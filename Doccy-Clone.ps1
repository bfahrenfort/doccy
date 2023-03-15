$ScriptPath = $MyInvocation.MyCommand.Path
$Doccyfile = "$(Split-Path -Parent $ScriptPath)\$((Get-Item $ScriptPath).BaseName)\doccyfile"
$RepoDir = ((Get-Content $DoccyFile -Raw) -replace '\\', '\\' | ConvertFrom-StringData)['RepoDir']

$CloneDir = "${RepoDir}\$(Split-Path $Args[0] -Leaf)"
git clone $Args[0] $CloneDir && Set-Location $CloneDir
