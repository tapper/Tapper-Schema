-- Convert schema 'upgrades/Artemis-Schema-TestrunDB-2.010021-MySQL.sql' to 'Artemis::Schema::TestrunDB v2.010022':;

BEGIN;

ALTER TABLE queue_host DROP FOREIGN KEY queue_host_fk_queue_id;

ALTER TABLE queue_host ADD CONSTRAINT queue_host_fk_queue_id FOREIGN KEY (queue_id) REFERENCES queue (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE testrun_scheduling CHANGE COLUMN status status VARCHAR(255) DEFAULT 'prepare';


COMMIT;

