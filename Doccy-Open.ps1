$DoccyRoot = $MyInvocation.MyCommand.Path | Split-Path -Parent # TODO: this might be fixable

$Config = (Get-Content "$DoccyRoot\Doccy-Open\doccyfile" -Raw) -replace '\\', '\\' | ConvertFrom-StringData
$SchoolPath = $Config['SchoolPath']
$Doccyfile = Get-Content "$SchoolPath\Doccy-Open.conf" -Raw
$DoccyPairs = ConvertFrom-StringData "$Doccyfile"

if (-not $args[0])
{
  Write-Output 'Please supply arguments.'
}
if ($args[0] -eq 'list')
{
  foreach ($pair in $DoccyPairs.GetEnumerator())
  {
    Write-Output $pair.Name
  }
}
elseif ($args[0] -eq 'help')
{
  Write-Output "Configure the root path in this file's path\doccy.conf, and configure arguments in the root path\doccyfile in the form arg = path/to/doc/appended/to/root/path.docx"
}
elseif ($args[0] -eq 'add')
{
  #Add-Content $SchoolPath\doccyfile 
}
else
{
  foreach ($arg in $args)
  {
    if ($DoccyPairs.ContainsKey($arg))
    {
      $str = "{0}\{1}" -f "$SchoolPath", $DoccyPairs[$arg]
      Start-Process $str
    }
    else
    {
      Write-Output "Unrecognized argument: $arg`n'doccy help' to see help`n'doccy list' for available arguments."
    }
  }
}
