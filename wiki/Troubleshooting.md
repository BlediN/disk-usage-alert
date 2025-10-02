# Troubleshooting Guide

This guide helps you resolve common issues with Disk Usage Alert.

## Common Issues

### Installation Issues

#### Issue: Permission Denied

**Error**:
```
bash: ./disk-usage-alert.sh: Permission denied
```

**Solution**:
```bash
chmod +x disk-usage-alert.sh
```

#### Issue: Command Not Found

**Error**:
```
disk-usage-alert: command not found
```

**Solutions**:
1. Use full path:
   ```bash
   /usr/local/bin/disk-usage-alert
   ```

2. Check installation:
   ```bash
   which disk-usage-alert
   ls -l /usr/local/bin/disk-usage-alert
   ```

3. Reinstall:
   ```bash
   sudo cp disk-usage-alert.sh /usr/local/bin/disk-usage-alert
   sudo chmod +x /usr/local/bin/disk-usage-alert
   ```

### Configuration Issues

#### Issue: Configuration File Not Found

**Error**:
```
Error: Configuration file not found: /etc/disk-usage-alert.conf
```

**Solution**:
```bash
# Create default configuration
sudo touch /etc/disk-usage-alert.conf

# Or specify custom location
disk-usage-alert --config /path/to/custom.conf
```

#### Issue: Invalid Configuration Syntax

**Error**:
```
Error: Invalid configuration format
```

**Solution**:
```bash
# Check syntax
bash -n /etc/disk-usage-alert.conf

# Verify KEY=VALUE format (no spaces around =)
# Correct:   THRESHOLD=80
# Incorrect: THRESHOLD = 80
```

#### Issue: Threshold Not Working

**Problem**: Alerts trigger at wrong percentages

**Solution**:
1. Verify threshold values:
   ```bash
   grep THRESHOLD /etc/disk-usage-alert.conf
   ```

2. Ensure values are 0-100:
   ```bash
   WARNING_THRESHOLD=80
   CRITICAL_THRESHOLD=90
   ```

3. Test configuration:
   ```bash
   disk-usage-alert --test
   ```

### Alert Issues

#### Issue: Email Alerts Not Sending

**Symptoms**: No emails received

**Troubleshooting Steps**:

1. **Check email configuration**:
   ```bash
   grep EMAIL /etc/disk-usage-alert.conf
   ```

2. **Verify mail command exists**:
   ```bash
   which mail
   # If not found, install mailutils
   sudo apt-get install mailutils
   ```

3. **Test SMTP connection**:
   ```bash
   telnet smtp.example.com 587
   ```

4. **Check logs**:
   ```bash
   tail -f /var/log/mail.log
   tail -f /var/log/disk-usage-alert.log
   ```

5. **Test email manually**:
   ```bash
   echo "Test" | mail -s "Test" your@email.com
   ```

#### Issue: Slack Notifications Not Working

**Symptoms**: No Slack messages appear

**Solutions**:

1. **Verify webhook URL**:
   ```bash
   # Test webhook with curl
   curl -X POST -H 'Content-type: application/json' \
     --data '{"text":"Test message"}' \
     YOUR_WEBHOOK_URL
   ```

2. **Check webhook format**:
   - Should start with `https://hooks.slack.com/services/`
   - No extra spaces or quotes

3. **Verify Slack channel**:
   - Channel must exist
   - Bot must have access to channel

4. **Check firewall**:
   ```bash
   # Ensure outbound HTTPS is allowed
   curl -I https://slack.com
   ```

#### Issue: Too Many Alerts (Alert Spam)

**Problem**: Receiving alerts every few minutes

**Solution**:
```bash
# Increase alert cooldown in config
ALERT_COOLDOWN=120  # 2 hours

# Or adjust thresholds
WARNING_THRESHOLD=85
CRITICAL_THRESHOLD=95
```

#### Issue: No Alerts Despite High Disk Usage

**Troubleshooting**:

1. **Check disk usage manually**:
   ```bash
   df -h
   ```

2. **Run in debug mode**:
   ```bash
   disk-usage-alert --debug
   ```

3. **Verify alert methods are enabled**:
   ```bash
   grep ENABLE_ /etc/disk-usage-alert.conf
   ```

4. **Check alert cooldown state**:
   ```bash
   cat /var/lib/disk-usage-alert/cooldown.state
   # Remove if needed
   sudo rm /var/lib/disk-usage-alert/cooldown.state
   ```

### Cron/Scheduled Task Issues

#### Issue: Cron Job Not Running

**Troubleshooting**:

1. **Verify cron job exists**:
   ```bash
   sudo crontab -l | grep disk-usage-alert
   ```

2. **Check cron syntax**:
   ```bash
   # Correct format:
   # minute hour day month weekday command
   0 * * * * /usr/local/bin/disk-usage-alert
   ```

3. **Check cron logs**:
   ```bash
   grep CRON /var/log/syslog
   grep disk-usage-alert /var/log/syslog
   ```

4. **Verify cron service is running**:
   ```bash
   sudo systemctl status cron
   ```

5. **Test script manually with cron environment**:
   ```bash
   sudo su -
   /usr/local/bin/disk-usage-alert
   ```

#### Issue: Systemd Timer Not Working

**Troubleshooting**:

1. **Check timer status**:
   ```bash
   sudo systemctl status disk-usage-alert.timer
   ```

2. **List timers**:
   ```bash
   sudo systemctl list-timers | grep disk-usage-alert
   ```

3. **Check service logs**:
   ```bash
   sudo journalctl -u disk-usage-alert.service -n 50
   ```

4. **Verify timer is enabled**:
   ```bash
   sudo systemctl is-enabled disk-usage-alert.timer
   ```

5. **Reload systemd**:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl restart disk-usage-alert.timer
   ```

### Performance Issues

#### Issue: Script Takes Too Long to Run

**Symptoms**: Timeouts or slow execution

**Solutions**:

1. **Enable parallel checking**:
   ```bash
   PARALLEL_CHECKS=true
   ```

2. **Exclude unnecessary filesystems**:
   ```bash
   EXCLUDE_TYPES="tmpfs,devtmpfs,squashfs"
   ```

3. **Reduce check timeout**:
   ```bash
   CHECK_TIMEOUT=15
   ```

4. **Monitor specific paths only**:
   ```bash
   MONITOR_ALL=false
   MONITOR_PATHS="/,/home,/var"
   ```

#### Issue: High CPU or Memory Usage

**Solutions**:

1. **Check for infinite loops** (run in debug mode)
2. **Reduce check frequency** in cron/timer
3. **Disable parallel processing** if causing issues

### Permission Issues

#### Issue: Cannot Read Disk Usage

**Error**:
```
df: Permission denied
```

**Solution**:
```bash
# Ensure script runs as root
sudo disk-usage-alert

# Or add to cron with sudo
sudo crontab -e
```

#### Issue: Cannot Write to Log File

**Error**:
```
Error: Cannot write to /var/log/disk-usage-alert.log
```

**Solution**:
```bash
# Create log file with proper permissions
sudo touch /var/log/disk-usage-alert.log
sudo chown root:root /var/log/disk-usage-alert.log
sudo chmod 644 /var/log/disk-usage-alert.log
```

### Filesystem-Specific Issues

#### Issue: Network Filesystems Timing Out

**Problem**: NFS or CIFS mounts cause script to hang

**Solution**:
```bash
# Exclude network filesystems
EXCLUDE_TYPES="nfs,nfs4,cifs,smbfs"

# Or set shorter timeout
CHECK_TIMEOUT=10
```

#### Issue: False Positives on Temporary Filesystems

**Problem**: Alerts for /dev/shm, /run, etc.

**Solution**:
```bash
# Exclude temporary filesystems
EXCLUDE_PATHS="/dev,/sys,/proc,/run,/dev/shm"
EXCLUDE_TYPES="tmpfs,devtmpfs"
```

## Debug Mode

Run with debug output for detailed information:

```bash
disk-usage-alert --debug
```

This shows:
- Configuration loaded
- Filesystems being checked
- Threshold comparisons
- Alert decisions
- Notification attempts

## Logging

### Enable Detailed Logging

```bash
# In config file
ENABLE_LOGGING=true
LOG_FILE="/var/log/disk-usage-alert.log"
LOG_LEVEL="DEBUG"
```

### View Logs

```bash
# Recent logs
tail -f /var/log/disk-usage-alert.log

# Search for errors
grep ERROR /var/log/disk-usage-alert.log

# Search for specific filesystem
grep "/var" /var/log/disk-usage-alert.log
```

## Getting Help

If you're still experiencing issues:

1. **Gather information**:
   ```bash
   # System info
   uname -a
   df -h
   
   # Script info
   disk-usage-alert --version
   disk-usage-alert --debug
   
   # Configuration
   cat /etc/disk-usage-alert.conf
   
   # Logs
   tail -100 /var/log/disk-usage-alert.log
   ```

2. **Check existing issues**:
   - Visit the GitHub repository
   - Search for similar problems

3. **Create a new issue**:
   - Include system information
   - Provide debug output
   - Share relevant configuration (remove sensitive data)
   - Describe expected vs actual behavior

## Best Practices to Avoid Issues

1. **Test changes before deploying**:
   ```bash
   disk-usage-alert --test
   ```

2. **Start with default configuration** and customize gradually

3. **Monitor logs regularly**:
   ```bash
   # Check weekly
   tail -100 /var/log/disk-usage-alert.log
   ```

4. **Keep the script updated**:
   ```bash
   cd disk-usage-alert
   git pull origin main
   ```

5. **Backup configuration before changes**:
   ```bash
   sudo cp /etc/disk-usage-alert.conf /etc/disk-usage-alert.conf.backup
   ```

## Quick Diagnostic Script

Run this to gather diagnostic information:

```bash
#!/bin/bash
echo "=== System Info ==="
uname -a
echo ""
echo "=== Disk Usage ==="
df -h
echo ""
echo "=== Script Location ==="
which disk-usage-alert
echo ""
echo "=== Configuration ==="
cat /etc/disk-usage-alert.conf 2>/dev/null || echo "Config not found"
echo ""
echo "=== Recent Logs ==="
tail -20 /var/log/disk-usage-alert.log 2>/dev/null || echo "Log not found"
echo ""
echo "=== Cron Jobs ==="
sudo crontab -l | grep disk-usage-alert
```

Save this as `/tmp/disk-usage-diagnostic.sh` and run:

```bash
bash /tmp/disk-usage-diagnostic.sh
```

## Next Steps

- Review [Configuration](Configuration.md) for proper setup
- Check [Usage](Usage.md) for correct command syntax
- See [Installation](Installation.md) if reinstallation is needed
