-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010028-MySQL.sql' to 'Artemis::Schema::ReportsDB v2.010029':;

BEGIN;

ALTER TABLE reportgrouptestrunstats ADD COLUMN success_ratio VARCHAR(20);


COMMIT;

