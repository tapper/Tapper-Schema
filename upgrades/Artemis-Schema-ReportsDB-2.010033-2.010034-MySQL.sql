-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010033-MySQL.sql' to 'Artemis::Schema::ReportsDB v2.010034':;

BEGIN;

ALTER TABLE report DROP COLUMN hardwaredb_systems_id;

COMMIT;

