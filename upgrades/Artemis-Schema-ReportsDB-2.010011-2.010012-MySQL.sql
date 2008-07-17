-- Convert schema '/var/tmp/Artemis-Schema-ReportsDB-2.010011-MySQL.sql' to 'Artemis::Schema::ReportsDB v2.010012':

BEGIN;

ALTER TABLE reportsection CHANGE COLUMN language_description language_description text;

COMMIT;
