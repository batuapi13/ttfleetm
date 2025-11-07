# Superuser Permissions - FIXED

## Problem Found
Superuser role had LESS access than admin because:
- Documents page required `requireAdmin` → blocked superusers
- Users page required `requireAdmin` → blocked superusers  
- Frontend showed admin features only if `role === 'admin'` → hidden from superusers

## Solution Applied

### Backend Changes (`/opt/ttfleetm/server.js`)
Changed all admin-protected endpoints to use `requireAdminOrSuperuser`:

**Before:**
```javascript
app.get('/api/documents', requireAuth, requireAdmin, ...)
app.get('/api/users', requireAuth, requireAdmin, ...)
```

**After:**
```javascript
app.get('/api/documents', requireAuth, requireAdminOrSuperuser, ...)
app.get('/api/users', requireAuth, requireAdminOrSuperuser, ...)
```

### Frontend Changes (`/opt/ttfleetm/public/assets/app.js`)
Updated all role checks to include superuser:

**Before:**
```javascript
if (state.user.role === 'admin') {
  // show admin features
}
```

**After:**
```javascript
if (state.user.role === 'admin' || state.user.role === 'superuser') {
  // show admin features
}
```

## Permission Matrix (Current)

| Feature | User | Admin | Superuser |
|---------|------|-------|-----------|
| Dashboard | ✅ | ✅ | ✅ |
| View Vehicles | ✅ | ✅ | ✅ |
| Add/Edit Vehicles | ❌ | ✅ | ✅ |
| Delete Vehicles | ❌ | ✅ | ✅ |
| Log Usage | ✅ | ✅ | ✅ |
| **Delete Usage Logs** | ❌ | ❌ | ✅ |
| View Maintenance | ✅ | ✅ | ✅ |
| Add Maintenance | ❌ | ✅ | ✅ |
| View Documents | ❌ | ✅ | ✅ |
| Add Documents | ❌ | ✅ | ✅ |
| View Users | ❌ | ✅ | ✅ |
| Add/Edit Users | ❌ | ✅ | ✅ |
| **Delete Users** | ❌ | ❌ | ✅ |

## Superuser Exclusive Powers

**Superuser can do everything Admin can PLUS:**
- ✅ Delete usage logs (including logs from other users)
- ✅ Delete any user (including other admins)
- ✅ These actions require password re-authentication

## Testing

1. **Logout and login as tapa (superuser)**
2. **Check all pages are accessible:**
   - Dashboard ✅
   - Vehicles ✅
   - Usage Log ✅ (with Delete buttons)
   - Maintenance ✅
   - **Documents ✅** (now accessible!)
   - **Users ✅** (now accessible!)
3. **Verify delete functions work**

---

**Status:** ✅ Fixed and deployed
**Date:** November 7, 2025 15:00
