#!/bin/bash

# Install packages based on system type
# Supports: macOS (Homebrew), Arch Linux (pacman), Ubuntu/Debian (apt)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Function to detect OS and return package manager
detect_system() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ -f /etc/os-release ]]; then
        source /etc/os-release
        if [[ "$ID" == "arch" ]]; then
            echo "arch"
        elif [[ "$ID" == "ubuntu" ]] || [[ "$ID_LIKE" == *"debian"* ]]; then
            echo "ubuntu"
        else
            echo "unknown"
        fi
    else
        echo "unknown"
    fi
}

# Function to check if package manager is installed
check_package_manager() {
    case "$1" in
        macos)
            if ! command -v brew &> /dev/null; then
                print_error "Homebrew is not installed"
                print_info "Install Homebrew from: https://brew.sh"
                exit 1
            fi
            ;;
        arch)
            if ! command -v pacman &> /dev/null; then
                print_error "pacman is not installed"
                exit 1
            fi
            ;;
        ubuntu)
            if ! command -v apt &> /dev/null; then
                print_error "apt is not installed"
                exit 1
            fi
            ;;
        *)
            print_error "Unknown package manager"
            exit 1
            ;;
    esac
}

# Function to install packages on macOS
install_macos() {
    print_info "Installing packages with Homebrew..."
    
    while IFS= read -r package || [[ -n "$package" ]]; do
        # Skip empty lines and comments
        [[ -z "$package" || "$package" == \#* ]] && continue
        
        if brew list "$package" &>/dev/null; then
            print_warning "$package is already installed"
        else
            print_info "Installing $package..."
            if brew install "$package"; then
                print_success "$package installed"
            else
                print_error "Failed to install $package"
                return 1
            fi
        fi
    done < "$PACKAGES_FILE"
}

# Function to install packages on Arch Linux
install_arch() {
    print_info "Installing packages with pacman..."
    
    local packages_to_install=()
    
    while IFS= read -r package || [[ -n "$package" ]]; do
        # Skip empty lines and comments
        [[ -z "$package" || "$package" == \#* ]] && continue
        
        if pacman -Q "$package" &>/dev/null; then
            print_warning "$package is already installed"
        else
            packages_to_install+=("$package")
        fi
    done < "$PACKAGES_FILE"
    
    if [[ ${#packages_to_install[@]} -gt 0 ]]; then
        print_info "Installing ${#packages_to_install[@]} package(s)..."
        if sudo pacman -S --noconfirm "${packages_to_install[@]}"; then
            print_success "All packages installed"
        else
            print_error "Failed to install some packages"
            return 1
        fi
    else
        print_success "All packages are already installed"
    fi
}

# Function to install packages on Ubuntu/Debian
install_ubuntu() {
    print_info "Installing packages with apt..."
    
    # Update package manager
    print_info "Updating apt cache..."
    if ! sudo apt update; then
        print_error "Failed to update apt cache"
        return 1
    fi
    
    local packages_to_install=()
    
    while IFS= read -r package || [[ -n "$package" ]]; do
        # Skip empty lines and comments
        [[ -z "$package" || "$package" == \#* ]] && continue
        
        if dpkg -l | grep -q "^ii  $package"; then
            print_warning "$package is already installed"
        else
            packages_to_install+=("$package")
        fi
    done < "$PACKAGES_FILE"
    
    if [[ ${#packages_to_install[@]} -gt 0 ]]; then
        print_info "Installing ${#packages_to_install[@]} package(s)..."
        if sudo apt install -y "${packages_to_install[@]}"; then
            print_success "All packages installed"
        else
            print_error "Failed to install some packages"
            return 1
        fi
    else
        print_success "All packages are already installed"
    fi
}

# Main script
main() {
    # Get the directory of this script
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    print_info "Detecting system..."
    SYSTEM=$(detect_system)
    
    # Determine packages file based on system
    case "$SYSTEM" in
        macos)
            PACKAGES_FILE="$SCRIPT_DIR/packages-brew"
            print_success "Detected: macOS (Homebrew)"
            ;;
        arch)
            PACKAGES_FILE="$SCRIPT_DIR/packages-arch"
            print_success "Detected: Arch Linux (pacman)"
            ;;
        ubuntu)
            PACKAGES_FILE="$SCRIPT_DIR/packages-ubuntu"
            print_success "Detected: Ubuntu/Debian (apt)"
            ;;
        unknown)
            print_error "Unable to detect system type"
            exit 1
            ;;
    esac
    
    # Check if packages file exists
    if [[ ! -f "$PACKAGES_FILE" ]]; then
        print_error "packages file not found at $PACKAGES_FILE"
        exit 1
    fi
    
    # Install packages based on system
    case "$SYSTEM" in
        macos)
            check_package_manager "macos"
            install_macos
            ;;
        arch)
            check_package_manager "arch"
            install_arch
            ;;
        ubuntu)
            check_package_manager "ubuntu"
            install_ubuntu
            ;;
    esac
    
    print_success "Package installation complete!"
}

main "$@"
