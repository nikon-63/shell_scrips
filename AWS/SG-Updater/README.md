# SG-Updater

This script updates an AWS Security Group (SG) inbound rules to allow traffic from your current public IP address.

## Features

- **Automatic IP Detection**: Uses `checkip.amazonaws.com` to find your current public IP.
- **Stateful Updates**: Stores the last-known IP to avoid unnecessary AWS API calls.
- **Managed Rules**: Marks rules with `(managed)` and automatically cleans up old rules it created.
- **Cron Integration**: Easily install or uninstall a cron job that runs every minute.

## Installation & Setup

1. **Install Dependencies**:
   - `aws-cli` (configured or with credentials in `.env`)
   - `curl`
   - `crontab`

2. **Configuration**:
   Copy `.env.example` to `.env` and fill in your details:
   ```bash
   cp .env.example .env
   ```
   Edit `.env`:
   - `AWS_REGION`: Your AWS region (e.g., `eu-west-2`).
   - `SECURITY_GROUP_ID`: The ID of the security group to update.
   - `STATE_FILE`: Path to a file where the current IP will be stored (e.g., `/tmp/sg_ip.txt`).
   - `AWS_ACCESS_KEY_ID` & `AWS_SECRET_ACCESS_KEY`: Your AWS credentials.

3. **Usage**:
   - **Run Once**: `./sg-ip-updater.sh`
   - **Install Cron**: `./sg-ip-updater.sh --install` (runs every minute by default)
   - **Uninstall Cron**: `./sg-ip-updater.sh --uninstall`
