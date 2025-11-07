# Troubleshooting Guide

## Common Issues and Solutions

### Installation Issues

#### Node.js Version Conflicts
**Problem:** Application fails to start with Node.js version errors
```
Error: The engine "node" is incompatible with this module
```

**Solution:**
```bash
# Check current version
node --version

# Install Node.js 18.x
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify installation
node --version  # Should show v18.x.x
```

#### Permission Issues
**Problem:** Permission denied errors during installation
```
Error: EACCES: permission denied, mkdir '/var/www/html/fleet-new'
```

**Solution:**
```bash
# Fix ownership
sudo chown -R $USER:$USER /var/www/html/fleet-new

# Fix permissions
chmod -R 755 /var/www/html/fleet-new
chmod -R 775 /var/www/html/fleet-new/data
chmod -R 775 /var/www/html/fleet-new/logs
chmod -R 775 /var/www/html/fleet-new/uploads
```

#### Missing Dependencies
**Problem:** Module not found errors
```
Error: Cannot find module 'express'
```

**Solution:**
```bash
cd /var/www/html/fleet-new
npm install

# If that fails, try:
rm -rf node_modules package-lock.json
npm install
```

### Service Issues

#### Service Won't Start
**Problem:** Fleet management service fails to start
```bash
sudo systemctl status fleet-management
# Shows: failed (Result: exit-code)
```

**Diagnosis:**
```bash
# Check detailed logs
sudo journalctl -u fleet-management -n 50

# Check if port is in use
sudo netstat -tlnp | grep :3000

# Check file permissions
ls -la /var/www/html/fleet-new/server.js
```

**Solutions:**
```bash
# Kill process using port 3000
sudo lsof -ti:3000 | xargs sudo kill -9

# Fix file permissions
sudo chown -R tapa:www-data /var/www/html/fleet-new

# Restart service
sudo systemctl restart fleet-management
```

#### Service Starts But Not Accessible
**Problem:** Service running but HTTP requests timeout

**Diagnosis:**
```bash
# Check if service is actually listening
sudo netstat -tlnp | grep :3000

# Test local connectivity
curl -I http://localhost:3000

# Check firewall
sudo ufw status
```

**Solutions:**
```bash
# If firewall is blocking
sudo ufw allow 3000

# If binding to localhost only, check server.js:
# Change app.listen(3000, 'localhost') to app.listen(3000, '0.0.0.0')
```

### Authentication Issues

#### LDAP Authentication Failures
**Problem:** Users cannot login with LDAP credentials
```
LDAP bind failed: Invalid credentials
```

**Diagnosis:**
```bash
# Test LDAP connectivity
node test-ldap.js

# Test with ldapsearch
sudo apt install ldap-utils
ldapsearch -x -H ldap://your-server:389 -b "DC=domain,DC=com" -s base
```

**Solutions:**
1. **Check LDAP configuration:**
```javascript
// In ldap-config.js
module.exports = {
  url: 'ldap://correct-server:389',  // Verify server address
  username: 'CN=service,DC=domain,DC=com',  // Verify DN format
  password: 'correct-password'  // Verify password
};
```

2. **Test service account:**
```bash
ldapsearch -x -H ldap://server:389 \
  -D "CN=service,DC=domain,DC=com" \
  -w "password" \
  -b "DC=domain,DC=com" \
  -s sub "(sAMAccountName=testuser)"
```

3. **Check network connectivity:**
```bash
telnet ldap-server 389
# Should connect successfully
```

#### Local Authentication Issues
**Problem:** Cannot login with local admin account

**Solution:**
```bash
# Reset admin password in data/users.json
cd /var/www/html/fleet-new
node -e "
const bcrypt = require('bcryptjs');
const fs = require('fs');
const users = JSON.parse(fs.readFileSync('data/users.json', 'utf8'));
const admin = users.find(u => u.username === 'admin');
if (admin) {
  admin.password = bcrypt.hashSync('admin123', 10);
  fs.writeFileSync('data/users.json', JSON.stringify(users, null, 2));
  console.log('Admin password reset to: admin123');
}
"
```

#### Session Issues
**Problem:** Users get logged out frequently

**Diagnosis:**
```bash
# Check session configuration in server.js
grep -n "session" /var/www/html/fleet-new/server.js
```

**Solutions:**
```javascript
// In server.js, increase session timeout:
app.use(session({
  secret: 'your-secret',
  resave: false,
  saveUninitialized: false,
  cookie: { 
    secure: false, // Set to true if using HTTPS
    maxAge: 24 * 60 * 60 * 1000 // 24 hours
  }
}));
```

### Database/Storage Issues

#### Corrupted Data Files
**Problem:** Application crashes with JSON parsing errors
```
SyntaxError: Unexpected token in JSON
```

**Diagnosis:**
```bash
# Check data files
cd /var/www/html/fleet-new/data
for file in *.json; do
  echo "Checking $file"
  node -e "try { JSON.parse(require('fs').readFileSync('$file', 'utf8')); console.log('✓ Valid'); } catch(e) { console.log('✗ Invalid:', e.message); }"
done
```

**Solutions:**
```bash
# Restore from backup
./scripts/restore.sh backup-file.tar.gz

# Or reset to defaults
cd /var/www/html/fleet-new/data
cp vehicles.json vehicles.json.backup
echo '[]' > vehicles.json

# Restart service
sudo systemctl restart fleet-management
```

#### Permission Issues with Data Files
**Problem:** Cannot read/write data files
```
Error: EACCES: permission denied, open 'data/vehicles.json'
```

**Solution:**
```bash
cd /var/www/html/fleet-new
sudo chown -R tapa:www-data data/
chmod -R 664 data/*.json
chmod 775 data/
```

### Frontend Issues

#### PWA Not Installing
**Problem:** "Add to Home Screen" option not available

**Diagnosis:**
```bash
# Check manifest.json
curl -I http://localhost:3000/manifest.json

# Check service worker
curl -I http://localhost:3000/sw.js

# Check HTTPS (required for PWA in production)
```

**Solutions:**
1. **Verify manifest.json is accessible**
2. **Check service worker registration in browser console**
3. **Use HTTPS in production**
4. **Clear browser cache and try again**

#### Application Not Loading
**Problem:** Blank page or JavaScript errors

**Diagnosis:**
```bash
# Check browser console for errors
# Check if static files are served correctly
curl -I http://localhost:3000/assets/app.js
curl -I http://localhost:3000/assets/style.css
```

**Solutions:**
```bash
# Verify static file paths in server.js
grep -n "static" /var/www/html/fleet-new/server.js

# Check file permissions
ls -la /var/www/html/fleet-new/public/assets/
```

#### Mobile Interface Issues
**Problem:** Interface not responsive on mobile

**Solutions:**
1. **Clear mobile browser cache**
2. **Check viewport meta tag in HTML**
3. **Verify CSS media queries**
4. **Test in different mobile browsers**

### Performance Issues

#### Slow Response Times
**Problem:** Application responds slowly

**Diagnosis:**
```bash
# Check system resources
htop
df -h
free -h

# Check Node.js process
ps aux | grep node
```

**Solutions:**
```bash
# Restart service
sudo systemctl restart fleet-management

# Check for memory leaks in logs
sudo journalctl -u fleet-management | grep -i "memory\|heap"

# Optimize JSON file sizes
cd /var/www/html/fleet-new/data
ls -lah *.json
```

#### High Memory Usage
**Problem:** Node.js process consuming too much memory

**Solutions:**
```bash
# Add memory monitoring to service
# In /etc/systemd/system/fleet-management.service
[Service]
MemoryLimit=512M
MemoryAccounting=yes

# Reload and restart
sudo systemctl daemon-reload
sudo systemctl restart fleet-management
```

### Network Issues

#### Can't Access from Other Devices
**Problem:** Application only accessible from localhost

**Diagnosis:**
```bash
# Check binding address
sudo netstat -tlnp | grep :3000

# Should show 0.0.0.0:3000, not 127.0.0.1:3000
```

**Solutions:**
```javascript
// In server.js, change:
app.listen(3000, '0.0.0.0', () => {
  console.log('Server running on port 3000');
});

// Not:
app.listen(3000, 'localhost', () => {
  console.log('Server running on port 3000');
});
```

#### CORS Issues
**Problem:** Cross-origin request errors

**Solution:**
```javascript
// In server.js, add CORS middleware:
const cors = require('cors');
app.use(cors({
  origin: ['http://localhost:3000', 'http://your-domain.com'],
  credentials: true
}));
```

### Backup and Recovery

#### Lost Data
**Problem:** Accidentally deleted important data

**Solutions:**
```bash
# Check if backups exist
ls -la /var/backups/ttfleetm/

# Restore from backup
cd /var/www/html/fleet-new
./scripts/restore.sh /var/backups/ttfleetm/ttfleetm_backup_YYYYMMDD_HHMMSS.tar.gz

# If no backups available, check system backups
sudo find /var/backups -name "*ttfleetm*" -type f
```

#### Backup Script Failures
**Problem:** Automated backups not working

**Diagnosis:**
```bash
# Test backup script manually
cd /var/www/html/fleet-new
./scripts/backup.sh

# Check cron logs
sudo grep -i backup /var/log/syslog
```

**Solutions:**
```bash
# Fix backup script permissions
chmod +x scripts/backup.sh

# Add to crontab for automated backups
crontab -e
# Add line: 0 2 * * * /var/www/html/fleet-new/scripts/backup.sh
```

## Log Analysis

### Important Log Locations
```bash
# Application logs
sudo journalctl -u fleet-management -f

# System logs
tail -f /var/log/syslog

# Application-specific logs (if configured)
tail -f /var/www/html/fleet-new/logs/app.log
```

### Common Log Patterns
```bash
# Successful startup
"Server running on port 3000"

# LDAP authentication
"User authenticated via LDAP"
"LDAP bind failed"

# Database errors
"Error reading data file"
"JSON parse error"

# Session issues
"Session expired"
"Invalid session"
```

## Getting Help

### Debug Mode
Enable detailed logging:
```javascript
// In server.js or store.js
const DEBUG = true;
if (DEBUG) {
  console.log('Debug info:', data);
}
```

### System Information Script
```bash
#!/bin/bash
echo "=== System Information ==="
uname -a
echo "Node.js: $(node --version)"
echo "npm: $(npm --version)"
echo "Free memory: $(free -h | grep Mem | awk '{print $7}')"
echo "Disk space: $(df -h / | tail -1 | awk '{print $4}')"
echo
echo "=== Service Status ==="
sudo systemctl status fleet-management --no-pager
echo
echo "=== Port Usage ==="
sudo netstat -tlnp | grep :3000
echo
echo "=== Recent Logs ==="
sudo journalctl -u fleet-management -n 10 --no-pager
```

### Support Checklist
Before seeking support, gather:
1. **System information** (OS, Node.js version)
2. **Error messages** (exact text)
3. **Log files** (recent entries)
4. **Configuration files** (anonymized)
5. **Steps to reproduce** the issue
6. **Expected vs actual behavior**