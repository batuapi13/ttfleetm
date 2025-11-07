#!/bin/bash

# Backup script for TT Fleet Management System
# Version: 0.5

set -e

# Configuration
APP_DIR="/var/www/html/fleet-new"
BACKUP_DIR="/var/backups/ttfleetm"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="ttfleetm_backup_$TIMESTAMP.tar.gz"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Create backup directory
log_info "Creating backup directory..."
sudo mkdir -p $BACKUP_DIR

# Create backup
log_info "Creating backup of application data..."
cd $APP_DIR

# Create temporary backup with important files only
tar -czf /tmp/$BACKUP_FILE \
  --exclude='node_modules' \
  --exclude='.git' \
  --exclude='logs/*.log' \
  --exclude='*.tmp' \
  data/ config/ uploads/ .env package.json server.js store.js public/ docs/ 2>/dev/null || true

# Move to backup directory
sudo mv /tmp/$BACKUP_FILE $BACKUP_DIR/

# Set proper permissions
sudo chown tapa:www-data $BACKUP_DIR/$BACKUP_FILE

# Keep only last 10 backups
log_info "Cleaning old backups..."
sudo find $BACKUP_DIR -name "ttfleetm_backup_*.tar.gz" -type f -exec ls -t {} + | tail -n +11 | sudo xargs rm -f 2>/dev/null || true

# Show backup info
BACKUP_SIZE=$(ls -lah $BACKUP_DIR/$BACKUP_FILE | awk '{print $5}')
log_success "Backup created: $BACKUP_DIR/$BACKUP_FILE ($BACKUP_SIZE)"

# List recent backups
echo
log_info "Recent backups:"
ls -lah $BACKUP_DIR/ttfleetm_backup_*.tar.gz 2>/dev/null | tail -5 || echo "No previous backups found"