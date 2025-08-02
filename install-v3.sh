#!/bin/bash

# Enhanced WiFi Connection Manager Installer
# Version: 3.0
# Supports multiple versions: CLI, GUI, and Enhanced versions

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
INSTALL_DIR="/usr/local/bin"
BACKUP_DIR="$HOME/.konekwifi-backup"
LOG_FILE="/tmp/konekwifi_install_$(date +%Y%m%d_%H%M%S).log"

# Internationalization
LANG_CODE="${LANG:-en_US}"
case $LANG_CODE in
    id_ID*|id*)
        MSG_WELCOME="Selamat datang di WiFi Connection Manager Installer v3.0"
        MSG_DETECTING="Mendeteksi sistem..."
        MSG_CHECKING_DEPS="Mengecek dependensi..."
        MSG_INSTALLING="Menginstall..."
        MSG_SUCCESS="Instalasi berhasil!"
        MSG_FAILED="Instalasi gagal!"
        MSG_ALREADY_EXISTS="sudah ada, membuat backup..."
        MSG_CHOOSE_VERSION="Pilih versi yang ingin diinstall:"
        MSG_ALL_VERSIONS="Semua versi (CLI + GUI + Enhanced)"
        MSG_CLI_ONLY="Hanya CLI version"
        MSG_GUI_ONLY="Hanya GUI version"
        MSG_ENHANCED_ONLY="Hanya Enhanced version"
        MSG_ENTER_CHOICE="Masukkan pilihan (1-4):"
        ;;
    *)
        MSG_WELCOME="Welcome to WiFi Connection Manager Installer v3.0"
        MSG_DETECTING="Detecting system..."
        MSG_CHECKING_DEPS="Checking dependencies..."
        MSG_INSTALLING="Installing..."
        MSG_SUCCESS="Installation successful!"
        MSG_FAILED="Installation failed!"
        MSG_ALREADY_EXISTS="already exists, creating backup..."
        MSG_CHOOSE_VERSION="Choose version to install:"
        MSG_ALL_VERSIONS="All versions (CLI + GUI + Enhanced)"
        MSG_CLI_ONLY="CLI version only"
        MSG_GUI_ONLY="GUI version only"
        MSG_ENHANCED_ONLY="Enhanced version only"
        MSG_ENTER_CHOICE="Enter your choice (1-4):"
        ;;
esac

# Logging function
log_message() {
    local level=$1
    local message=$2
    echo "[$(date '+%H:%M:%S')] [$level] $message" | tee -a "$LOG_FILE"
}

# Print header
print_header() {
    clear
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}     WiFi Connection Manager Installer        ${NC}"
    echo -e "${BLUE}                Version 3.0                    ${NC}"
    echo -e "${BLUE}================================================${NC}"
    echo ""
    echo -e "${CYAN}$MSG_WELCOME${NC}"
    echo ""
    log_message "INFO" "Installer started"
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        echo -e "${YELLOW}⚠️  Running as root detected${NC}"
        echo -e "${YELLOW}📋 Installing to system directories${NC}"
    else
        echo -e "${YELLOW}⚠️  Not running as root${NC}"
        echo -e "${YELLOW}💡 You may need to enter password for sudo commands${NC}"
        INSTALL_DIR="$HOME/.local/bin"
        echo -e "${CYAN}📁 Installing to user directory: $INSTALL_DIR${NC}"
    fi
    echo ""
}

# Detect system and package manager
detect_system() {
    echo -e "${BLUE}$MSG_DETECTING${NC}"
    
    if command -v apt &> /dev/null; then
        PACKAGE_MANAGER="apt"
        DISTRO="Debian/Ubuntu"
    elif command -v dnf &> /dev/null; then
        PACKAGE_MANAGER="dnf"
        DISTRO="Fedora/RHEL"
    elif command -v yum &> /dev/null; then
        PACKAGE_MANAGER="yum"
        DISTRO="RHEL/CentOS"
    elif command -v pacman &> /dev/null; then
        PACKAGE_MANAGER="pacman"
        DISTRO="Arch Linux"
    elif command -v zypper &> /dev/null; then
        PACKAGE_MANAGER="zypper"
        DISTRO="openSUSE"
    else
        PACKAGE_MANAGER="unknown"
        DISTRO="Unknown"
    fi
    
    echo -e "${GREEN}✓ System detected: $DISTRO${NC}"
    log_message "INFO" "System detected: $DISTRO with $PACKAGE_MANAGER"
}

# Check dependencies
check_dependencies() {
    echo -e "${BLUE}$MSG_CHECKING_DEPS${NC}"
    
    local missing_deps=()
    
    # Check NetworkManager
    if ! command -v nmcli &> /dev/null; then
        missing_deps+=("network-manager")
        echo -e "${RED}✗ nmcli not found${NC}"
    else
        echo -e "${GREEN}✓ NetworkManager found${NC}"
    fi
    
    # Check zenity (for GUI version)
    if ! command -v zenity &> /dev/null; then
        missing_deps+=("zenity")
        echo -e "${YELLOW}⚠ zenity not found (needed for GUI version)${NC}"
    else
        echo -e "${GREEN}✓ zenity found${NC}"
    fi
    
    # Check systemctl
    if ! command -v systemctl &> /dev/null; then
        echo -e "${YELLOW}⚠ systemctl not found${NC}"
    else
        echo -e "${GREEN}✓ systemctl found${NC}"
    fi
    
    # Install missing dependencies
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "${YELLOW}📦 Installing missing dependencies...${NC}"
        install_dependencies "${missing_deps[@]}"
    fi
    
    echo ""
}

# Install dependencies based on package manager
install_dependencies() {
    local deps=("$@")
    
    case $PACKAGE_MANAGER in
        apt)
            sudo apt update
            sudo apt install -y "${deps[@]}"
            ;;
        dnf)
            sudo dnf install -y "${deps[@]}"
            ;;
        yum)
            sudo yum install -y "${deps[@]}"
            ;;
        pacman)
            sudo pacman -S --noconfirm "${deps[@]}"
            ;;
        zypper)
            sudo zypper install -y "${deps[@]}"
            ;;
        *)
            echo -e "${RED}❌ Unknown package manager. Please install dependencies manually:${NC}"
            printf "${YELLOW}%s ${NC}" "${deps[@]}"
            echo ""
            read -p "Press Enter to continue after installing dependencies..."
            ;;
    esac
}

# Create necessary directories
create_directories() {
    echo -e "${BLUE}📁 Creating directories...${NC}"
    
    # Create install directory if it doesn't exist
    if [ ! -d "$INSTALL_DIR" ]; then
        mkdir -p "$INSTALL_DIR"
        echo -e "${GREEN}✓ Created: $INSTALL_DIR${NC}"
    fi
    
    # Create backup directory
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        echo -e "${GREEN}✓ Created backup directory: $BACKUP_DIR${NC}"
    fi
    
    # Add to PATH if needed
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]] && [ "$INSTALL_DIR" = "$HOME/.local/bin" ]; then
        echo -e "${YELLOW}💡 Adding $INSTALL_DIR to PATH...${NC}"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc" 2>/dev/null || true
        echo -e "${GREEN}✓ Added to PATH (restart terminal or run: source ~/.bashrc)${NC}"
    fi
    
    log_message "INFO" "Directories created: $INSTALL_DIR, $BACKUP_DIR"
}

# Backup existing files
backup_existing() {
    local file=$1
    local target="$INSTALL_DIR/$file"
    
    if [ -f "$target" ]; then
        echo -e "${YELLOW}📋 $file $MSG_ALREADY_EXISTS${NC}"
        cp "$target" "$BACKUP_DIR/${file}.backup.$(date +%Y%m%d_%H%M%S)"
        log_message "BACKUP" "Backed up existing $file"
    fi
}

# Install script
install_script() {
    local script_name=$1
    local source_file=$2
    local target_name=${3:-$script_name}
    
    if [ ! -f "$source_file" ]; then
        echo -e "${RED}✗ Source file not found: $source_file${NC}"
        return 1
    fi
    
    backup_existing "$target_name"
    
    if [[ $EUID -eq 0 ]]; then
        cp "$source_file" "$INSTALL_DIR/$target_name"
        chmod +x "$INSTALL_DIR/$target_name"
    else
        sudo cp "$source_file" "$INSTALL_DIR/$target_name"
        sudo chmod +x "$INSTALL_DIR/$target_name"
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Installed: $target_name${NC}"
        log_message "INSTALL" "Successfully installed $target_name"
        return 0
    else
        echo -e "${RED}✗ Failed to install: $target_name${NC}"
        log_message "ERROR" "Failed to install $target_name"
        return 1
    fi
}

# Create symlink
create_symlink() {
    local target=$1
    local link_name=$2
    
    backup_existing "$link_name"
    
    if [[ $EUID -eq 0 ]]; then
        ln -sf "$target" "$INSTALL_DIR/$link_name"
    else
        sudo ln -sf "$target" "$INSTALL_DIR/$link_name"
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Created symlink: $link_name -> $target${NC}"
        log_message "SYMLINK" "Created symlink $link_name -> $target"
        return 0
    else
        echo -e "${RED}✗ Failed to create symlink: $link_name${NC}"
        log_message "ERROR" "Failed to create symlink $link_name"
        return 1
    fi
}

# Version selection menu
select_version() {
    echo -e "${CYAN}$MSG_CHOOSE_VERSION${NC}"
    echo ""
    echo -e "${YELLOW}1)${NC} $MSG_ALL_VERSIONS"
    echo -e "${YELLOW}2)${NC} $MSG_CLI_ONLY"
    echo -e "${YELLOW}3)${NC} $MSG_GUI_ONLY"
    echo -e "${YELLOW}4)${NC} $MSG_ENHANCED_ONLY"
    echo ""
    
    while true; do
        echo -e "${BLUE}$MSG_ENTER_CHOICE${NC}"
        read -r choice
        case $choice in
            1|all|ALL)
                INSTALL_VERSION="all"
                break
                ;;
            2|cli|CLI)
                INSTALL_VERSION="cli"
                break
                ;;
            3|gui|GUI)
                INSTALL_VERSION="gui"
                break
                ;;
            4|enhanced|ENHANCED)
                INSTALL_VERSION="enhanced"
                break
                ;;
            *)
                echo -e "${RED}❌ Invalid choice. Please enter 1-4${NC}"
                ;;
        esac
    done
    
    echo -e "${GREEN}✓ Selected: $INSTALL_VERSION${NC}"
    echo ""
    log_message "INFO" "User selected version: $INSTALL_VERSION"
}

# Install based on version selection
install_versions() {
    echo -e "${BLUE}$MSG_INSTALLING${NC}"
    local install_count=0
    local total_count=0
    
    case $INSTALL_VERSION in
        all)
            # Install all versions
            echo -e "${CYAN}Installing all versions...${NC}"
            
            # Original CLI version
            ((total_count++))
            if install_script "konekwifi" "konekwifi"; then ((install_count++)); fi
            
            # Enhanced CLI version
            ((total_count++))
            if install_script "konekwifi-v3" "konekwifi-v3"; then ((install_count++)); fi
            
            # GUI version
            ((total_count++))
            if install_script "konekwifi-gui" "konekwifi-gui"; then ((install_count++)); fi
            
            # Enhanced disconnect version
            ((total_count++))
            if install_script "putuswifi-v3" "putuswifi-v3"; then ((install_count++)); fi
            
            # Create symlinks
            ((total_count++))
            if create_symlink "$INSTALL_DIR/konekwifi" "putuswifi"; then ((install_count++)); fi
            
            # Create global uninstaller
            ((total_count++))
            if install_script "uninstallwifi" "uninstall.sh"; then ((install_count++)); fi
            ;;
            
        cli)
            echo -e "${CYAN}Installing CLI version only...${NC}"
            
            ((total_count++))
            if install_script "konekwifi" "konekwifi"; then ((install_count++)); fi
            
            ((total_count++))
            if create_symlink "$INSTALL_DIR/konekwifi" "putuswifi"; then ((install_count++)); fi
            ;;
            
        gui)
            echo -e "${CYAN}Installing GUI version only...${NC}"
            
            ((total_count++))
            if install_script "konekwifi-gui" "konekwifi-gui"; then ((install_count++)); fi
            ;;
            
        enhanced)
            echo -e "${CYAN}Installing Enhanced versions only...${NC}"
            
            ((total_count++))
            if install_script "konekwifi-v3" "konekwifi-v3"; then ((install_count++)); fi
            
            ((total_count++))
            if install_script "putuswifi-v3" "putuswifi-v3"; then ((install_count++)); fi
            ;;
    esac
    
    echo ""
    echo -e "${BLUE}Installation Summary:${NC}"
    echo -e "Successfully installed: ${GREEN}$install_count${NC}/$total_count"
    
    if [ $install_count -eq $total_count ]; then
        echo -e "${GREEN}🎉 $MSG_SUCCESS${NC}"
        log_message "SUCCESS" "All components installed successfully ($install_count/$total_count)"
        return 0
    else
        echo -e "${YELLOW}⚠️  Partial installation completed${NC}"
        log_message "WARNING" "Partial installation ($install_count/$total_count)"
        return 1
    fi
}

# Show installation summary
show_summary() {
    echo ""
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}           INSTALLATION COMPLETE               ${NC}"
    echo -e "${BLUE}================================================${NC}"
    echo ""
    
    echo -e "${CYAN}📋 Installed Commands:${NC}"
    
    case $INSTALL_VERSION in
        all)
            echo -e "  ${GREEN}konekwifi${NC}     - Original CLI WiFi manager"
            echo -e "  ${GREEN}putuswifi${NC}     - Disconnect WiFi (symlink)"
            echo -e "  ${GREEN}konekwifi-v3${NC}  - Enhanced CLI with security & i18n"
            echo -e "  ${GREEN}konekwifi-gui${NC} - GUI version with zenity"
            echo -e "  ${GREEN}putuswifi-v3${NC}  - Enhanced disconnect with i18n"
            echo -e "  ${GREEN}uninstallwifi${NC} - Global uninstaller"
            ;;
        cli)
            echo -e "  ${GREEN}konekwifi${NC}     - CLI WiFi manager"
            echo -e "  ${GREEN}putuswifi${NC}     - Disconnect WiFi"
            ;;
        gui)
            echo -e "  ${GREEN}konekwifi-gui${NC} - GUI WiFi manager"
            ;;
        enhanced)
            echo -e "  ${GREEN}konekwifi-v3${NC}  - Enhanced CLI WiFi manager"
            echo -e "  ${GREEN}putuswifi-v3${NC}  - Enhanced disconnect"
            ;;
    esac
    
    echo ""
    echo -e "${CYAN}📁 Installation Directory:${NC} $INSTALL_DIR"
    echo -e "${CYAN}📋 Backup Directory:${NC} $BACKUP_DIR"
    echo -e "${CYAN}📄 Log File:${NC} $LOG_FILE"
    echo ""
    
    echo -e "${YELLOW}💡 Quick Start:${NC}"
    echo -e "  Type ${GREEN}konekwifi${NC} to connect to WiFi"
    echo -e "  Type ${GREEN}putuswifi${NC} to disconnect from WiFi"
    if [[ "$INSTALL_VERSION" == "all" || "$INSTALL_VERSION" == "gui" ]]; then
        echo -e "  Type ${GREEN}konekwifi-gui${NC} for graphical interface"
    fi
    if [[ "$INSTALL_VERSION" == "all" || "$INSTALL_VERSION" == "enhanced" ]]; then
        echo -e "  Type ${GREEN}konekwifi-v3${NC} for enhanced features"
    fi
    echo ""
    
    # Show PATH warning if needed
    if [ "$INSTALL_DIR" = "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        echo -e "${YELLOW}⚠️  Important: Restart your terminal or run:${NC}"
        echo -e "  ${CYAN}source ~/.bashrc${NC}"
        echo ""
    fi
    
    echo -e "${GREEN}🎉 Installation completed successfully!${NC}"
    echo -e "${BLUE}================================================${NC}"
}

# Error handling
handle_error() {
    echo -e "${RED}❌ $MSG_FAILED${NC}"
    echo -e "${YELLOW}💡 Check the log file for details: $LOG_FILE${NC}"
    log_message "ERROR" "Installation failed"
    exit 1
}

# Main installation process
main() {
    # Set error handling
    set -e
    trap handle_error ERR
    
    print_header
    check_root
    detect_system
    check_dependencies
    create_directories
    select_version
    
    if install_versions; then
        show_summary
    else
        echo -e "${YELLOW}⚠️  Some components failed to install${NC}"
        echo -e "${YELLOW}💡 Check log file: $LOG_FILE${NC}"
    fi
    
    log_message "INFO" "Installer completed"
}

# Check for help option
if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
    echo "WiFi Connection Manager Installer v3.0"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --help, -h    Show this help message"
    echo ""
    echo "This installer will:"
    echo "  🔍 Detect your system and package manager"
    echo "  📦 Install required dependencies"
    echo "  🛠️  Install WiFi manager scripts"
    echo "  🔗 Create convenient symlinks"
    echo "  📁 Set up proper directory structure"
    echo ""
    echo "Supported versions:"
    echo "  • CLI version (konekwifi)"
    echo "  • GUI version (konekwifi-gui)"
    echo "  • Enhanced version (konekwifi-v3)"
    echo "  • All versions"
    echo ""
    echo "Requirements:"
    echo "  • NetworkManager (nmcli)"
    echo "  • zenity (for GUI version)"
    echo "  • Bash 4.0+"
    exit 0
fi

# Run main function
main
