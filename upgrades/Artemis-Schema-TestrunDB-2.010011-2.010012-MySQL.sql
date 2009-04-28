-- Convert schema 'upgrades/Artemis-Schema-TestrunDB-2.010011-MySQL.sql' to 'Artemis::Schema::TestrunDB v2.010012':;

BEGIN;

ALTER TABLE testrun DROP COLUMN timeout_after_testprogram;


COMMIT;

