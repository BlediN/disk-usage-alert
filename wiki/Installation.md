# Installation Guide

This guide will walk you through installing Disk Usage Alert on your Ubuntu server.

## Prerequisites

Before installing, ensure you have:

- Ubuntu 18.04 LTS or later
- Root or sudo access
- Internet connection (for downloading dependencies if needed)

## Installation Methods

### Method 1: Manual Installation

#### Step 1: Download the Script

```bash
# Clone the repository
git clone https://github.com/BlediN/disk-usage-alert.git
cd disk-usage-alert
```

#### Step 2: Make the Script Executable

```bash
# If there's a main script file
chmod +x disk-usage-alert.sh
```

#### Step 3: Copy to System Path (Optional)

For system-wide access:

```bash
sudo cp disk-usage-alert.sh /usr/local/bin/disk-usage-alert
```

### Method 2: Quick Install (One-liner)

```bash
curl -sSL https://raw.githubusercontent.com/BlediN/disk-usage-alert/main/install.sh | sudo bash
```

**Note**: Always review scripts before running them with sudo privileges.

## Post-Installation

### Verify Installation

Check that the script is accessible:

```bash
disk-usage-alert --version
# or
./disk-usage-alert.sh --version
```

### Configure Monitoring

1. Edit the configuration file:
   ```bash
   sudo nano /etc/disk-usage-alert.conf
   ```

2. Set your preferences (see [Configuration](Configuration.md) for details)

3. Test the configuration:
   ```bash
   disk-usage-alert --test
   ```

## Setting Up Automated Monitoring

### Using Cron

To run checks automatically, add a cron job:

```bash
# Edit crontab
sudo crontab -e

# Add one of the following lines:

# Run every hour
0 * * * * /usr/local/bin/disk-usage-alert

# Run every 6 hours
0 */6 * * * /usr/local/bin/disk-usage-alert

# Run daily at 2 AM
0 2 * * * /usr/local/bin/disk-usage-alert
```

### Using Systemd Timer (Alternative)

Create a systemd service:

```bash
sudo nano /etc/systemd/system/disk-usage-alert.service
```

Add the following content:

```ini
[Unit]
Description=Disk Usage Alert Service
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/disk-usage-alert
User=root
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

Create a timer:

```bash
sudo nano /etc/systemd/system/disk-usage-alert.timer
```

Add the following content:

```ini
[Unit]
Description=Disk Usage Alert Timer
Requires=disk-usage-alert.service

[Timer]
OnBootSec=5min
OnUnitActiveSec=1h
Unit=disk-usage-alert.service

[Install]
WantedBy=timers.target
```

Enable and start the timer:

```bash
sudo systemctl daemon-reload
sudo systemctl enable disk-usage-alert.timer
sudo systemctl start disk-usage-alert.timer
```

Check timer status:

```bash
sudo systemctl status disk-usage-alert.timer
```

## Updating

To update to the latest version:

```bash
cd disk-usage-alert
git pull origin main
sudo cp disk-usage-alert.sh /usr/local/bin/disk-usage-alert
```

## Uninstallation

To remove Disk Usage Alert:

```bash
# Remove the script
sudo rm /usr/local/bin/disk-usage-alert

# Remove configuration
sudo rm /etc/disk-usage-alert.conf

# Remove cron jobs
sudo crontab -e
# (manually remove the disk-usage-alert line)

# Or remove systemd timer
sudo systemctl stop disk-usage-alert.timer
sudo systemctl disable disk-usage-alert.timer
sudo rm /etc/systemd/system/disk-usage-alert.service
sudo rm /etc/systemd/system/disk-usage-alert.timer
sudo systemctl daemon-reload
```

## Next Steps

- [Configure](Configuration.md) your alert thresholds
- Learn about [Usage](Usage.md) options
- Check [Troubleshooting](Troubleshooting.md) if you encounter issues
