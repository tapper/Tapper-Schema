-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010036-SQLite.sql' to 'upgrades/Artemis-Schema-ReportsDB-2.010037-SQLite.sql':;

BEGIN;

ALTER TABLE reportsection ADD COLUMN tags VARCHAR(255);


COMMIT;

