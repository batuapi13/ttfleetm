# LDAP Configuration Guide

## Overview

TT Fleet Management System supports dual authentication: both local users and LDAP integration. This guide covers the complete LDAP setup process.

## Prerequisites

- LDAP/Active Directory server accessible from application server
- Service account with read permissions in LDAP directory
- Knowledge of your LDAP directory structure

## Configuration Steps

### 1. Basic LDAP Configuration

Create or edit `ldap-config.js`:

```javascript
module.exports = {
  // LDAP Server Configuration
  url: 'ldap://your-ldap-server:389',  // or ldaps://server:636 for SSL
  baseDN: 'DC=yourdomain,DC=com',
  
  // Service Account Credentials
  username: 'CN=service-account,OU=Service Accounts,DC=yourdomain,DC=com',
  password: 'your-service-account-password',
  
  // Group-based Role Mapping
  groups: {
    admin: 'CN=car_admin,OU=Groups,DC=yourdomain,DC=com',
    user: 'CN=car_user,OU=Groups,DC=yourdomain,DC=com'
  },
  
  // User Search Configuration
  userSearchBase: 'OU=Users,DC=yourdomain,DC=com',
  userSearchFilter: '(sAMAccountName={{username}})',
  
  // Attribute Mapping
  attributes: {
    username: 'sAMAccountName',
    displayName: 'displayName',
    email: 'mail',
    memberOf: 'memberOf'
  },
  
  // Connection Settings
  timeout: 5000,
  connectTimeout: 10000,
  enabled: true
};
```

### 2. Active Directory Examples

#### Standard AD Configuration
```javascript
module.exports = {
  url: 'ldap://dc.company.com:389',
  baseDN: 'DC=company,DC=com',
  username: 'CN=ldap-service,OU=Service Accounts,DC=company,DC=com',
  password: 'ServicePassword123',
  
  groups: {
    admin: 'CN=Fleet_Admins,OU=Security Groups,DC=company,DC=com',
    user: 'CN=Fleet_Users,OU=Security Groups,DC=company,DC=com'
  },
  
  userSearchBase: 'OU=Employees,DC=company,DC=com',
  userSearchFilter: '(sAMAccountName={{username}})',
  
  attributes: {
    username: 'sAMAccountName',
    displayName: 'displayName',
    email: 'mail',
    memberOf: 'memberOf'
  }
};
```

#### Multi-Domain AD Configuration
```javascript
module.exports = {
  url: 'ldap://global.company.com:3268',  // Global Catalog port
  baseDN: 'DC=company,DC=com',
  username: 'CN=fleet-service,OU=Service Accounts,DC=company,DC=com',
  password: 'ComplexPassword456',
  
  groups: {
    admin: 'CN=car_admin,OU=Groups,DC=company,DC=com',
    user: 'CN=car_user,OU=Groups,DC=company,DC=com'
  },
  
  userSearchBase: 'DC=company,DC=com',  // Search entire forest
  userSearchFilter: '(userPrincipalName={{username}}@company.com)',
  
  attributes: {
    username: 'userPrincipalName',
    displayName: 'displayName',
    email: 'mail',
    memberOf: 'memberOf'
  }
};
```

### 3. OpenLDAP Configuration

```javascript
module.exports = {
  url: 'ldap://openldap.company.com:389',
  baseDN: 'dc=company,dc=com',
  username: 'cn=admin,dc=company,dc=com',
  password: 'adminpassword',
  
  groups: {
    admin: 'cn=fleet-admins,ou=groups,dc=company,dc=com',
    user: 'cn=fleet-users,ou=groups,dc=company,dc=com'
  },
  
  userSearchBase: 'ou=people,dc=company,dc=com',
  userSearchFilter: '(uid={{username}})',
  
  attributes: {
    username: 'uid',
    displayName: 'cn',
    email: 'mail',
    memberOf: 'memberOf'
  }
};
```

## Authentication Flow

### 1. Login Process
```
User Login
    ↓
LDAP Enabled?
    ↓ (Yes)
Search User in LDAP
    ↓
User Found?
    ↓ (Yes)
Bind with User Credentials
    ↓
Bind Successful?
    ↓ (Yes)
Check Group Membership
    ↓
Assign Role (admin/user)
    ↓
Create/Update Local User Record
    ↓
Create Session
```

### 2. Group Membership Logic
```javascript
// Example group membership check
function checkGroupMembership(userGroups, requiredGroup) {
  return userGroups.some(group => {
    // Handle nested group DNs
    return group.toLowerCase().includes(requiredGroup.toLowerCase());
  });
}
```

## Testing LDAP Configuration

### 1. Test Script
Use the included test script:

```bash
# Test LDAP connectivity
node test-ldap.js

# Test with specific user
node test-ldap.js testuser
```

### 2. Manual Testing Steps

#### Test LDAP Connectivity
```bash
# Test with ldapsearch (install ldap-utils)
sudo apt install ldap-utils

# Test basic connectivity
ldapsearch -x -H ldap://your-server:389 -b "DC=yourdomain,DC=com" -s base

# Test service account
ldapsearch -x -H ldap://your-server:389 \
  -D "CN=service-account,OU=Service Accounts,DC=yourdomain,DC=com" \
  -w "password" \
  -b "DC=yourdomain,DC=com" \
  -s sub "(sAMAccountName=testuser)"
```

#### Test Group Membership
```bash
# Find user groups
ldapsearch -x -H ldap://your-server:389 \
  -D "CN=service-account,OU=Service Accounts,DC=yourdomain,DC=com" \
  -w "password" \
  -b "DC=yourdomain,DC=com" \
  -s sub "(sAMAccountName=testuser)" memberOf
```

## Security Considerations

### 1. Service Account Setup
```bash
# Create dedicated service account with minimal permissions
# Required permissions:
# - Read access to user objects
# - Read access to group objects
# - No write permissions needed

# Active Directory example:
# 1. Create user account: fleet-service
# 2. Set strong password
# 3. Disable password expiration
# 4. Add to "Domain Users" group only
# 5. Grant "Read" permissions on Users and Groups OUs
```

### 2. Secure LDAP Configuration
```javascript
module.exports = {
  // Use LDAPS for production
  url: 'ldaps://ldap.company.com:636',
  
  // Certificate validation
  tlsOptions: {
    rejectUnauthorized: true,
    ca: [fs.readFileSync('/path/to/ca-cert.pem')]
  },
  
  // Strong password for service account
  password: process.env.LDAP_SERVICE_PASSWORD,
  
  // Connection limits
  timeout: 5000,
  connectTimeout: 10000,
  reconnect: true
};
```

### 3. Environment Variables
```bash
# .env file
LDAP_ENABLED=true
LDAP_URL=ldaps://ldap.company.com:636
LDAP_SERVICE_PASSWORD=your-secure-password
LDAP_SERVICE_USER=CN=fleet-service,OU=Service Accounts,DC=company,DC=com
```

## Troubleshooting

### Common Issues

#### 1. Connection Timeout
```javascript
// Symptoms: "Connection timeout" errors
// Solution: Check firewall rules, network connectivity

// Test connectivity
telnet ldap-server 389
# or
nmap -p 389 ldap-server
```

#### 2. Authentication Failed
```javascript
// Symptoms: "Invalid credentials" for service account
// Solution: Verify service account credentials

// Test with ldapsearch
ldapsearch -x -H ldap://server:389 \
  -D "your-service-account-dn" \
  -w "password" \
  -b "base-dn" \
  -s base
```

#### 3. User Not Found
```javascript
// Symptoms: Users can't login, "User not found"
// Solution: Check userSearchBase and userSearchFilter

// Debug user search
userSearchFilter: '(|(sAMAccountName={{username}})(userPrincipalName={{username}}))'
```

#### 4. Group Membership Issues
```javascript
// Symptoms: Users login but get wrong permissions
// Solution: Check group DNs and membership

// Debug: Add logging to store.js
console.log('User groups:', userEntry.memberOf);
console.log('Admin group:', config.groups.admin);
```

### Debug Mode
Enable debug logging:

```javascript
// In store.js, add debug logging
const debug = true;

if (debug) {
  console.log('LDAP Config:', config);
  console.log('Search result:', searchResult);
  console.log('User groups:', userEntry.memberOf);
}
```

### Log Analysis
```bash
# View LDAP-related logs
sudo journalctl -u fleet-management -f | grep -i ldap

# Common log patterns to look for:
# - "LDAP connection established"
# - "User authenticated via LDAP"
# - "Group membership checked"
# - "LDAP bind failed"
```

## Group Management

### 1. Active Directory Group Setup
```bash
# Create security groups in AD
# 1. Open "Active Directory Users and Computers"
# 2. Create new group: "car_admin"
#    - Group scope: Global or Universal
#    - Group type: Security
# 3. Create new group: "car_user"
# 4. Add users to appropriate groups
```

### 2. Role Assignment Logic
```javascript
// In store.js
async function assignUserRole(userGroups, config) {
  // Check admin group first
  const isAdmin = userGroups.some(group => 
    group.toLowerCase().includes(config.groups.admin.toLowerCase())
  );
  
  if (isAdmin) return 'admin';
  
  // Check user group
  const isUser = userGroups.some(group => 
    group.toLowerCase().includes(config.groups.user.toLowerCase())
  );
  
  return isUser ? 'user' : 'user'; // Default to user role
}
```

## Advanced Configuration

### 1. Multiple LDAP Servers
```javascript
module.exports = {
  servers: [
    {
      url: 'ldap://primary-dc.company.com:389',
      primary: true
    },
    {
      url: 'ldap://secondary-dc.company.com:389',
      fallback: true
    }
  ],
  // ... other config
};
```

### 2. Custom Attribute Mapping
```javascript
module.exports = {
  attributes: {
    username: 'sAMAccountName',
    displayName: 'displayName',
    email: 'mail',
    phone: 'telephoneNumber',
    department: 'department',
    title: 'title',
    manager: 'manager',
    memberOf: 'memberOf',
    // Custom attributes
    employeeId: 'employeeNumber',
    location: 'physicalDeliveryOfficeName'
  }
};
```

### 3. SSL/TLS Configuration
```javascript
module.exports = {
  url: 'ldaps://ldap.company.com:636',
  tlsOptions: {
    rejectUnauthorized: true,
    ca: [
      fs.readFileSync('/etc/ssl/certs/ca-certificates.crt')
    ],
    cert: fs.readFileSync('/path/to/client-cert.pem'),
    key: fs.readFileSync('/path/to/client-key.pem')
  }
};
```

## Best Practices

1. **Use dedicated service account** with minimal required permissions
2. **Enable LDAPS (SSL/TLS)** for production environments
3. **Implement connection pooling** for better performance
4. **Cache user information** to reduce LDAP queries
5. **Monitor LDAP connections** and implement retry logic
6. **Regular testing** of LDAP connectivity and authentication
7. **Document group structure** and role mappings
8. **Backup LDAP configuration** as part of deployment process

## Integration with Local Authentication

The system seamlessly supports both LDAP and local users:

1. **LDAP users** are automatically created in local database on first login
2. **Local users** can be created via admin interface
3. **Admin elevation** works for both LDAP and local admin accounts
4. **Password changes** for LDAP users must be done in LDAP system
5. **Role assignment** for LDAP users is based on group membership