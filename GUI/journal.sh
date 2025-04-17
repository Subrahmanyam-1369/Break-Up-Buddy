#!/bin/bash
source db_config.sh

SESSION_FILE=".session"
if [[ ! -f "$SESSION_FILE" ]]; then
    whiptail --title "Authentication Required" --msgbox "⚠️ You must be logged in to access journal features." 10 60
    exit 1
fi

SESSION_USER_ID=$(cat "$SESSION_FILE")

write_journal_entry() {
    entry=$(whiptail --title "New Journal Entry" --inputbox "Type your entry (single-line only):" 15 60 3>&1 1>&2 2>&3)
    [[ -z "$entry" ]] && return

    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" <<EOF
INSERT INTO journal_entries (user_id, entry, entry_date)
VALUES ($SESSION_USER_ID, '$(echo "$entry" | sed "s/'/\'/g")', CURDATE());
EOF

    [[ $? -eq 0 ]] && whiptail --msgbox "✅ Journal entry saved." 10 60 || whiptail --msgbox "❌ Failed to save entry." 10 60
}

view_all_journals() {
    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e \
    "SELECT id, entry_date, entry FROM journal_entries WHERE user_id=$SESSION_USER_ID ORDER BY entry_date DESC;" > tmp_journal.txt
    whiptail --textbox tmp_journal.txt 20 70
}

view_journals_grouped() {
    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e \
    "SELECT entry_date, GROUP_CONCAT(entry SEPARATOR '\n---\n') AS entries FROM journal_entries WHERE user_id=$SESSION_USER_ID GROUP BY entry_date ORDER BY entry_date DESC;" > tmp_grouped.txt
    whiptail --textbox tmp_grouped.txt 20 70
}

delete_entry() {
    entry_id=$(whiptail --inputbox "Enter the ID of the journal entry to delete:" 10 60 3>&1 1>&2 2>&3)
    [[ -z "$entry_id" ]] && return

    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e \
    "DELETE FROM journal_entries WHERE id=$entry_id AND user_id=$SESSION_USER_ID;"

    [[ $? -eq 0 ]] && whiptail --msgbox "✅ Entry deleted." 10 60 || whiptail --msgbox "❌ Failed to delete entry." 10 60
}

edit_entry() {
    entry_id=$(whiptail --inputbox "Enter the ID of the journal entry to edit:" 10 60 3>&1 1>&2 2>&3)
    [[ -z "$entry_id" ]] && return

    new_entry=$(whiptail --inputbox "Enter the new journal content:" 15 60 3>&1 1>&2 2>&3)
    [[ -z "$new_entry" ]] && return

    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e \
    "UPDATE journal_entries SET entry='$(echo "$new_entry" | sed "s/'/\'/g")' WHERE id=$entry_id AND user_id=$SESSION_USER_ID;"

    [[ $? -eq 0 ]] && whiptail --msgbox "✅ Entry updated." 10 60 || whiptail --msgbox "❌ Failed to update entry." 10 60
}

journal_menu() {
    while true; do
        opt=$(whiptail --title "📓 Journal Menu" --menu "Choose an option" 20 60 10 \
            "1" "Write a new journal entry" \
            "2" "View all journal entries" \
            "3" "View entries grouped by date" \
            "4" "Delete a journal entry" \
            "5" "Edit a journal entry" \
            "6" "Back to Main Menu" 3>&1 1>&2 2>&3)

        case "$opt" in
            1) write_journal_entry ;;
            2) view_all_journals ;;
            3) view_journals_grouped ;;
            4) delete_entry ;;
            5) edit_entry ;;
            6) break ;;
        esac
    done
}

journal_menu
