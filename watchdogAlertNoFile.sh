#!/bin/bash

# Mandará un mail todas las noches a las 12 si no hay archivos nuevos en un path smb

# Credentials del path, en caso de no tener, comentar
user=
password=

# Paths a monitorear:
new=/mnt/ejemplo
stored=/mnt/ejemplo/Stored
aux1=/mnt/ejemplo/aux

# Network paths:
path= 192.168.x.x
aux1= 192.168.x.x

# Network Shares:
new_share=c$
stored_share=e$
aux1_share=ejemplo

# Alerts:
email=example@gmail.com
subject='Ejemplo - Alerta'
body="No hay archivos nuevos en las ultimas 24 horas."

# Creation time in days:
ctime=1

# Create dirs if not exist:
mkdir -p $new $stored $aux

# Functions:
mount_new () {
        mount -o username=$user,password=$password "//$path/$new_share" $new
        }

mount_stored () {
        mount -o username=$user,password=$password "//$path/$stored_share" $stored
        }

mount_aux1 () {
        mount -o username=$user,password=$password "//$aux1/$aux1_share" $aux1
        }

do_alerting () {
        echo "$body" | mail -s "$subject" "$email"
        }

# Runtime
# Mount points, check and mount:
mountpoint -q $new || mount_new
mountpoint -q $stored || mount_stored
#mountpoint -q $aux1 || mount_aux1 # por si se requiere verficar long term storage.

find_new=`find $new/path/new -maxdepth 1 -ctime -$ctime -type f -name "*"`
find_stored=`find $stored -maxdepth 1 -ctime -$ctime -type f -name "*"`

if [ -z "$find_new" ]; then do_alerting ; fi
if [ -z "$find_stored" ]; then do_alerting ; fi

# Debug:
#if [ -z "$find_new" ]; then echo "new null"; else echo "new not null"; fi
#if [ -z "$find_stored" ]; then echo "stored null"; else echo "stored not null"; fi