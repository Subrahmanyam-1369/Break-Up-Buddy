#!/bin/bash
source db_config.sh

SESSION_FILE=".session"
if [[ ! -f "$SESSION_FILE" ]]; then
    echo "⚠️  You must be logged in to see suggestions."
    return 1
fi

user_id=$(cat "$SESSION_FILE")

get_mood() {
    mood=$(mysql -N -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" \
    -e "SELECT current_mood FROM users WHERE user_id=$user_id;")
    echo "🎯 Your current mood: $mood"
}

get_random_suggestion() {
    local type="$1"
    mysql -N -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" \
    -e "SELECT suggestion FROM suggestions WHERE $mood BETWEEN mood_range_start AND mood_range_end AND type='$type' ORDER BY RAND() LIMIT 1;"
}

show_all_suggestions() {
    get_mood
    echo ""
    echo "💬 Quote Suggestion:"
    get_random_suggestion "quote"
    echo ""

    echo "🎬 Movie Suggestion:"
    get_random_suggestion "movie"
    echo ""

    echo "🎵 Music Suggestion:"
    get_random_suggestion "music"
    echo ""
}

suggestion_menu() {
    while true; do
        echo ""
        echo "💡 Suggestions Based on Your Mood"
        echo "----------------------------------"
        echo "1. Show Quote Suggestion"
        echo "2. Show Movie Suggestion"
        echo "3. Show Music Suggestion"
        echo "4. Show All Suggestions"
        echo "5. Back to Main Menu"
        echo ""

        read -p "Choose an option [1-5]: " choice
        get_mood
        case "$choice" in
            1) echo ""; echo "💬 Quote Suggestion:"; get_random_suggestion "quote"; echo "" ;;
            2) echo ""; echo "🎬 Movie Suggestion:"; get_random_suggestion "movie"; echo "" ;;
            3) echo ""; echo "🎵 Music Suggestion:"; get_random_suggestion "music"; echo "" ;;
            4) show_all_suggestions ;;
            5) echo "🔙 Returning to Main Menu..."; break ;;
            *) echo "❌ Invalid option. Please try again." ;;
        esac
    done
}

# Launch the menu
suggestion_menu

