-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010026-MySQL.sql' to 'Artemis::Schema::ReportsDB v2.010027':;

BEGIN;

ALTER TABLE reportcomment ADD COLUMN succession integer(10);

ALTER TABLE reportsection CHANGE COLUMN language_description language_description text;


COMMIT;

