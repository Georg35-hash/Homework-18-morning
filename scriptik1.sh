#!/bin/bash

target_address="google.com"
max_ping_time_ms=10
max_failures=3
failures=0

while true; do
    # Выполняем пинг и извлекаем время ответа
    ping_result=$(ping -c 1 "$target_address" | grep 'icmp_seq')
    ping_time=$(echo "$ping_result" | awk -F'=' '{print $4}' | awk '{print $1}' | awk -F'.' '{print $1}')

    # Проверка на превышение времени пинга
    if [ -n "$ping_time" ] && [ "$ping_time" -gt "$max_ping_time_ms" ]; then
        echo "Пинг $target_address превышает $max_ping_time_ms мс: $ping_time мс."
    fi

    # Проверка на неудачный пинг
    if [ -z "$ping_time" ]; then
        echo "Пинг $target_address не удался."
        ((failures++))
    else
        echo "Пинг $target_address успешен: $ping_time мс."
        failures=0 # Сбросить счетчик неудачных попыток
    fi

    # Если неудач 3 подряд, выводим сообщение
    if [ "$failures" -ge "$max_failures" ]; then
        echo "Превышено максимальное количество неудачных попыток."
        failures=0 # Сбросить счетчик после сообщения
    fi

    sleep 1
done
