-- Convert schema 'upgrades/Artemis-Schema-TestrunDB-2.010017-MySQL.sql' to 'Artemis::Schema::TestrunDB v2.010018':;

BEGIN;

ALTER TABLE host ADD COLUMN active TINYINT DEFAULT '0';

ALTER TABLE testrun_scheduling CHANGE COLUMN status status VARCHAR(255) DEFAULT 'prepare';


COMMIT;

