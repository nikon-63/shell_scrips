# RADIUS Test Script

A simple Bash script to test RADIUS authentication against a RADIUS server.

## Prerequisites

* **FreeRADIUS client tools**

  ```sh
  brew install freeradius-client
  ```
* **wpa\_supplicant** 

  ```sh
  brew install wpa_supplicant
  ```

## Usage

```sh
./connection_test.sh \
  -h <HOST> \
  -p <PORT> \
  -s <SECRET> \
  -u <USER> \
  -P <PASS> \
  [-m <METHOD>]
```

* `-h HOST` — RADIUS server address (default: `127.0.0.1`)
* `-p PORT` — RADIUS auth port (default: `1812`)
* `-s SECRET` — Shared secret with RADIUS server **(required)**
* `-u USER` — Username to authenticate **(required)**
* `-P PASS` — Password for the user (prompts if omitted)
* `-m METHOD` — `mschap` (default) or `peap` (Unifi uses 'mschap')

