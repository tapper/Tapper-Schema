-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010024-MySQL.sql' to 'Artemis::Schema::ReportsDB v2.010026':;

BEGIN;

ALTER TABLE report ADD INDEX report_idx_machine_name (machine_name);

ALTER TABLE reportsection ADD COLUMN bios text,
                          CHANGE COLUMN language_description language_description text;

ALTER TABLE suite ADD INDEX suite_idx_name (name);


COMMIT;

