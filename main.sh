#!/bin/bash

while true; do
  echo "===== Breakup Buddy CLI ====="
  echo "1. Login"
  echo "2. Register"
  echo "3. Exit"
  read -p "Choose an option: " choice

  case $choice in
    1) bash login.sh ;;
    2) bash register.sh ;;
    3) echo "Goodbye!"; exit ;;
    *) echo "Invalid option. Try again." ;;
  esac
done
