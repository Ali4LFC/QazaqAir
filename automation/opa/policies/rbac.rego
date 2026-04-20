package qazaqair.rbac

default allow = false

# User roles
roles := {
    "admin": ["read", "write", "delete", "deploy", "monitor"],
    "developer": ["read", "write", "deploy"],
    "operator": ["read", "monitor"],
    "viewer": ["read"]
}

# Resource permissions
resources := {
    "api": ["read", "write", "delete"],
    "database": ["read", "write", "backup"],
    "monitoring": ["read", "monitor"],
    "infrastructure": ["deploy", "monitor"],
    "logs": ["read"],
    "config": ["read", "write"]
}

# Check if user has required permission
has_permission(user, resource, permission) {
    user_roles := data.users[user].roles
    role := user_roles[_]
    allowed_permissions := roles[role]
    permission == allowed_permissions[_]
}

# Check if resource allows permission
resource_allows(resource, permission) {
    allowed_permissions := resources[resource]
    permission == allowed_permissions[_]
}

# Main allow rule
allow {
    input.method == "GET"
    has_permission(input.user, input.resource, "read")
}

allow {
    input.method == "POST"
    has_permission(input.user, input.resource, "write")
}

allow {
    input.method == "PUT"
    has_permission(input.user, input.resource, "write")
}

allow {
    input.method == "DELETE"
    has_permission(input.user, input.resource, "delete")
}

allow {
    input.action == "deploy"
    has_permission(input.user, input.resource, "deploy")
}

allow {
    input.action == "monitor"
    has_permission(input.user, input.resource, "monitor")
}

allow {
    input.action == "backup"
    has_permission(input.user, input.resource, "backup")
}
