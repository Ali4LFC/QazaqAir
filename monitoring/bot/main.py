import docker
import telebot
import requests
import os
import threading
import time
import pandas as pd
from datetime import datetime, timedelta
from io import BytesIO
from openai import OpenAI

# Configuration
TOKEN = os.getenv('TELEGRAM_TOKEN')
CHAT_ID = os.getenv('CHAT_ID')
ALLOWED_USER_IDS = [int(i.strip()) for i in os.getenv('ALLOWED_USER_IDS', '').split(',') if i.strip()]
PROMETHEUS_URL = os.getenv('PROMETHEUS_URL', 'http://prometheus:9090')
ALERTMANAGER_URL = os.getenv('ALERTMANAGER_URL', 'http://alertmanager:9093')
GRAFANA_URL = os.getenv('GRAFANA_URL', 'http://grafana:3000')
GRAFANA_API_KEY = os.getenv('GRAFANA_API_KEY')
DASHBOARD_UID = os.getenv('DASHBOARD_UID', 'node-exporter-full')
OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')

bot = telebot.TeleBot(TOKEN)
client = docker.from_env()
ai_client = OpenAI(api_key=OPENAI_API_KEY) if OPENAI_API_KEY else None

def is_authorized(message):
    return message.from_user.id in ALLOWED_USER_IDS

# --- Helper functions ---

def get_prometheus_metric(query):
    try:
        response = requests.get(f"{PROMETHEUS_URL}/api/v1/query", params={'query': query})
        response.raise_for_status()
        result = response.json()
        if result['status'] == 'success' and result['data']['result']:
            return result['data']['result'][0]['value'][1]
    except Exception as e:
        print(f"Error querying Prometheus: {e}")
    return "N/A"

def render_grafana_panel(panel_id, from_time="now-30m", to_time="now"):
    headers = {'Authorization': f'Bearer {GRAFANA_API_KEY}'}
    # Typical render URL for Grafana (using UID only)
    url = f"{GRAFANA_URL}/render/d-solo/{DASHBOARD_UID}?panelId={panel_id}&from={from_time}&to={to_time}&width=1000&height=500"
    try:
        response = requests.get(url, headers=headers, timeout=30)
        response.raise_for_status()
        return BytesIO(response.content)
    except Exception as e:
        print(f"Error rendering Grafana panel {panel_id}: {e}")
        return None

# --- Bot Command Handlers ---

@bot.message_handler(commands=['start', 'help'])
def send_welcome(message):
    if not is_authorized(message): return
    help_text = (
        "🤖 *Advanced Monitoring Bot*\n\n"
        "📈 *Visuals:*\n"
        "/render [id] - Render specific Grafana panel\n"
        "/dashboard - Get core metrics graphs\n\n"
        "🔍 *Analytics & AI:*\n"
        "/top_cpu - Top 5 CPU consumers\n"
        "/predict_disk - Disk exhaustion prediction\n"
        "/ask [question] - Ask AI Assistant (OpenAI GPT)\n"
        "/uptime - Services & System uptime\n\n"
        "🛠️ *Operations:*\n"
        "/status - Container status\n"
        "/logs [service] - Last 20 log lines\n"
        "/restart [service] - Restart container\n"
        "/alerts - Active alerts\n"
    )
    bot.reply_to(message, help_text, parse_mode='Markdown')

@bot.message_handler(commands=['render'])
def render_command(message):
    if not is_authorized(message): return
    args = message.text.split()
    if len(args) < 2:
        bot.reply_to(message, "⚠️ Usage: /render [panel_id]")
        return
    panel_id = args[1]
    bot.send_chat_action(message.chat.id, 'upload_photo')
    image = render_grafana_panel(panel_id)
    if image:
        bot.send_photo(message.chat.id, image, caption=f"📊 Panel {panel_id}")
    else:
        bot.reply_to(message, "❌ Failed to render panel. Check GRAFANA_API_KEY and Renderer status.")

@bot.message_handler(commands=['dashboard'])
def dashboard_command(message):
    if not is_authorized(message): return
    bot.send_message(message.chat.id, "⌛ Rendering dashboard graphs, please wait...")
    panels = {
        "CPU": 7,     # Common IDs in Node Exporter Full
        "RAM": 156,
        "Disk": 16,
        "Network": 13
    }
    media = []
    for name, pid in panels.items():
        img = render_grafana_panel(pid)
        if img:
            media.append(telebot.types.InputMediaPhoto(img, caption=f"📊 {name} usage (30m)"))
    
    if media:
        bot.send_media_group(message.chat.id, media)
    else:
        bot.reply_to(message, "❌ Could not render dashboard panels.")

@bot.message_handler(commands=['top_cpu'])
def top_cpu_command(message):
    if not is_authorized(message): return
    # PromQL for top 5 CPU consuming containers (if using cAdvisor) or node processes
    # Example using node_exporter process metrics if available, or just system load
    query = 'topk(5, rate(node_cpu_seconds_total{mode="user"}[5m]))'
    # This is a simplified example; actual PromQL depends on available metrics
    res = get_prometheus_metric(query)
    bot.reply_to(message, f"🔝 *Top CPU Usage:* `{res}`", parse_mode='Markdown')

@bot.message_handler(commands=['predict_disk'])
def predict_disk_command(message):
    if not is_authorized(message): return
    # predict_linear: will disk fill in 24h?
    query = 'predict_linear(node_filesystem_free_bytes{mountpoint="/"}[1h], 3600 * 24) < 0'
    res = get_prometheus_metric(query)
    if res != "N/A":
        bot.reply_to(message, "⚠️ *Alert:* Disk is predicted to fill within 24 hours!", parse_mode='Markdown')
    else:
        bot.reply_to(message, "✅ Disk usage is stable for the next 24h.")

@bot.message_handler(commands=['uptime'])
def uptime_command(message):
    if not is_authorized(message): return
    sys_uptime = get_prometheus_metric('node_time_seconds - node_boot_time_seconds')
    try:
        uptime_str = str(timedelta(seconds=int(float(sys_uptime))))
        bot.reply_to(message, f"⏱️ *System Uptime:* `{uptime_str}`", parse_mode='Markdown')
    except:
        bot.reply_to(message, "❌ Error calculating uptime.")

@bot.message_handler(commands=['logs'])
def logs_command(message):
    if not is_authorized(message): return
    args = message.text.split()
    if len(args) < 2:
        bot.reply_to(message, "⚠️ Usage: /logs [service_name]")
        return
    service_name = args[1]
    try:
        container = client.containers.get(service_name)
        logs = container.logs(tail=20).decode('utf-8')
        bot.reply_to(message, f"📋 *Last 20 lines for {service_name}:*\n\n`{logs}`", parse_mode='Markdown')
    except Exception as e:
        bot.reply_to(message, f"❌ Error: {e}")

@bot.message_handler(commands=['status'])
def status_command(message):
    if not is_authorized(message): return
    try:
        containers = client.containers.list(all=True)
        report = "🔌 *Service Status Report:*\n\n"
        for c in containers:
            status_icon = "✅" if c.status == "running" else "❌"
            report += f"{status_icon} `{c.name}`: {c.status}\n"
        bot.reply_to(message, report, parse_mode='Markdown')
    except Exception as e:
        bot.reply_to(message, f"❌ Error: {e}")

@bot.message_handler(commands=['restart'])
def restart_command(message):
    if not is_authorized(message): return
    args = message.text.split()
    if len(args) < 2: return
    service_name = args[1]
    try:
        container = client.containers.get(service_name)
        bot.reply_to(message, f"🔄 Restarting `{service_name}`...")
        container.restart()
        bot.reply_to(message, f"✅ Restarted.")
    except Exception as e:
        bot.reply_to(message, f"❌ Error: {e}")

@bot.message_handler(commands=['ask'])
def ask_ai_command(message):
    if not is_authorized(message): return
    if not ai_client:
        bot.reply_to(message, "❌ OpenAI Assistant is not configured. Please set OPENAI_API_KEY in environment.")
        return
    
    question = message.text.replace('/ask', '').strip()
    if not question:
        bot.reply_to(message, "⚠️ Please provide a question: /ask [your question]")
        return

    bot.send_chat_action(message.chat.id, 'typing')
    try:
        response = ai_client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "You are a DevOps assistant for QazaqAir monitoring system. Help users with infrastructure, monitoring, and air quality data analysis. You have access to project metrics via other bot commands."},
                {"role": "user", "content": question}
            ]
        )
        answer = response.choices[0].message.content
        bot.reply_to(message, f"🤖 *AI Assistant:* \n\n{answer}", parse_mode='Markdown')
    except Exception as e:
        bot.reply_to(message, f"❌ Error contacting AI: {e}")

# --- Docker Event Listener ---
def listen_docker_events():
    for event in client.events(decode=True):
        if event['Type'] == 'container' and event['Action'] in ['stop', 'die', 'oom']:
            name = event['Actor']['Attributes'].get('name', 'unknown')
            bot.send_message(CHAT_ID, f"🚨 *ALERT:* Container `{name}` {event['Action'].upper()}!", parse_mode='Markdown')

if __name__ == "__main__":
    print("Starting bot initialization...")
    # Register commands in Telegram Menu
    try:
        # Clear old commands first
        bot.delete_my_commands()
        time.sleep(2)
        
        bot.set_my_commands([
            telebot.types.BotCommand("dashboard", "Основные графики (CPU/RAM/Disk)"),
            telebot.types.BotCommand("status", "Состояние контейнеров"),
            telebot.types.BotCommand("metrics", "Текущие метрики"),
            telebot.types.BotCommand("top_cpu", "Топ потребителей CPU"),
            telebot.types.BotCommand("predict_disk", "Прогноз заполнения диска"),
            telebot.types.BotCommand("ask", "Спросить ИИ-ассистента"),
            telebot.types.BotCommand("logs", "Логи контейнера"),
            telebot.types.BotCommand("alerts", "Активные алерты"),
            telebot.types.BotCommand("uptime", "Аптайм системы"),
            telebot.types.BotCommand("help", "Справка")
        ])
        print("Commands registered successfully in Telegram.")
    except Exception as e:
        print(f"Error registering commands: {e}")
    
    # Ensure no webhooks are active
    try:
        bot.remove_webhook()
    except:
        pass

    # Start Docker listener in a background thread
    print("Advanced Bot is polling...")
    bot.infinity_polling()
