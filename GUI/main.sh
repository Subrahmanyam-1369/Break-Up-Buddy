#!/bin/bash

while true; do
    CHOICE=$(whiptail --title "Breakup Buddy CLI" --menu "Choose an option" 15 50 4 \
    "1" "Login" \
    "2" "Register" \
    "3" "Exit" 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        break
    fi

    case $CHOICE in
        1)
            bash login.sh
            ;;
        2)
            bash register.sh
            ;;
        3)
            break
            ;;
    esac
done
