-- Convert schema 'upgrades/Artemis-Schema-TestrunDB-2.010027-MySQL.sql' to 'Artemis::Schema::TestrunDB v2.010028':;

BEGIN;

ALTER TABLE queue ADD COLUMN active integer(1) DEFAULT '0';

ALTER TABLE testrun_scheduling CHANGE COLUMN status status VARCHAR(255) DEFAULT 'prepare';


COMMIT;

