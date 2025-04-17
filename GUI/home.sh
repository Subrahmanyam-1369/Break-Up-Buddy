#!/bin/bash
source db_config.sh

SESSION_FILE=".session"
if [[ ! -f "$SESSION_FILE" ]]; then
    whiptail --title "Not Logged In" --msgbox "⚠️  You must be logged in to access Home Menu." 10 50
    exit 1
fi

user_id=$(cat "$SESSION_FILE")

while true; do
  opt=$(whiptail --title "🏠 Home Menu" --menu "What would you like to do?" 20 60 10 \
    "1" "Update Details" \
    "2" "View Profile" \
    "3" "Journal" \
    "4" "Update Mood" \
    "5" "Track Recovery Progress" \
    "6" "No Contact Tracker" \
    "7" "Get Suggestions" \
    "8" "Delete Profile" \
    "9" "Exit" 3>&1 1>&2 2>&3)

  [ $? -ne 0 ] && exit

  case $opt in
    1) bash update_details.sh ;;
    2) bash view_profile.sh ;;
    3) bash journal.sh ;;
    4) bash update_mood.sh ;;
    5) bash track_recovery.sh ;;
    6) bash no_contact.sh ;;
    7) bash suggestions.sh ;;
    8)
      if whiptail --title "Delete Profile" --yesno "⚠️  Are you sure you want to delete your profile? This action cannot be undone." 10 60; then
        mysql -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" -e \
          "DELETE FROM users WHERE user_id=$user_id;"
        rm -f .session
        whiptail --title "Profile Deleted" --msgbox "✅ Your profile has been deleted.\nYou'll now be redirected to login." 10 50
        bash main.sh
        exit
      fi
      ;;
    9)
      rm -f .session
      exit
      ;;
  esac
done
