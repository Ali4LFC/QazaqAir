# Настройка Telegram уведомлений для n8n - QazaqAir Project

## 📋 Обзор

Этот гайд поможет вам настроить автоматические уведомления в Telegram через n8n для проекта QazaqAir.

## 🚀 Быстрая настройка

### 1. Создание Telegram бота

1. Найдите [@BotFather](https://t.me/BotFather) в Telegram
2. Отправьте команду: `/newbot`
3. Следуйте инструкциям:
   - Имя бота: `QazaqAir Notifier`
   - Username: `QazaqAirNotifierBot` (должен заканчиваться на "Bot")
4. Сохраните полученный **токен бота**

### 2. Получение Chat ID

1. Найдите вашего бота в Telegram
2. Отправьте ему любое сообщение
3. Откройте в браузере: `https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates`
4. Найдите `chat.id` в ответе и сохраните его

### 3. Настройка в n8n

#### Метод 1: Использование готового скрипта

1. В n8n создайте **Function node**
2. Вставьте содержимое файла `n8n-telegram-notify.js`
3. Добавьте **HTTP Request node** после Function node
4. Настройте HTTP Request:
   ```
   Method: POST
   URL: {{ $json.url }}
   Body: JSON
   JSON: {{ $json.payload }}
   ```

#### Метод 2: Прямая интеграция

1. Используйте встроенный **Telegram node** в n8n
2. Настройте credentials:
   - Bot Token: ваш токен от BotFather
   - Chat ID: ваш chat ID

## 📝 Примеры workflow

### Пример 1: Уведомление о запуске сервиса

```
Trigger (Webhook/Cron) → Function Node → Telegram Node
```

**Function Node код:**
```javascript
// Используйте готовые шаблоны
const notification = {
  type: 'success',
  title: 'Сервис запущен',
  message: 'Backend API успешно запущен',
  data: {
    service: 'backend-api',
    version: '1.0.0',
    environment: 'production'
  }
};

return [{
  json: {
    chatId: 'YOUR_CHAT_ID',
    text: `✅ *QazaqAir - ${notification.title}*\n\n📝 ${notification.message}\n\n🔧 Сервис: ${notification.data.service}\n📦 Версия: ${notification.data.version}\n🌍 Окружение: ${notification.data.environment}\n⏰ ${new Date().toLocaleString('ru-RU')}`,
    parseMode: 'Markdown'
  }
}];
```

### Пример 2: Уведомления об ошибках

```
Error Trigger → Function Node → Telegram Node
```

### Пример 3: Резервное копирование

```
Cron Trigger (ежедневно 03:00) → Backup Script → Function Node → Telegram Node
```

## 🔧 Конфигурация

### Основные переменные

```javascript
const CONFIG = {
  telegramBotToken: '1234567890:ABCdefGHIjklMNOpqrsTUVwxyz',
  telegramChatId: '123456789',
  project: {
    name: 'QazaqAir',
    environment: 'production',
    version: '1.0.0'
  }
};
```

### Типы уведомлений

- `info` - ℹ️ Информационные
- `success` - ✅ Успешные операции  
- `warning` - ⚠️ Предупреждения
- `error` - ❌ Ошибки

## 📊 Готовые шаблоны

### Системные события
- Запуск/остановка сервисов
- Ошибки приложений
- Обновления системы

### Мониторинг
- Превышение порогов метрик
- Восстановление сервисов
- Проверка доступности

### База данных
- Создание бэкапов
- Ошибки подключения
- Оптимизация производительности

### Развертывание
- Начало/завершение деплоя
- Откат изменений
- Тестирование

## 🛡️ Безопасность

1. **Храните токен в безопасности** - используйте n8n credentials
2. **Ограничьте доступ к боту** - настройте whitelist
3. **Используйте переменные окружения** для чувствительных данных
4. **Регулярно обновляйте токен** при необходимости

## 🚨 Распространенные проблемы

### Ошибка "Bad Request: chat not found"
- Проверьте правильность Chat ID
- Убедитесь, что пользователь написал боту хотя бы одно сообщение

### Ошибка "Unauthorized"
- Проверьте правильность токена бота
- Убедитесь, что бот не был удален

### Нет уведомлений
- Проверьте настройки n8n workflow
- Убедитесь, что Telegram node получает правильные данные

## 📈 Мониторинг

Для отслеживания работы уведомлений:

1. Добавьте логирование в Function nodes
2. Используйте n8n execution history
3. Настройте дашборды в Grafana (уже настроен в проекте)

## 🔗 Интеграция с существующими сервисами

### Docker Compose интеграция
```yaml
# Добавьте в docker-compose.yml
n8n-telegram:
  image: n8nio/n8n
  environment:
    - TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}
    - TELEGRAM_CHAT_ID=${TELEGRAM_CHAT_ID}
  volumes:
    - ./n8n-telegram-notify.js:/home/node/.n8n/telegram-notify.js
```

### Prometheus метрики
```javascript
// Добавьте в Function node
const metrics = {
  telegram_notifications_sent: 1,
  telegram_notifications_failed: 0
};
```

## 📞 Поддержка

Если возникли проблемы:
1. Проверьте логи n8n: `docker-compose logs n8n`
2. Проверьте статус Telegram API: https://core.telegram.org/bots/api
3. Обратитесь к документации n8n: https://docs.n8n.io/

---

**Готово!** Теперь ваш проект QazaqAir будет отправлять уведомления в Telegram через n8n.
