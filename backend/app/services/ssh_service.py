import asyncio
import asyncssh
import sys
from app.core.config import settings

class SSHServer(asyncssh.SSHServer):
    def password_auth_supported(self):
        return True

    def validate_password(self, username, password):
        return username == settings.SSH_USER and password == settings.SSH_PASS

async def handle_client(process):
    process.stdout.write('Welcome to QazaqAir SSH Management Console!\n')
    process.stdout.write('Available commands: status, backup, exit\n')
    
    while True:
        process.stdout.write('qazaqair> ')
        try:
            line = await process.stdin.readline()
        except EOFError:
            break
        except Exception:
            break
            
        if not line:
            break

        line = line.strip()
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
            from app.services.backup_service import backup_service
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
    host_key = None
    try:
        import os
        if not os.path.exists(host_key_path):
            # Для современных клиентов (OpenSSH Windows) используем ed25519
            key = asyncssh.generate_private_key('ssh-ed25519')
            key.write_private_key(host_key_path)
        host_key = host_key_path
    except Exception as e:
        print(f"[SSH] Error creating host key: {e}")
        # Если не удалось создать файл, используем сгенерированный в памяти
        host_key = asyncssh.generate_private_key('ssh-ed25519')

    try:
        await asyncssh.listen('', settings.SSH_PORT,
                             server_factory=SSHServer,
                             process_factory=handle_client,
                             server_host_keys=[host_key],
                             kex_algs=[
                                 'curve25519-sha256',
                                 'curve25519-sha256@libssh.org',
                                 'diffie-hellman-group14-sha256'
                             ],
                             encryption_algs=[
                                 'chacha20-poly1305@openssh.com',
                                 'aes256-gcm@openssh.com',
                                 'aes128-gcm@openssh.com',
                                 'aes256-ctr',
                                 'aes128-ctr'
                             ],
                             mac_algs=[
                                 'hmac-sha2-256-etm@openssh.com',
                                 'hmac-sha2-512-etm@openssh.com',
                                 'hmac-sha2-256',
                                 'hmac-sha2-512'
                             ])
        print(f"[SSH] Server started on port {settings.SSH_PORT}")
    except Exception as e:
        print(f"[SSH] Could not start SSH server: {e}")
