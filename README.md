# 🌬️ QazaqAir

Веб‑приложение для **мониторинга качества воздуха** по регионам Казахстана.  
Современный стек технологий, полноценная инфраструктура мониторинга, авторизация пользователей и поддержка казахского/русского языков.

---

## 📚 Содержание

- [Описание](#-описание)
- [Архитектура](#-архитектура)
- [Технологический стек](#-технологический-стек)
- [Структура проекта](#-структура-проекта)
- [Установка и запуск](#-установка-и-запуск)
- [API endpoints](#-api-endpoints)
- [Мониторинг и логирование](#-мониторинг-и-логирование)
- [Безопасность](#-безопасность)
- [Конфигурация и учетные данные](#-конфигурация-и-учетные-данные)
- [Инфраструктура как код](#-инфраструктура-как-код)
- [CI/CD](#-cicd)
- [Авторы](#-авторы)

## 📋 Описание

QazaqAir — это комплексное решение для мониторинга качества воздуха в Казахстане.

### Ключевые функции:

- **🌍 Многоязычность**: Полная поддержка казахского и русского языков
- **📊 AQI мониторинг**: Индекс качества воздуха по US EPA с цветовой индикацией
- **🗺️ Интерактивная карта**: Карта Казахстана с маркерами регионов
- **🔐 Авторизация**: JWT-based регистрация и вход пользователей
- **👤 Личный кабинет**: Выбор города, управление профилем
- **🌡️ Погода**: Температура, влажность, скорость ветра
- **📈 Сводка**: Топ-10 чистых и загрязненных регионов
- **🌙 Темная/светлая тема**: Автоматическое переключение
- **💾 История данных**: Почасовое сохранение в PostgreSQL
- **🔔 Уведомления**: Telegram-бот для алертов

---

## 🏗️ Архитектура

### Общая схема

```
┌─────────────────────────────────────────────────────────────┐
│                       Клиент                                │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  React + TypeScript + Vite (frontend_new)          │   │
│  │  • React Router v7                                  │   │
│  │  • Tailwind CSS v4                                  │   │
│  │  • React Leaflet (карта)                            │   │
│  └─────────────────────────────────────────────────────┘   │
└───────────────────────────┬─────────────────────────────────┘
                            │ HTTPS/HTTP
┌───────────────────────────▼─────────────────────────────────┐
│                    Nginx (Reverse Proxy)                     │
│              Порт 80/443 → проксирование                    │
└───────────────────────────┬─────────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────────┐
│                   Backend (FastAPI)                          │
│  • REST API /api/*                                          │
│  • JWT авторизация                                          │
│  • Кеширование WAQI (60 сек)                                │
│  • Rate limiting, Firewall                                  │
│  • SSH-сервер (порт 2222)                                   │
└───────┬─────────────┬───────────────────────────────────────┘
        │             │
        ▼             ▼
┌──────────────┐  ┌─────────────────────────────────────────┐
│   Supabase   │  │          WAQI API (waqi.info)          │
│  PostgreSQL  │  │   /feed/{city}?token=...               │
└──────────────┘  └─────────────────────────────────────────┘
```

### Инфраструктура мониторинга

```
┌─────────────────────────────────────────────────────────────┐
│              Полный стек мониторинга                         │
├──────────────┬──────────────┬──────────────┬─────────────────┤
│  Prometheus  │   Grafana    │    Zabbix    │     Nagios      │
│  (9090)      │   (3000)     │   (8086)     │    (8083)       │
├──────────────┼──────────────┼──────────────┼─────────────────┤
│  Node Exp    │  Dashboards  │  Server      │  NRPE Agent     │
│  cAdvisor    │  Alerts      │  Web UI      │  Plugins        │
│  Postgres Exp│  Telegram    │  Agent       │  Graphing       │
└──────────────┴──────────────┴──────────────┴─────────────────┘
```

---

## 📁 Структура проекта

```
QazaqAir/
├── backend/                    # FastAPI бэкенд
│   ├── app/
│   │   ├── api/
│   │   │   └── endpoints/      # API endpoints (air_quality, auth)
│   │   ├── core/
│   │   │   └── config.py       # Конфигурация приложения
│   │   ├── db/
│   │   │   └── session.py      # SQLAlchemy + Supabase
│   │   ├── services/
│   │   │   ├── waqi_service.py # WAQI API интеграция
│   │   │   ├── scheduler.py    # Фоновые задачи
│   │   │   └── ssh_service.py  # SSH сервер
│   │   └── main.py             # Точка входа FastAPI
│   └── .env                    # Переменные окружения
│
├── frontend_new/               # React + TypeScript фронтенд
│   ├── src/
│   │   ├── api/                # API клиенты
│   │   ├── components/         # UI компоненты
│   │   ├── context/            # React Context (Auth)
│   │   ├── pages/              # Страницы (Home, Login, Profile)
│   │   └── types/              # TypeScript типы
│   ├── package.json
│   └── Dockerfile
│
├── monitoring/                 # Инфраструктура мониторинга
│   ├── alertmanager/           # Уведомления
│   ├── grafana/                # Визуализация
│   ├── prometheus/             # Сбор метрик
│   ├── bot/                    # Telegram бот
│   └── docker-compose.yml
│
├── infrastructure/             # Документация инфраструктуры
├── security/                   # Настройки безопасности
├── terraform/                  # IaC для облака
├── ansible/                    # Конфигурация серверов
├── html/                       # Сборка фронтенда для nginx
├── backups/                    # Резервные копии БД
└── docker-compose.yml          # Полный стек сервисов
```

---

## 🛠️ Технологический стек

### Backend

| Компонент       | Технология                                 |
|-----------------|--------------------------------------------|
| Framework       | FastAPI                                    |
| Server          | Uvicorn (ASGI)                             |
| Database        | PostgreSQL (Supabase)                      |
| ORM             | SQLAlchemy                                 |
| Auth            | JWT (python-jose)                          |
| HTTP Client     | HTTPX                                      |
| Scheduler       | APScheduler                                |
| SSH Server      | asyncssh                                   |

### Frontend

| Компонент       | Технология                                 |
|-----------------|--------------------------------------------|
| Framework       | React 19 + TypeScript                      |
| Build Tool      | Vite                                       |
| Styling         | Tailwind CSS v4                            |
| Router          | React Router v7                            |
| Forms           | React Hook Form + Zod                      |
| Maps            | React Leaflet                              |
| Icons           | Lucide React                               |
| HTTP Client     | Axios                                      |

### Инфраструктура и DevOps

| Компонент       | Технология                                 |
|-----------------|--------------------------------------------|
| Container       | Docker + Docker Compose                    |
| Reverse Proxy   | Nginx                                      |
| CI/CD           | Jenkins                                    |
| IaC             | Terraform + Ansible                        |
| Monitoring      | Prometheus + Grafana + Zabbix + Nagios   |
| Automation      | n8n                                        |
| Container Mgmt  | Portainer                                  |
| Alerts          | Alertmanager + Telegram Bot                |

---

## 🚀 Установка и запуск

### Быстрый старт (Docker Compose)

Самый простой способ — запустить полный стек через Docker Compose:

```bash
# 1. Клонировать репозиторий
git clone <repository-url>
cd QazaqAir

# 2. Настроить переменные окружения
cp backend/.env.example backend/.env
# Отредактировать backend/.env, добавить WAQI_TOKEN

# 3. Запустить все сервисы
docker-compose up -d --build

# 4. Проверить статус
docker-compose ps
```

Сервисы будут доступны:
- **Приложение**: http://localhost
- **Frontend**: http://localhost:3001
- **Backend API**: http://localhost:8000
- **Grafana**: http://localhost:3000 (admin/admin)
- **Prometheus**: http://localhost:9090
- **Jenkins**: http://localhost:8085
- **Portainer**: http://localhost:9000

### Production развертывание (Linux сервер) ⚠️

Для production с полной безопасностью (firewall, fail2ban, SSL):

```bash
# Только для Linux! Устанавливает UFW, Fail2Ban, Docker, Nginx
sudo ./security/install-all.sh

# Запуск контейнеров
docker-compose up -d
```

**Что делает `install-all.sh`:**
- Устанавливает и настраивает UFW (firewall)
- Устанавливает и настраивает Fail2Ban (защита от брутфорса)
- Устанавливает Certbot (SSL сертификаты)
- Настраивает cron для бэкапов
- Создает Docker сети

### Windows 🪟

На Windows `install-all.sh` не работает (bash/apt-get/systemd). Варианты:

**Вариант 1: Только Docker (рекомендуется)**
```powershell
# Docker Desktop должен быть установлен
docker-compose up -d --build
```
> Без UFW/Fail2Ban, но работает всё остальное. Windows Firewall блокирует неиспользуемые порты.

**Вариант 2: WSL2 (полный функционал)**
```powershell
wsl --install -d Ubuntu
# Внутри WSL:
sudo ./security/install-all.sh
docker-compose up -d
```

**Вариант 3: Linux сервер через Terraform**
Смотри `DEPLOY.md` — создает EC2 instance и автоматически настраивает всё через Ansible.

### Ручная установка (для разработки)

#### Backend

```bash
# Python зависимости
pip install -r requirements.txt

# Настройка окружения
# backend/.env:
# WAQI_TOKEN=ваш_токен_waqi
# POSTGRES_URL=postgresql+psycopg2://user:pass@host:5432/db

# Запуск
python -m backend.app.main
# или
uvicorn backend.app.main:app --reload --port 8000
```

#### Frontend

```bash
cd frontend_new
npm install
npm run dev
```

Фронтенд запустится на http://localhost:5173

---

## 🔗 API Endpoints

### Air Quality

| Метод  | URL                               | Описание                      |
|--------|-----------------------------------|-------------------------------|
| `GET`  | `/api/air-quality`                | Текущие данные (общие)        |
| `GET`  | `/api/air-quality?region={key}`   | Данные по конкретному региону |
| `GET`  | `/api/regions`                    | Список всех регионов          |
| `GET`  | `/api/summary`                    | Топ-10 чистых/загрязненных    |
| `POST` | `/api/save-hourly`                | Ручное сохранение данных      |

### Authentication

| Метод  | URL                               | Описание                      |
|--------|-----------------------------------|-------------------------------|
| `POST` | `/api/auth/register`              | Регистрация пользователя      |
| `POST` | `/api/auth/login`                 | Вход (OAuth2 формат)          |
| `GET`  | `/api/auth/me`                    | Получить профиль              |
| `PATCH`| `/api/auth/me`                    | Обновить профиль              |

### System

| Метод  | URL                               | Описание                      |
|--------|-----------------------------------|-------------------------------|
| `GET`  | `/`                               | Главная страница (React)      |
| `GET`  | `/health`                         | Health check                  |
| `GET`  | `/docs`                           | Swagger UI документация       |
| `GET`  | `/openapi.json`                   | OpenAPI схема                 |

---

## 🎨 Интерфейс

### Страницы приложения

- **Главная**: Карта Казахстана, AQI выбранного региона, погода, топ-10
- **Вход**: Форма авторизации с JWT
- **Регистрация**: Создание нового аккаунта
- **Профиль**: Управление профилем, выбор города

### Компоненты UI

- Боковая панель со списком регионов
- Интерактивная карта с маркерами
- Карточки AQI с цветовой индикацией
- Переключатель языка (RU/KK)
- Переключатель темы (светлая/темная)

### Шкала AQI (US EPA)

| Значение  | Цвет             | Статус                       |
| --------- | ---------------- | ---------------------------- |
| 0 – 50    | 🟢 Зелёный       | Хорошо                       |
| 51 – 100  | 🟡 Жёлтый        | Умеренно                     |
| 101 – 150 | 🟠 Оранжевый     | Нездорово для чувствительных |
| 151 – 200 | 🔴 Красный       | Нездорово                    |

---

## 📊 Мониторинг и логирование

### Prometheus + Grafana Stack

| Сервис           | Порт  | Описание                          |
|------------------|-------|-----------------------------------|
| Prometheus       | 9090  | Сбор метрик                       |
| Grafana          | 3000  | Визуализация дашбордов            |
| Node Exporter    | 9100  | Метрики системы                   |
| cAdvisor         | 8080  | Метрики контейнеров               |
| Postgres Exporter| 9187  | Метрики БД                        |
| Blackbox Exporter| 9115  | Проверки доступности              |
| Alertmanager     | 9093  | Управление алертами               |

### Zabbix Stack

| Сервис       | Порт  | Описание                    |
|--------------|-------|-----------------------------|
| Zabbix Web   | 8086  | Веб-интерфейс               |
| Zabbix Server| 10051 | Сервер мониторинга          |
| Zabbix Agent | 10050 | Агент сбора метрик          |

### Другие инструменты

| Сервис       | Порт  | Описание                    |
|--------------|-------|-----------------------------|
| Nagios       | 8083  | Мониторинг инфраструктуры   |
| Portainer    | 9000  | Управление Docker           |
| n8n          | 5678  | Автоматизация workflows     |
| Jenkins      | 8085  | CI/CD пайплайны             |

---

## 🔐 Безопасность

### Встроенные механизмы

- **Firewall Middleware**: Блокировка по IP (`ALLOWED_IPS`, `BLOCKED_IPS`)
- **Rate Limiting**: Ограничение запросов на `/api/*`
- **JWT Auth**: Безопасная авторизация с токенами
- **CORS**: Настроенные разрешенные origins
- **HTTPS**: Поддержка SSL-сертификатов

### SSH доступ

- **Порт**: 2222
- **Команды**: `status`, `backup`, `exit`
- Настраивается через переменные окружения

### Переменные окружения (.env)

```env
# API
WAQI_TOKEN=your_token

# Database
POSTGRES_URL=postgresql+psycopg2://user:pass@host/db

# Security
SSL_CERTFILE=backend/certs/cert.pem
SSL_KEYFILE=backend/certs/key.pem
ALLOWED_IPS=127.0.0.1,192.168.1.0/24
BLOCKED_IPS=
TRUST_X_FORWARDED=false
RATE_LIMIT_WINDOW_SECONDS=60
RATE_LIMIT_MAX_REQUESTS=30

# SSH
SSH_HOST=0.0.0.0
SSH_PORT=2222
SSH_USERNAME=admin
SSH_PASSWORD=admin123

# Backup
BACKUP_DIR=backups
```

---

## 🏗️ Инфраструктура как код

### Terraform

Инфраструктура для облачного развертывания:
- Вычислительные ресурсы
- Сетевые настройки
- Базы данных

```bash
cd terraform
terraform init
terraform apply
```

### Ansible

Конфигурация серверов:
- Установка зависимостей
- Настройка безопасности
- Развертывание приложения

```bash
cd ansible
ansible-playbook -i inventory.ini monitoring.yml
```

---

## CI/CD

### Jenkins Pipeline

Автоматизированная сборка и деплой:
- Сборка Docker образов
- Запуск тестов
- Деплой на сервер

### Доступ к Jenkins

- **URL**: http://localhost:8085
- Начальный пароль доступен в логах контейнера

---

## 💾 Резервное копирование

### Автоматическое

- **Расписание**: Ежедневно в 03:00
- **Инструмент**: APScheduler + pg_dump
- **Расположение**: `backups/backup_YYYYMMDD_HHMMSS.sql`

### Ручное

Через SSH или API:
```bash
# SSH
ssh -p 2222 admin@localhost
> backup

# Или API
POST /api/save-hourly
```

---

## ⚙️ Конфигурация и учетные данные

### Основные конфигурационные файлы

| Файл | Описание | Содержимое |
|------|----------|------------|
| `backend/.env` | Переменные бэкенда | Токены, БД, секреты |
| `docker-compose.yml` | Сервисы Docker | Все контейнеры, порты, лимиты |
| `nginx.conf` | Настройки Nginx | Проксирование, SSL |
| `terraform/terraform.tfvars` | Terraform переменные | Пароли БД, домены |
| `ansible/inventory.ini` | Инвентарь серверов | IP адреса хостов |
| `monitoring/.env` | Мониторинг | Telegram бот токен |

### Backend (.env)

```env
# === API ===
WAQI_TOKEN=ваш_токен_waqi

# === Database (Supabase) ===
POSTGRES_URL=postgresql+psycopg2://postgres.gtbowxugcefxtckejavv:QazaqAir963%40@aws-1-ap-northeast-1.pooler.supabase.com:5432/postgres

# === Security ===
SSL_CERTFILE=backend/certs/cert.pem
SSL_KEYFILE=backend/certs/key.pem
ALLOWED_IPS=
BLOCKED_IPS=
TRUST_X_FORWARDED=false
RATE_LIMIT_WINDOW_SECONDS=60
RATE_LIMIT_MAX_REQUESTS=30

# === SSH Server ===
SSH_HOST=0.0.0.0
SSH_PORT=2222
SSH_USERNAME=admin
SSH_PASSWORD=admin123

# === Project ===
PROJECT_NAME=QazaqAir
BACKUP_DIR=backups
```

### Docker Compose (docker-compose.yml)

**Основные сервисы:**

| Сервис | Контейнер | Порты | Логин/Пароль |
|--------|-----------|-------|--------------|
| PostgreSQL | qazaqair-db-1 | 5432 | user/password |
| Backend | qazaqair-backend-1 | 8000, 2222 | - |
| Frontend | qazaqair-frontend-1 | 3001 | - |
| Nginx | qazaqair-app-1 | 80, 443 | - |
| Grafana | qazaqair-grafana-1 | 3000 | admin/admin |
| Prometheus | qazaqair-prometheus-1 | 9090 | - |
| Zabbix Web | zabbix-web | 8086 | Admin/zabbix |
| Zabbix DB | zabbix-db | - | zabbix/zabbix_password |
| Nagios | qazaqair-nagios-1 | 8083 | nagiosadmin/nagiosadmin |
| Jenkins | qazaqair-jenkins-1 | 8085 | admin/(пароль в логах) |
| Portainer | portainer | 9000 | - |
| n8n | qazaqair-n8n-1 | 5678 | - |
| Graphite | qazaqair-graphite-1 | 2003, 8082, 8125 | - |

### Terraform (terraform.tfvars)

```hcl
# === Database ===
db_password = "your-secure-password"
zabbix_db_password = "your-zabbix-password"

# === Monitoring ===
grafana_admin_password = "your-grafana-password"
nagios_admin_password = "your-nagios-password"

# === Infrastructure ===
domain_name = "your-domain.com"
enable_ssl = true
```

### Ansible (inventory.ini)

```ini
[monitoring]
monitoring-server ansible_host=127.0.0.1 ansible_user=ubuntu

[backend]
backend-server ansible_host=127.0.0.1 ansible_user=ubuntu
```

### Monitoring (.env)

```env
TELEGRAM_BOT_TOKEN=your_bot_token
TELEGRAM_CHAT_ID=your_chat_id
```

### Jenkins

- **URL**: http://localhost:8085
- **Начальный пароль**: `docker exec qazaqair-jenkins-1 cat /var/jenkins_home/secrets/initialAdminPassword`

### Безопасные подключения

**SSH в бэкенд:**
```bash
ssh -p 2222 admin@localhost
# Пароль: admin123 (или из SSH_PASSWORD в .env)
```

**PostgreSQL:**
```bash
# Локально
docker exec -it qazaqair-db-1 psql -U user -d airmonitor

# Или через Supabase
psql "postgresql://postgres.gtbowxugcefxtckejavv:QazaqAir963%40@aws-1-ap-northeast-1.pooler.supabase.com:5432/postgres"
```

**Grafana:**
- URL: http://localhost:3000
- Login: admin
- Password: admin (или GF_SECURITY_ADMIN_PASSWORD)

**Zabbix:**
- URL: http://localhost:8086
- Login: Admin
- Password: zabbix

**Nagios:**
- URL: http://localhost:8083
- Login: nagiosadmin
- Password: nagiosadmin

---

## 📞 Поддержка и документация

### Дополнительная документация

- [DEPLOY.md](./DEPLOY.md) — Инструкции по развертыванию
- [PRODUCTION_DEPLOYMENT.md](./PRODUCTION_DEPLOYMENT.md) — Продакшн деплой
- [FRONTEND_NEW_README.md](./FRONTEND_NEW_README.md) — Документация фронтенда
- [monitoring/README.md](./monitoring/README.md) — Документация мониторинга

### Полезные команды

```bash
# Логи сервиса
docker-compose logs -f backend

# Перезапуск сервиса
docker-compose restart frontend_new

# Масштабирование
docker-compose up -d --scale backend=2

# Очистка
docker system prune -f
```

---

## 👨‍💻 Авторы

Проект выполнен в рамках дисциплины **«Проектирование информационных систем»**

- **Преподаватель**: Жукабаева Т.
- **Студент**: [Имя студента]
