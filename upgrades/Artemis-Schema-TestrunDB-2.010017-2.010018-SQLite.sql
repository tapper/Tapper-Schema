-- Convert schema 'upgrades/Artemis-Schema-TestrunDB-2.010017-SQLite.sql' to 'upgrades/Artemis-Schema-TestrunDB-2.010018-SQLite.sql':;

BEGIN;

ALTER TABLE host ADD COLUMN active TINYINT DEFAULT '0';


COMMIT;

