# 🚀 Production Deployment Guide

## 📋 Обзор

Объединенный `docker-compose.yml` содержит все сервисы в одном файле для production развертывания:
- Основное приложение (backend, frontend, nginx, postgres)
- Мониторинг (Prometheus, Grafana, cAdvisor, node-exporter, postgres-exporter)
- Альтернативный мониторинг (Zabbix, Graphite)
- Автоматизация (n8n)
- Управление (Portainer)

## 🛠️ Быстрый запуск

### 1. Подготовка окружения
```bash
# Создать необходимые директории
mkdir -p monitoring/blackbox
mkdir -p monitoring/alertmanager
mkdir -p monitoring/grafana/provisioning

# Установить права доступа
chmod +x security/*.sh
```

### 2. Запуск всей инфраструктуры
```bash
# Остановить существующие сервисы
docker-compose down

# Запустить все сервисы с resource limits
docker-compose up -d

# Проверить статус
docker-compose ps
```

### 3. Проверка работоспособности
```bash
# Проверить логи критичных сервисов
docker-compose logs -f db backend prometheus grafana

# Проверить доступность экспортеров
curl http://localhost:9100/metrics  # node-exporter
curl http://localhost:8080/metrics  # cAdvisor
curl http://localhost:9187/metrics  # postgres-exporter
curl http://localhost:9115/metrics  # blackbox-exporter
```

## 📊 Доступ к сервисам

| Сервис | URL | Логин/Пароль | Описание |
|--------|-----|-------------|----------|
| Главное приложение | http://localhost | - | Основной сайт |
| Frontend New | http://localhost:3001 | - | React приложение |
| Backend API | http://localhost:8000 | - | FastAPI backend |
| Grafana | http://localhost:3000 | admin/admin | Визуализация метрик |
| Prometheus | http://localhost:9090 | - | Сбор метрик |
| Zabbix | http://localhost:8080 | Admin/zabbix | Альтернативный мониторинг |
| Portainer | http://localhost:9000 | - | Управление Docker |
| N8N | http://localhost/n8n | - | Автоматизация |
| cAdvisor | http://localhost:8080 | - | Метрики контейнеров |
| Node Exporter | http://localhost:9100/metrics | - | Метрики системы |
| AlertManager | http://localhost:9093 | - | Управление алертами |

## 🔧 Конфигурация

### Resource Limits
Все сервисы имеют настроенные лимиты ресурсов:
- **База данных**: 1GB RAM, 0.5 CPU
- **Backend**: 512MB RAM, 0.5 CPU  
- **Frontend**: 256MB RAM, 0.25 CPU
- **Prometheus**: 512MB RAM, 0.5 CPU
- **Grafana**: 256MB RAM, 0.25 CPU
- **Экспортеры**: 64-128MB RAM, 0.05-0.1 CPU

### Сети
- Единая сеть `app-network` с подсетью `172.20.0.0/16`
- Все сервисы могут общаться друг с другом

### Хранилище
- **postgres_data**: данные основной БД
- **prometheus_data**: метрики (30 дней, 10GB)
- **grafana_data**: дашборды и настройки
- **n8n_data**: workflows и данные n8n
- **portainer_data**: настройки Portainer

## 🔍 Мониторинг

### Prometheus Targets
Открыть http://localhost:9090/targets - все targets должны быть в состоянии `UP`

### Grafana Dashboards
1. Открыть http://localhost:3000
2. Импортировать дашборды:
   - Node Exporter Full (ID: 1860)
   - Docker Container Monitoring (ID: 179)
   - PostgreSQL Monitoring (ID: 455)

### Алерты
- AlertManager: http://localhost:9093
- Email алерты настроены для critical/warning уровней
- Webhook интеграция с monitor-bot

## 🛡️ Безопасность

### Resource Protection
- Ограничения CPU/RAM для предотвращения DoS
- Restart policies для автоматического восстановления
- Health checks для мониторинга состояния

### Изоляция
- Отдельные сети для разных типов сервисов
- Readonly volumes где возможно
- Минимальные привилегии для контейнеров

## 📈 Оптимизация

### Производительность
```bash
# Оптимизировать использование ресурсов
docker system prune -f

# Проверить использование ресурсов
docker stats

# Настроить логирование (если нужно)
docker-compose logs --tail=100 -f [service_name]
```

### Масштабирование
```bash
# Масштабировать frontend (если нужно)
docker-compose up -d --scale frontend_new=2

# Добавить worker для backend
docker-compose up -d --scale backend=2
```

## 🔄 Обслуживание

### Резервное копирование
```bash
# Бэкап баз данных
docker exec qazaqair-db-1 pg_dump -U user airmonitor > backup_$(date +%Y%m%d).sql

# Бэкап volumes
docker run --rm -v qazaqair_postgres_data:/data -v $(pwd):/backup alpine tar czf /backup/postgres_backup.tar.gz -C /data .
```

### Обновление
```bash
# Обновить образы
docker-compose pull

# Перезапустить с новыми образами
docker-compose up -d --force-recreate

# Очистить старые образы
docker image prune -f
```

### Диагностика проблем
```bash
# Проверить статус всех сервисов
docker-compose ps

# Посмотреть логи конкретного сервиса
docker-compose logs [service_name]

# Зайти в контейнер для отладки
docker exec -it [container_name] /bin/bash
```

## 🚨 Траблшутинг

### Частые проблемы

1. **Port already in use**
   ```bash
   # Найти процесс использующий порт
   sudo netstat -tulpn | grep :80
   # Остановить конфликтующий сервис
   ```

2. **Permission denied**
   ```bash
   # Проверить права на директории
   ls -la monitoring/
   # Установить правильные права
   sudo chown -R $USER:$USER monitoring/
   ```

3. **Memory issues**
   ```bash
   # Проверить использование памяти
   free -h
   docker stats
   # Увеличить swap если нужно
   ```

4. **Network issues**
   ```bash
   # Проверить сети Docker
   docker network ls
   docker network inspect qazaqair_app-network
   # Пересоздать сеть
   docker network rm qazaqair_app-network
   docker-compose up -d
   ```

## 📞 Поддержка

При возникновении проблем:
1. Проверить логи: `docker-compose logs`
2. Проверить статус: `docker-compose ps`
3. Проверить ресурсы: `docker stats`
4. Проверить сеть: `docker network ls`

Дополнительная информация в `INFRASTRUCTURE_SYNC_GUIDE.md`
