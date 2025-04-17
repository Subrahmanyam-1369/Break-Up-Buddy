#!/bin/bash
source db_config.sh

SESSION_FILE=".session"
if [[ ! -f "$SESSION_FILE" ]]; then
    echo "⚠️  You must be logged in to update mood."
    return 1
fi

user_id=$(cat "$SESSION_FILE")

get_current_mood() {
    mysql -N -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" \
    -e "SELECT current_mood FROM users WHERE user_id=$user_id;"
}

update_mood() {
    echo "🌈 Enter your current mood (1 to 10):"
    read mood

    # Validate mood input
    if ! [[ "$mood" =~ ^[1-9]$|^10$ ]]; then
        echo "❌ Invalid mood score. Please enter a number between 1 and 10."
        return
    fi

    # Update mood in the database
    mysql -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" \
    -e "UPDATE users SET current_mood=$mood WHERE user_id=$user_id;
         INSERT INTO mood_tracker (user_id, mood_score, mood_date) VALUES ($user_id, $mood, CURDATE());"

    echo "🎯 Your mood has been updated to $mood. Keep going! 🌟"
}

view_current_mood() {
    current_mood=$(get_current_mood)
    echo "🎯 Your current mood score is: $current_mood"
}

update_mood_menu() {
    while true; do
        echo ""
        echo "🧠 Mood Tracker Menu"
        echo "--------------------"
        echo "1. Update Today's Mood"
        echo "2. View Current Mood"
        echo "3. Back to Main Menu"
        echo ""

        read -p "Choose an option [1-3]: " choice
        case "$choice" in
            1) update_mood ;;
            2) view_current_mood ;;
            3) echo "🔙 Returning to Main Menu..."; break ;;
            *) echo "❌ Invalid option. Please try again." ;;
        esac
    done
}

# Start the mood tracker menu
update_mood_menu

