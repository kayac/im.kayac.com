-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Fri Sep  4 11:47:50 2009
-- 
SET foreign_key_checks=0;

DROP TABLE IF EXISTS `im_account`;

--
-- Table: `im_account`
--
CREATE TABLE `im_account` (
  `id` INTEGER unsigned NOT NULL,
  `service` VARCHAR(255),
  `username` VARCHAR(255),
  `valid` INTEGER(1) unsigned NOT NULL DEFAULT '0',
  `validation_code` VARCHAR(40),
  `authentication` ENUM('no', 'password', 'secretkey') NOT NULL DEFAULT 'no',
  `authentication_code` VARCHAR(255),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `user`;

--
-- Table: `user`
--
CREATE TABLE `user` (
  `id` INTEGER unsigned NOT NULL auto_increment,
  `username` VARCHAR(255) NOT NULL,
  `password` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE `user_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

SET foreign_key_checks=1;

