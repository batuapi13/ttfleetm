# TT Fleet Management System - User Manual

## Table of Contents
1. [Getting Started](#getting-started)
2. [Installing the App](#installing-the-app)
3. [Logging In](#logging-in)
4. [Dashboard Overview](#dashboard-overview)
5. [Managing Vehicles](#managing-vehicles)
6. [Using a Vehicle](#using-a-vehicle)
7. [Returning a Vehicle](#returning-a-vehicle)
8. [Viewing Usage History](#viewing-usage-history)
9. [Recording Maintenance](#recording-maintenance)
10. [Managing Documents](#managing-documents)
11. [Changing Your Password](#changing-your-password)
12. [Troubleshooting](#troubleshooting)

---

## Getting Started

### What is TT Fleet Management?
TT Fleet Management is a mobile-friendly application that helps you:
- Check vehicles in and out
- Track mileage
- Record maintenance
- Store vehicle documents
- View fleet status in real-time

### Who can use it?
- **All Staff**: Can check out vehicles, view usage history
- **Administrators**: Can manage vehicles, users, and all records

---

## Installing the App

### On iPhone/iPad (iOS)
1. Open **Safari** browser
2. Go to your fleet management website
3. Tap the **Share** button (square with arrow)
4. Scroll down and tap **"Add to Home Screen"**
5. Tap **"Add"**
6. The **TT Fleet** icon will appear on your home screen

### On Android Phone/Tablet
1. Open **Chrome** browser
2. Go to your fleet management website
3. Tap the **menu** (⋮ three dots)
4. Tap **"Add to Home screen"** or **"Install app"**
5. Tap **"Install"** or **"Add"**
6. The **TT Fleet** icon will appear on your home screen

**Tip**: After installing, tap the home screen icon to use the app like a native application!

---

## Logging In

### Step 1: Open the App
- Tap the **TT Fleet** icon on your home screen
- Or visit the website in your browser

### Step 2: Enter Your Credentials
- **Username**: Your company username
- **Password**: Your company password

### Step 3: Log In
- Tap the **"Login"** button
- You'll see the Dashboard

### Forgot Password?
- Tap **"🔑 Forgot Password / Change Password?"** link
- This will open your company's password management page
- Follow the instructions to reset your password

---

## Dashboard Overview

The Dashboard shows you:

### Vehicle Statistics
- **Total Vehicles**: How many vehicles in the fleet
- **In Use**: How many are currently checked out
- **Available**: How many are ready to use

### Fleet Overview Table
Shows all vehicles with:
- **Registration**: License plate number (e.g., WA2685D)
- **Vehicle**: Make and model (e.g., Proton Saga FLX)
- **Current Mileage**: Last recorded reading
- **Status**: Available / In Use
- **In Use By**: Who's using it (if checked out)
- **Next Service**: When service is due
  - 🟢 **Green**: Service due in 2,000+ km
  - 🟡 **Yellow**: Service due in 500-2,000 km
  - 🔴 **Red**: Service overdue or due soon

---

## Managing Vehicles

**(Admin Only)**

### Adding a New Vehicle
1. Tap **"Vehicles"** in the menu
2. Tap the **➕ Add Vehicle** button
3. Fill in the details:
   - **Registration Number** (required)
   - **Make** (e.g., Toyota)
   - **Model** (e.g., Hilux)
   - **Year** (e.g., 2020)
   - **Current Mileage** (e.g., 45000)
   - **Next Service Mileage** (e.g., 50000)
   - **Status** (Available/In Service/Out of Service)
4. Tap **"Add Vehicle"**

### Editing a Vehicle
1. Go to **"Vehicles"**
2. Find the vehicle
3. Tap the **✏️ Edit** button
4. Update the information
5. Tap **"Update Vehicle"**

### Setting Next Service Mileage
1. Go to **"Vehicles"**
2. Find the vehicle
3. In the **"Next Service Mileage"** column, tap the number
4. Type the new mileage when service is due
5. Tap **Enter** or click away to save

---

## Using a Vehicle

### Step 1: Go to Vehicles
- Tap **"Vehicles"** in the menu
- Or use the **"Vehicle List"** on the Dashboard

### Step 2: Select a Vehicle
- Find an **Available** vehicle
- Tap the **"Use"** button

### Step 3: Fill in Details
- **Mileage Reading**: Enter the current odometer reading
- **Notes** (optional): Where you're going, purpose of trip

### Step 4: Submit
- Tap **"Check Out"**
- The vehicle status changes to **"In Use"**
- Your name appears next to the vehicle

---

## Returning a Vehicle

### Step 1: Find Your Vehicle
- Go to **Dashboard** or **Vehicles**
- Find the vehicle showing your name

### Step 2: Return the Vehicle
- Tap the **"Return"** button

### Step 3: Enter Final Mileage
- **Final Mileage**: Enter the odometer reading
- The system shows distance traveled
- **Notes** (optional): Any issues, refueling done, etc.

### Step 4: Submit
- Tap **"Check In"**
- Vehicle returns to **"Available"** status

**Important**: Always record accurate mileage!

---

## Viewing Usage History

### View All Usage
1. Tap **"Usage Log"** in the menu
2. See all check-in/check-out records with:
   - Who used the vehicle
   - When they checked out/in
   - Mileage at start and end
   - Distance traveled
   - Any notes

### View Vehicle-Specific History
1. Go to **"Vehicles"**
2. Find the vehicle
3. Tap the vehicle name
4. See all usage history for that vehicle

---

## Recording Maintenance

**(Admin Only)**

### Adding Maintenance Record
1. Tap **"Maintenance"** in the menu
2. Tap **"➕ Add Maintenance"** button
3. Fill in:
   - **Vehicle**: Select from dropdown
   - **Date**: When service was done
   - **Mileage**: Odometer reading at service
   - **Type**: Oil Change, Tire Replacement, Inspection, etc.
   - **Cost**: Amount spent (optional)
   - **Notes**: What was done, parts replaced

4. Tap **"Add Maintenance"**

### Viewing Maintenance History
1. Go to **"Maintenance"**
2. See all service records
3. Filter by vehicle if needed

---

## Managing Documents

**(Admin Only)**

### Uploading Documents
1. Tap **"Documents"** in the menu
2. Tap **"➕ Upload Document"**
3. Choose:
   - **Vehicle**: Which vehicle (or Company-wide)
   - **Document Type**: Insurance, Registration, Manual, etc.
   - **File**: Select PDF or image
   - **Expiry Date** (optional): For insurance, registration

4. Tap **"Upload"**

### Viewing Documents
1. Go to **"Documents"**
2. Browse all uploaded files
3. Tap to view or download

---

## Changing Your Password

### For LDAP Users (Most Users)
1. Tap the **☰ menu** button
2. Tap **"🔑 Change Password"**
3. You'll be directed to the company password portal
4. Follow the instructions there

### For Local Admin Users
1. Tap the **☰ menu** button
2. Tap **"🔑 Change Password"**
3. Enter:
   - **Current Password**
   - **New Password** (minimum 6 characters)
   - **Confirm New Password**
4. Tap **"Change Password"**

---

## Troubleshooting

### App Not Loading?
- **Check internet connection**
- **Force refresh**: Pull down on the screen
- **Clear cache**: Settings → Apps → TT Fleet → Clear cache

### Changes Not Showing on Mobile?
- **Force close the app** and reopen
- **Wait 60 seconds** - app auto-updates
- **Reinstall the app** (uninstall and re-add to home screen)

### Can't Log In?
- **Check username and password** (no spaces)
- **Contact your IT admin** for password reset
- **Check internet connection** (required for login)

### Vehicle Still Shows "In Use"?
- Check if you properly **checked in** the vehicle
- Ask admin to check the **Usage Log**
- Admin can manually update if needed

### Can't See Admin Features?
- Check with your admin - you may not have admin permissions
- LDAP users: Check you're in the correct group

### App Opens Browser Instead of Full Screen?
**Android Users:**
1. **Uninstall the current app** (long-press icon → Remove)
2. **Clear browser cache**:
   - Chrome: Settings → Privacy → Clear browsing data
   - Select "All time" and "Cached images and files"
3. **Reinstall from browser** (Menu → Add to Home screen)

### Icons Not Showing Correctly?
- **Clear browser cache** and reinstall
- Make sure you're using the latest version

### Service Indicators Not Updating?
- Go to **Vehicles** page
- Admin: Update **"Next Service Mileage"** column
- Indicators update based on current mileage vs. next service

---

## Quick Tips

✅ **Always** record accurate mileage  
✅ **Check** vehicle condition before and after use  
✅ **Report** any issues in the notes  
✅ **Return** vehicles promptly after use  
✅ **Update** next service mileage after maintenance  
✅ **Use** the app from home screen for best experience  
✅ **Keep** your password secure  

---

## Need Help?

- **Technical Issues**: Contact your IT administrator
- **App Questions**: Refer to this manual
- **Password Problems**: Use the "Forgot Password" link

---

**Version**: 1.0 | **Last Updated**: November 2025  
**Tiongmas Technologies** | TT Fleet Management System
