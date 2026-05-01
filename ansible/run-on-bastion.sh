#!/bin/bash
# Установка и запуск Ansible на Bastion EC2

# Обновление системы
sudo apt update

# Установка Ansible
sudo apt install -y ansible

# Проверка версии
ansible --version

# Запуск базовой настройки (локально)
cd /home/ubuntu
ansible-playbook ansible/setup.yml -i ansible/inventory.ini

# Запуск мониторинга
ansible-playbook ansible/monitoring.yml -i ansible/inventory.ini

# Запуск безопасности
ansible-playbook ansible/security.yml -i ansible/inventory.ini

echo "Ansible настройка завершена!"
