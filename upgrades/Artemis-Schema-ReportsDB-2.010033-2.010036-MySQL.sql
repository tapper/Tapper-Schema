-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010033-MySQL.sql' to 'Artemis::Schema::ReportsDB v2.010036':;

BEGIN;

ALTER TABLE report DROP COLUMN hardwaredb_systems_id;

ALTER TABLE reportsection ADD COLUMN ticket_url VARCHAR(255) DEFAULT '',
                          ADD COLUMN wiki_url VARCHAR(255) DEFAULT '',
                          ADD COLUMN planning_id VARCHAR(255) DEFAULT '';

ALTER TABLE tap ADD COLUMN tap_is_archive integer(11);


COMMIT;

