-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010035-MySQL.sql' to 'Artemis::Schema::ReportsDB v2.010036':;

BEGIN;

ALTER TABLE reportsection ADD COLUMN ticket_url VARCHAR(255) DEFAULT '',
                          ADD COLUMN wiki_url VARCHAR(255) DEFAULT '',
                          ADD COLUMN planning_id VARCHAR(255) DEFAULT '';


COMMIT;

