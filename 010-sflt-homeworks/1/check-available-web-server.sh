#!/bin/bash

HOST="192.168.1.101"
PORT="80"

# проверка доступности порта
check_port() {
    nc -z -w1 $HOST $PORT
    return $?
}

# проверка наличия файла
check_index_html() {
    curl -sIf "http://$HOST/index.html" > /dev/null
    return $?
}

if check_port && check_index_html; then
    exit 1  # если порт и файл доступны, возвращаем 1
else
    exit 0  # если порт недоступен или файл не найден, возвращаем 0
fi
