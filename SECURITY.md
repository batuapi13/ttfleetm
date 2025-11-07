# Security Checklist for Repository Commits

## ⚠️ CRITICAL: Always Check Before Committing

### 🔒 **Sensitive Data to NEVER Commit:**

#### Passwords and Credentials
- [ ] LDAP/Active Directory passwords
- [ ] Database passwords  
- [ ] API keys and tokens
- [ ] SSH private keys
- [ ] Service account credentials
- [ ] Admin passwords

#### Server Information
- [ ] Internal IP addresses
- [ ] Server hostnames
- [ ] Port configurations (if sensitive)
- [ ] Network topology details

#### Configuration Files
- [ ] Production environment files
- [ ] Database connection strings
- [ ] Email server credentials
- [ ] Third-party service credentials

#### Personal Information
- [ ] Real user accounts
- [ ] Email addresses
- [ ] Phone numbers
- [ ] Internal company data

### ✅ **Pre-Commit Security Checklist:**

1. **Scan for Passwords**
   ```bash
   grep -r -i "password.*=" . --exclude-dir=node_modules --exclude-dir=.git
   ```

2. **Check for IP Addresses**
   ```bash
   grep -r "192\.168\|10\.\|172\." . --exclude-dir=node_modules --exclude-dir=.git
   ```

3. **Look for Common Sensitive Patterns**
   ```bash
   grep -r -E "(api[_-]?key|secret|token|password|pwd|pass)" . --exclude-dir=node_modules --exclude-dir=.git
   ```

4. **Review Config Files**
   ```bash
   find . -name "*.config.js" -o -name "*.env" -o -name "*config*" | grep -v node_modules
   ```

### 🛡️ **Security Best Practices:**

#### Use Example Files
- ✅ `ldap-config.example.js` (safe)
- ❌ `ldap-config.js` (contains real credentials)

#### Environment Variables
- ✅ Use `process.env.LDAP_PASSWORD`
- ❌ Hard-code passwords in files

#### .gitignore Protection
- ✅ Add `*.config.js` to .gitignore
- ✅ Add `.env` files to .gitignore
- ✅ Add `config/` directory exclusions

#### Documentation
- ✅ Use placeholder values in docs
- ✅ Provide setup instructions
- ❌ Include real credentials in examples

### 🚨 **If Credentials Are Already Committed:**

1. **Immediately Change Credentials**
   ```bash
   # Change the exposed passwords immediately
   # Rotate API keys and tokens
   # Update service account credentials
   ```

2. **Remove from Repository**
   ```bash
   # Create sanitized version
   # Commit security fix
   # Push to remote immediately
   ```

3. **Consider Repository History**
   ```bash
   # For highly sensitive data, consider:
   # - Creating new repository
   # - Using BFG Repo-Cleaner
   # - Contacting GitHub support
   ```

### 📝 **Example Secure Configurations:**

#### LDAP Config Template
```javascript
module.exports = {
  url: 'ldap://your-ldap-server:389',
  bindDN: 'uid=service-account,ou=people,dc=yourdomain,dc=com',
  bindPassword: process.env.LDAP_BIND_PASSWORD || 'your-password-here',
  // ... other config
};
```

#### Environment File Template
```bash
# .env file (NEVER commit this)
LDAP_BIND_PASSWORD=your-actual-password
DATABASE_PASSWORD=your-db-password
API_KEY=your-api-key
```

### 🔍 **Automated Security Scanning:**

#### Git Pre-commit Hook
```bash
#!/bin/sh
# .git/hooks/pre-commit

# Scan for potential secrets
if git diff --cached --name-only | xargs grep -l "password\|secret\|api.*key"; then
    echo "⚠️  WARNING: Potential secrets detected in staged files!"
    echo "Please review and remove sensitive data before committing."
    exit 1
fi
```

#### GitHub Actions Security Scan
```yaml
name: Security Scan
on: [push, pull_request]
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Run secret scan
      run: |
        # Add secret scanning tools here
        # Example: truffleHog, git-secrets, etc.
```

### 📚 **Resources:**

- [GitHub Security Best Practices](https://docs.github.com/en/code-security)
- [Git Secrets Tool](https://github.com/awslabs/git-secrets)
- [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/)

## Remember: **Security is Everyone's Responsibility**

Always assume your repository is public, even if it's private. Treat every commit as if it will be seen by the world.