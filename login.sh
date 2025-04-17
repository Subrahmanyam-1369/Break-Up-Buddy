#!/bin/bash
source db_config.sh

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'  # Reset to default color

# Clear the screen
clear

# Display header
echo -e "${CYAN}========================================="
echo -e "            ===== ${GREEN}Login Page${CYAN} =====           "
echo -e "=========================================${RESET}"
echo

# Prompt for username and password
echo -ne "${YELLOW}Enter username:${RESET} "
read username
echo -ne "${YELLOW}Enter password:${RESET} "
read -s password
echo

# Attempt login
user_id=$(mysql -N -u$DB_USER -p$DB_PASS -h$DB_HOST -P$DB_PORT -D$DB_NAME -e "SELECT user_id FROM users WHERE username='$username' AND password='$password';")

# Login validation
if [ -z "$user_id" ]; then
  echo -e "${RED}Login failed. Please try again.${RESET}"
  exit 1
else
  echo -e "${GREEN}Login successful! Welcome, ${username}.${RESET}"
  echo "$user_id" > .session
  sleep 1
  clear
  bash home.sh
fi

