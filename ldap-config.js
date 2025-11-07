// LDAP Configuration Example
// Copy this file to ldap-config.js and modify for your environment

module.exports = {
  enabled: false, // DISABLED for security - configure manually if needed
  
  // LDAP Server Settings  
  url: process.env.LDAP_URL || 'ldap://your-ldap-server:389',
  
  // Bind DN - account used to search for users
  bindDN: process.env.LDAP_BIND_DN || 'uid=service-account,ou=people,dc=yourdomain,dc=com',
  bindPassword: process.env.LDAP_BIND_PASSWORD || 'your-service-account-password',
  
  // Search settings
  searchBase: 'ou=people,dc=yourdomain,dc=com', // Where to search for users
  searchFilter: '(uid={{username}})', // {{username}} will be replaced with login username
  // Alternative for Active Directory: '(sAMAccountName={{username}})'
  // Alternative for email login: '(mail={{username}})'
  
  // Attribute mapping - map LDAP attributes to application fields
  attributes: {
    username: 'uid', // LDAP attribute for username (sAMAccountName for AD)
    fullName: 'cn', // Common name / display name
    email: 'mail', // Email address
    // Add other attributes as needed
  },
  
  // User role mapping (optional)
  // Map LDAP group membership to application roles
  roleMapping: {
    enabled: true, // Set to true to enable role mapping
    adminGroup: 'cn=admin_group,ou=groups,dc=yourdomain,dc=com', // LDAP group for admin users
    userGroup: 'cn=user_group,ou=groups,dc=yourdomain,dc=com', // LDAP group for regular users
  },
  
  // Connection options
  options: {
    timeout: 5000, // Connection timeout in milliseconds
    connectTimeout: 10000,
    reconnect: true,
  },
  
  // Fallback to local accounts
  allowLocalAuth: true, // If true, fall back to local auth when LDAP fails or user not found
};
