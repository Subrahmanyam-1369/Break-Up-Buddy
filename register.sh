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

# Header
echo -e "${CYAN}============================================"
echo -e "         ===== ${GREEN}Register User${CYAN} =====         "
echo -e "============================================${RESET}"
echo

# Registration prompts
echo -ne "${YELLOW}Enter your name: ${RESET}"
read name

echo -ne "${YELLOW}Choose a username: ${RESET}"
read username

echo -ne "${YELLOW}Create a password: ${RESET}"
read -s password
echo

echo -ne "${YELLOW}Enter your age: ${RESET}"
read age

echo -ne "${YELLOW}Enter your partner's name: ${RESET}"
read partner_name

echo -ne "${YELLOW}Enter breakup reason: ${RESET}"
read breakup_reason

echo -ne "${YELLOW}Enter breakup date (YYYY-MM-DD): ${RESET}"
read breakup_date

echo -ne "${YELLOW}On a scale of 1 to 10, how is your mood right now? ${RESET}"
read current_mood

# SQL query
query="INSERT INTO users (name, username, password, age, partner_name, breakup_reason, breakup_date, current_mood)
VALUES ('$name', '$username', '$password', $age, '$partner_name', '$breakup_reason', '$breakup_date', $current_mood);"

# Execute query
if mysql -u$DB_USER -p$DB_PASS -h$DB_HOST -P$DB_PORT -D$DB_NAME -e "$query"; then
  echo -e "\n${GREEN}Registration successful! You can now log in.${RESET}"
else
  echo -e "\n${RED}Registration failed. Please check your inputs and try again.${RESET}"
fi

