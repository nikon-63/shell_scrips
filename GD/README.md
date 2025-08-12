# gd (GitHub Desktop opener)

Open the current Git repository in GitHub Desktop from the terminal.

## Requirements
- macOS
- GitHub Desktop installed
- Directory must be a Git repository (contains a `.git` folder)

## Installation
1. Make the script executable
2. Place it in a directory that is in your PATH, or add the script's directory to your PATH.

## Usage
From any Git repository directory:
```sh
gd
```

Expected output:
```
Opened <repo-name> in GitHub Desktop
```

If not in a Git repo:
```
Not a git repository: <path>
```

If GitHub Desktop cannot be opened:
```
Could not open GitHub Desktop.
```

## Notes
- Works by calling: `open -a "GitHub Desktop" "$PWD"`.
- Make sure the script is in the PATH.