# Wrapper for sgpt --shell mode
# May be the default prefixless at some point
# May also be moved to Doccy-SgptShell and the search func be relegated to Doccy-Sgpt

if ($Args[0].StartsWith("`"")) # Pased in as "command"
{
  sgpt --shell $Args[0]
}
else
{
  $ArgString = "$Args"
  sgpt --shell $ArgString
}