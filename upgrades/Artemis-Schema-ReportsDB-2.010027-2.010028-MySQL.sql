-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010027-MySQL.sql' to 'Artemis::Schema::ReportsDB v2.010028':;

BEGIN;

SET foreign_key_checks=0;

CREATE TABLE `reportgrouptestrunstats` (
  `testrun_id` integer(11) NOT NULL,
  `total` integer(10),
  `failed` integer(10),
  `passed` integer(10),
  `parse_errors` integer(10),
  `skipped` integer(10),
  `todo` integer(10),
  `todo_passed` integer(10),
  `wait` integer(10),
  INDEX reportgrouptestrunstats_idx_testrun_id (`testrun_id`),
  PRIMARY KEY (`testrun_id`),
  CONSTRAINT `reportgrouptestrunstats_fk_testrun_id` FOREIGN KEY (`testrun_id`) REFERENCES `reportgrouptestrun` (`testrun_id`) ON DELETE CASCADE
) ENGINE=InnoDB;

SET foreign_key_checks=1;


COMMIT;

