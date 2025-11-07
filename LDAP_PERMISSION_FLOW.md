# LDAP Permission Flow - Always Fresh from LDAP

## How It Works Now (After Fix)

### Every Login Process:

1. **User enters username/password**
2. **LDAP Authentication happens**:
   - Binds to LDAP server
   - Searches for user in `ou=people,dc=tiongmas,dc=my`
   - Authenticates with user's password
   - **Queries LDAP groups** to find which groups user belongs to
   
3. **Role Assignment from LDAP Groups** (checked in order):
   ```javascript
   // Check superuser group FIRST
   if (user in cn=car_admin_su,ou=groups) → role = 'superuser'
   
   // Then check admin group
   else if (user in cn=car_admin,ou=groups) → role = 'admin'
   
   // Then check user group
   else if (user in cn=car_user,ou=groups) → role = 'user'
   
   // Default
   else → role = 'user'
   ```

4. **Fresh LDAP Data Returned to Session**:
   - The role comes **directly from LDAP group membership**
   - Local database is updated but **NOT used** for the session
   - Session gets: `{ username, full_name, role: <from LDAP>, ldap_user: true }`

5. **Local Database Role Also Updated**:
   - If role changed in LDAP, local DB is synced
   - Console logs: `"Updating tapa role from admin to superuser"`
   - This keeps the local DB in sync but **doesn't affect current session**

## Key Points

✅ **Permissions ARE pulled from LDAP every login**
✅ **No caching of roles between sessions**
✅ **LDAP is the source of truth**
✅ **Local DB is just a mirror for reference**

## What This Means

- **Change role in LDAP** → Next login uses new role immediately
- **Add user to `car_admin_su`** → Next login they are superuser
- **Remove from `car_admin_su`** → Next login they lose superuser access
- **No system restart needed** → Changes take effect on next login

## Testing Role Changes

### Scenario: Promote user from admin to superuser

1. In LDAP: Add user to `cn=car_admin_su,ou=groups,dc=tiongmas,dc=my`
2. User logs out of fleet system
3. User logs back in
4. System queries LDAP → finds user in `car_admin_su` → assigns 'superuser'
5. User now has delete permissions immediately

### Scenario: Demote superuser to regular user

1. In LDAP: Remove user from `cn=car_admin_su` and `cn=car_admin`
2. In LDAP: Ensure user is in `cn=car_user`
3. User logs out
4. User logs back in
5. System queries LDAP → finds user only in `car_user` → assigns 'user'
6. User loses admin/superuser permissions immediately

## Verification

Check logs after login to see LDAP group detection:
```bash
sudo journalctl -u fleet-management -f | grep "LDAP:"
```

You'll see:
```
LDAP: User is member of: cn=car_admin,ou=groups,dc=tiongmas,dc=my
LDAP: User is member of: cn=car_admin_su,ou=groups,dc=tiongmas,dc=my
LDAP: User role assigned: superuser
```

If role changed:
```
Updating tapa role from admin to superuser
```

---

**Bottom Line:** Permissions are 100% controlled by LDAP group membership and pulled fresh on every login. ✅
