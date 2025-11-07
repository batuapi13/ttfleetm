# TT Fleet Management System

![Version](https://img.shields.io/badge/version-0.5-blue.svg)
![Node.js](https://img.shields.io/badge/node.js-18.19.1-green.svg)
![License](https://img.shields.io/badge/license-MIT-yellow.svg)

A modern, responsive Fleet Management System built with Node.js, featuring PWA capabilities, LDAP integration, and dual authentication system.

## 🚀 Features

### Core Functionality
- **Vehicle Management**: Add, edit, delete, and track vehicle information
- **Usage Tracking**: Check-in/check-out system with mileage and user tracking
- **Maintenance Records**: Schedule and track vehicle maintenance
- **Document Management**: Store and organize vehicle-related documents
- **User Management**: Role-based access control (Admin/User)
- **Dashboard**: Real-time overview of fleet status and statistics

### Technical Features
- **Progressive Web App (PWA)**: Installable, offline-capable mobile experience
- **Dual Authentication System**: Support for both LDAP and local authentication
- **Responsive Design**: Mobile-first approach with collapsible sidebar
- **Dark/Light Theme**: User preference with persistent storage
- **Real-time Updates**: Live status tracking and notifications
- **JSON Storage**: Simple, lightweight data persistence
- **Session Management**: Secure user sessions with admin elevation

## 🔧 System Requirements

### Server Requirements
- **Operating System**: Linux (Ubuntu 18.04+ recommended)
- **Node.js**: Version 18.19.1 or higher
- **Memory**: Minimum 512MB RAM (1GB recommended)
- **Storage**: Minimum 1GB free space
- **Network**: Internet access for LDAP authentication (if used)

### Dependencies
```bash
# Core dependencies
express ^4.18.0
express-session ^1.17.0
bcryptjs ^2.4.0
body-parser ^1.20.0

# LDAP dependencies (optional)
ldapjs ^3.0.0

# Development dependencies
nodemon ^3.0.0
```

### Browser Support
- **Chrome/Edge**: 90+
- **Firefox**: 88+
- **Safari**: 14+
- **Mobile**: iOS Safari 14+, Chrome Mobile 90+

## 🏗️ Architecture

### System Components
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend       │    │   Storage       │
│   (PWA/SPA)     │◄──►│   (Node.js)     │◄──►│   (JSON Files)  │
│                 │    │                 │    │                 │
│ - React-like UI │    │ - Express.js    │    │ - vehicles.json │
│ - Service Worker│    │ - Session Mgmt  │    │ - users.json    │
│ - Offline Cache │    │ - LDAP Auth     │    │ - usage.json    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                ▲
                                │
                       ┌─────────────────┐
                       │   LDAP Server   │
                       │   (Optional)    │
                       └─────────────────┘
```

## 📋 Installation Guide

### Quick Installation
```bash
# Clone repository
git clone https://github.com/batuapi13/ttfleetm.git
cd ttfleetm

# Run automated setup
chmod +x deploy.sh
./deploy.sh

# Verify installation
./verify-setup.sh
```

### Manual Installation

#### 1. System Preparation
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify installation
node --version  # Should show v18.19.1+
npm --version   # Should show 9.0.0+
```

#### 2. Application Setup
```bash
# Create application directory
sudo mkdir -p /var/www/html/fleet-new
cd /var/www/html/fleet-new

# Clone or copy application files
git clone https://github.com/batuapi13/ttfleetm.git .

# Install dependencies
npm install

# Create data directories
mkdir -p data uploads logs

# Set proper permissions
sudo chown -R $USER:$USER /var/www/html/fleet-new
chmod +x *.sh
```

#### 3. Configuration
```bash
# Copy configuration templates
cp config/ldap-config.example.js config/ldap-config.js
cp config/server-config.example.js config/server-config.js

# Edit configurations as needed
nano config/ldap-config.js
nano config/server-config.js
```

#### 4. Service Setup
```bash
# Install as systemd service
sudo cp scripts/fleet-management.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable fleet-management
sudo systemctl start fleet-management

# Check status
sudo systemctl status fleet-management
```

## 🔐 Authentication Configuration

### Dual Authentication System
The system supports both LDAP and local authentication simultaneously.

#### Local Authentication Setup
```bash
# Default admin user is created automatically
# Username: admin
# Default password: admin123 (change immediately)

# Access admin panel to manage local users
# Navigate to: http://your-server:3000/#/users
```

#### LDAP Authentication Setup

1. **Configure LDAP Connection**:
```javascript
// config/ldap-config.js
module.exports = {
  url: 'ldap://your-ldap-server:389',
  baseDN: 'DC=yourdomain,DC=com',
  username: 'CN=service-account,OU=Service Accounts,DC=yourdomain,DC=com',
  password: 'service-account-password',
  
  // Group mappings
  groups: {
    admin: 'CN=car_admin,OU=Groups,DC=yourdomain,DC=com',
    user: 'CN=car_user,OU=Groups,DC=yourdomain,DC=com'
  },
  
  // User search settings
  userSearchBase: 'OU=Users,DC=yourdomain,DC=com',
  userSearchFilter: '(sAMAccountName={{username}})',
  
  // User attributes
  attributes: {
    username: 'sAMAccountName',
    displayName: 'displayName',
    email: 'mail',
    memberOf: 'memberOf'
  }
};
```

2. **Test LDAP Configuration**:
```bash
# Test LDAP connectivity
node test-ldap.js

# Test with specific user
node test-ldap.js username password
```

#### Authentication Flow
```
Login Attempt
     ↓
┌─────────────┐    NO     ┌─────────────┐
│ LDAP Auth   │ ────────► │ Local Auth  │
│ Available?  │           │ (Fallback)  │
└─────────────┘           └─────────────┘
     │ YES                       │
     ↓                           ↓
┌─────────────┐           ┌─────────────┐
│ LDAP Login  │           │ Local Login │
│ + Group     │           │ (JSON DB)   │
│ Mapping     │           │             │
└─────────────┘           └─────────────┘
     │                           │
     └─────────────┬─────────────┘
                   ↓
            ┌─────────────┐
            │ Session     │
            │ Created     │
            └─────────────┘
```

## 🛠️ Configuration

### Server Configuration
```javascript
// config/server-config.js
module.exports = {
  port: process.env.PORT || 3000,
  sessionSecret: 'your-secure-session-secret',
  environment: process.env.NODE_ENV || 'production',
  
  // File upload limits
  upload: {
    maxFileSize: '10MB',
    allowedTypes: ['image/jpeg', 'image/png', 'application/pdf']
  },
  
  // Security settings
  security: {
    enableHTTPS: false,
    corsOrigins: ['http://localhost:3000'],
    rateLimitWindowMs: 15 * 60 * 1000, // 15 minutes
    rateLimitMax: 100 // limit each IP to 100 requests per windowMs
  }
};
```

### Environment Variables
```bash
# Create .env file
NODE_ENV=production
PORT=3000
SESSION_SECRET=your-very-secure-secret-here
LDAP_ENABLED=true
LOG_LEVEL=info
```

## 🚀 Deployment Options

### Option 1: Direct Server Deployment
```bash
# Use automated deployment script
./deploy.sh

# Manual deployment
npm install --production
sudo systemctl start fleet-management
```

### Option 2: Docker Deployment
```bash
# Build and run with Docker
docker build -t ttfleetm .
docker run -d -p 3000:3000 --name fleet-management ttfleetm

# Or use Docker Compose
docker-compose up -d
```

### Option 3: PM2 Process Manager
```bash
# Install PM2
npm install -g pm2

# Start application
pm2 start ecosystem.config.js

# Setup auto-restart on boot
pm2 startup
pm2 save
```

## 📱 PWA Installation

### Mobile Installation
1. Open the app in Chrome/Safari
2. Tap "Add to Home Screen" when prompted
3. Or manually: Menu → "Install App" or "Add to Home Screen"

### Desktop Installation
1. Open the app in Chrome/Edge
2. Click the install icon in the address bar
3. Or: Menu → "Install TT Fleet Management..."

## 🔧 Usage Guide

### Administrator Tasks

#### Initial Setup
1. **Login with default admin account**
2. **Change default password** (Settings → Change Password)
3. **Configure LDAP** (if using) in config files
4. **Add vehicles** to the fleet
5. **Create/import users** or configure LDAP groups

#### User Management
```bash
# Add local user (via web interface)
Users → Add User → Fill details

# LDAP users are auto-created on first login
# Role assignment based on group membership
```

#### Vehicle Management
```bash
# Add vehicle
Vehicles → Add Vehicle → Fill details
- Registration number
- Make/Model
- Year
- Current mileage
```

### User Tasks

#### Vehicle Check-out
1. Navigate to **Vehicles**
2. Click **"Use"** on available vehicle
3. Enter current mileage
4. Add notes if needed
5. Submit

#### Vehicle Check-in
1. Navigate to **Dashboard** or **Vehicles**
2. Find your vehicle (marked "In Use")
3. Click **"Return"**
4. Enter final mileage
5. Add notes about trip
6. Submit

#### View Usage History
- **Usage Log** → View all trips
- **Vehicles** → Click vehicle → View history

## 🐛 Troubleshooting

### Common Issues

#### LDAP Authentication Not Working
```bash
# Test LDAP connectivity
node test-ldap.js

# Check logs
sudo journalctl -u fleet-management -f

# Common fixes:
1. Verify LDAP server accessibility
2. Check service account permissions
3. Validate group DN paths
4. Ensure firewall allows LDAP ports (389/636)
```

#### Application Won't Start
```bash
# Check service status
sudo systemctl status fleet-management

# View logs
sudo journalctl -u fleet-management -n 50

# Common fixes:
1. Check port availability: netstat -tlnp | grep 3000
2. Verify permissions: ls -la /var/www/html/fleet-new
3. Install dependencies: npm install
```

#### PWA Not Installing
1. **Verify HTTPS** (required for PWA on production)
2. **Check manifest.json** file accessibility
3. **Service worker** must be properly registered
4. **Clear browser cache** and try again

### Log Files
```bash
# Application logs
tail -f logs/app.log

# System service logs
sudo journalctl -u fleet-management -f

# Error logs
tail -f logs/error.log
```

## 🔒 Security Considerations

### Authentication Security
- **Session management** with secure cookies
- **Password hashing** using bcryptjs
- **LDAP integration** with secure binding
- **Role-based access** control (RBAC)

### Data Protection
- **Input validation** and sanitization
- **XSS protection** with Content Security Policy
- **CSRF protection** with session tokens
- **File upload** restrictions and validation

### Network Security
- **HTTPS recommended** for production
- **CORS configuration** for API access
- **Rate limiting** to prevent abuse
- **Secure headers** configuration

## 📊 Monitoring & Maintenance

### Performance Monitoring
```bash
# Monitor system resources
htop

# Check disk usage
df -h

# Monitor logs
tail -f /var/log/syslog
```

### Backup Procedures
```bash
# Backup data
./scripts/backup.sh

# Restore data
./scripts/restore.sh backup-file.tar.gz
```

### Updates
```bash
# Pull latest version
git pull origin main

# Install updates
npm install

# Restart service
sudo systemctl restart fleet-management
```

## 📄 API Documentation

### Authentication Endpoints
```
POST /api/login
POST /api/logout
GET  /api/me
POST /api/admin/elevate
```

### Vehicle Endpoints
```
GET    /api/vehicles
POST   /api/vehicles
PUT    /api/vehicles/:id
DELETE /api/vehicles/:id
```

### Usage Endpoints
```
GET  /api/usage
POST /api/vehicles/:id/use
POST /api/vehicles/:id/return
```

## 🤝 Contributing

### Development Setup
```bash
# Clone repository
git clone https://github.com/batuapi13/ttfleetm.git
cd ttfleetm

# Install dependencies
npm install

# Start development server
npm run dev
```

### Code Standards
- **ESLint** configuration provided
- **Prettier** for code formatting
- **Commit message** format: `type(scope): description`

## 📞 Support

### Documentation
- **README.md** - This file
- **docs/API.md** - API documentation
- **docs/LDAP-SETUP.md** - LDAP configuration guide
- **docs/TROUBLESHOOTING.md** - Common issues and solutions

### Contact
- **Repository**: https://github.com/batuapi13/ttfleetm
- **Issues**: https://github.com/batuapi13/ttfleetm/issues

## 📜 License

MIT License - see LICENSE file for details.

## 🏷️ Version History

### v0.5 (Current)
- Initial release
- Core fleet management functionality
- PWA capabilities
- LDAP integration
- Dual authentication system
- Responsive design with dark/light theme

### Planned Features (v0.6+)
- Photo-based check-in/out with GPS
- OCR for automatic mileage reading
- Advanced reporting and analytics
- Mobile push notifications
- Multi-language support