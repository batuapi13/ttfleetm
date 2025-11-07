# TIONGMAS Logo Upload Instructions

## Replace Placeholder Logos

To upload your actual TIONGMAS logo, replace these files:

### Login Screen Logo (Large)
```bash
# Upload your logo as:
/var/www/html/fleet-new/public/assets/tiongmas-logo-login.png
# Recommended size: 300x120 pixels
```

### Header Logo (Small)  
```bash
# Upload your logo as:
/var/www/html/fleet-new/public/assets/tiongmas-logo-header.png
# Recommended size: 200x80 pixels
```

## Upload Methods

### 1. Via SCP (from your computer)
```bash
scp tiongmas-logo-large.png tapa@your-server:/var/www/html/fleet-new/public/assets/tiongmas-logo-login.png
scp tiongmas-logo-small.png tapa@your-server:/var/www/html/fleet-new/public/assets/tiongmas-logo-header.png
```

### 2. Via Server Terminal
```bash
# If you have the files on the server:
cp /path/to/your/logo.png /var/www/html/fleet-new/public/assets/tiongmas-logo-login.png
cp /path/to/your/logo.png /var/www/html/fleet-new/public/assets/tiongmas-logo-header.png
```

### 3. Via File Manager
- Navigate to: `/var/www/html/fleet-new/public/assets/`
- Replace the placeholder PNG files with your actual logo files
- Keep the same filenames

## Current Features
✨ Rounded corners with elegant shadows
✨ Subtle glow animations  
✨ Responsive sizing for mobile
✨ Hover effects
✨ Brand color highlighting (#F5B942)
✨ Dark theme support

The placeholder will automatically be replaced once you upload your files!