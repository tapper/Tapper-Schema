-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010025-SQLite.sql' to 'upgrades/Artemis-Schema-ReportsDB-2.010026-SQLite.sql':;

BEGIN;

ALTER TABLE reportsection ADD COLUMN bios TEXT;


COMMIT;

