#!/bin/sh

#Update & reboot semanal
#sudo crontab -e -> 30 2 * * 0 usr/bin/tareasemanal/upandreboot.sh

BOT_TOKEN=<your bot token>
CHAT_ID=<your chat ID>
MESSAGE="Raspberry: Upgrade reboot realizado con exito."

# Actualizar el sistema
if sudo apt-get update && sudo apt-get upgrade --force-yes -y && sudo apt-get dist-upgrade --force-yes -y && sudo pihole -up && sudo apt-get autoremove --force-yes -y && sudo apt-get clean; then
  echo "$(date -d 'now' '+%d/%m/%Y %H:%M:%S'): $HOSTNAME: Todas las actualizaciones y reinicio exitosos" >> /usr/bin/tareasemanal/updates_logs.log

  curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d parse_mode=Markdown -d text="$MESSAGE" > /dev/null

  sleep 5s 

  sudo reboot
else
  echo "$(date -d 'now' '+%d/%m/%Y %H:%M:%S'): $HOSTNAME: Fallo en alguna actualización o reinicio" >> /usr/bin/tareasemanal/updates_logs.log
fi