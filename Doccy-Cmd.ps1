# Wrapper for sgpt sgpt --shell
# for no --shell, Doccy-Sgpt.ps1

param(
  [Alias('nc')]
  [Parameter(HelpMessage='Whether to execute the produced command without confirmation')]
  [switch]$NoConfirm = $False,

  [Parameter(Position=0, ValueFromRemainingArguments)]
  $Cmds
)

if ($Cmds[0].StartsWith("`"")) # Pased in as "command"
{
  sgpt --shell $Cmds[0]
}
else
{
  $CmdString = "$Cmds"
  $Result = (sgpt --shell $CmdString)[1]
  
  $Confirmation = Read-Host ("`e[4m${Result}`e[0m: [y/N]")
  if ($Confirmation -eq 'y' -or $NoConfirm) # Case insensitive
  {
    Invoke-Expression "$Result"
  }
}