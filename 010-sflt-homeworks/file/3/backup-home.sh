#!/bin/bash

SOURCE_DIR=$HOME
BACKUP_DIR="/tmp/backup"

# Выполняем резервное копирование
rsync -ac --delete $SOURCE_DIR $BACKUP_DIR \
&& logger "rsync успешно завершен: домашняя директория скопирована в /tmp/backup" \
|| logger "rsync завершен с ошибкой: домашняя директория не скопирована в /tmp/backup"
