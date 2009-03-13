-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010019-MySQL.sql' to 'Artemis::Schema::ReportsDB v2.010021':;

BEGIN;

ALTER TABLE report DROP COLUMN tapdata,
                   ADD COLUMN tapdom LONGBLOB DEFAULT '';

ALTER TABLE reportgrouparbitrary CHANGE COLUMN arbitrary_id arbitrary_id VARCHAR(255) NOT NULL;

ALTER TABLE reportsection CHANGE COLUMN language_description language_description text;


COMMIT;

