#!/bin/bash
source db_config.sh

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'  # Reset to default color

user_id=$(cat .session)

while true; do
  # Clear the screen before displaying the menu
  clear
  
  # Displaying the home menu with colors
  echo -e "${CYAN}========================================="
  echo -e "            ===== ${GREEN}Home Menu${CYAN} =====            "
  echo -e "=========================================${RESET}"
  echo
  echo -e "${YELLOW}1.${RESET} Update Details"
  echo -e "${YELLOW}2.${RESET} Journal"
  echo -e "${YELLOW}3.${RESET} Update Mood"
  echo -e "${YELLOW}4.${RESET} Track Recovery Progress"
  echo -e "${YELLOW}5.${RESET} No Contact Tracker"
  echo -e "${YELLOW}6.${RESET} Get Suggestions"
  echo -e "${YELLOW}7.${RESET} Exit"
  echo
  read -p "Choose an option: " opt
  echo
  
  # Process user input with colored feedback
  case $opt in
    1)
      echo -e "${GREEN}You chose to Update Details.${RESET}"
      bash update_details.sh
      ;;
    2)
      echo -e "${GREEN}You chose to Journal.${RESET}"
      bash journal.sh
      ;;
    3)
      echo -e "${GREEN}You chose to Update Mood.${RESET}"
      bash update_mood.sh
      ;;
    4)
      echo -e "${GREEN}You chose to Track Recovery Progress.${RESET}"
      bash track_recovery.sh
      ;;
    5)
      echo -e "${GREEN}You chose No Contact Tracker.${RESET}"
      bash no_contact.sh
      ;;
    6)
      echo -e "${GREEN}You chose Get Suggestions.${RESET}"
      bash suggestions.sh
      ;;
    7)
      echo -e "${RED}Logging out...${RESET}"
      rm .session
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

