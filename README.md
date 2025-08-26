# myprompt



Inspired by Chris Titus mybash tweaked to my liking.

## Installation
To install the .bashrc configuration, execute the following commands in your terminal:

```sh
git clone --depth=1 https://github.com/fredhawk/myprompt.git
cd myprompt
./setup.sh
```

The setup.sh script automates the installation process by:

- Creating necessary directories
- Cloning the repository
- Installing dependencies (bash-completion, neovim, starship, fzf, zoxide)
- Installing the MesloLGS Nerd Font required for the prompt
- Linking configuration files (.bashrc and starship.toml) to your home directory

Ensure you have the required permissions and a supported package manager before running the script.

## Uninstallation
To uninstall the .bashrc configuration, run:

```sh
cd myprompt
chmod +x uninstall.sh
./uninstall.sh
```

The uninstall.sh script reverses the installation process by:

- Removing installed dependencies
- Uninstalling fonts
- Removing symbolic links to configuration files
- Deleting the directory
- Cleaning up additional utilities like starship, fzf, and zoxide

After running the script, it's recommended to restart your shell to apply the changes.

