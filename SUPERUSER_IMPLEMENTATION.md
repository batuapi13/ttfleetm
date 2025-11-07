# Superuser Role Implementation

## Overview
Implemented a **Superuser** role with elevated privileges beyond normal admin users. The superuser (`tapa`) has exclusive access to delete sensitive data including usage logs and users.

## Changes Made

### 1. LDAP Configuration (`ldap-config.js`)
- Added `superuserGroup`: `cn=car_admin_su,ou=groups,dc=tiongmas,dc=my`
- Role hierarchy: **Superuser** > Admin > User

### 2. Backend (`store.js`)
- Updated `checkLDAPGroupMembership()` to recognize superuser group
- Added `deleteUsageLog(id)` method for deleting usage logs
- Role assignment priority: Check superuser first, then admin, then user

### 3. Server API (`server.js`)
- Added `requireSuperuser` middleware (highest privilege check)
- Added `requireAdminOrSuperuser` middleware (for future use)
- Updated `checkAdminPassword` to accept superuser role
- New endpoints:
  - `DELETE /api/usage/:id` - Delete usage log (superuser only)
  - `DELETE /api/users/:id` - Delete user (updated to superuser only)

### 4. Frontend (`/var/www/html/fleet/assets/app.js`)
- Updated `renderUsage()` to show Actions column with Delete button for superusers
- Added `deleteUsageLog(id)` function
- Updated role badge display:
  - Superuser: Red badge
  - Admin: Yellow/Warning badge
  - User: Blue/Info badge

## User Assignment

**Superuser:** `tapa`
- LDAP Group: `cn=car_admin_su,ou=groups,dc=tiongmas,dc=my`
- Privileges:
  - All admin capabilities
  - Delete usage logs
  - Delete any user (including admins)
  - Cannot be deleted by admins

## Security

- All delete operations require **superuser role** verification
- Admin password re-authentication required for destructive operations
- LDAP group membership verified on each login
- API endpoints protected with `requireSuperuser` middleware

## Testing Checklist

1. [ ] Login as `tapa` - should be assigned 'superuser' role
2. [ ] Navigate to Usage Log - should see "Actions" column with Delete buttons
3. [ ] Delete a usage log entry - should prompt for password and delete successfully
4. [ ] Navigate to Users - Delete button should work for superuser
5. [ ] Login as regular admin - should NOT see Delete buttons for usage logs
6. [ ] Verify LDAP group membership: `cn=car_admin_su,ou=groups,dc=tiongmas,dc=my`

## API Endpoints

### Delete Usage Log
```
DELETE /api/usage/:id
Authorization: Superuser role required
Body: { "admin_password": "password" }
```

### Delete User  
```
DELETE /api/users/:id
Authorization: Superuser role required
Body: { "admin_password": "password" }
```

## Future Enhancements

- Audit log for superuser actions
- Bulk delete operations
- Soft delete with recovery option
- Role-based action history

---
**Implementation Date:** November 7, 2025
**Status:** ✅ Complete and Running
