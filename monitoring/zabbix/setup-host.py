#!/usr/bin/env python3
"""Auto-configure Zabbix host for docker monitoring."""
import requests
import json
import sys
import time

ZABBIX_URL = "http://zabbix-web:8080/api_jsonrpc.php"
ZABBIX_USER = "Admin"
ZABBIX_PASS = "zabbix"


def api_call(method, params, auth_token=None):
    payload = {
        "jsonrpc": "2.0",
        "method": method,
        "params": params,
        "id": 1
    }
    if auth_token:
        payload["auth"] = auth_token

    try:
        resp = requests.post(ZABBIX_URL, json=payload, headers={"Content-Type": "application/json"}, timeout=10)
        return resp.json()
    except Exception as e:
        print(f"API Error: {e}")
        return None


def get_auth_token():
    result = api_call("user.login", {"username": ZABBIX_USER, "password": ZABBIX_PASS})
    if result and "result" in result:
        return result["result"]
    print(f"Login failed: {result}")
    return None


def get_template_id(auth_token, name):
    result = api_call("template.get", {"filter": {"host": [name]}}, auth_token)
    if result and "result" in result and result["result"]:
        return result["result"][0]["templateid"]
    return None


def get_group_id(auth_token, name):
    result = api_call("hostgroup.get", {"filter": {"name": [name]}}, auth_token)
    if result and "result" in result and result["result"]:
        return result["result"][0]["groupid"]
    return None


def host_exists(auth_token, hostname):
    result = api_call("host.get", {"filter": {"host": [hostname]}}, auth_token)
    return result and "result" in result and len(result["result"]) > 0


def remove_host_if_exists(auth_token, hostname):
    """Remove a host if it exists (cleanup previously created host)."""
    result = api_call("host.get", {"filter": {"host": [hostname]}, "output": ["hostid"]}, auth_token)
    if result and "result" in result and result["result"]:
        host_id = result["result"][0]["hostid"]
        delete_result = api_call("host.delete", [host_id], auth_token)
        if delete_result and "result" in delete_result:
            print(f"Removed host '{hostname}' (ID: {host_id})")
            return True
    return False


def update_zabbix_server_host(auth_token):
    """Update the built-in 'Zabbix server' host to use zabbix-agent container."""
    result = api_call("host.get", {
        "filter": {"host": ["Zabbix server"]},
        "output": ["hostid", "status", "name"],
        "selectInterfaces": ["interfaceid", "type", "dns", "ip", "port", "useip"],
        "selectParentTemplates": ["templateid", "name"]
    }, auth_token)
    
    if not result or "result" not in result or not result["result"]:
        print("ERROR: 'Zabbix server' host not found")
        return False
    
    host = result["result"][0]
    host_id = host["hostid"]
    print(f"Found host 'Zabbix server' (ID: {host_id})")
    
    # Get Linux template ID
    linux_template_id = get_template_id(auth_token, "Linux by Zabbix agent")
    docker_template_id = get_template_id(auth_token, "Docker by Zabbix agent 2")
    
    # Check if templates already linked
    current_templates = [t["templateid"] for t in host.get("parentTemplates", [])]
    templates_to_add = []
    
    if linux_template_id and linux_template_id not in current_templates:
        templates_to_add.append({"templateid": linux_template_id})
        print(f"Will add template: Linux by Zabbix agent")
    
    if docker_template_id and docker_template_id not in current_templates:
        templates_to_add.append({"templateid": docker_template_id})
        print(f"Will add template: Docker by Zabbix agent 2")
    
    # Update host: change interface to zabbix-agent DNS, enable host, add templates
    update_params = {
        "hostid": host_id,
        "status": 0,  # Enable host
        "name": "QazaqAir Zabbix Server"  # Better display name
    }
    
    # Update interface to use zabbix-agent container
    if host.get("interfaces"):
        interface_id = host["interfaces"][0]["interfaceid"]
        update_params["interfaces"] = [{
            "interfaceid": interface_id,
            "type": 1,
            "main": 1,
            "useip": 0,
            "ip": "",
            "dns": "zabbix-agent",
            "port": "10050"
        }]
        print("Will update agent interface to: DNS=zabbix-agent, Port=10050")
    
    if templates_to_add:
        update_params["templates"] = templates_to_add
    
    update_result = api_call("host.update", update_params, auth_token)
    if update_result and "result" in update_result:
        print(f"SUCCESS: Updated 'Zabbix server' host")
        return True
    else:
        print(f"FAILED to update host: {update_result}")
        return False


def create_host(auth_token):
    if host_exists(auth_token, "zabbix-server"):
        print("Host 'zabbix-server' already exists.")
        return True

    # List available templates for debugging
    templates_result = api_call("template.get", {"output": ["templateid", "name"], "limit": 20}, auth_token)
    if templates_result and "result" in templates_result:
        print("Available templates:")
        for t in templates_result["result"][:10]:
            print(f"  - {t['name']} (ID: {t['templateid']})")

    # Try different template names
    linux_template_id = get_template_id(auth_token, "Linux by Zabbix agent 2")
    if not linux_template_id:
        linux_template_id = get_template_id(auth_token, "Linux by Zabbix agent")
    if not linux_template_id:
        linux_template_id = get_template_id(auth_token, "Template OS Linux")
    
    docker_template_id = get_template_id(auth_token, "Docker by Zabbix agent 2")
    group_id = get_group_id(auth_token, "Linux servers")

    if not linux_template_id:
        print("ERROR: Template 'Linux by Zabbix agent 2' not found")
        return False
    if not docker_template_id:
        print("WARNING: Template 'Docker by Zabbix agent 2' not found, skipping Docker monitoring")
    if not group_id:
        print("ERROR: Host group 'Linux servers' not found")
        return False

    templates = [{"templateid": linux_template_id}]
    if docker_template_id:
        templates.append({"templateid": docker_template_id})

    params = {
        "host": "zabbix-server",
        "name": "Docker Host",
        "interfaces": [{
            "type": 1,
            "main": 1,
            "useip": 0,
            "ip": "",
            "dns": "zabbix-agent",
            "port": "10050"
        }],
        "groups": [{"groupid": group_id}],
        "templates": templates,
        "status": 0,
        "tls_connect": 1,
        "tls_accept": 1
    }

    result = api_call("host.create", params, auth_token)
    if result and "result" in result:
        print(f"SUCCESS: Host created with ID {result['result']['hostids'][0]}")
        return True
    else:
        print(f"FAILED: {result}")
        return False


def main():
    print("Waiting for Zabbix server to be ready...")
    time.sleep(5)

    print("Getting auth token...")
    auth_token = get_auth_token()
    if not auth_token:
        sys.exit(1)
    print("Authenticated successfully.")

    # Cleanup: remove previously created host if exists
    print("Cleaning up previously created host 'zabbix-server'...")
    remove_host_if_exists(auth_token, "zabbix-server")
    
    print("\nUpdating built-in 'Zabbix server' host...")
    if update_zabbix_server_host(auth_token):
        print("\nHost configured! Check Zabbix UI at http://localhost:8086")
        print("Host availability should show: 1 Available, 0 Not available")
    else:
        print("\nHost configuration failed.")
        sys.exit(1)


if __name__ == "__main__":
    main()
