# SSS - Secure SSH Simple

A simple Bash script to manage and connect to SSH servers using aliases.

## Features

- **Install (`--install`)**: Sets up the script by creating the mapping file (`.sss_mapping.json`) and adding an autocomplete function to your `.zshrc`.
- **Uninstall (`--uninstall`)**: Removes the mapping file and the autocomplete function from `.zshrc`.
- **Add (`--add`)**: Adds a new SSH alias and its corresponding address to the mapping file.
- **Remove (`--remove`)**: Removes an existing SSH alias from the mapping file.
- **List (`--list`)**: Lists all SSH aliases and their corresponding addresses.
- **Direct Connection**: Connect to an SSH server directly by using its alias.
- **Interactive Mode**: Run the script without arguments to list all aliases with numbers and select one to connect.

## Usage

1. **Install the script**:
   ```bash
   sss --install
   ```
   Sets up the mapping file and autocomplete functionality.

2. **Uninstall the script**:
   ```bash
   sss --uninstall
   ```
   Removes the mapping file and autocomplete functionality.

3. **Add a new SSH alias**:
   ```bash
   sss --add
   ```
   Follow the prompts to add a new alias and its corresponding SSH address.

4. **Remove an SSH alias**:
   ```bash
   sss --remove
   ```
   Follow the prompts to remove an alias.

5. **List all SSH aliases**:
   ```bash
   sss --list
   ```
   Displays all aliases and their corresponding SSH addresses.

6. **Connect directly using an alias**:
   ```bash
   sss <alias>
   ```
   Connects to the SSH server associated with the given alias.

7. **Interactive mode**:
   ```bash
   sss
   ```
   Lists all aliases with numbers and allows you to select one to connect.

## Setup

1. Place the `sss` script in a directory included in your `PATH`.

2. Run `sss --install` to set up the script.

3. Use `sss --add` to add SSH aliases.

4. Use `sss <alias>` to connect to SSH servers by their aliases.

## Notes

- The mapping file (`.sss_mapping.json`) is stored in your home directory and contains SSH aliases and their corresponding addresses.
- You can manually edit the mapping file to add or modify aliases.
- Make sure you have `jq` installed for JSON manipulation.
