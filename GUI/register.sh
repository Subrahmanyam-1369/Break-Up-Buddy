#!/bin/bash
source db_config.sh

name=$(whiptail --title "Register" --inputbox "Enter your name:" 10 60 3>&1 1>&2 2>&3) || exit
username=$(whiptail --title "Register" --inputbox "Choose a username:" 10 60 3>&1 1>&2 2>&3) || exit
password=$(whiptail --title "Register" --passwordbox "Create a password:" 10 60 3>&1 1>&2 2>&3) || exit
age=$(whiptail --title "Register" --inputbox "Enter your age:" 10 60 3>&1 1>&2 2>&3) || exit
partner_name=$(whiptail --title "Register" --inputbox "Enter your partner's name:" 10 60 3>&1 1>&2 2>&3) || exit
breakup_reason=$(whiptail --title "Register" --inputbox "Enter breakup reason:" 10 60 3>&1 1>&2 2>&3) || exit
breakup_date=$(whiptail --title "Register" --inputbox "Enter breakup date (YYYY-MM-DD):" 10 60 3>&1 1>&2 2>&3) || exit
current_mood=$(whiptail --title "Register" --inputbox "On a scale of 1 to 10, how is your mood?" 10 60 3>&1 1>&2 2>&3) || exit

query="INSERT INTO users (name, username, password, age, partner_name, breakup_reason, breakup_date, current_mood)
VALUES ('$name', '$username', '$password', $age, '$partner_name', '$breakup_reason', '$breakup_date', $current_mood);"

if mysql -u$DB_USER -p$DB_PASS -h$DB_HOST -P$DB_PORT -D$DB_NAME -e "$query"; then
  whiptail --title "Success" --msgbox "Registration successful!" 10 60
else
  whiptail --title "Error" --msgbox "Registration failed!" 10 60
fi
