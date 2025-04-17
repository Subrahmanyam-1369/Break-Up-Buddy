#!/bin/bash
source db_config.sh
user_id=$(cat .session)

mood=$(whiptail --title "Mood Tracker" --inputbox "Enter your current mood (1-10):" 10 60 3>&1 1>&2 2>&3)

if ! [[ "$mood" =~ ^[1-9]$|^10$ ]]; then
    whiptail --msgbox "Invalid mood score. Must be between 1 and 10." 10 60
    exit
fi

mysql -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" \
-e "UPDATE users SET current_mood=$mood WHERE user_id=$user_id; \
INSERT INTO mood_tracker (user_id, mood_score, mood_date) VALUES ($user_id, $mood, CURDATE());"

whiptail --msgbox "Mood updated to $mood. Keep going!" 10 60
