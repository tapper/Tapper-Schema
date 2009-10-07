-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010023-MySQL.sql' to 'Artemis::Schema::ReportsDB v2.010025':;

BEGIN;

ALTER TABLE report ADD COLUMN hardwaredb_systems_id integer(11),
                   ADD INDEX report_idx_id (id),
                   ADD INDEX report_idx_machine_name (machine_name);

COMMIT;

