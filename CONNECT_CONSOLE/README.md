# Connect Console

A small macOS helper script to connect to a Cisco switch (or other network device) via a serial console cable.

## Purpose
- Quickly find and open a serial console on macOS (uses /dev/cu.usb* or /dev/tty.usb*).
- Supports screen (default) and picocom.

## Prerequisites
- macOS
- screen or picocom installed (brew install screen | picocom)
- A USB-to-serial console adapter plugged in

## Usage
- Run: ./connect_console [baud] [tool]
  - baud: serial speed (default: 9600)
  - tool: screen or picocom (default: screen)
- Example: ./connect_console 9600 picocom

## Notes
- The script will list multiple devices and let you pick one.
- If a process holds the device, you'll be offered a chance to kill it.
- Prefer /dev/cu.* on macOS for outbound serial connections.
- Quit using your tool's exit keys (e.g., screen: Ctrl-A k, picocom: Ctrl-A Ctrl-X).

## Troubleshooting
- No devices found: unplug/replug the adapter and run ls -ltr /dev/*usb*

