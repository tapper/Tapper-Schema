-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010022-SQLite.sql' to 'upgrades/Artemis-Schema-ReportsDB-2.010023-SQLite.sql':;

BEGIN;

ALTER TABLE reportsection ADD COLUMN changeset VARCHAR(255);

ALTER TABLE reportsection ADD COLUMN description VARCHAR(255);


COMMIT;

