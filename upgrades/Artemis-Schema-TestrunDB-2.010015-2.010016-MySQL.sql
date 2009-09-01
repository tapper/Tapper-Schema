-- Convert schema 'upgrades/Artemis-Schema-TestrunDB-2.010015-MySQL.sql' to 'Artemis::Schema::TestrunDB v2.010016':;

BEGIN;

ALTER TABLE queue CHANGE COLUMN created_at created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- ALTER TABLE testrun CHANGE COLUMN created_at created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE testrun_requested_feature DROP INDEX ,
                                      CHANGE COLUMN id id integer(11) NOT NULL auto_increment,
                                      CHANGE COLUMN testrun_id testrun_id integer(11) NOT NULL,
                                      ADD PRIMARY KEY (id);

ALTER TABLE testrun_scheduling CHANGE COLUMN created_at created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;


COMMIT;

