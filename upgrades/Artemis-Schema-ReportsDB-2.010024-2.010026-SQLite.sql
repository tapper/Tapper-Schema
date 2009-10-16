-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010024-SQLite.sql' to 'upgrades/Artemis-Schema-ReportsDB-2.010026-SQLite.sql':;

BEGIN;

CREATE INDEX report_idx_machine_name02 ON report (machine_name);

ALTER TABLE reportsection ADD COLUMN bios TEXT;

CREATE INDEX suite_idx_name02 ON suite (name);


COMMIT;

