#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'  # Reset to default color

while true; do
  # Clear the terminal window to give a fresh start for each new interaction
  clear
  
  # Displaying the main menu with borders and colors
  echo -e "${CYAN}========================================="
  echo -e "        ===== ${GREEN}Breakup Buddy CLI${CYAN} =====     "
  echo -e "=========================================${RESET}"
  echo
  echo -e "${YELLOW}1.${RESET} Login"
  echo -e "${YELLOW}2.${RESET} Register"
  echo -e "${YELLOW}3.${RESET} Exit"
  echo
  read -p "Choose an option: " choice
  echo
  
  # Process user input
  case $choice in
    1)
      echo -e "${GREEN}You chose to Login.${RESET}"
      echo "Please enter your credentials..."
      bash login.sh
      clear   # Clear the screen after login
      ;;
    2)
      echo -e "${GREEN}You chose to Register.${RESET}"
      echo "Please fill in your details..."
      bash register.sh
      ;;
    3)
      echo -e "${RED}Goodbye! Take care.${RESET}"
      exit
      ;;
    *)
      echo -e "${RED}Invalid option. Please try again.${RESET}"
      ;;
  esac
  
  # Adding space before showing the menu again for better readability
  echo
  echo -e "${CYAN}=========================================${RESET}"
done

