$ScriptPath = $MyInvocation.MyCommand.Path
$Doccyfile = "$(Split-Path -Parent $ScriptPath)\$((Get-Item $ScriptPath).BaseName)\doccyfile"

if (Test-Path $Doccyfile)
{
  $Services = Get-Content $Doccyfile
  foreach ($s in $Services)
  {
    sudo Start-Service $s
    Write-Output "Started service ${s}"
  }
}
else
{
  Write-Output "WARN: Doccy-Services: doccyfile not found. Create ${Doccyfile} with a service name on each line and try again."
}
