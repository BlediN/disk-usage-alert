# Configuration Guide

This guide explains all configuration options available for Disk Usage Alert.

## Configuration File Location

The default configuration file is located at:

```
/etc/disk-usage-alert.conf
```

You can also use a custom location with the `--config` flag:

```bash
disk-usage-alert --config /path/to/custom.conf
```

## Configuration File Format

The configuration file uses a simple KEY=VALUE format:

```bash
# This is a comment
OPTION_NAME=value
```

## Basic Configuration

### Threshold Settings

```bash
# Warning threshold (percentage)
WARNING_THRESHOLD=80

# Critical threshold (percentage)
CRITICAL_THRESHOLD=90
```

**Example**:
- At 80% usage: Warning alert sent
- At 90% usage: Critical alert sent

### Check Intervals

```bash
# How often to check (when using systemd timer)
# Values: hourly, daily, weekly
CHECK_INTERVAL=hourly
```

## Alert Configuration

### Email Notifications

```bash
# Enable email alerts
ENABLE_EMAIL=true

# Email settings
EMAIL_TO="admin@example.com,ops@example.com"
EMAIL_FROM="disk-alert@server.local"
EMAIL_SUBJECT_PREFIX="[Disk Alert]"

# SMTP settings (if not using local mail)
SMTP_HOST="smtp.example.com"
SMTP_PORT=587
SMTP_USER="alerts@example.com"
SMTP_PASSWORD="your-password"
SMTP_TLS=true
```

**Multiple Recipients**: Separate email addresses with commas.

### Slack Integration

```bash
# Enable Slack notifications
ENABLE_SLACK=true

# Slack webhook URL
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/YOUR/WEBHOOK/URL"

# Slack channel (optional, webhook default will be used if not set)
SLACK_CHANNEL="#alerts"

# Bot name
SLACK_BOT_NAME="Disk Alert Bot"
```

### Discord Integration

```bash
# Enable Discord notifications
ENABLE_DISCORD=true

# Discord webhook URL
DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/YOUR/WEBHOOK/URL"
```

### Telegram Integration

```bash
# Enable Telegram notifications
ENABLE_TELEGRAM=true

# Telegram bot token
TELEGRAM_BOT_TOKEN="your-bot-token"

# Telegram chat ID
TELEGRAM_CHAT_ID="your-chat-id"
```

### Custom Alert Script

```bash
# Run custom script on alert
CUSTOM_ALERT_SCRIPT="/usr/local/bin/custom-alert.sh"

# Pass disk info as arguments
# $1 = mount point
# $2 = usage percentage
# $3 = alert level (warning/critical)
```

## Monitoring Configuration

### Filesystems to Monitor

```bash
# Monitor all mounted filesystems (default)
MONITOR_ALL=true

# Or specify specific mount points
MONITOR_PATHS="/,/home,/var"

# Exclude certain filesystems
EXCLUDE_PATHS="/dev,/sys,/proc,/run,/tmp"

# Exclude filesystem types
EXCLUDE_TYPES="tmpfs,devtmpfs,squashfs"
```

### Size Filters

```bash
# Ignore filesystems smaller than this (in GB)
MIN_FILESYSTEM_SIZE=1

# Only check filesystems of certain types
INCLUDE_TYPES="ext4,xfs,btrfs"
```

## Advanced Options

### Logging

```bash
# Enable logging
ENABLE_LOGGING=true

# Log file location
LOG_FILE="/var/log/disk-usage-alert.log"

# Log level: DEBUG, INFO, WARNING, ERROR
LOG_LEVEL="INFO"

# Keep logs for this many days
LOG_RETENTION_DAYS=30
```

### Alert Throttling

Prevent alert spam:

```bash
# Don't send another alert for same filesystem within this time (minutes)
ALERT_COOLDOWN=60

# Store cooldown state
COOLDOWN_STATE_FILE="/var/lib/disk-usage-alert/cooldown.state"
```

### Hostname Configuration

```bash
# Custom hostname in alerts (default: system hostname)
HOSTNAME="web-server-01"

# Include FQDN in alerts
USE_FQDN=true
```

### Performance Options

```bash
# Timeout for disk checks (seconds)
CHECK_TIMEOUT=30

# Parallel checking for multiple filesystems
PARALLEL_CHECKS=true
```

## Example Configurations

### Minimal Configuration

Basic setup with email alerts:

```bash
WARNING_THRESHOLD=80
CRITICAL_THRESHOLD=90
ENABLE_EMAIL=true
EMAIL_TO="admin@example.com"
```

### Production Server Configuration

Comprehensive monitoring with multiple alert channels:

```bash
# Thresholds
WARNING_THRESHOLD=75
CRITICAL_THRESHOLD=85

# Email alerts
ENABLE_EMAIL=true
EMAIL_TO="ops-team@company.com"
EMAIL_FROM="disk-alerts@server.company.com"
SMTP_HOST="smtp.company.com"
SMTP_PORT=587
SMTP_USER="alerts"
SMTP_PASSWORD="secret"
SMTP_TLS=true

# Slack alerts
ENABLE_SLACK=true
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/XXX/YYY/ZZZ"
SLACK_CHANNEL="#infrastructure-alerts"

# Monitoring
MONITOR_ALL=true
EXCLUDE_TYPES="tmpfs,devtmpfs"
MIN_FILESYSTEM_SIZE=5

# Logging
ENABLE_LOGGING=true
LOG_FILE="/var/log/disk-usage-alert.log"
LOG_LEVEL="INFO"

# Alert throttling
ALERT_COOLDOWN=120
```

### Development Server Configuration

Relaxed thresholds with minimal alerts:

```bash
WARNING_THRESHOLD=85
CRITICAL_THRESHOLD=95
ENABLE_EMAIL=true
EMAIL_TO="dev-team@company.com"
CHECK_INTERVAL=daily
ALERT_COOLDOWN=240
```

### Database Server Configuration

Strict monitoring for database volumes:

```bash
WARNING_THRESHOLD=70
CRITICAL_THRESHOLD=80

# Monitor specific database volumes
MONITOR_ALL=false
MONITOR_PATHS="/,/var/lib/mysql,/var/lib/postgresql"

# Multiple alert channels
ENABLE_EMAIL=true
EMAIL_TO="dba-team@company.com,ops-team@company.com"
ENABLE_SLACK=true
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/XXX/YYY/ZZZ"
SLACK_CHANNEL="#database-alerts"

# Strict cooldown
ALERT_COOLDOWN=30
```

## Configuration Validation

Test your configuration:

```bash
# Validate configuration file
disk-usage-alert --test --config /etc/disk-usage-alert.conf

# Check configuration syntax
bash -n /etc/disk-usage-alert.conf
```

## Environment Variables

You can also set configuration via environment variables (overrides config file):

```bash
export DUA_WARNING_THRESHOLD=85
export DUA_CRITICAL_THRESHOLD=95
export DUA_EMAIL_TO="admin@example.com"

disk-usage-alert
```

## Security Considerations

### File Permissions

Secure your configuration file, especially if it contains passwords:

```bash
sudo chmod 600 /etc/disk-usage-alert.conf
sudo chown root:root /etc/disk-usage-alert.conf
```

### Credential Management

Instead of storing passwords in the config file, use:

1. **Environment variables**:
   ```bash
   export SMTP_PASSWORD=$(cat /root/.smtp-password)
   ```

2. **Password files**:
   ```bash
   SMTP_PASSWORD_FILE="/root/.smtp-password"
   ```

3. **Integration with secret management**:
   ```bash
   SMTP_PASSWORD=$(vault read -field=password secret/smtp)
   ```

## Troubleshooting Configuration

### Check Current Configuration

```bash
disk-usage-alert --show-config
```

### Test Specific Alert Channel

```bash
# Test email
disk-usage-alert --test-email

# Test Slack
disk-usage-alert --test-slack

# Test all configured alerts
disk-usage-alert --test-alerts
```

### Common Issues

1. **Alerts not sending**: Check credentials and network connectivity
2. **Wrong thresholds**: Verify percentage values (0-100)
3. **Excluded paths still monitored**: Check exclude syntax
4. **Multiple alerts**: Adjust ALERT_COOLDOWN value

## Next Steps

- Review [Usage](Usage.md) for running the tool
- Check [Troubleshooting](Troubleshooting.md) for common issues
- See [Installation](Installation.md) for setup instructions
