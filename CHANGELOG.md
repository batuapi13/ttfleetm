# TT Fleet Management System - Change Log

## Version 0.5.0 (2025-11-07)

### Initial Release

#### New Features
- **Complete Fleet Management System**: Vehicle tracking, usage monitoring, maintenance records
- **Dual Authentication System**: Support for both LDAP and local authentication
- **Progressive Web App (PWA)**: Installable mobile experience with offline capabilities
- **Responsive Design**: Mobile-first approach with collapsible sidebar navigation
- **Dark/Light Theme**: User preference with persistent storage
- **Real-time Dashboard**: Live fleet status and statistics
- **User Management**: Role-based access control (Admin/User roles)
- **Document Management**: File upload and storage for vehicle documents
- **Maintenance Tracking**: Complete maintenance history and scheduling
- **Usage Logging**: Detailed check-in/check-out system with mileage tracking

#### Technical Features
- **Node.js Backend**: Express.js with session management
- **JSON Storage**: Lightweight file-based data persistence
- **LDAP Integration**: Active Directory and OpenLDAP support
- **Group-based Role Mapping**: Automatic role assignment from LDAP groups
- **Admin Elevation**: Password-based privilege escalation
- **Session Security**: Secure cookie handling and authentication
- **API Documentation**: Complete REST API with endpoint documentation

#### Deployment Features
- **Automated Deployment**: One-command setup script
- **Docker Support**: Container deployment with Docker Compose
- **Systemd Integration**: System service with auto-restart
- **Health Monitoring**: Built-in health checks and logging
- **Backup System**: Automated data backup and recovery
- **Verification Tools**: Installation verification and troubleshooting

#### Documentation
- **Comprehensive README**: Installation and usage guide
- **API Documentation**: Complete endpoint reference
- **LDAP Setup Guide**: Detailed configuration instructions
- **Troubleshooting Guide**: Common issues and solutions
- **Deployment Guide**: Multiple deployment options

#### Security
- **Secure Authentication**: bcrypt password hashing
- **Session Management**: Secure session handling
- **Input Validation**: XSS and injection protection
- **File Upload Security**: Type and size restrictions
- **LDAP Security**: Secure binding and group validation

#### User Experience
- **Mobile Optimized**: Touch-friendly interface
- **Offline Support**: PWA with service worker caching
- **Responsive Design**: Works on desktop, tablet, and mobile
- **Intuitive Navigation**: Clear menu structure and navigation
- **Real-time Updates**: Live status indicators
- **Dark Mode**: Eye-friendly dark theme option

### System Requirements
- **Node.js**: 18.19.1 or higher
- **Operating System**: Linux (Ubuntu 18.04+ recommended)
- **Memory**: 512MB minimum, 1GB recommended
- **Storage**: 1GB minimum free space
- **Network**: Internet access for LDAP (if used)

### Browser Support
- **Chrome/Edge**: 90+
- **Firefox**: 88+
- **Safari**: 14+
- **Mobile**: iOS Safari 14+, Chrome Mobile 90+

### Breaking Changes
- None (Initial release)

### Migration Notes
- None (Initial release)

### Known Issues
- None reported

### Future Roadmap (v0.6+)
- **Photo-based Check-in**: Camera integration for mileage verification
- **GPS Tracking**: Location-based vehicle monitoring
- **OCR Integration**: Automatic mileage reading from photos
- **Advanced Reporting**: Analytics and usage reports
- **Push Notifications**: Mobile notifications for maintenance and updates
- **Multi-language Support**: Internationalization
- **Advanced LDAP Features**: Nested group support, multiple domains
- **Backup Encryption**: Encrypted backup storage
- **Audit Logging**: Detailed activity logs
- **Custom Fields**: Configurable vehicle and user fields

## Development Team

**Tiongmas Technologies**
- Lead Developer: System Architecture and Implementation
- LDAP Integration: Authentication and directory services
- Frontend Development: PWA and responsive design
- Documentation: Technical writing and user guides

## Credits

### Technology Stack
- **Node.js**: JavaScript runtime
- **Express.js**: Web application framework
- **bcryptjs**: Password hashing library
- **ldapjs**: LDAP client library
- **Bootstrap Icons**: Icon library
- **Service Workers**: PWA functionality

### Testing Environment
- **Ubuntu Server**: Development and testing platform
- **Active Directory**: LDAP testing environment
- **Mobile Devices**: Cross-platform testing
- **Docker**: Container testing

## Support

For support, documentation, and updates:
- **GitHub Repository**: https://github.com/batuapi13/ttfleetm
- **Issue Tracker**: https://github.com/batuapi13/ttfleetm/issues
- **Documentation**: README.md and docs/ directory

## License

MIT License - See LICENSE file for details.
## Version 0.6.0 (2025-11-07)

### New Features

#### Dashboard Enhancements
- **Current Mileage Display**: Added column showing latest mileage reading from usage logs
- **Next Service Due**: Visual indicator with color-coded status
  - 🟢 Green: Service due in 2,000+ km  
  - 🟡 Yellow: Service due in 500-2,000 km
  - 🔴 Red: Service overdue or due within 500 km
- **Real-time Status Calculation**: Vehicle status now calculated from actual usage logs instead of stale database fields

#### Vehicle Management Improvements
- **Next Service Mileage**: Added editable column in Vehicles page for easy service scheduling
- **Live Status Sync**: Vehicle availability status now synchronized across Dashboard and Vehicles pages
- **Inline Editing**: Click-to-edit functionality for next service mileage

#### Password Management
- **Forgot Password Link**: Added on login page directing to LLDAP web interface (id.tiongmas.my)
- **Change Password Feature**: 
  - LDAP users: Redirected to company password portal
  - Local admin users: In-app password change with validation
  - Minimum 6 characters requirement
  - bcrypt password hashing
- **Password Security**: Current password verification before allowing changes

#### Progressive Web App (PWA) Enhancements
- **Android Optimization**: 
  - Fixed standalone mode to prevent opening in browser
  - Added all required icon sizes (72, 96, 128, 144, 152, 192, 384, 512)
  - Proper maskable icons for Android adaptive icons
  - Enhanced manifest.json with PWA-specific parameters
- **iOS Improvements**:
  - Apple-mobile-web-app-capable meta tags
  - Black-translucent status bar style
  - Proper apple-touch-icon references
- **App Branding**:
  - Changed name to "TT Fleet Management" (full) / "TT Fleet" (short)
  - Orange theme color (#ff9500)
  - Favicon with truck icon and "TT" branding
- **Install Prompt Banner**: 
  - Auto-appears 2 seconds after login on non-installed devices
  - One-click installation for mobile users
  - Auto-dismisses after 15 seconds if not acted upon

### Mobile Improvements

#### Cache Strategy Overhaul
- **Network-First for Assets**: CSS and JS files always fetch fresh content
- **ETag-Based Validation**: Server validates cached content before serving
- **Auto-Update Mechanism**: 
  - Checks for new service worker every 60 seconds
  - Auto-reloads page when new version detected
  - Users always get latest version within 1 minute
- **Cache Version Management**: Incremental cache versioning (fleet-v1 through fleet-v9)
- **Logout Cache Clearing**: 
  - Unregisters all service workers
  - Deletes all caches
  - Clears session storage (preserves theme preference)

#### Mobile UI Fixes
- **Hamburger Menu Close Button**: 
  - Fixed X button not responding on mobile
  - Added null checks for event listeners
  - Added z-index and pointer-events for clickability
  - Improved event handling with preventDefault and stopPropagation
- **Touch Optimization**: Better touch targets for mobile devices
- **Responsive Header**: "TT Fleet" branding visible on all screen sizes

### Technical Improvements

#### Data Synchronization
- **Usage Log Integration**: All vehicle status now derived from usage logs (source of truth)
- **Dashboard Data Consistency**: Eliminated conflicting data between pages
- **Real-time Status Updates**: Status calculated on-the-fly from latest checkout/checkin

#### Service Worker Updates
- **Progressive Enhancement**: Better offline support and caching strategy
- **Version Control**: fleet-v9-1762509788 (with automated versioning)
- **Message Handling**: SKIP_WAITING and CLEAR_CACHES message support
- **Cache Management**: Automatic cleanup of old cache versions

#### Security Enhancements
- **Password Validation**: Enforced minimum 6 character requirement
- **bcrypt Integration**: Secure password hashing for local users
- **Session Protection**: Password change requires current password verification
- **LDAP Separation**: LDAP users cannot change passwords locally (redirected to LLDAP)

### Bug Fixes

#### Critical Fixes
- **Vehicle Status Synchronization**: Fixed vehicles showing "Available" on Vehicles page while "In Use" on Dashboard
- **Next Service Data**: Dashboard now correctly pulls next_service_mileage from vehicle data
- **Mobile Cache Issues**: Resolved 24-hour cache causing mobile devices to show outdated content
- **PWA Installation**: Fixed Android devices opening browser instead of standalone app

#### UI Fixes
- **Hamburger Menu**: X button now properly closes sidebar on mobile devices
- **Service Indicators**: Correct calculation based on current mileage vs next service
- **Status Display**: Accurate "In Use By" information from actual usage logs
- **Icon Display**: Proper favicon and app icons across all devices and browsers

### Documentation

#### New Documentation
- **USER_MANUAL.md**: Comprehensive end-user guide with:
  - Step-by-step installation instructions (iOS and Android)
  - Login and authentication guide
  - Dashboard overview
  - Vehicle check-in/check-out procedures
  - Admin features walkthrough
  - Troubleshooting section
  - Quick tips for daily use

#### Updated Documentation
- **README.md**: Updated with new features and capabilities
- **CHANGELOG.md**: Detailed version history with all changes

### Deployment Changes
- **Service Worker Cache**: Version bumped to fleet-v9-1762509788
- **Manifest Updates**: Enhanced PWA manifest with proper Android support
- **Icon Assets**: Added complete icon set (72px to 512px)
- **Meta Tags**: Comprehensive PWA meta tags for cross-platform support

### Browser Compatibility
Tested and verified on:
- ✅ Chrome (Android): Full PWA support, standalone mode
- ✅ Safari (iOS): Full PWA support, home screen installation
- ✅ Samsung Internet: PWA installation working
- ✅ Firefox (Android): PWA support confirmed
- ✅ Edge (Android): Chromium-based, full support
- ✅ Opera/Brave: PWA-compatible

### Known Issues Resolved
- ❌ Mobile cache showing old content → ✅ Fixed with network-first strategy
- ❌ Android PWA opening browser → ✅ Fixed with proper manifest configuration
- ❌ Vehicle status inconsistency → ✅ Fixed with usage log-based calculation
- ❌ Service indicators not updating → ✅ Fixed with real-time data from vehicles
- ❌ Hamburger menu close button → ✅ Fixed with improved event handling
- ❌ Wrong app name on Android → ✅ Fixed with proper manifest and meta tags

### Migration Notes
- **No breaking changes**: All existing data and functionality preserved
- **Auto-update**: Users will automatically get new version within 60 seconds
- **Cache clear recommended**: For best experience, users should clear browser cache
- **PWA reinstall suggested**: Android users should reinstall PWA for proper standalone mode

### Performance Improvements
- **Faster updates**: Network-first strategy ensures fresh content
- **Better offline support**: Intelligent caching with fallback strategies
- **Reduced cache size**: Cleaned up old cache versions automatically
- **Optimized icons**: Multiple sizes for faster loading on different devices

### Future Roadmap (v0.7+)
- Photo-based check-in with GPS coordinates
- OCR for automatic mileage reading
- Push notifications for maintenance reminders
- Advanced analytics and reporting
- Multi-language support
- Custom fields configuration

### Credits
**Tiongmas Technologies** - Development and Implementation
- LDAP integration and authentication
- PWA optimization for cross-platform support
- Mobile-first responsive design
- Cache strategy and performance optimization

### Support
- **Repository**: https://github.com/batuapi13/ttfleetm
- **Issues**: https://github.com/batuapi13/ttfleetm/issues
- **Documentation**: README.md, USER_MANUAL.md

