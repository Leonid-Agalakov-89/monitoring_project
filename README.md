# Monitoring Project


## Описание

Данный проект предназначен для мониторинга процесса **test** в Linux. Скрипт выполняется каждую минуту и:
- Проверяет, запущен ли процесс **test**.
- При наличии процесса выполняет HTTPS-запрос на [https://test.com/monitoring/test/api](https://test.com/monitoring/test/api).
- Если обнаружен перезапуск процесса (изменился PID), записывает событие в лог **/var/log/monitoring.log**.
- Если сервер мониторинга недоступен, также записывает сообщение об ошибке в лог.


## Структура проекта
```
monitoring_project/

├── bin/
    │
    └── monitor_test.sh # Скрипт мониторинга

├── systemd/
    │
    ├── test-monitor.service # Unit-файл systemd для сервиса
    └── test-monitor.timer # Таймер systemd для периодического запуска
    
└── README.md # Инструкции по установке
```

## Установка

### 1. Установка скрипта мониторинга

1. Скопируйте скрипт `monitor_test.sh` в директорию `/usr/local/bin`:
   ```
   sudo cp bin/monitor_test.sh /usr/local/bin/monitor_test.sh
   ```

2. Сделайте скрипт исполняемым:
   ```
   sudo chmod +x /usr/local/bin/monitor_test.sh
   ```

### 2. Установка unit-файлов systemd

1. Скопируйте файлы test-monitor.service и test-monitor.timer в директорию /etc/systemd/system:
   ```
   sudo cp systemd/test-monitor.service /etc/systemd/system/test-monitor.service
   sudo cp systemd/test-monitor.timer /etc/systemd/system/test-monitor.timer
   ```

2. Перезагрузите конфигурацию systemd:
   ```
   sudo systemctl daemon-reload
   ```

3. Включите и запустите таймер:
   ```
   sudo systemctl enable test-monitor.timer
   sudo systemctl start test-monitor.timer
   ```

4. Проверьте статус таймера:
   ```
   sudo systemctl status test-monitor.timer
   ```


## Логирование

Все сообщения логирования записываются в файл /var/log/monitoring.log. Убедитесь, что у пользователя, от имени которого запускается скрипт, есть права на запись в этот файл.
При обнаружении перезапуска процесса (изменение PID) или недоступности сервера мониторинга, событие будет записано в лог с указанием даты и времени.


## Примечания
Скрипт использует команду pgrep для поиска процесса по точному совпадению имени. При необходимости вы можете изменить алгоритм поиска или добавить дополнительную обработку.
Убедитесь, что сервер https://test.com/monitoring/test/api доступен из вашей сети.
Для корректной работы скрипта требуется установленный пакет curl. Если возникают проблемы с запросом (например, ошибки SSL), проверьте настройки и установку curl.


## Об авторе:
Леонид Агалаков - python backend developer.
`https://github.com/Leonid-Agalakov-89`
