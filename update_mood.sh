#!/bin/bash
source db_config.sh
user_id=$(cat .session)

echo "Enter your current mood (1 to 10):"
read mood

mysql -u$DB_USER -p$DB_PASS -h$DB_HOST -P$DB_PORT -D$DB_NAME -e \
"UPDATE users SET current_mood=$mood WHERE user_id=$user_id;
 INSERT INTO mood_tracker (user_id, mood_score, mood_date) VALUES ($user_id, $mood, CURDATE());"
