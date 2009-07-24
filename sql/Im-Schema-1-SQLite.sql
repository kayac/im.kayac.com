-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Fri Sep  4 11:47:50 2009
-- 


BEGIN TRANSACTION;

--
-- Table: im_account
--
DROP TABLE im_account;

CREATE TABLE im_account (
  id INTEGER PRIMARY KEY NOT NULL,
  service VARCHAR(255),
  username VARCHAR(255),
  valid INTEGER(1) NOT NULL DEFAULT '0',
  validation_code VARCHAR(40),
  authentication ENUM NOT NULL DEFAULT 'no',
  authentication_code VARCHAR(255)
);

--
-- Table: user
--
DROP TABLE user;

CREATE TABLE user (
  id INTEGER PRIMARY KEY NOT NULL,
  username VARCHAR(255) NOT NULL,
  password VARCHAR(40) NOT NULL
);

CREATE UNIQUE INDEX user_username ON user (username);

COMMIT;
