# 📡 Infrastructure Synchronization Guide

## Текущие проблемы синхронизации

### 1. 🔴 Prometheus не видит метрики Docker контейнеров
**Проблема:** cAdvisor запускается отдельно в monitoring/docker-compose-cadvisor.yml
**Решение:** Добавить cAdvisor в основной docker-compose.yml

### 2. 🔴 Разные Docker сети
**Проблема:** monitoring_network external, но не создана в основном compose
**Решение:** Создать сеть перед запуском или определить в основном compose

### 3. 🔴 Отсутствуют системные метрики
**Проблема:** node-exporter запускается только в monitoring директории
**Решение:** Интегрировать в основную инфраструктуру

## 🛠️ Пошаговое исправление

### Шаг 1: Создание сетей
```bash
# Создать недостающие сети
docker network create monitoring_network
docker network create automation_network
```

### Шаг 2: Обновить основной docker-compose.yml
Заменить текущий docker-compose.yml на docker-compose-with-limits.yml:
```bash
cp docker-compose-with-limits.yml docker-compose.yml
```

### Шаг 3: Добавить экспортеры в основной compose
Добавить в конец docker-compose.yml:
```yaml
  # System Metrics
  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
    ports:
      - "9100:9100"
    networks:
      - app-network
    restart: unless-stopped

  # Container Metrics
  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: cadvisor
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    ports:
      - "8080:8080"
    networks:
      - app-network
    privileged: true
    restart: unless-stopped

  # PostgreSQL Metrics
  postgres-exporter:
    image: prometheuscommunity/postgres-exporter:latest
    environment:
      DATA_SOURCE_NAME: "postgresql://user:password@db:5432/airmonitor?sslmode=disable"
    ports:
      - "9187:9187"
    networks:
      - app-network
    depends_on:
      - db
    restart: unless-stopped
```

### Шаг 4: Обновить Prometheus конфигурацию
```bash
cp monitoring/prometheus/prometheus-enhanced.yml prometheus.yml
```

### Шаг 5: Перезапустить всю инфраструктуру
```bash
docker-compose down
docker-compose up -d
```

## 🔍 Проверка синхронизации

### 1. Проверить доступность экспортеров:
```bash
curl http://localhost:9100/metrics  # node-exporter
curl http://localhost:8080/metrics  # cAdvisor
curl http://localhost:9187/metrics  # postgres-exporter
```

### 2. Проверить Prometheus targets:
- Открыть http://localhost:9090/targets
- Все targets должны быть в состоянии UP

### 3. Проверить Grafana дашборды:
- Открыть http://localhost:3000
- Импортировать дашборды для node-exporter, cAdvisor, postgres

## 📊 Мониторинг синхронизации

### Ключевые метрики для отслеживания:
1. **Container uptime** - время работы контейнеров
2. **Network connectivity** - доступность между сервисами
3. **Resource usage** - CPU, RAM, disk usage
4. **Database connections** - количество подключений к БД
5. **API response times** - время ответа API

### Alert правила для синхронизации:
```yaml
# В monitoring/prometheus/alert_rules.yml добавить:
- alert: ContainerDown
  expr: up == 0
  for: 1m
  labels:
    severity: critical
  annotations:
    summary: "Container {{ $labels.instance }} is down"

- alert: DatabaseConnectionFailure
  expr: pg_up == 0
  for: 1m
  labels:
    severity: critical
  annotations:
    summary: "Database connection failed"
```

## 🚨 Частые проблемы и решения

### Проблема: "Connection refused" между контейнерами
**Решение:** Проверить, что контейнеры в одной сети и используют правильные имена

### Проблема: "Target down" в Prometheus
**Решение:** Проверить ports и network настройки в docker-compose.yml

### Проблема: "Permission denied" для volumes
**Решение:** Проверить права доступа к директориям и файлам

## 📈 Оптимизация производительности

### 1. Настройка resource limits:
- Установить适当的 CPU/memory лимиты
- Мониторить использование ресурсов

### 2. Настройка retention:
```yaml
# В prometheus.yml добавить:
storage:
  tsdb:
    retention.time: 30d
    retention.size: 10GB
```

### 3. Настройка логирования:
```yaml
# В docker-compose.yml добавить ко всем сервисам:
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

## 🔄 Автоматическое восстановление

### Health checks для критических сервисов:
```yaml
# Добавить в docker-compose.yml:
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

### Restart policies:
```yaml
restart: unless-stopped  # Для критических сервисов
restart: on-failure     # Для второстепенных сервисов
```
