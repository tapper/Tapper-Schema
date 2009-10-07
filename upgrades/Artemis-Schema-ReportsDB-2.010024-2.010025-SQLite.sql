-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010024-SQLite.sql' to 'upgrades/Artemis-Schema-ReportsDB-2.010025-SQLite.sql':;

BEGIN;

CREATE INDEX report_idx_machine_name02 ON report (machine_name);


COMMIT;

