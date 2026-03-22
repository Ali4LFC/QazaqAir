--
-- PostgreSQL database cluster dump
--

\restrict p4ltzM4ZEqxaVJCAFiJMGwyEGG4DzX3Dm4QeEbhssLGMw49VOEgk97DMUKbdcij

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:X29wkDTYoeOpJgmVkXYMxA==$LRjf4bLS9a2J1xj1QHS/g6hMLKTdxG2jhFhupv/jefs=:houa6Gt7aoUgeDscvIUDsTEMKU8AW+eKTtOV1lQDmeo=';
CREATE ROLE student;
ALTER ROLE student WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:npLe+xJ7rVhaybGQyofE6g==$+jgYA/0AkqOEI+mTbZnUtrQl6u9mukFoV8OUZZB23Xw=:p6MfVP5u+Ve8qRurxu1mRzQAbxZELUPPo9U/JEm9EQQ=';

--
-- User Configurations
--








\unrestrict p4ltzM4ZEqxaVJCAFiJMGwyEGG4DzX3Dm4QeEbhssLGMw49VOEgk97DMUKbdcij

--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

\restrict jx338twQXRgR242LWretYDocyDFXsOz8Ecaeva7xNgn1c7Y9aXCxx1ZgcbaihUP

-- Dumped from database version 15.17 (Debian 15.17-1.pgdg13+1)
-- Dumped by pg_dump version 15.17 (Debian 15.17-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

\unrestrict jx338twQXRgR242LWretYDocyDFXsOz8Ecaeva7xNgn1c7Y9aXCxx1ZgcbaihUP

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict hQQEgNOnHFpN8OIvXDCjJ2bz9VWhX988N8eGjJJuoFCm7pGQN0KOcTLCK3emT4f

-- Dumped from database version 15.17 (Debian 15.17-1.pgdg13+1)
-- Dumped by pg_dump version 15.17 (Debian 15.17-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO student;


--
-- PostgreSQL database dump complete
--

\unrestrict hQQEgNOnHFpN8OIvXDCjJ2bz9VWhX988N8eGjJJuoFCm7pGQN0KOcTLCK3emT4f

--
-- PostgreSQL database cluster dump complete
--

