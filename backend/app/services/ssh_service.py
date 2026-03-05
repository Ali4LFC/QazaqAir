import asyncio
import asyncssh
import sys
from backend.app.core.config import settings

class SSHServer(asyncssh.SSHServer):
    def password_auth_supported(self):
        return True

    def validate_password(self, username, password):
        return username == settings.SSH_USER and password == settings.SSH_PASS

def handle_client(process):
    process.stdout.write('Welcome to QazaqAir SSH Management Console!\n')
    process.stdout.write('Available commands: status, backup, exit\n')
    
    while True:
        process.stdout.write('qazaqair> ')
        try:
            line = process.stdin.readline().strip()
        except EOFError:
            break
            
        if not line:
            continue
            
        cmd = line.lower()
        if cmd == 'exit':
            process.stdout.write('Goodbye!\n')
            break
        elif cmd == 'status':
            process.stdout.write('Service: QazaqAir\n')
            process.stdout.write(f'DB Configured: {"Yes" if settings.POSTGRES_URL else "No"}\n')
            process.stdout.write(f'WAQI Token: {"Set" if settings.WAQI_TOKEN else "Not set"}\n')
        elif cmd == 'backup':
            process.stdout.write('Starting manual backup...\n')
            from backend.app.services.backup_service import backup_service
            path = backup_service.run_backup()
            if path:
                process.stdout.write(f'Backup created: {path}\n')
            else:
                process.stdout.write('Backup failed! Check logs.\n')
        else:
            process.stdout.write(f'Unknown command: {cmd}\n')
            
    process.exit(0)

async def start_ssh_server():
    if not settings.SSH_ENABLED:
        return

    # Для работы SSH нужен ключ хоста. В реальном проекте его лучше генерировать заранее.
    # Для демонстрации создадим временный ключ, если его нет.
    host_key_path = 'backend/certs/ssh_host_key'
    try:
        import os
        if not os.path.exists(host_key_path):
            # Генерируем ключ, если нет asyncssh.generate_private_key
            key = asyncssh.generate_private_key('ssh-rsa')
            key.write_private_key(host_key_path)
    except Exception as e:
        print(f"[SSH] Error creating host key: {e}")
        # Если не удалось создать файл, используем сгенерированный в памяти
        host_key_path = asyncssh.generate_private_key('ssh-rsa')

    try:
        await asyncssh.listen('', settings.SSH_PORT,
                             server_factory=SSHServer,
                             process_factory=handle_client)
        print(f"[SSH] Server started on port {settings.SSH_PORT}")
    except Exception as e:
        print(f"[SSH] Could not start SSH server: {e}")
