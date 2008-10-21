-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010012-MySQL.sql' to 'Artemis::Schema::ReportsDB v2.010013':

BEGIN;

ALTER TABLE reportfile ADD COLUMN contenttype VARCHAR(255) DEFAULT '';
ALTER TABLE reportsection CHANGE COLUMN language_description language_description text;

COMMIT;
