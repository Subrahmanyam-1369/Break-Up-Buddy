#!/bin/bash
source db_config.sh
user_id=$(cat .session)

result=$(mysql -N -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" -e \
"SELECT name, username, age, partner_name, breakup_reason, breakup_date, current_mood, last_contact_date FROM users WHERE user_id=$user_id;")

IFS=$'\t' read -r name username age partner breakup_reason breakup_date mood last_contact <<< "$result"

whiptail --title "Your Profile" --msgbox "👤 Name: $name\n👥 Username: $username\n🎂 Age: $age\n❤️ Partner: $partner\n💔 Reason: $breakup_reason\n📅 Breakup Date: $breakup_date\n😊 Mood: $mood\n🚫 Last Contact: $last_contact" 20 60
