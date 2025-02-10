#!/bin/bash
# Файл: monitor_test.sh
# Скрипт для мониторинга процесса "test" в Linux

# Путь к лог-файлу. Убедитесь, что у пользователя, от имени которого запускается скрипт, есть права на запись.
LOG_FILE="/var/log/monitoring.log"
# Файл для хранения последнего PID процесса "test"
PID_FILE="/tmp/test_monitor.pid"

# Имя процесса для мониторинга (точное совпадение)
PROCESS_NAME="test"
# URL для мониторинга (HTTPS-запрос)
MONITOR_URL="https://test.com/monitoring/test/api"

# Функция для записи в лог с префиксом даты и времени
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Проверяем, запущен ли процесс с именем "test"
pid=$(pgrep -x "$PROCESS_NAME")

# Если процесс не найден, ничего не делаем
if [ -z "$pid" ]; then
    exit 0
fi

# Если PID уже сохранён, проверяем, изменился ли он (то есть, процесс перезапустился)
if [ -f "$PID_FILE" ]; then
    old_pid=$(cat "$PID_FILE")
    if [ "$old_pid" != "$pid" ]; then
        log_message "Process '$PROCESS_NAME' restarted: old PID: $old_pid, new PID: $pid"
    fi
fi

# Сохраняем текущий PID для следующих проверок
echo "$pid" > "$PID_FILE"

# Выполняем HTTPS-запрос к серверу мониторинга
# --silent – отключает прогресс-бар, --show-error – показывает ошибки, --fail – завершает с ошибкой, если HTTP-код не 2xx.
response=$(curl --silent --show-error --fail "$MONITOR_URL" 2>&1)
curl_exit_code=$?

if [ $curl_exit_code -ne 0 ]; then
    log_message "Monitoring server not available. Error: $response"
fi
