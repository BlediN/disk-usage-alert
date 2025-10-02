

## 📄 Disk Usage Alert System — Implementation Guide

### 🔧 Purpose
Monitor disk usage every 2 minutes. If usage ≥ 1%, send alert emails via SendGrid to multiple recipients.

---

## 🛠️ Step-by-Step Setup (Safe for Production)

### 1. ✅ **Check Required Tools**

Before installing anything, check if required tools are already present:

```bash
which curl jq crontab
```

If any return empty, install only the missing ones:

```bash
# Example: install only missing tools
sudo apt install curl jq cron -y
```

> ⚠️ **Do NOT run `sudo apt update`** unless you need to install missing packages. It can trigger system-wide updates that may affect running services.

---

### 2. 🔐 **Create and Secure SendGrid API Key**

if you don't have the API key yet:
1. Log in to [SendGrid Dashboard](https://app.sendgrid.com)
2. Go to **Settings → API Keys**
3. Create a new key with “Mail Send” permission
4. Store it securely:

```bash
sudo nano /etc/sendgrid.env
```

Add key without quotes:

```bash
SENDGRID_API_KEY=your_actual_key_here
```

Secure the file:

```bash
sudo chmod 600 /etc/sendgrid.env
```

---

### 3. 📜 **Create the Monitoring Script**

```bash
sudo nano /usr/local/bin/disk_check.sh
```

Paste the .sh script in here



### 4. ⏰ **Schedule Cron Job**

Edit the crontab for your user:

```bash
crontab -e
```

Add:

```bash
0 * * * * /usr/local/bin/disk_check.sh
```

This runs the script every hour.

---

### 5. ✅ **Verify Setup**

- Run manually: `sudo /usr/local/bin/disk_check.sh`
- Check cron logs: `grep disk_check.sh /var/log/syslog`
- Confirm email delivery
- Optionally add logging to `/var/log/disk_check.log`

---

## 🧘 Safe Practices

- ✅ No system-wide updates (`apt update`) unless necessary
- ✅ No service restarts
- ✅ Script runs independently — no interference with existing apps
- ✅ Uses SendGrid via HTTPS — no local mail server required

