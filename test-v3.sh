#!/bin/bash

# Enhanced WiFi Connection Manager Test Suite
# Version: 3.0
# Purpose: Comprehensive testing for all WiFi manager versions

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Test counters
TESTS_TOTAL=0
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_WARNINGS=0

# Logging
LOG_FILE="/tmp/konekwifi_test_$(date +%Y%m%d_%H%M%S).log"

# Functions
log_message() {
    local level=$1
    local message=$2
    echo "[$(date '+%H:%M:%S')] [$level] $message" | tee -a "$LOG_FILE"
}

print_header() {
    clear
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}     WiFi Connection Manager Test Suite       ${NC}"
    echo -e "${BLUE}                Version 3.0                    ${NC}"
    echo -e "${BLUE}================================================${NC}"
    echo ""
    log_message "INFO" "Test suite started"
}

increment_test() {
    ((TESTS_TOTAL++))
}

pass_test() {
    local test_name=$1
    echo -e "${GREEN}✓ PASS${NC} - $test_name"
    log_message "PASS" "$test_name"
    ((TESTS_PASSED++))
}

fail_test() {
    local test_name=$1
    local error_msg=$2
    echo -e "${RED}✗ FAIL${NC} - $test_name"
    echo -e "  ${RED}Error: $error_msg${NC}"
    log_message "FAIL" "$test_name: $error_msg"
    ((TESTS_FAILED++))
}

warn_test() {
    local test_name=$1
    local warning_msg=$2
    echo -e "${YELLOW}⚠ WARN${NC} - $test_name"
    echo -e "  ${YELLOW}Warning: $warning_msg${NC}"
    log_message "WARN" "$test_name: $warning_msg"
    ((TESTS_WARNINGS++))
}

test_file_existence() {
    local file_path=$1
    local file_name=$2
    increment_test
    
    if [ -f "$file_path" ]; then
        pass_test "File existence: $file_name"
        return 0
    else
        fail_test "File existence: $file_name" "File not found: $file_path"
        return 1
    fi
}

test_file_executable() {
    local file_path=$1
    local file_name=$2
    increment_test
    
    if [ -x "$file_path" ]; then
        pass_test "Executable permission: $file_name"
        return 0
    else
        warn_test "Executable permission: $file_name" "File is not executable: $file_path"
        return 1
    fi
}

test_shebang() {
    local file_path=$1
    local file_name=$2
    increment_test
    
    if [ -f "$file_path" ]; then
        local first_line=$(head -n 1 "$file_path")
        if [[ "$first_line" == "#!/bin/bash" ]] || [[ "$first_line" == "#!/usr/bin/env bash" ]]; then
            pass_test "Shebang validation: $file_name"
            return 0
        else
            fail_test "Shebang validation: $file_name" "Invalid shebang: $first_line"
            return 1
        fi
    else
        fail_test "Shebang validation: $file_name" "File not found"
        return 1
    fi
}

test_syntax() {
    local file_path=$1
    local file_name=$2
    increment_test
    
    if [ -f "$file_path" ]; then
        if bash -n "$file_path" 2>/dev/null; then
            pass_test "Syntax validation: $file_name"
            return 0
        else
            local syntax_error=$(bash -n "$file_path" 2>&1)
            fail_test "Syntax validation: $file_name" "Syntax error: $syntax_error"
            return 1
        fi
    else
        fail_test "Syntax validation: $file_name" "File not found"
        return 1
    fi
}

test_dependencies() {
    local dependency=$1
    increment_test
    
    if command -v "$dependency" &> /dev/null; then
        pass_test "Dependency check: $dependency"
        return 0
    else
        warn_test "Dependency check: $dependency" "Command not found"
        return 1
    fi
}

test_help_functionality() {
    local script_path=$1
    local script_name=$2
    increment_test
    
    if [ -f "$script_path" ] && [ -x "$script_path" ]; then
        local help_output=$("$script_path" --help 2>&1)
        if [ $? -eq 0 ] && [ -n "$help_output" ]; then
            pass_test "Help functionality: $script_name"
            return 0
        else
            warn_test "Help functionality: $script_name" "Help option not working or no output"
            return 1
        fi
    else
        fail_test "Help functionality: $script_name" "Script not executable or not found"
        return 1
    fi
}

test_root_prevention() {
    local script_path=$1
    local script_name=$2
    increment_test
    
    if [ -f "$script_path" ]; then
        if grep -q "EUID.*eq.*0" "$script_path" && grep -q "exit.*1" "$script_path"; then
            pass_test "Root prevention: $script_name"
            return 0
        else
            warn_test "Root prevention: $script_name" "No root user prevention found"
            return 1
        fi
    else
        fail_test "Root prevention: $script_name" "File not found"
        return 1
    fi
}

test_internationalization() {
    local script_path=$1
    local script_name=$2
    increment_test
    
    if [ -f "$script_path" ]; then
        if grep -q "LANG_CODE" "$script_path" && grep -q "MSG_" "$script_path"; then
            pass_test "Internationalization: $script_name"
            return 0
        else
            warn_test "Internationalization: $script_name" "No i18n support found"
            return 1
        fi
    else
        fail_test "Internationalization: $script_name" "File not found"
        return 1
    fi
}

test_security_features() {
    local script_path=$1
    local script_name=$2
    increment_test
    
    if [ -f "$script_path" ]; then
        local security_score=0
        
        # Check for password handling
        if grep -q "read.*-s" "$script_path"; then
            ((security_score++))
        fi
        
        # Check for input validation
        if grep -q "validate\|sanitize\|\[ -n.*\]" "$script_path"; then
            ((security_score++))
        fi
        
        # Check for root prevention
        if grep -q "EUID.*eq.*0" "$script_path"; then
            ((security_score++))
        fi
        
        if [ $security_score -ge 2 ]; then
            pass_test "Security features: $script_name"
            return 0
        else
            warn_test "Security features: $script_name" "Minimal security features ($security_score/3)"
            return 1
        fi
    else
        fail_test "Security features: $script_name" "File not found"
        return 1
    fi
}

# Test NetworkManager functionality
test_networkmanager() {
    increment_test
    
    if systemctl is-active --quiet NetworkManager; then
        pass_test "NetworkManager service status"
    else
        warn_test "NetworkManager service status" "NetworkManager is not active"
    fi
    
    increment_test
    if nmcli device status &> /dev/null; then
        pass_test "nmcli basic functionality"
    else
        fail_test "nmcli basic functionality" "nmcli command failed"
    fi
}

# Test all versions
test_all_versions() {
    echo -e "${CYAN}Testing Core Files...${NC}"
    echo "=================================="
    
    # Test main konekwifi script
    test_file_existence "konekwifi" "konekwifi (main script)"
    test_file_executable "konekwifi" "konekwifi"
    test_shebang "konekwifi" "konekwifi"
    test_syntax "konekwifi" "konekwifi"
    test_help_functionality "./konekwifi" "konekwifi"
    test_root_prevention "konekwifi" "konekwifi"
    
    echo ""
    echo -e "${CYAN}Testing Enhanced Versions...${NC}"
    echo "=================================="
    
    # Test v3 enhanced version
    test_file_existence "konekwifi-v3" "konekwifi-v3 (enhanced CLI)"
    test_file_executable "konekwifi-v3" "konekwifi-v3"
    test_shebang "konekwifi-v3" "konekwifi-v3"
    test_syntax "konekwifi-v3" "konekwifi-v3"
    test_internationalization "konekwifi-v3" "konekwifi-v3"
    test_security_features "konekwifi-v3" "konekwifi-v3"
    
    # Test GUI version
    test_file_existence "konekwifi-gui" "konekwifi-gui (GUI version)"
    test_file_executable "konekwifi-gui" "konekwifi-gui"
    test_shebang "konekwifi-gui" "konekwifi-gui"
    test_syntax "konekwifi-gui" "konekwifi-gui"
    test_internationalization "konekwifi-gui" "konekwifi-gui"
    test_security_features "konekwifi-gui" "konekwifi-gui"
    
    # Test disconnect versions
    test_file_existence "putuswifi-v3" "putuswifi-v3 (enhanced disconnect)"
    test_file_executable "putuswifi-v3" "putuswifi-v3"
    test_shebang "putuswifi-v3" "putuswifi-v3"
    test_syntax "putuswifi-v3" "putuswifi-v3"
    test_internationalization "putuswifi-v3" "putuswifi-v3"
    test_security_features "putuswifi-v3" "putuswifi-v3"
    
    echo ""
    echo -e "${CYAN}Testing Installation Files...${NC}"
    echo "=================================="
    
    # Test installation scripts
    test_file_existence "install.sh" "install.sh"
    test_file_executable "install.sh" "install.sh"
    test_syntax "install.sh" "install.sh"
    
    test_file_existence "uninstall.sh" "uninstall.sh"
    test_file_executable "uninstall.sh" "uninstall.sh"
    test_syntax "uninstall.sh" "uninstall.sh"
    
    echo ""
    echo -e "${CYAN}Testing Dependencies...${NC}"
    echo "=================================="
    
    # Test dependencies
    test_dependencies "nmcli"
    test_dependencies "zenity"
    test_dependencies "systemctl"
    test_networkmanager
    
    echo ""
    echo -e "${CYAN}Testing Documentation...${NC}"
    echo "=================================="
    
    # Test documentation
    test_file_existence "README.md" "README.md"
    test_file_existence "CHANGELOG.md" "CHANGELOG.md"
    test_file_existence "DEVELOPER.md" "DEVELOPER.md"
    test_file_existence "QUICKSTART.md" "QUICKSTART.md"
    test_file_existence "LICENSE" "LICENSE"
}

# Performance test
test_performance() {
    echo ""
    echo -e "${CYAN}Performance Tests...${NC}"
    echo "=================================="
    
    increment_test
    local start_time=$(date +%s.%N)
    nmcli device wifi list &> /dev/null
    local end_time=$(date +%s.%N)
    local duration=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "N/A")
    
    if [ "$duration" != "N/A" ] && (( $(echo "$duration < 5.0" | bc -l 2>/dev/null || echo 0) )); then
        pass_test "WiFi scan performance: ${duration}s"
    else
        warn_test "WiFi scan performance" "Slow response time: ${duration}s"
    fi
}

# Generate test report
generate_report() {
    echo ""
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}             TEST RESULTS SUMMARY              ${NC}"
    echo -e "${BLUE}================================================${NC}"
    echo ""
    echo -e "Total Tests:   ${CYAN}$TESTS_TOTAL${NC}"
    echo -e "Passed:        ${GREEN}$TESTS_PASSED${NC}"
    echo -e "Failed:        ${RED}$TESTS_FAILED${NC}"
    echo -e "Warnings:      ${YELLOW}$TESTS_WARNINGS${NC}"
    echo ""
    
    local success_rate=$((TESTS_PASSED * 100 / TESTS_TOTAL))
    if [ $success_rate -ge 80 ]; then
        echo -e "Success Rate:  ${GREEN}$success_rate%${NC}"
        echo -e "${GREEN}🎉 Overall Status: GOOD${NC}"
    elif [ $success_rate -ge 60 ]; then
        echo -e "Success Rate:  ${YELLOW}$success_rate%${NC}"
        echo -e "${YELLOW}⚠️  Overall Status: ACCEPTABLE${NC}"
    else
        echo -e "Success Rate:  ${RED}$success_rate%${NC}"
        echo -e "${RED}❌ Overall Status: NEEDS IMPROVEMENT${NC}"
    fi
    
    echo ""
    echo -e "Log file: ${CYAN}$LOG_FILE${NC}"
    echo ""
    
    log_message "INFO" "Test suite completed - Total: $TESTS_TOTAL, Passed: $TESTS_PASSED, Failed: $TESTS_FAILED, Warnings: $TESTS_WARNINGS"
}

# Main execution
main() {
    print_header
    
    # Check if we're in the right directory
    if [ ! -f "konekwifi" ]; then
        echo -e "${RED}❌ Error: konekwifi script not found in current directory${NC}"
        echo -e "${YELLOW}💡 Please run this test from the konekwifi project directory${NC}"
        exit 1
    fi
    
    test_all_versions
    test_performance
    generate_report
    
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}        Test completed successfully!           ${NC}"
    echo -e "${BLUE}================================================${NC}"
}

# Check for help option
if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
    echo "WiFi Connection Manager Test Suite v3.0"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --help, -h    Show this help message"
    echo ""
    echo "This test suite validates:"
    echo "  ✅ File existence and permissions"
    echo "  ✅ Script syntax and shebangs"
    echo "  ✅ Security features"
    echo "  ✅ Internationalization support"
    echo "  ✅ Dependencies and NetworkManager"
    echo "  ✅ Performance metrics"
    echo ""
    echo "Output:"
    echo "  - Colored console output"
    echo "  - Detailed log file in /tmp/"
    echo "  - Comprehensive test report"
    exit 0
fi

# Run main function
main
