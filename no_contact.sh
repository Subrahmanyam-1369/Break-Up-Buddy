#!/bin/bash
source db_config.sh

SESSION_FILE=".session"
if [[ ! -f "$SESSION_FILE" ]]; then
    echo "⚠️  You must be logged in to track no-contact progress."
    exit 1
fi

user_id=$(cat "$SESSION_FILE")

echo "📅 Enter last contact date with your ex (YYYY-MM-DD):"
read last_contact

# Validate date format (basic check)
if ! [[ "$last_contact" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "❌ Invalid date format. Please use YYYY-MM-DD."
    exit 1
fi

# Update last contact date
mysql -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" -e \
"UPDATE users SET last_contact_date='$last_contact' WHERE user_id=$user_id;"

# Get days since last contact
days=$(mysql -N -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -D"$DB_NAME" -e \
"SELECT DATEDIFF(CURDATE(), last_contact_date) FROM users WHERE user_id=$user_id;")

echo ""
echo "📆 You’ve been in No Contact for **$days day(s)**."

# Motivational statements based on ranges
if (( days < 3 )); then
    echo "💔 It’s just the beginning... You might be missing them, but stay strong. Every hour counts."
elif (( days < 10 )); then
    echo "😟 Still fresh... Temptations might strike, but remember why you started this journey. Don’t give in!"
elif (( days < 20 )); then
    echo "💪 Two weeks of strength! You’re breaking patterns. Keep going!"
elif (( days < 30 )); then
    echo "🔥 Almost a month! You’re showing real courage. Don’t look back."
elif (( days < 60 )); then
    echo "🌱 Over a month of healing. You’re growing stronger every day—be proud!"
elif (( days < 90 )); then
    echo "🌼 Nearly 3 months! This is no longer a phase—it’s transformation. You're blooming."
else
    echo "🦋 You’ve come so far. Look at you—surviving, healing, and evolving beautifully. Keep shining."
fi
