#!/bin/bash


BOT_TOKEN="6917184800"

API_URL="https://api.telegram.org/bot$BOT_TOKEN"

LAST_UPDATE_ID=0

while true; do
    
    UPDATES=$(curl -s "$API_URL/getUpdates")

    NEW_UPDATE_ID=$(echo "$UPDATES" | jq -r ".result[-1].update_id")
 
    if [[ $NEW_UPDATE_ID != $LAST_UPDATE_ID ]]; then
        
        LAST_UPDATE_ID=$NEW_UPDATE_ID

        MESSAGE=$(echo "$UPDATES" | jq -r ".result[-1].message.text")

        if [[ $MESSAGE == "/start" ]]; then
            CHAT_ID=$(echo "$UPDATES" | jq -r ".result[-1].message.chat.id")
            USER_LANG=$(echo "$UPDATES" | jq -r ".result[-1].message.from.language_code")
            FIRST_NAME=$(echo "$UPDATES" | jq -r ".result[-1].message.from.first_name")
            KEYBOARD=$(cat <<EOF
            {
                "inline_keyboard": [
                    [
                        {
                            "text": "Owner",
                            "url": "https://t.me/proluciofficial"
                        }
                    ]
                ]
            }
EOF
            )

            curl -s -X POST "$API_URL/sendMessage" -d "chat_id=$CHAT_ID" -d "text=*Hello $FIRST_NAME, With this bot you can talk unlimitedly via gpt. Just send a message and see the magic*" -d "parse_mode=markdown" -d "reply_markup=$KEYBOARD"

        else
            
            CHAT_ID=$(echo "$UPDATES" | jq -r ".result[-1].message.chat.id")
            UR=$(python3 -c "import requests; print(requests.get('https://sensui-useless-apis.codersensui.repl.co/api/tools/blackai?question=$MESSAGE').text)")


            NEWURL=$(echo $UR | jq -r '.message')
            curl -s -X POST "$API_URL/sendMessage" -d "chat_id=$CHAT_ID" -d "parse_mode=Markdown" -d "disable_web_page_preview=true" -d "text=* $NEWURL*"
        fi
    fi


    
done
