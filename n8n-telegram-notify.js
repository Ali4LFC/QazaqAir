/**
 * n8n Telegram Notification Script for QazaqAir Project
 * Используйте этот скрипт в n8n Function node для отправки уведомлений в Telegram
 */

// Конфигурация - замените на ваши значения
const CONFIG = {
  telegramBotToken: 'YOUR_BOT_TOKEN_HERE', // Получите от @BotFather
  telegramChatId: 'YOUR_CHAT_ID_HERE', // ID чата для уведомлений
  project: {
    name: 'QazaqAir',
    environment: 'production', // production, staging, development
    version: '1.0.0'
  }
};

/**
 * Основная функция для отправки уведомлений
 * @param {Object} options - Опции уведомления
 * @param {string} options.type - Тип уведомления (info, warning, error, success)
 * @param {string} options.title - Заголовок уведомления
 * @param {string} options.message - Текст сообщения
 * @param {Object} options.data - Дополнительные данные
 */
async function sendNotification(options) {
  const { type = 'info', title, message, data = {} } = options;
  
  // Формирование сообщения
  const formattedMessage = formatMessage(type, title, message, data);
  
  try {
    // Отправка в Telegram
    const response = await sendToTelegram(formattedMessage);
    
    return {
      success: true,
      message: 'Уведомление успешно отправлено в Telegram',
      response: response
    };
  } catch (error) {
    return {
      success: false,
      message: 'Ошибка отправки уведомления',
      error: error.message
    };
  }
}

/**
 * Форматирование сообщения для Telegram
 */
function formatMessage(type, title, message, data) {
  const icons = {
    info: 'ℹ️',
    warning: '⚠️',
    error: '❌',
    success: '✅'
  };
  
  const icon = icons[type] || icons.info;
  const timestamp = new Date().toLocaleString('ru-RU', { 
    timeZone: 'Asia/Almaty' 
  });
  
  let formatted = `${icon} *${CONFIG.project.name} - ${title}*\n\n`;
  formatted += `📝 ${message}\n\n`;
  formatted += `🔧 Окружение: ${CONFIG.project.environment}\n`;
  formatted += `⏰ Время: ${timestamp}\n`;
  
  // Добавление дополнительных данных
  if (Object.keys(data).length > 0) {
    formatted += `\n📊 *Дополнительная информация:*\n`;
    Object.entries(data).forEach(([key, value]) => {
      formatted += `• ${key}: ${value}\n`;
    });
  }
  
  return formatted;
}

/**
 * Отправка сообщения в Telegram API
 */
async function sendToTelegram(message) {
  const url = `https://api.telegram.org/bot${CONFIG.telegramBotToken}/sendMessage`;
  
  const payload = {
    chat_id: CONFIG.telegramChatId,
    text: message,
    parse_mode: 'Markdown',
    disable_web_page_preview: true
  };
  
  const response = await fetch(url, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(payload)
  });
  
  if (!response.ok) {
    throw new Error(`Telegram API error: ${response.status} ${response.statusText}`);
  }
  
  return await response.json();
}

/**
 * Предустановленные шаблоны уведомлений
 */
const NOTIFICATIONS = {
  // Системные уведомления
  system: {
    startup: (serviceName) => ({
      type: 'success',
      title: 'Сервис запущен',
      message: `Сервис ${serviceName} успешно запущен`,
      data: { service: serviceName }
    }),
    
    shutdown: (serviceName) => ({
      type: 'warning',
      title: 'Сервис остановлен',
      message: `Сервис ${serviceName} был остановлен`,
      data: { service: serviceName }
    }),
    
    error: (serviceName, error) => ({
      type: 'error',
      title: 'Ошибка сервиса',
      message: `В сервисе ${serviceName} произошла ошибка`,
      data: { service: serviceName, error: error }
    })
  },
  
  // База данных
  database: {
    backup: {
      success: (size, duration) => ({
        type: 'success',
        title: 'Резервная копия создана',
        message: 'Резервная копия базы данных успешно создана',
        data: { size: `${size}MB`, duration: `${duration}с` }
      }),
      
      failed: (error) => ({
        type: 'error',
        title: 'Ошибка резервного копирования',
        message: 'Не удалось создать резервную копию базы данных',
        data: { error: error }
      })
    }
  },
  
  // Мониторинг
  monitoring: {
    alert: (metric, value, threshold) => ({
      type: 'warning',
      title: 'Превышен порог метрики',
      message: `Метрика ${metric} превысила пороговое значение`,
      data: { metric, value, threshold }
    }),
    
    recovery: (metric) => ({
      type: 'success',
      title: 'Метрика восстановлена',
      message: `Метрика ${metric} вернулась в норму`,
      data: { metric }
    })
  },
  
  // Развертывание
  deployment: {
    started: (version) => ({
      type: 'info',
      title: 'Развертывание начато',
      message: `Начато развертывание версии ${version}`,
      data: { version }
    }),
    
    completed: (version, duration) => ({
      type: 'success',
      title: 'Развертывание завершено',
      message: `Развертывание версии ${version} успешно завершено`,
      data: { version, duration: `${duration}мин` }
    }),
    
    failed: (version, error) => ({
      type: 'error',
      title: 'Развертывание не удалось',
      message: `Развертывание версии ${version} завершилось с ошибкой`,
      data: { version, error }
    })
  }
};

// Экспорт для использования в n8n
module.exports = {
  sendNotification,
  NOTIFICATIONS,
  CONFIG
};

// Примеры использования в n8n:
/*
// 1. Простое уведомление
await sendNotification({
  type: 'info',
  title: 'Тестовое уведомление',
  message: 'Это тестовое сообщение из n8n'
});

// 2. Уведомление о запуске сервиса
await sendNotification(NOTIFICATIONS.system.startup('backend-api'));

// 3. Уведомление об ошибке базы данных
await sendNotification(NOTIFICATIONS.database.backup.failed('Недостаточно места на диске'));

// 4. Уведомление о развертывании
await sendNotification(NOTIFICATIONS.deployment.completed('1.2.3', 5));
*/
