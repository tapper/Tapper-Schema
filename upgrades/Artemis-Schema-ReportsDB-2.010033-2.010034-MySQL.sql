-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010033-MySQL.sql' to 'Artemis::Schema::ReportsDB v2.010034':;

BEGIN;

ALTER TABLE report DROP FOREIGN KEY report_fk_id,
                   DROP FOREIGN KEY report_fk_id_1,
                   DROP INDEX id,
                   DROP COLUMN hardwaredb_systems_id;

ALTER TABLE reportgrouparbitrary ADD INDEX reportgrouparbitrary_idx_report_id (report_id),
                                 ADD CONSTRAINT reportgrouparbitrary_fk_report_id FOREIGN KEY (report_id) REFERENCES report (id) ON DELETE CASCADE;

ALTER TABLE reportgrouptestrun ADD INDEX reportgrouptestrun_idx_report_id (report_id),
                               ADD CONSTRAINT reportgrouptestrun_fk_report_id FOREIGN KEY (report_id) REFERENCES report (id) ON DELETE CASCADE;


COMMIT;

