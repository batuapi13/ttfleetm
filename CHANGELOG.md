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