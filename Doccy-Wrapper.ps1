# Main helper/installer/caller for the doccy helper
[CmdletBinding()]
param(
  [Parameter(HelpMessage='Whether to start the wrapper in install mode')]
  [switch]$Install=$False,

  [Parameter(HelpMessage='What to type to activate doccy after install')]
  [string]$ScriptName='doccy',

  [Parameter(HelpMessage='Installation directory of the script. If the value is not on path, use -AddToPath. DO NOT SET THIS AS THE REPO DIRECTORY!')]
  [string]$InstallDir,

  [Parameter(HelpMessage='Whether to add the install dir to path')]
  [switch]$AddTopath,

  [Parameter(HelpMessage='Whether to enable modules instead of executing commands')]
  [switch]$Enable=$False,


  # Ignore these
  [Parameter(HelpMessage='The root of your Doccy module repo. Normal users should not change this!!')]
  [string]$DoccyRoot,

  [Parameter(HelpMessage='The script to copy as the new doccy script. Normal users should not change this!!')]
  [string]$DoccyWrapper=$MyInvocation.MyCommand.path,

  # All the rest of the stuff passed in
  [Parameter(Position=0, ValueFromRemainingArguments)]
  $Cmds
)

# All the convoluted variable sets needed to run
Begin
{
  $ScriptDir = $MyInvocation.MyCommand.path | Split-Path -Parent
  $ConfigCheck = Convert-Path "$ScriptDir\doccyfile" -ErrorAction SilentlyContinue
  if($ConfigCheck -and $Install) # Running in install mode while presumptively already installed
  {
    Write-Output 'doccy: WARN: -Install: doccyfile found in current working directory. This is unsupported.'
  }
  elseif (-not $ConfigCheck -and -not $Install) # Running outside of install mode while not installed, never do this
  {
    Write-Output 'doccy: ERR: Doccyfile not found. Please make sure that the current script directory has a doccyfile and try again.'
    exit(1)
  }

  if ($Install -and -not $DoccyRoot) # Running in install mode and haven't set a custom doccy root, assume it's running from the repo
  {
    $DoccyRoot = $ScriptDir
  }

  if ($ConfigCheck) # If this script is configured like it's been installed
  {
    $Doccyfile = (Get-Content $ConfigCheck -Raw) -replace '\\', '\\' | ConvertFrom-StringData
    if ($Install) # Similar sanity checks to above
    {
      Write-Error 'Doccy-Install: ERR: Doccy is already installed. If you believe this to be in error, delete the doccyfile in this run directory.'
    }
    else
    {
      $DoccyRoot = $Doccyfile['DoccyRoot']
      $InstallDir = $Doccyfile['InstallDir']
      $EnabledModules = $Doccyfile['EnabledModules'].Split(' ')
      $PrefixlessModule = $Doccyfile['PrefixlessModule']

      if ($DoccyRoot -eq $ScriptDir) # Yet another redundant sanity check
      {
        Write-Error 'doccy: ERR: doccy was installed to the repo root. This is unsupported. Move this script and doccyfile to a directory on PATH.'
      }
    }
  }
  else
  {
    Write-Error 'doccy: ERR: Doccyfile not found. During install, this is normal.'
  }
}

Process
{
  function ConvertTo-StringData([string[]]$arr) # ['Open', 'Sgpt', 'Another'] -> 'Open Sgpt Another'
  {
    $str = "${arr[0]}"
    foreach ($e in $arr)
    {
      $str += " ${e}"
    }
    return $str
  }
  
  function Write-Doccyfile([string]$root, [string]$dir, [string]$enabled, [string]$prefixless)
  {
    Write-Output @"
# This is the main doccy configuration file for the wrapper.
# Configure your modules in their respective doccyfiles.
DoccyRoot = ${root}
InstallDir = ${dir}
EnabledModules = ${enabled}
PrefixlessModule = ${prefixless}
"@ | Out-File -FilePath "$(Convert-Path $InstallDir)\doccyfile"
  }

  if ($Install)
  {
    Write-Output "Doccy-Install: Installing doccy to $(Convert-Path $InstallDir)..."

    # Install the script
    Copy-Item $DoccyWrapper -Destination "$InstallDir\$ScriptName.ps1"

    # Install the default configuration
    $Enabled = @('Open')
    Write-Doccyfile (Convert-Path $DoccyRoot) (Convert-Path $InstallDir) (ConvertTo-StringData($Enabled)) 'Open'

    Write-Output "Doccy-Install: Installed. If -InstallDir was on PATH, you may call doccy. Otherwise, add it to your path.`nSee documentation for usage."
  }
  elseif ($Enable)
  {
    foreach ($module in $Cmds)
    {
      # Look for a corresponding script in the repo
      if (Get-Content "${DoccyRoot}\Doccy-$((Get-Culture).TextInfo.ToTitleCase($module)).ps1" -ErrorAction SilentlyContinue)
      {
        if ($module -in $EnabledModules) # No need to enable
        {
          Write-Output "Doccy-Enable: WARN: $module is already enabled." 
        }
        else
        {
          $EnabledModules += (Get-Culture).TextInfo.ToTitleCase($module)
          Write-Doccyfile $DoccyRoot $InstallDir (ConvertTo-StringData($EnabledModules)) $PrefixlessModule
        }
      }
      else # Wasn't found in the repo under that name
      {
        Write-Output "Doccy-Enable: WARN: Could not find module Doccy-$((Get-Culture).TextInfo.ToTitleCase($module)).ps1 in repo directory"
      }
    }
  }
  elseif ($ConfigCheck) # Just process the commands as usual
  {
    if ((Get-Culture).TextInfo.ToTitleCase($Cmds[0]) -in $EnabledModules)
    {
      # Send command to the module requested
      # 'doccy open con' will call '$DoccyRoot\Doccy-Open.ps1 con'
      Invoke-Expression "${DoccyRoot}\Doccy-$((Get-Culture).TextInfo.ToTitleCase($Cmds[0])).ps1 $(ConvertTo-StringData ($Cmds | Select-Object -Skip 1))"
    }
    else
    {
      # Send command to the prefixless module
      # 'doccy con' is '$DoccyRoot\Doccy-Open.ps1 con' if Open is prefixless
      Invoke-Expression "${DoccyRoot}\Doccy-$((Get-Culture).TextInfo.ToTitleCase($PrefixlessModule)).ps1 $(ConvertTo-StringData $Cmds)"
    }
  }
  else # Sanity check
  {
    Write-Error "doccy: ERR: Doccy has not been installed. Run with -Install and -InstallDir <directory> for full functionality."
    exit(1)
  }
}
