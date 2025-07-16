# Shell-VS

A simple Bash script to open Visual Studio Code projects using aliases. 

## Features

- **Install (`--install`)**: Sets up the script by creating the mapping file (`.vscode_projects.json`) and adding an autocomplete function to your `.zshrc`. During installation, you'll be prompted to specify the initial GitHub root directory where your project folders are located.
- **Uninstall (`--uninstall`)**: Removes the mapping file and the autocomplete function from `.zshrc`.
- **Sync (`--sync`)**: Scans the specified GitHub root directory and updates the mapping file with any new project folders.
- **Open Projects**: Quickly open a project in Visual Studio Code using its alias.

## Usage

1. **Install the script**:
   ```bash
   vs --install
   ```
   Follow the prompts to set up the mapping file and autocomplete.

2. **Uninstall the script**:
   ```bash
   vs --uninstall
   ```

3. **Sync projects**:
   ```bash
   vs --sync
   ```
   Updates the mapping file with new project folders from the GitHub root directory.

4. **Open a project**:
   ```bash
   vs <project_alias>
   ```
   Opens the project associated with the given alias in Visual Studio Code.

## Setup

1. Place the `vs` script in a directory included in your `PATH`.

2. Run `vs --install` to set up the script.

3. Run `vs --sync` to populate the mapping file with existing project folders.

4. Use `vs <project_alias>` to open projects by their aliases.

## Notes

- The mapping file (`.vscode_projects.json`) is stored in your home directory and contains project aliases, paths, and the GitHub root directory.
- You can manually edit the mapping file to add additional GitHub root directories or project aliases.
- Make sure you have `jq` installed for JSON manipulation.

