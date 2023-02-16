$DoccyRoot = $MyInvocation.MyCommand.Path | Split-Path -Parent # TODO: this might be fixable

$Config = (Get-Content "$DoccyRoot\Doccy-Open\doccyfile" -Raw) -replace '\\', '\\' | ConvertFrom-StringData

# The path to the document folder you wish to search
$DocumentPath = $Config['DocumentPath']

# In that folder, create a Doccy-Open.conf with lines in the format:
# alias = relative/path/to/file.txt
# And calling `doccy open alias` will open $DocumentPath\relative/path/to/file.txt
# Because Start-Process uses the registry default program, this will work with any file format
# I like to use it with .docx
$Doccyfile = Get-Content "$DocumentPath\Doccy-Open.conf" -Raw
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
  #Add-Content $DocumentPath\doccyfile 
}
else
{
  foreach ($arg in $args)
  {
    if ($DoccyPairs.ContainsKey($arg))
    {
      $str = "{0}\{1}" -f "$DocumentPath", $DoccyPairs[$arg]
      Start-Process $str
    }
    else
    {
      Write-Output "Unrecognized argument: $arg`n'doccy help' to see help`n'doccy list' for available arguments."
    }
  }
}
