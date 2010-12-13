-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010036-MySQL.sql' to 'Artemis::Schema::ReportsDB v2.010037':;

BEGIN;

ALTER TABLE reportsection ADD COLUMN tags VARCHAR(255);


COMMIT;

