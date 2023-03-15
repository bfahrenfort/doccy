# doccy

## A sophisticated, extensible helper-accessor framework for the busy academic.

- Problem: I don't like to take my hands off the keyboard, but I'm constantly opening documents and performing other small tasks that take a few seconds longer than necessary.
- Context: I have access to a shell at all times through the Windows Terminal Quake Mode.
- Solution: Write a foolishly generic, single-platform script that's essentially an alias aliaser, with very little going for it other than redundancy and triviality.

doccy allows you to access many different helper routines from the same script, complete with their own configuration files and pre-enable checks.

### Using doccy

Install with `Doccy-Wrapper.ps1 -Install -InstallDir <some directory on path>`. It'll create a wrapper script called `doccy.ps1` by default and a `doccyfile`.

To enable additional modules found in the repo, run `doccy -Enable <module name>`. It'll run any preinstall checks and add the module to your doccyfile. This shouldn't be added to the doccyfile manually, as you may inadverdently skip said preinstall checks.

To use a module, run `doccy <module name> [the arguments you pass to the module]`. If the module is set as the prefixless module, you can just run `doccy [arguments]`.

To set the prefixless module, change the module name of the key `PrefixlessModule` in your install's doccyfile. CLI change will be added in future.

### Modules available

#### Open

`Start-Process` files by small aliases without ever opening File Explorer. Specify a root document folder in the module's doccyfile (located in its folder in the repo), then create a configuration file (`Doccy-Open.conf`) in the document folder with `alias = relative/path/to/file.docx` or similar. Use with `doccy open alias`.

#### Sgpt

Chat to ChatGPT from the command line with [shell_gpt](https://github.com/TheR1D/shell_gpt). `doccy sgpt "what is a stack?"`

#### Cmd

Get ChatGPT to create shell commands for you with [shell_gpt](https://github.com/TheR1D/shell_gpt). `doccy cmd "write a PowerShell command to say 'Hi!'"`. Will run the command if confirmed with `y` on prompt or if passed `-NoConfirm`.

#### Clone

Clone a repo into a folder specified by a doccyfile (for me, I use `<user folder>\Repos`) and navigate to that directory. `doccy clone https://github.com/bfahrenfort/doccy` will clone into Repos\doccy and nagivate there.

### Extending doccy

To extend doccy, create a PowerShell script named `Doccy-<name>.ps1` in the repo's root which will be called with all following command line arguments when running `doccy <name> [args]`.

Handle these arguments however you like. doccy routines should be documented clearly.

If it serves a function that's useful to more people than just you, make it configurable with a doccyfile and submit a pull request.

#### Running pre-enable tasks

Create a PowerShell script named `Doccy-Enable<name>.ps1` in the repo's root. When enabling your module, this script will be run. Your script should return 0 if the module may be successfully enabled, or 1 if the module should not be enabled.

pre-enable tasks should not forcibly install any programs; they should only prompt the user for permission to do so. If admin permission is needed, inform the user and abort in anticipation of a run from an admin shell (no [gsudo](https://github.com/gerardog/gsudo) shenanigans).

#### Examples of multi-useful doccy routines

- A script that provides an alias to call a common program installed on the user's computer that's usually called with specific lengthy arguments in much less time.
- A script that lists some features of the user's computer.
- A good general principle to follow is to use environment variables rather than named paths, and to allow for configuration if you do something nonstandard.

#### Examples of non useful doccy routines

- A script that opens a game you play frequently.
- A script that navigates your specific folder structure on your computer and runs a task you perform frequently.
