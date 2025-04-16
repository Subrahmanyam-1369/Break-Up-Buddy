#!/bin/bash
source db_config.sh

echo "Enter username:"
read username
echo "Enter password:"
read -s password

user_id=$(mysql -N -u$DB_USER -p$DB_PASS -h$DB_HOST -P$DB_PORT -D$DB_NAME -e "SELECT user_id FROM users WHERE username='$username' AND password='$password';")

if [ -z "$user_id" ]; then
  echo "Login failed. Please try again."
  exit 1
else
  echo "Login successful! Welcome $username"
  echo "$user_id" > .session
  bash home.sh
fi
