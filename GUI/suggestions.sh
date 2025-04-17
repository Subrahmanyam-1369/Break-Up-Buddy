#!/bin/bash
source db_config.sh
user_id=$(cat .session)

mood=$(mysql -N -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" -e \
"SELECT current_mood FROM users WHERE user_id=$user_id;")

quote=$(mysql -N -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" -e \
"SELECT suggestion FROM suggestions WHERE $mood BETWEEN mood_range_start AND mood_range_end AND type='quote' ORDER BY RAND() LIMIT 1;")

movie=$(mysql -N -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" -e \
"SELECT suggestion FROM suggestions WHERE $mood BETWEEN mood_range_start AND mood_range_end AND type='movie' ORDER BY RAND() LIMIT 1;")

music=$(mysql -N -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" -e \
"SELECT suggestion FROM suggestions WHERE $mood BETWEEN mood_range_start AND mood_range_end AND type='music' ORDER BY RAND() LIMIT 1;")

echo -e "💬 Quote: $quote\n🎬 Movie: $movie\n🎵 Music: $music" > tmp_sugg.txt
whiptail --textbox tmp_sugg.txt 20 60
