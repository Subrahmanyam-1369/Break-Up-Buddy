#!/bin/bash
source db_config.sh

echo "Enter your name:"
read name
echo "Choose a username:"
read username
echo "Create a password:"
read -s password
echo "Enter your age:"
read age
echo "Enter your partner's name:"
read partner_name
echo "Enter breakup reason:"
read breakup_reason
echo "Enter breakup date (YYYY-MM-DD):"
read breakup_date
echo "On a scale of 1 to 10, how is your mood right now?"
read current_mood

query="INSERT INTO users (name, username, password, age, partner_name, breakup_reason, breakup_date, current_mood)
VALUES ('$name', '$username', '$password', $age, '$partner_name', '$breakup_reason', '$breakup_date', $current_mood);"

mysql -u$DB_USER -p$DB_PASS -h$DB_HOST -P$DB_PORT -D$DB_NAME -e "$query"
