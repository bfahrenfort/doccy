# Wrapper for sgpt without --shell
# May be the default prefixless at some point
# for --shell, Doccy-Cmd.ps1

if ($Args[0].StartsWith("`"")) # Pased in as "command"
{
  sgpt $Args[0]
}
else
{
  $ArgString = "$Args"
  sgpt $ArgString
}