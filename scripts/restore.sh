#!/bin/bash

# Restore script for TT Fleet Management System
# Version: 0.5

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

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

# Check if backup file is provided
if [ $# -eq 0 ]; then
    log_error "Usage: $0 <backup-file.tar.gz>"
    echo
    log_info "Available backups:"
    ls -lah /var/backups/ttfleetm/ttfleetm_backup_*.tar.gz 2>/dev/null || echo "No backups found"
    exit 1
fi

BACKUP_FILE="$1"
APP_DIR="/var/www/html/fleet-new"
SERVICE_NAME="fleet-management"

# Check if backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
    log_error "Backup file not found: $BACKUP_FILE"
    exit 1
fi

# Confirm restore operation
echo "========================================"
echo "   TT Fleet Management - Restore       "
echo "========================================"
echo
log_warning "This will restore data from: $BACKUP_FILE"
log_warning "Current data will be backed up as restore-backup-$(date +%Y%m%d_%H%M%S).tar.gz"
echo
read -p "Continue with restore? (y/N): " confirm
if [[ ! $confirm =~ ^[Yy]$ ]]; then
    log_info "Restore cancelled"
    exit 0
fi

# Stop service
log_info "Stopping fleet management service..."
sudo systemctl stop $SERVICE_NAME 2>/dev/null || true

# Create backup of current data
log_info "Creating backup of current data..."
cd $APP_DIR
RESTORE_BACKUP="restore-backup-$(date +%Y%m%d_%H%M%S).tar.gz"
tar -czf /tmp/$RESTORE_BACKUP data/ config/ uploads/ .env 2>/dev/null || true
sudo mkdir -p /var/backups/ttfleetm
sudo mv /tmp/$RESTORE_BACKUP /var/backups/ttfleetm/
log_success "Current data backed up to: /var/backups/ttfleetm/$RESTORE_BACKUP"

# Extract backup
log_info "Extracting backup..."
cd $APP_DIR
tar -xzf "$BACKUP_FILE"

# Fix permissions
log_info "Setting proper permissions..."
sudo chown -R tapa:www-data $APP_DIR/data $APP_DIR/uploads 2>/dev/null || true
chmod -R 664 $APP_DIR/data/*.json 2>/dev/null || true
chmod 775 $APP_DIR/data $APP_DIR/uploads 2>/dev/null || true

# Start service
log_info "Starting fleet management service..."
sudo systemctl start $SERVICE_NAME

# Check if service started successfully
sleep 3
if sudo systemctl is-active --quiet $SERVICE_NAME; then
    log_success "Service started successfully"
else
    log_error "Service failed to start"
    log_info "Check logs with: sudo journalctl -u $SERVICE_NAME -f"
    log_info "You can restore previous data from: /var/backups/ttfleetm/$RESTORE_BACKUP"
    exit 1
fi

# Test connectivity
log_info "Testing application connectivity..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 | grep -q "200\|401"; then
    log_success "Application is responding"
else
    log_warning "Application may not be responding correctly"
fi

echo
echo "========================================"
log_success "Restore completed successfully!"
echo "========================================"
echo
log_info "Restore details:"
log_info "  Backup file: $BACKUP_FILE"
log_info "  Application URL: http://localhost:3000"
log_info "  Service status: $(sudo systemctl is-active $SERVICE_NAME)"
echo
log_info "If you experience issues:"
log_info "  1. Check service logs: sudo journalctl -u $SERVICE_NAME -f"
log_info "  2. Verify setup: ./verify-setup.sh"
log_info "  3. Restore previous data: ./scripts/restore.sh /var/backups/ttfleetm/$RESTORE_BACKUP"