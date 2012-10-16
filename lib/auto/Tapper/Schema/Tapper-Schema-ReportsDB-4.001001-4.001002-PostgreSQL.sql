-- Convert schema 'lib/auto/Tapper/Schema/Tapper-Schema-ReportsDB-4.001001-PostgreSQL.sql' to 'lib/auto/Tapper/Schema/Tapper-Schema-ReportsDB-4.001002-PostgreSQL.sql':;

BEGIN;

ALTER TABLE report ALTER COLUMN suite_version TYPE character varying(255);

ALTER TABLE report ALTER COLUMN reportername TYPE character varying(255);

ALTER TABLE report ALTER COLUMN peeraddr TYPE character varying(255);

ALTER TABLE report ALTER COLUMN peerport TYPE character varying(255);

ALTER TABLE report ALTER COLUMN machine_name TYPE character varying(255);

ALTER TABLE reportsection ALTER COLUMN ram TYPE character varying(255);

ALTER TABLE reportsection ALTER COLUMN uptime TYPE character varying(255);

ALTER TABLE reportsection ALTER COLUMN xen_hvbits TYPE character varying(255);

ALTER TABLE reporttopic ALTER COLUMN name TYPE character varying(255);

ALTER TABLE suite ALTER COLUMN type TYPE character varying(255);

CREATE INDEX report_idx_created_at on report (created_at);

CREATE INDEX reportsection_idx_report_id on reportsection (report_id);


COMMIT;

