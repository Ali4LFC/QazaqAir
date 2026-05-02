--
-- PostgreSQL database dump
--

\restrict BwGhL9GqEAeZQH08kqxl96u6saaTb8IUwFHFVd63jfDXVL5lnP2VizxDGnibCHw

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.9 (Debian 17.9-0+deb13u1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


ALTER TYPE auth.oauth_authorization_status OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


ALTER TYPE auth.oauth_client_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


ALTER TYPE auth.oauth_response_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


ALTER TYPE storage.buckettype OWNER TO supabase_storage_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: graphql(text, text, jsonb, jsonb); Type: FUNCTION; Schema: graphql_public; Owner: supabase_admin
--

CREATE FUNCTION graphql_public.graphql("operationName" text DEFAULT NULL::text, query text DEFAULT NULL::text, variables jsonb DEFAULT NULL::jsonb, extensions jsonb DEFAULT NULL::jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;


ALTER FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) OWNER TO supabase_admin;

--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: rls_auto_enable(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rls_auto_enable() RETURNS event_trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'pg_catalog'
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN
    SELECT *
    FROM pg_event_trigger_ddl_commands()
    WHERE command_tag IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
      AND object_type IN ('table','partitioned table')
  LOOP
     IF cmd.schema_name IS NOT NULL AND cmd.schema_name IN ('public') AND cmd.schema_name NOT IN ('pg_catalog','information_schema') AND cmd.schema_name NOT LIKE 'pg_toast%' AND cmd.schema_name NOT LIKE 'pg_temp%' THEN
      BEGIN
        EXECUTE format('alter table if exists %s enable row level security', cmd.object_identity);
        RAISE LOG 'rls_auto_enable: enabled RLS on %', cmd.object_identity;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE LOG 'rls_auto_enable: failed to enable RLS on %', cmd.object_identity;
      END;
     ELSE
        RAISE LOG 'rls_auto_enable: skip % (either system schema or not in enforced list: %.)', cmd.object_identity, cmd.schema_name;
     END IF;
  END LOOP;
END;
$$;


ALTER FUNCTION public.rls_auto_enable() OWNER TO postgres;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_
        -- Filter by action early - only get subscriptions interested in this action
        -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
        and (subs.action_filter = '*' or subs.action_filter = action::text);

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS TABLE(wal jsonb, is_rls_enabled boolean, subscription_ids uuid[], errors text[], slot_changes_count bigint)
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
  WITH pub AS (
    SELECT
      concat_ws(
        ',',
        CASE WHEN bool_or(pubinsert) THEN 'insert' ELSE NULL END,
        CASE WHEN bool_or(pubupdate) THEN 'update' ELSE NULL END,
        CASE WHEN bool_or(pubdelete) THEN 'delete' ELSE NULL END
      ) AS w2j_actions,
      coalesce(
        string_agg(
          realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
          ','
        ) filter (WHERE ppt.tablename IS NOT NULL AND ppt.tablename NOT LIKE '% %'),
        ''
      ) AS w2j_add_tables
    FROM pg_publication pp
    LEFT JOIN pg_publication_tables ppt ON pp.pubname = ppt.pubname
    WHERE pp.pubname = publication
    GROUP BY pp.pubname
    LIMIT 1
  ),
  -- MATERIALIZED ensures pg_logical_slot_get_changes is called exactly once
  w2j AS MATERIALIZED (
    SELECT x.*, pub.w2j_add_tables
    FROM pub,
         pg_logical_slot_get_changes(
           slot_name, null, max_changes,
           'include-pk', 'true',
           'include-transaction', 'false',
           'include-timestamp', 'true',
           'include-type-oids', 'true',
           'format-version', '2',
           'actions', pub.w2j_actions,
           'add-tables', pub.w2j_add_tables
         ) x
  ),
  -- Count raw slot entries before apply_rls/subscription filter
  slot_count AS (
    SELECT count(*)::bigint AS cnt
    FROM w2j
    WHERE w2j.w2j_add_tables <> ''
  ),
  -- Apply RLS and filter as before
  rls_filtered AS (
    SELECT xyz.wal, xyz.is_rls_enabled, xyz.subscription_ids, xyz.errors
    FROM w2j,
         realtime.apply_rls(
           wal := w2j.data::jsonb,
           max_record_bytes := max_record_bytes
         ) xyz(wal, is_rls_enabled, subscription_ids, errors)
    WHERE w2j.w2j_add_tables <> ''
      AND xyz.subscription_ids[1] IS NOT NULL
  )
  -- Real rows with slot count attached
  SELECT rf.wal, rf.is_rls_enabled, rf.subscription_ids, rf.errors, sc.cnt
  FROM rls_filtered rf, slot_count sc

  UNION ALL

  -- Sentinel row: always returned when no real rows exist so Elixir can
  -- always read slot_changes_count. Identified by wal IS NULL.
  SELECT null, null, null, null, sc.cnt
  FROM slot_count sc
  WHERE NOT EXISTS (SELECT 1 FROM rls_filtered)
$$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: allow_any_operation(text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_any_operation(expected_operations text[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT CASE
      WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
      ELSE raw_operation
    END AS current_operation
    FROM current_operation
  )
  SELECT EXISTS (
    SELECT 1
    FROM normalized n
    CROSS JOIN LATERAL unnest(expected_operations) AS expected_operation
    WHERE expected_operation IS NOT NULL
      AND expected_operation <> ''
      AND n.current_operation = CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END
  );
$$;


ALTER FUNCTION storage.allow_any_operation(expected_operations text[]) OWNER TO supabase_storage_admin;

--
-- Name: allow_only_operation(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_only_operation(expected_operation text) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT
      CASE
        WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
        ELSE raw_operation
      END AS current_operation,
      CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END AS requested_operation
    FROM current_operation
  )
  SELECT CASE
    WHEN requested_operation IS NULL OR requested_operation = '' THEN FALSE
    ELSE COALESCE(current_operation = requested_operation, FALSE)
  END
  FROM normalized;
$$;


ALTER FUNCTION storage.allow_only_operation(expected_operation text) OWNER TO supabase_storage_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


ALTER FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text) OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.protect_delete() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


ALTER FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


ALTER TABLE auth.custom_oauth_providers OWNER TO supabase_auth_admin;

--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


ALTER TABLE auth.oauth_authorizations OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE auth.oauth_client_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


ALTER TABLE auth.oauth_consents OWNER TO supabase_auth_admin;

--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: webauthn_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    challenge_type text NOT NULL,
    session_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    CONSTRAINT webauthn_challenges_challenge_type_check CHECK ((challenge_type = ANY (ARRAY['signup'::text, 'registration'::text, 'authentication'::text])))
);


ALTER TABLE auth.webauthn_challenges OWNER TO supabase_auth_admin;

--
-- Name: webauthn_credentials; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_credentials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    credential_id bytea NOT NULL,
    public_key bytea NOT NULL,
    attestation_type text DEFAULT ''::text NOT NULL,
    aaguid uuid,
    sign_count bigint DEFAULT 0 NOT NULL,
    transports jsonb DEFAULT '[]'::jsonb NOT NULL,
    backup_eligible boolean DEFAULT false NOT NULL,
    backed_up boolean DEFAULT false NOT NULL,
    friendly_name text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone
);


ALTER TABLE auth.webauthn_credentials OWNER TO supabase_auth_admin;

--
-- Name: aqi_hourly; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aqi_hourly (
    id integer NOT NULL,
    region_key character varying(64) NOT NULL,
    city character varying(128) NOT NULL,
    ts_hour timestamp with time zone NOT NULL,
    aqi integer,
    temp_c double precision,
    humidity_pct integer,
    wind_ms double precision
);


ALTER TABLE public.aqi_hourly OWNER TO postgres;

--
-- Name: aqi_hourly_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.aqi_hourly_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.aqi_hourly_id_seq OWNER TO postgres;

--
-- Name: aqi_hourly_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.aqi_hourly_id_seq OWNED BY public.aqi_hourly.id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.regions (
    id integer NOT NULL,
    key character varying(64) NOT NULL,
    name character varying(128) NOT NULL,
    name_kk character varying(128),
    city character varying(128),
    coords_lat double precision,
    coords_lon double precision,
    country character varying(50) DEFAULT 'Kazakhstan'::character varying
);


ALTER TABLE public.regions OWNER TO postgres;

--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.regions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.regions_id_seq OWNER TO postgres;

--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.regions_id_seq OWNED BY public.regions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    hashed_password character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    city_key character varying(64),
    is_active boolean,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE storage.buckets_analytics OWNER TO supabase_storage_admin;

--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.buckets_vectors OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb,
    metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.vector_indexes OWNER TO supabase_storage_admin;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: aqi_hourly id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aqi_hourly ALTER COLUMN id SET DEFAULT nextval('public.aqi_hourly_id_seq'::regclass);


--
-- Name: regions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions ALTER COLUMN id SET DEFAULT nextval('public.regions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.custom_oauth_providers (id, provider_type, identifier, name, client_id, client_secret, acceptable_client_ids, scopes, pkce_enabled, attribute_mapping, authorization_params, enabled, email_optional, issuer, discovery_url, skip_nonce_check, cached_discovery, discovery_cached_at, authorization_url, token_url, userinfo_url, jwks_uri, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
20260219120000
20260302000000
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
\.


--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.webauthn_challenges (id, user_id, challenge_type, session_data, created_at, expires_at) FROM stdin;
\.


--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.webauthn_credentials (id, user_id, credential_id, public_key, attestation_type, aaguid, sign_count, transports, backup_eligible, backed_up, friendly_name, created_at, updated_at, last_used_at) FROM stdin;
\.


--
-- Data for Name: aqi_hourly; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aqi_hourly (id, region_key, city, ts_hour, aqi, temp_c, humidity_pct, wind_ms) FROM stdin;
1	astana	Astana	2026-03-03 11:00:00+00	7	-5	92	5.6
2	almaty_city	Almaty	2026-03-03 11:00:00+00	3	2	93	2
3	shymkent	Шымкент	2026-03-03 11:00:00+00	10	11.5	77	1
4	akmola	Акмолинская область	2026-03-03 11:00:00+00	7	-5	92	5.6
5	aktobe	Актюбинская область	2026-03-03 11:00:00+00	7	-5	92	5.6
6	almaty_obl	Алматинская область	2026-03-03 11:00:00+00	3	2	93	2
7	atyrau	Атырауская область	2026-03-03 11:00:00+00	56	4	75	3
8	east_kz	Восточно-Казахстанская область	2026-03-03 11:00:00+00	47	-4	76	2
9	zhambyl	Жамбылская область	2026-03-03 11:00:00+00	10	11.5	77	1
10	west_kz	Западно-Казахстанская область	2026-03-03 11:00:00+00	18	10.5	48	8.4
11	karaganda	Карагандинская область	2026-03-03 11:00:00+00	7	-5	92	5.6
12	kostanay	Костанайская область	2026-03-03 11:00:00+00	7	-5	92	5.6
13	kyzylorda	Кызылординская область	2026-03-03 11:00:00+00	10	11.5	77	1
14	mangystau	Мангистауская область	2026-03-03 11:00:00+00	56	4	75	3
15	north_kz	Северо-Казахстанская область	2026-03-03 11:00:00+00	7	-5	92	5.6
16	pavlodar	Павлодарская область	2026-03-03 11:00:00+00	7	-5	92	5.6
17	turkistan	Туркестанская область	2026-03-03 11:00:00+00	10	11.5	77	1
18	abay	Абайская область	2026-03-03 11:00:00+00	47	-4	76	2
19	ulytau	Улытауская область	2026-03-03 11:00:00+00	7	-5	92	5.6
20	jetisu	Жетысуская область	2026-03-03 11:00:00+00	3	2	93	2
101	astana	Astana	2026-03-02 22:00:00+00	7	-5	92	5.6
102	almaty_city	Almaty	2026-03-02 22:00:00+00	3	2	93	2
103	shymkent	Шымкент	2026-03-02 22:00:00+00	10	11.5	77	1
104	akmola	Акмолинская область	2026-03-02 22:00:00+00	7	-5	92	5.6
105	aktobe	Актюбинская область	2026-03-02 22:00:00+00	7	-5	92	5.6
106	almaty_obl	Алматинская область	2026-03-02 22:00:00+00	3	2	93	2
107	atyrau	Атырауская область	2026-03-02 22:00:00+00	56	4	75	3
108	east_kz	Восточно-Казахстанская область	2026-03-02 22:00:00+00	46	-4	76	2
109	zhambyl	Жамбылская область	2026-03-02 22:00:00+00	10	11.5	77	1
110	west_kz	Западно-Казахстанская область	2026-03-02 22:00:00+00	17	12	42	5.1
111	karaganda	Карагандинская область	2026-03-02 22:00:00+00	7	-5	92	5.6
112	kostanay	Костанайская область	2026-03-02 22:00:00+00	7	-5	92	5.6
113	kyzylorda	Кызылординская область	2026-03-02 22:00:00+00	10	11.5	77	1
114	mangystau	Мангистауская область	2026-03-02 22:00:00+00	56	4	75	3
115	north_kz	Северо-Казахстанская область	2026-03-02 22:00:00+00	7	-5	92	5.6
116	pavlodar	Павлодарская область	2026-03-02 22:00:00+00	7	-5	92	5.6
117	turkistan	Туркестанская область	2026-03-02 22:00:00+00	10	11.5	77	1
118	abay	Абайская область	2026-03-02 22:00:00+00	46	-4	76	2
119	ulytau	Улытауская область	2026-03-02 22:00:00+00	7	-5	92	5.6
120	jetisu	Жетысуская область	2026-03-02 22:00:00+00	3	2	93	2
161	astana	Астана	2026-03-03 12:00:00+00	7	-5	92	5.6
162	almaty_city	Алматы	2026-03-03 12:00:00+00	3	2	93	2
163	shymkent	Шымкент	2026-03-03 12:00:00+00	10	11.5	77	1
164	akmola	Акмолинская область	2026-03-03 12:00:00+00	7	-5	92	5.6
165	aktobe	Актюбинская область	2026-03-03 12:00:00+00	7	-5	92	5.6
166	almaty_obl	Алматинская область	2026-03-03 12:00:00+00	3	2	93	2
167	atyrau	Атырауская область	2026-03-03 12:00:00+00	56	4	75	3
168	east_kz	Восточно-Казахстанская область	2026-03-03 12:00:00+00	46	-4	76	2
169	zhambyl	Жамбылская область	2026-03-03 12:00:00+00	10	11.5	77	1
170	west_kz	Западно-Казахстанская область	2026-03-03 12:00:00+00	17	12	42	5.1
171	karaganda	Карагандинская область	2026-03-03 12:00:00+00	7	-5	92	5.6
172	kostanay	Костанайская область	2026-03-03 12:00:00+00	7	-5	92	5.6
173	kyzylorda	Кызылординская область	2026-03-03 12:00:00+00	10	11.5	77	1
174	mangystau	Мангистауская область	2026-03-03 12:00:00+00	56	4	75	3
175	north_kz	Северо-Казахстанская область	2026-03-03 12:00:00+00	7	-5	92	5.6
176	pavlodar	Павлодарская область	2026-03-03 12:00:00+00	7	-5	92	5.6
177	turkistan	Туркестанская область	2026-03-03 12:00:00+00	10	11.5	77	1
178	abay	Абайская область	2026-03-03 12:00:00+00	46	-4	76	2
179	ulytau	Улытауская область	2026-03-03 12:00:00+00	7	-5	92	5.6
180	jetisu	Жетысуская область	2026-03-03 12:00:00+00	3	2	93	2
201	astana	Astana	2026-03-02 23:00:00+00	7	-5	92	5.6
202	almaty_city	Almaty	2026-03-02 23:00:00+00	3	2	93	2
203	shymkent	Шымкент	2026-03-02 23:00:00+00	10	11.5	77	1
204	akmola	Акмолинская область	2026-03-02 23:00:00+00	7	-5	92	5.6
205	aktobe	Актюбинская область	2026-03-02 23:00:00+00	7	-5	92	5.6
206	almaty_obl	Алматинская область	2026-03-02 23:00:00+00	3	2	93	2
207	atyrau	Атырауская область	2026-03-02 23:00:00+00	17	12	42	5.1
208	east_kz	Восточно-Казахстанская область	2026-03-02 23:00:00+00	46	-4	76	2
209	zhambyl	Жамбылская область	2026-03-02 23:00:00+00	10	11.5	77	1
210	west_kz	Западно-Казахстанская область	2026-03-02 23:00:00+00	17	12	42	5.1
211	karaganda	Карагандинская область	2026-03-02 23:00:00+00	7	-5	92	5.6
212	kostanay	Костанайская область	2026-03-02 23:00:00+00	7	-5	92	5.6
213	kyzylorda	Кызылординская область	2026-03-02 23:00:00+00	10	11.5	77	1
214	mangystau	Мангистауская область	2026-03-02 23:00:00+00	17	12	42	5.1
215	north_kz	Северо-Казахстанская область	2026-03-02 23:00:00+00	7	-5	92	5.6
216	pavlodar	Павлодарская область	2026-03-02 23:00:00+00	7	-5	92	5.6
217	turkistan	Туркестанская область	2026-03-02 23:00:00+00	10	11.5	77	1
218	abay	Абайская область	2026-03-02 23:00:00+00	46	-4	76	2
219	ulytau	Улытауская область	2026-03-02 23:00:00+00	7	-5	92	5.6
220	jetisu	Жетысуская область	2026-03-02 23:00:00+00	3	2	93	2
241	astana	Астана	2026-03-03 17:00:00+00	7	-5	92	5.6
242	almaty_city	Алматы	2026-03-03 17:00:00+00	3	2	93	2
243	shymkent	Шымкент	2026-03-03 17:00:00+00	10	11.5	77	1
244	akmola	Акмолинская область	2026-03-03 17:00:00+00	7	-5	92	5.6
245	aktobe	Актюбинская область	2026-03-03 17:00:00+00	7	-5	92	5.6
246	almaty_obl	Алматинская область	2026-03-03 17:00:00+00	3	2	93	2
247	atyrau	Атырауская область	2026-03-03 17:00:00+00	17	12	42	5.1
248	east_kz	Восточно-Казахстанская область	2026-03-03 17:00:00+00	46	-4	76	2
249	zhambyl	Жамбылская область	2026-03-03 17:00:00+00	10	11.5	77	1
250	west_kz	Западно-Казахстанская область	2026-03-03 17:00:00+00	17	12	42	5.1
251	karaganda	Карагандинская область	2026-03-03 17:00:00+00	7	-5	92	5.6
252	kostanay	Костанайская область	2026-03-03 17:00:00+00	7	-5	92	5.6
253	kyzylorda	Кызылординская область	2026-03-03 17:00:00+00	10	11.5	77	1
254	mangystau	Мангистауская область	2026-03-03 17:00:00+00	17	12	42	5.1
255	north_kz	Северо-Казахстанская область	2026-03-03 17:00:00+00	7	-5	92	5.6
256	pavlodar	Павлодарская область	2026-03-03 17:00:00+00	7	-5	92	5.6
257	turkistan	Туркестанская область	2026-03-03 17:00:00+00	10	11.5	77	1
258	abay	Абайская область	2026-03-03 17:00:00+00	46	-4	76	2
259	ulytau	Улытауская область	2026-03-03 17:00:00+00	7	-5	92	5.6
260	jetisu	Жетысуская область	2026-03-03 17:00:00+00	3	2	93	2
261	astana	Астана	2026-03-03 17:11:57+00	7	-5	92	5.6
262	almaty_city	Алматы	2026-03-03 17:11:57+00	3	2	93	2
263	shymkent	Шымкент	2026-03-03 17:11:57+00	11	11.5	77	1
264	akmola	Акмолинская область	2026-03-03 17:11:57+00	7	-5	92	5.6
265	aktobe	Актюбинская область	2026-03-03 17:11:57+00	7	-5	92	5.6
266	almaty_obl	Алматинская область	2026-03-03 17:11:57+00	3	2	93	2
267	atyrau	Атырауская область	2026-03-03 17:11:57+00	17	12	42	5.1
268	east_kz	Восточно-Казахстанская область	2026-03-03 17:11:57+00	46	-4	76	2
269	zhambyl	Жамбылская область	2026-03-03 17:11:57+00	11	11.5	77	1
270	west_kz	Западно-Казахстанская область	2026-03-03 17:11:57+00	17	12	42	5.1
271	karaganda	Карагандинская область	2026-03-03 17:11:57+00	7	-5	92	5.6
272	kostanay	Костанайская область	2026-03-03 17:11:57+00	7	-5	92	5.6
273	kyzylorda	Кызылординская область	2026-03-03 17:11:57+00	11	11.5	77	1
274	mangystau	Мангистауская область	2026-03-03 17:11:57+00	17	12	42	5.1
275	north_kz	Северо-Казахстанская область	2026-03-03 17:11:57+00	7	-5	92	5.6
276	pavlodar	Павлодарская область	2026-03-03 17:11:57+00	7	-5	92	5.6
277	turkistan	Туркестанская область	2026-03-03 17:11:57+00	11	11.5	77	1
278	abay	Абайская область	2026-03-03 17:11:57+00	46	-4	76	2
279	ulytau	Улытауская область	2026-03-03 17:11:57+00	7	-5	92	5.6
280	jetisu	Жетысуская область	2026-03-03 17:11:57+00	3	2	93	2
281	astana	Астана	2026-03-03 17:14:46+00	7	-5	92	5.6
282	almaty_city	Алматы	2026-03-03 17:14:46+00	3	1	100	2.5
283	shymkent	Шымкент	2026-03-03 17:14:46+00	11	11.5	77	1
284	akmola	Акмолинская область	2026-03-03 17:14:46+00	7	-5	92	5.6
285	aktobe	Актюбинская область	2026-03-03 17:14:46+00	7	-5	92	5.6
286	almaty_obl	Алматинская область	2026-03-03 17:14:46+00	3	1	100	2.5
287	atyrau	Атырауская область	2026-03-03 17:14:46+00	17	12	42	5.1
288	east_kz	Восточно-Казахстанская область	2026-03-03 17:14:46+00	46	-4	76	2
289	zhambyl	Жамбылская область	2026-03-03 17:14:46+00	11	11.5	77	1
290	west_kz	Западно-Казахстанская область	2026-03-03 17:14:46+00	17	12	42	5.1
291	karaganda	Карагандинская область	2026-03-03 17:14:46+00	7	-5	92	5.6
292	kostanay	Костанайская область	2026-03-03 17:14:46+00	7	-5	92	5.6
293	kyzylorda	Кызылординская область	2026-03-03 17:14:46+00	11	11.5	77	1
294	mangystau	Мангистауская область	2026-03-03 17:14:46+00	17	12	42	5.1
362	almaty_city	Almaty	2026-03-03 19:30:17+00	2	1	93	1.5
295	north_kz	Северо-Казахстанская область	2026-03-03 17:14:46+00	7	-5	92	5.6
296	pavlodar	Павлодарская область	2026-03-03 17:14:46+00	7	-5	92	5.6
297	turkistan	Туркестанская область	2026-03-03 17:14:46+00	11	11.5	77	1
298	abay	Абайская область	2026-03-03 17:14:46+00	46	-4	76	2
299	ulytau	Улытауская область	2026-03-03 17:14:46+00	7	-5	92	5.6
300	jetisu	Жетысуская область	2026-03-03 17:14:46+00	3	1	100	2.5
301	astana	Астана	2026-03-03 17:17:47+00	7	-5	92	5.6
302	almaty_city	Алматы	2026-03-03 17:17:47+00	3	1	100	2.5
303	shymkent	Шымкент	2026-03-03 17:17:47+00	11	11.5	77	1
304	akmola	Акмолинская область	2026-03-03 17:17:47+00	7	-5	92	5.6
305	aktobe	Актюбинская область	2026-03-03 17:17:47+00	7	-5	92	5.6
306	almaty_obl	Алматинская область	2026-03-03 17:17:47+00	3	1	100	2.5
307	atyrau	Атырауская область	2026-03-03 17:17:47+00	17	12	42	5.1
308	east_kz	Восточно-Казахстанская область	2026-03-03 17:17:47+00	46	-4	76	2
309	zhambyl	Жамбылская область	2026-03-03 17:17:47+00	11	11.5	77	1
310	west_kz	Западно-Казахстанская область	2026-03-03 17:17:47+00	17	12	42	5.1
311	karaganda	Карагандинская область	2026-03-03 17:17:47+00	7	-5	92	5.6
312	kostanay	Костанайская область	2026-03-03 17:17:47+00	7	-5	92	5.6
313	kyzylorda	Кызылординская область	2026-03-03 17:17:47+00	11	11.5	77	1
314	mangystau	Мангистауская область	2026-03-03 17:17:47+00	17	12	42	5.1
315	north_kz	Северо-Казахстанская область	2026-03-03 17:17:47+00	7	-5	92	5.6
316	pavlodar	Павлодарская область	2026-03-03 17:17:47+00	7	-5	92	5.6
317	turkistan	Туркестанская область	2026-03-03 17:17:47+00	11	11.5	77	1
318	abay	Абайская область	2026-03-03 17:17:47+00	46	-4	76	2
319	ulytau	Улытауская область	2026-03-03 17:17:47+00	7	-5	92	5.6
320	jetisu	Жетысуская область	2026-03-03 17:17:47+00	3	1	100	2.5
321	astana	Астана	2026-03-03 17:24:05+00	7	-5	92	5.6
322	almaty_city	Алматы	2026-03-03 17:24:05+00	3	1	100	2.5
323	shymkent	Шымкент	2026-03-03 17:24:05+00	11	11.5	77	1
324	akmola	Акмолинская область	2026-03-03 17:24:05+00	7	-5	92	5.6
325	aktobe	Актюбинская область	2026-03-03 17:24:05+00	7	-5	92	5.6
326	almaty_obl	Алматинская область	2026-03-03 17:24:05+00	3	1	100	2.5
327	atyrau	Атырауская область	2026-03-03 17:24:05+00	17	12	42	5.1
328	east_kz	Восточно-Казахстанская область	2026-03-03 17:24:05+00	46	-4	76	2
329	zhambyl	Жамбылская область	2026-03-03 17:24:05+00	11	11.5	77	1
330	west_kz	Западно-Казахстанская область	2026-03-03 17:24:05+00	17	12	42	5.1
331	karaganda	Карагандинская область	2026-03-03 17:24:05+00	7	-5	92	5.6
332	kostanay	Костанайская область	2026-03-03 17:24:05+00	7	-5	92	5.6
333	kyzylorda	Кызылординская область	2026-03-03 17:24:05+00	11	11.5	77	1
334	mangystau	Мангистауская область	2026-03-03 17:24:05+00	17	12	42	5.1
335	north_kz	Северо-Казахстанская область	2026-03-03 17:24:05+00	7	-5	92	5.6
336	pavlodar	Павлодарская область	2026-03-03 17:24:05+00	7	-5	92	5.6
337	turkistan	Туркестанская область	2026-03-03 17:24:05+00	11	11.5	77	1
338	abay	Абайская область	2026-03-03 17:24:05+00	46	-4	76	2
339	ulytau	Улытауская область	2026-03-03 17:24:05+00	7	-5	92	5.6
340	jetisu	Жетысуская область	2026-03-03 17:24:05+00	3	1	100	2.5
341	astana	Астана	2026-03-03 17:48:21+00	7	-5	92	5.6
342	almaty_city	Алматы	2026-03-03 17:48:21+00	3	1	100	2.5
343	shymkent	Шымкент	2026-03-03 17:48:21+00	11	11.5	77	1
344	akmola	Акмолинская область	2026-03-03 17:48:21+00	7	-5	92	5.6
345	aktobe	Актюбинская область	2026-03-03 17:48:21+00	7	-5	92	5.6
346	almaty_obl	Алматинская область	2026-03-03 17:48:21+00	3	1	100	2.5
347	atyrau	Атырауская область	2026-03-03 17:48:21+00	16	12	40	6.6
348	east_kz	Восточно-Казахстанская область	2026-03-03 17:48:21+00	59	-4.8	78	1
349	zhambyl	Жамбылская область	2026-03-03 17:48:21+00	11	11.5	77	1
350	west_kz	Западно-Казахстанская область	2026-03-03 17:48:21+00	16	12	40	6.6
351	karaganda	Карагандинская область	2026-03-03 17:48:21+00	7	-5	92	5.6
352	kostanay	Костанайская область	2026-03-03 17:48:21+00	7	-5	92	5.6
353	kyzylorda	Кызылординская область	2026-03-03 17:48:21+00	11	11.5	77	1
354	mangystau	Мангистауская область	2026-03-03 17:48:21+00	16	12	40	6.6
355	north_kz	Северо-Казахстанская область	2026-03-03 17:48:21+00	7	-5	92	5.6
356	pavlodar	Павлодарская область	2026-03-03 17:48:21+00	7	-5	92	5.6
357	turkistan	Туркестанская область	2026-03-03 17:48:21+00	11	11.5	77	1
358	abay	Абайская область	2026-03-03 17:48:21+00	59	-4.8	78	1
359	ulytau	Улытауская область	2026-03-03 17:48:21+00	7	-5	92	5.6
360	jetisu	Жетысуская область	2026-03-03 17:48:21+00	3	1	100	2.5
361	astana	Астана	2026-03-03 19:30:17+00	7	-5	92	5.1
363	aktobe	Ақтөбе облысы	2026-03-03 19:30:17+00	7	-5	92	5.1
364	almaty_obl	Алматы облысы	2026-03-03 19:30:17+00	2	1	93	1.5
365	atyrau	Атырау облысы	2026-03-03 19:30:17+00	72	12	42	5.6
366	east_kz	Шығыс Қазақстан облысы	2026-03-03 19:30:17+00	80	-4.8	78	1
367	zhambyl	Жамбыл облысы	2026-03-03 19:30:17+00	8	11.2	79	1
368	west_kz	Батыс Қазақстан облысы	2026-03-03 19:30:17+00	16	12	42	5.6
369	karaganda	Қарағанды облысы	2026-03-03 19:30:17+00	7	-5	92	5.1
370	kostanay	Қостанай облысы	2026-03-03 19:30:17+00	7	-5	92	5.1
371	kyzylorda	Қызылорда облысы	2026-03-03 19:30:17+00	8	11.2	79	1
372	mangystau	Маңғыстау облысы	2026-03-03 19:30:17+00	72	12	42	5.6
373	north_kz	Солтүстік Қазақстан облысы	2026-03-03 19:30:17+00	7	-5	92	5.1
374	pavlodar	Павлодар облысы	2026-03-03 19:30:17+00	7	-5	92	5.1
375	turkistan	Түркістан облысы	2026-03-03 19:30:17+00	8	11.2	79	1
376	abay	Абай облысы	2026-03-03 19:30:17+00	80	-4.8	78	1
377	ulytau	Ұлытау облысы	2026-03-03 19:30:17+00	7	-5	92	5.1
378	jetisu	Жетісу облысы	2026-03-03 19:30:17+00	2	1	93	1.5
379	astana	Астана	2026-03-03 19:34:08+00	7	-5	92	5.1
380	almaty_city	Almaty	2026-03-03 19:34:08+00	2	1	93	1.5
381	astana	Астана	2026-03-03 19:56:09+00	7	-5	92	4.6
382	almaty_city	Алматы	2026-03-03 19:56:09+00	3	1	93	1.5
383	shymkent	Шымкент	2026-03-03 19:56:09+00	8	11.2	79	1
384	akmola	Ақмола облысы	2026-03-03 19:56:09+00	7	-5	92	4.6
385	aktobe	Ақтөбе облысы	2026-03-03 19:56:09+00	7	-5	92	4.6
386	almaty_obl	Алматы облысы	2026-03-03 19:56:09+00	3	1	93	1.5
387	atyrau	Атырау облысы	2026-03-03 19:56:09+00	72	12	42	5.6
388	east_kz	Шығыс Қазақстан облысы	2026-03-03 19:56:09+00	80	-4.8	78	1
389	zhambyl	Жамбыл облысы	2026-03-03 19:56:09+00	8	11.2	79	1
390	west_kz	Батыс Қазақстан облысы	2026-03-03 19:56:09+00	16	12	42	5.6
391	karaganda	Қарағанды облысы	2026-03-03 19:56:09+00	7	-5	92	4.6
392	kostanay	Қостанай облысы	2026-03-03 19:56:09+00	7	-5	92	4.6
393	kyzylorda	Қызылорда облысы	2026-03-03 19:56:09+00	8	11.2	79	1
394	mangystau	Маңғыстау облысы	2026-03-03 19:56:09+00	72	12	42	5.6
395	north_kz	Солтүстік Қазақстан облысы	2026-03-03 19:56:09+00	7	-5	92	4.6
396	pavlodar	Павлодар облысы	2026-03-03 19:56:09+00	7	-5	92	4.6
397	turkistan	Түркістан облысы	2026-03-03 19:56:09+00	8	11.2	79	1
398	abay	Абай облысы	2026-03-03 19:56:09+00	80	-4.8	78	1
399	ulytau	Ұлытау облысы	2026-03-03 19:56:09+00	7	-5	92	4.6
400	jetisu	Жетісу облысы	2026-03-03 19:56:09+00	3	1	93	1.5
401	astana	Astana	2026-03-03 20:00:00+00	7	-5	92	4.6
402	almaty_city	Almaty	2026-03-03 20:00:00+00	3	1	93	1.5
403	ulytau	Ұлытау облысы	2026-03-03 20:00:00+00	7	-5	92	4.6
404	jetisu	Жетісу облысы	2026-03-03 20:00:00+00	3	1	93	1.5
405	astana	Астана	2026-03-03 20:05:47+00	7	-5	92	4.6
406	almaty_city	Алматы	2026-03-03 20:05:47+00	3	1	93	1.5
407	shymkent	Шымкент	2026-03-03 20:05:47+00	8	11.2	79	1
408	akmola	Ақмола облысы	2026-03-03 20:05:47+00	7	-5	92	4.6
409	aktobe	Ақтөбе облысы	2026-03-03 20:05:47+00	7	-5	92	4.6
410	almaty_obl	Алматы облысы	2026-03-03 20:05:47+00	3	1	93	1.5
411	atyrau	Атырау облысы	2026-03-03 20:05:47+00	72	12	42	5.6
412	east_kz	Шығыс Қазақстан облысы	2026-03-03 20:05:47+00	80	-4.8	78	1
413	zhambyl	Жамбыл облысы	2026-03-03 20:05:47+00	8	11.2	79	1
414	west_kz	Батыс Қазақстан облысы	2026-03-03 20:05:47+00	16	12	42	5.6
415	karaganda	Қарағанды облысы	2026-03-03 20:05:47+00	7	-5	92	4.6
416	kostanay	Қостанай облысы	2026-03-03 20:05:47+00	7	-5	92	4.6
417	kyzylorda	Қызылорда облысы	2026-03-03 20:05:47+00	8	11.2	79	1
418	mangystau	Маңғыстау облысы	2026-03-03 20:05:47+00	72	12	42	5.6
419	north_kz	Солтүстік Қазақстан облысы	2026-03-03 20:05:47+00	7	-5	92	4.6
420	pavlodar	Павлодар облысы	2026-03-03 20:05:47+00	7	-5	92	4.6
421	turkistan	Түркістан облысы	2026-03-03 20:05:47+00	8	11.2	79	1
422	abay	Абай облысы	2026-03-03 20:05:47+00	80	-4.8	78	1
423	ulytau	Ұлытау облысы	2026-03-03 20:05:47+00	7	-5	92	4.6
424	jetisu	Жетісу облысы	2026-03-03 20:05:47+00	3	1	93	1.5
425	astana	Астана	2026-03-04 05:15:51+00	12	-11	92	2.5
426	almaty_city	Алматы	2026-03-04 05:15:51+00	4	0	100	1.5
427	shymkent	Шымкент	2026-03-04 05:15:51+00	4	8.7	89	1
428	akmola	Ақмола облысы	2026-03-04 05:15:51+00	12	-11	92	2.5
429	aktobe	Ақтөбе облысы	2026-03-04 05:15:51+00	12	-11	92	2.5
430	almaty_obl	Алматы облысы	2026-03-04 05:15:51+00	4	0	100	1.5
431	atyrau	Атырау облысы	2026-03-04 05:15:51+00	65	5	83	7.9
432	east_kz	Шығыс Қазақстан облысы	2026-03-04 05:15:51+00	32	-10.8	84	1
433	zhambyl	Жамбыл облысы	2026-03-04 05:15:51+00	4	8.7	89	1
434	west_kz	Батыс Қазақстан облысы	2026-03-04 05:15:51+00	19	5	83	7.9
435	karaganda	Қарағанды облысы	2026-03-04 05:15:51+00	12	-11	92	2.5
436	kostanay	Қостанай облысы	2026-03-04 05:15:51+00	12	-11	92	2.5
437	kyzylorda	Қызылорда облысы	2026-03-04 05:15:51+00	4	8.7	89	1
438	mangystau	Маңғыстау облысы	2026-03-04 05:15:51+00	65	5	83	7.9
439	north_kz	Солтүстік Қазақстан облысы	2026-03-04 05:15:51+00	12	-11	92	2.5
440	pavlodar	Павлодар облысы	2026-03-04 05:15:51+00	12	-11	92	2.5
441	turkistan	Түркістан облысы	2026-03-04 05:15:51+00	4	8.7	89	1
442	abay	Абай облысы	2026-03-04 05:15:51+00	32	-10.8	84	1
443	ulytau	Ұлытау облысы	2026-03-04 05:15:51+00	12	-11	92	2.5
444	jetisu	Жетісу облысы	2026-03-04 05:15:51+00	4	0	100	1.5
445	astana	Астана	2026-03-04 05:27:01+00	12	-11	92	2.5
446	almaty_city	Алматы	2026-03-04 05:27:01+00	4	0	100	1.5
447	shymkent	Шымкент	2026-03-04 05:27:01+00	4	8.7	89	1
448	akmola	Ақмола облысы	2026-03-04 05:27:01+00	12	-11	92	2.5
449	aktobe	Ақтөбе облысы	2026-03-04 05:27:01+00	12	-11	92	2.5
450	almaty_obl	Алматы облысы	2026-03-04 05:27:01+00	4	0	100	1.5
451	atyrau	Атырау облысы	2026-03-04 05:27:01+00	65	5	83	7.9
452	east_kz	Шығыс Қазақстан облысы	2026-03-04 05:27:01+00	32	-10.8	84	1
453	zhambyl	Жамбыл облысы	2026-03-04 05:27:01+00	4	8.7	89	1
454	west_kz	Батыс Қазақстан облысы	2026-03-04 05:27:01+00	19	5	83	7.9
455	karaganda	Қарағанды облысы	2026-03-04 05:27:01+00	12	-11	92	2.5
456	kostanay	Қостанай облысы	2026-03-04 05:27:01+00	12	-11	92	2.5
457	kyzylorda	Қызылорда облысы	2026-03-04 05:27:01+00	4	8.7	89	1
458	mangystau	Маңғыстау облысы	2026-03-04 05:27:01+00	65	5	83	7.9
459	north_kz	Солтүстік Қазақстан облысы	2026-03-04 05:27:01+00	12	-11	92	2.5
460	pavlodar	Павлодар облысы	2026-03-04 05:27:01+00	12	-11	92	2.5
461	turkistan	Түркістан облысы	2026-03-04 05:27:01+00	4	8.7	89	1
462	abay	Абай облысы	2026-03-04 05:27:01+00	32	-10.8	84	1
463	ulytau	Ұлытау облысы	2026-03-04 05:27:01+00	12	-11	92	2.5
464	jetisu	Жетісу облысы	2026-03-04 05:27:01+00	4	0	100	1.5
465	astana	Astana	2026-03-03 20:16:28+00	7	-13	84	3.6
466	almaty_city	Almaty	2026-03-03 20:16:28+00	3	1	100	2.5
467	astana	Astana	2026-03-03 20:58:30+00	7	-13	84	3.6
468	almaty_city	Almaty	2026-03-03 20:58:30+00	3	1	100	2.5
469	kostanay	Қостанай облысы	2026-03-03 20:58:30+00	7	-13	84	3.6
470	kyzylorda	Қызылорда облысы	2026-03-03 20:58:30+00	4	8.7	94	1
471	mangystau	Маңғыстау облысы	2026-03-03 20:58:30+00	51	5	75	7.2
472	north_kz	Солтүстік Қазақстан облысы	2026-03-03 20:58:30+00	7	-13	84	3.6
473	pavlodar	Павлодар облысы	2026-03-03 20:58:30+00	7	-13	84	3.6
474	turkistan	Түркістан облысы	2026-03-03 20:58:30+00	4	8.7	94	1
475	abay	Абай облысы	2026-03-03 20:58:30+00	50	-5.6	62	1
476	ulytau	Ұлытау облысы	2026-03-03 20:58:30+00	7	-13	84	3.6
477	jetisu	Жетісу облысы	2026-03-03 20:58:30+00	3	1	100	2.5
478	astana	Astana	2026-03-03 21:00:00+00	7	-13	84	3.6
479	almaty_city	Almaty	2026-03-03 21:00:00+00	3	1	100	2.5
480	astana	Астана	2026-03-04 10:12:58+00	7	-13	84	3.6
481	almaty_city	Алматы	2026-03-04 10:12:58+00	3	1	100	2.5
482	shymkent	Шымкент	2026-03-04 10:12:58+00	4	8.7	94	1
483	akmola	Ақмола облысы	2026-03-04 10:12:58+00	7	-13	84	3.6
484	aktobe	Ақтөбе облысы	2026-03-04 10:12:58+00	7	-13	84	3.6
485	almaty_obl	Алматы облысы	2026-03-04 10:12:58+00	3	1	100	2.5
486	atyrau	Атырау облысы	2026-03-04 10:12:58+00	51	5	75	7.2
487	east_kz	Шығыс Қазақстан облысы	2026-03-04 10:12:58+00	50	-5.6	62	1
488	zhambyl	Жамбыл облысы	2026-03-04 10:12:58+00	4	8.7	94	1
489	west_kz	Батыс Қазақстан облысы	2026-03-04 10:12:58+00	20	5	75	7.2
490	karaganda	Қарағанды облысы	2026-03-04 10:12:58+00	7	-13	84	3.6
491	kostanay	Қостанай облысы	2026-03-04 10:12:58+00	7	-13	84	3.6
492	kyzylorda	Қызылорда облысы	2026-03-04 10:12:58+00	4	8.7	94	1
493	mangystau	Маңғыстау облысы	2026-03-04 10:12:58+00	51	5	75	7.2
494	north_kz	Солтүстік Қазақстан облысы	2026-03-04 10:12:58+00	7	-13	84	3.6
495	pavlodar	Павлодар облысы	2026-03-04 10:12:58+00	7	-13	84	3.6
496	turkistan	Түркістан облысы	2026-03-04 10:12:58+00	4	8.7	94	1
497	abay	Абай облысы	2026-03-04 10:12:58+00	50	-5.6	62	1
498	ulytau	Ұлытау облысы	2026-03-04 10:12:58+00	7	-13	84	3.6
499	jetisu	Жетісу облысы	2026-03-04 10:12:58+00	3	1	100	2.5
500	astana	Астана	2026-03-03 22:18:53+00	7	-8.5	75	4.6
501	almaty_city	Алматы	2026-03-03 22:18:53+00	3	2	86	2.5
502	shymkent	Шымкент	2026-03-03 22:18:53+00	4	8.7	94	1
503	akmola	Ақмола облысы	2026-03-03 22:18:53+00	7	-8.5	75	4.6
504	aktobe	Ақтөбе облысы	2026-03-03 22:18:53+00	7	-8.5	75	4.6
505	almaty_obl	Алматы облысы	2026-03-03 22:18:53+00	3	2	86	2.5
506	atyrau	Атырау облысы	2026-03-03 22:18:53+00	46	5	70	7.2
507	east_kz	Шығыс Қазақстан облысы	2026-03-03 22:18:53+00	37	-5.6	62	1
508	zhambyl	Жамбыл облысы	2026-03-03 22:18:53+00	4	8.7	94	1
509	west_kz	Батыс Қазақстан облысы	2026-03-03 22:18:53+00	20	5	70	7.2
510	karaganda	Қарағанды облысы	2026-03-03 22:18:53+00	7	-8.5	75	4.6
511	kostanay	Қостанай облысы	2026-03-03 22:18:53+00	7	-8.5	75	4.6
512	kyzylorda	Қызылорда облысы	2026-03-03 22:18:53+00	4	8.7	94	1
513	mangystau	Маңғыстау облысы	2026-03-03 22:18:53+00	46	5	70	7.2
514	north_kz	Солтүстік Қазақстан облысы	2026-03-03 22:18:53+00	7	-8.5	75	4.6
515	pavlodar	Павлодар облысы	2026-03-03 22:18:53+00	7	-8.5	75	4.6
516	turkistan	Түркістан облысы	2026-03-03 22:18:53+00	4	8.7	94	1
517	abay	Абай облысы	2026-03-03 22:18:53+00	37	-5.6	62	1
518	ulytau	Ұлытау облысы	2026-03-03 22:18:53+00	7	-8.5	75	4.6
519	jetisu	Жетісу облысы	2026-03-03 22:18:53+00	3	2	86	2.5
520	astana	Астана	2026-03-03 23:00:00+00	7	-6.5	70	4.6
521	almaty_city	Алматы	2026-03-03 23:00:00+00	2	3	80	2.5
522	shymkent	Шымкент	2026-03-03 23:00:00+00	4	6.2	94	1
523	akmola	Ақмола облысы	2026-03-03 23:00:00+00	7	-6.5	70	4.6
524	aktobe	Ақтөбе облысы	2026-03-03 23:00:00+00	7	-6.5	70	4.6
525	almaty_obl	Алматы облысы	2026-03-03 23:00:00+00	2	3	80	2.5
526	atyrau	Атырау облысы	2026-03-03 23:00:00+00	39	6	65	8.2
527	east_kz	Шығыс Қазақстан облысы	2026-03-03 23:00:00+00	37	-5.6	62	1
528	zhambyl	Жамбыл облысы	2026-03-03 23:00:00+00	4	6.2	94	1
529	west_kz	Батыс Қазақстан облысы	2026-03-03 23:00:00+00	19	6	65	8.2
530	karaganda	Қарағанды облысы	2026-03-03 23:00:00+00	7	-6.5	70	4.6
531	kostanay	Қостанай облысы	2026-03-03 23:00:00+00	7	-6.5	70	4.6
532	kyzylorda	Қызылорда облысы	2026-03-03 23:00:00+00	4	6.2	94	1
533	mangystau	Маңғыстау облысы	2026-03-03 23:00:00+00	39	6	65	8.2
534	north_kz	Солтүстік Қазақстан облысы	2026-03-03 23:00:00+00	7	-6.5	70	4.6
535	pavlodar	Павлодар облысы	2026-03-03 23:00:00+00	7	-6.5	70	4.6
536	turkistan	Түркістан облысы	2026-03-03 23:00:00+00	4	6.2	94	1
537	abay	Абай облысы	2026-03-03 23:00:00+00	37	-5.6	62	1
538	ulytau	Ұлытау облысы	2026-03-03 23:00:00+00	7	-6.5	70	4.6
539	jetisu	Жетісу облысы	2026-03-03 23:00:00+00	2	3	80	2.5
544	astana	Астана	2026-03-04 00:00:00+00	7	-4.5	65	4.1
545	almaty_city	Алматы	2026-03-04 00:00:00+00	2	3.5	78	2
546	shymkent	Шымкент	2026-03-04 00:00:00+00	4	6.2	94	1
547	akmola	Ақмола облысы	2026-03-04 00:00:00+00	7	-4.5	65	4.1
548	aktobe	Ақтөбе облысы	2026-03-04 00:00:00+00	7	-4.5	65	4.1
549	almaty_obl	Алматы облысы	2026-03-04 00:00:00+00	2	3.5	78	2
550	atyrau	Атырау облысы	2026-03-04 00:00:00+00	35	7	61	8.2
551	east_kz	Шығыс Қазақстан облысы	2026-03-04 00:00:00+00	38	2.2	40	2
552	zhambyl	Жамбыл облысы	2026-03-04 00:00:00+00	4	6.2	94	1
553	west_kz	Батыс Қазақстан облысы	2026-03-04 00:00:00+00	20	7	61	8.2
554	karaganda	Қарағанды облысы	2026-03-04 00:00:00+00	7	-4.5	65	4.1
555	kostanay	Қостанай облысы	2026-03-04 00:00:00+00	7	-4.5	65	4.1
556	kyzylorda	Қызылорда облысы	2026-03-04 00:00:00+00	4	6.2	94	1
557	mangystau	Маңғыстау облысы	2026-03-04 00:00:00+00	35	7	61	8.2
558	north_kz	Солтүстік Қазақстан облысы	2026-03-04 00:00:00+00	7	-4.5	65	4.1
559	pavlodar	Павлодар облысы	2026-03-04 00:00:00+00	7	-4.5	65	4.1
560	turkistan	Түркістан облысы	2026-03-04 00:00:00+00	4	6.2	94	1
561	abay	Абай облысы	2026-03-04 00:00:00+00	38	2.2	40	2
562	ulytau	Ұлытау облысы	2026-03-04 00:00:00+00	7	-4.5	65	4.1
563	jetisu	Жетісу облысы	2026-03-04 00:00:00+00	2	3.5	78	2
564	astana	Астана	2026-03-05 13:55:33+00	7	0	86	7.7
565	almaty_city	Алматы	2026-03-05 13:55:33+00	4	7	70	0.5
566	shymkent	Шымкент	2026-03-05 13:55:33+00	4	6.8	91	1
567	akmola	Ақмола облысы	2026-03-05 13:55:33+00	7	0	86	7.7
568	aktobe	Ақтөбе облысы	2026-03-05 13:55:33+00	7	0	86	7.7
569	almaty_obl	Алматы облысы	2026-03-05 13:55:33+00	4	7	70	0.5
570	atyrau	Атырау облысы	2026-03-05 13:55:33+00	12	8	39	11
571	east_kz	Шығыс Қазақстан облысы	2026-03-05 13:55:33+00	42	1.9	74	2
572	zhambyl	Жамбыл облысы	2026-03-05 13:55:33+00	4	6.8	91	1
573	west_kz	Батыс Қазақстан облысы	2026-03-05 13:55:33+00	17	8	39	11
574	karaganda	Қарағанды облысы	2026-03-05 13:55:33+00	7	0	86	7.7
575	kostanay	Қостанай облысы	2026-03-05 13:55:33+00	7	0	86	7.7
576	kyzylorda	Қызылорда облысы	2026-03-05 13:55:33+00	4	6.8	91	1
577	mangystau	Маңғыстау облысы	2026-03-05 13:55:33+00	12	8	39	11
578	north_kz	Солтүстік Қазақстан облысы	2026-03-05 13:55:33+00	7	0	86	7.7
579	pavlodar	Павлодар облысы	2026-03-05 13:55:33+00	7	0	86	7.7
580	turkistan	Түркістан облысы	2026-03-05 13:55:33+00	4	6.8	91	1
581	abay	Абай облысы	2026-03-05 13:55:33+00	42	1.9	74	2
582	ulytau	Ұлытау облысы	2026-03-05 13:55:33+00	7	0	86	7.7
583	jetisu	Жетісу облысы	2026-03-05 13:55:33+00	4	7	70	0.5
584	astana	Astana	2026-03-05 14:00:00+00	7	0	86	7.7
585	almaty_city	Almaty	2026-03-05 14:00:00+00	4	7	70	0.5
586	astana	Астана	2026-03-05 01:23:20+00	7	0	86	7.7
587	almaty_city	Алматы	2026-03-05 01:23:20+00	4	7	70	0.5
588	shymkent	Шымкент	2026-03-05 01:23:20+00	4	6.8	91	1
589	akmola	Ақмола облысы	2026-03-05 01:23:20+00	7	0	86	7.7
590	aktobe	Ақтөбе облысы	2026-03-05 01:23:20+00	7	0	86	7.7
591	almaty_obl	Алматы облысы	2026-03-05 01:23:20+00	4	7	70	0.5
592	atyrau	Атырау облысы	2026-03-05 01:23:20+00	12	8	39	11
593	east_kz	Шығыс Қазақстан облысы	2026-03-05 01:23:20+00	42	1.9	74	2
594	zhambyl	Жамбыл облысы	2026-03-05 01:23:20+00	4	6.8	91	1
595	west_kz	Батыс Қазақстан облысы	2026-03-05 01:23:20+00	17	8	39	11
596	karaganda	Қарағанды облысы	2026-03-05 01:23:20+00	7	0	86	7.7
597	kostanay	Қостанай облысы	2026-03-05 01:23:20+00	7	0	86	7.7
598	kyzylorda	Қызылорда облысы	2026-03-05 01:23:20+00	4	6.8	91	1
599	mangystau	Маңғыстау облысы	2026-03-05 01:23:20+00	12	8	39	11
600	north_kz	Солтүстік Қазақстан облысы	2026-03-05 01:23:20+00	7	0	86	7.7
601	pavlodar	Павлодар облысы	2026-03-05 01:23:20+00	7	0	86	7.7
602	turkistan	Түркістан облысы	2026-03-05 01:23:20+00	4	6.8	91	1
603	abay	Абай облысы	2026-03-05 01:23:20+00	42	1.9	74	2
604	ulytau	Ұлытау облысы	2026-03-05 01:23:20+00	7	0	86	7.7
605	jetisu	Жетісу облысы	2026-03-05 01:23:20+00	4	7	70	0.5
606	astana	Астана	2026-03-05 14:28:32+00	7	0	86	7.7
607	almaty_city	Алматы	2026-03-05 14:28:32+00	4	7	70	0.5
608	shymkent	Шымкент	2026-03-05 14:28:32+00	4	6.8	91	1
609	akmola	Ақмола облысы	2026-03-05 14:28:32+00	7	0	86	7.7
610	aktobe	Ақтөбе облысы	2026-03-05 14:28:32+00	7	0	86	7.7
611	almaty_obl	Алматы облысы	2026-03-05 14:28:32+00	4	7	70	0.5
612	atyrau	Атырау облысы	2026-03-05 14:28:32+00	12	8	39	11
613	east_kz	Шығыс Қазақстан облысы	2026-03-05 14:28:32+00	42	1.9	74	2
614	zhambyl	Жамбыл облысы	2026-03-05 14:28:32+00	4	6.8	91	1
615	west_kz	Батыс Қазақстан облысы	2026-03-05 14:28:32+00	17	8	39	11
616	karaganda	Қарағанды облысы	2026-03-05 14:28:32+00	7	0	86	7.7
617	kostanay	Қостанай облысы	2026-03-05 14:28:32+00	7	0	86	7.7
618	kyzylorda	Қызылорда облысы	2026-03-05 14:28:32+00	4	6.8	91	1
619	mangystau	Маңғыстау облысы	2026-03-05 14:28:32+00	12	8	39	11
620	north_kz	Солтүстік Қазақстан облысы	2026-03-05 14:28:32+00	7	0	86	7.7
621	pavlodar	Павлодар облысы	2026-03-05 14:28:32+00	7	0	86	7.7
622	turkistan	Түркістан облысы	2026-03-05 14:28:32+00	4	6.8	91	1
623	abay	Абай облысы	2026-03-05 14:28:32+00	42	1.9	74	2
624	ulytau	Ұлытау облысы	2026-03-05 14:28:32+00	7	0	86	7.7
625	jetisu	Жетісу облысы	2026-03-05 14:28:32+00	4	7	70	0.5
626	astana	Астана	2026-03-05 14:30:24+00	7	0	86	7.7
627	almaty_city	Алматы	2026-03-05 14:30:24+00	4	7	70	0.5
628	shymkent	Шымкент	2026-03-05 14:30:24+00	4	6.8	91	1
629	akmola	Ақмола облысы	2026-03-05 14:30:24+00	7	0	86	7.7
630	aktobe	Ақтөбе облысы	2026-03-05 14:30:24+00	7	0	86	7.7
631	almaty_obl	Алматы облысы	2026-03-05 14:30:24+00	4	7	70	0.5
632	atyrau	Атырау облысы	2026-03-05 14:30:24+00	12	8	39	11
633	east_kz	Шығыс Қазақстан облысы	2026-03-05 14:30:24+00	42	1.9	74	2
634	zhambyl	Жамбыл облысы	2026-03-05 14:30:24+00	4	6.8	91	1
635	west_kz	Батыс Қазақстан облысы	2026-03-05 14:30:24+00	17	8	39	11
636	karaganda	Қарағанды облысы	2026-03-05 14:30:24+00	7	0	86	7.7
637	kostanay	Қостанай облысы	2026-03-05 14:30:24+00	7	0	86	7.7
638	kyzylorda	Қызылорда облысы	2026-03-05 14:30:24+00	4	6.8	91	1
639	mangystau	Маңғыстау облысы	2026-03-05 14:30:24+00	12	8	39	11
640	north_kz	Солтүстік Қазақстан облысы	2026-03-05 14:30:24+00	7	0	86	7.7
641	pavlodar	Павлодар облысы	2026-03-05 14:30:24+00	7	0	86	7.7
642	turkistan	Түркістан облысы	2026-03-05 14:30:24+00	4	6.8	91	1
643	abay	Абай облысы	2026-03-05 14:30:24+00	42	1.9	74	2
644	ulytau	Ұлытау облысы	2026-03-05 14:30:24+00	7	0	86	7.7
645	jetisu	Жетісу облысы	2026-03-05 14:30:24+00	4	7	70	0.5
646	astana	Астана	2026-03-05 14:31:57+00	7	0	86	7.7
647	almaty_city	Алматы	2026-03-05 14:31:57+00	4	7	70	0.5
648	shymkent	Шымкент	2026-03-05 14:31:57+00	4	6.8	91	1
649	akmola	Ақмола облысы	2026-03-05 14:31:57+00	7	0	86	7.7
650	aktobe	Ақтөбе облысы	2026-03-05 14:31:57+00	7	0	86	7.7
651	almaty_obl	Алматы облысы	2026-03-05 14:31:57+00	4	7	70	0.5
652	atyrau	Атырау облысы	2026-03-05 14:31:57+00	12	8	39	11
653	east_kz	Шығыс Қазақстан облысы	2026-03-05 14:31:57+00	42	1.9	74	2
654	zhambyl	Жамбыл облысы	2026-03-05 14:31:57+00	4	6.8	91	1
655	west_kz	Батыс Қазақстан облысы	2026-03-05 14:31:57+00	17	8	39	11
656	karaganda	Қарағанды облысы	2026-03-05 14:31:57+00	7	0	86	7.7
657	kostanay	Қостанай облысы	2026-03-05 14:31:57+00	7	0	86	7.7
658	kyzylorda	Қызылорда облысы	2026-03-05 14:31:57+00	4	6.8	91	1
659	mangystau	Маңғыстау облысы	2026-03-05 14:31:57+00	12	8	39	11
660	north_kz	Солтүстік Қазақстан облысы	2026-03-05 14:31:57+00	7	0	86	7.7
661	pavlodar	Павлодар облысы	2026-03-05 14:31:57+00	7	0	86	7.7
662	turkistan	Түркістан облысы	2026-03-05 14:31:57+00	4	6.8	91	1
663	abay	Абай облысы	2026-03-05 14:31:57+00	42	1.9	74	2
664	ulytau	Ұлытау облысы	2026-03-05 14:31:57+00	7	0	86	7.7
665	jetisu	Жетісу облысы	2026-03-05 14:31:57+00	4	7	70	0.5
666	astana	Астана	2026-03-05 14:48:15+00	7	0	86	7.7
667	almaty_city	Алматы	2026-03-05 14:48:15+00	4	7	70	0.5
668	shymkent	Шымкент	2026-03-05 14:48:15+00	4	6.8	91	1
669	akmola	Ақмола облысы	2026-03-05 14:48:15+00	7	0	86	7.7
670	aktobe	Ақтөбе облысы	2026-03-05 14:48:15+00	7	0	86	7.7
671	almaty_obl	Алматы облысы	2026-03-05 14:48:15+00	4	7	70	0.5
672	atyrau	Атырау облысы	2026-03-05 14:48:15+00	11	9	34	11
673	east_kz	Шығыс Қазақстан облысы	2026-03-05 14:48:15+00	36	3.8	66	2
674	zhambyl	Жамбыл облысы	2026-03-05 14:48:15+00	4	6.8	91	1
675	west_kz	Батыс Қазақстан облысы	2026-03-05 14:48:15+00	17	9	34	11
676	karaganda	Қарағанды облысы	2026-03-05 14:48:15+00	7	0	86	7.7
677	kostanay	Қостанай облысы	2026-03-05 14:48:15+00	7	0	86	7.7
678	kyzylorda	Қызылорда облысы	2026-03-05 14:48:15+00	4	6.8	91	1
679	mangystau	Маңғыстау облысы	2026-03-05 14:48:15+00	11	9	34	11
680	north_kz	Солтүстік Қазақстан облысы	2026-03-05 14:48:15+00	7	0	86	7.7
681	pavlodar	Павлодар облысы	2026-03-05 14:48:15+00	7	0	86	7.7
682	turkistan	Түркістан облысы	2026-03-05 14:48:15+00	4	6.8	91	1
683	abay	Абай облысы	2026-03-05 14:48:15+00	36	3.8	66	2
684	ulytau	Ұлытау облысы	2026-03-05 14:48:15+00	7	0	86	7.7
685	jetisu	Жетісу облысы	2026-03-05 14:48:15+00	4	7	70	0.5
686	astana	Астана	2026-03-05 01:49:55+00	7	0	86	7.7
687	almaty_city	Алматы	2026-03-05 01:49:55+00	4	7	70	0.5
688	shymkent	Шымкент	2026-03-05 01:49:55+00	4	6.8	91	1
689	akmola	Ақмола облысы	2026-03-05 01:49:55+00	7	0	86	7.7
690	aktobe	Ақтөбе облысы	2026-03-05 01:49:55+00	7	0	86	7.7
691	almaty_obl	Алматы облысы	2026-03-05 01:49:55+00	4	7	70	0.5
692	atyrau	Атырау облысы	2026-03-05 01:49:55+00	11	9	34	11
693	east_kz	Шығыс Қазақстан облысы	2026-03-05 01:49:55+00	36	3.8	66	2
694	zhambyl	Жамбыл облысы	2026-03-05 01:49:55+00	4	6.8	91	1
695	west_kz	Батыс Қазақстан облысы	2026-03-05 01:49:55+00	17	9	34	11
696	karaganda	Қарағанды облысы	2026-03-05 01:49:55+00	7	0	86	7.7
697	kostanay	Қостанай облысы	2026-03-05 01:49:55+00	7	0	86	7.7
698	kyzylorda	Қызылорда облысы	2026-03-05 01:49:55+00	4	6.8	91	1
699	mangystau	Маңғыстау облысы	2026-03-05 01:49:55+00	11	9	34	11
700	north_kz	Солтүстік Қазақстан облысы	2026-03-05 01:49:55+00	7	0	86	7.7
701	pavlodar	Павлодар облысы	2026-03-05 01:49:55+00	7	0	86	7.7
702	turkistan	Түркістан облысы	2026-03-05 01:49:55+00	4	6.8	91	1
703	abay	Абай облысы	2026-03-05 01:49:55+00	36	3.8	66	2
704	ulytau	Ұлытау облысы	2026-03-05 01:49:55+00	7	0	86	7.7
705	jetisu	Жетісу облысы	2026-03-05 01:49:55+00	4	7	70	0.5
706	astana	Астана	2026-03-05 01:51:32+00	7	0	86	7.7
707	almaty_city	Алматы	2026-03-05 01:51:32+00	4	7	70	0.5
708	shymkent	Шымкент	2026-03-05 01:51:32+00	4	6.8	91	1
709	akmola	Ақмола облысы	2026-03-05 01:51:32+00	7	0	86	7.7
710	aktobe	Ақтөбе облысы	2026-03-05 01:51:32+00	7	0	86	7.7
711	almaty_obl	Алматы облысы	2026-03-05 01:51:32+00	4	7	70	0.5
712	atyrau	Атырау облысы	2026-03-05 01:51:32+00	11	9	34	11
713	east_kz	Шығыс Қазақстан облысы	2026-03-05 01:51:32+00	36	3.8	66	2
714	zhambyl	Жамбыл облысы	2026-03-05 01:51:32+00	4	6.8	91	1
715	west_kz	Батыс Қазақстан облысы	2026-03-05 01:51:32+00	17	9	34	11
716	karaganda	Қарағанды облысы	2026-03-05 01:51:32+00	7	0	86	7.7
717	kostanay	Қостанай облысы	2026-03-05 01:51:32+00	7	0	86	7.7
718	kyzylorda	Қызылорда облысы	2026-03-05 01:51:32+00	4	6.8	91	1
719	mangystau	Маңғыстау облысы	2026-03-05 01:51:32+00	11	9	34	11
720	north_kz	Солтүстік Қазақстан облысы	2026-03-05 01:51:32+00	7	0	86	7.7
721	pavlodar	Павлодар облысы	2026-03-05 01:51:32+00	7	0	86	7.7
722	turkistan	Түркістан облысы	2026-03-05 01:51:32+00	4	6.8	91	1
723	abay	Абай облысы	2026-03-05 01:51:32+00	36	3.8	66	2
724	ulytau	Ұлытау облысы	2026-03-05 01:51:32+00	7	0	86	7.7
725	jetisu	Жетісу облысы	2026-03-05 01:51:32+00	4	7	70	0.5
726	astana	Астана	2026-03-05 01:54:55+00	7	0	86	7.7
727	almaty_city	Алматы	2026-03-05 01:54:55+00	4	7	70	0.5
728	shymkent	Шымкент	2026-03-05 01:54:55+00	4	6.8	91	1
729	akmola	Ақмола облысы	2026-03-05 01:54:55+00	7	0	86	7.7
730	aktobe	Ақтөбе облысы	2026-03-05 01:54:55+00	7	0	86	7.7
731	almaty_obl	Алматы облысы	2026-03-05 01:54:55+00	4	7	70	0.5
732	atyrau	Атырау облысы	2026-03-05 01:54:55+00	11	9	34	11
733	east_kz	Шығыс Қазақстан облысы	2026-03-05 01:54:55+00	36	3.8	66	2
734	zhambyl	Жамбыл облысы	2026-03-05 01:54:55+00	4	6.8	91	1
735	west_kz	Батыс Қазақстан облысы	2026-03-05 01:54:55+00	17	9	34	11
736	karaganda	Қарағанды облысы	2026-03-05 01:54:55+00	7	0	86	7.7
737	kostanay	Қостанай облысы	2026-03-05 01:54:55+00	7	0	86	7.7
738	kyzylorda	Қызылорда облысы	2026-03-05 01:54:55+00	4	6.8	91	1
739	mangystau	Маңғыстау облысы	2026-03-05 01:54:55+00	11	9	34	11
740	north_kz	Солтүстік Қазақстан облысы	2026-03-05 01:54:55+00	7	0	86	7.7
741	pavlodar	Павлодар облысы	2026-03-05 01:54:55+00	7	0	86	7.7
742	turkistan	Түркістан облысы	2026-03-05 01:54:55+00	4	6.8	91	1
743	abay	Абай облысы	2026-03-05 01:54:55+00	36	3.8	66	2
744	ulytau	Ұлытау облысы	2026-03-05 01:54:55+00	7	0	86	7.7
745	jetisu	Жетісу облысы	2026-03-05 01:54:55+00	4	7	70	0.5
746	astana	Астана	2026-03-05 01:56:21+00	7	0	86	7.7
747	almaty_city	Алматы	2026-03-05 01:56:21+00	4	7	70	0.5
748	shymkent	Шымкент	2026-03-05 01:56:21+00	4	6.8	91	1
749	akmola	Ақмола облысы	2026-03-05 01:56:21+00	7	0	86	7.7
750	aktobe	Ақтөбе облысы	2026-03-05 01:56:21+00	7	0	86	7.7
751	almaty_obl	Алматы облысы	2026-03-05 01:56:21+00	4	7	70	0.5
752	atyrau	Атырау облысы	2026-03-05 01:56:21+00	11	9	34	11
753	east_kz	Шығыс Қазақстан облысы	2026-03-05 01:56:21+00	36	3.8	66	2
754	zhambyl	Жамбыл облысы	2026-03-05 01:56:21+00	4	6.8	91	1
755	west_kz	Батыс Қазақстан облысы	2026-03-05 01:56:21+00	17	9	34	11
756	karaganda	Қарағанды облысы	2026-03-05 01:56:21+00	7	0	86	7.7
757	kostanay	Қостанай облысы	2026-03-05 01:56:21+00	7	0	86	7.7
758	kyzylorda	Қызылорда облысы	2026-03-05 01:56:21+00	4	6.8	91	1
759	mangystau	Маңғыстау облысы	2026-03-05 01:56:21+00	11	9	34	11
760	north_kz	Солтүстік Қазақстан облысы	2026-03-05 01:56:21+00	7	0	86	7.7
761	pavlodar	Павлодар облысы	2026-03-05 01:56:21+00	7	0	86	7.7
762	turkistan	Түркістан облысы	2026-03-05 01:56:21+00	4	6.8	91	1
763	abay	Абай облысы	2026-03-05 01:56:21+00	36	3.8	66	2
764	ulytau	Ұлытау облысы	2026-03-05 01:56:21+00	7	0	86	7.7
765	jetisu	Жетісу облысы	2026-03-05 01:56:21+00	4	7	70	0.5
766	astana	Астана	2026-03-05 02:00:00+00	7	0	86	7.7
767	almaty_city	Алматы	2026-03-05 02:00:00+00	4	7	70	0.5
768	shymkent	Шымкент	2026-03-05 02:00:00+00	4	6.8	91	1
769	akmola	Ақмола облысы	2026-03-05 02:00:00+00	7	0	86	7.7
770	aktobe	Ақтөбе облысы	2026-03-05 02:00:00+00	7	0	86	7.7
771	almaty_obl	Алматы облысы	2026-03-05 02:00:00+00	4	7	70	0.5
772	atyrau	Атырау облысы	2026-03-05 02:00:00+00	11	9	34	11
773	east_kz	Шығыс Қазақстан облысы	2026-03-05 02:00:00+00	36	3.8	66	2
774	zhambyl	Жамбыл облысы	2026-03-05 02:00:00+00	4	6.8	91	1
775	west_kz	Батыс Қазақстан облысы	2026-03-05 02:00:00+00	17	9	34	11
776	karaganda	Қарағанды облысы	2026-03-05 02:00:00+00	7	0	86	7.7
777	kostanay	Қостанай облысы	2026-03-05 02:00:00+00	7	0	86	7.7
778	kyzylorda	Қызылорда облысы	2026-03-05 02:00:00+00	4	6.8	91	1
779	mangystau	Маңғыстау облысы	2026-03-05 02:00:00+00	11	9	34	11
780	north_kz	Солтүстік Қазақстан облысы	2026-03-05 02:00:00+00	7	0	86	7.7
781	pavlodar	Павлодар облысы	2026-03-05 02:00:00+00	7	0	86	7.7
782	turkistan	Түркістан облысы	2026-03-05 02:00:00+00	4	6.8	91	1
783	abay	Абай облысы	2026-03-05 02:00:00+00	36	3.8	66	2
784	ulytau	Ұлытау облысы	2026-03-05 02:00:00+00	7	0	86	7.7
785	jetisu	Жетісу облысы	2026-03-05 02:00:00+00	4	7	70	0.5
786	astana	Астана	2026-03-05 02:00:57+00	7	0	86	7.7
787	almaty_city	Алматы	2026-03-05 02:00:57+00	4	7	70	0.5
788	shymkent	Шымкент	2026-03-05 02:00:57+00	4	6.8	91	1
789	akmola	Ақмола облысы	2026-03-05 02:00:57+00	7	0	86	7.7
790	aktobe	Ақтөбе облысы	2026-03-05 02:00:57+00	7	0	86	7.7
791	almaty_obl	Алматы облысы	2026-03-05 02:00:57+00	4	7	70	0.5
792	atyrau	Атырау облысы	2026-03-05 02:00:57+00	11	9	34	11
793	east_kz	Шығыс Қазақстан облысы	2026-03-05 02:00:57+00	36	3.8	66	2
794	zhambyl	Жамбыл облысы	2026-03-05 02:00:57+00	4	6.8	91	1
795	west_kz	Батыс Қазақстан облысы	2026-03-05 02:00:57+00	17	9	34	11
796	karaganda	Қарағанды облысы	2026-03-05 02:00:57+00	7	0	86	7.7
797	kostanay	Қостанай облысы	2026-03-05 02:00:57+00	7	0	86	7.7
798	kyzylorda	Қызылорда облысы	2026-03-05 02:00:57+00	4	6.8	91	1
799	mangystau	Маңғыстау облысы	2026-03-05 02:00:57+00	11	9	34	11
800	north_kz	Солтүстік Қазақстан облысы	2026-03-05 02:00:57+00	7	0	86	7.7
801	pavlodar	Павлодар облысы	2026-03-05 02:00:57+00	7	0	86	7.7
802	turkistan	Түркістан облысы	2026-03-05 02:00:57+00	4	6.8	91	1
803	abay	Абай облысы	2026-03-05 02:00:57+00	36	3.8	66	2
804	ulytau	Ұлытау облысы	2026-03-05 02:00:57+00	7	0	86	7.7
805	jetisu	Жетісу облысы	2026-03-05 02:00:57+00	4	7	70	0.5
806	astana	Астана	2026-03-05 15:10:16+00	7	0	86	8.7
807	almaty_city	Алматы	2026-03-05 15:10:16+00	3	7	70	1.5
808	shymkent	Шымкент	2026-03-05 15:10:16+00	4	7.4	92	1
809	akmola	Ақмола облысы	2026-03-05 15:10:16+00	7	0	86	8.7
810	aktobe	Ақтөбе облысы	2026-03-05 15:10:16+00	7	0	86	8.7
811	almaty_obl	Алматы облысы	2026-03-05 15:10:16+00	3	7	70	1.5
812	atyrau	Атырау облысы	2026-03-05 15:10:16+00	11	9	34	11
813	east_kz	Шығыс Қазақстан облысы	2026-03-05 15:10:16+00	36	3.8	66	2
814	zhambyl	Жамбыл облысы	2026-03-05 15:10:16+00	4	7.4	92	1
815	west_kz	Батыс Қазақстан облысы	2026-03-05 15:10:16+00	17	9	34	11
816	karaganda	Қарағанды облысы	2026-03-05 15:10:16+00	7	0	86	8.7
817	kostanay	Қостанай облысы	2026-03-05 15:10:16+00	7	0	86	8.7
818	kyzylorda	Қызылорда облысы	2026-03-05 15:10:16+00	4	7.4	92	1
819	mangystau	Маңғыстау облысы	2026-03-05 15:10:16+00	11	9	34	11
820	north_kz	Солтүстік Қазақстан облысы	2026-03-05 15:10:16+00	7	0	86	8.7
821	pavlodar	Павлодар облысы	2026-03-05 15:10:16+00	7	0	86	8.7
822	turkistan	Түркістан облысы	2026-03-05 15:10:16+00	4	7.4	92	1
823	abay	Абай облысы	2026-03-05 15:10:16+00	36	3.8	66	2
824	ulytau	Ұлытау облысы	2026-03-05 15:10:16+00	7	0	86	8.7
825	jetisu	Жетісу облысы	2026-03-05 15:10:16+00	3	7	70	1.5
826	astana	Астана	2026-03-05 03:08:28+00	7	0	86	7.7
827	almaty_city	Алматы	2026-03-05 03:08:28+00	3	7	70	1.5
828	shymkent	Шымкент	2026-03-05 03:08:28+00	4	7.4	92	1
829	akmola	Ақмола облысы	2026-03-05 03:08:28+00	7	0	86	7.7
830	aktobe	Ақтөбе облысы	2026-03-05 03:08:28+00	7	0	86	7.7
831	almaty_obl	Алматы облысы	2026-03-05 03:08:28+00	3	7	70	1.5
832	atyrau	Атырау облысы	2026-03-05 03:08:28+00	11	10	29	10.2
833	east_kz	Шығыс Қазақстан облысы	2026-03-05 03:08:28+00	61	3.8	66	2
834	zhambyl	Жамбыл облысы	2026-03-05 03:08:28+00	4	7.4	92	1
835	west_kz	Батыс Қазақстан облысы	2026-03-05 03:08:28+00	17	10	29	10.2
836	karaganda	Қарағанды облысы	2026-03-05 03:08:28+00	7	0	86	7.7
837	kostanay	Қостанай облысы	2026-03-05 03:08:28+00	7	0	86	7.7
838	kyzylorda	Қызылорда облысы	2026-03-05 03:08:28+00	4	7.4	92	1
839	mangystau	Маңғыстау облысы	2026-03-05 03:08:28+00	11	10	29	10.2
840	north_kz	Солтүстік Қазақстан облысы	2026-03-05 03:08:28+00	7	0	86	7.7
841	pavlodar	Павлодар облысы	2026-03-05 03:08:28+00	7	0	86	7.7
842	turkistan	Түркістан облысы	2026-03-05 03:08:28+00	4	7.4	92	1
843	abay	Абай облысы	2026-03-05 03:08:28+00	61	3.8	66	2
844	ulytau	Ұлытау облысы	2026-03-05 03:08:28+00	7	0	86	7.7
845	jetisu	Жетісу облысы	2026-03-05 03:08:28+00	3	7	70	1.5
846	astana	Астана	2026-03-05 03:13:39+00	7	0	86	7.7
847	almaty_city	Алматы	2026-03-05 03:13:39+00	3	7	70	1.5
848	shymkent	Шымкент	2026-03-05 03:13:39+00	4	7.4	92	1
849	akmola	Ақмола облысы	2026-03-05 03:13:39+00	7	0	86	7.7
850	aktobe	Ақтөбе облысы	2026-03-05 03:13:39+00	7	0	86	7.7
851	almaty_obl	Алматы облысы	2026-03-05 03:13:39+00	3	7	70	1.5
852	atyrau	Атырау облысы	2026-03-05 03:13:39+00	11	10	29	10.2
853	east_kz	Шығыс Қазақстан облысы	2026-03-05 03:13:39+00	61	3.8	66	2
854	zhambyl	Жамбыл облысы	2026-03-05 03:13:39+00	4	7.4	92	1
855	west_kz	Батыс Қазақстан облысы	2026-03-05 03:13:39+00	17	10	29	10.2
856	karaganda	Қарағанды облысы	2026-03-05 03:13:39+00	7	0	86	7.7
857	kostanay	Қостанай облысы	2026-03-05 03:13:39+00	7	0	86	7.7
858	kyzylorda	Қызылорда облысы	2026-03-05 03:13:39+00	4	7.4	92	1
859	mangystau	Маңғыстау облысы	2026-03-05 03:13:39+00	11	10	29	10.2
860	north_kz	Солтүстік Қазақстан облысы	2026-03-05 03:13:39+00	7	0	86	7.7
861	pavlodar	Павлодар облысы	2026-03-05 03:13:39+00	7	0	86	7.7
862	turkistan	Түркістан облысы	2026-03-05 03:13:39+00	4	7.4	92	1
863	abay	Абай облысы	2026-03-05 03:13:39+00	61	3.8	66	2
864	ulytau	Ұлытау облысы	2026-03-05 03:13:39+00	7	0	86	7.7
865	jetisu	Жетісу облысы	2026-03-05 03:13:39+00	3	7	70	1.5
866	astana	Астана	2026-03-05 03:20:08+00	7	0	86	7.7
867	almaty_city	Алматы	2026-03-05 03:20:08+00	3	7	70	1.5
868	shymkent	Шымкент	2026-03-05 03:20:08+00	4	7.4	92	1
869	akmola	Ақмола облысы	2026-03-05 03:20:08+00	7	0	86	7.7
870	aktobe	Ақтөбе облысы	2026-03-05 03:20:08+00	7	0	86	7.7
871	almaty_obl	Алматы облысы	2026-03-05 03:20:08+00	3	7	70	1.5
872	atyrau	Атырау облысы	2026-03-05 03:20:08+00	11	10	29	10.2
873	east_kz	Шығыс Қазақстан облысы	2026-03-05 03:20:08+00	61	3.8	66	2
874	zhambyl	Жамбыл облысы	2026-03-05 03:20:08+00	4	7.4	92	1
875	west_kz	Батыс Қазақстан облысы	2026-03-05 03:20:08+00	17	10	29	10.2
876	karaganda	Қарағанды облысы	2026-03-05 03:20:08+00	7	0	86	7.7
877	kostanay	Қостанай облысы	2026-03-05 03:20:08+00	7	0	86	7.7
878	kyzylorda	Қызылорда облысы	2026-03-05 03:20:08+00	4	7.4	92	1
879	mangystau	Маңғыстау облысы	2026-03-05 03:20:08+00	11	10	29	10.2
880	north_kz	Солтүстік Қазақстан облысы	2026-03-05 03:20:08+00	7	0	86	7.7
881	pavlodar	Павлодар облысы	2026-03-05 03:20:08+00	7	0	86	7.7
882	turkistan	Түркістан облысы	2026-03-05 03:20:08+00	4	7.4	92	1
883	abay	Абай облысы	2026-03-05 03:20:08+00	61	3.8	66	2
884	ulytau	Ұлытау облысы	2026-03-05 03:20:08+00	7	0	86	7.7
885	jetisu	Жетісу облысы	2026-03-05 03:20:08+00	3	7	70	1.5
886	astana	Астана	2026-03-05 03:24:20+00	7	0	86	7.7
887	almaty_city	Алматы	2026-03-05 03:24:20+00	3	7	70	1.5
888	shymkent	Шымкент	2026-03-05 03:24:20+00	4	7.4	92	1
889	akmola	Ақмола облысы	2026-03-05 03:24:20+00	7	0	86	7.7
890	aktobe	Ақтөбе облысы	2026-03-05 03:24:20+00	7	0	86	7.7
891	almaty_obl	Алматы облысы	2026-03-05 03:24:20+00	3	7	70	1.5
892	atyrau	Атырау облысы	2026-03-05 03:24:20+00	11	10	29	9.7
893	east_kz	Шығыс Қазақстан облысы	2026-03-05 03:24:20+00	61	3.8	66	2
894	zhambyl	Жамбыл облысы	2026-03-05 03:24:20+00	4	7.4	92	1
895	west_kz	Батыс Қазақстан облысы	2026-03-05 03:24:20+00	17	10	29	9.7
896	karaganda	Қарағанды облысы	2026-03-05 03:24:20+00	7	0	86	7.7
897	kostanay	Қостанай облысы	2026-03-05 03:24:20+00	7	0	86	7.7
898	kyzylorda	Қызылорда облысы	2026-03-05 03:24:20+00	4	7.4	92	1
899	mangystau	Маңғыстау облысы	2026-03-05 03:24:20+00	11	10	29	9.7
900	north_kz	Солтүстік Қазақстан облысы	2026-03-05 03:24:20+00	7	0	86	7.7
901	pavlodar	Павлодар облысы	2026-03-05 03:24:20+00	7	0	86	7.7
902	turkistan	Түркістан облысы	2026-03-05 03:24:20+00	4	7.4	92	1
903	abay	Абай облысы	2026-03-05 03:24:20+00	61	3.8	66	2
904	ulytau	Ұлытау облысы	2026-03-05 03:24:20+00	7	0	86	7.7
905	jetisu	Жетісу облысы	2026-03-05 03:24:20+00	3	7	70	1.5
906	astana	Астана	2026-03-05 03:33:33+00	7	0	86	7.7
907	almaty_city	Алматы	2026-03-05 03:33:33+00	3	7	70	1.5
908	shymkent	Шымкент	2026-03-05 03:33:33+00	4	7.4	92	1
909	akmola	Ақмола облысы	2026-03-05 03:33:33+00	7	0	86	7.7
910	aktobe	Ақтөбе облысы	2026-03-05 03:33:33+00	7	0	86	7.7
911	almaty_obl	Алматы облысы	2026-03-05 03:33:33+00	3	7	70	1.5
912	atyrau	Атырау облысы	2026-03-05 03:33:33+00	11	10	29	9.7
913	east_kz	Шығыс Қазақстан облысы	2026-03-05 03:33:33+00	61	3.8	66	2
914	zhambyl	Жамбыл облысы	2026-03-05 03:33:33+00	4	7.4	92	1
915	west_kz	Батыс Қазақстан облысы	2026-03-05 03:33:33+00	17	10	29	9.7
916	karaganda	Қарағанды облысы	2026-03-05 03:33:33+00	7	0	86	7.7
917	kostanay	Қостанай облысы	2026-03-05 03:33:33+00	7	0	86	7.7
918	kyzylorda	Қызылорда облысы	2026-03-05 03:33:33+00	4	7.4	92	1
919	mangystau	Маңғыстау облысы	2026-03-05 03:33:33+00	11	10	29	9.7
920	north_kz	Солтүстік Қазақстан облысы	2026-03-05 03:33:33+00	7	0	86	7.7
921	pavlodar	Павлодар облысы	2026-03-05 03:33:33+00	7	0	86	7.7
922	turkistan	Түркістан облысы	2026-03-05 03:33:33+00	4	7.4	92	1
923	abay	Абай облысы	2026-03-05 03:33:33+00	61	3.8	66	2
924	ulytau	Ұлытау облысы	2026-03-05 03:33:33+00	7	0	86	7.7
925	jetisu	Жетісу облысы	2026-03-05 03:33:33+00	3	7	70	1.5
926	astana	Astana	2026-03-05 04:00:00+00	8	0	92	6.1
927	almaty_city	Almaty	2026-03-05 04:00:00+00	4	7	70	1
928	astana	Астана	2026-04-06 00:15:42+00	8	15	58	3.6
929	almaty_city	Алматы	2026-04-06 00:15:42+00	2	22	43	1.5
930	shymkent	Шымкент	2026-04-06 00:15:42+00	119	24	14	0.5
931	akmola	Ақмола облысы	2026-04-06 00:15:42+00	8	15	58	3.6
932	aktobe	Ақтөбе облысы	2026-04-06 00:15:42+00	8	15	58	3.6
933	almaty_obl	Алматы облысы	2026-04-06 00:15:42+00	2	22	43	1.5
934	atyrau	Атырау облысы	2026-04-06 00:15:42+00	24	15	47	17.4
935	east_kz	Шығыс Қазақстан облысы	2026-04-06 00:15:42+00	61	21.7	42	3
936	zhambyl	Жамбыл облысы	2026-04-06 00:15:42+00	2	22	43	1.5
937	west_kz	Батыс Қазақстан облысы	2026-04-06 00:15:42+00	15	15	47	17.4
938	karaganda	Қарағанды облысы	2026-04-06 00:15:42+00	8	15	58	3.6
939	kostanay	Қостанай облысы	2026-04-06 00:15:42+00	8	15	58	3.6
940	kyzylorda	Қызылорда облысы	2026-04-06 00:15:42+00	8	15	58	3.6
941	mangystau	Маңғыстау облысы	2026-04-06 00:15:42+00	24	15	47	17.4
942	north_kz	Солтүстік Қазақстан облысы	2026-04-06 00:15:42+00	8	15	58	3.6
943	pavlodar	Павлодар облысы	2026-04-06 00:15:42+00	8	15	58	3.6
944	turkistan	Түркістан облысы	2026-04-06 00:15:42+00	8	15	58	3.6
945	abay	Абай облысы	2026-04-06 00:15:42+00	61	21.7	42	3
946	ulytau	Ұлытау облысы	2026-04-06 00:15:42+00	8	15	58	3.6
947	jetisu	Жетісу облысы	2026-04-06 00:15:42+00	2	22	43	1.5
948	astana	Астана	2026-04-06 01:47:04+00	8	16	48	4.6
949	almaty_city	Алматы	2026-04-06 01:47:04+00	2	22	43	1.5
950	shymkent	Шымкент	2026-04-06 01:47:04+00	107	25	13	3.6
951	akmola	Ақмола облысы	2026-04-06 01:47:04+00	8	16	48	4.6
952	aktobe	Ақтөбе облысы	2026-04-06 01:47:04+00	8	16	48	4.6
953	almaty_obl	Алматы облысы	2026-04-06 01:47:04+00	2	22	43	1.5
954	atyrau	Атырау облысы	2026-04-06 01:47:04+00	24	16	44	16.4
955	east_kz	Шығыс Қазақстан облысы	2026-04-06 01:47:04+00	61	21.7	42	3
956	zhambyl	Жамбыл облысы	2026-04-06 01:47:04+00	2	22	43	1.5
957	west_kz	Батыс Қазақстан облысы	2026-04-06 01:47:04+00	14	16	44	16.4
958	karaganda	Қарағанды облысы	2026-04-06 01:47:04+00	8	16	48	4.6
959	kostanay	Қостанай облысы	2026-04-06 01:47:04+00	8	16	48	4.6
960	kyzylorda	Қызылорда облысы	2026-04-06 01:47:04+00	8	16	48	4.6
961	mangystau	Маңғыстау облысы	2026-04-06 01:47:04+00	24	16	44	16.4
962	north_kz	Солтүстік Қазақстан облысы	2026-04-06 01:47:04+00	8	16	48	4.6
963	pavlodar	Павлодар облысы	2026-04-06 01:47:04+00	8	16	48	4.6
964	turkistan	Түркістан облысы	2026-04-06 01:47:04+00	8	16	48	4.6
965	abay	Абай облысы	2026-04-06 01:47:04+00	61	21.7	42	3
966	ulytau	Ұлытау облысы	2026-04-06 01:47:04+00	8	16	48	4.6
967	jetisu	Жетісу облысы	2026-04-06 01:47:04+00	2	22	43	1.5
968	astana	Astana	2026-04-06 02:00:00+00	8	17	45	3
969	almaty_city	Алматы	2026-04-06 02:00:00+00	4	23	39	1.5
970	shymkent	Шымкент	2026-04-06 02:00:00+00	107	25	13	3.6
971	akmola	Ақмола облысы	2026-04-06 02:00:00+00	8	17	45	3
972	aktobe	Ақтөбе облысы	2026-04-06 02:00:00+00	8	17	45	3
973	almaty_obl	Алматы облысы	2026-04-06 02:00:00+00	4	23	39	1.5
974	atyrau	Атырау облысы	2026-04-06 02:00:00+00	24	16	44	16.4
975	east_kz	Шығыс Қазақстан облысы	2026-04-06 02:00:00+00	61	21.7	42	3
976	zhambyl	Жамбыл облысы	2026-04-06 02:00:00+00	4	23	39	1.5
977	west_kz	Батыс Қазақстан облысы	2026-04-06 02:00:00+00	14	16	44	16.4
978	karaganda	Қарағанды облысы	2026-04-06 02:00:00+00	8	17	45	3
979	kostanay	Қостанай облысы	2026-04-06 02:00:00+00	8	17	45	3
980	kyzylorda	Қызылорда облысы	2026-04-06 02:00:00+00	8	17	45	3
981	mangystau	Маңғыстау облысы	2026-04-06 02:00:00+00	24	16	44	16.4
982	north_kz	Солтүстік Қазақстан облысы	2026-04-06 02:00:00+00	8	17	45	3
983	pavlodar	Павлодар облысы	2026-04-06 02:00:00+00	8	17	45	3
984	turkistan	Түркістан облысы	2026-04-06 02:00:00+00	8	17	45	3
985	abay	Абай облысы	2026-04-06 02:00:00+00	61	21.7	42	3
986	ulytau	Ұлытау облысы	2026-04-06 02:00:00+00	8	17	45	3
987	jetisu	Жетісу облысы	2026-04-06 02:00:00+00	4	23	39	1.5
988	astana	Астана	2026-04-06 02:01:28+00	8	17	45	3
989	almaty_city	Алматы	2026-04-06 02:01:28+00	4	23	39	1.5
990	shymkent	Шымкент	2026-04-06 02:01:28+00	107	25	13	3.6
991	akmola	Ақмола облысы	2026-04-06 02:01:28+00	8	17	45	3
992	aktobe	Ақтөбе облысы	2026-04-06 02:01:28+00	8	17	45	3
993	almaty_obl	Алматы облысы	2026-04-06 02:01:28+00	4	23	39	1.5
994	atyrau	Атырау облысы	2026-04-06 02:01:28+00	24	16	44	16.4
995	east_kz	Шығыс Қазақстан облысы	2026-04-06 02:01:28+00	61	21.7	42	3
996	zhambyl	Жамбыл облысы	2026-04-06 02:01:28+00	4	23	39	1.5
997	west_kz	Батыс Қазақстан облысы	2026-04-06 02:01:28+00	14	16	44	16.4
998	karaganda	Қарағанды облысы	2026-04-06 02:01:28+00	8	17	45	3
999	kostanay	Қостанай облысы	2026-04-06 02:01:28+00	8	17	45	3
1000	kyzylorda	Қызылорда облысы	2026-04-06 02:01:28+00	8	17	45	3
1001	mangystau	Маңғыстау облысы	2026-04-06 02:01:28+00	24	16	44	16.4
1002	north_kz	Солтүстік Қазақстан облысы	2026-04-06 02:01:28+00	8	17	45	3
1003	pavlodar	Павлодар облысы	2026-04-06 02:01:28+00	8	17	45	3
1004	turkistan	Түркістан облысы	2026-04-06 02:01:28+00	8	17	45	3
1005	abay	Абай облысы	2026-04-06 02:01:28+00	61	21.7	42	3
1006	ulytau	Ұлытау облысы	2026-04-06 02:01:28+00	8	17	45	3
1007	jetisu	Жетісу облысы	2026-04-06 02:01:28+00	4	23	39	1.5
1008	astana	Астана	2026-04-13 16:06:34+00	5	9.5	87	6.1
1009	almaty_city	Алматы	2026-04-13 16:06:34+00	2	21	29	3
1010	shymkent	Шымкент	2026-04-13 16:06:34+00	87	15	51	3.6
1011	akmola	Ақмола облысы	2026-04-13 16:06:34+00	5	9.5	87	6.1
1012	aktobe	Ақтөбе облысы	2026-04-13 16:06:34+00	5	9.5	87	6.1
1013	almaty_obl	Алматы облысы	2026-04-13 16:06:34+00	2	21	29	3
1014	atyrau	Атырау облысы	2026-04-13 16:06:34+00	6	11	53	14.4
1015	east_kz	Шығыс Қазақстан облысы	2026-04-13 16:06:34+00	43	20.5	19	2
1016	zhambyl	Жамбыл облысы	2026-04-13 16:06:34+00	2	21	29	3
1017	west_kz	Батыс Қазақстан облысы	2026-04-13 16:06:34+00	16	11	53	14.4
1018	karaganda	Қарағанды облысы	2026-04-13 16:06:34+00	5	9.5	87	6.1
1019	kostanay	Қостанай облысы	2026-04-13 16:06:34+00	5	9.5	87	6.1
1020	kyzylorda	Қызылорда облысы	2026-04-13 16:06:34+00	5	9.5	87	6.1
1021	mangystau	Маңғыстау облысы	2026-04-13 16:06:34+00	6	11	53	14.4
1022	north_kz	Солтүстік Қазақстан облысы	2026-04-13 16:06:34+00	5	9.5	87	6.1
1023	pavlodar	Павлодар облысы	2026-04-13 16:06:34+00	5	9.5	87	6.1
1024	turkistan	Түркістан облысы	2026-04-13 16:06:34+00	5	9.5	87	6.1
1025	abay	Абай облысы	2026-04-13 16:06:34+00	43	20.5	19	2
1026	ulytau	Ұлытау облысы	2026-04-13 16:06:34+00	5	9.5	87	6.1
1027	jetisu	Жетісу облысы	2026-04-13 16:06:34+00	2	21	29	3
1028	astana	Astana	2026-04-13 17:00:00+00	5	10	79	6.1
1029	almaty_city	Almaty	2026-04-13 17:00:00+00	2	21	30	3.6
1030	astana	Астана	2026-04-13 17:56:14+00	4	10	76	6.6
1031	almaty_city	Алматы	2026-04-13 17:56:14+00	2	20	28	3.6
1032	shymkent	Шымкент	2026-04-13 17:56:14+00	80	16	44	1.5
1033	akmola	Ақмола облысы	2026-04-13 17:56:14+00	4	10	76	6.6
1034	aktobe	Ақтөбе облысы	2026-04-13 17:56:14+00	4	10	76	6.6
1035	almaty_obl	Алматы облысы	2026-04-13 17:56:14+00	2	20	28	3.6
1036	atyrau	Атырау облысы	2026-04-13 17:56:14+00	6	12	50	13.3
1037	east_kz	Шығыс Қазақстан облысы	2026-04-13 17:56:14+00	39	20.5	19	2
1038	zhambyl	Жамбыл облысы	2026-04-13 17:56:14+00	2	20	28	3.6
1039	west_kz	Батыс Қазақстан облысы	2026-04-13 17:56:14+00	15	12	50	13.3
1040	karaganda	Қарағанды облысы	2026-04-13 17:56:14+00	4	10	76	6.6
1041	kostanay	Қостанай облысы	2026-04-13 17:56:14+00	4	10	76	6.6
1042	kyzylorda	Қызылорда облысы	2026-04-13 17:56:14+00	4	10	76	6.6
1043	mangystau	Маңғыстау облысы	2026-04-13 17:56:14+00	6	12	50	13.3
1044	north_kz	Солтүстік Қазақстан облысы	2026-04-13 17:56:14+00	4	10	76	6.6
1045	pavlodar	Павлодар облысы	2026-04-13 17:56:14+00	4	10	76	6.6
1046	turkistan	Түркістан облысы	2026-04-13 17:56:14+00	4	10	76	6.6
1047	abay	Абай облысы	2026-04-13 17:56:14+00	39	20.5	19	2
1048	ulytau	Ұлытау облысы	2026-04-13 17:56:14+00	4	10	76	6.6
1049	jetisu	Жетісу облысы	2026-04-13 17:56:14+00	2	20	28	3.6
1050	astana	Astana	2026-04-13 18:00:00+00	4	10	76	6.6
1051	almaty_city	Almaty	2026-04-13 18:00:00+00	2	20	28	3.6
1052	astana	Астана	2026-04-13 18:07:16+00	4	10	76	6.6
1053	almaty_city	Алматы	2026-04-13 18:07:16+00	2	20	28	3.6
1054	shymkent	Шымкент	2026-04-13 18:07:16+00	80	16	44	1.5
1055	akmola	Ақмола облысы	2026-04-13 18:07:16+00	4	10	76	6.6
1056	aktobe	Ақтөбе облысы	2026-04-13 18:07:16+00	4	10	76	6.6
1057	almaty_obl	Алматы облысы	2026-04-13 18:07:16+00	2	20	28	3.6
1058	atyrau	Атырау облысы	2026-04-13 18:07:16+00	6	12	50	13.3
1059	east_kz	Шығыс Қазақстан облысы	2026-04-13 18:07:16+00	39	20.5	19	2
1060	zhambyl	Жамбыл облысы	2026-04-13 18:07:16+00	2	20	28	3.6
1061	west_kz	Батыс Қазақстан облысы	2026-04-13 18:07:16+00	15	12	50	13.3
1062	karaganda	Қарағанды облысы	2026-04-13 18:07:16+00	4	10	76	6.6
1063	kostanay	Қостанай облысы	2026-04-13 18:07:16+00	4	10	76	6.6
1064	kyzylorda	Қызылорда облысы	2026-04-13 18:07:16+00	4	10	76	6.6
1065	mangystau	Маңғыстау облысы	2026-04-13 18:07:16+00	6	12	50	13.3
1066	north_kz	Солтүстік Қазақстан облысы	2026-04-13 18:07:16+00	4	10	76	6.6
1067	pavlodar	Павлодар облысы	2026-04-13 18:07:16+00	4	10	76	6.6
1068	turkistan	Түркістан облысы	2026-04-13 18:07:16+00	4	10	76	6.6
1069	abay	Абай облысы	2026-04-13 18:07:16+00	39	20.5	19	2
1070	ulytau	Ұлытау облысы	2026-04-13 18:07:16+00	4	10	76	6.6
1071	jetisu	Жетісу облысы	2026-04-13 18:07:16+00	2	20	28	3.6
1072	astana	Астана	2026-04-13 18:09:46+00	4	10	76	6.6
1073	almaty_city	Алматы	2026-04-13 18:09:46+00	2	20	28	3.6
1074	shymkent	Шымкент	2026-04-13 18:09:46+00	80	16	44	1.5
1075	akmola	Ақмола облысы	2026-04-13 18:09:46+00	4	10	76	6.6
1076	aktobe	Ақтөбе облысы	2026-04-13 18:09:46+00	4	10	76	6.6
1077	almaty_obl	Алматы облысы	2026-04-13 18:09:46+00	2	20	28	3.6
1078	atyrau	Атырау облысы	2026-04-13 18:09:46+00	6	10	49	15.4
1079	east_kz	Шығыс Қазақстан облысы	2026-04-13 18:09:46+00	39	20.5	19	2
1080	zhambyl	Жамбыл облысы	2026-04-13 18:09:46+00	2	20	28	3.6
1081	west_kz	Батыс Қазақстан облысы	2026-04-13 18:09:46+00	15	10	49	15.4
1082	karaganda	Қарағанды облысы	2026-04-13 18:09:46+00	4	10	76	6.6
1083	kostanay	Қостанай облысы	2026-04-13 18:09:46+00	4	10	76	6.6
1084	kyzylorda	Қызылорда облысы	2026-04-13 18:09:46+00	4	10	76	6.6
1085	mangystau	Маңғыстау облысы	2026-04-13 18:09:46+00	6	10	49	15.4
1086	north_kz	Солтүстік Қазақстан облысы	2026-04-13 18:09:46+00	4	10	76	6.6
1087	pavlodar	Павлодар облысы	2026-04-13 18:09:46+00	4	10	76	6.6
1088	turkistan	Түркістан облысы	2026-04-13 18:09:46+00	4	10	76	6.6
1089	abay	Абай облысы	2026-04-13 18:09:46+00	39	20.5	19	2
1090	ulytau	Ұлытау облысы	2026-04-13 18:09:46+00	4	10	76	6.6
1091	jetisu	Жетісу облысы	2026-04-13 18:09:46+00	2	20	28	3.6
1092	astana	Астана	2026-04-13 18:31:13+00	4	10	76	4.6
1093	almaty_city	Алматы	2026-04-13 18:31:13+00	2	20	34	1.5
1094	shymkent	Шымкент	2026-04-13 18:31:13+00	95	15	47	2.5
1095	akmola	Ақмола облысы	2026-04-13 18:31:13+00	4	10	76	4.6
1096	aktobe	Ақтөбе облысы	2026-04-13 18:31:13+00	4	10	76	4.6
1097	almaty_obl	Алматы облысы	2026-04-13 18:31:13+00	2	20	34	1.5
1098	atyrau	Атырау облысы	2026-04-13 18:31:13+00	6	10	49	15.4
1099	east_kz	Шығыс Қазақстан облысы	2026-04-13 18:31:13+00	44	20.5	19	2
1100	zhambyl	Жамбыл облысы	2026-04-13 18:31:13+00	2	20	34	1.5
1101	west_kz	Батыс Қазақстан облысы	2026-04-13 18:31:13+00	15	10	49	15.4
1102	karaganda	Қарағанды облысы	2026-04-13 18:31:13+00	4	10	76	4.6
1103	kostanay	Қостанай облысы	2026-04-13 18:31:13+00	4	10	76	4.6
1104	kyzylorda	Қызылорда облысы	2026-04-13 18:31:13+00	4	10	76	4.6
1105	mangystau	Маңғыстау облысы	2026-04-13 18:31:13+00	6	10	49	15.4
1106	north_kz	Солтүстік Қазақстан облысы	2026-04-13 18:31:13+00	4	10	76	4.6
1107	pavlodar	Павлодар облысы	2026-04-13 18:31:13+00	4	10	76	4.6
1108	turkistan	Түркістан облысы	2026-04-13 18:31:13+00	4	10	76	4.6
1109	abay	Абай облысы	2026-04-13 18:31:13+00	44	20.5	19	2
1110	ulytau	Ұлытау облысы	2026-04-13 18:31:13+00	4	10	76	4.6
1111	jetisu	Жетісу облысы	2026-04-13 18:31:13+00	2	20	34	1.5
1112	astana	Astana	2026-04-13 19:00:00+00	4	10	76	4.6
1113	almaty_city	Almaty	2026-04-13 19:00:00+00	2	20	34	1.5
1114	astana	Astana	2026-04-14 14:58:02+00	3	12	39	1
1115	almaty_city	Алматы	2026-04-14 14:58:02+00	2	22	21	3.6
1116	astana	Astana	2026-04-14 15:00:00+00	3	12	39	1
1117	almaty_city	Almaty	2026-04-14 15:00:00+00	2	22	21	3.6
1118	astana	Астана	2026-04-14 15:50:04+00	4	12	37	1.5
1119	almaty_city	Алматы	2026-04-14 15:50:04+00	2	22	17	1.5
1120	shymkent	Шымкент	2026-04-14 15:50:04+00	55	23	17	2.5
1121	akmola	Ақмола облысы	2026-04-14 15:50:04+00	4	12	37	1.5
1122	aktobe	Ақтөбе облысы	2026-04-14 15:50:04+00	4	12	37	1.5
1123	almaty_obl	Алматы облысы	2026-04-14 15:50:04+00	2	22	17	1.5
1124	atyrau	Атырау облысы	2026-04-14 15:50:04+00	5	13	22	11.3
1125	east_kz	Шығыс Қазақстан облысы	2026-04-14 15:50:04+00	39	18.6	26	4
1126	zhambyl	Жамбыл облысы	2026-04-14 15:50:04+00	2	22	17	1.5
1127	west_kz	Батыс Қазақстан облысы	2026-04-14 15:50:04+00	14	13	22	11.3
1128	karaganda	Қарағанды облысы	2026-04-14 15:50:04+00	4	12	37	1.5
1129	kostanay	Қостанай облысы	2026-04-14 15:50:04+00	4	12	37	1.5
1130	kyzylorda	Қызылорда облысы	2026-04-14 15:50:04+00	4	12	37	1.5
1131	mangystau	Маңғыстау облысы	2026-04-14 15:50:04+00	5	13	22	11.3
1132	north_kz	Солтүстік Қазақстан облысы	2026-04-14 15:50:04+00	4	12	37	1.5
1133	pavlodar	Павлодар облысы	2026-04-14 15:50:04+00	4	12	37	1.5
1134	turkistan	Түркістан облысы	2026-04-14 15:50:04+00	4	12	37	1.5
1135	abay	Абай облысы	2026-04-14 15:50:04+00	39	18.6	26	4
1136	ulytau	Ұлытау облысы	2026-04-14 15:50:04+00	4	12	37	1.5
1137	jetisu	Жетісу облысы	2026-04-14 15:50:04+00	2	22	17	1.5
1138	astana	Астана	2026-04-14 15:56:34+00	4	12	37	1.5
1139	almaty_city	Алматы	2026-04-14 15:56:34+00	2	22	17	1.5
1140	shymkent	Шымкент	2026-04-14 15:56:34+00	55	23	17	2.5
1141	akmola	Ақмола облысы	2026-04-14 15:56:34+00	4	12	37	1.5
1142	aktobe	Ақтөбе облысы	2026-04-14 15:56:34+00	4	12	37	1.5
1143	almaty_obl	Алматы облысы	2026-04-14 15:56:34+00	2	22	17	1.5
1144	atyrau	Атырау облысы	2026-04-14 15:56:34+00	5	13	22	11.3
1145	east_kz	Шығыс Қазақстан облысы	2026-04-14 15:56:34+00	39	18.6	26	4
1146	zhambyl	Жамбыл облысы	2026-04-14 15:56:34+00	2	22	17	1.5
1147	west_kz	Батыс Қазақстан облысы	2026-04-14 15:56:34+00	14	13	22	11.3
1148	karaganda	Қарағанды облысы	2026-04-14 15:56:34+00	4	12	37	1.5
1149	kostanay	Қостанай облысы	2026-04-14 15:56:34+00	4	12	37	1.5
1150	kyzylorda	Қызылорда облысы	2026-04-14 15:56:34+00	4	12	37	1.5
1151	mangystau	Маңғыстау облысы	2026-04-14 15:56:34+00	5	13	22	11.3
1152	north_kz	Солтүстік Қазақстан облысы	2026-04-14 15:56:34+00	4	12	37	1.5
1153	pavlodar	Павлодар облысы	2026-04-14 15:56:34+00	4	12	37	1.5
1154	turkistan	Түркістан облысы	2026-04-14 15:56:34+00	4	12	37	1.5
1155	abay	Абай облысы	2026-04-14 15:56:34+00	39	18.6	26	4
1156	ulytau	Ұлытау облысы	2026-04-14 15:56:34+00	4	12	37	1.5
1157	jetisu	Жетісу облысы	2026-04-14 15:56:34+00	2	22	17	1.5
1158	astana	Астана	2026-04-14 15:58:35+00	4	12	37	1.5
1159	almaty_city	Алматы	2026-04-14 15:58:35+00	2	22	17	1.5
1160	shymkent	Шымкент	2026-04-14 15:58:35+00	55	23	17	2.5
1161	akmola	Ақмола облысы	2026-04-14 15:58:35+00	4	12	37	1.5
1162	aktobe	Ақтөбе облысы	2026-04-14 15:58:35+00	4	12	37	1.5
1163	almaty_obl	Алматы облысы	2026-04-14 15:58:35+00	2	22	17	1.5
1164	atyrau	Атырау облысы	2026-04-14 15:58:35+00	5	13	22	11.3
1165	east_kz	Шығыс Қазақстан облысы	2026-04-14 15:58:35+00	39	18.6	26	4
1166	zhambyl	Жамбыл облысы	2026-04-14 15:58:35+00	2	22	17	1.5
1167	west_kz	Батыс Қазақстан облысы	2026-04-14 15:58:35+00	14	13	22	11.3
1168	karaganda	Қарағанды облысы	2026-04-14 15:58:35+00	4	12	37	1.5
1169	kostanay	Қостанай облысы	2026-04-14 15:58:35+00	4	12	37	1.5
1461	abay	Абай облысы	2026-04-25 09:55:12+00	51	18.1	66	1
1170	kyzylorda	Қызылорда облысы	2026-04-14 15:58:35+00	4	12	37	1.5
1171	mangystau	Маңғыстау облысы	2026-04-14 15:58:35+00	5	13	22	11.3
1172	north_kz	Солтүстік Қазақстан облысы	2026-04-14 15:58:35+00	4	12	37	1.5
1173	pavlodar	Павлодар облысы	2026-04-14 15:58:35+00	4	12	37	1.5
1174	turkistan	Түркістан облысы	2026-04-14 15:58:35+00	4	12	37	1.5
1175	abay	Абай облысы	2026-04-14 15:58:35+00	39	18.6	26	4
1176	ulytau	Ұлытау облысы	2026-04-14 15:58:35+00	4	12	37	1.5
1177	jetisu	Жетісу облысы	2026-04-14 15:58:35+00	2	22	17	1.5
1178	astana	Астана	2026-04-14 16:00:00+00	4	12	37	1.5
1179	almaty_city	Алматы	2026-04-14 16:00:00+00	2	22	17	1.5
1180	shymkent	Шымкент	2026-04-14 16:00:00+00	55	23	17	2.5
1181	akmola	Ақмола облысы	2026-04-14 16:00:00+00	4	12	37	1.5
1182	aktobe	Ақтөбе облысы	2026-04-14 16:00:00+00	4	12	37	1.5
1183	almaty_obl	Алматы облысы	2026-04-14 16:00:00+00	2	22	17	1.5
1184	atyrau	Атырау облысы	2026-04-14 16:00:00+00	5	13	22	11.3
1185	east_kz	Шығыс Қазақстан облысы	2026-04-14 16:00:00+00	39	18.6	26	4
1186	zhambyl	Жамбыл облысы	2026-04-14 16:00:00+00	2	22	17	1.5
1187	west_kz	Батыс Қазақстан облысы	2026-04-14 16:00:00+00	14	13	22	11.3
1188	karaganda	Қарағанды облысы	2026-04-14 16:00:00+00	4	12	37	1.5
1189	kostanay	Қостанай облысы	2026-04-14 16:00:00+00	4	12	37	1.5
1190	kyzylorda	Қызылорда облысы	2026-04-14 16:00:00+00	4	12	37	1.5
1191	mangystau	Маңғыстау облысы	2026-04-14 16:00:00+00	5	13	22	11.3
1192	north_kz	Солтүстік Қазақстан облысы	2026-04-14 16:00:00+00	4	12	37	1.5
1193	pavlodar	Павлодар облысы	2026-04-14 16:00:00+00	4	12	37	1.5
1194	turkistan	Түркістан облысы	2026-04-14 16:00:00+00	4	12	37	1.5
1195	abay	Абай облысы	2026-04-14 16:00:00+00	39	18.6	26	4
1196	ulytau	Ұлытау облысы	2026-04-14 16:00:00+00	4	12	37	1.5
1197	jetisu	Жетісу облысы	2026-04-14 16:00:00+00	2	22	17	1.5
1198	astana	Астана	2026-04-14 16:02:01+00	4	12	37	1.5
1199	almaty_city	Алматы	2026-04-14 16:02:01+00	2	22	17	1.5
1200	shymkent	Шымкент	2026-04-14 16:02:01+00	55	23	17	2.5
1201	akmola	Ақмола облысы	2026-04-14 16:02:01+00	4	12	37	1.5
1202	aktobe	Ақтөбе облысы	2026-04-14 16:02:01+00	4	12	37	1.5
1203	almaty_obl	Алматы облысы	2026-04-14 16:02:01+00	2	22	17	1.5
1204	atyrau	Атырау облысы	2026-04-14 16:02:01+00	5	13	22	11.3
1205	east_kz	Шығыс Қазақстан облысы	2026-04-14 16:02:01+00	39	18.6	26	4
1206	zhambyl	Жамбыл облысы	2026-04-14 16:02:01+00	2	22	17	1.5
1207	west_kz	Батыс Қазақстан облысы	2026-04-14 16:02:01+00	14	13	22	11.3
1208	karaganda	Қарағанды облысы	2026-04-14 16:02:01+00	4	12	37	1.5
1209	kostanay	Қостанай облысы	2026-04-14 16:02:01+00	4	12	37	1.5
1210	kyzylorda	Қызылорда облысы	2026-04-14 16:02:01+00	4	12	37	1.5
1211	mangystau	Маңғыстау облысы	2026-04-14 16:02:01+00	5	13	22	11.3
1212	north_kz	Солтүстік Қазақстан облысы	2026-04-14 16:02:01+00	4	12	37	1.5
1213	pavlodar	Павлодар облысы	2026-04-14 16:02:01+00	4	12	37	1.5
1214	turkistan	Түркістан облысы	2026-04-14 16:02:01+00	4	12	37	1.5
1215	abay	Абай облысы	2026-04-14 16:02:01+00	39	18.6	26	4
1216	ulytau	Ұлытау облысы	2026-04-14 16:02:01+00	4	12	37	1.5
1217	jetisu	Жетісу облысы	2026-04-14 16:02:01+00	2	22	17	1.5
1218	astana	Astana	2026-04-14 16:12:36+00	4	12	37	1.5
1219	almaty_city	Almaty	2026-04-14 16:12:36+00	2	22	17	1.5
1220	astana	Астана	2026-04-14 16:26:59+00	4	12	37	1.5
1221	almaty_city	Алматы	2026-04-14 16:26:59+00	2	22	17	1.5
1222	shymkent	Шымкент	2026-04-14 16:26:59+00	55	23	17	2.5
1223	akmola	Ақмола облысы	2026-04-14 16:26:59+00	4	12	37	1.5
1224	aktobe	Ақтөбе облысы	2026-04-14 16:26:59+00	4	12	37	1.5
1225	almaty_obl	Алматы облысы	2026-04-14 16:26:59+00	2	22	17	1.5
1226	atyrau	Атырау облысы	2026-04-14 16:26:59+00	5	13	24	11.8
1227	east_kz	Шығыс Қазақстан облысы	2026-04-14 16:26:59+00	41	18.6	26	4
1228	zhambyl	Жамбыл облысы	2026-04-14 16:26:59+00	2	22	17	1.5
1229	west_kz	Батыс Қазақстан облысы	2026-04-14 16:26:59+00	14	13	24	11.8
1230	karaganda	Қарағанды облысы	2026-04-14 16:26:59+00	4	12	37	1.5
1231	kostanay	Қостанай облысы	2026-04-14 16:26:59+00	4	12	37	1.5
1232	kyzylorda	Қызылорда облысы	2026-04-14 16:26:59+00	4	12	37	1.5
1233	mangystau	Маңғыстау облысы	2026-04-14 16:26:59+00	5	13	24	11.8
1234	north_kz	Солтүстік Қазақстан облысы	2026-04-14 16:26:59+00	4	12	37	1.5
1235	pavlodar	Павлодар облысы	2026-04-14 16:26:59+00	4	12	37	1.5
1236	turkistan	Түркістан облысы	2026-04-14 16:26:59+00	4	12	37	1.5
1237	abay	Абай облысы	2026-04-14 16:26:59+00	41	18.6	26	4
1238	ulytau	Ұлытау облысы	2026-04-14 16:26:59+00	4	12	37	1.5
1239	jetisu	Жетісу облысы	2026-04-14 16:26:59+00	2	22	17	1.5
1240	astana	Астана	2026-04-24 21:50:49+00	6	18	42	2.5
1241	almaty_city	Алматы	2026-04-24 21:50:49+00	3	17	72	2.5
1242	shymkent	Шымкент	2026-04-24 21:50:49+00	12	26.9	31	2
1243	akmola	Ақмола облысы	2026-04-24 21:50:49+00	6	18	42	2.5
1244	aktobe	Ақтөбе облысы	2026-04-24 21:50:49+00	6	18	42	2.5
1245	almaty_obl	Алматы облысы	2026-04-24 21:50:49+00	3	17	72	2.5
1246	atyrau	Атырау облысы	2026-04-24 21:50:49+00	20	10.5	71	3
1247	east_kz	Шығыс Қазақстан облысы	2026-04-24 21:50:49+00	39	15.6	80	1
1248	zhambyl	Жамбыл облысы	2026-04-24 21:50:49+00	12	26.9	31	2
1249	west_kz	Батыс Қазақстан облысы	2026-04-24 21:50:49+00	28	10.5	71	3
1250	karaganda	Қарағанды облысы	2026-04-24 21:50:49+00	6	18	42	2.5
1251	kostanay	Қостанай облысы	2026-04-24 21:50:49+00	6	18	42	2.5
1252	kyzylorda	Қызылорда облысы	2026-04-24 21:50:49+00	12	26.9	31	2
1253	mangystau	Маңғыстау облысы	2026-04-24 21:50:49+00	20	10.5	71	3
1254	north_kz	Солтүстік Қазақстан облысы	2026-04-24 21:50:49+00	6	18	42	2.5
1255	pavlodar	Павлодар облысы	2026-04-24 21:50:49+00	6	18	42	2.5
1256	turkistan	Түркістан облысы	2026-04-24 21:50:49+00	12	26.9	31	2
1257	abay	Абай облысы	2026-04-24 21:50:49+00	39	15.6	80	1
1258	ulytau	Ұлытау облысы	2026-04-24 21:50:49+00	6	18	42	2.5
1259	jetisu	Жетісу облысы	2026-04-24 21:50:49+00	3	17	72	2.5
1260	astana	Астана	2026-04-24 21:59:40+00	7	12	76	2.5
1261	almaty_city	Алматы	2026-04-24 21:59:40+00	5	14.5	85	0.7
1262	shymkent	Шымкент	2026-04-24 21:59:40+00	12	26.9	31	2
1263	akmola	Ақмола облысы	2026-04-24 21:59:40+00	7	12	76	2.5
1264	aktobe	Ақтөбе облысы	2026-04-24 21:59:40+00	7	12	76	2.5
1265	almaty_obl	Алматы облысы	2026-04-24 21:59:40+00	5	14.5	85	0.7
1266	atyrau	Атырау облысы	2026-04-24 21:59:40+00	20	10.5	71	3
1267	east_kz	Шығыс Қазақстан облысы	2026-04-24 21:59:40+00	39	15.6	80	1
1268	zhambyl	Жамбыл облысы	2026-04-24 21:59:40+00	12	26.9	31	2
1269	west_kz	Батыс Қазақстан облысы	2026-04-24 21:59:40+00	28	10.5	71	3
1270	karaganda	Қарағанды облысы	2026-04-24 21:59:40+00	7	12	76	2.5
1271	kostanay	Қостанай облысы	2026-04-24 21:59:40+00	7	12	76	2.5
1272	kyzylorda	Қызылорда облысы	2026-04-24 21:59:40+00	12	26.9	31	2
1273	mangystau	Маңғыстау облысы	2026-04-24 21:59:40+00	20	10.5	71	3
1274	north_kz	Солтүстік Қазақстан облысы	2026-04-24 21:59:40+00	7	12	76	2.5
1275	pavlodar	Павлодар облысы	2026-04-24 21:59:40+00	7	12	76	2.5
1276	turkistan	Түркістан облысы	2026-04-24 21:59:40+00	12	26.9	31	2
1277	abay	Абай облысы	2026-04-24 21:59:40+00	39	15.6	80	1
1278	ulytau	Ұлытау облысы	2026-04-24 21:59:40+00	7	12	76	2.5
1279	jetisu	Жетісу облысы	2026-04-24 21:59:40+00	5	14.5	85	0.7
1280	astana	Astana	2026-04-24 22:00:00+00	7	12	76	2.5
1281	almaty_city	Almaty	2026-04-24 22:00:00+00	5	14.5	85	0.7
1282	astana	Астана	2026-04-24 22:16:04+00	7	12	76	2.5
1283	almaty_city	Алматы	2026-04-24 22:16:04+00	5	14.5	85	0.7
1284	shymkent	Шымкент	2026-04-24 22:16:04+00	12	26.9	31	2
1285	akmola	Ақмола облысы	2026-04-24 22:16:04+00	7	12	76	2.5
1286	aktobe	Ақтөбе облысы	2026-04-24 22:16:04+00	7	12	76	2.5
1287	almaty_obl	Алматы облысы	2026-04-24 22:16:04+00	5	14.5	85	0.7
1288	atyrau	Атырау облысы	2026-04-24 22:16:04+00	20	10.5	71	3
1289	east_kz	Шығыс Қазақстан облысы	2026-04-24 22:16:04+00	39	15.6	80	1
1290	zhambyl	Жамбыл облысы	2026-04-24 22:16:04+00	12	26.9	31	2
1291	west_kz	Батыс Қазақстан облысы	2026-04-24 22:16:04+00	28	10.5	71	3
1292	karaganda	Қарағанды облысы	2026-04-24 22:16:04+00	7	12	76	2.5
1293	kostanay	Қостанай облысы	2026-04-24 22:16:04+00	7	12	76	2.5
1294	kyzylorda	Қызылорда облысы	2026-04-24 22:16:04+00	12	26.9	31	2
1295	mangystau	Маңғыстау облысы	2026-04-24 22:16:04+00	20	10.5	71	3
1296	north_kz	Солтүстік Қазақстан облысы	2026-04-24 22:16:04+00	7	12	76	2.5
1297	pavlodar	Павлодар облысы	2026-04-24 22:16:04+00	7	12	76	2.5
1298	turkistan	Түркістан облысы	2026-04-24 22:16:04+00	12	26.9	31	2
1299	abay	Абай облысы	2026-04-24 22:16:04+00	39	15.6	80	1
1300	ulytau	Ұлытау облысы	2026-04-24 22:16:04+00	7	12	76	2.5
1301	jetisu	Жетісу облысы	2026-04-24 22:16:04+00	5	14.5	85	0.7
1302	astana	Астана	2026-04-24 22:19:57+00	7	12	76	2.5
1303	almaty_city	Алматы	2026-04-24 22:19:57+00	5	14.5	85	0.7
1304	shymkent	Шымкент	2026-04-24 22:19:57+00	12	26.9	31	2
1305	akmola	Ақмола облысы	2026-04-24 22:19:57+00	7	12	76	2.5
1306	aktobe	Ақтөбе облысы	2026-04-24 22:19:57+00	7	12	76	2.5
1307	almaty_obl	Алматы облысы	2026-04-24 22:19:57+00	5	14.5	85	0.7
1308	atyrau	Атырау облысы	2026-04-24 22:19:57+00	20	10.5	71	3
1309	east_kz	Шығыс Қазақстан облысы	2026-04-24 22:19:57+00	48	15.6	80	1
1310	zhambyl	Жамбыл облысы	2026-04-24 22:19:57+00	12	26.9	31	2
1311	west_kz	Батыс Қазақстан облысы	2026-04-24 22:19:57+00	28	10.5	71	3
1312	karaganda	Қарағанды облысы	2026-04-24 22:19:57+00	7	12	76	2.5
1313	kostanay	Қостанай облысы	2026-04-24 22:19:57+00	7	12	76	2.5
1314	kyzylorda	Қызылорда облысы	2026-04-24 22:19:57+00	12	26.9	31	2
1315	mangystau	Маңғыстау облысы	2026-04-24 22:19:57+00	20	10.5	71	3
1316	north_kz	Солтүстік Қазақстан облысы	2026-04-24 22:19:57+00	7	12	76	2.5
1317	pavlodar	Павлодар облысы	2026-04-24 22:19:57+00	7	12	76	2.5
1318	turkistan	Түркістан облысы	2026-04-24 22:19:57+00	12	26.9	31	2
1319	abay	Абай облысы	2026-04-24 22:19:57+00	48	15.6	80	1
1320	ulytau	Ұлытау облысы	2026-04-24 22:19:57+00	7	12	76	2.5
1321	jetisu	Жетісу облысы	2026-04-24 22:19:57+00	5	14.5	85	0.7
1322	astana	Astana	2026-04-25 08:57:19+00	5	15.5	63	6.6
1323	almaty_city	Алматы	2026-04-25 08:57:19+00	1	12.5	99	0.3
1324	shymkent	Шымкент	2026-04-25 08:57:19+00	7	16.5	44	3
1325	akmola	Ақмола облысы	2026-04-25 08:57:19+00	5	15.5	63	6.6
1326	aktobe	Ақтөбе облысы	2026-04-25 08:57:19+00	5	15.5	63	6.6
1327	almaty_obl	Алматы облысы	2026-04-25 08:57:19+00	1	12.5	99	0.3
1328	atyrau	Атырау облысы	2026-04-25 08:57:19+00	33	7	70	8.2
1329	east_kz	Шығыс Қазақстан облысы	2026-04-25 08:57:19+00	39	7	90	1
1330	zhambyl	Жамбыл облысы	2026-04-25 08:57:19+00	7	16.5	44	3
1331	west_kz	Батыс Қазақстан облысы	2026-04-25 08:57:19+00	24	7	70	8.2
1332	karaganda	Қарағанды облысы	2026-04-25 08:57:19+00	5	15.5	63	6.6
1333	kostanay	Қостанай облысы	2026-04-25 08:57:19+00	5	15.5	63	6.6
1334	kyzylorda	Қызылорда облысы	2026-04-25 08:57:19+00	7	16.5	44	3
1335	mangystau	Маңғыстау облысы	2026-04-25 08:57:19+00	33	7	70	8.2
1336	north_kz	Солтүстік Қазақстан облысы	2026-04-25 08:57:19+00	5	15.5	63	6.6
1337	pavlodar	Павлодар облысы	2026-04-25 08:57:19+00	5	15.5	63	6.6
1338	turkistan	Түркістан облысы	2026-04-25 08:57:19+00	7	16.5	44	3
1339	abay	Абай облысы	2026-04-25 08:57:19+00	39	7	90	1
1340	ulytau	Ұлытау облысы	2026-04-25 08:57:19+00	5	15.5	63	6.6
1341	jetisu	Жетісу облысы	2026-04-25 08:57:19+00	1	12.5	99	0.3
1342	astana	Astana	2026-04-25 09:00:00+00	5	15.5	63	6.6
1343	almaty_city	Almaty	2026-04-25 09:00:00+00	1	12.5	99	0.3
1344	astana	Астана	2026-04-25 09:12:36+00	5	17.5	59	7.2
1345	almaty_city	Алматы	2026-04-25 09:12:36+00	2	15	84	1.2
1346	shymkent	Шымкент	2026-04-25 09:12:36+00	23	16.5	44	3
1347	akmola	Ақмола облысы	2026-04-25 09:12:36+00	5	17.5	59	7.2
1348	aktobe	Ақтөбе облысы	2026-04-25 09:12:36+00	5	17.5	59	7.2
1349	almaty_obl	Алматы облысы	2026-04-25 09:12:36+00	2	15	84	1.2
1350	atyrau	Атырау облысы	2026-04-25 09:12:36+00	33	7	70	8.2
1351	east_kz	Шығыс Қазақстан облысы	2026-04-25 09:12:36+00	39	7	90	1
1352	zhambyl	Жамбыл облысы	2026-04-25 09:12:36+00	23	16.5	44	3
1353	west_kz	Батыс Қазақстан облысы	2026-04-25 09:12:36+00	24	7	70	8.2
1354	karaganda	Қарағанды облысы	2026-04-25 09:12:36+00	5	17.5	59	7.2
1355	kostanay	Қостанай облысы	2026-04-25 09:12:36+00	5	17.5	59	7.2
1356	kyzylorda	Қызылорда облысы	2026-04-25 09:12:36+00	23	16.5	44	3
1357	mangystau	Маңғыстау облысы	2026-04-25 09:12:36+00	33	7	70	8.2
1358	north_kz	Солтүстік Қазақстан облысы	2026-04-25 09:12:36+00	5	17.5	59	7.2
1359	pavlodar	Павлодар облысы	2026-04-25 09:12:36+00	5	17.5	59	7.2
1360	turkistan	Түркістан облысы	2026-04-25 09:12:36+00	23	16.5	44	3
1361	abay	Абай облысы	2026-04-25 09:12:36+00	39	7	90	1
1362	ulytau	Ұлытау облысы	2026-04-25 09:12:36+00	5	17.5	59	7.2
1363	jetisu	Жетісу облысы	2026-04-25 09:12:36+00	2	15	84	1.2
1364	astana	Астана	2026-04-25 09:26:07+00	5	17.5	59	7.2
1365	almaty_city	Алматы	2026-04-25 09:26:07+00	2	15	84	1.2
1366	shymkent	Шымкент	2026-04-25 09:26:07+00	23	16.5	44	3
1367	akmola	Ақмола облысы	2026-04-25 09:26:07+00	5	17.5	59	7.2
1368	aktobe	Ақтөбе облысы	2026-04-25 09:26:07+00	5	17.5	59	7.2
1369	almaty_obl	Алматы облысы	2026-04-25 09:26:07+00	2	15	84	1.2
1370	atyrau	Атырау облысы	2026-04-25 09:26:07+00	33	7	70	8.2
1371	east_kz	Шығыс Қазақстан облысы	2026-04-25 09:26:07+00	51	18.1	66	1
1372	zhambyl	Жамбыл облысы	2026-04-25 09:26:07+00	23	16.5	44	3
1373	west_kz	Батыс Қазақстан облысы	2026-04-25 09:26:07+00	24	7	70	8.2
1374	karaganda	Қарағанды облысы	2026-04-25 09:26:07+00	5	17.5	59	7.2
1375	kostanay	Қостанай облысы	2026-04-25 09:26:07+00	5	17.5	59	7.2
1376	kyzylorda	Қызылорда облысы	2026-04-25 09:26:07+00	23	16.5	44	3
1377	mangystau	Маңғыстау облысы	2026-04-25 09:26:07+00	33	7	70	8.2
1378	north_kz	Солтүстік Қазақстан облысы	2026-04-25 09:26:07+00	5	17.5	59	7.2
1379	pavlodar	Павлодар облысы	2026-04-25 09:26:07+00	5	17.5	59	7.2
1380	turkistan	Түркістан облысы	2026-04-25 09:26:07+00	23	16.5	44	3
1381	abay	Абай облысы	2026-04-25 09:26:07+00	51	18.1	66	1
1382	ulytau	Ұлытау облысы	2026-04-25 09:26:07+00	5	17.5	59	7.2
1383	jetisu	Жетісу облысы	2026-04-25 09:26:07+00	2	15	84	1.2
1384	astana	Астана	2026-04-25 09:29:29+00	5	17.5	59	7.2
1385	almaty_city	Алматы	2026-04-25 09:29:29+00	2	15	84	1.2
1386	shymkent	Шымкент	2026-04-25 09:29:29+00	23	16.5	44	3
1387	akmola	Ақмола облысы	2026-04-25 09:29:29+00	5	17.5	59	7.2
1388	aktobe	Ақтөбе облысы	2026-04-25 09:29:29+00	5	17.5	59	7.2
1608	shymkent	Шымкент	2026-04-25 11:04:36+00	35	16.5	44	3
1389	almaty_obl	Алматы облысы	2026-04-25 09:29:29+00	2	15	84	1.2
1390	atyrau	Атырау облысы	2026-04-25 09:29:29+00	33	7	70	8.2
1391	east_kz	Шығыс Қазақстан облысы	2026-04-25 09:29:29+00	51	18.1	66	1
1392	zhambyl	Жамбыл облысы	2026-04-25 09:29:29+00	23	16.5	44	3
1393	west_kz	Батыс Қазақстан облысы	2026-04-25 09:29:29+00	24	7	70	8.2
1394	karaganda	Қарағанды облысы	2026-04-25 09:29:29+00	5	17.5	59	7.2
1395	kostanay	Қостанай облысы	2026-04-25 09:29:29+00	5	17.5	59	7.2
1396	kyzylorda	Қызылорда облысы	2026-04-25 09:29:29+00	23	16.5	44	3
1397	mangystau	Маңғыстау облысы	2026-04-25 09:29:29+00	33	7	70	8.2
1398	north_kz	Солтүстік Қазақстан облысы	2026-04-25 09:29:29+00	5	17.5	59	7.2
1399	pavlodar	Павлодар облысы	2026-04-25 09:29:29+00	5	17.5	59	7.2
1400	turkistan	Түркістан облысы	2026-04-25 09:29:29+00	23	16.5	44	3
1401	abay	Абай облысы	2026-04-25 09:29:29+00	51	18.1	66	1
1402	ulytau	Ұлытау облысы	2026-04-25 09:29:29+00	5	17.5	59	7.2
1403	jetisu	Жетісу облысы	2026-04-25 09:29:29+00	2	15	84	1.2
1404	astana	Астана	2026-04-25 09:33:52+00	5	17.5	59	7.2
1405	almaty_city	Алматы	2026-04-25 09:33:52+00	2	15	84	1.2
1406	shymkent	Шымкент	2026-04-25 09:33:52+00	23	16.5	44	3
1407	akmola	Ақмола облысы	2026-04-25 09:33:52+00	5	17.5	59	7.2
1408	aktobe	Ақтөбе облысы	2026-04-25 09:33:52+00	5	17.5	59	7.2
1409	almaty_obl	Алматы облысы	2026-04-25 09:33:52+00	2	15	84	1.2
1410	atyrau	Атырау облысы	2026-04-25 09:33:52+00	33	7	70	8.2
1411	east_kz	Шығыс Қазақстан облысы	2026-04-25 09:33:52+00	51	18.1	66	1
1412	zhambyl	Жамбыл облысы	2026-04-25 09:33:52+00	23	16.5	44	3
1413	west_kz	Батыс Қазақстан облысы	2026-04-25 09:33:52+00	24	7	70	8.2
1414	karaganda	Қарағанды облысы	2026-04-25 09:33:52+00	5	17.5	59	7.2
1415	kostanay	Қостанай облысы	2026-04-25 09:33:52+00	5	17.5	59	7.2
1416	kyzylorda	Қызылорда облысы	2026-04-25 09:33:52+00	23	16.5	44	3
1417	mangystau	Маңғыстау облысы	2026-04-25 09:33:52+00	33	7	70	8.2
1418	north_kz	Солтүстік Қазақстан облысы	2026-04-25 09:33:52+00	5	17.5	59	7.2
1419	pavlodar	Павлодар облысы	2026-04-25 09:33:52+00	5	17.5	59	7.2
1420	turkistan	Түркістан облысы	2026-04-25 09:33:52+00	23	16.5	44	3
1421	abay	Абай облысы	2026-04-25 09:33:52+00	51	18.1	66	1
1422	ulytau	Ұлытау облысы	2026-04-25 09:33:52+00	5	17.5	59	7.2
1423	jetisu	Жетісу облысы	2026-04-25 09:33:52+00	2	15	84	1.2
1424	astana	Астана	2026-04-25 09:39:52+00	5	17.5	59	7.2
1425	almaty_city	Алматы	2026-04-25 09:39:52+00	2	15	84	1.2
1426	shymkent	Шымкент	2026-04-25 09:39:52+00	23	16.5	44	3
1427	akmola	Ақмола облысы	2026-04-25 09:39:52+00	5	17.5	59	7.2
1428	aktobe	Ақтөбе облысы	2026-04-25 09:39:52+00	5	17.5	59	7.2
1429	almaty_obl	Алматы облысы	2026-04-25 09:39:52+00	2	15	84	1.2
1430	atyrau	Атырау облысы	2026-04-25 09:39:52+00	33	7	70	8.2
1431	east_kz	Шығыс Қазақстан облысы	2026-04-25 09:39:52+00	51	18.1	66	1
1432	zhambyl	Жамбыл облысы	2026-04-25 09:39:52+00	23	16.5	44	3
1433	west_kz	Батыс Қазақстан облысы	2026-04-25 09:39:52+00	24	7	70	8.2
1434	karaganda	Қарағанды облысы	2026-04-25 09:39:52+00	5	17.5	59	7.2
1435	kostanay	Қостанай облысы	2026-04-25 09:39:52+00	5	17.5	59	7.2
1436	kyzylorda	Қызылорда облысы	2026-04-25 09:39:52+00	23	16.5	44	3
1437	mangystau	Маңғыстау облысы	2026-04-25 09:39:52+00	33	7	70	8.2
1438	north_kz	Солтүстік Қазақстан облысы	2026-04-25 09:39:52+00	5	17.5	59	7.2
1439	pavlodar	Павлодар облысы	2026-04-25 09:39:52+00	5	17.5	59	7.2
1440	turkistan	Түркістан облысы	2026-04-25 09:39:52+00	23	16.5	44	3
1441	abay	Абай облысы	2026-04-25 09:39:52+00	51	18.1	66	1
1442	ulytau	Ұлытау облысы	2026-04-25 09:39:52+00	5	17.5	59	7.2
1443	jetisu	Жетісу облысы	2026-04-25 09:39:52+00	2	15	84	1.2
1444	astana	Астана	2026-04-25 09:55:12+00	5	17.5	59	7.2
1445	almaty_city	Алматы	2026-04-25 09:55:12+00	2	15	84	1.2
1446	shymkent	Шымкент	2026-04-25 09:55:12+00	23	16.5	44	3
1447	akmola	Ақмола облысы	2026-04-25 09:55:12+00	5	17.5	59	7.2
1448	aktobe	Ақтөбе облысы	2026-04-25 09:55:12+00	5	17.5	59	7.2
1449	almaty_obl	Алматы облысы	2026-04-25 09:55:12+00	2	15	84	1.2
1450	atyrau	Атырау облысы	2026-04-25 09:55:12+00	34	10.5	57	5.9
1451	east_kz	Шығыс Қазақстан облысы	2026-04-25 09:55:12+00	51	18.1	66	1
1452	zhambyl	Жамбыл облысы	2026-04-25 09:55:12+00	23	16.5	44	3
1453	west_kz	Батыс Қазақстан облысы	2026-04-25 09:55:12+00	24	10.5	57	5.9
1454	karaganda	Қарағанды облысы	2026-04-25 09:55:12+00	5	17.5	59	7.2
1455	kostanay	Қостанай облысы	2026-04-25 09:55:12+00	5	17.5	59	7.2
1456	kyzylorda	Қызылорда облысы	2026-04-25 09:55:12+00	23	16.5	44	3
1457	mangystau	Маңғыстау облысы	2026-04-25 09:55:12+00	34	10.5	57	5.9
1458	north_kz	Солтүстік Қазақстан облысы	2026-04-25 09:55:12+00	5	17.5	59	7.2
1459	pavlodar	Павлодар облысы	2026-04-25 09:55:12+00	5	17.5	59	7.2
1460	turkistan	Түркістан облысы	2026-04-25 09:55:12+00	23	16.5	44	3
1462	ulytau	Ұлытау облысы	2026-04-25 09:55:12+00	5	17.5	59	7.2
1463	jetisu	Жетісу облысы	2026-04-25 09:55:12+00	2	15	84	1.2
1464	astana	Astana	2026-04-25 10:00:00+00	5	17.5	59	7.2
1465	almaty_city	Almaty	2026-04-25 10:00:00+00	2	15	84	1.2
1466	astana	Астана	2026-04-25 10:28:36+00	5	17.5	59	7.2
1467	almaty_city	Алматы	2026-04-25 10:28:36+00	2	15	84	1.2
1468	shymkent	Шымкент	2026-04-25 10:28:36+00	35	16.5	44	3
1469	akmola	Ақмола облысы	2026-04-25 10:28:36+00	5	17.5	59	7.2
1470	aktobe	Ақтөбе облысы	2026-04-25 10:28:36+00	5	17.5	59	7.2
1471	almaty_obl	Алматы облысы	2026-04-25 10:28:36+00	2	15	84	1.2
1472	atyrau	Атырау облысы	2026-04-25 10:28:36+00	34	10.5	57	5.9
1473	east_kz	Шығыс Қазақстан облысы	2026-04-25 10:28:36+00	50	18.1	66	1
1474	zhambyl	Жамбыл облысы	2026-04-25 10:28:36+00	35	16.5	44	3
1475	west_kz	Батыс Қазақстан облысы	2026-04-25 10:28:36+00	24	10.5	57	5.9
1476	karaganda	Қарағанды облысы	2026-04-25 10:28:36+00	5	17.5	59	7.2
1477	kostanay	Қостанай облысы	2026-04-25 10:28:36+00	5	17.5	59	7.2
1478	kyzylorda	Қызылорда облысы	2026-04-25 10:28:36+00	35	16.5	44	3
1479	mangystau	Маңғыстау облысы	2026-04-25 10:28:36+00	34	10.5	57	5.9
1480	north_kz	Солтүстік Қазақстан облысы	2026-04-25 10:28:36+00	5	17.5	59	7.2
1481	pavlodar	Павлодар облысы	2026-04-25 10:28:36+00	5	17.5	59	7.2
1482	turkistan	Түркістан облысы	2026-04-25 10:28:36+00	35	16.5	44	3
1483	abay	Абай облысы	2026-04-25 10:28:36+00	50	18.1	66	1
1484	ulytau	Ұлытау облысы	2026-04-25 10:28:36+00	5	17.5	59	7.2
1485	jetisu	Жетісу облысы	2026-04-25 10:28:36+00	2	15	84	1.2
1486	astana	Астана	2026-04-25 10:46:05+00	5	17.5	59	7.2
1487	almaty_city	Алматы	2026-04-25 10:46:05+00	2	15	84	1.2
1488	shymkent	Шымкент	2026-04-25 10:46:05+00	35	16.5	44	3
1489	akmola	Ақмола облысы	2026-04-25 10:46:05+00	5	17.5	59	7.2
1490	aktobe	Ақтөбе облысы	2026-04-25 10:46:05+00	5	17.5	59	7.2
1491	almaty_obl	Алматы облысы	2026-04-25 10:46:05+00	2	15	84	1.2
1492	atyrau	Атырау облысы	2026-04-25 10:46:05+00	35	12	50	10.8
1493	east_kz	Шығыс Қазақстан облысы	2026-04-25 10:46:05+00	50	18.1	66	1
1494	zhambyl	Жамбыл облысы	2026-04-25 10:46:05+00	35	16.5	44	3
1495	west_kz	Батыс Қазақстан облысы	2026-04-25 10:46:05+00	26	12	50	10.8
1496	karaganda	Қарағанды облысы	2026-04-25 10:46:05+00	5	17.5	59	7.2
1497	kostanay	Қостанай облысы	2026-04-25 10:46:05+00	5	17.5	59	7.2
1498	kyzylorda	Қызылорда облысы	2026-04-25 10:46:05+00	35	16.5	44	3
1499	mangystau	Маңғыстау облысы	2026-04-25 10:46:05+00	35	12	50	10.8
1500	north_kz	Солтүстік Қазақстан облысы	2026-04-25 10:46:05+00	5	17.5	59	7.2
1501	pavlodar	Павлодар облысы	2026-04-25 10:46:05+00	5	17.5	59	7.2
1502	turkistan	Түркістан облысы	2026-04-25 10:46:05+00	35	16.5	44	3
1503	abay	Абай облысы	2026-04-25 10:46:05+00	50	18.1	66	1
1504	ulytau	Ұлытау облысы	2026-04-25 10:46:05+00	5	17.5	59	7.2
1505	jetisu	Жетісу облысы	2026-04-25 10:46:05+00	2	15	84	1.2
1506	astana	Астана	2026-04-25 10:49:52+00	6	22	45	7.2
1507	almaty_city	Алматы	2026-04-25 10:49:52+00	2	19.5	64	1.5
1508	shymkent	Шымкент	2026-04-25 10:49:52+00	35	16.5	44	3
1509	akmola	Ақмола облысы	2026-04-25 10:49:52+00	6	22	45	7.2
1510	aktobe	Ақтөбе облысы	2026-04-25 10:49:52+00	6	22	45	7.2
1511	almaty_obl	Алматы облысы	2026-04-25 10:49:52+00	2	19.5	64	1.5
1512	atyrau	Атырау облысы	2026-04-25 10:49:52+00	35	12	50	10.8
1513	east_kz	Шығыс Қазақстан облысы	2026-04-25 10:49:52+00	50	18.1	66	1
1514	zhambyl	Жамбыл облысы	2026-04-25 10:49:52+00	35	16.5	44	3
1515	west_kz	Батыс Қазақстан облысы	2026-04-25 10:49:52+00	26	12	50	10.8
1516	karaganda	Қарағанды облысы	2026-04-25 10:49:52+00	6	22	45	7.2
1517	kostanay	Қостанай облысы	2026-04-25 10:49:52+00	6	22	45	7.2
1518	kyzylorda	Қызылорда облысы	2026-04-25 10:49:52+00	35	16.5	44	3
1519	mangystau	Маңғыстау облысы	2026-04-25 10:49:52+00	35	12	50	10.8
1520	north_kz	Солтүстік Қазақстан облысы	2026-04-25 10:49:52+00	6	22	45	7.2
1521	pavlodar	Павлодар облысы	2026-04-25 10:49:52+00	6	22	45	7.2
1522	turkistan	Түркістан облысы	2026-04-25 10:49:52+00	35	16.5	44	3
1523	abay	Абай облысы	2026-04-25 10:49:52+00	50	18.1	66	1
1524	ulytau	Ұлытау облысы	2026-04-25 10:49:52+00	6	22	45	7.2
1525	jetisu	Жетісу облысы	2026-04-25 10:49:52+00	2	19.5	64	1.5
1526	astana	Астана	2026-04-25 10:52:54+00	6	22	45	7.2
1527	almaty_city	Алматы	2026-04-25 10:52:54+00	2	19.5	64	1.5
1528	shymkent	Шымкент	2026-04-25 10:52:54+00	35	16.5	44	3
1529	akmola	Ақмола облысы	2026-04-25 10:52:54+00	6	22	45	7.2
1530	aktobe	Ақтөбе облысы	2026-04-25 10:52:54+00	6	22	45	7.2
1531	almaty_obl	Алматы облысы	2026-04-25 10:52:54+00	2	19.5	64	1.5
1532	atyrau	Атырау облысы	2026-04-25 10:52:54+00	35	12	50	10.8
1533	east_kz	Шығыс Қазақстан облысы	2026-04-25 10:52:54+00	50	18.1	66	1
1534	zhambyl	Жамбыл облысы	2026-04-25 10:52:54+00	35	16.5	44	3
1535	west_kz	Батыс Қазақстан облысы	2026-04-25 10:52:54+00	26	12	50	10.8
1536	karaganda	Қарағанды облысы	2026-04-25 10:52:54+00	6	22	45	7.2
1537	kostanay	Қостанай облысы	2026-04-25 10:52:54+00	6	22	45	7.2
1538	kyzylorda	Қызылорда облысы	2026-04-25 10:52:54+00	35	16.5	44	3
1539	mangystau	Маңғыстау облысы	2026-04-25 10:52:54+00	35	12	50	10.8
1540	north_kz	Солтүстік Қазақстан облысы	2026-04-25 10:52:54+00	6	22	45	7.2
1541	pavlodar	Павлодар облысы	2026-04-25 10:52:54+00	6	22	45	7.2
1542	turkistan	Түркістан облысы	2026-04-25 10:52:54+00	35	16.5	44	3
1543	abay	Абай облысы	2026-04-25 10:52:54+00	50	18.1	66	1
1544	ulytau	Ұлытау облысы	2026-04-25 10:52:54+00	6	22	45	7.2
1545	jetisu	Жетісу облысы	2026-04-25 10:52:54+00	2	19.5	64	1.5
1546	astana	Астана	2026-04-25 10:57:25+00	6	22	45	7.2
1547	almaty_city	Алматы	2026-04-25 10:57:25+00	2	19.5	64	1.5
1548	shymkent	Шымкент	2026-04-25 10:57:25+00	35	16.5	44	3
1549	akmola	Ақмола облысы	2026-04-25 10:57:25+00	6	22	45	7.2
1550	aktobe	Ақтөбе облысы	2026-04-25 10:57:25+00	6	22	45	7.2
1551	almaty_obl	Алматы облысы	2026-04-25 10:57:25+00	2	19.5	64	1.5
1552	atyrau	Атырау облысы	2026-04-25 10:57:25+00	35	12	50	10.8
1553	east_kz	Шығыс Қазақстан облысы	2026-04-25 10:57:25+00	50	18.1	66	1
1554	zhambyl	Жамбыл облысы	2026-04-25 10:57:25+00	35	16.5	44	3
1555	west_kz	Батыс Қазақстан облысы	2026-04-25 10:57:25+00	26	12	50	10.8
1556	karaganda	Қарағанды облысы	2026-04-25 10:57:25+00	6	22	45	7.2
1557	kostanay	Қостанай облысы	2026-04-25 10:57:25+00	6	22	45	7.2
1558	kyzylorda	Қызылорда облысы	2026-04-25 10:57:25+00	35	16.5	44	3
1559	mangystau	Маңғыстау облысы	2026-04-25 10:57:25+00	35	12	50	10.8
1560	north_kz	Солтүстік Қазақстан облысы	2026-04-25 10:57:25+00	6	22	45	7.2
1561	pavlodar	Павлодар облысы	2026-04-25 10:57:25+00	6	22	45	7.2
1562	turkistan	Түркістан облысы	2026-04-25 10:57:25+00	35	16.5	44	3
1563	abay	Абай облысы	2026-04-25 10:57:25+00	50	18.1	66	1
1564	ulytau	Ұлытау облысы	2026-04-25 10:57:25+00	6	22	45	7.2
1565	jetisu	Жетісу облысы	2026-04-25 10:57:25+00	2	19.5	64	1.5
1566	astana	Астана	2026-04-25 10:59:18+00	6	22	45	7.2
1567	almaty_city	Алматы	2026-04-25 10:59:18+00	2	19.5	64	1.5
1568	shymkent	Шымкент	2026-04-25 10:59:18+00	35	16.5	44	3
1569	akmola	Ақмола облысы	2026-04-25 10:59:18+00	6	22	45	7.2
1570	aktobe	Ақтөбе облысы	2026-04-25 10:59:18+00	6	22	45	7.2
1571	almaty_obl	Алматы облысы	2026-04-25 10:59:18+00	2	19.5	64	1.5
1572	atyrau	Атырау облысы	2026-04-25 10:59:18+00	35	12	50	10.8
1573	east_kz	Шығыс Қазақстан облысы	2026-04-25 10:59:18+00	50	18.1	66	1
1574	zhambyl	Жамбыл облысы	2026-04-25 10:59:18+00	35	16.5	44	3
1575	west_kz	Батыс Қазақстан облысы	2026-04-25 10:59:18+00	26	12	50	10.8
1576	karaganda	Қарағанды облысы	2026-04-25 10:59:18+00	6	22	45	7.2
1577	kostanay	Қостанай облысы	2026-04-25 10:59:18+00	6	22	45	7.2
1578	kyzylorda	Қызылорда облысы	2026-04-25 10:59:18+00	35	16.5	44	3
1579	mangystau	Маңғыстау облысы	2026-04-25 10:59:18+00	35	12	50	10.8
1580	north_kz	Солтүстік Қазақстан облысы	2026-04-25 10:59:18+00	6	22	45	7.2
1581	pavlodar	Павлодар облысы	2026-04-25 10:59:18+00	6	22	45	7.2
1582	turkistan	Түркістан облысы	2026-04-25 10:59:18+00	35	16.5	44	3
1583	abay	Абай облысы	2026-04-25 10:59:18+00	50	18.1	66	1
1584	ulytau	Ұлытау облысы	2026-04-25 10:59:18+00	6	22	45	7.2
1585	jetisu	Жетісу облысы	2026-04-25 10:59:18+00	2	19.5	64	1.5
1586	astana	Астана	2026-04-25 11:00:00+00	6	22	45	7.2
1587	almaty_city	Алматы	2026-04-25 11:00:00+00	2	19.5	64	1.5
1588	shymkent	Шымкент	2026-04-25 11:00:00+00	35	16.5	44	3
1589	akmola	Ақмола облысы	2026-04-25 11:00:00+00	6	22	45	7.2
1590	aktobe	Ақтөбе облысы	2026-04-25 11:00:00+00	6	22	45	7.2
1591	almaty_obl	Алматы облысы	2026-04-25 11:00:00+00	2	19.5	64	1.5
1592	atyrau	Атырау облысы	2026-04-25 11:00:00+00	35	12	50	10.8
1593	east_kz	Шығыс Қазақстан облысы	2026-04-25 11:00:00+00	50	18.1	66	1
1594	zhambyl	Жамбыл облысы	2026-04-25 11:00:00+00	35	16.5	44	3
1595	west_kz	Батыс Қазақстан облысы	2026-04-25 11:00:00+00	26	12	50	10.8
1596	karaganda	Қарағанды облысы	2026-04-25 11:00:00+00	6	22	45	7.2
1597	kostanay	Қостанай облысы	2026-04-25 11:00:00+00	6	22	45	7.2
1598	kyzylorda	Қызылорда облысы	2026-04-25 11:00:00+00	35	16.5	44	3
1599	mangystau	Маңғыстау облысы	2026-04-25 11:00:00+00	35	12	50	10.8
1600	north_kz	Солтүстік Қазақстан облысы	2026-04-25 11:00:00+00	6	22	45	7.2
1601	pavlodar	Павлодар облысы	2026-04-25 11:00:00+00	6	22	45	7.2
1602	turkistan	Түркістан облысы	2026-04-25 11:00:00+00	35	16.5	44	3
1603	abay	Абай облысы	2026-04-25 11:00:00+00	50	18.1	66	1
1604	ulytau	Ұлытау облысы	2026-04-25 11:00:00+00	6	22	45	7.2
1605	jetisu	Жетісу облысы	2026-04-25 11:00:00+00	2	19.5	64	1.5
1606	astana	Астана	2026-04-25 11:04:36+00	6	22	45	7.2
1607	almaty_city	Алматы	2026-04-25 11:04:36+00	2	19.5	64	1.5
1609	akmola	Ақмола облысы	2026-04-25 11:04:36+00	6	22	45	7.2
1610	aktobe	Ақтөбе облысы	2026-04-25 11:04:36+00	6	22	45	7.2
1611	almaty_obl	Алматы облысы	2026-04-25 11:04:36+00	2	19.5	64	1.5
1612	atyrau	Атырау облысы	2026-04-25 11:04:36+00	35	12	50	10.8
1613	east_kz	Шығыс Қазақстан облысы	2026-04-25 11:04:36+00	50	18.1	66	1
1614	zhambyl	Жамбыл облысы	2026-04-25 11:04:36+00	35	16.5	44	3
1615	west_kz	Батыс Қазақстан облысы	2026-04-25 11:04:36+00	26	12	50	10.8
1616	karaganda	Қарағанды облысы	2026-04-25 11:04:36+00	6	22	45	7.2
1617	kostanay	Қостанай облысы	2026-04-25 11:04:36+00	6	22	45	7.2
1618	kyzylorda	Қызылорда облысы	2026-04-25 11:04:36+00	35	16.5	44	3
1619	mangystau	Маңғыстау облысы	2026-04-25 11:04:36+00	35	12	50	10.8
1620	north_kz	Солтүстік Қазақстан облысы	2026-04-25 11:04:36+00	6	22	45	7.2
1621	pavlodar	Павлодар облысы	2026-04-25 11:04:36+00	6	22	45	7.2
1622	turkistan	Түркістан облысы	2026-04-25 11:04:36+00	35	16.5	44	3
1623	abay	Абай облысы	2026-04-25 11:04:36+00	50	18.1	66	1
1624	ulytau	Ұлытау облысы	2026-04-25 11:04:36+00	6	22	45	7.2
1625	jetisu	Жетісу облысы	2026-04-25 11:04:36+00	2	19.5	64	1.5
1626	astana	Астана	2026-04-25 11:09:37+00	6	22	45	7.2
1627	almaty_city	Алматы	2026-04-25 11:09:37+00	2	19.5	64	1.5
1628	shymkent	Шымкент	2026-04-25 11:09:37+00	35	16.5	44	3
1629	akmola	Ақмола облысы	2026-04-25 11:09:37+00	6	22	45	7.2
1630	aktobe	Ақтөбе облысы	2026-04-25 11:09:37+00	6	22	45	7.2
1631	almaty_obl	Алматы облысы	2026-04-25 11:09:37+00	2	19.5	64	1.5
1632	atyrau	Атырау облысы	2026-04-25 11:09:37+00	35	12	50	10.8
1633	east_kz	Шығыс Қазақстан облысы	2026-04-25 11:09:37+00	50	18.1	66	1
1634	zhambyl	Жамбыл облысы	2026-04-25 11:09:37+00	35	16.5	44	3
1635	west_kz	Батыс Қазақстан облысы	2026-04-25 11:09:37+00	26	12	50	10.8
1636	karaganda	Қарағанды облысы	2026-04-25 11:09:37+00	6	22	45	7.2
1637	kostanay	Қостанай облысы	2026-04-25 11:09:37+00	6	22	45	7.2
1638	kyzylorda	Қызылорда облысы	2026-04-25 11:09:37+00	35	16.5	44	3
1639	mangystau	Маңғыстау облысы	2026-04-25 11:09:37+00	35	12	50	10.8
1640	north_kz	Солтүстік Қазақстан облысы	2026-04-25 11:09:37+00	6	22	45	7.2
1641	pavlodar	Павлодар облысы	2026-04-25 11:09:37+00	6	22	45	7.2
1642	turkistan	Түркістан облысы	2026-04-25 11:09:37+00	35	16.5	44	3
1643	abay	Абай облысы	2026-04-25 11:09:37+00	50	18.1	66	1
1644	ulytau	Ұлытау облысы	2026-04-25 11:09:37+00	6	22	45	7.2
1645	jetisu	Жетісу облысы	2026-04-25 11:09:37+00	2	19.5	64	1.5
1646	astana	Астана	2026-04-25 11:13:18+00	6	22	45	7.2
1647	almaty_city	Алматы	2026-04-25 11:13:18+00	2	19.5	64	1.5
1648	shymkent	Шымкент	2026-04-25 11:13:18+00	33	16.5	44	3
1649	akmola	Ақмола облысы	2026-04-25 11:13:18+00	6	22	45	7.2
1650	aktobe	Ақтөбе облысы	2026-04-25 11:13:18+00	6	22	45	7.2
1651	almaty_obl	Алматы облысы	2026-04-25 11:13:18+00	2	19.5	64	1.5
1652	atyrau	Атырау облысы	2026-04-25 11:13:18+00	35	12	50	10.8
1653	east_kz	Шығыс Қазақстан облысы	2026-04-25 11:13:18+00	50	18.1	66	1
1654	zhambyl	Жамбыл облысы	2026-04-25 11:13:18+00	33	16.5	44	3
1655	west_kz	Батыс Қазақстан облысы	2026-04-25 11:13:18+00	26	12	50	10.8
1656	karaganda	Қарағанды облысы	2026-04-25 11:13:18+00	6	22	45	7.2
1657	kostanay	Қостанай облысы	2026-04-25 11:13:18+00	6	22	45	7.2
1658	kyzylorda	Қызылорда облысы	2026-04-25 11:13:18+00	33	16.5	44	3
1659	mangystau	Маңғыстау облысы	2026-04-25 11:13:18+00	35	12	50	10.8
1660	north_kz	Солтүстік Қазақстан облысы	2026-04-25 11:13:18+00	6	22	45	7.2
1661	pavlodar	Павлодар облысы	2026-04-25 11:13:18+00	6	22	45	7.2
1662	turkistan	Түркістан облысы	2026-04-25 11:13:18+00	33	16.5	44	3
1663	abay	Абай облысы	2026-04-25 11:13:18+00	50	18.1	66	1
1664	ulytau	Ұлытау облысы	2026-04-25 11:13:18+00	6	22	45	7.2
1665	jetisu	Жетісу облысы	2026-04-25 11:13:18+00	2	19.5	64	1.5
1666	astana	Astana	2026-04-25 12:00:00+00	6	24	30	9.7
1667	almaty_city	Almaty	2026-04-25 12:00:00+00	2	21	60	2
1668	astana	Astana	2026-04-25 13:00:00+00	5	24	25	10.8
1669	almaty_city	Almaty	2026-04-25 13:00:00+00	2	22	53	2.5
1670	astana	Astana	2026-04-25 13:20:51+00	6	20	45	11.8
1671	almaty_city	Алматы	2026-04-25 13:20:51+00	2	23	56	2.5
1672	shymkent	Шымкент	2026-04-25 13:20:51+00	24	27.4	27	2
1673	akmola	Ақмола облысы	2026-04-25 13:20:51+00	6	20	45	11.8
1674	aktobe	Ақтөбе облысы	2026-04-25 13:20:51+00	6	20	45	11.8
1675	almaty_obl	Алматы облысы	2026-04-25 13:20:51+00	2	23	56	2.5
1676	atyrau	Атырау облысы	2026-04-25 13:20:51+00	37	13	47	11.3
1677	east_kz	Шығыс Қазақстан облысы	2026-04-25 13:20:51+00	35	21.3	55	2
1678	zhambyl	Жамбыл облысы	2026-04-25 13:20:51+00	24	27.4	27	2
1679	west_kz	Батыс Қазақстан облысы	2026-04-25 13:20:51+00	29	13	47	11.3
1680	karaganda	Қарағанды облысы	2026-04-25 13:20:51+00	6	20	45	11.8
1681	kostanay	Қостанай облысы	2026-04-25 13:20:51+00	6	20	45	11.8
1682	kyzylorda	Қызылорда облысы	2026-04-25 13:20:51+00	24	27.4	27	2
1683	mangystau	Маңғыстау облысы	2026-04-25 13:20:51+00	37	13	47	11.3
1684	north_kz	Солтүстік Қазақстан облысы	2026-04-25 13:20:51+00	6	20	45	11.8
1685	pavlodar	Павлодар облысы	2026-04-25 13:20:51+00	6	20	45	11.8
1686	turkistan	Түркістан облысы	2026-04-25 13:20:51+00	24	27.4	27	2
1687	abay	Абай облысы	2026-04-25 13:20:51+00	35	21.3	55	2
1688	ulytau	Ұлытау облысы	2026-04-25 13:20:51+00	6	20	45	11.8
1689	jetisu	Жетісу облысы	2026-04-25 13:20:51+00	2	23	56	2.5
1690	astana	Astana	2026-04-26 23:46:31+00	4	11.5	42	3.6
1691	almaty_city	Алматы	2026-04-26 23:46:31+00	2	21	52	3
1692	shymkent	Шымкент	2026-04-26 23:46:31+00	17	19.7	56	2
1693	akmola	Ақмола облысы	2026-04-26 23:46:31+00	4	11.5	42	3.6
1694	aktobe	Ақтөбе облысы	2026-04-26 23:46:31+00	4	11.5	42	3.6
1695	almaty_obl	Алматы облысы	2026-04-26 23:46:31+00	2	21	52	3
1696	atyrau	Атырау облысы	2026-04-26 23:46:31+00	70	16.5	50	9
1697	east_kz	Шығыс Қазақстан облысы	2026-04-26 23:46:31+00	48	21.7	41	4
1698	zhambyl	Жамбыл облысы	2026-04-26 23:46:31+00	17	19.7	56	2
1699	west_kz	Батыс Қазақстан облысы	2026-04-26 23:46:31+00	55	16.5	50	9
1700	karaganda	Қарағанды облысы	2026-04-26 23:46:31+00	4	11.5	42	3.6
1701	kostanay	Қостанай облысы	2026-04-26 23:46:31+00	4	11.5	42	3.6
1702	kyzylorda	Қызылорда облысы	2026-04-26 23:46:31+00	17	19.7	56	2
1703	mangystau	Маңғыстау облысы	2026-04-26 23:46:31+00	70	16.5	50	9
1704	north_kz	Солтүстік Қазақстан облысы	2026-04-26 23:46:31+00	4	11.5	42	3.6
1705	pavlodar	Павлодар облысы	2026-04-26 23:46:31+00	4	11.5	42	3.6
1706	turkistan	Түркістан облысы	2026-04-26 23:46:31+00	17	19.7	56	2
1707	abay	Абай облысы	2026-04-26 23:46:31+00	48	21.7	41	4
1708	ulytau	Ұлытау облысы	2026-04-26 23:46:31+00	4	11.5	42	3.6
1709	jetisu	Жетісу облысы	2026-04-26 23:46:31+00	2	21	52	3
1710	astana	Astana	2026-04-27 00:00:00+00	4	11.5	42	3.6
1711	almaty_city	Almaty	2026-04-27 00:00:00+00	2	21	52	3
1712	astana	Астана	2026-04-28 02:24:43+00	6	19	27	3.6
1713	almaty_city	Алматы	2026-04-28 02:24:43+00	1	23	31	1.5
1714	shymkent	Шымкент	2026-04-28 02:24:43+00	11	24.5	39	1
1715	akmola	Ақмола облысы	2026-04-28 02:24:43+00	6	19	27	3.6
1716	aktobe	Ақтөбе облысы	2026-04-28 02:24:43+00	6	19	27	3.6
1717	almaty_obl	Алматы облысы	2026-04-28 02:24:43+00	1	23	31	1.5
1718	atyrau	Атырау облысы	2026-04-28 02:24:43+00	33	17	51	6.1
1719	east_kz	Шығыс Қазақстан облысы	2026-04-28 02:24:43+00	42	19.2	59	2
1720	zhambyl	Жамбыл облысы	2026-04-28 02:24:43+00	11	24.5	39	1
1721	west_kz	Батыс Қазақстан облысы	2026-04-28 02:24:43+00	39	17	51	6.1
1722	karaganda	Қарағанды облысы	2026-04-28 02:24:43+00	6	19	27	3.6
1723	kostanay	Қостанай облысы	2026-04-28 02:24:43+00	6	19	27	3.6
1724	kyzylorda	Қызылорда облысы	2026-04-28 02:24:43+00	11	24.5	39	1
1725	mangystau	Маңғыстау облысы	2026-04-28 02:24:43+00	33	17	51	6.1
1726	north_kz	Солтүстік Қазақстан облысы	2026-04-28 02:24:43+00	6	19	27	3.6
1727	pavlodar	Павлодар облысы	2026-04-28 02:24:43+00	6	19	27	3.6
1728	turkistan	Түркістан облысы	2026-04-28 02:24:43+00	11	24.5	39	1
1729	abay	Абай облысы	2026-04-28 02:24:43+00	42	19.2	59	2
1730	ulytau	Ұлытау облысы	2026-04-28 02:24:43+00	6	19	27	3.6
1731	jetisu	Жетісу облысы	2026-04-28 02:24:43+00	1	23	31	1.5
1732	astana	Астана	2026-05-02 08:11:19+00	6	8.5	73	4.1
1733	almaty_city	Алматы	2026-05-02 08:11:19+00	2	20.5	49	1.5
1734	shymkent	Шымкент	2026-05-02 08:11:19+00	7	16.1	76	1
1735	akmola	Ақмола облысы	2026-05-02 08:11:19+00	6	8.5	73	4.1
1736	aktobe	Ақтөбе облысы	2026-05-02 08:11:19+00	6	8.5	73	4.1
1737	almaty_obl	Алматы облысы	2026-05-02 08:11:19+00	2	20.5	49	1.5
1738	atyrau	Атырау облысы	2026-05-02 08:11:19+00	76	13	82	1.5
1739	east_kz	Шығыс Қазақстан облысы	2026-05-02 08:11:19+00	26	16	28	4
1740	zhambyl	Жамбыл облысы	2026-05-02 08:11:19+00	7	16.1	76	1
1741	west_kz	Батыс Қазақстан облысы	2026-05-02 08:11:19+00	57	13	82	1.5
1742	karaganda	Қарағанды облысы	2026-05-02 08:11:19+00	6	8.5	73	4.1
1743	kostanay	Қостанай облысы	2026-05-02 08:11:19+00	6	8.5	73	4.1
1744	kyzylorda	Қызылорда облысы	2026-05-02 08:11:19+00	7	16.1	76	1
1745	mangystau	Маңғыстау облысы	2026-05-02 08:11:19+00	76	13	82	1.5
1746	north_kz	Солтүстік Қазақстан облысы	2026-05-02 08:11:19+00	6	8.5	73	4.1
1747	pavlodar	Павлодар облысы	2026-05-02 08:11:19+00	6	8.5	73	4.1
1748	turkistan	Түркістан облысы	2026-05-02 08:11:19+00	7	16.1	76	1
1749	abay	Абай облысы	2026-05-02 08:11:19+00	26	16	28	4
1750	ulytau	Ұлытау облысы	2026-05-02 08:11:19+00	6	8.5	73	4.1
1751	jetisu	Жетісу облысы	2026-05-02 08:11:19+00	2	20.5	49	1.5
1752	astana	Астана	2026-05-02 08:13:24+00	6	8.5	73	4.1
1753	almaty_city	Алматы	2026-05-02 08:13:24+00	2	20.5	49	1.5
1754	shymkent	Шымкент	2026-05-02 08:13:24+00	7	16.1	76	1
1755	akmola	Ақмола облысы	2026-05-02 08:13:24+00	6	8.5	73	4.1
1756	aktobe	Ақтөбе облысы	2026-05-02 08:13:24+00	6	8.5	73	4.1
1757	almaty_obl	Алматы облысы	2026-05-02 08:13:24+00	2	20.5	49	1.5
1758	atyrau	Атырау облысы	2026-05-02 08:13:24+00	76	13	82	1.5
1759	east_kz	Шығыс Қазақстан облысы	2026-05-02 08:13:24+00	26	16	28	4
1760	zhambyl	Жамбыл облысы	2026-05-02 08:13:24+00	7	16.1	76	1
1761	west_kz	Батыс Қазақстан облысы	2026-05-02 08:13:24+00	57	13	82	1.5
1762	karaganda	Қарағанды облысы	2026-05-02 08:13:24+00	6	8.5	73	4.1
1763	kostanay	Қостанай облысы	2026-05-02 08:13:24+00	6	8.5	73	4.1
1764	kyzylorda	Қызылорда облысы	2026-05-02 08:13:24+00	7	16.1	76	1
1765	mangystau	Маңғыстау облысы	2026-05-02 08:13:24+00	76	13	82	1.5
1766	north_kz	Солтүстік Қазақстан облысы	2026-05-02 08:13:24+00	6	8.5	73	4.1
1767	pavlodar	Павлодар облысы	2026-05-02 08:13:24+00	6	8.5	73	4.1
1768	turkistan	Түркістан облысы	2026-05-02 08:13:24+00	7	16.1	76	1
1769	abay	Абай облысы	2026-05-02 08:13:24+00	26	16	28	4
1770	ulytau	Ұлытау облысы	2026-05-02 08:13:24+00	6	8.5	73	4.1
1771	jetisu	Жетісу облысы	2026-05-02 08:13:24+00	2	20.5	49	1.5
1772	astana	Astana	2026-05-02 08:25:16+00	6	8.5	73	4.1
1773	almaty_city	Almaty	2026-05-02 08:25:16+00	2	20.5	49	1.5
1774	astana	Астана	2026-05-02 08:32:12+00	6	8.5	73	4.1
1775	almaty_city	Алматы	2026-05-02 08:32:12+00	2	20.5	49	1.5
1776	shymkent	Шымкент	2026-05-02 08:32:12+00	7	16.1	76	1
1777	akmola	Ақмола облысы	2026-05-02 08:32:12+00	6	8.5	73	4.1
1778	aktobe	Ақтөбе облысы	2026-05-02 08:32:12+00	6	8.5	73	4.1
1779	almaty_obl	Алматы облысы	2026-05-02 08:32:12+00	2	20.5	49	1.5
1780	atyrau	Атырау облысы	2026-05-02 08:32:12+00	78	14	76	1.5
1781	east_kz	Шығыс Қазақстан облысы	2026-05-02 08:32:12+00	26	16	28	4
1782	zhambyl	Жамбыл облысы	2026-05-02 08:32:12+00	7	16.1	76	1
1783	west_kz	Батыс Қазақстан облысы	2026-05-02 08:32:12+00	57	14	76	1.5
1784	karaganda	Қарағанды облысы	2026-05-02 08:32:12+00	6	8.5	73	4.1
1785	kostanay	Қостанай облысы	2026-05-02 08:32:12+00	6	8.5	73	4.1
1786	kyzylorda	Қызылорда облысы	2026-05-02 08:32:12+00	7	16.1	76	1
1787	mangystau	Маңғыстау облысы	2026-05-02 08:32:12+00	78	14	76	1.5
1788	north_kz	Солтүстік Қазақстан облысы	2026-05-02 08:32:12+00	6	8.5	73	4.1
1789	pavlodar	Павлодар облысы	2026-05-02 08:32:12+00	6	8.5	73	4.1
1790	turkistan	Түркістан облысы	2026-05-02 08:32:12+00	7	16.1	76	1
1791	abay	Абай облысы	2026-05-02 08:32:12+00	26	16	28	4
1792	ulytau	Ұлытау облысы	2026-05-02 08:32:12+00	6	8.5	73	4.1
1793	jetisu	Жетісу облысы	2026-05-02 08:32:12+00	2	20.5	49	1.5
1794	astana	Astana	2026-05-02 09:00:00+00	7	11	60	5.1
1795	almaty_city	Алматы	2026-05-02 09:00:00+00	1	22	45	2
1796	shymkent	Шымкент	2026-05-02 09:00:00+00	7	16.1	76	1
1797	akmola	Ақмола облысы	2026-05-02 09:00:00+00	7	11	60	5.1
1798	aktobe	Ақтөбе облысы	2026-05-02 09:00:00+00	7	11	60	5.1
1799	almaty_obl	Алматы облысы	2026-05-02 09:00:00+00	1	22	45	2
1800	atyrau	Атырау облысы	2026-05-02 09:00:00+00	78	14	76	1.5
1801	east_kz	Шығыс Қазақстан облысы	2026-05-02 09:00:00+00	26	16	28	4
1802	zhambyl	Жамбыл облысы	2026-05-02 09:00:00+00	7	16.1	76	1
1803	west_kz	Батыс Қазақстан облысы	2026-05-02 09:00:00+00	57	14	76	1.5
1804	karaganda	Қарағанды облысы	2026-05-02 09:00:00+00	7	11	60	5.1
1805	kostanay	Қостанай облысы	2026-05-02 09:00:00+00	7	11	60	5.1
1806	kyzylorda	Қызылорда облысы	2026-05-02 09:00:00+00	7	16.1	76	1
1807	mangystau	Маңғыстау облысы	2026-05-02 09:00:00+00	78	14	76	1.5
1808	north_kz	Солтүстік Қазақстан облысы	2026-05-02 09:00:00+00	7	11	60	5.1
1809	pavlodar	Павлодар облысы	2026-05-02 09:00:00+00	7	11	60	5.1
1810	turkistan	Түркістан облысы	2026-05-02 09:00:00+00	7	16.1	76	1
1811	abay	Абай облысы	2026-05-02 09:00:00+00	26	16	28	4
1812	ulytau	Ұлытау облысы	2026-05-02 09:00:00+00	7	11	60	5.1
1813	jetisu	Жетісу облысы	2026-05-02 09:00:00+00	1	22	45	2
1814	astana	Астана	2026-05-02 09:08:02+00	7	11	60	5.1
1815	almaty_city	Алматы	2026-05-02 09:08:02+00	1	22	45	2
1816	shymkent	Шымкент	2026-05-02 09:08:02+00	7	16.1	76	1
1817	akmola	Ақмола облысы	2026-05-02 09:08:02+00	7	11	60	5.1
1818	aktobe	Ақтөбе облысы	2026-05-02 09:08:02+00	7	11	60	5.1
1819	almaty_obl	Алматы облысы	2026-05-02 09:08:02+00	1	22	45	2
1820	atyrau	Атырау облысы	2026-05-02 09:08:02+00	78	14	76	1.5
1821	east_kz	Шығыс Қазақстан облысы	2026-05-02 09:08:02+00	26	16	28	4
1822	zhambyl	Жамбыл облысы	2026-05-02 09:08:02+00	7	16.1	76	1
1823	west_kz	Батыс Қазақстан облысы	2026-05-02 09:08:02+00	57	14	76	1.5
1824	karaganda	Қарағанды облысы	2026-05-02 09:08:02+00	7	11	60	5.1
1825	kostanay	Қостанай облысы	2026-05-02 09:08:02+00	7	11	60	5.1
1826	kyzylorda	Қызылорда облысы	2026-05-02 09:08:02+00	7	16.1	76	1
1827	mangystau	Маңғыстау облысы	2026-05-02 09:08:02+00	78	14	76	1.5
1828	north_kz	Солтүстік Қазақстан облысы	2026-05-02 09:08:02+00	7	11	60	5.1
1829	pavlodar	Павлодар облысы	2026-05-02 09:08:02+00	7	11	60	5.1
1830	turkistan	Түркістан облысы	2026-05-02 09:08:02+00	7	16.1	76	1
1831	abay	Абай облысы	2026-05-02 09:08:02+00	26	16	28	4
1832	ulytau	Ұлытау облысы	2026-05-02 09:08:02+00	7	11	60	5.1
1833	jetisu	Жетісу облысы	2026-05-02 09:08:02+00	1	22	45	2
1834	astana	Astana	2026-05-02 10:00:00+00	6	13	50	6.6
1835	almaty_city	Almaty	2026-05-02 10:00:00+00	1	23	43	1.5
1836	astana	Astana	2026-05-02 10:38:08+00	6	14	44	6.6
1837	almaty_city	Алматы	2026-05-02 10:38:08+00	2	24	38	2.5
1838	shymkent	Шымкент	2026-05-02 10:38:08+00	7	16.1	76	1
1839	akmola	Ақмола облысы	2026-05-02 10:38:08+00	6	14	44	6.6
1840	aktobe	Ақтөбе облысы	2026-05-02 10:38:08+00	6	14	44	6.6
1841	almaty_obl	Алматы облысы	2026-05-02 10:38:08+00	2	24	38	2.5
1842	atyrau	Атырау облысы	2026-05-02 10:38:08+00	81	15	74	1.2
1843	east_kz	Шығыс Қазақстан облысы	2026-05-02 10:38:08+00	47	22.8	18	6
1844	zhambyl	Жамбыл облысы	2026-05-02 10:38:08+00	7	16.1	76	1
1845	west_kz	Батыс Қазақстан облысы	2026-05-02 10:38:08+00	58	15	74	1.2
1846	karaganda	Қарағанды облысы	2026-05-02 10:38:08+00	6	14	44	6.6
1847	kostanay	Қостанай облысы	2026-05-02 10:38:08+00	6	14	44	6.6
1848	kyzylorda	Қызылорда облысы	2026-05-02 10:38:08+00	7	16.1	76	1
1849	mangystau	Маңғыстау облысы	2026-05-02 10:38:08+00	81	15	74	1.2
1850	north_kz	Солтүстік Қазақстан облысы	2026-05-02 10:38:08+00	6	14	44	6.6
1851	pavlodar	Павлодар облысы	2026-05-02 10:38:08+00	6	14	44	6.6
1852	turkistan	Түркістан облысы	2026-05-02 10:38:08+00	7	16.1	76	1
1853	abay	Абай облысы	2026-05-02 10:38:08+00	47	22.8	18	6
1854	ulytau	Ұлытау облысы	2026-05-02 10:38:08+00	6	14	44	6.6
1855	jetisu	Жетісу облысы	2026-05-02 10:38:08+00	2	24	38	2.5
1856	astana	Астана	2026-05-02 11:40:40+00	7	16	36	6.6
1857	almaty_city	Алматы	2026-05-02 11:40:40+00	2	26	39	3.6
1858	shymkent	Шымкент	2026-05-02 11:40:40+00	8	16.1	76	1
1859	akmola	Ақмола облысы	2026-05-02 11:40:40+00	7	16	36	6.6
1860	aktobe	Ақтөбе облысы	2026-05-02 11:40:40+00	7	16	36	6.6
1861	almaty_obl	Алматы облысы	2026-05-02 11:40:40+00	2	26	39	3.6
1862	atyrau	Атырау облысы	2026-05-02 11:40:40+00	81	15	74	1.2
1863	east_kz	Шығыс Қазақстан облысы	2026-05-02 11:40:40+00	45	22.8	18	6
1864	zhambyl	Жамбыл облысы	2026-05-02 11:40:40+00	8	16.1	76	1
1865	west_kz	Батыс Қазақстан облысы	2026-05-02 11:40:40+00	58	15	74	1.2
1866	karaganda	Қарағанды облысы	2026-05-02 11:40:40+00	7	16	36	6.6
1867	kostanay	Қостанай облысы	2026-05-02 11:40:40+00	7	16	36	6.6
1868	kyzylorda	Қызылорда облысы	2026-05-02 11:40:40+00	8	16.1	76	1
1869	mangystau	Маңғыстау облысы	2026-05-02 11:40:40+00	81	15	74	1.2
1870	north_kz	Солтүстік Қазақстан облысы	2026-05-02 11:40:40+00	7	16	36	6.6
1871	pavlodar	Павлодар облысы	2026-05-02 11:40:40+00	7	16	36	6.6
1872	turkistan	Түркістан облысы	2026-05-02 11:40:40+00	8	16.1	76	1
1873	abay	Абай облысы	2026-05-02 11:40:40+00	45	22.8	18	6
1874	ulytau	Ұлытау облысы	2026-05-02 11:40:40+00	7	16	36	6.6
1875	jetisu	Жетісу облысы	2026-05-02 11:40:40+00	2	26	39	3.6
1876	astana	Astana	2026-05-02 12:00:00+00	7	16	36	6.6
1877	almaty_city	Almaty	2026-05-02 12:00:00+00	2	26	39	3.6
1878	astana	Астана	2026-05-02 12:12:36+00	7	16	37	6.1
1879	almaty_city	Алматы	2026-05-02 12:12:36+00	2	25.5	39	3.6
1880	shymkent	Шымкент	2026-05-02 12:12:36+00	8	16.1	76	1
1881	akmola	Ақмола облысы	2026-05-02 12:12:36+00	7	16	37	6.1
1882	aktobe	Ақтөбе облысы	2026-05-02 12:12:36+00	7	16	37	6.1
1883	almaty_obl	Алматы облысы	2026-05-02 12:12:36+00	2	25.5	39	3.6
1884	atyrau	Атырау облысы	2026-05-02 12:12:36+00	82	15	72	4.3
1885	east_kz	Шығыс Қазақстан облысы	2026-05-02 12:12:36+00	45	22.8	18	6
1886	zhambyl	Жамбыл облысы	2026-05-02 12:12:36+00	8	16.1	76	1
1887	west_kz	Батыс Қазақстан облысы	2026-05-02 12:12:36+00	59	15	72	4.3
1888	karaganda	Қарағанды облысы	2026-05-02 12:12:36+00	7	16	37	6.1
1889	kostanay	Қостанай облысы	2026-05-02 12:12:36+00	7	16	37	6.1
1890	kyzylorda	Қызылорда облысы	2026-05-02 12:12:36+00	8	16.1	76	1
1891	mangystau	Маңғыстау облысы	2026-05-02 12:12:36+00	82	15	72	4.3
1892	north_kz	Солтүстік Қазақстан облысы	2026-05-02 12:12:36+00	7	16	37	6.1
1893	pavlodar	Павлодар облысы	2026-05-02 12:12:36+00	7	16	37	6.1
1894	turkistan	Түркістан облысы	2026-05-02 12:12:36+00	8	16.1	76	1
1895	abay	Абай облысы	2026-05-02 12:12:36+00	45	22.8	18	6
1896	ulytau	Ұлытау облысы	2026-05-02 12:12:36+00	7	16	37	6.1
1897	jetisu	Жетісу облысы	2026-05-02 12:12:36+00	2	25.5	39	3.6
1898	astana	Astana	2026-05-01 23:29:42+00	7	16	37	6.1
1899	almaty_city	Almaty	2026-05-01 23:29:42+00	2	25.5	39	3.6
\.


--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.regions (id, key, name, name_kk, city, coords_lat, coords_lon, country) FROM stdin;
1	astana	Астана	Астана	Astana	51.1694	71.4491	Kazakhstan
2	almaty_city	Алматы	Алматы	Almaty	43.2383	76.9453	Kazakhstan
3	shymkent	Шымкент	Шымкент	Shymkent	42.3417	69.5901	Kazakhstan
4	akmola	Акмолинская область	Ақмола облысы	Kokshetau	53.2833	69.3833	Kazakhstan
5	aktobe	Актюбинская область	Ақтөбе облысы	Aktobe	50.2833	57.1667	Kazakhstan
6	almaty_obl	Алматинская область	Алматы облысы	Taldykorgan	45.0167	78.3667	Kazakhstan
7	atyrau	Атырауская область	Атырау облысы	Atyrau	47.1167	51.8833	Kazakhstan
8	east_kz	Восточно-Казахстанская область	Шығыс Қазақстан облысы	Oskemen	49.9667	82.6167	Kazakhstan
9	zhambyl	Жамбылская область	Жамбыл облысы	Taraz	42.9	71.3667	Kazakhstan
10	west_kz	Западно-Казахстанская область	Батыс Қазақстан облысы	Oral	51.2225	51.3866	Kazakhstan
11	karaganda	Карагандинская область	Қарағанды облысы	Karaganda	49.8047	73.1094	Kazakhstan
12	kostanay	Костанайская область	Қостанай облысы	Kostanay	53.2144	63.6246	Kazakhstan
13	kyzylorda	Кызылординская область	Қызылорда облысы	Kyzylorda	44.85	65.5	Kazakhstan
14	mangystau	Мангистауская область	Маңғыстау облысы	Aktau	43.65	51.1667	Kazakhstan
15	north_kz	Северо-Казахстанская область	Солтүстік Қазақстан облысы	Petropavl	54.8667	69.15	Kazakhstan
16	pavlodar	Павлодарская область	Павлодар облысы	Pavlodar	52.3	76.95	Kazakhstan
17	turkistan	Туркестанская область	Түркістан облысы	Turkistan	43.3	68.2667	Kazakhstan
18	abay	Абайская область	Абай облысы	Semey	50.4333	80.2667	Kazakhstan
19	ulytau	Улытауская область	Ұлытау облысы	Zhezkazgan	47.7833	67.7	Kazakhstan
20	jetisu	Жетысуская область	Жетісу облысы	Taldykorgan	45.0167	78.3667	Kazakhstan
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, hashed_password, name, city_key, is_active, created_at) FROM stdin;
2	nurim@mail.ru	$2b$12$GTFrAFe4HqnHZc/DF28rGeETRyMXottsL7ZaKudZvuCkUZNqsZTEK	Nurim	\N	t	2026-04-14 11:15:41.982781
1	a.nurasyl.78@gmail.com	$2b$12$SdzXleNSd1r8e1aSkIkpbuURqp4bGVhhRa7RML1FLbwi4JKgkleji	fdsf	shymkent	t	2026-04-13 13:08:52.850678
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-03-03 10:32:21
20211116045059	2026-03-03 10:32:22
20211116050929	2026-03-03 10:34:24
20211116051442	2026-03-03 10:34:25
20211116212300	2026-03-03 10:34:26
20211116213355	2026-03-03 10:34:26
20211116213934	2026-03-03 10:34:27
20211116214523	2026-03-03 10:34:28
20211122062447	2026-03-03 10:34:29
20211124070109	2026-03-03 10:34:29
20211202204204	2026-03-03 10:34:30
20211202204605	2026-03-03 10:34:31
20211210212804	2026-03-03 10:34:33
20211228014915	2026-03-03 10:34:34
20220107221237	2026-03-03 10:34:34
20220228202821	2026-03-03 10:34:35
20220312004840	2026-03-03 10:34:36
20220603231003	2026-03-03 10:34:37
20220603232444	2026-03-03 10:34:37
20220615214548	2026-03-03 10:34:38
20220712093339	2026-03-03 10:34:39
20220908172859	2026-03-03 10:34:40
20220916233421	2026-03-03 10:34:40
20230119133233	2026-03-03 10:34:41
20230128025114	2026-03-03 10:34:42
20230128025212	2026-03-03 10:34:43
20230227211149	2026-03-03 10:34:43
20230228184745	2026-03-03 10:34:44
20230308225145	2026-03-03 10:34:45
20230328144023	2026-03-03 10:34:45
20231018144023	2026-03-03 10:34:46
20231204144023	2026-03-03 10:34:47
20231204144024	2026-03-03 10:34:48
20231204144025	2026-03-03 10:34:49
20240108234812	2026-03-03 10:34:49
20240109165339	2026-03-03 10:34:50
20240227174441	2026-03-03 10:34:51
20240311171622	2026-03-03 10:34:52
20240321100241	2026-03-03 10:34:54
20240401105812	2026-03-03 10:34:56
20240418121054	2026-03-03 10:34:57
20240523004032	2026-03-03 10:34:59
20240618124746	2026-03-03 10:35:00
20240801235015	2026-03-03 10:35:01
20240805133720	2026-03-03 10:35:01
20240827160934	2026-03-03 10:35:02
20240919163303	2026-03-03 10:35:03
20240919163305	2026-03-03 10:35:04
20241019105805	2026-03-03 10:35:04
20241030150047	2026-03-03 10:35:07
20241108114728	2026-03-03 10:35:08
20241121104152	2026-03-03 10:35:08
20241130184212	2026-03-03 10:35:09
20241220035512	2026-03-03 10:35:10
20241220123912	2026-03-03 10:35:11
20241224161212	2026-03-03 10:35:11
20250107150512	2026-03-03 10:35:12
20250110162412	2026-03-03 10:35:13
20250123174212	2026-03-03 10:35:13
20250128220012	2026-03-03 10:35:14
20250506224012	2026-03-03 10:35:15
20250523164012	2026-03-03 10:35:15
20250714121412	2026-03-03 10:35:16
20250905041441	2026-03-03 10:35:17
20251103001201	2026-03-03 10:35:17
20251120212548	2026-03-03 10:35:18
20251120215549	2026-03-03 10:35:19
20260218120000	2026-03-03 10:35:20
20260326120000	2026-04-13 12:38:03
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-03-03 10:32:19.987363
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-03-03 10:32:20.310918
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2026-03-03 10:32:20.326208
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-03-03 10:32:20.88826
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-03-03 10:32:21.27146
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-03-03 10:32:21.294608
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-03-03 10:32:21.308864
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-03-03 10:32:21.318092
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-03-03 10:32:21.32682
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-03-03 10:32:21.339489
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-03-03 10:32:21.348449
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-03-03 10:32:21.360673
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-03-03 10:32:21.376738
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-03-03 10:32:21.385541
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-03-03 10:32:21.394586
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-03-03 10:32:21.45787
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-03-03 10:32:21.46684
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-03-03 10:32:21.475627
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-03-03 10:32:21.48434
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-03-03 10:32:21.500733
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-03-03 10:32:21.511883
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-03-03 10:32:21.524344
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-03-03 10:32:21.556188
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-03-03 10:32:21.585104
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-03-03 10:32:21.594216
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-03-03 10:32:21.602952
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-03-03 10:32:21.612113
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-03-03 10:32:21.620703
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-03-03 10:32:21.634069
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-03-03 10:32:21.642545
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-03-03 10:32:21.651014
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-03-03 10:32:21.659306
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-03-03 10:32:21.667618
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-03-03 10:32:21.676015
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-03-03 10:32:21.685034
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-03-03 10:32:21.693768
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-03-03 10:32:21.702223
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-03-03 10:32:21.710726
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-03-03 10:32:21.739003
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-03-03 10:32:21.754372
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-03-03 10:32:21.763019
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-03-03 10:32:21.771462
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-03-03 10:32:21.779816
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-03-03 10:32:21.802588
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-03-03 10:32:21.811519
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-03-03 10:32:21.821121
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-03-03 10:32:21.915295
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-03-03 10:32:21.933437
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-03-03 10:32:21.949874
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-03-03 10:32:22.122099
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-03-03 10:32:22.132124
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-03-03 10:32:50.510684
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-03-03 10:32:50.515826
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-03-03 10:32:50.54146
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-03-03 10:32:50.546694
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-03-03 10:32:50.549823
56	fix-optimized-search-function	cb58526ebc23048049fd5bf2fd148d18b04a2073	2026-03-03 10:32:50.574614
57	s3-multipart-uploads-metadata	f127886e00d1b374fadbc7c6b31e09336aad5287	2026-04-13 12:37:23.732357
58	operation-ergonomics	00ca5d483b3fe0d522133d9002ccc5df98365120	2026-04-13 12:37:23.752062
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata, metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 1, false);


--
-- Name: aqi_hourly_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.aqi_hourly_id_seq', 1899, true);


--
-- Name: regions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.regions_id_seq', 20, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- Name: aqi_hourly aqi_hourly_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aqi_hourly
    ADD CONSTRAINT aqi_hourly_pkey PRIMARY KEY (id);


--
-- Name: regions regions_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_key_key UNIQUE (key);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: aqi_hourly uq_region_hour; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aqi_hourly
    ADD CONSTRAINT uq_region_hour UNIQUE (region_key, ts_hour);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


--
-- Name: idx_aqi_hourly_region_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_aqi_hourly_region_key ON public.aqi_hourly USING btree (region_key);


--
-- Name: idx_aqi_hourly_ts_hour; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_aqi_hourly_ts_hour ON public.aqi_hourly USING btree (ts_hour);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_action_filter_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_key ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: aqi_hourly AQI data public; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "AQI data public" ON public.aqi_hourly FOR SELECT USING (true);


--
-- Name: regions Regions public; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Regions public" ON public.regions FOR SELECT USING (true);


--
-- Name: users Users access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users access" ON public.users USING (true);


--
-- Name: aqi_hourly; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.aqi_hourly ENABLE ROW LEVEL SECURITY;

--
-- Name: regions; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.regions ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea, text[], text[]) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.crypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.dearmor(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_bytes(integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_uuid() FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text, integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_key_id(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1mc() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v4() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_nil() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_dns() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_oid() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_url() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_x500() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION pg_reload_conf(); Type: ACL; Schema: pg_catalog; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pg_catalog.pg_reload_conf() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: FUNCTION rls_auto_enable(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.rls_auto_enable() TO anon;
GRANT ALL ON FUNCTION public.rls_auto_enable() TO authenticated;
GRANT ALL ON FUNCTION public.rls_auto_enable() TO service_role;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE custom_oauth_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.custom_oauth_providers TO postgres;
GRANT ALL ON TABLE auth.custom_oauth_providers TO dashboard_user;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- Name: TABLE oauth_client_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_client_states TO postgres;
GRANT ALL ON TABLE auth.oauth_client_states TO dashboard_user;


--
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE webauthn_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_challenges TO postgres;
GRANT ALL ON TABLE auth.webauthn_challenges TO dashboard_user;


--
-- Name: TABLE webauthn_credentials; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_credentials TO postgres;
GRANT ALL ON TABLE auth.webauthn_credentials TO dashboard_user;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements_info FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: TABLE aqi_hourly; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.aqi_hourly TO anon;
GRANT ALL ON TABLE public.aqi_hourly TO authenticated;
GRANT ALL ON TABLE public.aqi_hourly TO service_role;


--
-- Name: SEQUENCE aqi_hourly_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.aqi_hourly_id_seq TO anon;
GRANT ALL ON SEQUENCE public.aqi_hourly_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.aqi_hourly_id_seq TO service_role;


--
-- Name: TABLE regions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.regions TO anon;
GRANT ALL ON TABLE public.regions TO authenticated;
GRANT ALL ON TABLE public.regions TO service_role;


--
-- Name: SEQUENCE regions_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.regions_id_seq TO anon;
GRANT ALL ON SEQUENCE public.regions_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.regions_id_seq TO service_role;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.users TO anon;
GRANT ALL ON TABLE public.users TO authenticated;
GRANT ALL ON TABLE public.users TO service_role;


--
-- Name: SEQUENCE users_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.users_id_seq TO anon;
GRANT ALL ON SEQUENCE public.users_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.users_id_seq TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.buckets FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.buckets TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.objects FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.objects TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE vector_indexes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.vector_indexes TO service_role;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;
GRANT SELECT ON TABLE storage.vector_indexes TO anon;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: ensure_rls; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER ensure_rls ON ddl_command_end
         WHEN TAG IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
   EXECUTE FUNCTION public.rls_auto_enable();


ALTER EVENT TRIGGER ensure_rls OWNER TO postgres;

--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

\unrestrict BwGhL9GqEAeZQH08kqxl96u6saaTb8IUwFHFVd63jfDXVL5lnP2VizxDGnibCHw

