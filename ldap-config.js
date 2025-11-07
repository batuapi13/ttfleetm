// LDAP Configuration
// Configure this file based on your LDAP/Active Directory server

module.exports = {
  enabled: true, // Set to true to enable LDAP authentication
  
  // LDAP Server Settings
  url: 'ldap://192.168.0.20:3890', // your actual LDAP server
  
  // Bind DN - account used to search for users
  // IMPORTANT: You should change this password after the security incident
  bindDN: 'uid=bindsvc,ou=people,dc=tiongmas,dc=my',
  bindPassword: 'Lobak!123', // TODO: CHANGE THIS PASSWORD IMMEDIATELY
  
  // Search settings
  searchBase: 'ou=people,dc=tiongmas,dc=my', // Where to search for users
  searchFilter: '(uid={{username}})', // {{username}} will be replaced with login username
  
  // Attribute mapping - map LDAP attributes to application fields
  attributes: {
    username: 'uid', // LDAP attribute for username
    fullName: 'cn', // Common name / display name
    email: 'mail', // Email address
  },
  
  // User role mapping (optional)
  // Map LDAP group membership to application roles
  roleMapping: {
    enabled: true, // Set to true to enable role mapping
    superuserGroup: 'cn=car_admin_su,ou=groups,dc=tiongmas,dc=my', // LDAP group for superuser (highest privilege)
    adminGroup: 'cn=car_admin,ou=groups,dc=tiongmas,dc=my', // LDAP group for admin users
    userGroup: 'cn=car_user,ou=groups,dc=tiongmas,dc=my', // LDAP group for regular users
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
