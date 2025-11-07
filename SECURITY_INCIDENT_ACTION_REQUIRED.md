# ⚠️ CRITICAL SECURITY REMINDER ⚠️

## IMMEDIATE ACTION REQUIRED

### 🚨 Your LDAP Password Was Exposed on GitHub

**What happened:**
- Your LDAP service account password `Lobak!123` was briefly exposed in the GitHub repository
- The credentials have been removed from GitHub
- However, they may have been cached or indexed

### ✅ Actions Already Taken:
1. ✅ Removed credentials from GitHub repository
2. ✅ Enhanced .gitignore to prevent future exposure
3. ✅ Added security documentation and checklist
4. ✅ Moved application to secure location `/opt/ttfleetm`
5. ✅ Restored working LDAP configuration (TEMPORARY)

### 🔴 CRITICAL: What YOU Must Do NOW:

#### 1. Change LDAP Service Account Password IMMEDIATELY
```bash
# On your LDAP/Active Directory server:
# Change password for: uid=bindsvc,ou=people,dc=tiongmas,dc=my
# Current password: Lobak!123
# New password: [Choose a strong password]
```

#### 2. Update Local Configuration
```bash
# After changing the LDAP password, update:
sudo nano /opt/ttfleetm/ldap-config.js

# Change line 13 to your new password:
bindPassword: 'YOUR-NEW-PASSWORD-HERE',

# Then restart the service:
sudo systemctl restart fleet-management
```

#### 3. Review LDAP Server Logs
```bash
# Check for any unauthorized access attempts
# Look for failed authentication or unusual activity
# from the bindsvc account
```

#### 4. Security Best Practices Going Forward

**Never commit these files to Git:**
- `/opt/ttfleetm/ldap-config.js` (already in .gitignore)
- `/opt/ttfleetm/.env` (if created)
- `/opt/ttfleetm/data/` (contains user data)
- Any file with real passwords or credentials

**Use Environment Variables (Recommended):**
```bash
# Create .env file (NOT committed to Git):
echo "LDAP_BIND_PASSWORD=your-new-password" > /opt/ttfleetm/.env

# Update ldap-config.js to use environment variable:
bindPassword: process.env.LDAP_BIND_PASSWORD || 'fallback-not-for-production',
```

### 📁 Secure File Locations

**Production Application:**
- Location: `/opt/ttfleetm/`
- Purpose: Secure, non-web-accessible application files
- Access: Only via Node.js service (port 3000)

**Public Web Assets:**
- Location: `/var/www/html/fleet/`
- Purpose: Static files (HTML, CSS, JS, images only)
- Access: Via web server (if configured)
- Security: .htaccess prevents access to sensitive files

**Old INSECURE Location (TO BE DELETED):**
- Location: `/var/www/html/fleet-new-OLD-INSECURE/`
- Status: Should be completely removed after verification
- Risk: Contains old files that were web-accessible

### 🔒 Current Security Status

**✅ Secured:**
- Application moved outside web root
- Security headers enabled
- File access restrictions in place
- GitHub repository sanitized
- Service running with restricted permissions

**⚠️ Still Required:**
- Change LDAP password
- Update local configuration
- Delete old insecure directory
- Review LDAP logs for unauthorized access

### 🚀 Quick Commands

```bash
# Check service status
sudo systemctl status fleet-management

# View logs
sudo journalctl -u fleet-management -f

# Test application
curl http://localhost:3000

# After password change, restart
sudo systemctl restart fleet-management

# Delete old insecure directory (AFTER VERIFICATION)
sudo rm -rf /var/www/html/fleet-new-OLD-INSECURE
```

### 📞 Support

If you encounter issues after changing the password:
1. Check service logs: `sudo journalctl -u fleet-management -f`
2. Verify LDAP connectivity: `cd /opt/ttfleetm && node test-ldap.js`
3. Test with local admin account as fallback

### ⏰ Timeline

- **Exposure Duration**: ~20 minutes (when credentials were on GitHub)
- **Mitigation Applied**: Immediately
- **Password Change**: REQUIRED NOW
- **Complete Security**: After password change + verification

---

**REMEMBER:** The password `Lobak!123` is COMPROMISED and must be changed immediately.

This file: `/opt/ttfleetm/SECURITY_INCIDENT_ACTION_REQUIRED.md`
Created: 2025-11-07 13:33
