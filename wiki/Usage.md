# Usage Guide

This guide covers how to use Disk Usage Alert effectively on your Ubuntu server.

## Basic Usage

### Running a Manual Check

To perform a one-time disk usage check:

```bash
disk-usage-alert
```

Or if running from the repository directory:

```bash
./disk-usage-alert.sh
```

### Command-Line Options

```bash
disk-usage-alert [OPTIONS]

Options:
  -h, --help           Show help message
  -v, --version        Show version information
  -c, --config FILE    Use custom configuration file
  -t, --test           Run in test mode (no alerts sent)
  -d, --debug          Enable debug output
  -q, --quiet          Suppress standard output
  --check-path PATH    Check specific path instead of all mounts
```

## Examples

### Check Specific Directory

```bash
disk-usage-alert --check-path /var/log
```

### Test Configuration

Before setting up automated alerts, test your configuration:

```bash
disk-usage-alert --test
```

This will show what alerts would be triggered without actually sending notifications.

### Debug Mode

If you're experiencing issues, run with debug output:

```bash
disk-usage-alert --debug
```

### Custom Configuration File

Use a different configuration file:

```bash
disk-usage-alert --config /path/to/custom.conf
```

## Understanding Output

### Normal Output

When disk usage is below thresholds:

```
[OK] /          - Used: 45% (50GB/110GB)
[OK] /home      - Used: 62% (120GB/193GB)
[OK] /var       - Used: 38% (15GB/40GB)
```

### Warning State

When disk usage exceeds warning threshold:

```
[WARNING] /var/log - Used: 82% (33GB/40GB)
Threshold: 80%
```

### Critical State

When disk usage exceeds critical threshold:

```
[CRITICAL] /var/log - Used: 95% (38GB/40GB)
Threshold: 90%
Action Required: Immediate cleanup needed!
```

## Automated Monitoring

### Scheduled Checks with Cron

Once configured in cron (see [Installation](Installation.md)), the script runs automatically at specified intervals.

View cron logs:

```bash
# View recent cron executions
grep disk-usage-alert /var/log/syslog

# Or check system journal
journalctl -u cron | grep disk-usage-alert
```

### Systemd Timer

If using systemd timer:

```bash
# Check timer status
sudo systemctl status disk-usage-alert.timer

# View service logs
sudo journalctl -u disk-usage-alert.service

# Manually trigger the service
sudo systemctl start disk-usage-alert.service
```

## Alert Mechanisms

### Email Alerts

When configured for email notifications:

- **Warning Level**: Sends email with yellow flag emoji
- **Critical Level**: Sends urgent email with red flag emoji
- Subject line includes hostname for easy identification

### Slack Notifications

When Slack webhook is configured:

- Posts to specified channel
- Uses color coding (yellow for warning, red for critical)
- Includes hostname and detailed disk information

### Custom Scripts

You can configure custom alert scripts to:

- Send SMS via Twilio
- Post to other chat platforms
- Create tickets in monitoring systems
- Log to centralized logging systems

See [Configuration](Configuration.md) for setup details.

## Best Practices

### Monitoring Strategy

1. **Set Appropriate Thresholds**: 
   - Warning: 80% for most systems
   - Critical: 90% for most systems
   - Lower thresholds for critical systems (70%/85%)

2. **Check Frequency**:
   - Production servers: Every 1-2 hours
   - Development servers: Every 6-12 hours
   - Archive/backup servers: Daily

3. **Exclude Temporary Filesystems**:
   - /dev/shm
   - /run
   - tmpfs mounts

### Response Procedures

When you receive an alert:

1. **Verify the Alert**:
   ```bash
   df -h
   ```

2. **Identify Large Files/Directories**:
   ```bash
   sudo du -sh /* | sort -hr | head -10
   ```

3. **Check for Large Log Files**:
   ```bash
   sudo du -sh /var/log/* | sort -hr | head -10
   ```

4. **Find Old Files**:
   ```bash
   sudo find /path -type f -mtime +90 -size +100M
   ```

5. **Clean Up**:
   - Archive or delete old logs
   - Remove temporary files
   - Clean package caches
   - Review application data

### Maintenance

#### Regular Tasks

- Review alert history monthly
- Update thresholds based on growth patterns
- Test notification channels quarterly
- Update the script when new versions are released

#### Log Rotation

Ensure the alert script's own logs are rotated:

```bash
sudo nano /etc/logrotate.d/disk-usage-alert
```

Add:

```
/var/log/disk-usage-alert.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
}
```

## Integration Examples

### Integration with Monitoring Dashboards

Export metrics for Grafana, Prometheus, or other tools:

```bash
disk-usage-alert --format json > /var/lib/node_exporter/textfile_collector/disk_usage.prom
```

### Integration with Configuration Management

Ansible example:

```yaml
- name: Run disk usage check
  command: /usr/local/bin/disk-usage-alert
  register: disk_check
  
- name: Alert on critical usage
  debug:
    msg: "{{ disk_check.stdout }}"
  when: disk_check.rc != 0
```

## Troubleshooting

For common issues and solutions, see the [Troubleshooting](Troubleshooting.md) page.

## Next Steps

- Review [Configuration](Configuration.md) for advanced options
- Set up [automated monitoring](Installation.md#setting-up-automated-monitoring)
- Check [Troubleshooting](Troubleshooting.md) for common issues
