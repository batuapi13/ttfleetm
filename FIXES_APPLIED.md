# Fixes Applied - November 7, 2025

## Issues Fixed

### 1. ✅ Header "Welcome" Text Behind Menu Bar
**Problem:** When sidebar is open, the header title "Welcome tapa" goes behind the sidebar.

**Fix:** Updated header z-index from 100 to 250 (sidebar is z-index 200)
- File: `/var/www/html/fleet/assets/style.css`
- Line 119: Changed `z-index: 100;` to `z-index: 250;`

### 2. 🔍 Delete Buttons Not Showing in Usage Log
**Problem:** Logged in as tapa, but cannot see delete buttons in usage log.

**Root Cause:** Likely tapa is NOT in the `car_admin_su` LDAP group yet.

**Debug Features Added:**
1. Header now shows role: "Welcome tapa [admin]" or "Welcome tapa [superuser]"
2. Console logging in browser (press F12 to see):
   - Shows current user role
   - Shows if superuser check passes

**What to Check:**
```bash
# Run this to check LDAP groups:
bash /tmp/check_tapa_ldap.sh
```

## Expected Behavior

### If tapa is in `car_admin_su` group:
- Header shows: "Welcome tapa [superuser]"
- Usage Log shows "Actions" column with Delete buttons
- Console shows: "Is superuser? true"

### If tapa is NOT in `car_admin_su` group yet:
- Header shows: "Welcome tapa [admin]" (or [user])
- NO Actions column in Usage Log
- Console shows: "Is superuser? false"

## How to Fix If tapa Not in Superuser Group

You need to add tapa to the LDAP group on your LDAP server:

```bash
# Example with ldapmodify (adjust for your LDAP setup)
ldapmodify -x -D "cn=admin,dc=tiongmas,dc=my" -W << EOF
dn: cn=car_admin_su,ou=groups,dc=tiongmas,dc=my
changetype: modify
add: member
member: uid=tapa,ou=people,dc=tiongmas,dc=my
