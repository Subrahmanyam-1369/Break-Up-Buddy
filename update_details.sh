#!/bin/bash
source db_config.sh
user_id=$(cat .session)

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

clear

while true; do
  echo -e "${CYAN}========================================"
  echo -e "        ${GREEN}Update Your Details${CYAN}"
  echo -e "========================================${RESET}"
  echo -e "${YELLOW}1.${RESET} Name"
  echo -e "${YELLOW}2.${RESET} Password"
  echo -e "${YELLOW}3.${RESET} Age"
  echo -e "${YELLOW}4.${RESET} Partner Name"
  echo -e "${YELLOW}5.${RESET} Breakup Reason"
  echo -e "${YELLOW}6.${RESET} Breakup Date (YYYY-MM-DD)"
  echo -e "${YELLOW}7.${RESET} Exit"
  echo
  read -p "Enter your choice: " choice

  case $choice in
    1)
      read -p "Enter new name: " val
      field="name"
      ;;
    2)
      read -s -p "Enter new password: " val
      echo
      field="password"
      ;;
    3)
      read -p "Enter new age: " val
      field="age"
      ;;
    4)
      read -p "Enter new partner name: " val
      field="partner_name"
      ;;
    5)
      read -p "Enter new breakup reason: " val
      field="breakup_reason"
      ;;
    6)
      read -p "Enter new breakup date (YYYY-MM-DD): " val
      field="breakup_date"
      ;;
    7)
      echo -e "${CYAN}Exiting update menu.${RESET}"
      break
      ;;
    *)
      echo -e "${RED}Invalid option. Please try again.${RESET}"
      continue
      ;;
  esac

  if mysql -u$DB_USER -p$DB_PASS -h$DB_HOST -P$DB_PORT -D$DB_NAME -e "UPDATE users SET $field='$val' WHERE user_id=$user_id;"; then
    echo -e "${GREEN}$field updated successfully!${RESET}"
  else
    echo -e "${RED}Failed to update $field. Please try again.${RESET}"
  fi

  echo
  sleep 1
done

