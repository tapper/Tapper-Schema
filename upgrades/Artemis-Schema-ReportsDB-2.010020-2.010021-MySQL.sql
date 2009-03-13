-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010020-MySQL.sql' to 'Artemis::Schema::ReportsDB v2.010021':

BEGIN;

ALTER TABLE report DROP COLUMN tapdata,
                   ADD COLUMN tapdom LONGBLOB DEFAULT '';
ALTER TABLE reportsection CHANGE COLUMN language_description language_description text;

COMMIT;
