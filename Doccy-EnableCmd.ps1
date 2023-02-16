# Ensure that shell-gpt is installed before attempting to enable the module

if (pip show shell-gpt)
{
  Write-Output 'Doccy-EnableCmd: shell_gpt found.'
  return 0
}
else
{
  $Confirmation = Read-Host "Doccy-EnableCmd: shell_gpt not found. Should doccy install it?`n[y/N]"
  if ($Confirmation -eq 'y')
  {
    if (pip install shell-gpt)
    {
      return 0
    }
  }
}
return 1