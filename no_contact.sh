#!/bin/bash
source db_config.sh

SESSION_FILE=".session"
if [[ ! -f "$SESSION_FILE" ]]; then
    echo "⚠️  You must be logged in to access No Contact Tracker."
    return 1
fi

user_id=$(cat "$SESSION_FILE")

update_last_contact() {
    echo "📅 Enter last contact date with your ex (YYYY-MM-DD):"
    read last_contact

    if ! [[ "$last_contact" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        echo "❌ Invalid date format. Please use YYYY-MM-DD."
        return
    fi

    mysql -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" -e \
    "UPDATE users SET last_contact_date='$last_contact' WHERE user_id=$user_id;"

    [[ $? -eq 0 ]] && echo "✅ Last contact date updated." || echo "❌ Failed to update date."
}

view_no_contact_progress() {
    days=$(mysql -N -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" -e \
    "SELECT DATEDIFF(CURDATE(), last_contact_date) FROM users WHERE user_id=$user_id;")

    echo ""
    echo "📆 You’ve been in No Contact for **$days day(s)**."

    if (( days < 3 )); then
        echo "💔 It’s just the beginning... Stay strong."
    elif (( days < 10 )); then
        echo "😟 Still fresh... Remember why you started."
    elif (( days < 20 )); then
        echo "💪 Two weeks of strength! Keep going!"
    elif (( days < 30 )); then
        echo "🔥 Almost a month! Don’t look back."
    elif (( days < 60 )); then
        echo "🌱 Over a month of healing. Be proud!"
    elif (( days < 90 )); then
        echo "🌼 Nearly 3 months! You're blooming."
    else
        echo "🦋 You’ve come so far. Keep shining."
    fi
}

no_contact_menu() {
    while true; do
        echo ""
        echo "🚫 No Contact Tracker"
        echo "----------------------"
        echo "1. Update last contact date"
        echo "2. View No Contact progress"
        echo "3. Back to Main Menu"
        echo ""

        read -p "Choose an option [1-3]: " choice
        case "$choice" in
            1) update_last_contact ;;
            2) view_no_contact_progress ;;
            3) echo "🔙 Returning to Main Menu..."; return ;;
            *) echo "❌ Invalid option. Please try again." ;;
        esac
    done
}

# Only call if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    no_contact_menu
fi
