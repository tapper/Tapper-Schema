-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010012-SQLite.sql' to 'upgrades/Artemis-Schema-ReportsDB-2.010013-SQLite.sql':

BEGIN;



ALTER TABLE reportfile ADD COLUMN contenttype VARCHAR(255) DEFAULT '';






COMMIT;
