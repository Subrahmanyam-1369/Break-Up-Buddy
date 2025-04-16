#!/bin/bash

source db_config.sh

SESSION_FILE=".session"
if [[ ! -f "$SESSION_FILE" ]]; then
    echo "⚠️  You must be logged in to access journal features."
    return 1
fi

SESSION_USER_ID=$(cat "$SESSION_FILE")

write_journal_entry() {
    echo "📝 Start typing your journal entry. Press ENTER on an empty line to finish:"
    entry=""
    while IFS= read -r line; do
        [[ -z "$line" ]] && break
        entry+="$line"$'\n'
    done

    if [[ -z "$entry" ]]; then
        echo "⚠️  Empty entry not saved."
        return
    fi

    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" <<EOF
INSERT INTO journal_entries (user_id, entry, entry_date)
VALUES ($SESSION_USER_ID, '$(echo "$entry" | sed "s/'/\\\'/g")', CURDATE());
EOF

    [[ $? -eq 0 ]] && echo "✅ Journal entry saved." || echo "❌ Failed to save entry."
}

view_all_journals() {
    echo "📖 All Journal Entries:"
    echo "------------------------"
    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e \
    "SELECT id, entry_date, entry FROM journal_entries WHERE user_id=$SESSION_USER_ID ORDER BY entry_date DESC;"
}

view_journals_grouped() {
    echo "📅 Journal Entries Grouped by Date:"
    echo "-----------------------------------"
    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e \
    "SELECT entry_date, GROUP_CONCAT(entry SEPARATOR '\n---\n') AS entries FROM journal_entries WHERE user_id=$SESSION_USER_ID GROUP BY entry_date ORDER BY entry_date DESC;"
}

delete_entry() {
    read -p "🗑️  Enter the ID of the journal entry to delete: " entry_id
    [[ -z "$entry_id" ]] && echo "⚠️  Entry ID cannot be empty." && return

    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e \
    "DELETE FROM journal_entries WHERE id=$entry_id AND user_id=$SESSION_USER_ID;"

    [[ $? -eq 0 ]] && echo "✅ Entry deleted (if it existed and belonged to you)." || echo "❌ Failed to delete entry."
}

edit_entry() {
    read -p "✏️  Enter the ID of the journal entry to edit: " entry_id
    [[ -z "$entry_id" ]] && echo "⚠️  Entry ID cannot be empty." && return

    echo "📝 Enter the new journal content. Press ENTER on a blank line to finish:"
    new_entry=""
    while IFS= read -r line; do
        [[ -z "$line" ]] && break
        new_entry+="$line"$'\n'
    done

    if [[ -z "$new_entry" ]]; then
        echo "⚠️  Empty entry not saved."
        return
    fi

    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e \
    "UPDATE journal_entries SET entry='$(echo "$new_entry" | sed "s/'/\\\'/g")' WHERE id=$entry_id AND user_id=$SESSION_USER_ID;"

    [[ $? -eq 0 ]] && echo "✅ Entry updated." || echo "❌ Failed to update entry."
}

journal_menu() {
    while true; do
        echo ""
        echo "📓 Journal Menu"
        echo "---------------"
        echo "1. Write a new journal entry"
        echo "2. View all journal entries"
        echo "3. View entries grouped by date"
        echo "4. Delete a journal entry"
        echo "5. Edit a journal entry"
        echo "6. Back to Main Menu"
        echo ""

        read -p "Choose an option [1-6]: " opt
        case "$opt" in
            1) write_journal_entry ;;
            2) view_all_journals ;;
            3) view_journals_grouped ;;
            4) delete_entry ;;
            5) edit_entry ;;
            6) echo "🔙 Returning to Main Menu..."; break ;;
            *) echo "❌ Invalid option. Please try again." ;;
        esac
    done
}

# Launch the menu if called directly
journal_menu
