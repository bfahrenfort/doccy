# doccy
## A sophisticated, extensible helper-accessor framework for the busy academic.
### Problem: I don't like to take my hands off the keyboard, but I'm constantly opening documents and performing other small tasks that take a few seconds longer than necessary.
* Context: I have access to a shell at all times through the Windows Terminal Quake Mode.
* Solution: Write a foolishly generic script that's essentially an alias aliaser.

doccy allows you to access many different helper routines from the same script, complete with their own configuration files and pre-enable checks.

### Using doccy
Install with `Doccy-Wrapper.ps1 -Install -InstallDir <some directory on path>`. It'll create a wrapper script called `doccy.ps1` by default and a `doccyfile`.

To enable additional modules found in the repo, run `doccy -Enable <module name>`. It'll run any preinstall checks and add the module to your doccyfile. This shouldn't be added to the doccyfile manually, as you may inadverdently skip said preinstall checks.

To use a module, run `doccy <module name> [the arguments you pass to the module]`. If the module is set as the prefixless module, you can just run `doccy [arguments]`. 

To set the prefixless module, change the module name of the key `PrefixlessModule` in your install's doccyfile. CLI change will be added in future.

### Modules available
#### Open
Open documents by small aliases without ever opening File Explorer. Specify a root document folder in the module's doccyfile (located in its folder in the repo), then create a configuration file (`Doccy-Open.conf`) in the document folder with `alias = relative/path/to/file.docx` or similar. Use with `doccy open alias`.
#### Sgpt
Run ChatGPT from the command line with [shell_gpt](https://github.com/TheR1D/shell_gpt). `doccy sgpt "what is a stack?"`
#### Cmd
Get ChatGPT to create shell commands for you with [shell_gpt](https://github.com/TheR1D/shell_gpt). `doccy cmd "write a PowerShell command to say 'Hi!'"`


### Extending doccy
To extend doccy, create a PowerShell script named `Doccy-<name>.ps1` in the repo's root. If it serves a function that's useful to more people than just you, make it configurable with a doccyfile and submit a pull request.

#### Running pre-enable tasks
Create a PowerShell script named `Doccy-Enable<name>.ps1` in the repo's root. When enabling your module, this script will be run. Your script should return 0 if the module may be successfully enabled, or 1 if the module should not be enabled.

#### Examples of multi-useful doccy routines
* A script that provides an alias for a common program installed on the user's computer called with specific lengthy arguments in much less time.
* A script that lists some features of the user's computer.
#### Examples of non useful doccy routines
* A script that opens a game you play frequently.
* A script that navigates your specific folder structure on your computer and runs a task you perform frequently.