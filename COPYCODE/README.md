
# COPYCODE

`copyCode` is a Bash script to collect and concatenate the contents of all source files in a directory (recursively), respecting `.gitignore` rules, and output them to a single file. This is useful for sharing, archiving, or reviewing all code in a project while skipping ignored files and build artifacts.

## Features

- Recursively collects all files tracked by Git or untracked but not ignored (respects `.gitignore`).
- Outputs each file's name, path, and contents, separated by a divider.
- Skips the output file itself if it would be included.
- Works from any subdirectory inside a Git repo.

## Requirements

- Bash
- Git
- Python 3 (for path handling)

## Usage

```sh
copyCode <source_dir> <output_file>
```

- `<source_dir>`: Directory to scan for code files (must be inside a Git repo)
- `<output_file>`: File to write the concatenated output to

### Example

```sh
copyCode . out.txt
```

This will write all code files (not ignored by Git) in the current directory and subdirectories to `out.txt`.

## Output Format

For each file:

```
File Name: <filename>
File Path: <absolute_path>
<file contents>
------------------------------------------
```

## Notes

- Only files not ignored by `.gitignore` are included.
- The script must be run inside a Git repository.
- The output file is skipped if it would be included in the results.
