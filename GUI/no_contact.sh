#!/bin/bash
source db_config.sh

SESSION_FILE=".session"
if [[ ! -f "$SESSION_FILE" ]]; then
    whiptail --title "Login Required" --msgbox "⚠️ You must be logged in to access No Contact Tracker." 10 60
    exit 1
fi

user_id=$(cat "$SESSION_FILE")

update_last_contact() {
    last_contact=$(whiptail --title "Last Contact Date" --inputbox "📅 Enter last contact date with your ex (YYYY-MM-DD):" 10 60 3>&1 1>&2 2>&3)

    if ! [[ "$last_contact" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        whiptail --msgbox "❌ Invalid date format. Please use YYYY-MM-DD." 10 60
        return
    fi

    mysql -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" \
    -e "UPDATE users SET last_contact_date='$last_contact' WHERE user_id=$user_id;"

    if [[ $? -eq 0 ]]; then
        whiptail --msgbox "✅ Last contact date updated." 10 60
    else
        whiptail --msgbox "❌ Failed to update date." 10 60
    fi
}

view_no_contact_progress() {
    days=$(mysql -N -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" \
    -e "SELECT DATEDIFF(CURDATE(), last_contact_date) FROM users WHERE user_id=$user_id;")

    msg="📆 You’ve been in No Contact for $days day(s).
"

    if (( days < 3 )); then
        msg+="💔 It’s just the beginning... Stay strong."
    elif (( days < 10 )); then
        msg+="😟 Still fresh... Remember why you started."
    elif (( days < 20 )); then
        msg+="💪 Two weeks of strength! Keep going!"
    elif (( days < 30 )); then
        msg+="🔥 Almost a month! Don’t look back."
    elif (( days < 60 )); then
        msg+="🌱 Over a month of healing. Be proud!"
    elif (( days < 90 )); then
        msg+="🌼 Nearly 3 months! You're blooming."
    else
        msg+="🦋 You’ve come so far. Keep shining."
    fi

    whiptail --msgbox "$msg" 15 70
}

no_contact_menu() {
    while true; do
        choice=$(whiptail --title "🚫 No Contact Tracker" --menu "Select an option" 15 60 4 \
        "1" "Update last contact date" \
        "2" "View No Contact progress" \
        "3" "Back to Main Menu" 3>&1 1>&2 2>&3)

        case "$choice" in
            1) update_last_contact ;;
            2) view_no_contact_progress ;;
            3) break ;;
        esac
    done
}

no_contact_menu
