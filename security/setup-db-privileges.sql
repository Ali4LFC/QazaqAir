-- QazaqAir Database Privileges Setup
-- Run this script to create proper users and permissions

-- Create application user
CREATE USER qazaqair_app WITH PASSWORD 'secure_app_password_2024';

-- Create readonly user for monitoring
CREATE USER qazaqair_readonly WITH PASSWORD 'readonly_password_2024';

-- Create backup user
CREATE USER qazaqair_backup WITH PASSWORD 'backup_password_2024';

-- Create monitoring user for Zabbix
CREATE USER zabbix_monitor WITH PASSWORD 'zabbix_monitor_2024';

-- Grant privileges to application user
GRANT CONNECT ON DATABASE airmonitor TO qazaqair_app;
GRANT USAGE ON SCHEMA public TO qazaqair_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO qazaqair_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO qazaqair_app;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO qazaqair_app;

-- Grant read-only privileges
GRANT CONNECT ON DATABASE airmonitor TO qazaqair_readonly;
GRANT USAGE ON SCHEMA public TO qazaqair_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO qazaqair_readonly;

-- Grant backup privileges
GRANT CONNECT ON DATABASE airmonitor TO qazaqair_backup;
GRANT USAGE ON SCHEMA public TO qazaqair_backup;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO qazaqair_backup;

-- Grant monitoring privileges
GRANT CONNECT ON DATABASE airmonitor TO zabbix_monitor;
GRANT USAGE ON SCHEMA public TO zabbix_monitor;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO zabbix_monitor;
GRANT SELECT ON pg_stat_database TO zabbix_monitor;
GRANT SELECT ON pg_stat_user_tables TO zabbix_monitor;

-- Ensure default privileges for future objects
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO qazaqair_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO qazaqair_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO qazaqair_readonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO qazaqair_backup;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO zabbix_monitor;

-- Create monitoring views for better security
CREATE OR REPLACE VIEW monitoring.table_stats AS
SELECT 
    schemaname,
    tablename,
    n_tup_ins as inserts,
    n_tup_upd as updates,
    n_tup_del as deletes,
    n_live_tup as live_tuples,
    n_dead_tup as dead_tuples
FROM pg_stat_user_tables;

GRANT SELECT ON monitoring.table_stats TO zabbix_monitor;

-- Create view for database connections
CREATE OR REPLACE VIEW monitoring.connection_stats AS
SELECT 
    datname as database_name,
    numbackends as active_connections,
    xact_commit as transactions_committed,
    xact_rollback as transactions_rolled_back,
    blks_read as blocks_read,
    blks_hit as blocks_hit,
    tup_returned as tuples_returned,
    tup_fetched as tuples_fetched,
    tup_inserted as tuples_inserted,
    tup_updated as tuples_updated,
    tup_deleted as tuples_deleted
FROM pg_stat_database;

GRANT SELECT ON monitoring.connection_stats TO zabbix_monitor;

-- Revoke unnecessary privileges from public
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO PUBLIC;

-- Create audit log table (optional)
CREATE TABLE IF NOT EXISTS audit.audit_log (
    id SERIAL PRIMARY KEY,
    table_name VARCHAR(255),
    operation VARCHAR(10),
    user_name VARCHAR(255),
    old_values JSONB,
    new_values JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

GRANT SELECT, INSERT ON audit.audit_log TO qazaqair_app;

COMMIT;
