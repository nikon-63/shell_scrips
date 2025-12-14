# shell_scrips

A collection of Bash scripts and utilities for network, system, and developer productivity tasks on macOS and Linux. Each folder contains a script or tool with its own README and usage instructions.

## Contents

| Folder         | Script/Tool         | Description |
|----------------|--------------------|-------------|
| CONNECT_CONSOLE| `connect_console`  | Quickly connect to Cisco/network devices via serial console on macOS. Auto-detects USB serial adapters and supports `screen`/`picocom`. |
| GD             | `gd`               | Opens the current Git repository in GitHub Desktop from the terminal. |
| IMAGE_JOIN     | `image_join`       | Joins two images (side-by-side or stacked) using ImageMagick. Output is saved as PNG. |
| NetCheck       | `netcheck_log.sh`, `netcheck_report.sh` | Logs and reports DNS/HTTP(S) checks for a list of targets. Useful for uptime and connectivity monitoring. |
| Radius         | `connection_test.sh`, `connection_report.sh` | Test RADIUS authentication against a server. Useful for network admins. |
| RPI            | `set_ip.sh`        | Configure static IP addresses for Raspberry Pi using NetworkManager (`nmcli`). |
| Shell-VS       | `vs`               | Manage and open VS Code projects using aliases and autocomplete. |
| SSS            | `sss`              | Manage and connect to SSH servers using aliases and interactive selection. |
| WEB-GIT        | `web-git`          | Open GitHub repos in your browser using project aliases. Reads URLs from `.git/config`. |
| COPYCODE       | `copyCode`         | Concatenate all code files in a directory (respects .gitignore) into a single file for sharing or review. |

---

## Quick Start

Each tool has its own README in its folder. Most scripts are Bash and require minimal dependencies. See below for a summary of each tool:

### CONNECT_CONSOLE
- Connect to Cisco/network devices via serial console on macOS.
- Usage: `./connect_console [baud] [tool]`
- Requires: `screen` or `picocom`.

### GD
- Open the current Git repo in GitHub Desktop.
- Usage: `gd`

### IMAGE_JOIN
- Join two images horizontally or vertically, matching size as needed.
- Usage: `image_join -h <img1> <img2>` or `image_join -v <img1> <img2>`
- Requires: ImageMagick

### NetCheck
- `netcheck_log.sh`: Logs DNS/HTTP(S) checks to a file.
- `netcheck_report.sh`: Summarizes and highlights failures.
- Usage: `./netcheck_log.sh` and `./netcheck_report.sh`

### Radius
- Test RADIUS authentication with `connection_test.sh`.
- Usage: `./connection_test.sh -h <HOST> -p <PORT> -s <SECRET> -u <USER> -P <PASS>`
- Requires: FreeRADIUS client tools, wpa_supplicant

### RPI
- Set static IP for a NetworkManager connection on Raspberry Pi.
- Usage: `sudo ./set_ip.sh -list` or `sudo ./set_ip.sh [ethernet|wifi] <conn> <ip/cidr> <gateway> <dns>`

### Shell-VS
- Manage and open VS Code projects by alias.
- Usage: `vs --install`, `vs <project_alias>`


### SSS
- Manage SSH server aliases and connect interactively.
- Usage: `sss --install`, `sss --add`, `sss <alias>`

### COPYCODE
- Concatenate all code files in a directory (respects .gitignore) into a single file.
- Usage: `copyCode <source_dir> <output_file>`
- Example: `copyCode . out.txt`

### WEB-GIT
- Open GitHub repos in your browser using aliases.
- Usage: `web-git --install`, `web-git <project_alias>`

---