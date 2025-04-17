#!/bin/bash
source db_config.sh
user_id=$(cat .session)

if whiptail --title "Delete Profile" --yesno "⚠️  Are you sure you want to delete your profile? This action cannot be undone." 10 60; then
  mysql -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" -e "DELETE FROM users WHERE user_id=$user_id;"
  rm .session
  whiptail --title "Deleted" --msgbox "Your profile has been deleted successfully." 10 50
  exit
else
  whiptail --title "Cancelled" --msgbox "Profile deletion cancelled." 10 40
fi
