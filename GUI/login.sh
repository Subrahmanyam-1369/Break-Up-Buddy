#!/bin/bash
source db_config.sh

username=$(whiptail --title "Login" --inputbox "Enter Username:" 10 60 3>&1 1>&2 2>&3)
[ $? -ne 0 ] && exit

password=$(whiptail --title "Login" --passwordbox "Enter Password:" 10 60 3>&1 1>&2 2>&3)
[ $? -ne 0 ] && exit

user_id=$(mysql -N -u$DB_USER -p$DB_PASS -h$DB_HOST -P$DB_PORT -D$DB_NAME -e "SELECT user_id FROM users WHERE username='$username' AND password='$password';")

if [ -z "$user_id" ]; then
    whiptail --title "Login Failed" --msgbox "Invalid username or password." 10 60
    exit 1
else
    echo "$user_id" > .session
    whiptail --title "Login Successful" --msgbox "Welcome, $username!" 10 60
    bash home.sh
fi
