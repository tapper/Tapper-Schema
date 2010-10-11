-- Convert schema 'upgrades/Artemis-Schema-TestrunDB-2.010031-SQLite.sql' to 'upgrades/Artemis-Schema-TestrunDB-2.010032-SQLite.sql':;

BEGIN;

ALTER TABLE host ADD COLUMN comment VARCHAR(255) DEFAULT '';


COMMIT;

