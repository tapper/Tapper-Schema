use `testrundb`;

DROP TABLE IF EXISTS `testrundb`.`chart_markings`;
CREATE  TABLE `testrundb`.`chart_markings` (
  `chart_marking_id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `chart_version_id` INT UNSIGNED NOT NULL ,
  `chart_marking_color` CHAR(6) NOT NULL ,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY (`chart_marking_id`) ,
  INDEX `fk_chart_markings_01` (`chart_version_id` ASC) ,
  CONSTRAINT `fk_chart_markings_01`
    FOREIGN KEY (`chart_version_id` )
    REFERENCES `testrundb`.`chart_versions` (`chart_version_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

ALTER TABLE `testrundb`.`chart_markings`
    ADD COLUMN `chart_marking_x_from` VARCHAR(512) NULL  AFTER `chart_marking_color` ,
    ADD COLUMN `chart_marking_x_to` VARCHAR(512) NULL  AFTER `chart_marking_x_from` ,
    ADD COLUMN `chart_marking_y_from` VARCHAR(512) NULL  AFTER `chart_marking_x_to` ,
    ADD COLUMN `chart_marking_y_to` VARCHAR(512) NULL  AFTER `chart_marking_y_from`
;