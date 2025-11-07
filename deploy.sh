#!/bin/bash

# TT Fleet Management System - Deployment Script
# Version: 0.5
# Description: Automated deployment script for production environment

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="ttfleetm"
APP_DIR="/var/www/html/fleet-new"
SERVICE_NAME="fleet-management"
USER="tapa"
GROUP="www-data"
NODE_VERSION="18.19.1"

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_error "This script should not be run as root. Please run as regular user."
        exit 1
    fi
}

check_node() {
    log_info "Checking Node.js installation..."
    
    if command -v node &> /dev/null; then
        NODE_CURRENT=$(node --version)
        log_info "Node.js version: $NODE_CURRENT"
        
        # Check if version is >= 18
        NODE_MAJOR=$(echo $NODE_CURRENT | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$NODE_MAJOR" -lt 18 ]; then
            log_warning "Node.js version $NODE_CURRENT is below recommended version 18.x"
            read -p "Continue anyway? (y/N): " confirm
            if [[ ! $confirm =~ ^[Yy]$ ]]; then
                exit 1
            fi
        fi
    else
        log_error "Node.js is not installed. Please install Node.js 18+ first."
        log_info "Run: curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt-get install -y nodejs"
        exit 1
    fi
}

check_dependencies() {
    log_info "Checking system dependencies..."
    
    # Check npm
    if ! command -v npm &> /dev/null; then
        log_error "npm is not installed"
        exit 1
    fi
    
    # Check git
    if ! command -v git &> /dev/null; then
        log_warning "git is not installed, installing..."
        sudo apt update && sudo apt install -y git
    fi
    
    log_success "Dependencies check completed"
}

setup_directories() {
    log_info "Setting up directories..."
    
    cd "$APP_DIR"
    
    # Create necessary directories
    mkdir -p data logs uploads config scripts
    
    # Create uploads .gitkeep
    touch uploads/.gitkeep
    
    # Set proper permissions
    sudo chown -R $USER:$GROUP "$APP_DIR"
    chmod -R 755 "$APP_DIR"
    chmod -R 775 data logs uploads
    
    log_success "Directories setup completed"
}

install_dependencies() {
    log_info "Installing Node.js dependencies..."
    
    cd "$APP_DIR"
    
    # Install production dependencies
    npm install --production
    
    # Install development dependencies if in development mode
    if [ "$NODE_ENV" = "development" ]; then
        npm install
    fi
    
    log_success "Dependencies installation completed"
}

create_config_files() {
    log_info "Creating configuration files..."
    
    cd "$APP_DIR"
    
    # Create LDAP config if it doesn't exist
    if [ ! -f "ldap-config.js" ]; then
        cat > ldap-config.js << 'EOF'
// LDAP Configuration for TT Fleet Management
// Copy this file and modify for your environment

module.exports = {
  // LDAP Server Configuration
  url: 'ldap://your-ldap-server:389',
  baseDN: 'DC=yourdomain,DC=com',
  
  // Service Account (for binding and searches)
  username: 'CN=service-account,OU=Service Accounts,DC=yourdomain,DC=com',
  password: 'service-account-password',
  
  // Group Mappings for Role Assignment
  groups: {
    // Users in this group get admin privileges
    admin: 'CN=car_admin,OU=Groups,DC=yourdomain,DC=com',
    // Users in this group get regular user privileges
    user: 'CN=car_user,OU=Groups,DC=yourdomain,DC=com'
  },
  
  // User Search Configuration
  userSearchBase: 'OU=Users,DC=yourdomain,DC=com',
  userSearchFilter: '(sAMAccountName={{username}})',
  
  // User Attribute Mapping
  attributes: {
    username: 'sAMAccountName',
    displayName: 'displayName',
    email: 'mail',
    memberOf: 'memberOf'
  },
  
  // Connection Options
  timeout: 5000,
  connectTimeout: 10000,
  
  // Enable/Disable LDAP
  enabled: true
};
EOF
        log_info "Created ldap-config.js template"
    fi
    
    # Create environment file if it doesn't exist
    if [ ! -f ".env" ]; then
        cat > .env << EOF
NODE_ENV=production
PORT=3000
SESSION_SECRET=$(openssl rand -base64 32)
LDAP_ENABLED=true
LOG_LEVEL=info
APP_NAME=TT Fleet Management
EOF
        log_info "Created .env file"
    fi
    
    log_success "Configuration files created"
}

create_systemd_service() {
    log_info "Creating systemd service..."
    
    sudo tee /etc/systemd/system/$SERVICE_NAME.service > /dev/null << EOF
[Unit]
Description=TT Fleet Management System
Documentation=https://github.com/batuapi13/ttfleetm
After=network.target

[Service]
Environment=NODE_ENV=production
Type=simple
User=$USER
WorkingDirectory=$APP_DIR
ExecStart=/usr/bin/node server.js
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=$SERVICE_NAME

# Security settings
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=$APP_DIR
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF
    
    # Reload systemd and enable service
    sudo systemctl daemon-reload
    sudo systemctl enable $SERVICE_NAME
    
    log_success "Systemd service created and enabled"
}

start_service() {
    log_info "Starting $SERVICE_NAME service..."
    
    # Stop service if running
    sudo systemctl stop $SERVICE_NAME 2>/dev/null || true
    
    # Start service
    sudo systemctl start $SERVICE_NAME
    
    # Check status
    sleep 3
    if sudo systemctl is-active --quiet $SERVICE_NAME; then
        log_success "Service started successfully"
        
        # Show service status
        sudo systemctl status $SERVICE_NAME --no-pager -l
        
        log_info "Application should be available at: http://localhost:3000"
    else
        log_error "Service failed to start"
        log_info "Check logs with: sudo journalctl -u $SERVICE_NAME -f"
        exit 1
    fi
}

create_backup_script() {
    log_info "Creating backup script..."
    
    mkdir -p scripts
    
    cat > scripts/backup.sh << 'EOF'
#!/bin/bash
# Backup script for TT Fleet Management System

BACKUP_DIR="/var/backups/ttfleetm"
APP_DIR="/var/www/html/fleet-new"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="ttfleetm_backup_$TIMESTAMP.tar.gz"

# Create backup directory
sudo mkdir -p $BACKUP_DIR

# Create backup
log_info "Creating backup..."
tar -czf /tmp/$BACKUP_FILE -C $APP_DIR data/ config/ uploads/ .env 2>/dev/null || true

# Move to backup directory
sudo mv /tmp/$BACKUP_FILE $BACKUP_DIR/

# Keep only last 10 backups
sudo find $BACKUP_DIR -name "ttfleetm_backup_*.tar.gz" -type f -exec ls -t {} + | tail -n +11 | sudo xargs rm -f

log_success "Backup created: $BACKUP_DIR/$BACKUP_FILE"
EOF
    
    chmod +x scripts/backup.sh
    log_success "Backup script created"
}

main() {
    echo "========================================"
    echo "   TT Fleet Management Deployment      "
    echo "        Version 0.5                    "
    echo "========================================"
    echo
    
    # Pre-checks
    check_root
    check_node
    check_dependencies
    
    # Setup
    setup_directories
    create_config_files
    install_dependencies
    create_systemd_service
    create_backup_script
    
    # Start application
    start_service
    
    echo
    echo "========================================"
    log_success "Deployment completed successfully!"
    echo "========================================"
    echo
    log_info "Application URL: http://localhost:3000"
    log_info "Default admin credentials:"
    log_info "  Username: admin"
    log_info "  Password: admin123"
    echo
    log_warning "IMPORTANT: Change default admin password immediately!"
    echo
    log_info "Useful commands:"
    log_info "  Check status: sudo systemctl status $SERVICE_NAME"
    log_info "  View logs: sudo journalctl -u $SERVICE_NAME -f"
    log_info "  Restart: sudo systemctl restart $SERVICE_NAME"
    log_info "  Create backup: ./scripts/backup.sh"
    echo
}

# Run main function
main "$@"