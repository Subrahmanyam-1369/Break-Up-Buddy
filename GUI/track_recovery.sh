#!/bin/bash
source db_config.sh

SESSION_FILE=".session"
if [[ ! -f "$SESSION_FILE" ]]; then
    whiptail --title "Login Required" --msgbox "⚠️  You must be logged in to track your mood." 10 60
    exit 1
fi

user_id=$(cat "$SESSION_FILE")

get_previous_mood() {
    mysql -N -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" \
    -e "SELECT current_mood FROM users WHERE user_id=$user_id;"
}

update_mood() {
    prev_mood=$(get_previous_mood)

    new_mood=$(whiptail --title "Mood Input" --inputbox "🌈 How's your mood today? (1-10)" 10 60 3>&1 1>&2 2>&3)

    if ! [[ "$new_mood" =~ ^[1-9]$|^10$ ]]; then
        whiptail --msgbox "❌ Invalid mood score. Please enter a number between 1 and 10." 10 60
        return
    fi

    mysql -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" \
    -e "UPDATE users SET current_mood=$new_mood WHERE user_id=$user_id;"

    if [ "$new_mood" -eq "$prev_mood" ]; then
        whiptail --msgbox "➖ No mood change today. Consistency is good too. Keep reflecting! ✨" 10 60
    else
        diff=$((new_mood - prev_mood))

        mysql -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" \
        -e "INSERT INTO recovery_progress (user_id, mood_diff, progress_date) VALUES ($user_id, $diff, CURDATE());"

        if [ "$diff" -gt 0 ]; then
            case $diff in
                1) msg="🙂 Slight improvement! One step at a time." ;;
                2) msg="😊 You're feeling noticeably better today! Great going!" ;;
                3) msg="😃 Big improvement! You're healing beautifully!" ;;
                *) msg="🌟 Wow! Major leap in mood. Keep shining and stay positive!" ;;
            esac
        else
            case $diff in
                -1) msg="😐 Slight dip. It's okay to have off days. Be kind to yourself." ;;
                -2) msg="😕 Feeling down today? Tomorrow is a new chance to feel better." ;;
                -3) msg="😔 Tough day? You're not alone—breathe and take it slow." ;;
                *) msg="💔 A big mood drop. Please take care of yourself. You’re doing your best. Reach out if you need support." ;;
            esac
        fi
        whiptail --msgbox "$msg" 12 70
    fi
}

track_mood_menu() {
    while true; do
        choice=$(whiptail --title "🧠 Mood Tracker" --menu "What would you like to do?" 15 60 4 \
        "1" "Update Today's Mood" \
        "2" "View Current Mood" \
        "3" "Back to Main Menu" 3>&1 1>&2 2>&3)

        case "$choice" in
            1) update_mood ;;
            2)
                mood=$(get_previous_mood)
                whiptail --msgbox "🎯 Your current mood score is: $mood" 10 60
                ;;
            3) break ;;
        esac
    done
}

track_mood_menu
