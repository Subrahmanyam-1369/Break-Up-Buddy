#!/bin/bash
source db_config.sh

user_id=$(cat .session)

while true; do
  echo "===== Home Menu ====="
  echo "1. Update Details"
  echo "2. Journal"
  echo "3. Update Mood"
  echo "4. Track Recovery Progress"
  echo "5. No Contact Tracker"
  echo "6. Get Suggestions"
  echo "7. Exit"
  read -p "Choose an option: " opt

  case $opt in
    1) bash update_details.sh ;;
    2) bash journal.sh ;;
    3) bash update_mood.sh ;;
    4) bash track_recovery.sh ;;
    5) bash no_contact.sh ;;
    6) bash suggestions.sh ;;
    7) echo "Logging out..."; rm .session; exit ;;
    *) echo "Invalid option." ;;
  esac
done
