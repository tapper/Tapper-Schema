-- Convert schema 'upgrades/Artemis-Schema-TestrunDB-2.010012-MySQL.sql' to 'Artemis::Schema::TestrunDB v2.010014':;

BEGIN;

ALTER TABLE testrun CHANGE COLUMN created_at created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;


COMMIT;

