#!/bin/bash
source db_config.sh
user_id=$(cat .session)

while true; do
  echo "Select field to update:"
  echo "1. Name"
  echo "2. Password"
  echo "3. Age"
  echo "4. Partner Name"
  echo "5. Breakup Reason"
  echo "6. Breakup Date"
  echo "7. Exit"
  read -p "Choice: " choice

  case $choice in
    1) read -p "New name: " val; field="name" ;;
    2) read -s -p "New password: " val; echo; field="password" ;;
    3) read -p "New age: " val; field="age" ;;
    4) read -p "New partner name: " val; field="partner_name" ;;
    5) read -p "New breakup reason: " val; field="breakup_reason" ;;
    6) read -p "New breakup date (YYYY-MM-DD): " val; field="breakup_date" ;;
    7) break ;;
    *) echo "Invalid"; continue ;;
  esac

  mysql -u$DB_USER -p$DB_PASS -h$DB_HOST -P$DB_PORT -D$DB_NAME -e "UPDATE users SET $field='$val' WHERE user_id=$user_id;"
done
