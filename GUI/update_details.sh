#!/bin/bash
source db_config.sh
user_id=$(cat .session)

while true; do
  choice=$(whiptail --title "Update Details" --menu "Select field to update" 20 60 10 \
    "1" "Name" \
    "2" "Password" \
    "3" "Age" \
    "4" "Partner Name" \
    "5" "Breakup Reason" \
    "6" "Breakup Date (YYYY-MM-DD)" \
    "7" "Exit" 3>&1 1>&2 2>&3)

  [ $? -ne 0 ] && break

  case $choice in
    1) field="name"; label="new name" ;;
    2) field="password"; label="new password" ;;
    3) field="age"; label="new age" ;;
    4) field="partner_name"; label="new partner name" ;;
    5) field="breakup_reason"; label="new breakup reason" ;;
    6) field="breakup_date"; label="new breakup date (YYYY-MM-DD)" ;;
    7) break ;;
  esac

  val=$(whiptail --inputbox "Enter $label:" 10 60 3>&1 1>&2 2>&3) || continue

  if mysql -u$DB_USER -p$DB_PASS -h$DB_HOST -P$DB_PORT -D$DB_NAME -e "UPDATE users SET $field='$val' WHERE user_id=$user_id;"; then
    whiptail --msgbox "$field updated successfully!" 10 60
  else
    whiptail --msgbox "Failed to update $field." 10 60
  fi
done
