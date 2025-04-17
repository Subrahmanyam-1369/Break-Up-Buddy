#!/bin/bash

# Load DB config
source db_config.sh

# Colors
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

SESSION_FILE=".session"
if [[ ! -f "$SESSION_FILE" ]]; then
    echo -e "${RED}⚠️  You must be logged in to access journal features.${NC}"
    return 1
fi

SESSION_USER_ID=$(cat "$SESSION_FILE")

write_journal_entry() {
    echo -e "${CYAN}📝 Start typing your journal entry. Press ENTER on an empty line to finish:${NC}"
    entry=""
    while IFS= read -r line; do
        [[ -z "$line" ]] && break
        entry+="$line"$'\n'
    done

    if [[ -z "$entry" ]]; then
        echo -e "${YELLOW}⚠️  Empty entry not saved.${NC}"
        return
    fi

    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" <<EOF
INSERT INTO journal_entries (user_id, entry, entry_date)
VALUES ($SESSION_USER_ID, '$(echo "$entry" | sed "s/'/\\\'/g")', CURDATE());
EOF

    [[ $? -eq 0 ]] && echo -e "${GREEN}✅ Journal entry saved.${NC}" || echo -e "${RED}❌ Failed to save entry.${NC}"
}

view_all_journals() {
    echo -e "${CYAN}📖 All Journal Entries:${NC}"
    echo "------------------------"
    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e \
    "SELECT id, entry_date, entry FROM journal_entries WHERE user_id=$SESSION_USER_ID ORDER BY entry_date DESC;"
}

view_journals_grouped() {
    echo -e "${CYAN}📅 Journal Entries Grouped by Date:${NC}"
    echo "-----------------------------------"
    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e \
    "SELECT entry_date, GROUP_CONCAT(entry SEPARATOR '\n---\n') AS entries FROM journal_entries WHERE user_id=$SESSION_USER_ID GROUP BY entry_date ORDER BY entry_date DESC;"
}

delete_entry() {
    read -p "🗑️  Enter the ID of the journal entry to delete: " entry_id
    [[ -z "$entry_id" ]] && echo -e "${YELLOW}⚠️  Entry ID cannot be empty.${NC}" && return

    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e \
    "DELETE FROM journal_entries WHERE id=$entry_id AND user_id=$SESSION_USER_ID;"

    [[ $? -eq 0 ]] && echo -e "${GREEN}✅ Entry deleted (if it existed and belonged to you).${NC}" || echo -e "${RED}❌ Failed to delete entry.${NC}"
}

edit_entry() {
    read -p "✏️  Enter the ID of the journal entry to edit: " entry_id
    [[ -z "$entry_id" ]] && echo -e "${YELLOW}⚠️  Entry ID cannot be empty.${NC}" && return

    echo -e "${CYAN}📝 Enter the new journal content. Press ENTER on a blank line to finish:${NC}"
    new_entry=""
    while IFS= read -r line; do
        [[ -z "$line" ]] && break
        new_entry+="$line"$'\n'
    done

    if [[ -z "$new_entry" ]]; then
        echo -e "${YELLOW}⚠️  Empty entry not saved.${NC}"
        return
    fi

    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e \
    "UPDATE journal_entries SET entry='$(echo "$new_entry" | sed "s/'/\\\'/g")' WHERE id=$entry_id AND user_id=$SESSION_USER_ID;"

    [[ $? -eq 0 ]] && echo -e "${GREEN}✅ Entry updated.${NC}" || echo -e "${RED}❌ Failed to update entry.${NC}"
}

journal_menu() {
    while true; do
        echo ""
        echo -e "${BOLD}${CYAN}📓 Journal Menu${NC}"
        echo -e "${CYAN}---------------${NC}"
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
            6) echo -e "${YELLOW}🔙 Returning to Main Menu...${NC}"; break ;;
            *) echo -e "${RED}❌ Invalid option. Please try again.${NC}" ;;
        esac
    done
}

# Launch the menu
journal_menu

