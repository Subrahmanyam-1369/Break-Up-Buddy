#!/bin/bash
source db_config.sh

SESSION_FILE=".session"
if [[ ! -f "$SESSION_FILE" ]]; then
    echo "⚠️  You must be logged in to see suggestions."
    exit 1
fi

user_id=$(cat "$SESSION_FILE")

mood=$(mysql -N -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" \
-e "SELECT current_mood FROM users WHERE user_id=$user_id;")

echo "🎯 Your current mood: $mood"
echo ""

get_random_suggestion() {
    local type="$1"
    mysql -N -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" \
    -e "SELECT suggestion FROM suggestions WHERE $mood BETWEEN mood_range_start AND mood_range_end AND type='$type' ORDER BY RAND() LIMIT 1;"
}

echo "💬 Quote Suggestion:"
get_random_suggestion "quote"
echo ""

echo "🎬 Movie Suggestion:"
get_random_suggestion "movie"
echo ""

echo "🎵 Music Suggestion:"
get_random_suggestion "music"
echo ""
