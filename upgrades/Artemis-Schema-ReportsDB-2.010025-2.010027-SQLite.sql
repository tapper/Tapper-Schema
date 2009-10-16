-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010025-SQLite.sql' to 'upgrades/Artemis-Schema-ReportsDB-2.010027-SQLite.sql':;

BEGIN;

ALTER TABLE reportcomment ADD COLUMN succession INT(10);

ALTER TABLE reportsection ADD COLUMN bios TEXT;


COMMIT;

