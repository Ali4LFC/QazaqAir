import docker
import telebot
import requests
import os
import time
from datetime import datetime, timedelta
from openai import OpenAI

# Configuration
TOKEN = os.getenv('TELEGRAM_TOKEN')
CHAT_ID = os.getenv('CHAT_ID')
ALLOWED_USER_IDS = [int(i.strip()) for i in os.getenv('ALLOWED_USER_IDS', '').split(',') if i.strip()]
PROMETHEUS_URL = os.getenv('PROMETHEUS_URL', 'http://prometheus:9090')
ALERTMANAGER_URL = os.getenv('ALERTMANAGER_URL', 'http://alertmanager:9093')
COMPOSE_PROJECT_NAME = os.getenv('COMPOSE_PROJECT_NAME', 'qazaqair')
OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')
OPENAI_API_BASE = os.getenv('OPENAI_API_BASE', 'https://api.openai.com/v1')
AI_MODEL = os.getenv('AI_MODEL', 'gpt-3.5-turbo')


def _clean_env_value(value, default=""):
    if value is None:
        return default
    # docker env_file may keep inline comments as part of value
    return value.split('#', 1)[0].strip()


bot = telebot.TeleBot(TOKEN)
client = docker.from_env()
ai_client = OpenAI(
    api_key=OPENAI_API_KEY,
    base_url=OPENAI_API_BASE
) if OPENAI_API_KEY else None

METRIC_QUERIES = {
    "cpu_usage": '100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)',
    "memory_usage": '(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100',
    "disk_usage": '(1 - (node_filesystem_avail_bytes{mountpoint="/",fstype!~"tmpfs|overlay"} / node_filesystem_size_bytes{mountpoint="/",fstype!~"tmpfs|overlay"})) * 100',
}

EXPORTER_QUERIES = {
    "node_up": 'up{job="node-exporter"}',
    "node_load_1m": 'node_load1',
    "node_uptime": 'node_time_seconds - node_boot_time_seconds',
    "nginx_up": 'up{job="nginx"}',
    "nginx_connections_active": 'nginx_connections_active',
    "nginx_http_requests_rate": 'sum(rate(nginx_http_requests_total[5m]))',
    "postgres_up": 'up{job="postgres-exporter"}',
    "postgres_connections": 'sum(pg_stat_database_numbackends)',
    "postgres_db_size": 'sum(pg_database_size_bytes)',
}

def is_authorized(message):
    return message.from_user.id in ALLOWED_USER_IDS


def build_main_menu():
    kb = telebot.types.InlineKeyboardMarkup(row_width=2)
    kb.add(
        telebot.types.InlineKeyboardButton("📊 Текущие метрики", callback_data="menu_metrics"),
        telebot.types.InlineKeyboardButton("🚨 Активные алерты", callback_data="menu_alerts"),
    )
    kb.add(
        telebot.types.InlineKeyboardButton("🧩 Экспортеры", callback_data="menu_exporters"),
        telebot.types.InlineKeyboardButton("🔌 Состояние контейнеров", callback_data="menu_status"),
    )
    return kb

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


def get_prometheus_metrics_snapshot():
    snapshot = {}
    for key, query in METRIC_QUERIES.items():
        snapshot[key] = get_prometheus_metric(query)
    return snapshot


def format_percent_metric(value):
    if value in (None, "N/A"):
        return "N/A"
    try:
        return f"{float(value):.2f}%"
    except Exception:
        return str(value)


def get_active_alerts():
    try:
        response = requests.get(f"{ALERTMANAGER_URL}/api/v2/alerts", timeout=20)
        response.raise_for_status()
        alerts = response.json()
        active = []
        for alert in alerts:
            status = alert.get("status", {}).get("state", "")
            if status != "active":
                continue
            labels = alert.get("labels", {})
            active.append({
                "name": labels.get("alertname", "unknown"),
                "severity": labels.get("severity", "n/a"),
                "instance": labels.get("instance", "n/a"),
            })
        return active
    except Exception as e:
        print(f"Error querying Alertmanager: {e}")
        return None


def format_exporters_report():
    values = {k: get_prometheus_metric(v) for k, v in EXPORTER_QUERIES.items()}

    def up_icon(raw):
        try:
            return "✅" if float(raw) >= 1 else "❌"
        except Exception:
            return "❓"

    def as_number(raw, precision=2):
        if raw in (None, "N/A"):
            return "N/A"
        try:
            return f"{float(raw):.{precision}f}"
        except Exception:
            return str(raw)

    uptime = "N/A"
    raw_uptime = values.get("node_uptime")
    try:
        uptime = str(timedelta(seconds=int(float(raw_uptime))))
    except Exception:
        pass

    db_size_gb = "N/A"
    raw_db_size = values.get("postgres_db_size")
    try:
        db_size_gb = f"{(float(raw_db_size) / (1024 ** 3)):.2f} GB"
    except Exception:
        if raw_db_size not in (None, "N/A"):
            db_size_gb = str(raw_db_size)

    text = (
        "🧩 *Отчет по экспортерам*\n\n"
        "*Node Exporter*\n"
        f"{up_icon(values.get('node_up'))} UP: `{values.get('node_up', 'N/A')}`\n"
        f"📈 Load (1m): `{as_number(values.get('node_load_1m'))}`\n"
        f"⏱️ Uptime: `{uptime}`\n\n"
        "*Nginx Exporter*\n"
        f"{up_icon(values.get('nginx_up'))} UP: `{values.get('nginx_up', 'N/A')}`\n"
        f"🔗 Active connections: `{as_number(values.get('nginx_connections_active'), 0)}`\n"
        f"🌐 HTTP req/s (5m): `{as_number(values.get('nginx_http_requests_rate'))}`\n\n"
        "*Postgres Exporter*\n"
        f"{up_icon(values.get('postgres_up'))} UP: `{values.get('postgres_up', 'N/A')}`\n"
        f"🧵 Active DB connections: `{as_number(values.get('postgres_connections'), 0)}`\n"
        f"💾 Total DB size: `{db_size_gb}`\n\n"
        f"🕒 Updated: `{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}`"
    )
    return text


def get_project_containers():
    try:
        containers = client.containers.list(
            all=True,
            filters={"label": f"com.docker.compose.project={COMPOSE_PROJECT_NAME}"}
        )
        if containers:
            return containers
    except Exception as e:
        print(f"Error filtering containers by compose project label: {e}")

    # Fallback: keep previous behavior if label-based filtering fails
    return client.containers.list(all=True)


def format_container_status_report():
    containers = get_project_containers()
    report = "🔌 *Service Status Report:*\n\n"

    one_shot_services = {'zabbix-setup'}
    for c in containers:
        status = c.status
        exit_code = c.attrs.get('State', {}).get('ExitCode') if hasattr(c, 'attrs') else None

        if c.name in one_shot_services and status == 'exited' and exit_code == 0:
            status_icon = "⚙️"
            status_text = "completed"
        else:
            status_icon = "✅" if status == "running" else "❌"
            status_text = status

        report += f"{status_icon} `{c.name}`: {status_text}\n"

    return report

# --- Bot Command Handlers ---

@bot.message_handler(commands=['start', 'help'])
def send_welcome(message):
    if not is_authorized(message): return
    help_text = (
        "🤖 *Advanced Monitoring Bot*\n\n"
        "🧩 *Exporters & Metrics:*\n"
        "/exporters - Node/Nginx/Postgres exporters report\n"
        "/metrics - Current CPU/RAM/Disk metrics\n"
        "/alerts - Active alerts\n\n"
        "🔍 *Analytics & AI:*\n"
        "/top_cpu - Top 5 CPU consumers\n"
        "/predict_disk - Disk exhaustion prediction\n"
        "/ask [question] - Ask AI Assistant (OpenAI GPT)\n"
        "/uptime - Services & System uptime\n\n"
        "🛠️ *Operations:*\n"
        "/status - Container status\n"
        "/logs [service] - Last 20 log lines\n"
        "/restart [service] - Restart container\n"
        "/menu - Open interactive monitoring menu\n"
    )
    bot.reply_to(message, help_text, parse_mode='Markdown', reply_markup=build_main_menu())


@bot.message_handler(commands=['menu'])
def menu_command(message):
    if not is_authorized(message): return
    bot.send_message(message.chat.id, "Выбери, что проверить 👇", reply_markup=build_main_menu())

@bot.message_handler(commands=['exporters'])
def exporters_command(message):
    if not is_authorized(message): return
    bot.reply_to(message, format_exporters_report(), parse_mode='Markdown')


@bot.message_handler(commands=['metrics'])
def metrics_command(message):
    if not is_authorized(message): return
    snapshot = get_prometheus_metrics_snapshot()
    text = (
        "📊 *Текущие метрики системы*\n\n"
        f"🖥️ CPU: `{format_percent_metric(snapshot.get('cpu_usage'))}`\n"
        f"🧠 RAM: `{format_percent_metric(snapshot.get('memory_usage'))}`\n"
        f"💽 Disk (/): `{format_percent_metric(snapshot.get('disk_usage'))}`\n"
        f"🕒 Updated: `{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}`"
    )
    bot.reply_to(message, text, parse_mode='Markdown')

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


@bot.message_handler(commands=['alerts'])
def alerts_command(message):
    if not is_authorized(message): return
    active_alerts = get_active_alerts()
    if active_alerts is None:
        bot.reply_to(message, "❌ Не удалось получить алерты из Alertmanager.")
        return

    if not active_alerts:
        bot.reply_to(message, "✅ Активных алертов нет.")
        return

    lines = ["🚨 *Активные алерты:*\n"]
    for i, alert in enumerate(active_alerts[:10], start=1):
        lines.append(
            f"{i}. *{alert['name']}* | severity: `{alert['severity']}` | instance: `{alert['instance']}`"
        )
    if len(active_alerts) > 10:
        lines.append(f"\n…and {len(active_alerts) - 10} more")
    bot.reply_to(message, "\n".join(lines), parse_mode='Markdown')

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
        report = format_container_status_report()
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


@bot.callback_query_handler(func=lambda call: call.data.startswith('menu_'))
def callbacks(call):
    message = call.message
    if not message:
        return

    if message.chat.type == 'private' and call.from_user.id not in ALLOWED_USER_IDS:
        bot.answer_callback_query(call.id, "Нет доступа")
        return

    data = call.data
    bot.answer_callback_query(call.id)

    if data == 'menu_metrics':
        snapshot = get_prometheus_metrics_snapshot()
        text = (
            "📊 *Текущие метрики системы*\n\n"
            f"🖥️ CPU: `{format_percent_metric(snapshot.get('cpu_usage'))}`\n"
            f"🧠 RAM: `{format_percent_metric(snapshot.get('memory_usage'))}`\n"
            f"💽 Disk (/): `{format_percent_metric(snapshot.get('disk_usage'))}`\n"
            f"🕒 Updated: `{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}`"
        )
        bot.send_message(message.chat.id, text, parse_mode='Markdown')
    elif data == 'menu_alerts':
        active_alerts = get_active_alerts()
        if active_alerts is None:
            bot.send_message(message.chat.id, "❌ Не удалось получить алерты из Alertmanager.")
        elif not active_alerts:
            bot.send_message(message.chat.id, "✅ Активных алертов нет.")
        else:
            lines = ["🚨 *Активные алерты:*\n"]
            for i, alert in enumerate(active_alerts[:10], start=1):
                lines.append(
                    f"{i}. *{alert['name']}* | severity: `{alert['severity']}` | instance: `{alert['instance']}`"
                )
            if len(active_alerts) > 10:
                lines.append(f"\n…and {len(active_alerts) - 10} more")
            bot.send_message(message.chat.id, "\n".join(lines), parse_mode='Markdown')
    elif data == 'menu_exporters':
        bot.send_message(message.chat.id, format_exporters_report(), parse_mode='Markdown')
    elif data == 'menu_status':
        report = format_container_status_report()
        bot.send_message(message.chat.id, report, parse_mode='Markdown')

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
            model=AI_MODEL,
            messages=[
                {"role": "system", "content": "You are a DevOps assistant for QazaqAir monitoring system. Help users with infrastructure, monitoring, and air quality data analysis. You have access to project metrics via other bot commands."},
                {"role": "user", "content": question}
            ],
            extra_headers={
                "HTTP-Referer": "https://github.com/Ali4LFC/QazaqAir", # Optional, for OpenRouter rankings
                "X-Title": "QazaqAir Monitoring Bot", # Optional, for OpenRouter rankings
            }
        )
        answer = response.choices[0].message.content
        bot.reply_to(message, f"🤖 *AI Assistant:* \n\n{answer}", parse_mode='Markdown')
    except Exception as e:
        bot.reply_to(message, f"❌ Error contacting AI: {e}")

if __name__ == "__main__":
    print("Starting bot initialization...")
    # Register commands in Telegram Menu
    try:
        # Clear old commands first
        bot.delete_my_commands()
        time.sleep(2)
        
        bot.set_my_commands([
            telebot.types.BotCommand("menu", "Всплывающее меню мониторинга"),
            telebot.types.BotCommand("exporters", "Отчет по экспортерам"),
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
