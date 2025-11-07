#!/usr/bin/env node
/**
 * LDAP Connection Test Utility
 * Usage: node test-ldap.js [username] [password]
 */

const ldap = require('ldapjs');
const ldapConfig = require('./ldap-config');

if (!ldapConfig.enabled) {
  console.log('❌ LDAP is disabled in ldap-config.js');
  console.log('Set enabled: true to activate LDAP authentication');
  process.exit(1);
}

const testUsername = process.argv[2];
const testPassword = process.argv[3];

if (!testUsername || !testPassword) {
  console.log('Usage: node test-ldap.js <username> <password>');
  process.exit(1);
}

console.log('🔍 Testing LDAP Connection...');
console.log('Server:', ldapConfig.url);
console.log('Search Base:', ldapConfig.searchBase);
console.log('Username:', testUsername);
console.log('---');

const client = ldap.createClient({
  url: ldapConfig.url,
  ...ldapConfig.options
});

// Bind with service account
console.log('📡 Binding with service account...');
client.bind(ldapConfig.bindDN, ldapConfig.bindPassword, (err) => {
  if (err) {
    console.error('❌ Bind failed:', err.message);
    client.unbind();
    process.exit(1);
  }
  
  console.log('✅ Service account bind successful');
  
  // Search for user
  const searchFilter = ldapConfig.searchFilter.replace('{{username}}', testUsername);
  console.log('🔍 Searching for user with filter:', searchFilter);
  
  const opts = {
    filter: searchFilter,
    scope: 'sub',
    attributes: Object.values(ldapConfig.attributes)
  };
  
  client.search(ldapConfig.searchBase, opts, (err, res) => {
    if (err) {
      console.error('❌ Search failed:', err.message);
      client.unbind();
      process.exit(1);
    }
    
    let userDN = null;
    let userData = {};
    
    res.on('searchEntry', (entry) => {
      userDN = entry.objectName;
      console.log('✅ User found:', userDN);
      console.log('📋 All available attributes:');
      entry.attributes.forEach(attr => {
        console.log(`   ${attr.type}: ${attr.values.join(', ')}`);
      });
      console.log('---');
      
      // Helper function to get attribute value
      const getAttr = (attrName) => {
        const attr = entry.attributes.find(a => a.type === attrName);
        return attr ? attr.values[0] : null;
      };
      
      userData = {
        username: getAttr(ldapConfig.attributes.username),
        full_name: getAttr(ldapConfig.attributes.fullName),
        email: getAttr(ldapConfig.attributes.email) || 'N/A'
      };
      
      console.log('📋 Mapped user attributes:');
      console.log('  - Username:', userData.username);
      console.log('  - Full Name:', userData.full_name);
      console.log('  - Email:', userData.email);
    });
    
    res.on('error', (err) => {
      console.error('❌ Search error:', err.message);
      client.unbind();
      process.exit(1);
    });
    
    res.on('end', () => {
      if (!userDN) {
        console.log('❌ User not found in LDAP');
        client.unbind();
        process.exit(1);
      }
      
      // Test user authentication
      console.log('🔐 Testing user authentication...');
      console.log('   Binding as:', userDN.toString());
      client.bind(userDN.toString(), testPassword, (err) => {
        client.unbind();
        
        if (err) {
          console.log('❌ Authentication failed:', err.message);
          console.log('   Error code:', err.code);
          process.exit(1);
        }
        
        console.log('✅ Authentication successful!');
        console.log('---');
        console.log('✨ LDAP configuration is working correctly');
        process.exit(0);
      });
    });
  });
});

client.on('error', (err) => {
  console.error('❌ LDAP connection error:', err.message);
  process.exit(1);
});
