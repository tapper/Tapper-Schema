-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010031-MySQL.sql' to 'Artemis::Schema::ReportsDB v2.010032':;

BEGIN;

ALTER TABLE reportsection ADD COLUMN kernel VARCHAR(255);


COMMIT;

