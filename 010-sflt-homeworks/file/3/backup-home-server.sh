#!/bin/bash

SOURCE_DIR_LOCAL=$HOME
REMOTE_SERVER="deb-192.168.1.102"
REMOTE_DIR="/tmp/remote_backup"
REMOTE_DIR_SERVER=$REMOTE_SERVER":"$REMOTE_DIR
MAX_BACKUPS=5  # максимальное кол-во резервных копий

# Создание новой резервной копии
times=$(date +"%Y-%m-%d_%H-%M-%S")
host_name=$(echo $(hostname))
backup_name="backup_"$host_name"_$times"

ssh $REMOTE_SERVER "mkdir -p $REMOTE_DIR"
rsync -a $SOURCE_DIR_LOCAL $REMOTE_DIR_SERVER"/$backup_name"

#Удаление старых резервных копий, если их больше максимума
backup_list=$(ssh $REMOTE_SERVER "ls -dt /tmp/remote_backup/backup_"$host_name"_*")
backup_count=$(echo "$backup_list" | wc -l)

if [ $backup_count -gt $MAX_BACKUPS ]; then
  old_backups=$(echo "$backup_list" | tail -n $(($backup_count - $MAX_BACKUPS)))
  for old_backup in $old_backups; do
    ssh $REMOTE_SERVER "rm -rf $old_backup"
  done
fi

echo "Резервное копирование завершено. Создана новая копия: $backup_name"
