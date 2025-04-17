#!/bin/bash
source db_config.sh

SESSION_FILE=".session"
if [[ ! -f "$SESSION_FILE" ]]; then
    echo "⚠️  You must be logged in to track mood."
    return 1
fi

user_id=$(cat "$SESSION_FILE")

get_previous_mood() {
    mysql -N -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" \
    -e "SELECT current_mood FROM users WHERE user_id=$user_id;"
}

update_mood() {
    prev_mood=$(get_previous_mood)

    echo ""
    echo "🌈 On a scale of 1 to 10, how's your mood today?"
    read new_mood

    # Validate mood
    if ! [[ "$new_mood" =~ ^[1-9]$|^10$ ]]; then
        echo "❌ Invalid mood score. Please enter a number between 1 and 10."
        return
    fi

    # Update user mood
    mysql -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" \
    -e "UPDATE users SET current_mood=$new_mood WHERE user_id=$user_id;"

    # Track progress
    if [ "$new_mood" -eq "$prev_mood" ]; then
        echo "➖ No mood change today. Consistency is good too. Keep reflecting! ✨"
    else
        diff=$((new_mood - prev_mood))

        mysql -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" \
        -e "INSERT INTO recovery_progress (user_id, mood_diff, progress_date) VALUES ($user_id, $diff, CURDATE());"

        if [ "$diff" -gt 0 ]; then
            case $diff in
                1) echo "🙂 Slight improvement! One step at a time." ;;
                2) echo "😊 You're feeling noticeably better today! Great going!" ;;
                3) echo "😃 Big improvement! You're healing beautifully!" ;;
                *) echo "🌟 Wow! Major leap in mood. Keep shining and stay positive!" ;;
            esac
        else
            case $diff in
                -1) echo "😐 Slight dip. It's okay to have off days. Be kind to yourself." ;;
                -2) echo "😕 Feeling down today? Tomorrow is a new chance to feel better." ;;
                -3) echo "😔 Tough day? You're not alone—breathe and take it slow." ;;
                *) echo "💔 A big mood drop. Please take care of yourself. You’re doing your best. Reach out if you need support." ;;
            esac
        fi
    fi
}

track_mood_menu() {
    while true; do
        echo ""
        echo "🧠 Mood Tracker Menu"
        echo "-----------------------"
        echo "1. Update Today's Mood"
        echo "2. View Current Mood"
        echo "3. Back to Main Menu"
        echo ""

        read -p "Choose an option [1-3]: " choice
        case "$choice" in
            1) update_mood ;;
            2) mood=$(get_previous_mood); echo "🎯 Your current mood score is: $mood" ;;
            3) echo "🔙 Returning to Main Menu..."; break ;;
            *) echo "❌ Invalid option. Please try again." ;;
        esac
    done
}

# Start the mood tracker
track_mood_menu

