-- Convert schema 'upgrades/Artemis-Schema-TestrunDB-2.010032-SQLite.sql' to 'upgrades/Artemis-Schema-TestrunDB-2.010034-SQLite.sql':;

BEGIN;

CREATE TABLE host_feature (
  id INTEGER PRIMARY KEY NOT NULL,
  host_id INT NOT NULL,
  entry VARCHAR(255) NOT NULL,
  value VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT 'CURRENT_TIMESTAMP',
  updated_at DATETIME
);

CREATE INDEX host_feature_idx_host_id ON host_feature (host_id);

CREATE TABLE message (
  id INTEGER PRIMARY KEY NOT NULL,
  testrun_id INT(11) NOT NULL,
  message VARCHAR(65000),
  created_at TIMESTAMP DEFAULT 'CURRENT_TIMESTAMP',
  updated_at DATETIME
);

CREATE INDEX message_idx_testrun_id ON message (testrun_id);

CREATE TABLE state (
  id INTEGER PRIMARY KEY NOT NULL,
  testrun_id INT(11) NOT NULL,
  state VARCHAR(65000),
  created_at TIMESTAMP DEFAULT 'CURRENT_TIMESTAMP',
  updated_at DATETIME
);

CREATE INDEX state_idx_testrun_id ON state (testrun_id);

CREATE UNIQUE INDEX unique_testrun_id ON state (testrun_id);

CREATE TEMPORARY TABLE testrun_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  shortname VARCHAR(255) DEFAULT '',
  notes TEXT DEFAULT '',
  topic_name VARCHAR(255) NOT NULL DEFAULT '',
  starttime_earliest DATETIME,
  starttime_testrun DATETIME,
  starttime_test_program DATETIME,
  endtime_test_program DATETIME,
  owner_user_id INT(11),
  wait_after_tests INT(1) DEFAULT 0,
  rerun_on_error INT(11) DEFAULT 0,
  created_at TIMESTAMP DEFAULT 'CURRENT_TIMESTAMP',
  updated_at DATETIME
);

INSERT INTO testrun_temp_alter SELECT id, shortname, notes, topic_name, starttime_earliest, starttime_testrun, starttime_test_program, endtime_test_program, owner_user_id, wait_after_tests, rerun_on_error, created_at, updated_at FROM testrun;

DROP TABLE testrun;

CREATE TABLE testrun (
  id INTEGER PRIMARY KEY NOT NULL,
  shortname VARCHAR(255) DEFAULT '',
  notes TEXT DEFAULT '',
  topic_name VARCHAR(255) NOT NULL DEFAULT '',
  starttime_earliest DATETIME,
  starttime_testrun DATETIME,
  starttime_test_program DATETIME,
  endtime_test_program DATETIME,
  owner_user_id INT(11),
  wait_after_tests INT(1) DEFAULT 0,
  rerun_on_error INT(11) DEFAULT 0,
  created_at TIMESTAMP DEFAULT 'CURRENT_TIMESTAMP',
  updated_at DATETIME
);

CREATE INDEX testrun_idx_owner_user_id03 ON testrun (owner_user_id);

INSERT INTO testrun SELECT id, shortname, notes, topic_name, starttime_earliest, starttime_testrun, starttime_test_program, endtime_test_program, owner_user_id, wait_after_tests, rerun_on_error, created_at, updated_at FROM testrun_temp_alter;

DROP TABLE testrun_temp_alter;


COMMIT;

