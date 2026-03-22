import docker
import telebot
import time
import os

TOKEN = os.getenv('TELEGRAM_TOKEN')
CHAT_ID = os.getenv('CHAT_ID')
bot = telebot.TeleBot(TOKEN)
client = docker.from_env()

def listen_docker():
    print("Бот запущен. Слушаю события Docker...")
    bot.send_message(CHAT_ID, "🚀 Система мониторинга QazaqAir запущена!")
    
    # Слушаем поток событий (Events) вместо цикла со sleep
    for event in client.events(decode=True):
        if event['Type'] == 'container':
            action = event['Action']
            # Имя контейнера из атрибутов
            name = event['Actor']['Attributes'].get('name', 'unknown')
            
            if action == 'stop':
                bot.send_message(CHAT_ID, f"🚨 ALERT: Контейнер {name} ОСТАНОВЛЕН!")
            elif action == 'die':
                bot.send_message(CHAT_ID, f"❌ ALERT: Контейнер {name} упал (die)!")
            elif action == 'start':
                bot.send_message(CHAT_ID, f"✅ Контейнер {name} снова ЗАПУЩЕН.")

if __name__ == "__main__":
    try:
        listen_docker()
    except Exception as e:
        print(f"Ошибка: {e}")