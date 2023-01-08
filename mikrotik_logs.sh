#!/bin/bash

log_file="/var/log/mikrotik.log"

BOT_TOKEN=<your bot token>
CHAT_ID=<your chat ID>

# Archivo donde se almacenarán los errores anteriores
errors_file="./errors.txt"
logins_file="./logins.txt"

# Usamos el comando "grep" para buscar la palabra "error" en el archivo
errors=$(grep -i "critical" "$log_file")

# Recorremos cada línea de la salida de grep
while read -r line; do
    message=$(echo "$line" | sed 's/^[^ ]* *[^ ]* *[^ ]* *[^ ]* *[^ ]* *//')
    message="Mikrotik: $message"
    # Comprobamos si la línea ya está en el archivo de errores
    if ! grep -q "$line" "$errors_file"; then
        # Si la línea no está en el archivo, la añadimos y enviamos un mensaje de Telegram
        echo "$line" >>"$errors_file"
        # Enviar el mensaje
        curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d parse_mode=Markdown -d text="$message" > /dev/null
    fi
done <<<"$errors"

# Usamos el comando "grep" para buscar la palabra "account" en el archivo
logins=$(grep -i "account" "$log_file")

# Recorremos cada línea de la salida de grep
while read -r line; do
    message=$(echo "$line" | sed 's/^[^ ]* *[^ ]* *[^ ]* *[^ ]* *[^ ]* *//')
    message="Mikrotik: $message"
    # Comprobamos si la línea ya está en el archivo de logins
    if ! grep -q "$line" "$logins_file"; then
        # Si la línea no está en el archivo, la añadimos y enviamos un mensaje de Telegram
        echo "$line" >>"$logins_file"
        # Reemplaza "TOKEN" y "CHAT_ID" por el token de tu bot y el ID del chat donde quieres enviar el mensaje
        curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d parse_mode=Markdown -d text="$message" > /dev/null
    fi
done <<<"$logins"
