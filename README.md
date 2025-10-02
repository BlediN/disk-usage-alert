# disk-usage-alert

Checks the storage in a Ubuntu server and sends alerts when disk usage exceeds configured thresholds.

## Overview

Disk Usage Alert is a monitoring tool designed to help system administrators proactively manage disk space on Ubuntu servers. It automatically checks disk usage and sends notifications through various channels (email, Slack, Discord, Telegram) when storage thresholds are exceeded.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/BlediN/disk-usage-alert.git
cd disk-usage-alert

# Make the script executable
chmod +x disk-usage-alert.sh

# Run a test check
./disk-usage-alert.sh --test
```

## Documentation

📚 **[Visit the Wiki](wiki/)** for comprehensive documentation:

- **[Installation Guide](wiki/Installation.md)** - Complete setup instructions for Ubuntu servers
- **[Usage Guide](wiki/Usage.md)** - How to use the tool effectively
- **[Configuration Guide](wiki/Configuration.md)** - All configuration options explained
- **[Troubleshooting Guide](wiki/Troubleshooting.md)** - Solutions to common issues
- **[Contributing Guide](wiki/Contributing.md)** - How to contribute to the project

## Features

- ✅ Automated disk usage monitoring
- ✅ Configurable warning and critical thresholds
- ✅ Multiple notification channels (Email, Slack, Discord, Telegram)
- ✅ Alert throttling to prevent spam
- ✅ Support for scheduled checks (cron/systemd)
- ✅ Filesystem filtering and exclusion
- ✅ Lightweight and efficient
- ✅ Easy to configure and deploy

## Requirements

- Ubuntu 18.04 LTS or later
- Bash 4.0 or later
- Root or sudo access (for installation)

## Basic Usage

```bash
# Check all filesystems
disk-usage-alert

# Check specific path
disk-usage-alert --check-path /var/log

# Run in debug mode
disk-usage-alert --debug

# Test configuration
disk-usage-alert --test
```

## Quick Configuration Example

Create `/etc/disk-usage-alert.conf`:

```bash
WARNING_THRESHOLD=80
CRITICAL_THRESHOLD=90
ENABLE_EMAIL=true
EMAIL_TO="admin@example.com"
```

See the [Configuration Guide](wiki/Configuration.md) for all options.

## Contributing

Contributions are welcome! Please see the [Contributing Guide](wiki/Contributing.md) for details.

## License

This project is open source. See LICENSE file for details.

## Support

- 📖 Check the [Wiki](wiki/) for documentation
- 🐛 [Report bugs](https://github.com/BlediN/disk-usage-alert/issues)
- 💡 [Request features](https://github.com/BlediN/disk-usage-alert/issues)
- 🤝 [Contribute](wiki/Contributing.md)
