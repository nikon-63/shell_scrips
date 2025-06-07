# Raspberry Pi Scripts

This README documents scripts intended for use on Raspberry Pi devices.  

---
## Script: `set_ip.sh`

### Description

This script configures a **static IPv4 address** for a specified **NetworkManager connection** using `nmcli`. It supports both Ethernet and Wi-Fi profiles and allows you to view available connections with a `-list` option.

### Requirements

* `bash`
* `nmcli` (part of `network-manager`)
* Must be run with `sudo`

### Usage

```bash
# List connections
sudo ./set_ip.sh -list

# Set static IP
sudo ./set_ip.sh [ethernet|wifi] <connection_name> <ip/cidr> <gateway> <dns>
```

#### Arguments

| Argument      | Description                                                              |                                                                          |
| ------------- | ------------------------------------------------------------------------ | ------------------------------------------------------------------------ |
| `-list`       | Lists all available NetworkManager connections and exits.                |                                                                          |
| `ethernet / wifi`                                                                   | Interface type; used for clarity (but only the connection name matters). |
| `<conn_name>` | Name of the NetworkManager connection profile (quoted if it has spaces). |                                                                          |
| `<ip/cidr>`   | Static IP with CIDR notation (e.g., `192.168.100.23/24`).                |                                                                          |
| `<gateway>`   | Gateway IP address (e.g., `192.168.100.1`).                              |                                                                          |
| `<dns>`       | Comma-separated list of DNS servers (e.g., `8.8.8.8,1.1.1.1`).           |                                                                          |

### Examples

```bash
# List available connections
sudo ./set_ip.sh -list

# Set static IP for Wi-Fi profile named "preconfigured"
sudo ./set_ip.sh wifi "preconfigured" 192.168.100.23/24 192.168.100.1 8.8.8.8,1.1.1.1

# Set static IP for Ethernet profile named "Wired connection 1"
sudo ./set_ip.sh ethernet "Wired connection 1" 192.168.100.50/24 192.168.100.1 1.1.1.1
```

### Notes

* The script only works with **NetworkManager**-managed connections.
* The connection name must exist; use `-list` to find it.
* DNS values should be comma-separated but will be correctly parsed as space-separated internally.
* Automatically restarts the selected connection to apply changes.

---

***Template for making mini readmes for new scripts***

## Script: `<script_name>.sh`

### Description
_A brief summary of what the script does._

### Requirements
- _List any required tools, packages, or dependencies (e.g., `bash`, `nmcli`, etc.)_

### Usage
```bash
# Example usage
./<script_name>.sh [arguments]
```

#### Arguments
| Argument | Description |
|----------|-------------|
| arg1     | _Description of arg1_ |
| arg2     | _Description of arg2_ |
| ...      | ...                   |

### Examples
```bash
# Example 1
./<script_name>.sh ...

# Example 2
./<script_name>.sh ...
```

### Notes
- _Any additional notes, caveats, or tips._

---
