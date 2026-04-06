#!/bin/bash

# Цвета для вывода
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "--- Начинаю проверку системы мониторинга ---"

# 1. Проверка Node Exporter
echo -n "Node Exporter (Metrics): "
if curl -s http://localhost:9100/metrics | grep -q "node_cpu_seconds_total"; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}FAILED${NC}"
fi

# 2. Проверка Prometheus API и Таргетов
echo -n "Prometheus API: "
if curl -s http://localhost:9090/-/healthy | grep -q "Prometheus is Healthy"; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}FAILED${NC}"
fi

echo -n "Prometheus Targets: "
TARGETS=$(curl -s http://localhost:9090/api/v1/targets)
if echo $TARGETS | grep -q "node-exporter"; then
    echo -e "${GREEN}OK (node-exporter found)${NC}"
else
    echo -e "${RED}FAILED (node-exporter not found)${NC}"
fi

# 3. Проверка Grafana
echo -n "Grafana UI: "
if curl -s -I http://localhost:3000/login | grep -q "200 OK"; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}FAILED${NC}"
fi

# 4. Проверка Alertmanager
echo -n "Alertmanager: "
if curl -s http://localhost:9093/-/healthy | grep -q "OK"; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}FAILED${NC}"
fi

# 5. Проверка Zabbix Web
echo -n "Zabbix Web: "
if curl -s -I http://localhost:8080 | grep -q "200 OK"; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}FAILED${NC}"
fi

echo "--- Проверка завершена ---"
