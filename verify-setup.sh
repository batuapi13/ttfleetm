#!/bin/bash

# TT Fleet Management System - Setup Verification Script
# Version: 0.5
# Description: Verify installation and configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
SERVICE_NAME="fleet-management"
APP_DIR="/var/www/html/fleet-new"
PORT=3000

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

check_node() {
    log_info "Checking Node.js installation..."
    
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
        log_success "Node.js installed: $NODE_VERSION"
    else
        log_error "Node.js not found"
        return 1
    fi
    
    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm --version)
        log_success "npm installed: $NPM_VERSION"
    else
        log_error "npm not found"
        return 1
    fi
}

check_directories() {
    log_info "Checking directory structure..."
    
    if [ -d "$APP_DIR" ]; then
        log_success "Application directory exists: $APP_DIR"
        
        cd "$APP_DIR"
        
        # Check required directories
        for dir in data logs uploads public; do
            if [ -d "$dir" ]; then
                log_success "Directory exists: $dir"
            else
                log_error "Directory missing: $dir"
            fi
        done
        
        # Check required files
        for file in server.js store.js package.json; do
            if [ -f "$file" ]; then
                log_success "File exists: $file"
            else
                log_error "File missing: $file"
            fi
        done
    else
        log_error "Application directory not found: $APP_DIR"
        return 1
    fi
}

check_dependencies() {
    log_info "Checking Node.js dependencies..."
    
    cd "$APP_DIR"
    
    if [ -f "package.json" ]; then
        if [ -d "node_modules" ]; then
            log_success "Node modules installed"
            
            # Check specific dependencies
            if [ -d "node_modules/express" ]; then
                log_success "Express.js installed"
            else
                log_error "Express.js missing"
            fi
            
            if [ -d "node_modules/ldapjs" ]; then
                log_success "LDAP client installed"
            else
                log_warning "LDAP client missing (optional)"
            fi
        else
            log_error "Node modules not installed. Run: npm install"
            return 1
        fi
    else
        log_error "package.json not found"
        return 1
    fi
}

check_configuration() {
    log_info "Checking configuration files..."
    
    cd "$APP_DIR"
    
    # Check LDAP config
    if [ -f "ldap-config.js" ]; then
        log_success "LDAP configuration exists"
    else
        log_warning "LDAP configuration not found (will use defaults)"
    fi
    
    # Check environment file
    if [ -f ".env" ]; then
        log_success "Environment configuration exists"
    else
        log_warning "Environment file not found (will use defaults)"
    fi
    
    # Check permissions
    if [ -w "data" ] && [ -w "logs" ] && [ -w "uploads" ]; then
        log_success "Directory permissions correct"
    else
        log_warning "Some directories may not be writable"
    fi
}

check_service() {
    log_info "Checking systemd service..."
    
    if sudo systemctl list-unit-files | grep -q "$SERVICE_NAME.service"; then
        log_success "Service file exists"
        
        if sudo systemctl is-enabled --quiet $SERVICE_NAME; then
            log_success "Service is enabled"
        else
            log_warning "Service is not enabled"
        fi
        
        if sudo systemctl is-active --quiet $SERVICE_NAME; then
            log_success "Service is running"
        else
            log_warning "Service is not running"
        fi
    else
        log_warning "Service file not found"
    fi
}

check_connectivity() {
    log_info "Checking application connectivity..."
    
    # Wait a moment for service to start
    sleep 2
    
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT | grep -q "200"; then
        log_success "Application is responding on port $PORT"
    else
        log_warning "Application not responding on port $PORT"
        
        # Check if port is in use
        if netstat -tlnp 2>/dev/null | grep -q ":$PORT "; then
            log_info "Port $PORT is in use"
        else
            log_warning "Port $PORT is not in use"
        fi
    fi
}

check_ldap() {
    log_info "Testing LDAP configuration..."
    
    cd "$APP_DIR"
    
    if [ -f "test-ldap.js" ] && [ -f "ldap-config.js" ]; then
        log_info "Running LDAP test..."
        
        # Run LDAP test with timeout
        timeout 10s node test-ldap.js 2>&1 | head -10
        
        if [ $? -eq 0 ]; then
            log_success "LDAP test completed"
        else
            log_warning "LDAP test failed or timed out"
        fi
    else
        log_warning "LDAP test script not available"
    fi
}

show_logs() {
    log_info "Recent application logs:"
    echo "----------------------------------------"
    
    # Show systemd logs
    if sudo systemctl is-active --quiet $SERVICE_NAME; then
        sudo journalctl -u $SERVICE_NAME --no-pager -n 10 --reverse
    else
        log_warning "Service not running, no logs available"
    fi
    
    echo "----------------------------------------"
}

show_summary() {
    echo
    echo "========================================"
    echo "   TT Fleet Management Verification    "
    echo "========================================"
    echo
    
    log_info "System Information:"
    echo "  OS: $(lsb_release -d 2>/dev/null | cut -f2 || echo 'Unknown')"
    echo "  Kernel: $(uname -r)"
    echo "  Architecture: $(uname -m)"
    echo "  Uptime: $(uptime -p 2>/dev/null || uptime)"
    echo
    
    log_info "Application Information:"
    echo "  Application: TT Fleet Management v0.5"
    echo "  Directory: $APP_DIR"
    echo "  Service: $SERVICE_NAME"
    echo "  Port: $PORT"
    echo "  URL: http://localhost:$PORT"
    echo
    
    log_info "Default Credentials:"
    echo "  Username: admin"
    echo "  Password: admin123"
    echo
    
    log_warning "Remember to change default credentials!"
}

main() {
    echo "========================================"
    echo "   TT Fleet Management Verification    "
    echo "        Version 0.5                    "
    echo "========================================"
    echo
    
    local errors=0
    
    check_node || errors=$((errors + 1))
    check_directories || errors=$((errors + 1))
    check_dependencies || errors=$((errors + 1))
    check_configuration || errors=$((errors + 1))
    check_service || errors=$((errors + 1))
    check_connectivity || errors=$((errors + 1))
    
    # Optional checks
    check_ldap
    show_logs
    
    echo
    if [ $errors -eq 0 ]; then
        log_success "All critical checks passed!"
        show_summary
    else
        log_error "$errors critical issues found"
        echo
        log_info "Common solutions:"
        log_info "  1. Run: npm install"
        log_info "  2. Run: sudo systemctl restart $SERVICE_NAME"
        log_info "  3. Check: sudo journalctl -u $SERVICE_NAME -f"
        log_info "  4. Verify: ./deploy.sh"
    fi
    
    echo
}

# Run main function
main "$@"