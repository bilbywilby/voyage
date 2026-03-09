#!/bin/bash
#
# SCRIPT NAME: termux_setup_and_info.sh
# DESCRIPTION: A robust utility script for basic Termux setup, package installation, 
#              and system information display.
# AUTHOR: Gemini AI Assistant (Expert Catch-All Model)
# DATE: November 2025

# --- Global Variables ---
ESSENTIAL_PACKAGES="git python nano neofetch w3m openssh"

# --- Functions ---

# Function to display the main menu
show_menu() {
    clear
    echo "================================================="
    echo "🚀 Termux System Utility Menu 🚀"
    echo "================================================="
    echo "1) 🔄 Update & Upgrade Termux Packages"
    echo "2) 📦 Install Essential Development Tools"
    echo "3) ℹ️ Display Detailed System Information"
    echo "4) 🚪 Exit Script"
    echo "-------------------------------------------------"
}

# Function to perform system update and upgrade
update_system() {
    echo -e "\n--- Starting System Update and Upgrade ---"
    # Using 'pkg' (Termux package manager)
    pkg update -y && pkg upgrade -y
    if [ $? -eq 0 ]; then
        echo -e "\n✅ System update and upgrade complete."
    else
        echo -e "\n❌ Error during update/upgrade. Check your connection."
    fi
}

# Function to install essential packages
install_essentials() {
    echo -e "\n--- Installing Essential Tools: ${ESSENTIAL_PACKAGES} ---"
    # Check if neofetch is installed first (used for system info)
    pkg install -y neofetch > /dev/null 2>&1
    
    # Install all other essential packages
    for package in $ESSENTIAL_PACKAGES; do
        if pkg install -y $package; then
            echo "   [OK] Installed $package"
        else
            echo "   [FAIL] Could not install $package"
        fi
    done
    
    echo -e "\n✅ Essential tool installation complete."
}

# Function to display system information using neofetch
show_info() {
    # Check if neofetch is installed, install if not
    if ! command -v neofetch &> /dev/null; then
        echo "Neofetch not found. Installing now..."
        pkg install -y neofetch
    fi
    
    echo -e "\n--- Termux System Information ---"
    neofetch
    echo "----------------------------------------"
    echo "Current Working Directory: $(pwd)"
    echo "Termux User Home: $HOME"
    echo "----------------------------------------"
}

# --- Main Execution Loop ---

while true; do
    show_menu
    read -p "Enter your choice (1-4): " choice
    
    case $choice in
        1) 
            update_system
            read -p "Press ENTER to return to the menu..."
            ;;
        2) 
            install_essentials
            read -p "Press ENTER to return to the menu..."
            ;;
        3) 
            show_info
            read -p "Press ENTER to return to the menu..."
            ;;
        4) 
            echo -e "\n👋 Exiting script. Goodbye!"
            break
            ;;
        *) 
            echo -e "\n❌ Invalid option: $choice. Please enter a number between 1 and 4."
            sleep 2
            ;;
    esac
done
# --- End of Script ---

