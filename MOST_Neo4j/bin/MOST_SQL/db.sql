SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `mon_development` ;
CREATE SCHEMA IF NOT EXISTS `mon_development` DEFAULT CHARACTER SET utf8 ;
USE `mon_development` ;

-- -----------------------------------------------------
-- Table `mon_development`.`zone`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mon_development`.`zone` ;

CREATE  TABLE IF NOT EXISTS `mon_development`.`zone` (
  `idzone` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NULL ,
  `description` VARCHAR(45) NULL ,
  `country` VARCHAR(45) NULL ,
  `state` VARCHAR(45) NULL ,
  `county` VARCHAR(45) NULL ,
  `city` VARCHAR(45) NULL ,
  `building` VARCHAR(45) NULL ,
  `floor` VARCHAR(45) NULL ,
  `room` VARCHAR(45) NULL ,
  `area` DOUBLE NULL ,
  `volume` DOUBLE NULL ,
  PRIMARY KEY (`idzone`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mon_development`.`datapoint`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mon_development`.`datapoint` ;

CREATE  TABLE IF NOT EXISTS `mon_development`.`datapoint` (
  `datapoint_name` VARCHAR(100) NOT NULL ,
  `unit` VARCHAR(45) NULL DEFAULT NULL ,
  `type` VARCHAR(45) NULL DEFAULT NULL ,
  `min` DECIMAL(10,2)  NULL DEFAULT NULL ,
  `max` DECIMAL(10,2)  NULL DEFAULT NULL ,
  `accuracy` DECIMAL(10,2)  NULL DEFAULT NULL ,
  `math_operations` VARCHAR(100) NULL DEFAULT NULL ,
  `deadband` DECIMAL(10,2)  NULL DEFAULT NULL ,
  `sample_interval` DECIMAL(10,0)  NULL DEFAULT NULL ,
  `sample_interval_min` DECIMAL(10,0)  NULL DEFAULT NULL ,
  `watchdog` DECIMAL(10,0)  NULL DEFAULT NULL ,
  `virtual` VARCHAR(100) NULL DEFAULT NULL ,
  `custom_attr` VARCHAR(500) NULL DEFAULT NULL ,
  `description` VARCHAR(500) NULL DEFAULT NULL ,
  `zone_idzone` INT NULL DEFAULT NULL ,
  PRIMARY KEY (`datapoint_name`) ,
  INDEX `fk_datapoint_zone1_idx` (`zone_idzone` ASC) ,
  CONSTRAINT `fk_datapoint_zone1`
    FOREIGN KEY (`zone_idzone` )
    REFERENCES `mon_development`.`zone` (`idzone` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mon_development`.`data`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mon_development`.`data` ;

CREATE  TABLE IF NOT EXISTS `mon_development`.`data` (
  `datapoint_name` VARCHAR(100) NOT NULL ,
  `timestamp` DATETIME NOT NULL ,
  `value` DOUBLE NOT NULL ,
  INDEX `fk_data_datapoint1_idx` (`datapoint_name` ASC) ,
  PRIMARY KEY (`datapoint_name`, `timestamp`, `value`) ,
  CONSTRAINT `fk_data_datapoint1`
    FOREIGN KEY (`datapoint_name` )
    REFERENCES `mon_development`.`datapoint` (`datapoint_name` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mon_development`.`connections`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mon_development`.`connections` ;

CREATE  TABLE IF NOT EXISTS `mon_development`.`connections` (
  `number` INT NOT NULL AUTO_INCREMENT ,
  `datapoint_name` VARCHAR(100) NOT NULL ,
  `device_name` VARCHAR(100) NULL ,
  `connection_type` VARCHAR(100) NOT NULL ,
  `connection_variables` VARCHAR(500) NULL ,
  `writeable` BINARY NULL ,
  `vendor` VARCHAR(100) NULL ,
  `model` VARCHAR(100) NULL ,
  `connector_id` VARCHAR(100) NULL ,
  PRIMARY KEY (`number`) ,
  INDEX `connection_type` (`connection_type` ASC) ,
  INDEX `connector_id` (`connector_id` ASC) ,
  INDEX `device` (`device_name` ASC) ,
  INDEX `fk_OPC_DA_datapoint1_idx` (`datapoint_name` ASC) ,
  CONSTRAINT `fk_OPC_DA_datapoint1`
    FOREIGN KEY (`datapoint_name` )
    REFERENCES `mon_development`.`datapoint` (`datapoint_name` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mon_development`.`zone_has_zone`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mon_development`.`zone_has_zone` ;

CREATE  TABLE IF NOT EXISTS `mon_development`.`zone_has_zone` (
  `zone_high` INT NOT NULL ,
  `zone_low` INT NOT NULL ,
  PRIMARY KEY (`zone_high`, `zone_low`) ,
  INDEX `fk_zone_has_zone_zone2_idx` (`zone_low` ASC) ,
  INDEX `fk_zone_has_zone_zone1_idx` (`zone_high` ASC) ,
  CONSTRAINT `fk_zone_has_zone_zone1`
    FOREIGN KEY (`zone_high` )
    REFERENCES `mon_development`.`zone` (`idzone` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_zone_has_zone_zone2`
    FOREIGN KEY (`zone_low` )
    REFERENCES `mon_development`.`zone` (`idzone` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mon_development`.`warning`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mon_development`.`warning` ;

CREATE  TABLE IF NOT EXISTS `mon_development`.`warning` (
  `wid` INT NOT NULL AUTO_INCREMENT ,
  `errorCode` TINYINT NULL ,
  `datapoint_name` VARCHAR(100) NOT NULL ,
  `description` VARCHAR(200) NULL ,
  `toDo` VARCHAR(200) NULL ,
  `fromTime` DATETIME NOT NULL COMMENT '	' ,
  `toTime` DATETIME NULL ,
  `priority` TINYINT NULL ,
  `source` VARCHAR(100) NULL ,
  INDEX `fk_warning_1_idx` (`datapoint_name` ASC) ,
  PRIMARY KEY (`wid`) ,
  CONSTRAINT `fk_warning_1`
    FOREIGN KEY (`datapoint_name` )
    REFERENCES `mon_development`.`datapoint` (`datapoint_name` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mon_development`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mon_development`.`user` ;

CREATE  TABLE IF NOT EXISTS `mon_development`.`user` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(100) NOT NULL ,
  `password` BINARY(60) NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mon_development`.`role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mon_development`.`role` ;

CREATE  TABLE IF NOT EXISTS `mon_development`.`role` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(100) NOT NULL ,
  `description` VARCHAR(100) NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mon_development`.`user_role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mon_development`.`user_role` ;

CREATE  TABLE IF NOT EXISTS `mon_development`.`user_role` (
  `uid` INT NOT NULL ,
  `rid` INT NOT NULL ,
  INDEX `uid_idx` (`uid` ASC) ,
  INDEX `rid_idx` (`rid` ASC) ,
  PRIMARY KEY (`uid`, `rid`) ,
  CONSTRAINT `uid`
    FOREIGN KEY (`uid` )
    REFERENCES `mon_development`.`user` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `rid`
    FOREIGN KEY (`rid` )
    REFERENCES `mon_development`.`role` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
PACK_KEYS = DEFAULT;


-- -----------------------------------------------------
-- Table `mon_development`.`role_zone_permissions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mon_development`.`role_zone_permissions` ;

CREATE  TABLE IF NOT EXISTS `mon_development`.`role_zone_permissions` (
  `role_id` INT NOT NULL ,
  `idzone` INT NOT NULL ,
  `read` TINYINT(1)  NULL DEFAULT FALSE ,
  `write` TINYINT(1)  NULL DEFAULT FALSE ,
  `admin` TINYINT(1)  NULL DEFAULT FALSE ,
  PRIMARY KEY (`role_id`, `idzone`) ,
  INDEX `fk_role_has_zone_zone2_idx` (`idzone` ASC) ,
  INDEX `fk_role_has_zone_role2_idx` (`role_id` ASC) ,
  CONSTRAINT `fk_role_has_zone_role2`
    FOREIGN KEY (`role_id` )
    REFERENCES `mon_development`.`role` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_role_has_zone_zone2`
    FOREIGN KEY (`idzone` )
    REFERENCES `mon_development`.`zone` (`idzone` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- procedure addDatapoint    DONE
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`addDatapoint`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`addDatapoint` 
            (
                IN p_datapoint_name       VARCHAR(100)    ,
                IN p_type                 VARCHAR(45)     ,
                IN p_unit                 VARCHAR(45)     ,
                IN p_accuracy             NUMERIC(10,2)         ,
                IN p_min                  NUMERIC(10,2)         ,
                IN p_max                  NUMERIC(10,2)         ,
                IN p_deadband             NUMERIC(10,2)   ,
                IN p_sample_interval      NUMERIC         ,
                IN p_sample_interval_min  NUMERIC         ,
                IN p_watchdog             NUMERIC         ,
                IN p_math_operations      VARCHAR(45)     ,
                IN p_virtual              VARCHAR(100)    ,
                IN p_custom_attr          VARCHAR(500)    ,
                IN p_description          VARCHAR(500)    
            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#   Zach R.
#DATE OF CREATION:
#   unknown (Dec 2010)
#DATE OF LAST MODIFICATION:
#   2012-07-06
#FUNCTION OF STORED PROCEDURE:
#   adds entry in table datapoint
#
#   all parameters have to be served to the stored procedure, when no entry of argument wanted in table datapoint hand over null (works only if null is allowed)
#   for wrong input types unintended results may occour (e.g. string when int is wanted can be interpreted as 0 or numbers in string are taken)
#
#   datapoint_name is primary key
#   also adds one entry for the datapoint in table data (to make SP addData easier/faster)
#
#   use NULL for values not provided!
#   - watchdog, 0 = disabled, NULL use 1.5*sample_interval for check interval
#
#EXAMPLE: CALL addDatapoint('name2','type2',null,null,12,14,null,null,null,null,null,null,null)
#               adds datapoint with: name equals name2 and type equals type2
#                                    min equals 12 and max equals 14
#                                    other attributes are not set (null)

        DECLARE lv_currentTimestamp     timestamp;  

            INSERT INTO datapoint
                (
                    datapoint_name      , 
                    type                ,
                    unit                ,
                    accuracy            ,
                    min                 ,
                    max                 ,
                    deadband            ,
                    sample_interval     ,
                    sample_interval_min ,
                    watchdog            ,
                    math_operations     ,
                    custom_attr         ,
                    virtual             ,
                    description
                )
            
            VALUES
                (
                    p_datapoint_name     ,
                    p_type               ,
                    p_unit               ,
                    p_accuracy           ,
                    p_min                ,
                    p_max                ,
                    p_deadband           ,
                    p_sample_interval    ,
                    p_sample_interval_min,
                    p_watchdog           ,
                    p_math_operations    ,
                    p_custom_attr        ,
                    p_virtual            ,
                    p_description        
                ) ;
                
                #add entry to table data to makeSP addData easier/faster
                SET lv_currentTimestamp = 
                        ( SELECT NOW() );
                CALL addDataForced(p_datapoint_name, lv_currentTimestamp , 0);
END


$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure addDataForced DONE
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`addDataForced`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`addDataForced` 
            (
                IN p_datapoint_name        VARCHAR(100)    ,
                IN p_timestamp             DATETIME    ,
                IN p_value                 double
            )         
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#    BRAEUER R.
#DATE OF CREATION:
#   UNKNOWN (~Dec 2010)
#DATE OF LAST MODIFICATION:
#   2011-07-12
#FUNCTION OF STORED PROCEDURE:
#   adds entry in table data without constraint checking
#
#   all parameters have to be served to the stored procedure, when no entry of argument wanted in table datapoint hand over null (works only if null is allowed)
#   for wrong input types unintended results may occour (e.g. string when int is wanted can be interpreted as 0 or numbers in string are taken)
#
#   iddata is primary key and automatically generated (incremented)
#   served datapoint_name has to exist in table datapoint, otherwise an error will be raised!
#
#EXAMPLE: CALL addDatapoint('name2','2010-12-28 12:00:00',14.23)
#             adds data for existing datapoint name2 with timestamp 2010-12-28 12:00:00 and value 14.23
               
               INSERT INTO data
                (
                    datapoint_name  ,
                    timestamp       , 
                    value
                )
            
            VALUES
                (
                    p_datapoint_name    ,
                    p_timestamp         ,
                    p_value
                ) ;

END








$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure raiseError
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`raiseError`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`raiseError`(
            p_msg VARCHAR(128)
        )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   unknown (Dec 2010)
#DATE OF LAST MODIFICATION:
#   unknown
#FUNCTION OF STORED PROCEDURE:
#   Raise an error with user defined error message. Probably won't work on all systems!
#EXAMPLE:
#   CALL raiseError ('Something bad just happened.');        
        
        DECLARE _msg TINYINT;

        -- Force an error to be raised by assigning a string to an
        -- integer variable. The string will appear on the client.
        SET _msg = p_msg;
        
END





$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure addConnection  DONE
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`addConnection`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`addConnection` 
            (
                IN p_datapoint_name            VARCHAR(100)    ,
                IN p_device_name               VARCHAR(100)    ,
                IN p_connection_type           VARCHAR(100)    ,
                IN p_connection_variables      VARCHAR(500)    ,
                IN p_writeable                 BINARY          ,
                IN p_vendor                    VARCHAR(100)    ,
                IN p_model                     VARCHAR(100)    ,
                IN p_connector_id              VARCHAR(100)    
            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#   ZACH R.
#DATE OF CREATION:
#   2012-07-06
#DATE OF LAST MODIFICATION:
#   2012-07-31
#FUNCTION OF STORED PROCEDURE:
#   adds entry in table connections
#   
#   all parameters have to be served to the stored procedure, when no entry of argument wanted in table datapoint hand over null (works only if null is allowed)
#   for wrong input types unintended results may occour (e.g. string when int is wanted can be interpreted as 0 or numbers in string are taken)
#   
#   datapoint_name is foreign key and has to exist in table datapoint
#EXAMPLE:
#   CALL addConnection('dpName2','device1','opc-da','/path/to/opc/name2', false,NULL,NULL,NULL);


# connection is a reserved word in mySQL, so connections (with s) is used as table name
            INSERT INTO connections
                (
                    datapoint_name           ,
                    device_name              ,
                    connection_type          ,
                    connection_variables     ,    
                    writeable                ,
                    vendor                   ,
                    model                    ,
                    connector_id      
                )
            
            VALUES
                (
                    p_datapoint_name          ,
                    p_device_name             ,
                    p_connection_type         ,
                    p_connection_variables    ,
                    p_writeable               ,
                    p_vendor                  ,
                    p_model                   ,
                    p_connector_id              
                ) ;
END




$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure addZone  DONE
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`addZone`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`addZone`
            (
                IN p_name                   VARCHAR(45)    ,
                IN p_description            VARCHAR(45)    ,
                IN p_country                VARCHAR(45)    ,
                IN p_state                  VARCHAR(45)    ,
                IN p_county                 VARCHAR(45)    ,
                IN p_city                   VARCHAR(45)    ,
                IN p_building               VARCHAR(45)    ,
                IN p_floor                  VARCHAR(45)    ,
                IN p_room                   VARCHAR(45)    ,
                IN p_area                   DOUBLE         ,
                IN p_volume                 DOUBLE     
            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   unknown (Dec 2010)
#DATE OF LAST MODIFICATION:
#   unknown
#FUNCTION OF STORED PROCEDURE:
#   adds entry in table zone
#   
#   all parameters have to be served to the stored procedure, when no entry of argument wanted in table datapoint hand over null (works only if null is allowed)
#   for wrong input types unintended results may occour (e.g. string when int is wanted can be interpreted as 0 or numbers in string are taken)
#   
#   idzone is primary key and automatically generated (incremented)
#   
#EXAMPLE: CALL addZone('name2','description2','country2','state2','county2','city2','building2','floor2','room2',13,28.4)

            INSERT INTO zone
                (
                    name              , 
                    description       ,
                    country           ,
                    state             ,
                    county            , 
                    city              ,
                    building          ,
                    floor             ,
                    room              ,
                    area              ,
                    volume            
                )
            
            VALUES
                (
                    p_name             ,
                    p_description      ,
                    p_country          ,
                    p_state            ,
                    p_county           ,
                    p_city             ,
                    p_building         ,
                    p_floor            ,
                    p_room             ,
                    p_area             ,
                    p_volume         
                ) ;
END



$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure insertTestdata
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`insertTestdata`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`insertTestdata`()
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#   ZACH R.
#DATE OF CREATION:
#   unknown (Dec 2010)
#DATE OF LAST MODIFICATION:
#   2012-07-31
#FUNCTION OF STORED PROCEDURE:
#   insert testdata in database

        CALL addDatapoint('tem1','temperature','°C','0.1',-50,100,0.2,3600,1,0,'not supported yet',NULL,NULL,NULL);
        CALL addDatapoint('tem2','temperature','°C','0.1',-50,100,0.2,3600,1,NULL,'not supported yet',NULL,NULL,NULL);
        CALL addDatapoint('tem3','temperature','°C','0.1',-50,100,0.2,3600,1,NULL,'not supported yet',NULL,NULL,NULL);
        CALL addDatapoint('tem4','temperature','°C','0.1',-50,100,0.2,3600,1,7600,'not supported yet',NULL,NULL,NULL);
        CALL addDatapoint('con1','contact','boolean',NULL,NULL,NULL,NULL,3600,0.4,0,'not supported yet',NULL,NULL,NULL);
        CALL addDatapoint('name3','type3','unit3',123453,4,5,3453,3453,3,3,'math','custom',NULL,NULL);
        CALL addDatapoint('name4','type4','unit4',123453,4,5,3453,3453,3,4,'math','custom',NULL,NULL);
        CALL addDatapoint('name5','type5','unit5',123453,4,5,3453,3453,3,5,'math','custom',NULL,NULL);
        CALL addDatapoint('name6','type6','unit6',123453,4,5,3453,3453,3,6,'math','custom',NULL,NULL);
        CALL addDatapoint('name7','type7','unit7',123453,4,5,3453,3453,3,7,'math','custom',NULL,NULL);
        CALL addDatapoint('rhu1','rhu','%','1',0,100,2,3600,1,NULL,'not supported yet',NULL,NULL,NULL);
        CALL addDatapoint('rhu2','rhu','%','1',0,100,2,3600,1,0,'not supported yet',NULL,NULL,NULL);

        CALL addDatapointConnection('tem100','type101','unit101',123453,4,5,3453,3453,3,8,'math','custom',NULL,NULL,'device1','opc-da','/path/to/opc/element',false,NULL,NULL,NULL);
        CALL addDatapointConnection('tem101','type101','unit101',123453,4,5,3453,3453,3,9,'math','custom',NULL,NULL,NULL,'jdbc','sqlite /path/to/opc/element; sqltable dsfsd;',NULL,NULL,NULL,NULL);
        CALL addDatapointConnection('name11','type2','unit2',123453,4,5,3453,3453,3,3600,'math2','custom2','virtual2','description2','devide_name2','connection_type2','connection_variable2',0,'vendor2','model2','connector_id2');
        CALL addDatapointConnection('name12','type2','unit2',123453,4,5,3453,3453,3,3600,'math2','custom2','virtual2','description2','devide_name2','connection_type2','connection_variable2',0,'vendor2','model2','connector_id2');

        CALL addConnection('name3','device1','opc-da','/path/to/opc/name3', false,NULL,NULL,NULL);
        CALL addConnection('name3','device2','opc-da','/path/to/opc/name3', false,NULL,NULL,NULL);
        CALL addConnection('name3','device23','opc-da','/path/to/opc/name3', false,NULL,NULL,NULL);
        CALL addConnection('name4','device3','opc-da','/path/to/opc/name4', false,NULL,NULL,NULL);

        CALL addDataForced('tem1','2010-12-29 12:02:30',1);
        CALL addDataForced('tem1','2010-12-29 12:02:20',0);
        CALL addDataForced('tem1','2010-12-29 12:04:10',20);
        CALL addDataForced('tem1','2010-12-29 12:04:12',30);
        CALL addDataForced('tem1','2010-12-29 12:06:10',20);
        CALL addDataForced('tem1','2010-12-29 12:06:40',10);
        CALL addDataForced('tem1','2010-12-29 12:08:40',20);
        CALL addDataForced('tem1','2010-12-29 12:10:00',22);
        CALL addDataForced('tem1','2010-12-29 12:10:00',20);
        CALL addDataForced('tem1','2010-12-29 12:10:01',21);
        CALL addDataForced('tem1','2010-12-29 12:10:01',30);
        CALL addDataForced('tem1','2010-12-29 12:10:10',21);
        CALL addDataForced('tem1','2010-12-29 12:11:20',25);
        CALL addDataForced('tem1','2010-12-29 12:12:05',35);
        CALL addDataForced('tem1','2010-12-29 12:13:01',30);
        CALL addDataForced('tem1','2010-12-29 12:14:10',21);
        CALL addDataForced('tem1','2010-12-29 12:15:50',25);
        CALL addDataForced('tem1','2010-12-29 12:31:00',35);
        CALL addDataForced('tem1','2010-12-29 12:32:01',23);
        CALL addDataForced('tem1','2010-12-29 12:32:55',23);
        CALL addDataForced('tem1','2010-12-29 12:34:05',28);
        CALL addDataForced('tem1','2010-12-29 12:35:40',26);
        CALL addDataForced('rhu1','2010-12-29 12:40:00',75);
        CALL addDataForced('tem1','2010-12-29 12:40:00',25);
        CALL addDataForced('rhu2','2010-12-29 12:40:00',88);
        CALL addDataForced('tem1','2010-12-29 13:00:00',22);
        CALL addDataForced('tem1','2010-12-29 13:00:00',24);
        CALL addDataForced('tem1','2010-12-29 13:00:00',11);
        CALL addDataForced('tem1','2010-12-29 13:00:00',12);
        CALL addDataForced('tem2','2010-12-29 12:10:00',20);
        CALL addDataForced('tem2','2010-12-29 12:12:00',21);
        CALL addDataForced('tem2','2010-12-29 12:13:00',21);
        CALL addDataForced('tem2','2010-12-29 12:15:01',20);
        CALL addDataForced('tem2','2010-12-29 12:15:10',20);
        CALL addDataForced('tem2','2010-12-29 12:30:00',23);
        CALL addDataForced('tem2','2010-12-29 12:31:00',23);
        CALL addDataForced('tem2','2010-12-29 12:32:01',22);
        CALL addDataForced('tem2','2010-12-29 12:32:55',22);
        CALL addDataForced('tem2','2010-12-29 12:34:05',22);
        CALL addDataForced('tem2','2010-12-29 12:35:40',22);
        CALL addDataForced('tem2','2010-12-29 12:40:00',20);
        CALL addDataForced('tem2','2010-12-29 12:48:00',22);
        CALL addDataForced('tem2','2010-12-29 12:49:00',24);
        CALL addDataForced('tem2','2010-12-29 13:49:10',23);
        CALL addDataForced('tem2','2010-12-29 13:00:00',23);
        
        CALL addDataForced('tem4','2010-12-29 12:10:00',20);
        CALL addDataForced('tem4','2010-12-29 12:12:00',20);
        CALL addDataForced('tem4','2010-12-29 12:13:00',22);
        CALL addDataForced('tem4','2010-12-29 12:15:01',29);
        CALL addDataForced('tem4','2010-12-29 12:15:10',21);
        CALL addDataForced('tem4','2010-12-29 12:30:00',20);
        CALL addDataForced('tem4','2010-12-29 12:31:00',25);
        CALL addDataForced('tem4','2010-12-29 12:32:01',23);
        CALL addDataForced('tem4','2010-12-29 12:32:55',23);
        CALL addDataForced('tem4','2010-12-29 12:34:05',20);
        CALL addDataForced('tem4','2010-12-29 12:35:40',26);
        CALL addDataForced('tem4','2010-12-29 12:40:00',25);
        CALL addDataForced('tem4','2010-12-29 12:48:00',23);
        CALL addDataForced('tem4','2010-12-29 12:49:00',23);
        CALL addDataForced('tem4','2010-12-29 13:49:10',20);
        CALL addDataForced('tem4','2010-12-29 13:00:00',23);
        
        CALL addDataForced('con1','2010-12-29 12:02:23',0);
        CALL addDataForced('con1','2010-12-29 12:02:30',1);
        CALL addDataForced('con1','2010-12-29 12:04:10',0);
        CALL addDataForced('con1','2010-12-29 12:04:32',1);
        CALL addDataForced('con1','2010-12-29 12:06:14',3);
        CALL addDataForced('con1','2010-12-29 12:06:30',0);
        CALL addDataForced('con1','2010-12-29 12:08:40',5.3);
        CALL addDataForced('con1','2010-12-29 12:10:00',1);
        CALL addDataForced('con1','2010-12-29 12:10:08',1);
        CALL addDataForced('con1','2010-12-29 12:10:09',1);
        CALL addDataForced('con1','2010-12-29 12:10:20',0);
        CALL addDataForced('con1','2010-12-29 12:30:40',1);
        CALL addDataForced('con1','2010-12-29 12:31:00',0);
        CALL addDataForced('con1','2010-12-29 12:32:05',1);
        CALL addDataForced('con1','2010-12-29 12:32:53',1);
        CALL addDataForced('con1','2010-12-29 12:33:01',0);
        CALL addDataForced('con1','2010-12-29 12:35:00',1);
        CALL addDataForced('con1','2010-12-29 12:35:15',0);
        CALL addDataForced('con1','2010-12-29 12:40:00',0);
        
        CALL addDataForced('rhu1','2010-12-29 12:10:09',40);
        CALL addDataForced('rhu1','2010-12-29 12:10:10',60);
        CALL addDataForced('rhu1','2010-12-29 12:30:00',55);
        CALL addDataForced('rhu1','2010-12-29 12:31:00',54);
        CALL addDataForced('rhu1','2010-12-29 12:32:01',76);
        CALL addDataForced('rhu1','2010-12-29 12:32:55',32);
        CALL addDataForced('rhu1','2010-12-29 12:33:05',43);
        CALL addDataForced('rhu1','2010-12-29 12:35:00',45);
        CALL addDataForced('rhu1','2010-12-29 12:35:05',76);
        CALL addDataForced('rhu1','2010-12-29 12:40:00',80);

        CALL addConnection('tem1','device2','opc-da','/path/to',true,NULL,NULL,NULL);
        CALL addConnection('con1','device3','opc-da','/path/to',true,NULL,NULL,NULL);
        CALL addConnection('name3','device4','jdbc','sqlite path/to/file; sqlTableName test;',false,'model1','vendor1',NULL);
        CALL addConnection('name4',NULL,'jdbc','sqlite path/to/file; sqlTableName test;',false,'model2','vendor2',NULL);
        CALL addConnection('name5',NULL,'jdbc','sqlite path/to/file; sqlTableName test;',false,NULL,NULL,NULL);
        CALL addConnection('name6',NULL,'jdbc','sqlite path/to/file; sqlTableName test;',false,NULL,NULL,NULL);
        CALL addConnection('name7',NULL,'jdbc','sqlite path/to/file; sqlTableName test;',false,NULL,NULL,NULL);
        
    
        CALL addZone('con1','description2','country2','state2','county2','city2','building2','floor2','room2',13,28.4);
        CALL addZone('name3','description3','country3','state3','county3','city3','building3','floor3','room3',13,28.4);
        CALL addZone('name4','description4','country4','state4','county4','city4','building4','floor4','room4',13,28.4);
        CALL addZone('name5','description5','country5','state5','county5','city5','building5','floor5','room5',13,28.6);
        CALL addZone('name6','description6','country6','state6','county6','city6','building6','floor6','room6',13,28.7);
        CALL addZone('name7','description7','country7','state7','county7','city7','building7','floor7','room7',13,28.4);

        
        CALL addZone('tem1','description1','country1','state1','county1','city1','building1','floor1','room1',1,1.4);
        CALL addZone('con1','description2','country2','state2','county2','city2','building2','floor2','room2',2,2.4);
        CALL addZone('name3','description3','country3','state3','county3','city3','building3','floor3','room3',3,3.4);
        CALL addZone('name4','description4','country4','state4','county4','city4','building4','floor4','room4',4,4.4);
        CALL addZone('name5','description5','country5','state5','county5','city5','building5','floor5','room5',5,5.4);
        CALL addZone('name6','description6','country6','state6','county6','city6','building6','floor6','room6',6,6.4);
        CALL addZone('name7','description7','country7','state7','county7','city7','building7','floor7','room7',7,7.4);
        
        CALL addZone('tem1','description1','country1','state1','county1','city1','building1','floor1','room10',1,1.4);
        CALL addZone('con1','description2','country2','state2','county2','city2','building2','floor2','room20',2,2.4);
        CALL addZone('name3','description3','country3','state3','county3','city3','building3','floor3','room30',3,3.4);
        CALL addZone('name4','description4','country4','state4','county4','city4','building4','floor4','room40',4,4.4);
        CALL addZone('name5','description5','country5','state5','county5','city5','building5','floor5','room50',5,5.4);
        CALL addZone('name6','description6','country6','state6','county6','city6','building6','floor6','room60',6,6.4);
        CALL addZone('name7','description7','country7','state7','county7','city7','building7','floor7','room70',7,7.4);
        
        CALL addZone('tem1','description1','country1','state1','county1','city1','building1','floor1','room11',1,1.4);
        CALL addZone('tem1','description1','country1','state1','county1','city1','building1','floor1','room12',1,1.4);
        CALL addZone('tem1','description1','country1','state1','county1','city1','building1','floor1','room13',1,1.4);
        
        CALL addZone('str','description1','country1','state1','county1','city1','building1','floor1','room11',1,1.4);
        CALL addZone('tem1','description1','str','state1','county1','city1','building1','floor1','room12',1,1.4);
        CALL addZone('tem1','str','country1','state1','county1','city1','building1','floor1','room13',1,1.4);
        CALL addZone('str','description1','country1','str','county1','city1','building1','floor1','room11',1,1.4);
        CALL addZone('tem1','description1','country1','str','county1','city1','building1','floor1','room12',1,1.4);
        CALL addZone('tem1','description1','country1','state1','county1','str','building1','floor1','room13',1,1.4);
        
        CALL addDatapointToZone('tem1',1);
        CALL addDatapointToZone('tem2',1);
        CALL addDatapointToZone('rhu1',1);     
        CALL addDatapointToZone('con1',2);
        CALL addDatapointToZone('name3',3);
        CALL addDatapointToZone('name4',4);
        CALL addDatapointToZone('name5',1);
        CALL addDatapointToZone('name6',1);
        CALL addDatapointToZone('tem3',5);
        CALL addDatapointToZone('tem4',10);
 
        CALL addZoneToZone(5,1);
        CALL addZoneToZone(5,2);
        CALL addZoneToZone(6,1);
        CALL addZoneToZone(6,3);
        CALL addZoneToZone(7,2);
        CALL addZoneToZone(7,4);
        CALL addZoneToZone(8,3);
        CALL addZoneToZone(8,4);
        CALL addZoneToZone(9,5);
        CALL addZoneToZone(9,7);
        CALL addZoneToZone(10,3);
        CALL addZoneToZone(10,5);
        CALL addZoneToZone(11,3);
        CALL addZoneToZone(11,8);
        CALL addZoneToZone(11,10);
        #make inconsistent database zone_has_zone
        CALL addZoneToZone(13,14);
        CALL addZoneToZone(14,13);
        
        #CALL addDatapointToDevice('tem1','device1');
        
        
        #insert into tables for UI
        
        CALL addUser('user1','$2a$10$VWE1kL9BwSYCar1cx0HL.OmWJvOL/NV7YB5VBhOllu29aeNN77zs6');
        CALL addUser('user2','$2a$10$VWE1kL9BwSYCar1cx0HL.OmWJvOL/NV7YB5VBhOllu29aeNN77zs6');
        CALL addUser('test', '$2a$10$VWE1kL9BwSYCar1cx0HL.OmWJvOL/NV7YB5VBhOllu29aeNN77zs6');
        CALL addUser('mostsoc', '$2a$10$MJ7YYJut10TMeBuPaGyPYu2N6hW/vRfUk6vdMu9Nls0KXs..XUT2y');

        
        CALL addRole('role1','test role 1');
        CALL addRole('role2','test role 2');
        CALL addRole('role3','test role 3');
        CALL addRole('person', 'Person Module');
        CALL addRole('livechart', 'Live Chart Module');
        CALL addRole('newAP', 'New Working Package');
        CALL addRole('desktop', 'Desktop Module');
        CALL addRole('export', 'Export Module');
        
        CALL addUserToRole('user1','role1');
        CALL addUserToRole('user1','role2');
        CALL addUserToRole('user1','role3');
        CALL addUserToRole('user2','role2');
        CALL addUserToRole('mostsoc','person');
        CALL addUserToRole('mostsoc','livechart');
        CALL addUserToRole('mostsoc','newAP');
        CALL addUserToRole('mostsoc','desktop');
        CALL addUserToRole('mostsoc','export');


        CALL addRoleAccessToZone('role1',1,true, false, false);
        CALL addRoleAccessToZone('role1',2,true, true, false);
        CALL addRoleAccessToZone('role1',3,true, false, false);
        CALL addRoleAccessToZone('role1',4,true, false, false);
        CALL addRoleAccessToZone('role1',5,true, true, true);
        CALL addRoleAccessToZone('role1',10,true, false, false);
        CALL addRoleAccessToZone('role2',1,false, true, false);

        
        #add event to added periodicly add new values
        # TODO create event not possible withing stored procedure
        #CREATE EVENT `demo_new_rhu1_value` ON SCHEDULE EVERY 200 SECOND STARTS '2011-06-22 15:00:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL mon_development.addData('rhu1',UTC_TIMESTAMP(),RAND()*10);

END











$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure test
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`test`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`test`()

BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   unknown (Dec 2010)
#DATE OF LAST MODIFICATION:
#   2012-10-23
#FUNCTION OF STORED PROCEDURE:
#   erase all old data from tables and insert new (default values)

        #prepare statement so that the database name is always mon_development (if mon_development is written as a string it is not changed when MySQL schema name is changed :-) )
        SET @stmt_expr_01 = 'TRUNCATE mon_development.warning;';    
        SET @stmt_expr_02 = 'TRUNCATE mon_development.role_zone_permissions;';    
        SET @stmt_expr_03 = 'TRUNCATE mon_development.data;';    
        SET @stmt_expr_04 = 'TRUNCATE mon_development.connections;';    
        SET @stmt_expr_05 = 'TRUNCATE mon_development.datapoint;';    
        SET @stmt_expr_06 = 'TRUNCATE mon_development.zone_has_zone;';    
        SET @stmt_expr_07 = 'TRUNCATE mon_development.zone;';    
        SET @stmt_expr_08 = 'TRUNCATE mon_development.user_role;';      
        SET @stmt_expr_09 = 'TRUNCATE mon_development.role;';    
        SET @stmt_expr_10 = 'TRUNCATE mon_development.user;';    
        #for testing purpose
        SELECT @stmt_expr_01;
        
        PREPARE stmt_01 FROM @stmt_expr_01;
        PREPARE stmt_02 FROM @stmt_expr_02;
        PREPARE stmt_03 FROM @stmt_expr_03;
        PREPARE stmt_04 FROM @stmt_expr_04;
        PREPARE stmt_05 FROM @stmt_expr_05;
        PREPARE stmt_06 FROM @stmt_expr_06;
        PREPARE stmt_07 FROM @stmt_expr_07;
        PREPARE stmt_08 FROM @stmt_expr_08;
        PREPARE stmt_09 FROM @stmt_expr_09;
        PREPARE stmt_10 FROM @stmt_expr_10;
        
        EXECUTE stmt_01;
        EXECUTE stmt_02;
        EXECUTE stmt_03;
        EXECUTE stmt_04;
        EXECUTE stmt_05;
        EXECUTE stmt_06;
        EXECUTE stmt_07;
        EXECUTE stmt_08;
        EXECUTE stmt_09;
        EXECUTE stmt_10;
        
        
        SET @stmt_expr = 'CALL `mon_development`.insertTestdata;';  
        PREPARE stmt FROM @stmt_expr;
        EXECUTE stmt; 
        

        #DROP all TEMPORARY tables to prevent warning in testscript_performance
        #TODO: update this
        DROP TABLE IF EXISTS data_periodic;
        DROP TABLE IF EXISTS data_periodic_dp1;
        DROP TABLE IF EXISTS data_periodic_dp2;
        DROP TABLE IF EXISTS data_calcAverageWeighted;
        DROP TABLE IF EXISTS data_tmp;
        DROP TABLE IF EXISTS data_tmp_sorted;
        DROP TABLE IF EXISTS tmp_SP_getPermissionOfUserForDatapoint;

        #crate tables that may be needed when testing SP that are normally not called directly (e.g. interpolateValuesLinear)
        CREATE TEMPORARY TABLE IF NOT EXISTS data_periodic (
                    `iddata_periodic` INT NOT NULL AUTO_INCREMENT        ,
                    `value` DOUBLE                                       ,
                    `timestamp` DATETIME                                 ,
                    `quality`   DOUBLE                                   ,
                    `datapoint_name`    VARCHAR(100)                     ,
                    PRIMARY KEY(`iddata_periodic`)                       
                    );
        TRUNCATE TABLE data_periodic;
        
        CREATE TEMPORARY TABLE IF NOT EXISTS data_periodic_dp1  LIKE  data_periodic;
        TRUNCATE TABLE data_periodic_dp1;
        
        CREATE TEMPORARY TABLE IF NOT EXISTS data_periodic_dp2  LIKE  data_periodic;
        TRUNCATE TABLE data_periodic_dp2;
        
        CREATE TEMPORARY TABLE IF NOT EXISTS data_calcAverageWeighted (
                        `id`                        INT         NOT NULL AUTO_INCREMENT      ,
                        `value`                     DOUBLE                                   ,
                        `timestamp`                 DATETIME                                 ,
                        `timeduration`              INT                                      ,
                        PRIMARY KEY(`id`)                       
                        );
        TRUNCATE TABLE data_calcAverageWeighted;
        
        CREATE TEMPORARY TABLE IF NOT EXISTS data_tmp (
                 `id` INT NOT NULL AUTO_INCREMENT                                   ,
                 `value`                            DOUBLE                          ,
                 `timestamp`                        DATETIME                        ,
                 `valid`                            BOOLEAN                         ,
                 `datapoint_name`                   VARCHAR(100)                    ,
                 `quality`                          DOUBLE                          ,
                 PRIMARY KEY(`id`)                       
                 );
        CREATE TEMPORARY TABLE IF NOT EXISTS data_tmp_sorted LIKE data_tmp;
        TRUNCATE TABLE data_tmp;
        
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_SP_getPermissionOfUserForDatapoint (
                        `id`                INT NOT NULL AUTO_INCREMENT      ,
                        `idzone`            INT NOT NULL                     ,
                        PRIMARY KEY(`id`)                                  
                 );
    TRUNCATE TABLE tmp_SP_getPermissionOfUserForDatapoint;
        
END




$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure addDatapointToZone  DONE
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`addDatapointToZone`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`addDatapointToZone` (
                            IN p_datapoint_name     VARCHAR(100)        ,
                            IN p_idzone             INT                     
                        )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-02-10
#DATE OF LAST MODIFICATION:
#   2011-07-12
#FUNCTION OF STORED PROCEDURE:
#   adds an existing datapoint to an existing zone
#EXAMPLE:
#   CALL addDatapointToZone('tem2',2);
    
    UPDATE datapoint SET zone_idzone=p_idzone WHERE datapoint_name=p_datapoint_name;
    
END



$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getValuesPeriodicAnalog
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getValuesPeriodicAnalog`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getValuesPeriodicAnalog`(
                IN p_datapoint_name        VARCHAR(100)    ,
                IN p_starttime             DATETIME        ,
                IN p_endtime               DATETIME        ,
                IN p_periode               DOUBLE          ,
                IN p_mode                  INT              
            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   UNKNOWN (~Jan 2010)
#DATE OF LAST MODIFICATION:
#   2012-09-15
#FUNCTION OF STORED PROCEDURE:
#   this function generates periodic values for analog values
#   p_periode is the output interval of the generated periodic values, the function 
#   which is used for interpolation is because of flexibility implemented as another stored procedure
#   p_mode sets the mode for calculation: 1 -> weighted averaging / linear interpolation
#                                         2 -> weighted averaging / sample & hold
#                                         3 -> difference value / zero
#
#                                         modes higher than 1000 are equal to modes higher than zero, but the output is depressed (needes because of SP getValuesOfDatapointWhereDpXXX)
#                                         e.g. mode 1002 = mode 2 without output (values have to be read from temporary table by calling SP/function)
#EXAMPLE:
#   CALL getValuesPeriodicAnalog('tem1','2010-12-29 12:00:00', '2010-12-29 13:00:00',60,1);

    DECLARE lv_firstDate                DATETIME;
    DECLARE lv_firstValue               DOUBLE;
    DECLARE lv_lastValidValue           DOUBLE;
    DECLARE lv_currentValue             DOUBLE;
    DECLARE lv_currentValueMax          DOUBLE;
    DECLARE lv_quality                  DOUBLE;
    DECLARE lv_starttime_per            DATETIME;
    DECLARE lv_endtime_per              DATETIME;
    DECLARE lv_starttime_interpol       DATETIME;
    DECLARE lv_lastValidValueTimestamp  DATETIME;
    DECLARE lv_lastperiode_was_valid    BOOLEAN;
    DECLARE lv_countPeriod              INT;
    DECLARE lv_outputEnabled            BOOLEAN;
    
    #initialize local variables if needed
    SET lv_outputEnabled = TRUE;
    
    #check if given dates(time) are allowed
    IF (SELECT TIME_TO_SEC(TIMEDIFF(p_endtime, p_starttime))) < p_periode
    THEN
        CALL raiseError('endtime must be later than starttime + one periode');
    ELSE
    #check if datapoint_name exists
    IF  (SELECT count(datapoint_name) FROM datapoint WHERE datapoint_name=p_datapoint_name) = 0
    THEN
        CALL raiseError('given datapoint_name does not exist in database(in table datapoint)');
    ELSE
    
        CREATE TEMPORARY TABLE IF NOT EXISTS data_periodic (
                        `iddata_periodic` INT NOT NULL AUTO_INCREMENT        ,
                        `value` DOUBLE                                       ,
                        `timestamp` DATETIME                                 ,
                        `quality`   DOUBLE                                   ,
                        `datapoint_name`    VARCHAR(100)                     ,
                        PRIMARY KEY(`iddata_periodic`)                       
                        );
        TRUNCATE TABLE data_periodic;
            
        #TODO: instead of the following query also the first SET lv_firstValue=... (some lines beneath this) could be used and cached (because it is needed anywayin most cases). If the returned value is NULL, no values are in the database
        IF  (SELECT count(value) FROM data WHERE timestamp BETWEEN p_starttime AND p_endtime AND datapoint_name=p_datapoint_name) = 0
        THEN
            
            INSERT INTO data_periodic (
                value                   ,
                timestamp               ,
                datapoint_name          ,
                quality         
            )
            VALUES (
                NULL                    ,
                p_starttime             ,
                p_datapoint_name        ,
                0                                
            );
            
            SET lv_starttime_per=p_starttime+1;
            SET lv_endtime_per=
                (SELECT DATE_ADD(p_starttime,INTERVAL p_periode SECOND));
            
            #do calculations while endtime for next periode sooner than final endtime
            WHILE (SELECT TIME_TO_SEC(TIMEDIFF(p_endtime, lv_endtime_per))) >= 0
                DO
                
                        INSERT INTO data_periodic (
                            value                   ,
                            timestamp               ,
                            datapoint_name          ,
                            quality         
                        )
                        VALUES (
                            NULL                    ,
                            lv_endtime_per          ,
                            p_datapoint_name        ,
                            0                                
                        );
            
            #shift to next periode
            #lv_endtime_per+1 because SQL BETWEEN function includes the limits to (closed set)
            SET lv_starttime_per = lv_endtime_per + 1;
            SET lv_endtime_per=
                    (SELECT DATE_ADD(lv_endtime_per,INTERVAL p_periode SECOND));
            END WHILE;

        ELSE
            #---------------------------------------------------------------------------------------------
            #-------------------------------- start of main algorithm ------------------------------------
            #---------------------------------------------------------------------------------------------
            SET lv_starttime_per=p_starttime+1;
            SET lv_endtime_per=
                (SELECT DATE_ADD(p_starttime,INTERVAL p_periode SECOND));
            SET lv_firstDate=
            -- get first date in given timeslot of given datapoint_name
                (SELECT MIN(timestamp) FROM data WHERE timestamp BETWEEN p_starttime AND p_endtime AND datapoint_name=p_datapoint_name);
            #the first value (the value with the earliest date) is directly interpreted as the value at the starttime (no averageing/interpolation,
            #because averaging/interpolation for a certain timepoint is done with the periode before)
            SET lv_firstValue=
            -- get value of first entry, there shouldn't be more than one entries for one timestamp but to prevent failure limit to 1 return value
            (SELECT value from data WHERE timestamp=lv_firstDate AND datapoint_name=p_datapoint_name LIMIT 1);
            #the values in the table data_periodic are temporary, so the values in this table need to be delted
            SET lv_lastValidValue=lv_firstValue;
            SET lv_lastperiode_was_valid = TRUE;
            SET lv_countPeriod = 1;
            #set if the generated values shall be returned to calling function (by the SELECT statement at the end of this SP)
            IF p_mode > 1000 
            THEN
                SET lv_outputEnabled = FALSE;
                SET p_mode = p_mode - 1000;
            END IF;
            
            
            #insert first value in table data_periodic
            INSERT INTO data_periodic (
                value                   ,
                timestamp               ,
                datapoint_name          ,
                quality         
            )
            VALUES (
                lv_firstValue           ,
                p_starttime             ,
                p_datapoint_name        ,
                0            
            );
                        
            #---------------------------------------------------------------------------------------------
            #-------------- mode = 1 (weighted averaging and linear interpolation)------------------------
            #---------------------------------------------------------------------------------------------   
            IF p_mode=1
            THEN
                #mode 1:
                #algorithm for weighted averaging and linear interpolation of the values
                WHILE 
                #do calculations while endtime for next periode sooner than final endtime
                        (SELECT TIME_TO_SEC(TIMEDIFF(p_endtime, lv_endtime_per))) >= 0
                DO

                    IF lv_lastperiode_was_valid=true
                    THEN
                    #for testing purpose
                    #SELECT 'branch 1';
                    #SELECT lv_endtime_per;
                            
                        #check if avg value of periode exists (in other words, if there are values in this periode given)
                        #TODO: test if DISTINCT has an effect, don't think so (but could be needed to prevent errors or confounded with LIMIT 1)
                        #lv_starttime_per+1 done at the end of the loop. Needed because SQL BETWEEN function includes the limits to (closed set)
                        IF (SELECT DISTINCT datapoint_name FROM data WHERE timestamp BETWEEN lv_starttime_per AND lv_endtime_per AND datapoint_name=p_datapoint_name) IS NOT NULL
                        THEN
                            #calculate weighted average value of last periode
                            CALL calcAverageWeighted(p_datapoint_name,lv_starttime_per,lv_endtime_per,lv_lastValidValue,lv_currentValue,lv_lastValidValue,lv_quality);
                            #calculated average value is assigned to the endtime of the periode
                            #quality is equal to the number of values in current periode (many values -> high quality)
                            INSERT INTO data_periodic (
                                value                   ,
                                timestamp               ,
                                datapoint_name          ,
                                quality         
                            )
                            VALUES (
                                lv_currentValue         ,
                                lv_endtime_per          ,
                                p_datapoint_name        ,
                                lv_quality            
                            );
                            
                        ELSE
                            SET lv_lastperiode_was_valid = false;
                            SET lv_starttime_interpol=lv_starttime_per-1;
                        END IF;
                    ELSE
                    #for testing purpose
                    #SELECT 'branch 2';    
                    #SELECT lv_endtime_per;
                    
                        #TODO: test if DISTINCT has an effect, don't think so (but could be needed to prevent errors or confounded with LIMIT 1)
                        IF (SELECT DISTINCT datapoint_name FROM data WHERE timestamp BETWEEN lv_starttime_per AND lv_endtime_per AND datapoint_name=p_datapoint_name) IS NOT NULL
                        THEN
                            SET lv_lastperiode_was_valid = true;
                            -- interpolate algorithm
                            
                            -- lv_endtime_per is the timepoint of the current valid value
                            -- startvalue for weighted average is NULL, so there is no and it is ignored by stored procedure calcAverageWeighted
                            
                            #lv_firstValue because returned value can not be assigned to lv_lastValidValue because this is the startvalue needed for the interpolation
                            #perhaps it would be better to use normal averaging in this mode!?
                            CALL calcAverageWeighted(p_datapoint_name,lv_starttime_per,lv_endtime_per,NULL,lv_currentValue,lv_firstValue,lv_quality);
                            
                            CALL interpolateValuesLinear(p_datapoint_name, lv_starttime_interpol, lv_endtime_per, p_periode, lv_lastValidValue, lv_currentValue);

                            SET lv_lastValidValue = lv_currentValue;
                            
                        END IF;
                    
                    END IF;
                    
                    #shift to next periode
                    #lv_endtime_per+1 because SQL BETWEEN function includes the limits to (closed set)
                    SET lv_starttime_per = lv_endtime_per + 1;
                    SET lv_endtime_per=
                        (SELECT DATE_ADD(lv_endtime_per,INTERVAL p_periode SECOND));
                    
                END WHILE;
                
                IF lv_lastperiode_was_valid=false
                THEN
                    CALL interpolateValuesLinear(p_datapoint_name, lv_starttime_interpol, lv_starttime_per, p_periode, lv_lastValidValue, lv_lastValidValue);
                END IF;

            #---------------------------------------------------------------------------------------------
            #-------------- mode = 2 (weighted averaging / sample & hold)---------------------------------
            #---------------------------------------------------------------------------------------------
            ELSEIF p_mode = 2
            THEN
                    #mode 2:
                    #algorithm for weighted averaging and sample & hold of values
                    WHILE 
                    #do calculations while endtime for next periode sooner than final endtime
                            (SELECT TIME_TO_SEC(TIMEDIFF(p_endtime, lv_endtime_per))) >= 0
                    DO
                            #check if there are values in current periode
                            #lv_starttime_per+1 done at the end of the loop. Needed because SQL BETWEEN function includes the limits to (closed set)
                            #TODO: check if DISTINCT has an effect or LIMIT 1 needed/better!
                            IF (SELECT DISTINCT datapoint_name FROM data WHERE timestamp BETWEEN lv_starttime_per AND lv_endtime_per AND datapoint_name=p_datapoint_name) IS NOT NULL
                            THEN
                                #calculate weighted average value of last periode
                                CALL calcAverageWeighted(p_datapoint_name,lv_starttime_per,lv_endtime_per,lv_lastValidValue,lv_currentValue,lv_lastValidValue,lv_quality);
                                #for testing purpose
                                    #SELECT * FROM data_calcAverageWeighted;
                                    #SELECT lv_currentValue;
                                    #SELECT lv_lastValidValue;
                                #/for testing purpose
                                SET lv_countPeriod = 1;
                                #assigning of current value (calculated result of last period) to the endtime of the period                    
                                INSERT INTO data_periodic (        
                                    value                  ,
                                    timestamp              ,
                                    datapoint_name         ,
                                    quality
                                )        
                                VALUES (        
                                    lv_currentValue        ,
                                    lv_endtime_per         ,
                                    p_datapoint_name       ,
                                    lv_quality              
                                                           );
                            ELSE
                                SET lv_countPeriod = lv_countPeriod + 1;
                                SET lv_quality = 1 / lv_countPeriod;
                                #assigning of value (the last entry of the last period that was valid (hold)) to the endtime of the current period                    
                                INSERT INTO data_periodic (        
                                    value                  ,
                                    timestamp              ,
                                    datapoint_name         ,
                                    quality
                                )        
                                VALUES (        
                                    lv_lastValidValue      ,
                                    lv_endtime_per         ,
                                    p_datapoint_name       ,
                                    lv_quality              
                                                           );
                            END IF;
                            
                         #shift to next periode
                         #lv_endtime_per+1 because SQL BETWEEN function includes the limits to (closed set)
                         SET lv_starttime_per = lv_endtime_per + 1;
                         SET lv_endtime_per=
                            (SELECT DATE_ADD(lv_endtime_per,INTERVAL p_periode SECOND));
                     END WHILE;
            
            #---------------------------------------------------------------------------------------------
            #----------------------- mode = 3 (difference value / zero)-----------------------------------
            #---------------------------------------------------------------------------------------------
            ELSEIF p_mode = 3
            THEN
                    #mode 3:
                    #algorithm for difference value and zero
                    WHILE 
                    #do calculations while endtime for next periode sooner than final endtime
                            (SELECT TIME_TO_SEC(TIMEDIFF(p_endtime, lv_endtime_per))) >= 0
                    DO
                            #get quality (number of measurements) for current period
                            SET lv_quality =
                                        (SELECT count(*) FROM data WHERE timestamp BETWEEN lv_starttime_per AND lv_endtime_per AND datapoint_name=p_datapoint_name);
                            #check if there are values in current periode
                            #lv_starttime_per+1 done at the end of the loop. Needed because SQL BETWEEN function includes the limits to (closed set)
                            #TODO: check if DISTINCT has an effect or LIMIT 1 needed/better!
                            IF (SELECT DISTINCT datapoint_name FROM data WHERE timestamp BETWEEN lv_starttime_per AND lv_endtime_per AND datapoint_name=p_datapoint_name) IS NOT NULL
                            THEN
                                #calculate difference value of last (highest) value with last valid value (last value before this period)
                                SET lv_currentValueMax = 
                                        (SELECT value FROM data WHERE datapoint_name=p_datapoint_name AND timestamp=
                                                                                                                 (SELECT timestamp FROM data WHERE timestamp <= lv_endtime_per AND datapoint_name=p_datapoint_name ORDER BY timestamp DESC LIMIT 1)
                                                                                                      LIMIT 1);
                                SET lv_currentValue = lv_currentValueMax - lv_lastValidValue;
                                #TODO: check if lv_currentValue is negative (could happen if counter overflow)
                                #assigning of current value (calculated result of last period) to the endtime of the period                    
                                INSERT INTO data_periodic (        
                                    value                  ,
                                    timestamp              ,
                                    datapoint_name         ,
                                    quality
                                )        
                                VALUES (        
                                    lv_currentValue        ,
                                    lv_endtime_per         ,
                                    p_datapoint_name       ,
                                    lv_quality              
                                                           );
                                SET lv_lastValidValue = lv_currentValueMax;
                                        
                            ELSE
                                #assigning of value (zero) to the endtime of the current period                    
                                INSERT INTO data_periodic (        
                                    value                  ,
                                    timestamp              ,
                                    datapoint_name         ,
                                    quality
                                )        
                                VALUES (        
                                    0                      ,
                                    lv_endtime_per         ,
                                    p_datapoint_name       ,
                                    lv_quality              
                                                           );
                            END IF;
                         
                         #shift to next periode
                         #lv_endtime_per+1 because SQL BETWEEN function includes the limits to (closed set)
                         SET lv_starttime_per = lv_endtime_per + 1;
                         SET lv_endtime_per=
                            (SELECT DATE_ADD(lv_endtime_per,INTERVAL p_periode SECOND));
                     END WHILE;
            ELSE
                CALL raiseError('Wanted mode not supported by this stored procedure! Allowed modes: 1,2,3 (and corresponding modes above 1000)');    
            END IF;
            

        END IF;
    
        IF lv_outputEnabled IS TRUE
        THEN
            SELECT datapoint_name, timestamp, value, quality FROM data_periodic;
        END IF;
        
    END IF;
    END IF;
END$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure interpolateValuesLinear
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`interpolateValuesLinear`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`interpolateValuesLinear`(
                    IN  p_datapoint_name        VARCHAR(100)    ,
                    IN  p_starttime             DATETIME        ,
                    IN  p_endtime               DATETIME        ,
                    IN  p_periode               DOUBLE          ,
                    IN  p_value_starttime       DOUBLE          ,
                    IN  p_value_endtime         DOUBLE          
                )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   unknown (Jan 2011)
#DATE OF LAST MODIFICATION:
#   2011-10-10
#FUNCTION OF STORED PROCEDURE:
#   calculate linear interpolated values between two given values (timepoint to which values belong also needed)
#EXAMPLE:
#   CALL interpolateValuesLinear('tem1','2010-12-29 12:10:00','2010-12-29 12:20:00',60,21,25);
#   To view results (not returned from this SP!):
#   SELECT * FROM data_periodic;

        DECLARE lv_starttime_per            DATETIME;
        DECLARE lv_endtime_per              DATETIME;
        DECLARE lv_value                    DOUBLE;
        DECLARE lv_k                        DOUBLE;
        DECLARE lv_x                        DOUBLE;
        DECLARE lv_d                        DOUBLE;
        DECLARE lv_delta_x                  DOUBLE;
        DECLARE lv_quality                  DOUBLE;
        
        SET lv_starttime_per=p_starttime;
        SET lv_endtime_per=
            (SELECT DATE_ADD(lv_starttime_per,INTERVAL p_periode SECOND));           
 
-- y = k*x + d
        SET lv_delta_x =
            (SELECT TIME_TO_SEC(TIMEDIFF(p_endtime, p_starttime)));
        SET lv_k = (p_value_endtime - p_value_starttime) / lv_delta_x;
        SET lv_x = p_periode;
        SET lv_d = p_value_starttime;
        #quality depands on length of interpolation (long interpolation -> lower quality) 
        SET lv_quality =
            (p_periode) / (lv_delta_x);
                
        WHILE 
            #do calculations while endtime for next periode sooner than final endtime
            (SELECT TIME_TO_SEC(TIMEDIFF(p_endtime, lv_endtime_per))) >= 0
        DO
-- y = k*x + d            
            SET lv_value=
                (lv_k * lv_x + lv_d);

                    INSERT INTO data_periodic (
                        value                   ,
                        timestamp          ,
                        datapoint_name          ,
                        quality                 
                    )
                    VALUES (
                        lv_value                ,
                        lv_endtime_per          ,
                        p_datapoint_name        ,
                        lv_quality           
                    );
            
        #shift to next periode
        SET lv_starttime_per = lv_endtime_per;
        SET lv_endtime_per=
            (SELECT DATE_ADD(lv_endtime_per,INTERVAL p_periode SECOND));
        SET lv_x = lv_x + p_periode;
        
        END WHILE;

        #set quality of last entry to number of values of last periode (because the last entry is not interpolated!)
        SET lv_quality =
            (SELECT count(*) FROM data WHERE timestamp BETWEEN p_starttime+1 AND p_endtime AND datapoint_name=p_datapoint_name);
        #TODO: next line changes timestamp to current time (since data_periodic temporary table?? or not recogniced in first place)
        
        #UPDATE data_periodic SET quality=lv_quality WHERE timestampValue=p_endtime;
END
$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure addDatapointConnection
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`addDatapointConnection`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`addDatapointConnection`
            (
                IN p_datapoint_name             VARCHAR(100)    ,
                IN p_type                       VARCHAR(45)     ,
                IN p_unit                       VARCHAR(45)     ,
                IN p_accuracy                   NUMERIC(10,2)   ,
                IN p_min                        NUMERIC(10,2)   ,
                IN p_max                        NUMERIC(10,2)   ,
                IN p_deadband                   NUMERIC(10,2)   ,
                IN p_sample_interval            NUMERIC         ,
                IN p_sample_interval_min        NUMERIC         ,
                IN p_watchdog                   NUMERIC         ,
                IN p_math_operations            VARCHAR(45)     ,
                IN p_virtual                    VARCHAR(100)    ,
                IN p_custom_attr                VARCHAR(500)    ,
                IN p_description                VARCHAR(500)    ,
                IN p_device_name                VARCHAR(100)    ,
                IN p_connection_type            VARCHAR(100)    ,
                IN p_connection_variables       VARCHAR(500)    ,
                IN p_writeable                  BINARY          ,
                IN p_vendor                     VARCHAR(100)    ,
                IN p_model                      VARCHAR(100)    ,
                IN p_connector_id               VARCHAR(100)    
            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#   ZACH R.
#DATE OF CREATION:
#   2012-07-06
#DATE OF LAST MODIFICATION:
#   2013-02-28
#FUNCTION OF STORED PROCEDURE:
#   adds entry in table datapoint (and therefore in table data too) AND connections
#
#   all parameters have to be served to the stored procedure, when no entry of argument wanted in table datapoint hand over null (works only if null is allowed)
#   for wrong input types unintended results may occour (e.g. string when int is wanted can be interpreted as 0 or numbers in string are taken)
#
#   datapoint_name is primary key in table datapoint and foreign key in table connections
#
#EXAMPLE: CALL addDatapointConnection('testDp1','type2','unit2',NULL,0,100,1,60,5,NULL,'math','virtual','custom','description','deviceName','jdbc','connection_variables',TRUE,NULL,NULL,NULL);
   
        CALL addDatapoint
                (
                    p_datapoint_name     ,
                    p_type               ,
                    p_unit               ,
                    p_accuracy           ,
                    p_min                ,
                    p_max                ,
                    p_deadband           ,
                    p_sample_interval    ,
                    p_sample_interval_min,
                    p_watchdog           ,
                    p_math_operations    ,
                    p_virtual            ,
                    p_custom_attr        ,
                    p_description         
                ) ;
                
            CALL addConnection 
                    (
                            p_datapoint_name        , 
                            p_device_name           , 
                            p_connection_type       ,
                            p_connection_variables  ,
                            p_writeable             ,
                            p_vendor                ,
                            p_model                 ,
                            p_connector_id      
                    );
END








$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getValuesPeriodicBinary
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getValuesPeriodicBinary`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getValuesPeriodicBinary`(
                IN p_datapoint_name        VARCHAR(100)    ,
                IN p_starttime             DATETIME        ,
                IN p_endtime               DATETIME        ,
                IN p_period                DOUBLE          ,
                IN p_mode                  INT             
            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-02-09
#DATE OF LAST MODIFICATION:
#   2012-08-21
#FUNCTION OF STORED PROCEDURE:
#   this function generates periodic values
#   p_period is the output interval of the generated periodic values
#   mode:   1 = majority decision / sample & hold
#           2 = forced 0 / default 1
#           3 = forced 1 / default 0
#
#           modes higher than 1000 are equal to modes higher than zero, but the output is depressed (needes because of SP getValuesOfDatapointWhereDpXXX)
#           e.g. mode 1002 = mode 2 without output (values have to be read from temporary table by calling SP/function)
#EXAMPLE:
#   CALL getValuesPeriodicBinary('con1','2010-12-29 12:00:00', '2010-12-29 13:00:00',60,1);

    DECLARE lv_firstDate                DATETIME;
    DECLARE lv_firstValue               DOUBLE;
    DECLARE lv_lastValidValue           DOUBLE;
    DECLARE lv_currentValue             DOUBLE;
    DECLARE lv_quality                  DOUBLE;
    DECLARE lv_starttime_per            DATETIME;
    DECLARE lv_endtime_per              DATETIME;
    DECLARE lv_starttime_interpol       DATETIME;
    DECLARE lv_lastperiod_was_valid     BOOLEAN;
    DECLARE lv_countPeriod              INT;
    DECLARE lv_outputEnabled            BOOLEAN;
    
    #initialize local variables
    SET lv_outputEnabled = TRUE;
    
    #check if given dates(time) are allowed
    IF (SELECT TIME_TO_SEC(TIMEDIFF(p_endtime, p_starttime))) < p_period
    THEN
        CALL raiseError('endtime must be later than starttime + one period');
    ELSE
    #check if datapoint_name exists
    IF  (SELECT count(datapoint_name) FROM datapoint WHERE datapoint_name=p_datapoint_name) = 0
    THEN
        CALL raiseError('given datapoint_name does not exist in database(in table datapoint)');
    ELSE
        CREATE TEMPORARY TABLE IF NOT EXISTS data_periodic (
                `iddata_periodic` INT NOT NULL AUTO_INCREMENT        ,
                `value` DOUBLE                                       ,
                `timestamp` DATETIME                                 ,
                `quality`   DOUBLE                                   ,
                `datapoint_name`    VARCHAR(100)                     ,
                PRIMARY KEY(`iddata_periodic`)                       
                );
        TRUNCATE TABLE data_periodic;
        
    #TODO: instead of the following query also the first SET lv_firstValue=... (some lines beneath this) could be used and cached (because it is needed anywayin most cases). If the returned value is NULL, no values are in the database
    IF  (SELECT count(value) FROM data WHERE timestamp BETWEEN p_starttime AND p_endtime AND datapoint_name=p_datapoint_name) = 0
    THEN
           
            INSERT INTO data_periodic (
                value                   ,
                timestamp               ,
                datapoint_name          ,
                quality         
            )
            VALUES (
                NULL                    ,
                p_starttime             ,
                p_datapoint_name        ,
                0                                
            );
            
            SET lv_starttime_per=p_starttime+1;
            SET lv_endtime_per=
                (SELECT DATE_ADD(p_starttime,INTERVAL p_period SECOND));
            
            #do calculations while endtime for next periode sooner than final endtime
            WHILE (SELECT TIME_TO_SEC(TIMEDIFF(p_endtime, lv_endtime_per))) >= 0
                DO
                
                        INSERT INTO data_periodic (
                            value                   ,
                            timestamp               ,
                            datapoint_name          ,
                            quality         
                        )
                        VALUES (
                            NULL                    ,
                            lv_endtime_per          ,
                            p_datapoint_name        ,
                            0                                
                        );
            
            #shift to next periode
            #lv_endtime_per+1 because SQL BETWEEN function includes the limits to (closed set)
            SET lv_starttime_per = lv_endtime_per + 1;
            SET lv_endtime_per=
                    (SELECT DATE_ADD(lv_endtime_per,INTERVAL p_period SECOND));
            END WHILE;

    ELSE
        #---------------------------------------------------------------------------------------------
        #-------------------------------- start of main algorithm ------------------------------------
        #---------------------------------------------------------------------------------------------
    
        SET lv_starttime_per=p_starttime;
        SET lv_endtime_per=
            (SELECT DATE_ADD(lv_starttime_per,INTERVAL p_period SECOND));
        SET lv_firstDate=
        -- get first date in given timeslot of given datapoint_name
            (SELECT MIN(timestamp) FROM data WHERE timestamp BETWEEN p_starttime AND p_endtime AND datapoint_name=p_datapoint_name);
        #the first value (the value with the earliest date) is directly interpreted as the value at the starttime (no averageing/interpolation,
        #because averaging/interpolation for a certain timepoint is done with the period before)
        SET lv_firstValue=
        -- get value of first entry, there shouldn't be more than one entries for one timestamp but to prevent failure limit to 1 return value
        (SELECT value from data WHERE timestamp=lv_firstDate AND datapoint_name=p_datapoint_name LIMIT 1);
        #the values in the table data_periodic are temporary, so the values in this table need to be deleted
        SET lv_lastValidValue=lv_firstValue;
        SET lv_lastperiod_was_valid = TRUE;
        #set if the generated values shall be returned to calling function (by the SELECT statement at the end of this SP)
        IF p_mode > 1000 
        THEN
            SET lv_outputEnabled = FALSE;
            SET p_mode = p_mode - 1000;
        END IF;
               
        #insert first value in table data_periodic
        INSERT INTO data_periodic (
            value                   ,
            timestamp               ,
            datapoint_name          ,
            quality         
        )
        VALUES (
            lv_firstValue           ,
            p_starttime             ,
            p_datapoint_name        ,
            0            
        );
        SET lv_countPeriod = 1;
        
        CASE p_mode
                #---------------------------------------------------------------------------------------------
                #------------------ mode = 1 (majority decision / sample & hold)------------------------------
                #---------------------------------------------------------------------------------------------   
        
            WHEN 1 THEN            
            #algorithm for majority decision (if there are more than one values) and sample & hold (if there is no value)
                WHILE 
                #do calculations while endtime for next period sooner than final endtime
                        (SELECT TIME_TO_SEC(TIMEDIFF(p_endtime, lv_endtime_per))) >= 0
                DO
                         #check if there are values in current period
                        IF (SELECT DISTINCT datapoint_name FROM data WHERE timestamp BETWEEN lv_starttime_per AND lv_endtime_per AND datapoint_name=p_datapoint_name) IS NOT NULL
                        THEN
                            #lv_quality is used for majority decision algorithm
                            SET lv_quality =
                                    (SELECT count(*) FROM data WHERE timestamp BETWEEN lv_starttime_per AND  lv_endtime_per AND datapoint_name=p_datapoint_name);
                            #majority decision of values, everything not 0 is interpreted as TRUE, if half values are TRUE the result is TRUE
                            IF lv_quality < 2 * (SELECT count(*) FROM data WHERE timestamp BETWEEN lv_starttime_per AND lv_endtime_per AND datapoint_name=p_datapoint_name AND value = 0)
                            THEN        SET lv_currentValue = 0;
                            ELSE        SET lv_currentValue = 1;
                            END IF;
                            
                            SET lv_countPeriod = 1;
                            #assigning of value (result of last period) to the endtime of the period                    
                            INSERT INTO data_periodic (        
                                value                  ,
                                timestamp              ,
                                datapoint_name         ,
                                quality
                            )        
                            VALUES (        
                                lv_currentValue        ,
                                lv_endtime_per         ,
                                p_datapoint_name       ,
                                lv_quality              
                            );
                            #store last value of current period (-> for use in hold mode)
                            SET lv_lastValidValue =
                                (SELECT value FROM data WHERE timestamp <= lv_endtime_per AND datapoint_name=p_datapoint_name ORDER BY timestamp DESC LIMIT 1);
                        
                        ELSE
                            SET lv_countPeriod = lv_countPeriod + 1;
                            SET lv_quality = 1 / lv_countPeriod;

                        #assigning of value (the last value of the last valid period-> hold mode) to the endtime of the period                    
                        INSERT INTO data_periodic (        
                            value                  ,
                            timestamp              ,
                            datapoint_name         ,
                            quality
                        )        
                        VALUES (        
                            lv_lastValidValue      ,
                            lv_endtime_per         ,
                            p_datapoint_name       ,
                            lv_quality              
                        );        
                        END IF;
                        
                     #shift to next period
                     #lv_endtime_per+1 because SQL BETWEEN function includes the limits to (closed set)
                     SET lv_starttime_per = lv_endtime_per + 1;
                     SET lv_endtime_per=
                        (SELECT DATE_ADD(lv_endtime_per,INTERVAL p_period SECOND));
                 END WHILE;
                 
                #---------------------------------------------------------------------------------------------
                #--------------------------- mode = 2 (forced 0 / default 1)----------------------------------
                #---------------------------------------------------------------------------------------------
                
                WHEN 2 THEN            
                #algorithm for forced 0 (if there is at least one 0 in the period the periodic value is zero) and default 1 (if there is no value in the period the periodic value is 1)
                    WHILE 
                    #do calculations while endtime for next period sooner than final endtime
                            (SELECT TIME_TO_SEC(TIMEDIFF(p_endtime, lv_endtime_per))) >= 0
                    DO
                            #check if there are values in current period
                            IF (SELECT DISTINCT datapoint_name FROM data WHERE timestamp BETWEEN lv_starttime_per AND lv_endtime_per AND datapoint_name=p_datapoint_name) IS NOT NULL
                            THEN
                                #check if there is at least one zero in current period and set lv_lastValidValue to 0 if so, to 1 if there is no zero in current period
                                IF (SELECT DISTINCT datapoint_name FROM data WHERE timestamp BETWEEN lv_starttime_per AND lv_endtime_per AND datapoint_name=p_datapoint_name AND value=0) IS NOT NULL
                                THEN
                                    SET lv_lastValidValue = 0;
                                ELSE    SET lv_lastValidValue = 1;
                                END IF;
                                SET lv_quality =
                                        (SELECT count(*) FROM data WHERE timestamp BETWEEN lv_starttime_per AND lv_endtime_per AND datapoint_name=p_datapoint_name);
                                SET lv_countPeriod = 1;
                            ELSE
                                #if there are no values in current period set lv_lastValidValue to 1
                                SET lv_countPeriod = lv_countPeriod + 1;
                                SET lv_quality = 1 / lv_countPeriod;
                                SET lv_lastValidValue = 1;
                            END IF;
                            #assigning of value (result of last period or if there was no value 1) to the endtime of the period                    
                            INSERT INTO data_periodic (        
                                value                  ,
                                timestamp              ,
                                datapoint_name         ,
                                quality                 
                            )        
                            VALUES (        
                                lv_lastValidValue      ,
                                lv_endtime_per         ,
                                p_datapoint_name       ,
                                lv_quality              
                            );        

                         #shift to next period
                         #lv_endtime_per+1 because SQL BETWEEN function includes the limits to (closed set)
                         SET lv_starttime_per = lv_endtime_per + 1;
                         SET lv_endtime_per=
                            (SELECT DATE_ADD(lv_endtime_per,INTERVAL p_period SECOND));
                     END WHILE;
                 
                #---------------------------------------------------------------------------------------------
                #--------------------------- mode = 3 (forced 1 / default 0)----------------------------------
                #---------------------------------------------------------------------------------------------
                                
                WHEN 3 THEN            
                #algorithm for forced 1 (if there is at least one 1 in the period the periodic value is 1) and default 0 (if there is no value in the period the periodic value is 0)
                    WHILE 
                    #do calculations while endtime for next period sooner than final endtime
                            (SELECT TIME_TO_SEC(TIMEDIFF(p_endtime, lv_endtime_per))) >= 0
                    DO
                            #check if there are values in current period
                            IF (SELECT DISTINCT datapoint_name FROM data WHERE timestamp BETWEEN lv_starttime_per AND lv_endtime_per AND datapoint_name=p_datapoint_name) IS NOT NULL
                            THEN
                                #check if there is at least one zero in current period and set lv_lastValidValue to 0 if so, to 1 if there is no zero in current period
                                IF (SELECT DISTINCT datapoint_name FROM data WHERE timestamp BETWEEN lv_starttime_per AND lv_endtime_per AND datapoint_name=p_datapoint_name AND value<>0) IS NOT NULL
                                THEN
                                    SET lv_lastValidValue = 1;
                                ELSE    SET lv_lastValidValue = 0;
                                END IF;
                                SET lv_quality =
                                        (SELECT count(*) FROM data WHERE timestamp BETWEEN lv_starttime_per AND lv_endtime_per AND datapoint_name=p_datapoint_name);
                                SET lv_countPeriod = 1;
                            ELSE
                                #if there are no values in current period set lv_lastValidValue to 0
                                SET lv_countPeriod = lv_countPeriod + 1;
                                SET lv_quality = 1 / lv_countPeriod;
                                SET lv_lastValidValue =0;
                            END IF;

                            #assigning of value (result of last period or if there was no value 0) to the endtime of the period                    
                            INSERT INTO data_periodic (        
                                value                  ,
                                timestamp              ,
                                datapoint_name         ,
                                quality                
                            )        
                            VALUES (        
                                lv_lastValidValue      ,
                                lv_endtime_per         ,
                                p_datapoint_name       ,
                                lv_quality             
                            );        

                         #shift to next period
                         #lv_endtime_per+1 because SQL BETWEEN function includes the limits to (closed set)
                         SET lv_starttime_per = lv_endtime_per + 1;
                         SET lv_endtime_per=
                            (SELECT DATE_ADD(lv_endtime_per,INTERVAL p_period SECOND));
                     END WHILE;

                    
                ELSE
                CALL raiseError('Wanted mode not supported by this stored procedure! Allowed modes: 1,2,3 (and corresponding modes above 1000)');    
        END CASE;

     END IF;
             
        IF lv_outputEnabled IS TRUE
        THEN
            SELECT datapoint_name, timestamp, value, quality FROM data_periodic;
        END IF;
        
    END IF;
    END IF;
END
$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getValuesPeriodic
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getValuesPeriodic`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getValuesPeriodic`(
                IN p_datapoint_name        VARCHAR(100)    ,
                IN p_starttime             DATETIME        ,
                IN p_endtime               DATETIME        ,
                IN p_periode               DOUBLE          ,
                IN p_mode                  INT             
            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-02-09
#DATE OF LAST MODIFICATION:
#   2011-09-27
#FUNCTION OF STORED PROCEDURE:
#   this function calculates periodic values apposite to the type (more exactly the unit) of the datapoint with algorithms for binary and analog values
#   p_periode is the output interval of the generated periodic values
#   p_mode is the mode with that the values are calculated.
#   If p_mode is 0 or NULL an default mode is used:
#               binary: majority decision / sample & hold
#               analog: weighted average / linear interpolation)
#

    #check if given dates(time) are allowed
    IF (SELECT TIME_TO_SEC(TIMEDIFF(p_endtime, p_starttime))) < p_periode
    THEN
        CALL raiseError('endtime must be later than starttime + one periode');
    ELSE
    #check if datapoint_name exists
    IF  (SELECT count(datapoint_name) FROM datapoint WHERE datapoint_name=p_datapoint_name) = 0
    THEN
        CALL raiseError('given datapoint_name does not exist in database(in table datapoint)');
    ELSE
    #check if given mode is 0 or NULL -> set mode to default mode (=1)
    IF p_mode = 0 OR p_mode IS NULL
    THEN
        SET p_mode = 1;
    END IF;
    
    CREATE TEMPORARY TABLE IF NOT EXISTS data_periodic (
                 `iddata_periodic` INT NOT NULL AUTO_INCREMENT        ,
                 `value` DOUBLE                                       ,
                 `timestamp` DATETIME                                 ,
                 `quality`   DOUBLE                                   ,
                 `datapoint_name`    VARCHAR(100)                     ,
                 PRIMARY KEY(`iddata_periodic`)                       
                 );
    TRUNCATE TABLE data_periodic;
    
    #input data should be correct, now starting algorithm for choosing appropriate (depending on type, more exactly the unit of the datapoint) stored procedure
        IF (SELECT unit from datapoint WHERE datapoint_name=p_datapoint_name)='boolean'
        THEN
            #call of stored procedure for binary values
            CALL getValuesPeriodicBinary(
                    p_datapoint_name      ,
                    p_starttime           ,
                    p_endtime             ,
                    p_periode             ,
                    p_mode                     
            );
        ELSE
        #call of stored procedure for analog values
             CALL getValuesPeriodicAnalog(
                    p_datapoint_name      ,
                    p_starttime           ,
                    p_endtime             ,
                    p_periode             ,
                    p_mode
            );
        END IF;
    
    END IF;
    END IF;
END

$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure addZoneToZone
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`addZoneToZone`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`addZoneToZone` (
                        IN p_zone_high       INT     ,
                        IN p_zone_low        INT     
                        )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-02-10
#DATE OF LAST MODIFICATION:
#   2011-07-12
#FUNCTION OF STORED PROCEDURE:
#   adds an existing zone to another existing zone
#EXAMPLE:
#   CALL addZoneToZone(10,8);

INSERT INTO zone_has_zone
                (
                    zone_high     ,
                    zone_low  
                )
        
        VALUES
                (
                    p_zone_high    ,
                    p_zone_low
                ) ;
        
END




$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getBasiczones
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getBasiczones`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getBasiczones`(
                            IN  p_idzone        INT                  
                            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-02-11
#DATE OF LAST MODIFICATION:
#   2011-03-11
#FUNCTION OF STORED PROCEDURE:
#   returns all basic (=smallest) zones which are contained in a zone 
#EXAMPLE:
#   CALL getBasiczones(10);

    DECLARE lv_index          INT;
    DECLARE lv_currentzone    INT;

    SET lv_index=1;

    CREATE TEMPORARY TABLE IF NOT EXISTS zones_tmp (
                        `ID` INT NOT NULL AUTO_INCREMENT        ,
                        `zone` INT                          ,
                        PRIMARY KEY(`ID`)                       
                        );
    CREATE TEMPORARY TABLE IF NOT EXISTS zones_basic (
                        `ID` INT NOT NULL AUTO_INCREMENT        ,
                        `zone` INT                               ,
                        PRIMARY KEY(`ID`)              
                        );                        
    TRUNCATE TABLE zones_basic;
    TRUNCATE TABLE zones_tmp;

    
    INSERT INTO zones_tmp 
                (zone) 
    VALUES 
                (p_idzone);

    SET lv_currentzone=
                  (SELECT zone FROM zones_tmp WHERE ID=lv_index);

    IF (SELECT DISTINCT idzone FROM zone WHERE idzone=lv_currentzone) IS NULL
    THEN
         CALL raiseError('Given zone not in database!');
    END IF;
    
    #if current zone has no subzones write it into the table zones_basic
    #if current zone has subzones write it into the table zones_tmp
    #set current zone to next entry in table zones_tmp
    #do this till there is no further entry in table zones_tmp
    #restrict to 1000 subzones, need to detect inconsistency of table <zone_has_zone> (problem if 2 zones contain each other in 2 entries, must not be!)
    WHILE lv_currentzone IS NOT NULL AND lv_index<1000
    DO
      IF (SELECT DISTINCT zone_high FROM zone_has_zone WHERE zone_high=lv_currentzone) IS NOT NULL
      THEN
          INSERT INTO zones_tmp 
                      (zone)
          (SELECT zone_low FROM zone_has_zone WHERE zone_high=lv_currentzone);  
      ELSE
          INSERT INTO zones_basic
                 (
                     zone
                 )
          VALUES (
                     lv_currentzone   
                 );
      END IF;
      #set next entry in table zones_tmp to be checked by next interation
      SET lv_index=lv_index+1;
      SET lv_currentzone=
                  (SELECT zone FROM zones_tmp WHERE ID=lv_index);

    END WHILE;
    
    IF lv_index=1000
    THEN 
        CALL raiseError('To many subzones (max number is 1000) or inconsistent table <zone_has_zone>');
    END IF;

    SELECT DISTINCT zone FROM zones_basic ORDER BY zone;
    DROP TABLE zones_tmp;
    DROP TABLE zones_basic; 
END





$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getSubzones
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getSubzones`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getSubzones`(
                            IN  p_idzone        INT     ,
                            IN  p_sublevels     INT                         
                            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-03-11
#DATE OF LAST MODIFICATION:
#   2012-07-31
#FUNCTION OF STORED PROCEDURE:
#   returns subzones which are contained in a given number of sublevels of a zone (zone itself is NOT returned!) by calling SP getSubzones_Internal and reading table used by it
#   p_sublevels = NULL --> return all subzones
#EXAMPLE:
#   CALL getSubzones(10,3);
#   CALL getSubzones(10,NULL);
#ERROR: -30 -> 'Given zone not in database!'

    IF (SELECT DISTINCT idzone FROM zone WHERE idzone=p_idzone) IS NULL
    THEN
         CALL raiseWarning(-30, 'Given zone not in database!');
    ELSE
        CALL getSubzones_internal(p_idzone,p_sublevels);
        SELECT DISTINCT zone FROM zones_tmpSPsubzones WHERE ID > 1 ORDER BY zone;
    END IF;
    
END
$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getValues
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getValues`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getValues`(
                IN p_datapoint_name        VARCHAR(100)    ,
                IN p_starttime             DATETIME        ,
                IN p_endtime               DATETIME               
            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-03-29
#DATE OF LAST MODIFICATION:
#   2011-11-17
#FUNCTION OF STORED PROCEDURE:
#   returns data from table data for wanted datapoint_name and timeslot
#   returns last entry from table data for input parameter p_starttime and p_endtime NULL
#   returns first entry after starttime if argument p_endtime is NULL
#   returns first entry before endtime if argument p_starttime is NULL
#   returns all values of all datapoints in a given timeframe
#EXAMPLE:
#   CALL getValues('tem1','2010-12-29 12:00:00', '2010-12-29 13:00:00');
#   CALL getValues('tem1',null,null);
#   CALL getValues('tem1','2010-12-29 12:20:00', NULL;
#   CALL getValues('tem1',NULL, '2010-12-29 12:20:00');
#   CALL getValues('%','2010-12-29 12:00:00', '2010-12-29 13:00:00');



    #check if given dates(time) are allowed
    IF (SELECT TIME_TO_SEC(TIMEDIFF(p_endtime, p_starttime))) < 0
    THEN
        CALL raiseError('endtime must be later than starttime!');
    ELSE
        
        IF p_starttime IS NULL
        THEN    
            IF p_endtime IS NULL
            THEN
                SELECT datapoint_name, timestamp, value  FROM data WHERE datapoint_name = p_datapoint_name AND timestamp = 
                                            (SELECT MAX(timestamp) FROM data WHERE datapoint_name = p_datapoint_name) LIMIT 1;
            ELSE 
                SELECT datapoint_name, timestamp, value  FROM data WHERE datapoint_name = p_datapoint_name AND timestamp = 
                                            (SELECT MAX(timestamp) FROM data WHERE datapoint_name = p_datapoint_name AND timestamp < p_endtime ) LIMIT 1;
            END IF;
        ELSEIF p_endtime IS NULL
        THEN
               SELECT datapoint_name, timestamp, value  FROM data WHERE datapoint_name = p_datapoint_name AND timestamp = 
                                            (SELECT MIN(timestamp) FROM data WHERE datapoint_name = p_datapoint_name AND timestamp > p_starttime ) LIMIT 1;
        ELSE
            SELECT datapoint_name, timestamp, value  FROM data WHERE datapoint_name LIKE p_datapoint_name AND timestamp BETWEEN p_starttime AND p_endtime;
        END IF;
        
    END IF;
END




$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure addData      DONE.... :)
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`addData`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE`mon_development`.`addData` (
	IN p_datapoint_name        VARCHAR(100)    ,
	IN p_timestamp             DATETIME    ,
	IN p_value                 DOUBLE
)

addProc:BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   GLAWISCHNIG S.
#   BRAEUER R.
#   ZACH R.
#DATE OF CREATION:
#   July 2010
#DATE OF LAST MODIFICATION:
#   2012-11-13
#FUNCTION OF STORED PROCEDURE:
#   Adds data if no constraints are violated.
#   Constrains (min,max,deadband) are ignored if set to NULL.
#   ERRORCODES: - { 10,11,12,13,14 }
#   TODO: add error code description here
#   
#EXAMPLE: CALL `mon_development`.`addData`('con1','2010-12-29 14:30:13',1) (depends on constraints in database if it works!)
# 
# TODO add valid datapoint check 
# TODO optimize performance --> get maxiValue, minValue, dpDeadband, sample_interval (+ something like dpExists?) within one SELECT call.

DECLARE lastValue Double DEFAULT NULL;
DECLARE lastTimestamp Datetime DEFAULT NULL;

DECLARE timeStampDiff INTEGER DEFAULT NULL;
DECLARE dpDeadband DOUBLE DEFAULT NULL;
DECLARE maxiValue DOUBLE DEFAULT NULL;
DECLARE minValue DOUBLE DEFAULT NULL;
DECLARE sampleInterval INTEGER DEFAULT NULL;
DECLARE sampleIntervalMin INTEGER DEFAULT NULL;


# CACHING of multiple/costly queries
# TODO do valid datapoint check  (inkl getting of min, max, etc.) values first.
# (only after datapoint check!)--> do I really need "	WHERE dp.datapoint_name = p_datapoint_name"? isn't looking at the data table "d.datapoint_name = dp.datapoint_name;" enough? 

#get last value and timestamp
SELECT value,timestamp INTO lastValue, lastTimestamp
    FROM data 
    WHERE datapoint_name = p_datapoint_name 
    AND timestamp <= p_timestamp 
    GROUP BY timestamp desc LIMIT 1;

SELECT TIMESTAMPDIFF(SECOND, lastTimestamp, p_timestamp) INTO timeStampDiff;


SELECT deadband, max, min, sample_interval, sample_interval_min INTO dpDeadband, maxiValue, minValue, sampleInterval, sampleIntervalMin 
    FROM datapoint
    WHERE datapoint_name = p_datapoint_name;


########### CONSTRAINTS ############



# MINVALUE CONSTRAINT
# ignore if min is NULL
# ERROR CODE -13

IF (minValue IS NOT NULL)
THEN 
IF (p_value < minValue)
THEN
SELECT -13;
LEAVE addProc;
END IF;
END IF;


# MAXVALUE CONSTRAINT
# ignore if max is NULL
# ERROR CODE -12
IF (maxiValue IS NOT NULL)
THEN 
  IF (p_value > maxiValue)
  THEN  
    SELECT -12;
    LEAVE addProc;
  END IF;
END IF;


# is latest dp value null condition
# (optional) remove check to improve performance. But each datappoint must have at least one value (data)! Otherwise no values are added at all!
IF ((SELECT d.datapoint_name FROM data d WHERE d.datapoint_name = p_datapoint_name limit 1) IS NULL)
THEN
INSERT INTO data
                (
                    datapoint_name  ,
                    timestamp       , 
                    value
                )
            VALUES
                (
                    p_datapoint_name    ,
                    p_timestamp         ,
                    p_value
                ) ;
SELECT 1;
LEAVE addProc;
END IF;


# SAMPLE_INTERVAL CONSTRAINT
# ignore if sampleInterval is NULL --> go to deadband and sample_interval_min check
# Note: if something < null --> false; same for >, etc. --> works
# return SELECT 2 if outside of sample_interval
IF ( sampleInterval IS NULL OR (timeStampDiff) < sampleInterval)
THEN
# inside sample_interval (or sampleInterval is NULL) -->

# MIN SAMPLE INTERVAL CONSTRAINT
# ignore if sampleIntervalMin is NULL
# ERROR CODE -10
IF (sampleIntervalMin IS NOT NULL AND (timeStampDiff) < sampleIntervalMin)
THEN
SELECT -10;
LEAVE addProc;

#DEADBAND CONSTRAINT
# ignore if deadband is NULL
# Note: if something < null --> false; same for >, etc. --> works
# tested: "SELECT IF(true OR 10 NOT BETWEEN (- null/2 + 5) AND (null/2 + 5),2,3);"
#ERROR CODE -11
 ELSEIF (dpDeadband IS NULL OR p_value NOT BETWEEN (- dpDeadband/2 + lastValue) AND (dpDeadband/2 + lastValue) )	
   THEN 
     INSERT INTO data
                (
                    datapoint_name  ,
                    timestamp       , 
                    value
                )
            VALUES
                (
                    p_datapoint_name    ,
                    p_timestamp         ,
                    p_value
                ) ;
      SELECT 1;
ELSE 
SELECT -11;
LEAVE addProc;
END IF;

ELSE
# sample interval exceeded - value is inserted
#added because outside of sample_interval
INSERT INTO data
                (
                    datapoint_name  ,
                    timestamp       , 
                    value
                )
            VALUES
                (
                    p_datapoint_name    ,
                    p_timestamp         ,
                    p_value
                ) ;
SELECT 2;
LEAVE addProc;
END IF;
END
$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure addWarning
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`addWarning`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`addWarning`(

        IN p_errorCode		          TINYINT         ,
        IN p_datapoint_name         VARCHAR(100)    ,
        IN p_timestamp              DATETIME        ,
        IN p_description            VARCHAR(200)    ,
        IN p_toDo	                  VARCHAR(200)    ,
        IN p_priority	              TINYINT         ,
        IN p_source	                VARCHAR(100)
)

BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#    GLAWISCHNIG S.
#    BRAEUER R.
#    ZACH R.
#DATE OF CREATION:
#   UNKNOWN (~mid 2011)
#DATE OF LAST MODIFICATION:
#   2012-04-05
#FUNCTION OF STORED PROCEDURE:
#   if there is an entry in table data for datapoint since last error: add entry to table warning (new error)
#   if there is no entry in table data for datapoint since last error: extend fromTime entry in table warning for datapoint to current timestamp (old error)
#EXAMPLE: TODO: CALL addWarning('name2','2010-12-28 12:00:00',14.23)
#ERROR: -10 -> 'datapoint_name does not exist!'

    DECLARE lv_timestampLastData        DATETIME;
    DECLARE lv_timestampLastWarning     DATETIME;

    #check if given dates(time) are allowed
    IF ((SELECT count(*) FROM datapoint WHERE datapoint_name = p_datapoint_name) = 0)
    THEN
        CALL raiseWarning(-10,'datapoint_name does not exist');
    ELSE
        SET lv_timestampLastData = (SELECT timestamp  FROM data WHERE datapoint_name = p_datapoint_name AND timestamp = 
                                                (SELECT MAX(timestamp) FROM data WHERE datapoint_name = p_datapoint_name) LIMIT 1);
        SET lv_timestampLastWarning = (SELECT MAX(toTime)  FROM warning WHERE datapoint_name = p_datapoint_name);                   
        
          IF (lv_timestampLastData > lv_timestampLastWarning) OR ((SELECT count(*) FROM warning WHERE datapoint_name = p_datapoint_name) = 0) OR (p_errorCode != 10 AND p_errorCode != 11)
        # case new error OR first error OR errorCode other than 10/11
        THEN
                INSERT INTO warning
                (   
                    errorCode       ,
                    datapoint_name  ,
                    description     ,
                    toDo            ,
                    fromTime        ,
                    toTime          ,
                    priority        ,
                    source          
                )

                VALUES
                (
                    p_errorCode         ,
                    p_datapoint_name    ,
                    p_description       ,
                    p_toDo              ,
                    p_timestamp         ,
                    p_timestamp         ,
                    p_priority          ,
                    p_source            
                ) ;            
            #TODO: define return codes
            SELECT 1;
        ELSE
        #case old error -> extend time
                UPDATE warning SET toTime=p_timestamp WHERE toTime=lv_timestampLastWarning and datapoint_name=p_datapoint_name;
            #TODO: define return codes
            SELECT 2;
        END IF;
    END IF;

END

$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure runWatchdog
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`runWatchdog`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`runWatchdog`(
                                IN p_timestamp             DATETIME    
                            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   GLAWISCHNIG S.
#DATE OF CREATION:
#   unknown
#DATE OF LAST MODIFICATION:
#   unknown
#FUNCTION OF STORED PROCEDURE:
#   
#EXAMPLE:
#   


# watchdog column:
# 0 - watchdog disabled
# NULL - sample_interval*1.5 is used for watchdog check interval
# any number [seconds] - this value in seconds is used for watchdog check interval

DECLARE done INT DEFAULT 0;
DECLARE timestamp_diff INTEGER;
DECLARE watchdog INTEGER;
DECLARE p_datapoint_name VARCHAR(100);
DECLARE dp_cursor CURSOR FOR SELECT datapoint_name FROM datapoint; 
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

OPEN dp_cursor;

read_loop: LOOP
  FETCH dp_cursor into p_datapoint_name;

  IF done THEN 
    LEAVE read_loop;
  END IF;

SELECT dpl.watchdog INTO watchdog FROM mon_development.datapoint dpl WHERE dpl.datapoint_name = p_datapoint_name;
SELECT TIMESTAMPDIFF(SECOND, max(d.timestamp), p_timestamp) INTO timestamp_diff FROM mon_development.data d, mon_development.datapoint dp
  WHERE dp.datapoint_name = p_datapoint_name AND  d.datapoint_name = dp.datapoint_name;

IF 
(watchdog = 0)
THEN
SELECT 0;
  
ELSEIF ((timestamp_diff > watchdog) AND (watchdog IS NOT NULL))
  THEN
   
CALL `mon_development`.`addWarning`('10', p_datapoint_name, p_timestamp, 'Watchdog Limit Exceeded','Recommended to Check Sensor','10','database_watchdog');
SELECT 1;   
 
ELSEIF ((watchdog IS NULL) AND (SELECT DISTINCT sample_interval FROM mon_development.datapoint dpl WHERE dpl.datapoint_name = p_datapoint_name AND sample_interval IS NOT NULL))
THEN
   IF (timestamp_diff 
      > 
    (SELECT CONVERT(sample_interval*1.5, SIGNED) FROM mon_development.datapoint dpl WHERE dpl.datapoint_name = p_datapoint_name))

  THEN

CALL `mon_development`.`addWarning`('11', p_datapoint_name, p_timestamp, 'Sample Interval Limit Exceeded','Highly recommended to check sensors','9','database_watchdog');
SELECT 1;

END IF;
END IF;
END LOOP;
CLOSE dp_cursor;
END


$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getValuesWhereDpEqual
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getValuesWhereDpEqual`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getValuesWhereDpEqual` 
            (
                IN p_dp1                   VARCHAR(100)    ,
                IN p_starttime             DATETIME        ,
                IN p_endtime               DATETIME        ,
                IN p_dp2                   VARCHAR(100)    ,
                IN p_value                 DOUBLE                     
            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-07-13
#DATE OF LAST MODIFICATION:
#   2011-11-24
#FUNCTION OF STORED PROCEDURE:
#   returns data(set) of datapoint1 (p_dp1) from table data of timeslot p_starttime to p_endtime where nearest value in the past of datapoint2 (p_dp2) is equal p_value
#EXAMPLE:
#   CALL getValuesWhereDpEqual('tem1','2010-12-29 12:00:00','2010-12-29 13:00:00','con1',1);

    DECLARE lv_index                INT;
    DECLARE lv_indexMax             INT;
    DECLARE lv_tmp                  INT;
    DECLARE lv_valid                BOOLEAN;
    DECLARE lv_timestampLastValid   DATETIME;
    DECLARE lv_timestampCurrentRow  DATETIME;
    DECLARE lv_timestampDiff        INT;
    
    SET lv_index = 1;
    SET lv_valid = FALSE;
    SET lv_tmp = 0;
    
    CREATE TEMPORARY TABLE IF NOT EXISTS data_tmp (
                 `id` INT NOT NULL AUTO_INCREMENT                                   ,
                 `value`                            DOUBLE                          ,
                 `timestamp`                        DATETIME                        ,
                 `valid`                            BOOLEAN                         ,
                 `datapoint_name`                   VARCHAR(100)                    ,
                 `quality`                          DOUBLE                          ,
                 PRIMARY KEY(`id`)                       
                 );
    CREATE TEMPORARY TABLE IF NOT EXISTS data_tmp_sorted LIKE data_tmp;
    TRUNCATE TABLE data_tmp;
    TRUNCATE TABLE data_tmp_sorted;
    
    INSERT INTO data_tmp
                (
                    value               ,
                    timestamp           ,
                    datapoint_name
                )
    (SELECT value, timestamp, datapoint_name FROM data WHERE datapoint_name = p_dp1 AND timestamp BETWEEN p_starttime AND p_endtime);
    
    INSERT INTO data_tmp
                (
                    value               ,
                    timestamp           ,
                    datapoint_name
                )
    (SELECT value, timestamp, datapoint_name FROM data WHERE datapoint_name = p_dp2 AND timestamp BETWEEN p_starttime AND p_endtime);
    
    INSERT INTO data_tmp_sorted
                (
                    quality             ,
                    value               ,
                    timestamp           ,
                    datapoint_name
                )
    (SELECT FIELD(datapoint_name,p_dp2,p_dp1) AS indexDpname, value, timestamp, datapoint_name FROM data_tmp ORDER BY timestamp ASC, indexDpname ASC);
    
    UPDATE  data_tmp_sorted SET valid=TRUE
            WHERE datapoint_name=p_dp2 AND value = p_Value;
    UPDATE  data_tmp_sorted SET valid=FALSE
            WHERE datapoint_name=p_dp2 AND valid IS NULL;
    SET lv_timestampLastValid = p_starttime;
    
    SET lv_indexMax = 
            (SELECT MAX(id) FROM data_tmp_sorted);
    
    WHILE  lv_index <= lv_indexMax
    DO
        
        IF lv_valid = FALSE
        THEN
               IF (SELECT valid FROM data_tmp_sorted WHERE id = lv_index) = 1
               THEN
                    SET lv_valid = TRUE;
                    SET lv_timestampLastValid = 
                        (SELECT timestamp FROM data_tmp_sorted WHERE id = lv_index);
               END IF;
        
        ELSE
               SET lv_tmp =
                        (SELECT valid FROM data_tmp_sorted WHERE id = lv_index);
               
               IF lv_tmp = 0
               THEN
                    SET lv_valid = FALSE;
                    
               ELSEIF lv_tmp IS NULL
               THEN
                    UPDATE data_tmp_sorted SET valid = TRUE WHERE id = lv_index;
                    SET lv_timestampCurrentRow = 
                                    (SELECT timestamp FROM data_tmp_sorted WHERE id = lv_index);
                    SET lv_timestampDiff = 
                                (SELECT TIMESTAMPDIFF(SECOND, lv_timestampLastValid, lv_timestampCurrentRow));
                    IF lv_timestampDiff = 0
                    THEN
                        SET lv_timestampDiff = 1;
                    END IF;
                    UPDATE data_tmp_sorted SET quality = 
                                                    (1000 /  lv_timestampDiff)
                                           WHERE id = lv_index;
                                           
                ELSEIF lv_tmp = 1
                THEN
                    SET lv_timestampLastValid = 
                        (SELECT timestamp FROM data_tmp_sorted WHERE id = lv_index);
            
                END IF;
        
        END IF;
        
        SET lv_index = lv_index + 1;
        
        
    END WHILE;
    
    #for testing purpose only
    #SELECT * FROM data_tmp_sorted;
    
    SELECT datapoint_name, timestamp, value, quality FROM data_tmp_sorted WHERE datapoint_name = p_dp1 AND valid = 1;

END







$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getValuesWhereDpBigger
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getValuesWhereDpBigger`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getValuesWhereDpBigger` 
            (
                IN p_dp1                   VARCHAR(100)    ,
                IN p_starttime             DATETIME        ,
                IN p_endtime               DATETIME        ,
                IN p_dp2                   VARCHAR(100)    ,
                IN p_value                 DOUBLE                     
            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-07-13
#DATE OF LAST MODIFICATION:
#   2011-11-24
#FUNCTION OF STORED PROCEDURE:
#   returns data(set) of datapoint1 (p_dp1) from table data of timeslot p_starttime to p_endtime where nearest value in the past of datapoint2 (p_dp2) is bigger than p_value
#EXAMPLE:
#   CALL getValuesWhereDpBigger('tem1','2010-12-29 12:00:00','2010-12-29 13:00:00','rhu1',60);


    DECLARE lv_index                INT;
    DECLARE lv_indexMax             INT;
    DECLARE lv_tmp                  INT;
    DECLARE lv_valid                BOOLEAN;
    DECLARE lv_timestampLastValid   DATETIME;
    DECLARE lv_timestampCurrentRow  DATETIME;
    DECLARE lv_timestampDiff        INT;
    
    SET lv_index = 1;
    SET lv_valid = FALSE;
    SET lv_tmp = 0;
    
    CREATE TEMPORARY TABLE IF NOT EXISTS data_tmp (
                 `id` INT NOT NULL AUTO_INCREMENT                                   ,
                 `value`                            DOUBLE                          ,
                 `timestamp`                        DATETIME                        ,
                 `valid`                            BOOLEAN                         ,
                 `datapoint_name`                   VARCHAR(100)                    ,
                 `quality`                          DOUBLE                          ,
                 PRIMARY KEY(`id`)                       
                 );
    CREATE TEMPORARY TABLE IF NOT EXISTS data_tmp_sorted LIKE data_tmp;
    TRUNCATE TABLE data_tmp;
    TRUNCATE TABLE data_tmp_sorted;
    
    INSERT INTO data_tmp
                (
                    value               ,
                    timestamp           ,
                    datapoint_name
                )
    (SELECT value, timestamp, datapoint_name FROM data WHERE datapoint_name = p_dp1 AND timestamp BETWEEN p_starttime AND p_endtime);
    
    INSERT INTO data_tmp
                (
                    value               ,
                    timestamp           ,
                    datapoint_name
                )
    (SELECT value, timestamp, datapoint_name FROM data WHERE datapoint_name = p_dp2 AND timestamp BETWEEN p_starttime AND p_endtime);
    
    INSERT INTO data_tmp_sorted
                (
                    quality             ,
                    value               ,
                    timestamp           ,
                    datapoint_name
                )
    (SELECT FIELD(datapoint_name,p_dp2,p_dp1) AS indexDpname, value, timestamp, datapoint_name FROM data_tmp ORDER BY timestamp ASC, indexDpname ASC);
    
    UPDATE  data_tmp_sorted SET valid=TRUE
            WHERE datapoint_name=p_dp2 AND value > p_Value;
    UPDATE  data_tmp_sorted SET valid=FALSE
            WHERE datapoint_name=p_dp2 AND valid IS NULL;
    SET lv_timestampLastValid = p_starttime;
    
    SET lv_indexMax = 
            (SELECT MAX(id) FROM data_tmp_sorted);
    
    WHILE  lv_index <= lv_indexMax
    DO
        
        IF lv_valid = FALSE
        THEN
               IF (SELECT valid FROM data_tmp_sorted WHERE id = lv_index) = 1
               THEN
                    SET lv_valid = TRUE;
                    SET lv_timestampLastValid = 
                        (SELECT timestamp FROM data_tmp_sorted WHERE id = lv_index);
               END IF;
        
        ELSE
               SET lv_tmp =
                        (SELECT valid FROM data_tmp_sorted WHERE id = lv_index);
               
               IF lv_tmp = 0
               THEN
                    SET lv_valid = FALSE;
                    
               ELSEIF lv_tmp IS NULL
               THEN
                    UPDATE data_tmp_sorted SET valid = TRUE WHERE id = lv_index;
                    SET lv_timestampCurrentRow = 
                                    (SELECT timestamp FROM data_tmp_sorted WHERE id = lv_index);
                    SET lv_timestampDiff = 
                                (SELECT TIMESTAMPDIFF(SECOND, lv_timestampLastValid, lv_timestampCurrentRow));
                    IF lv_timestampDiff = 0
                    THEN
                        SET lv_timestampDiff = 1;
                    END IF;
                    UPDATE data_tmp_sorted SET quality = 
                                                    (1000 /  lv_timestampDiff)
                                           WHERE id = lv_index;
               
               ELSEIF lv_tmp = 1
               THEN
                    SET lv_timestampLastValid = 
                        (SELECT timestamp FROM data_tmp_sorted WHERE id = lv_index);
               END IF;
        
        END IF;
        
        SET lv_index = lv_index + 1;
        
        
    END WHILE;
    
    #for testing purpose only
    #SELECT * FROM data_tmp_sorted;
    
    SELECT datapoint_name, timestamp, value, quality FROM data_tmp_sorted WHERE datapoint_name = p_dp1 AND valid = 1;

END








$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getValuesWhereDpLower
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getValuesWhereDpLower`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getValuesWhereDpLower` 
            (
                IN p_dp1                   VARCHAR(100)    ,
                IN p_starttime             DATETIME        ,
                IN p_endtime               DATETIME        ,
                IN p_dp2                   VARCHAR(100)    ,
                IN p_value                 DOUBLE          
            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-07-13
#DATE OF LAST MODIFICATION:
#   2011-11-24
#FUNCTION OF STORED PROCEDURE:
#   returns data(set) of datapoint1 (p_dp1) from table data of timeslot p_starttime to p_endtime where nearest value in the past of datapoint2 (p_dp2) is lower than p_value
#EXAMPLE:
#   CALL getValuesWhereDpLower('tem1','2010-12-29 12:00:00','2010-12-29 13:00:00','rhu1',60);


    DECLARE lv_index                INT;
    DECLARE lv_indexMax             INT;
    DECLARE lv_tmp                  INT;
    DECLARE lv_valid                BOOLEAN;
    DECLARE lv_timestampLastValid   DATETIME;
    DECLARE lv_timestampCurrentRow  DATETIME;
    DECLARE lv_timestampDiff        INT;
    
    SET lv_index = 1;
    SET lv_valid = FALSE;
    SET lv_tmp = 0;
    
    CREATE TEMPORARY TABLE IF NOT EXISTS data_tmp (
                 `id` INT NOT NULL AUTO_INCREMENT                                   ,
                 `value`                            DOUBLE                          ,
                 `timestamp`                        DATETIME                        ,
                 `valid`                            BOOLEAN                         ,
                 `datapoint_name`                   VARCHAR(100)                    ,
                 `quality`                          DOUBLE                          ,
                 PRIMARY KEY(`id`)                       
                 );
    CREATE TEMPORARY TABLE IF NOT EXISTS data_tmp_sorted LIKE data_tmp;
    TRUNCATE TABLE data_tmp;
    TRUNCATE TABLE data_tmp_sorted;
    
    INSERT INTO data_tmp
                (
                    value               ,
                    timestamp           ,
                    datapoint_name
                )
    (SELECT value, timestamp, datapoint_name FROM data WHERE datapoint_name = p_dp1 AND timestamp BETWEEN p_starttime AND p_endtime);
    
    INSERT INTO data_tmp
                (
                    value               ,
                    timestamp           ,
                    datapoint_name
                )
    (SELECT value, timestamp, datapoint_name FROM data WHERE datapoint_name = p_dp2 AND timestamp BETWEEN p_starttime AND p_endtime);
    
    INSERT INTO data_tmp_sorted
                (   
                    quality             ,
                    value               ,
                    timestamp           ,
                    datapoint_name
                )
    (SELECT FIELD(datapoint_name,p_dp2,p_dp1) AS indexDpname, value, timestamp, datapoint_name FROM data_tmp ORDER BY timestamp ASC, indexDpname ASC);

    UPDATE  data_tmp_sorted SET valid=TRUE
            WHERE datapoint_name=p_dp2 AND value < p_Value;
    UPDATE  data_tmp_sorted SET valid=FALSE
            WHERE datapoint_name=p_dp2 AND valid IS NULL;
    SET lv_timestampLastValid = p_starttime;
    
    SET lv_indexMax = 
            (SELECT MAX(id) FROM data_tmp_sorted);
    
    WHILE  lv_index <= lv_indexMax
    DO
        
        IF lv_valid = FALSE
        THEN
               IF (SELECT valid FROM data_tmp_sorted WHERE id = lv_index) = 1
               THEN
                    SET lv_valid = TRUE;
                    SET lv_timestampLastValid = 
                        (SELECT timestamp FROM data_tmp_sorted WHERE id = lv_index);
               END IF;
        
        ELSE
               SET lv_tmp =
                        (SELECT valid FROM data_tmp_sorted WHERE id = lv_index);
               
               IF lv_tmp = 0
               THEN
                    SET lv_valid = FALSE;
                    
               ELSEIF lv_tmp IS NULL
               THEN
                    UPDATE data_tmp_sorted SET valid = TRUE WHERE id = lv_index;
                    SET lv_timestampCurrentRow = 
                                    (SELECT timestamp FROM data_tmp_sorted WHERE id = lv_index);
                    SET lv_timestampDiff = 
                                (SELECT TIMESTAMPDIFF(SECOND, lv_timestampLastValid, lv_timestampCurrentRow));
                    IF lv_timestampDiff = 0
                    THEN
                        SET lv_timestampDiff = 1;
                    END IF;
                    UPDATE data_tmp_sorted SET quality = 
                                                    (1000 /  lv_timestampDiff)
                                           WHERE id = lv_index;
                                           
               ELSEIF lv_tmp = 1
               THEN
                    SET lv_timestampLastValid = 
                        (SELECT timestamp FROM data_tmp_sorted WHERE id = lv_index);
            
               END IF;
        
        END IF;
        
        SET lv_index = lv_index + 1;
        
        
    END WHILE;
    
    #for testing purpose only
    #SELECT * FROM data_tmp_sorted;
    
    SELECT datapoint_name, timestamp, value, quality FROM data_tmp_sorted WHERE datapoint_name = p_dp1 AND valid = 1;

END






$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getValuesWhereDpBetween
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getValuesWhereDpBetween`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getValuesWhereDpBetween` 
            (
                IN p_dp1                   VARCHAR(100)    ,
                IN p_starttime             DATETIME        ,
                IN p_endtime               DATETIME        ,
                IN p_dp2                   VARCHAR(100)    ,
                IN p_valueLow              DOUBLE          ,
                IN p_valueHigh             DOUBLE                     
            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-07-13
#DATE OF LAST MODIFICATION:
#   2011-11-24
#FUNCTION OF STORED PROCEDURE:
#   returns data(set) of datapoint1 (p_dp1) from table data of timeslot p_starttime to p_endtime where nearest value in the past of datapoint2 (p_dp2) is between p_valueLow and p_valueHigh (including values)
#EXAMPLE:
#       CALL getValuesWhereDpBetween('tem1','2010-12-29 12:00:00','2010-12-29 13:00:00','rhu1',40,60);

    DECLARE lv_index                INT;
    DECLARE lv_indexMax             INT;
    DECLARE lv_tmp                  INT;
    DECLARE lv_valid                BOOLEAN;
    DECLARE lv_timestampLastValid   DATETIME;
    DECLARE lv_timestampCurrentRow  DATETIME;
    DECLARE lv_timestampDiff        INT;
    
    SET lv_index = 1;
    SET lv_valid = FALSE;
    SET lv_tmp = 0;
    
    CREATE TEMPORARY TABLE IF NOT EXISTS data_tmp (
                 `id` INT NOT NULL AUTO_INCREMENT                                   ,
                 `value`                            DOUBLE                          ,
                 `timestamp`                        DATETIME                        ,
                 `valid`                            BOOLEAN                         ,
                 `datapoint_name`                   VARCHAR(100)                    ,
                 `quality`                          DOUBLE                          ,
                 PRIMARY KEY(`id`)                       
                 );
    CREATE TEMPORARY TABLE IF NOT EXISTS data_tmp_sorted LIKE data_tmp;
    TRUNCATE TABLE data_tmp;
    TRUNCATE TABLE data_tmp_sorted;
    
    INSERT INTO data_tmp
                (
                    value               ,
                    timestamp           ,
                    datapoint_name
                )
    (SELECT value, timestamp, datapoint_name FROM data WHERE datapoint_name = p_dp1 AND timestamp BETWEEN p_starttime AND p_endtime);
    
    INSERT INTO data_tmp
                (
                    value               ,
                    timestamp           ,
                    datapoint_name
                )
    (SELECT value, timestamp, datapoint_name FROM data WHERE datapoint_name = p_dp2 AND timestamp BETWEEN p_starttime AND p_endtime);
    
    INSERT INTO data_tmp_sorted
                (   quality             ,
                    value               ,
                    timestamp           ,
                    datapoint_name
                )
    (SELECT FIELD(datapoint_name,p_dp2,p_dp1) AS indexDpname, value, timestamp, datapoint_name FROM data_tmp ORDER BY timestamp ASC, indexDpname ASC);
    
    UPDATE  data_tmp_sorted SET valid=TRUE
            WHERE datapoint_name=p_dp2 AND value BETWEEN p_ValueLow AND p_ValueHigh;
    UPDATE  data_tmp_sorted SET valid=FALSE
            WHERE datapoint_name=p_dp2 AND valid IS NULL;
    SET lv_timestampLastValid = p_starttime;
    
    SET lv_indexMax = 
            (SELECT MAX(id) FROM data_tmp_sorted);
    
    WHILE  lv_index <= lv_indexMax
    DO
        
        IF lv_valid = FALSE
        THEN
               IF (SELECT valid FROM data_tmp_sorted WHERE id = lv_index) = 1
               THEN
                    SET lv_valid = TRUE;
                    SET lv_timestampLastValid = 
                        (SELECT timestamp FROM data_tmp_sorted WHERE id = lv_index);
               END IF;
        
        ELSE
               SET lv_tmp =
                        (SELECT valid FROM data_tmp_sorted WHERE id = lv_index);
               
               IF lv_tmp = 0
               THEN
                    SET lv_valid = FALSE;
                    
               ELSEIF lv_tmp IS NULL
               THEN
                    UPDATE data_tmp_sorted SET valid = TRUE WHERE id = lv_index;
                    SET lv_timestampCurrentRow = 
                                    (SELECT timestamp FROM data_tmp_sorted WHERE id = lv_index);
                    SET lv_timestampDiff = 
                                (SELECT TIMESTAMPDIFF(SECOND, lv_timestampLastValid, lv_timestampCurrentRow));
                    IF lv_timestampDiff = 0
                    THEN
                        SET lv_timestampDiff = 1;
                    END IF;
                    UPDATE data_tmp_sorted SET quality = 
                                                    (1000 /  lv_timestampDiff)
                                           WHERE id = lv_index;
               
               ELSEIF lv_tmp = 1
               THEN
                    SET lv_timestampLastValid = 
                        (SELECT timestamp FROM data_tmp_sorted WHERE id = lv_index);
 
               END IF;
        
        END IF;
        
        SET lv_index = lv_index + 1;
        
        
    END WHILE;
    
    #for testing purpose only
    #SELECT * FROM data_tmp_sorted;
    
    SELECT datapoint_name, timestamp, value, quality FROM data_tmp_sorted WHERE datapoint_name = p_dp1 AND valid = 1;

END


$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getValuesPeriodicWhereDpBigger
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getValuesPeriodicWhereDpBigger`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getValuesPeriodicWhereDpBigger` 
            (
                IN p_dp1                   VARCHAR(100)    ,
                IN p_starttime             DATETIME        ,
                IN p_endtime               DATETIME        ,
                IN p_period                DOUBLE          ,
                IN p_dp2                   VARCHAR(100)    ,
                IN p_value                 DOUBLE          ,
                IN p_modeDp1               INT             ,
                IN p_modeDp2               INT              
            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-07-13
#DATE OF LAST MODIFICATION:
#   2012-02-29
#FUNCTION OF STORED PROCEDURE:
#   returns periodic generated data(set) of datapoint1 (p_dp1) of timeslot p_starttime to p_endtime where periodic generated value of datapoint2 (p_dp2) is bigger than p_value
#   TODO: performance analysis, guess is that this SP is better performing (need to be compared with non periodic functions) -> no, it is not :-)
#EXAMPLE:
#   CALL getValuesPeriodicWhereDpBigger('tem2','2010-12-29 12:00:00','2010-12-29 13:00:00',180,'tem1',25,1,1);
#   CALL getValuesPeriodicWhereDpBigger('tem1','2010-12-29 12:00:00','2010-12-29 13:00:00',180,'tem1',25,1,1);

    #set mode with that SP are called to mode without output (values are stored in table data_periodic)
    SET p_modeDp1 = p_modeDp1 + 1000;
    SET p_modeDp2 = p_modeDp2 + 1000;
    
    CALL getValuesPeriodic(p_dp1, p_starttime, p_endtime, p_period, p_modeDp1);
    CREATE TEMPORARY TABLE IF NOT EXISTS data_periodic_dp1  LIKE    data_periodic;
    TRUNCATE TABLE data_periodic_dp1;
    INSERT data_periodic_dp1    SELECT * FROM data_periodic;

    #TODO: copy only needed column (=timestamp)
    CALL getValuesPeriodic(p_dp2, p_starttime, p_endtime, p_period, p_modeDp2);
    CREATE TEMPORARY TABLE IF NOT EXISTS data_periodic_dp2  LIKE    data_periodic;
    TRUNCATE TABLE data_periodic_dp2;
    INSERT data_periodic_dp2    SELECT * FROM data_periodic WHERE value>p_value;
    
    SELECT A.datapoint_name, A.timestamp, A.value, A.quality FROM data_periodic_dp1 A INNER JOIN data_periodic_dp2 B ON A.timestamp=B.timestamp;
    
END






$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getValuesPeriodicWhereDpEqual
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getValuesPeriodicWhereDpEqual`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getValuesPeriodicWhereDpEqual` 
            (
                IN p_dp1                   VARCHAR(100)    ,
                IN p_starttime             DATETIME        ,
                IN p_endtime               DATETIME        ,
                IN p_period                DOUBLE          ,
                IN p_dp2                   VARCHAR(100)    ,
                IN p_value                 DOUBLE          ,
                IN p_modeDp1               INT             ,
                IN p_modeDp2               INT              
            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-07-13
#DATE OF LAST MODIFICATION:
#   2012-02-29
#FUNCTION OF STORED PROCEDURE:
#   returns periodic generated data(set) of datapoint1 (p_dp1) from timeslot p_starttime to p_endtime where periodic generated value of datapoint2 (p_dp2) is equal p_value
#   TODO: performance analysis, guess is that this SP is better performing (need to be compared with non periodic functions) -> no, it is not :-)
#EXAMPLE:
#   CALL getValuesPeriodicWhereDpEqual('tem1','2010-12-29 12:00:00','2010-12-29 13:00:00',180,'con1',1,1,1);

    #set mode with that SP are called to mode without output (values are stored in table data_periodic)
    SET p_modeDp1 = p_modeDp1 + 1000;
    SET p_modeDp2 = p_modeDp2 + 1000;
    
    CALL getValuesPeriodic(p_dp1, p_starttime, p_endtime, p_period, p_modeDp1);
    CREATE TEMPORARY TABLE IF NOT EXISTS data_periodic_dp1  LIKE    data_periodic;
    TRUNCATE TABLE data_periodic_dp1;
    INSERT data_periodic_dp1    SELECT * FROM data_periodic;
    
    #TODO: copy only needed column (=timestamp)
    CALL getValuesPeriodic(p_dp2, p_starttime, p_endtime, p_period, p_modeDp2);
    CREATE TEMPORARY TABLE IF NOT EXISTS data_periodic_dp2  LIKE    data_periodic;
    TRUNCATE TABLE data_periodic_dp2;
    INSERT data_periodic_dp2    SELECT * FROM data_periodic WHERE value=p_value;
    
    SELECT A.datapoint_name, A.timestamp, A.value, A.quality FROM data_periodic_dp1 A INNER JOIN data_periodic_dp2 B ON A.timestamp=B.timestamp;
    
END








$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getValuesPeriodicWhereDpBetween
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getValuesPeriodicWhereDpBetween`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getValuesPeriodicWhereDpBetween` 
            (
                IN p_dp1                   VARCHAR(100)    ,
                IN p_starttime             DATETIME        ,
                IN p_endtime               DATETIME        ,
                IN p_period                DOUBLE          ,
                IN p_dp2                   VARCHAR(100)    ,
                IN p_valueLow              DOUBLE          ,
                IN p_valueHigh             DOUBLE          ,
                IN p_modeDp1               INT             ,
                IN p_modeDp2               INT              
            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-07-13
#DATE OF LAST MODIFICATION:
#   2012-02-29
#FUNCTION OF STORED PROCEDURE:
#   returns data(set) of periodic generated values for datapoint1 (p_dp1) of timeslot p_starttime to p_endtime where periodic generated value of datapoint2 (p_dp2) is between p_valueLow and p_valueHigh (including low and high values!!)
#   TODO: performance analysis, guess is that this SP is better performing (need to be compared with non periodic functions)
#EXAMPLE:
#   CALL getValuesPeriodicWhereDpBetween('tem2','2010-12-29 12:00:00','2010-12-29 13:00:00',180,'tem1',23,26,1,1);
#   CALL getValuesPeriodicWhereDpBetween('tem1','2010-12-29 12:00:00','2010-12-29 13:00:00',180,'tem1',23,26,1,1);

    #set mode with that SP are called to mode without output (values are stored in table data_periodic)
    SET p_modeDp1 = p_modeDp1 + 1000;
    SET p_modeDp2 = p_modeDp2 + 1000;
    
    CALL getValuesPeriodic(p_dp1, p_starttime, p_endtime, p_period, p_modeDp1);
    CREATE TEMPORARY TABLE IF NOT EXISTS data_periodic_dp1  LIKE    data_periodic;
    TRUNCATE TABLE data_periodic_dp1;
    INSERT data_periodic_dp1    SELECT * FROM data_periodic;
    
    #TODO: copy only needed column (=timestamp)
    CALL getValuesPeriodic(p_dp2, p_starttime, p_endtime, p_period, p_modeDp2);
    CREATE TEMPORARY TABLE IF NOT EXISTS data_periodic_dp2  LIKE    data_periodic;
    TRUNCATE TABLE data_periodic_dp2;
    INSERT data_periodic_dp2    SELECT * FROM data_periodic WHERE value BETWEEN p_valueLow AND p_valueHigh;
    
    SELECT A.datapoint_name, A.timestamp, A.value, A.quality FROM data_periodic_dp1 A INNER JOIN data_periodic_dp2 B ON A.timestamp=B.timestamp;

   
END




$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getValuesPeriodicWhereDpLower
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getValuesPeriodicWhereDpLower`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getValuesPeriodicWhereDpLower` 
            (
                IN p_dp1                   VARCHAR(100)    ,
                IN p_starttime             DATETIME        ,
                IN p_endtime               DATETIME        ,
                IN p_period                DOUBLE          ,
                IN p_dp2                   VARCHAR(100)    ,
                IN p_value                 DOUBLE          ,
                IN p_modeDp1               INT             ,
                IN p_modeDp2               INT                
            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2012-02-29
#DATE OF LAST MODIFICATION:
#   2011-12-31
#FUNCTION OF STORED PROCEDURE:
#   returns periodic generated data(set) of datapoint1 (p_dp1) of timeslot p_starttime to p_endtime where periodic generated value of datapoint2 (p_dp2) is lower than p_value
#   TODO: performance analysis, guess is that this SP is better performing (need to be compared with non periodic functions) -> no, it is not :-)
#EXAMPLE:
#   CALL getValuesPeriodicWhereDpLower('tem2','2010-12-29 12:00:00','2010-12-29 13:00:00',180,'tem1',25,1,1);
#   CALL getValuesPeriodicWhereDpLower('tem1','2010-12-29 12:00:00','2010-12-29 13:00:00',180,'tem1',25,1,1);

    #set mode with that SP are called to mode without output (values are stored in table data_periodic)
    SET p_modeDp1 = p_modeDp1 + 1000;
    SET p_modeDp2 = p_modeDp2 + 1000;
    
    CALL getValuesPeriodic(p_dp1, p_starttime, p_endtime, p_period, p_modeDp1);
    CREATE TEMPORARY TABLE IF NOT EXISTS data_periodic_dp1  LIKE    data_periodic;
    TRUNCATE TABLE data_periodic_dp1;
    INSERT data_periodic_dp1    SELECT * FROM data_periodic;
    
    #TODO: copy only needed column (=timestamp)
    CALL getValuesPeriodic(p_dp2, p_starttime, p_endtime, p_period, p_modeDp2);
    CREATE TEMPORARY TABLE IF NOT EXISTS data_periodic_dp2  LIKE    data_periodic;
    TRUNCATE TABLE data_periodic_dp2;
    INSERT data_periodic_dp2    SELECT * FROM data_periodic WHERE value<p_value;
    
    SELECT A.datapoint_name, A.timestamp, A.value, A.quality FROM data_periodic_dp1 A INNER JOIN data_periodic_dp2 B ON A.timestamp=B.timestamp;
    
END






$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure raiseWarning
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`raiseWarning`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`raiseWarning`(
            p_errorId   INT             ,
            p_msg       VARCHAR(128)
        )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#   ZACH R.
#DATE OF CREATION:
#   2011-07-25
#DATE OF LAST MODIFICATION:
#   2012-04-05
#FUNCTION OF STORED PROCEDURE:
#   Raise an "warning" (numer and string) with user defined message.
#EXAMPLE:
#   CALL raiseWarning (-10, 'Something bad just happened.');        
    
    SELECT p_errorId;
    #TODO: implement return of string (then it is multiple resultset)
    #SELECT p_msg;
        
END
$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure trial
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`trial`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`trial`()

BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-07-26
#DATE OF LAST MODIFICATION:
#   2011-07-26
#FUNCTION OF STORED PROCEDURE:
#   SP for testing code


    DECLARE a   INT;
    DECLARE cursor1 CURSOR FOR SELECT zone_idzone from datapoint WHERE datapoint_name='tem2';
    CREATE TEMPORARY TABLE IF NOT EXISTS testData like datapoint;
    

    OPEN cursor1;
    FETCH cursor1 INTO a;
    CLOSE cursor1;
    Select a;

END
$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure calcAverageWeighted
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`calcAverageWeighted`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`calcAverageWeighted`(
                IN p_datapoint_name        VARCHAR(100)    ,
                IN p_starttime             DATETIME        ,
                IN p_endtime               DATETIME        ,
                IN p_startvalue            DOUBLE          ,
                OUT p_currentValue         DOUBLE          ,
                OUT p_lastValidValue       DOUBLE          ,
                OUT p_quality              INT              
            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-09-05
#DATE OF LAST MODIFICATION:
#   2011-10-06
#FUNCTION OF STORED PROCEDURE:
#   this stored procedure calculates the weighted (by time duration) average value according to an given datapoint_name in an given timeslot (starttime to endtime).
#   It stores the calculated value of the given period (p_currentValue) in the table data_periodic with the timestamp p_endtime. The calculated value p_currentValue and the last value in the given period (lastValidValue) are returned to the calling function.
#EXAMPLE:
#       the two output variables var1 and var2 must existe before calling the SP, therefore (@ for user variable):
#       SET @var1 = 1;
#       SET @var2 = 0;
#       SET @var3 = 1;
#       CALL calcAverageWeighted('tem1','2010-12-29 12:10:00','2010-12-29 12:40:00',3,@var1,@var2,@var3);
#       There are no values directly returned (because otherwise they would always be returned when this SP is called from another SP).
#       For testing:
#       SELECT * from data_calcAverageWeighted;
#       SELECT @var1;
#       SELECT @var2;
#       SELECT @var3;
    
        DECLARE lv_index            INT;
        DECLARE lv_indexMax         INT;
        DECLARE lv_timedurationSum  DOUBLE;
        DECLARE lv_timestamp1       DATETIME;
        DECLARE lv_timestamp2       DATETIME;
                        
        SET lv_index = 1;
        
        #create (temporary) table for calculations in this stored procedure
        CREATE TEMPORARY TABLE IF NOT EXISTS data_calcAverageWeighted (
                        `id`                        INT         NOT NULL AUTO_INCREMENT      ,
                        `value`                     DOUBLE                                   ,
                        `timestamp`                 DATETIME                                 ,
                        `timeduration`              INT                                      ,
                        PRIMARY KEY(`id`)                       
                        );
        TRUNCATE TABLE data_calcAverageWeighted;
        
        #insert startdata (given from calling function) in (temporary) table data_calcAverageWeighted
        INSERT INTO data_calcAverageWeighted
                        (       `value`             ,
                                `timestamp`         
                        )
        VALUES (
                        p_startvalue               ,
                        p_starttime               
                );
        #copy data that shall be weighted into seperate (temporary) table data_calcAverageWeighted
        INSERT INTO data_calcAverageWeighted
                (       `value`             ,
                        `timestamp`         
                        )
        SELECT value,timestamp FROM data WHERE datapoint_name=p_datapoint_name AND timestamp BETWEEN p_starttime AND p_endtime;
        #insert last data into table data_calcAverageWeighted. Only timestamp needed because of calculation of the duration of the last value
        INSERT INTO data_calcAverageWeighted(
                                `value`             ,
                                `timestamp`         ,
                                `timeduration`     )
        VALUES (
                        0               ,
                        p_endtime       ,
                        0               );
        
        SET lv_indexMax=
                        (SELECT MAX(id) FROM data_calcAverageWeighted);
                        
        WHILE (lv_index+1) <= lv_indexMax
        DO
            SET lv_timestamp1=(SELECT timestamp FROM data_calcAverageWeighted WHERE id=lv_index);
            SET lv_timestamp2=(SELECT timestamp FROM data_calcAverageWeighted WHERE id=lv_index+1);
            UPDATE data_calcAverageWeighted SET timeduration=
                (SELECT TIMESTAMPDIFF(SECOND,lv_timestamp1, lv_timestamp2)) WHERE id=lv_index;
            
            SET lv_index=lv_index+1;
        END WHILE;
        
        IF p_startvalue IS NULL
        THEN
            UPDATE data_calcAverageWeighted SET timeduration=0 WHERE id=1;
            UPDATE data_calcAverageWeighted SET value=0 WHERE id=1;
        END IF;
        
        #calculate weighted average value
        SET lv_timedurationSum =
                                (SELECT SUM(timeduration) FROM data_calcAverageWeighted);
        
        IF lv_timedurationSum = 0
        THEN
            #TODO: could cause problems if no values are in current period (lv_indexMax-1 then 0!?), test if this can happen!
            SET p_currentValue = 
                         (SELECT value FROM data_calcAverageWeighted WHERE id=lv_indexMax-1);
        ELSE
            SET p_currentValue =
                         (SELECT SUM(value * timeduration)/lv_timedurationSum FROM data_calcAverageWeighted);
        END IF;
        
        
        #TODO: could cause problems if no values are in current period (lv_indexMax-1 then 0!?), test if this can happen!
        SET p_lastValidValue =
                    (SELECT value FROM data_calcAverageWeighted WHERE id = lv_indexMax-1);
        #set quality, not full correct if more than one dataset for the same timestamp of an datapoint (but this should not be too often)           
        SET p_quality=lv_index-1;
        
        #for testing purpose:
        #SELECT * FROM data_calcAverageWeighted;
        #SELECT p_currentValue;
        #SELECT p_lastValidValue;
        #/for testing purpose:
END

$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getDatapoint
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getDatapoint`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getDatapoint`(
                                IN  p_datapoint_name        VARCHAR(100)
                               )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#   ZACHR.
#DATE OF CREATION:
#   2011-10-05
#DATE OF LAST MODIFICATION:
#   2012-07-06
#FUNCTION OF STORED PROCEDURE:
#   returns datapoint, order because then the order in matlab will be correct (else problem e.g. con1, con10, con11, ..., con2, con20)
#EXAMPLES:
#   CALL getDatapoint('tem2');
#   CALL getDatapoint('tem%');
    
    IF p_datapoint_name IS NULL
    THEN
        SELECT * FROM datapoint ORDER BY ABS(datapoint.datapoint_name);
   ELSE
        SELECT * FROM datapoint WHERE datapoint.datapoint_name LIKE p_datapoint_name ORDER BY ABS(datapoint.datapoint_name);
    END IF;
    
END$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure deleteDatapoint
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`deleteDatapoint`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`deleteDatapoint`(
                    IN      p_datapoint_name       VARCHAR(100)
                    )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#   ZACH R.
#DATE OF CREATION:
#   2012-07-06
#DATE OF LAST MODIFICATION:
#   2011-11-07
#FUNCTION OF STORED PROCEDURE:
#   deletes datapoint (from table datapoint), all entries in table data and entries in table data_source
#   supports wildcards
#EXAMPLE:
#   CALL deleteDatapoint('tem1');
#   CALL deleteDatapoint('tem%');

    #code without wildcard support
    #
    #DELETE FROM data WHERE datapoint_name=p_datapoint_name;
    #DELETE FROM data_source WHERE datapoint_name=p_datapoint_name;
    #DELETE FROM datapoint WHERE datapoint_name=p_datapoint_name;

    #code with wildcard support
    #
    DELETE FROM data WHERE datapoint_name LIKE p_datapoint_name;
    DELETE FROM connections WHERE datapoint_name LIKE p_datapoint_name;
    DELETE FROM datapoint WHERE datapoint_name LIKE p_datapoint_name;
    #TODO delete devive if it has no other datapoint references
    
END
$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure emptyDatapoint
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`emptyDatapoint`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`emptyDatapoint`(
                    IN      p_datapoint_name       VARCHAR(100)
                    )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-10-10
#DATE OF LAST MODIFICATION:
#   2011-11-07
#FUNCTION OF STORED PROCEDURE:
#   deletes all entries in table data for given datapoint
#   supports wildcards!
#EXAMPLE:
#   CALL emptyDatapoint('tem1');
#   CALL emptyDatapoint('tem%');

    #code without wildcard support
    #
    DELETE FROM data WHERE datapoint_name=p_datapoint_name;
    
    
    #code with wildcard support
    #
    DELETE FROM data WHERE datapoint_name LIKE p_datapoint_name;
    
END

$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure emptyDatapointTimeslot
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`emptyDatapointTimeslot`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`emptyDatapointTimeslot`(
                    IN      p_datapoint_name       VARCHAR(100)     ,
                    IN      p_starttime            DATETIME         ,
                    IN      p_endtime              DATETIME         
                    )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-10-10
#DATE OF LAST MODIFICATION:
#   2011-11-07
#FUNCTION OF STORED PROCEDURE:
#   deletes entries  in table data for given datapoint of given timeslot (including limits starttime and endtime)
#   supports wildcards!
#EXAMPLE:
#   CALL emptyDatapointTimeslot('tem1','2010-12-29 12:10:00','2010-12-29 12:40:00');
#   CALL emptyDatapointTimeslot('tem%','2010-12-29 12:10:00','2010-12-29 12:40:00');

    #code without wildcard support
    #
    #DELETE FROM data WHERE datapoint_name=p_datapoint_name AND timestamp BETWEEN p_starttime AND p_endtime;
    
    
    #code with wildcard support
    #
    DELETE FROM data WHERE datapoint_name LIKE p_datapoint_name AND timestamp BETWEEN p_starttime AND p_endtime;
    
END




$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure addUser
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`addUser`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`addUser` 
            (
                IN p_name               VARCHAR(100)    ,
                IN p_password           BINARY(60)
            )         
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#    BRAEUER R.
#DATE OF CREATION:
#   2011-10-24
#DATE OF LAST MODIFICATION:
#   2011-11-07
#FUNCTION OF STORED PROCEDURE:
#   adds entry in table user
#   all parameters have to be served to the stored procedure, when no entry of argument wanted hand over null (works only if null is allowed)
#   uid is primary key and automatically generated (incremented)
#
#EXAMPLE: CALL addUser('test',$2a$10$VWE1kL9BwSYCar1cx0HL.OmWJvOL/NV7YB5VBhOllu29aeNN77zs6)
               
            INSERT INTO user
                (
                    name            ,
                    password       
                )
            
            VALUES
                (
                    p_name          ,
                    p_password         
                ) ;

END

$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure addRole
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`addRole`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`addRole` 
            (
                IN p_name              VARCHAR(100)      ,
                IN p_description       VARCHAR(100)     
            )         
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#    BRAEUER R.
#DATE OF CREATION:
#   2011-10-24
#DATE OF LAST MODIFICATION:
#   2011-10-25
#FUNCTION OF STORED PROCEDURE:
#   adds entry in table role
#   all parameters have to be served to the stored procedure, when no entry of argument wanted hand over null (works only if null is allowed)
#   id is primary key and automatically generated (incremented)
#
#EXAMPLE: CALL addRole('person','Person Module')
               
            INSERT INTO role
                (
                    name            ,
                    description      
                )
            
            VALUES
                (
                    p_name          ,
                    p_description    
                ) ;

END

$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure addUserToRole
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`addUserToRole`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`addUserToRole` 
            (
                IN p_nameUser               VARCHAR(100)    ,
                IN p_nameRole               VARCHAR(100)     
            )         
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#    BRAEUER R.
#DATE OF CREATION:
#   2011-10-24
#DATE OF LAST MODIFICATION:
#   2011-10-25
#FUNCTION OF STORED PROCEDURE:
#   adds entry in table userRole
#   p_nameUser must exist in table user
#   p_nameRole must exist in table role
#
#EXAMPLE: CALL addUserToRole('user1','person')

    INSERT INTO user_role 
        (
            uid     ,
            rid      
        )
    VALUES
        (
            (SELECT id FROM user WHERE name=p_nameUser)     ,
            (SELECT id FROM role WHERE name=p_nameRole)
        );

END


$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure checkPermissionOfUserForDatapoint
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`checkPermissionOfUserForDatapoint`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`checkPermissionOfUserForDatapoint` (
                        IN p_user                       VARCHAR(100)           ,
                        IN p_datapoint_name             VARCHAR(100)           ,
                        IN p_permissionType             ENUM('read'     ,
                                                             'write'    ,
                                                             'admin'
                                                            )      
                        )
foo:BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#    BRAEUER R.
#DATE OF CREATION:
#   2011-12-05
#DATE OF LAST MODIFICATION:
#   2012-06-26
#FUNCTION OF STORED PROCEDURE:
#   this function returns a boolean value of if a user has the given access to a datapoint
#EXAMPLE:
#   CALL checkPermissionOfUserForDatapoint('user1','tem1','read');
#ERROR: -20 -> 'Given datapoint_name not in database!'
#       -21 -> 'Given user not in database!'
#       -22 -> 'Wrong permission type given, only ''read'', ''write'' or ''admin'' allowed!'

    DECLARE lv_index        INT;
    DECLARE lv_indexMax     INT;
    DECLARE lv_currentzone  INT;
    DECLARE lv_DpInSubzone  BOOLEAN;
    DECLARE lv_return       BOOLEAN;
    
    SET lv_return = FALSE;
    
    IF (SELECT DISTINCT datapoint_name FROM datapoint WHERE datapoint_name=p_datapoint_name) IS NULL
    THEN
         CALL raiseWarning(-20, 'Given datapoint_name not in database!');
    ELSEIF (SELECT DISTINCT id FROM user WHERE name=p_user) IS NULL
    THEN
         CALL raiseWarning(-21, 'Given user not in database!');
    ELSE
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_SP_checkPermissionOfUserForDatapoint (
                        `id`                INT NOT NULL AUTO_INCREMENT      ,
                        `idzone`            INT NOT NULL                     ,
                        PRIMARY KEY(`id`)                                  
                 );
    TRUNCATE TABLE tmp_SP_checkPermissionOfUserForDatapoint;
    
    CASE p_permissionType
        WHEN    'read'
        THEN    
            INSERT INTO tmp_SP_checkPermissionOfUserForDatapoint
                    (
                        idzone     
                    )
            SELECT DISTINCT idzone FROM role_zone_permissions WHERE role_id IN ( SELECT rid FROM user_role WHERE uid= (SELECT id FROM user WHERE name=p_user) ) AND `read` IS TRUE;
        WHEN    'write'
        THEN    
            INSERT INTO tmp_SP_checkPermissionOfUserForDatapoint
                    (
                        idzone     
                    )
            SELECT DISTINCT idzone FROM role_zone_permissions WHERE role_id IN ( SELECT rid FROM user_role WHERE uid= (SELECT id FROM user WHERE name=p_user) ) AND `write` IS TRUE;
        WHEN    'admin'
        THEN    
            INSERT INTO tmp_SP_checkPermissionOfUserForDatapoint
                    (
                        idzone     
                    )
            SELECT DISTINCT idzone FROM role_zone_permissions WHERE role_id IN ( SELECT rid FROM user_role WHERE uid= (SELECT id FROM user WHERE name=p_user) ) AND `admin` IS TRUE;
        ELSE
            CALL raiseWarning(-22, 'Wrong permission type given, only ''read'', ''write'' or ''admin'' allowed!');
            LEAVE foo;
        END CASE;
    
    #for testing purpose only!
    #SELECT @lv_tmpStr;
    #SELECT * FROM tmp_SP_checkPermissionOfUserForDatapoint;
    
    SET lv_index = 1;
    SET lv_indexMax=
              (SELECT MAX(id) FROM tmp_SP_checkPermissionOfUserForDatapoint);
                        
    WHILE (lv_index) <= lv_indexMax
    DO
        SET lv_currentZone =
                (SELECT idzone FROM tmp_SP_checkPermissionOfUserForDatapoint WHERE id=lv_index);
        #the third parameter is the number of sublvels, NULL stands for all sublevels
        CALL isDpInSubzone(p_datapoint_name, lv_currentZone, NULL, lv_DpInSubzone);
        IF lv_DpInSubzone IS TRUE
        THEN
            SET lv_return = TRUE;
        END IF;
        SET lv_index=lv_index+1;
    END WHILE;
    
    SELECT lv_return;

    END IF;
END












$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure addRoleAccessToZone
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`addRoleAccessToZone`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`addRoleAccessToZone` (
                        IN p_role                        VARCHAR(100)           ,
                        IN p_idzone                      INT                    ,
                        IN p_read                        BOOLEAN                ,
                        IN p_write                       BOOLEAN                ,
                        IN p_admin                       BOOLEAN                
                        )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#    BRAEUER R.
#DATE OF CREATION:
#   2011-12-05
#DATE OF LAST MODIFICATION:
#   2011-12-06
#FUNCTION OF STORED PROCEDURE:
#   this function adds an entry into the table role_has_access_to_zone
#EXAMPLE:
#   CALL addRoleAccessToZone('role1',1, true, false false);
    
    DECLARE lv_idRole   INT;
    
    SET lv_idRole =
            (SELECT id FROM role WHERE name = p_role);
            
    INSERT INTO role_zone_permissions
        (
                role_id         ,
                idzone     ,
                `read`          ,
                `write`         ,
                admin           
        )
    VALUES
        (
            lv_idRole           ,
            p_idzone       ,
            p_read              ,
            p_write             ,
            p_admin
        );
    
END




$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure isDpInSubzone
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`isDpInSubzone`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`isDpInSubzone`(
                            IN  p_datapoint_name       VARCHAR(100)         ,
                            IN  p_zone                 INT                  ,
                            IN  p_sublevels            INT                  ,        
                            OUT p_out                  BOOLEAN              
                            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-12-06
#DATE OF LAST MODIFICATION:
#   2012-06-26
#FUNCTION OF STORED PROCEDURE:
#   returns true if the given datapoint is in the given zone or a subzone of the given sublevel (NULL --> all sublevels) of it, false if it is not through the variable p_out
#EXAMPLE:
#   CALL isDpInSubzone('tem1',1,3,@result);
#   CALL isDpInSubzone('tem1',1,NULL,@result);
#       @result is an OUT variable!
    

    IF (SELECT DISTINCT idzone FROM zone WHERE idzone=p_zone) IS NULL
    THEN
         CALL raiseWarning('Given zone not in database!');
    ELSE
        
        CALL getSubzones_Internal(p_zone, p_sublevels);
        
        IF (SELECT count(*) FROM datapoint, zones_tmpSPsubzones WHERE datapoint.zone_idzone IN (zones_tmpSPsubzones.zone) AND datapoint_name = p_datapoint_name) = 0
        THEN
            SET p_out = FALSE;
        ELSE
            SET p_out = TRUE;
        END IF;
    
    END IF;
    
END





$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getSubzones_Internal
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getSubzones_Internal`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getSubzones_Internal`(
                            IN  p_idzone        INT             ,
                            IN  p_sublevels     INT       
                            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-12-06
#DATE OF LAST MODIFICATION:
#   2012-09-05
#FUNCTION OF STORED PROCEDURE:
#   calculates  subzones which are contained in a given number of sublevels of a zone (zone itself is also written into table!)
#   p_sublevels = NULL --> return all subzones
#EXAMPLE:
#   CALL getSubzones_Internal(10,3);
#   CALL getSubzones_Internal(10,NULL);
#ERROR:
#   -30 -> 'Given zone not in database!'
#EOH

    DECLARE lv_index                        INT;
    DECLARE lv_currentzone                  INT;
    DECLARE lv_currentSublevel              INT;
    DECLARE lv_indexCurrentSublevelMax      INT;
    
    IF (SELECT DISTINCT idzone FROM zone WHERE idzone=p_idzone) IS NULL
    THEN
         CALL raiseWarning(-30,'Given zone not in database!');
    ELSE
        
        SET lv_index=1;
        SET lv_currentSublevel=0;
        SET lv_indexCurrentSublevelMax=1;
        
        CREATE TEMPORARY TABLE IF NOT EXISTS zones_tmpSPsubzones (
                            `ID` INT NOT NULL AUTO_INCREMENT        ,
                            `zone` INT                              ,
                            `sublevel` INT                          ,
                            PRIMARY KEY(`ID`)                       
                            );
        TRUNCATE TABLE zones_tmpSPsubzones;

        INSERT INTO zones_tmpSPsubzones 
                    (
                     zone       ,
                     sublevel   
                     ) 
        VALUES  (
                    p_idzone            ,
                    lv_currentSublevel           
                );
        
        SET lv_currentzone=p_idzone;
        
        #if all subzones shall be returned set p_sublevels to max number of subzones
        IF p_sublevels IS NULL
        THEN
            SET p_sublevels = 1000;
        END IF;
        
        #if current zone has subzones write them into the table zones_tmpSPsubzones
        #set current zone to next entry in table zones_tmpSPsubzones
        #do this till the maximum number of sublevels (p_sublevels) is reached or till there is no further entry in table zones_tmpSPsubzones
        #restrict to 1000 sublevels, need to detect inconsistency of table <zone_has_zone> (problem if 2 zones contain each other in 2 entries, must not be!)
        WHILE lv_currentzone IS NOT NULL AND lv_currentSublevel < p_sublevels
        DO
            #Does lv_current_zone have subzones?
            IF (SELECT DISTINCT zone_high FROM zone_has_zone WHERE zone_high=lv_currentzone) IS NOT NULL
            THEN
                #insert subzones of current zone into table zones_tmpSPsubzones
                INSERT INTO zones_tmpSPsubzones 
                            (zone)
                (SELECT zone_low FROM zone_has_zone WHERE zone_high=lv_currentzone);
            END IF;
            
            #if last entry of current sublevel is reached write current sublevel into table zones_tmpSPsubzones and get index where next sublevel ends
            IF lv_index = lv_indexCurrentSublevelMax
            THEN
                SET lv_indexCurrentSublevelMax = 
                    (SELECT MAX(ID) FROM zones_tmpSPsubzones);
                SET lv_currentSublevel=lv_currentSublevel+1;
                UPDATE zones_tmpSPsubzones SET sublevel=lv_currentSublevel WHERE sublevel IS NULL;
            END IF;
          
          #set next entry in table zones_tmpSPsubzones to be checked by next interation
          SET lv_index=lv_index+1;
          SET lv_currentzone=
                      (SELECT zone FROM zones_tmpSPsubzones WHERE ID=lv_index);
        END WHILE;
        
        IF lv_currentSublevel>=1000
        THEN 
            CALL raiseError('To many subzone levels returned (max number is 1000) or inconsistent table <zone_has_zone>');
        END IF;
    END IF;
END













$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getNumberOfValues
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getNumberOfValues`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getNumberOfValues`(
                IN p_datapoint_name        VARCHAR(100)    ,
                IN p_starttime             DATETIME        ,
                IN p_endtime               DATETIME               
            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2012-04-03
#DATE OF LAST MODIFICATION:
#   2012-04-03
#FUNCTION OF STORED PROCEDURE:
#   returns number of row entries of wanted datapoint_name in table data for wanted timeslot
#EXAMPLE:
#   CALL getNumberOfValues('tem1','2010-12-29 12:00:00', '2010-12-29 13:00:00');

#
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2012-04-03
#DATE OF LAST MODIFICATION:
#   2012-04-03
#FUNCTION OF STORED PROCEDURE:
#   returns number of row entries of  wanted datapoint_name in table data for wanted timeslot
#EXAMPLE:
#   CALL getNumberOfValues('tem1','2010-12-29 12:00:00', '2010-12-29 13:00:00');


    #check if given dates(time) are allowed
    IF (SELECT TIME_TO_SEC(TIMEDIFF(p_endtime, p_starttime))) < 0
    THEN
        CALL raiseError('endtime must be later than starttime!');
    ELSEIF (SELECT count(*) FROM datapoint WHERE datapoint_name=p_datapoint_name) = 0
    THEN
        CALL raiseError('datapoint_name does not exist in database!');
    ELSE
            SELECT count(*)  FROM data WHERE datapoint_name = p_datapoint_name AND timestamp BETWEEN p_starttime AND p_endtime;
    END IF;
    
END


$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getDatapointsInSubzones
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getDatapointsInSubzones`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getDatapointsInSubzones`(
                            IN  p_idzone        INT         ,
                            IN  p_sublevels     INT         
                            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2012-05-06
#DATE OF LAST MODIFICATION:
#   2012-05-30
#FUNCTION OF STORED PROCEDURE:
#   returns datapoints that are in a subzone till given sublevel of the given zone  (zone itself is also valid). SP getSubzones_Internal is called and table used by it is reused.
#   p_sublevels = NULL --> all subzones
#   p_sublevels = 0 --> only given zone (no subzones)
#EXAMPLE:
#   CALL getDatapointsInSubzones(10,3);
#   CALL getDatapointsInSubzones(10,NULL);
#ERROR: -30 -> 'Given zone not in database!'

    IF (SELECT DISTINCT idzone FROM zone WHERE idzone=p_idzone) IS NULL
    THEN
         CALL raiseWarning(-30, 'Given zone not in database!');
    ELSE
        #get subzones of given zone till given sublevel
        CALL getSubzones_internal(p_idzone, p_sublevels);
        SELECT * FROM datapoint WHERE zone_idzone IN (SELECT zone FROM zones_tmpSPsubzones);
    END IF;
    
END




$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getHeadzones
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getHeadzones`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getHeadzones`(
                                IN      p_username    VARCHAR(100)       
                            )
BEGIN#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-05-30
#DATE OF LAST MODIFICATION:
#   2012-06-29
#FUNCTION OF STORED PROCEDURE:
#   returns the highest zones for that the given user has any type of access right
#   if username is NULL: returns all zones that have no superzones (higher zones)
#EXAMPLE:
#   CALL getHeadzones('user1');
#ERROR:

    DECLARE lv_index                    INT;
    DECLARE lv_currentzone              INT;
    DECLARE lv_accessCurrentzone        BOOLEAN;
    DECLARE lv_accessSuperzones         BOOLEAN;
    
    IF p_username IS NULL
    THEN
        SELECT DISTINCT zone_high FROM zone_has_zone WHERE zone_high NOT IN (SELECT DISTINCT zone_low FROM zone_has_zone) ORDER BY zone_high;
    ELSE
        CREATE TEMPORARY TABLE IF NOT EXISTS tmp_SP_getHeadzonesPermissions (
                        `id`                INT NOT NULL AUTO_INCREMENT      ,
                        `zone`              INT NOT NULL                     ,
                        PRIMARY KEY(`id`)                                  
                 );
        TRUNCATE TABLE tmp_SP_getHeadzonesPermissions;
  
        CREATE TEMPORARY TABLE IF NOT EXISTS tmp_SP_getHeadzonesTmp (
                        `id`                INT NOT NULL AUTO_INCREMENT      ,
                        `zone`              INT NOT NULL                     ,
                        PRIMARY KEY(`id`)                                  
                 );
        TRUNCATE TABLE tmp_SP_getHeadzonesTmp;
                
        CREATE TEMPORARY TABLE IF NOT EXISTS tmp_SP_getHeadzonesHead (
                        `id`                INT NOT NULL AUTO_INCREMENT      ,
                        `zone`              INT NOT NULL                     ,
                        PRIMARY KEY(`id`)                                  
                 );
        TRUNCATE TABLE tmp_SP_getHeadzonesHead;
        
        #get all zones to which the given user has any type of access
        INSERT INTO tmp_SP_getHeadzonesPermissions
                                            (
                                                zone     
                                            )
        (SELECT DISTINCT idzone FROM role_zone_permissions WHERE role_id IN ( SELECT rid FROM user_role WHERE uid= (SELECT id FROM user WHERE name=p_username) ) );
 
        INSERT INTO tmp_SP_getHeadzonesTmp
                                    (
                                        zone     
                                    )
        (SELECT zone FROM tmp_SP_getHeadzonesPermissions);
        
        #if current zone has no superzones for which the given user has any type of access rights write it into the table tmp_SP_getHeadzonesHead
        #if current zone has superzones for which the given user has any type of access rights write it into the table zones_tmp
        #set current zone to next entry in table zones_tmp
        #do this till there is no further entry in table zones_tmp
        #restrict to 1000 subzones, need to detect inconsistency of table <zone_has_zone> (problem if 2 zones contain each other in 2 entries, must not be!)
        SET lv_index=1;
        SET lv_currentzone=
                    (SELECT zone FROM tmp_SP_getHeadzonesTmp WHERE id=lv_index);
                    
        WHILE lv_currentzone IS NOT NULL AND lv_index<1000000
        DO
          #for testing purpose
          #SELECT 'tag 1';
          
          IF (SELECT DISTINCT zone_low FROM zone_has_zone WHERE zone_low=lv_currentzone) IS NOT NULL
          THEN
          #for testing purpose
          #SELECT 'tag 2';
                #check if currentzone is subzone of a superzone for that the user has access rights
                #TODO: wrong, only next level superzone taken into account
                #TODO_PERFORMANCE: change if/else structure so that SP are not allways called
                CALL checkPermissionOfUserForSuperzone_Internal(p_username,lv_currentzone,'any',lv_accessSuperzones);
                IF lv_accessSuperzones IS TRUE 
                THEN
                    #current zone is not the headzone, so insert higher zones of current zone into table tmp_SP_getHeadzonesTmp
                    INSERT INTO tmp_SP_getHeadzonesTmp
                                        (
                                            zone
                                        )                 
                    (SELECT zone_high FROM zone_has_zone WHERE zone_low=lv_currentzone);
                ELSE
                    #TODO_PERFORMANCE: don't call SP, do SQL query to get lv_accessCurrentzone
                    CALL checkPermissionOfUserForZone_Internal(p_username,lv_currentzone,'any',lv_accessCurrentzone);
                    IF lv_accessCurrentzone IS TRUE 
                    THEN
                        #current zone is the headzone and has access rights, so add current zone to table tmp_SP_getHeadzonesHead
                        INSERT INTO tmp_SP_getHeadzonesHead
                             (
                                 zone
                             )
                        VALUES
                            (
                                lv_currentzone   
                            );
                    END IF;
                END IF;
          ELSE
          #for testing purpose
          #SELECT 'tag 3';
                    #TODO_PERFORMANCE: don't call SP, do SQL query to get lv_accessCurrentzone
                    CALL checkPermissionOfUserForZone_Internal(p_username,lv_currentzone,'any',lv_accessCurrentzone);
                    IF lv_accessCurrentzone IS TRUE 
                    THEN
                        #current zone is the headzone and has access rights, so add current zone to table tmp_SP_getHeadzonesHead
                        INSERT INTO tmp_SP_getHeadzonesHead
                             (
                                 zone
                             )
                        VALUES
                            (
                                lv_currentzone   
                            );
                    END IF;
          END IF;
          
          #set next entry in table zones_tmp to be checked by next interation
          SET lv_index=lv_index+1;
          
          #for testing purpose
          #SELECT 'tag 4';
          
          SET lv_currentzone=
                      (SELECT zone FROM tmp_SP_getHeadzonesTmp WHERE id=lv_index);
        END WHILE;

        IF lv_index>=1000000
        THEN 
            CALL raiseError('To many iterations, maybe inconsistent table <zone_has_zone> (or result too big!)');
        END IF;

        SELECT DISTINCT zone FROM tmp_SP_getHeadzonesHead ORDER BY zone;

    END IF;
END$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getZoneParameters
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getZoneParameters`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getZoneParameters`(
                            IN  p_idzone        INT                 
                            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-05-30
#DATE OF LAST MODIFICATION:
#   2012-05-30
#FUNCTION OF STORED PROCEDURE:
#   returns all parameters of a given zone (id)
#EXAMPLE:
#   CALL getZoneParameters(10);
#ERROR: -30 -> 'Given zone not in database!'

    IF (SELECT DISTINCT idzone FROM zone WHERE idzone=p_idzone) IS NULL
    THEN
         CALL raiseWarning(-30, 'Given zone not in database!');
    ELSE
        SELECT * FROM zone WHERE idzone=p_idzone;
    END IF;
    
END






$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getZoneParametersSearch
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getZoneParametersSearch`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getZoneParametersSearch`(
                            IN  p_parameter        varchar(45)          ,  
                            IN  p_value            varchar(45)                       
                            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2011-05-30
#DATE OF LAST MODIFICATION:
#   2012-05-31
#FUNCTION OF STORED PROCEDURE:
#   returns all parameters of zones if the wanted parameter contains the given value (mostly strings)
#   p_parameter=NULL --> all parameters (columns) searched
#EXAMPLE:
#   CALL getZoneParametersSearch('name','name1');
#   CALL getZoneParametersSearch(NULL,'str');
#ERROR: 


    DECLARE stmt_expr VARCHAR(128); 
    
    #TODO: test performance of large tables, because regexp may be slow
    #NULL --> all columns searched, otherwise only given (p_parameter) column searched
    IF p_parameter IS NULL
    THEN
        SET @stmt_expr = CONCAT('SELECT * FROM zone WHERE name regexp ''',p_value,''' OR 
                                                          description regexp ''',p_value,''' OR
                                                          country regexp ''',p_value,''' OR
                                                          state regexp ''',p_value,''' OR
                                                          county regexp ''',p_value,''' OR
                                                          city regexp ''',p_value,''' OR
                                                          floor regexp ''',p_value,''' OR
                                                          room regexp ''',p_value,''' OR
                                                          area regexp ''',p_value,''' OR
                                                          volume regexp ''',p_value,''';'
                                                          );
    ELSE
        SET @stmt_expr = CONCAT('SELECT * FROM zone WHERE ',p_parameter,' regexp ''',p_value,''';' );
    END IF;
    
    #for testing purpose
    #SELECT @stmt_expr;
    
    PREPARE stmt FROM @stmt_expr;
    EXECUTE stmt;
    
END





$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure checkPermissionOfUserForZone
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`checkPermissionOfUserForZone`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`checkPermissionOfUserForZone` (
                        IN p_user                       VARCHAR(100)           ,
                        IN p_zone                       INT                    ,
                        IN p_permissionType             ENUM('read'     ,
                                                             'write'    ,
                                                             'admin'    ,
                                                             'any'      
                                                            )      
                        )
foo:BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#    BRAEUER R.
#DATE OF CREATION:
#   2012-06-07
#DATE OF LAST MODIFICATION:
#   2012-06-29
#FUNCTION OF STORED PROCEDURE:
#   this function returns a boolean value of if a user has the given access to a zone by calling SP checkPermissionOfUserForZone_Internal
#EXAMPLE:
#   CALL checkPermissionOfUserForZone('user1',10,'read');
#   CALL checkPermissionOfUserForZone('user1',10,write');
#ERROR: -23 -> 'Given zone not in database!'
#       -21 -> 'Given user not in database!'
#       -22 -> 'Wrong permission type given, only ''read'', ''write'', ''admin'' or ''any'' allowed!'

    DECLARE lv_result   BOOLEAN;
    
    CALL checkPermissionOfUserForZone_Internal(p_user, p_zone, p_permissionType, lv_result);
    
    SELECT lv_result;
   
END





$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getSuperzones_Internal
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getSuperzones_Internal`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getSuperzones_Internal`(
                            IN  p_idzone        INT             ,
                            IN  p_superlevels     INT       
                            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2012-06-12
#DATE OF LAST MODIFICATION:
#   2012-09-05
#FUNCTION OF STORED PROCEDURE:
#   calculates  superzones (higher zones) which are contained in a given number of superlevels (higher levels) of a zone (zone itself is also written into table!)
#   p_superlevels = NULL --> return all superzones
#EXAMPLE:
#   CALL getSuperzones_Internal(1,3);
#   CALL getSuperzones_Internal(1,NULL);
#ERROR:
#   -30 -> 'Given zone not in database!'

    DECLARE lv_index                        INT;
    DECLARE lv_currentzone                  INT;
    DECLARE lv_currentSuperlevel            INT;
    DECLARE lv_indexCurrentSuperlevelMax    INT;
    
    CREATE TEMPORARY TABLE IF NOT EXISTS zones_tmpSPsuperzones (
                        `ID` INT NOT NULL AUTO_INCREMENT        ,
                        `zone` INT                              ,
                        `superlevel` INT                          ,
                        PRIMARY KEY(`ID`)                       
                        );
    TRUNCATE TABLE zones_tmpSPsuperzones;
        
    IF (SELECT DISTINCT idzone FROM zone WHERE idzone=p_idzone) IS NULL
    THEN
         CALL raiseWarning(-30,'Given zone not in database!');
    ELSE
        
        SET lv_index=1;
        SET lv_currentSuperlevel=0;
        SET lv_indexCurrentSuperlevelMax=1;
        

        INSERT INTO zones_tmpSPsuperzones 
                    (
                     zone       ,
                     superlevel   
                     ) 
        VALUES  (
                    p_idzone            ,
                    lv_currentSuperlevel           
                );
        
        SET lv_currentzone=p_idzone;

        
        #if all superzones shall be returned set p_superlevels to max number of superzones
        IF p_superlevels IS NULL
        THEN
            SET p_superlevels = 1000;
        END IF;
        
        #if current zone has superzones write them into the table zones_tmpSPsuperzones
        #set current zone to next entry in table zones_tmpSPsuperzones
        #do this till the maximum number of superlevels (p_superlevels) is reached or till there is no further entry in table zones_tmpSPsuperzones
        #restrict to 1000 superlevels, need to detect inconsistency of table <zone_has_zone> (problem if 2 zones contain each other in 2 entries, must not be!)
        WHILE lv_currentzone IS NOT NULL AND lv_currentSuperlevel < p_superlevels
        DO
          IF (SELECT DISTINCT zone_low FROM zone_has_zone WHERE zone_low=lv_currentzone) IS NOT NULL
          THEN
              #insert superzones of current zone into table zones_tmpSPsuperzones
              INSERT INTO zones_tmpSPsuperzones 
                          (zone)
              (SELECT zone_high FROM zone_has_zone WHERE zone_low=lv_currentzone);
              #if last entry of current superlevel is reached write current superlevel into table zones_tmpSPsuperzones and get index where current superlevel ends
              IF lv_index >= lv_indexCurrentSuperlevelMax
              THEN
                    SET lv_indexCurrentSuperlevelMax = 
                        (SELECT MAX(ID) FROM zones_tmpSPsuperzones);
                    SET lv_currentSuperlevel=lv_currentSuperlevel+1;
                    UPDATE zones_tmpSPsuperzones SET superlevel=lv_currentSuperlevel WHERE superlevel IS NULL;
              END IF;
       
          END IF;
          #set next entry in table zones_tmpSPsuperzones to be checked by next interation
          SET lv_index=lv_index+1;
          SET lv_currentzone=
                      (SELECT zone FROM zones_tmpSPsuperzones WHERE ID=lv_index);

        END WHILE;
        
        IF lv_currentSuperlevel>=1000
        THEN 
            CALL raiseError('To many superzone levels returned (max number is 1000) or inconsistent table <zone_has_zone>');
        END IF;
        
    END IF;
    
END







$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getSuperzones
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getSuperzones`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getSuperzones`(
                            IN  p_idzone        INT     ,
                            IN  p_superlevels     INT                         
                            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2012-06-12
#DATE OF LAST MODIFICATION:
#   2012-07-31
#FUNCTION OF STORED PROCEDURE:
#   returns superzones which are contained in a given number of superlevels of a zone (zone itself is NOT returned!) by calling SP getSuperzones_Internal and reading table used by it
#   p_superlevels = NULL --> return all superzones
#EXAMPLE:
#   CALL getSuperzones(1,3);
#   CALL getSuperzones(1,NULL);
#ERROR: -30 -> 'Given zone not in database!'

    IF (SELECT DISTINCT idzone FROM zone WHERE idzone=p_idzone) IS NULL
    THEN
         CALL raiseWarning(-30, 'Given zone not in database!');
    ELSE
        CALL getSuperzones_internal(p_idzone,p_superlevels);
        SELECT DISTINCT zone FROM zones_tmpSPsuperzones WHERE ID > 1 ORDER BY zone;
    END IF;
    
END










$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure checkPermissionOfUserForZone_Internal
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`checkPermissionOfUserForZone_Internal`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`checkPermissionOfUserForZone_Internal` (
                        IN p_user                       VARCHAR(100)           ,
                        IN p_zone                       INT                    ,
                        IN p_permissionType             ENUM('read'     ,
                                                             'write'    ,
                                                             'admin'    ,
                                                             'any'      
                                                            )                   ,
                        OUT p_result                     BOOLEAN                
                        )
foo:BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#    BRAEUER R.
#DATE OF CREATION:
#   2012-06-27
#DATE OF LAST MODIFICATION:
#   2012-06-29
#FUNCTION OF STORED PROCEDURE:
#   this function returns a boolean value as OUT variable of if a user has the given access to a zone
#EXAMPLE:
#   CALL checkPermissionOfUserForZone_Internal('user1',10,'read',out);
#   CALL checkPermissionOfUserForZone_Internal('user1',10,write',out);
#ERROR: -23 -> 'Given zone not in database!'
#       -21 -> 'Given user not in database!'
#       -22 -> 'Wrong permission type given, only ''read'', ''write'', ''admin'' or ''any'' allowed!'

    DECLARE lv_index        INT;
    DECLARE lv_indexMax     INT;
    DECLARE lv_currentzone  INT;
    
    
    IF (SELECT DISTINCT idzone FROM zone WHERE idzone=p_zone) IS NULL
    THEN
         CALL raiseWarning(-23, 'Given zone not in database!');
    ELSEIF (SELECT DISTINCT id FROM user WHERE name=p_user) IS NULL
    THEN
         CALL raiseWarning(-21, 'Given user not in database!');
    ELSE
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_SP_checkPermissionOfUserForZone (
                        `id`                INT NOT NULL AUTO_INCREMENT      ,
                        `idzone`            INT NOT NULL                     ,
                        PRIMARY KEY(`id`)                                  
                 );
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_SP_checkPermissionOfUserForZoneSuperzones (
                        `id`                INT NOT NULL AUTO_INCREMENT      ,
                        `idzone`            INT NOT NULL                     ,
                        PRIMARY KEY(`id`)                                  
                 );
    TRUNCATE TABLE tmp_SP_checkPermissionOfUserForZone;
    TRUNCATE TABLE tmp_SP_checkPermissionOfUserForZoneSuperzones;
    
    CASE p_permissionType
        WHEN    'read'
        THEN    
            INSERT INTO tmp_SP_checkPermissionOfUserForZone
                    (
                        idzone     
                    )
            SELECT DISTINCT idzone FROM role_zone_permissions WHERE role_id IN ( SELECT rid FROM user_role WHERE uid= (SELECT id FROM user WHERE name=p_user) ) AND `read` IS TRUE;
        WHEN    'write'
        THEN    
            INSERT INTO tmp_SP_checkPermissionOfUserForZone
                    (
                        idzone     
                    )
            SELECT DISTINCT idzone FROM role_zone_permissions WHERE role_id IN ( SELECT rid FROM user_role WHERE uid= (SELECT id FROM user WHERE name=p_user) ) AND `write` IS TRUE;
        WHEN    'admin'
        THEN    
            INSERT INTO tmp_SP_checkPermissionOfUserForZone
                    (
                        idzone     
                    )
            SELECT DISTINCT idzone FROM role_zone_permissions WHERE role_id IN ( SELECT rid FROM user_role WHERE uid= (SELECT id FROM user WHERE name=p_user) ) AND `admin` IS TRUE;
        WHEN    'any'
        THEN    
            INSERT INTO tmp_SP_checkPermissionOfUserForZone
                    (
                        idzone   
                    )
            SELECT DISTINCT idzone FROM role_zone_permissions WHERE role_id IN ( SELECT rid FROM user_role WHERE uid= (SELECT id FROM user WHERE name=p_user) ) IS TRUE;
        ELSE
            CALL raiseWarning(-22, 'Wrong permission type given, only ''read'', ''write'' ''admin'' or ''any'' allowed!');
            LEAVE foo;
        END CASE;
    
        #for testing purpose only!
        #SELECT @lv_tmpStr;
        #SELECT * FROM tmp_SP_checkPermissionOfUserForZone;
        
        CALL getSuperzones_Internal(p_zone,NULL);
        
        INSERT INTO tmp_SP_checkPermissionOfUserForZoneSuperzones
                (
                    idzone
                )
        SELECT DISTINCT zone FROM zones_tmpSPsuperzones;
        
        #TODO: find better (easier) solution :-)
        IF ( (SELECT count(*) FROM tmp_SP_checkPermissionOfUserForZone A INNER JOIN tmp_SP_checkPermissionOfUserForZoneSuperzones B ON A.idzone=B.idzone) != 0)
        THEN
            SET p_result = TRUE;
        ELSE
            SET p_result = FALSE;
        END IF;
   
    END IF;
END











$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure checkPermissionOfUserForSuperzone_Internal
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`checkPermissionOfUserForSuperzone_Internal`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`checkPermissionOfUserForSuperzone_Internal` (
                        IN p_user                       VARCHAR(100)           ,
                        IN p_zone                       INT                    ,
                        IN p_permissionType             ENUM('read'     ,
                                                             'write'    ,
                                                             'admin'    ,
                                                             'any'      
                                                            )                   ,
                        OUT p_result                    BOOLEAN                
                        )
foo:BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#    BRAEUER R.
#DATE OF CREATION:
#   2012-06-29
#DATE OF LAST MODIFICATION:
#   2012-06-29
#FUNCTION OF STORED PROCEDURE:
#   this function returns a boolean value as OUT variable of if a user has the given access to a superzone of the given zone
#   needed for SP getHeadzones, equivalent to checkPermissionOfUserForZone except that the given zone itself is not copied from the table zones_tmpSPsuperzones.
#   TODO: find better design way to do this than whole new SP :-)
#EXAMPLE:
#   CALL checkPermissionOfUserForSuperzone_Internal('user1',10,'read',out);
#   CALL checkPermissionOfUserForSuperzone_Internal('user1',10,write',out);
#ERROR: -23 -> 'Given zone not in database!'
#       -21 -> 'Given user not in database!'
#       -22 -> 'Wrong permission type given, only ''read'', ''write'', ''admin'' or ''any'' allowed!'

    DECLARE lv_index        INT;
    DECLARE lv_indexMax     INT;
    DECLARE lv_currentzone  INT;
    
    
    IF (SELECT DISTINCT idzone FROM zone WHERE idzone=p_zone) IS NULL
    THEN
         CALL raiseWarning(-23, 'Given zone not in database!');
    ELSEIF (SELECT DISTINCT id FROM user WHERE name=p_user) IS NULL
    THEN
         CALL raiseWarning(-21, 'Given user not in database!');
    ELSE
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_SP_checkPermissionOfUserForSuperzone (
                        `id`                INT NOT NULL AUTO_INCREMENT      ,
                        `idzone`            INT NOT NULL                     ,
                        PRIMARY KEY(`id`)                                  
                 );
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_SP_checkPermissionOfUserForSuperzoneSuperzones (
                        `id`                INT NOT NULL AUTO_INCREMENT      ,
                        `idzone`            INT NOT NULL                     ,
                        PRIMARY KEY(`id`)                                  
                 );
    TRUNCATE TABLE tmp_SP_checkPermissionOfUserForSuperzone;
    TRUNCATE TABLE tmp_SP_checkPermissionOfUserForSuperzoneSuperzones;
    
    CASE p_permissionType
        WHEN    'read'
        THEN    
            INSERT INTO tmp_SP_checkPermissionOfUserForSuperzone
                    (
                        idzone     
                    )
            SELECT DISTINCT idzone FROM role_zone_permissions WHERE role_id IN ( SELECT rid FROM user_role WHERE uid= (SELECT id FROM user WHERE name=p_user) ) AND `read` IS TRUE;
        WHEN    'write'
        THEN    
            INSERT INTO tmp_SP_checkPermissionOfUserForSuperzone
                    (
                        idzone     
                    )
            SELECT DISTINCT idzone FROM role_zone_permissions WHERE role_id IN ( SELECT rid FROM user_role WHERE uid= (SELECT id FROM user WHERE name=p_user) ) AND `write` IS TRUE;
        WHEN    'admin'
        THEN    
            INSERT INTO tmp_SP_checkPermissionOfUserForSuperzone
                    (
                        idzone     
                    )
            SELECT DISTINCT idzone FROM role_zone_permissions WHERE role_id IN ( SELECT rid FROM user_role WHERE uid= (SELECT id FROM user WHERE name=p_user) ) AND `admin` IS TRUE;
        WHEN    'any'
        THEN    
            INSERT INTO tmp_SP_checkPermissionOfUserForSuperzone
                    (
                        idzone   
                    )
            SELECT DISTINCT idzone FROM role_zone_permissions WHERE role_id IN ( SELECT rid FROM user_role WHERE uid= (SELECT id FROM user WHERE name=p_user) ) IS TRUE;
        ELSE
            CALL raiseWarning(-22, 'Wrong permission type given, only ''read'', ''write'' ''admin'' or ''any'' allowed!');
            LEAVE foo;
        END CASE;
    
        #for testing purpose only!
        #SELECT @lv_tmpStr;
        #SELECT * FROM tmp_SP_checkPermissionOfUserForSuperzone;
        
        CALL getSuperzones_Internal(p_zone,NULL);
        
        INSERT INTO tmp_SP_checkPermissionOfUserForSuperzoneSuperzones
                (
                    idzone
                )
                # only difference to SP checkPermissionOfUserForSuperzone: WHERE ID > 1
        SELECT DISTINCT zone FROM zones_tmpSPsuperzones WHERE ID > 1;
        
        #TODO: find better (easier) solution :-)
        IF ( (SELECT count(*) FROM tmp_SP_checkPermissionOfUserForSuperzone A INNER JOIN tmp_SP_checkPermissionOfUserForSuperzoneSuperzones B ON A.idzone=B.idzone) != 0)
        THEN
            SET p_result = TRUE;
        ELSE
            SET p_result = FALSE;
        END IF;
   
    END IF;
END


$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getConnection
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getConnection`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getConnection`(
                                IN  p_datapoint_name          VARCHAR(100)  ,
                                IN  p_device_name             VARCHAR(100)  ,
                                IN  p_connection_type         VARCHAR(100)  ,
                                IN  p_zone                    INT           ,
                                IN  p_connector_id            VARCHAR(100)  
                               )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#   ZACH R.
#DATE OF CREATION:
#   2011-10-05 (don't think so :-), have to ask Robert :-) )
#DATE OF LAST MODIFICATION:
#   2012-10-23
#FUNCTION OF STORED PROCEDURE:
#   returns connections inkl. datapoint and device definition, order because then the order in matlab will be correct (else problem e.g. con1, con10, con11, ..., con2, con20)
#EXAMPLES:
#   CALL getConnection( NULL, NULL, NULL, NULL, NULL);
#   CALL getConnection('tem2', NULL, NULL, NULL, NULL);
#   CALL getConnection('tem%', NULL, NULL, NULL, NULL);

# TODO implement further combinations, e.g. CALL getConnection( NULL, 'device10', NULL, NULL, NULL);  or CALL getConnection( NULL, NULL, 'opc-da', NULL, NULL); or CALL getConnection( NULL, NULL, NULL, NULL, 'connector_id_10');
    
    IF p_datapoint_name IS NULL
    THEN
        SELECT * FROM datapoint LEFT JOIN connections ON (datapoint.datapoint_name = connections.datapoint_name) ORDER BY ABS(datapoint.datapoint_name);
    ELSE
        SELECT * FROM datapoint LEFT JOIN connections ON (datapoint.datapoint_name = connections.datapoint_name) WHERE datapoint.datapoint_name LIKE p_datapoint_name ORDER BY ABS(datapoint.datapoint_name);
    END IF;
    
END


$$

DELIMITER ;
-- -----------------------------------------------------
-- procedure getDatabaseInfo
-- -----------------------------------------------------

USE `mon_development`;
DROP procedure IF EXISTS `mon_development`.`getDatabaseInfo`;

DELIMITER $$
USE `mon_development`$$
CREATE PROCEDURE `mon_development`.`getDatabaseInfo`(                
                            )
BEGIN
#INFO:
#   This file is part of MOST (Monitoring System Toolkit - most.bpi.tuwien.ac.at).
#LICENSE:
#   Creative Commons Attribution-ShareAlike 3.0 Unported License. For detailed information see license.txt or license.rtf
#CONTACT:
#   most@tuwien.ac.at
#AUTHOR:
#   BRAEUER R.
#DATE OF CREATION:
#   2012-08-07
#DATE OF LAST MODIFICATION:
#   2012-12-02
#FUNCTION OF STORED PROCEDURE:
#   returns infos about the database
#EXAMPLE:
#   CALL getDatabaseInfo()
#ERROR:
#   -1230 -> 'Testerror 1'
#   -1231 -> 'Testerror 2'
#   -1232 -> 'Testerror 3'
#EOH
#SVN:
#   ID:       $Id$
#   Revision: $Revision$
#   Revision: $Date$
#   Head:     $Head$

    DECLARE lv_databaseName                         VARCHAR(100);
    DECLARE lv_id                                   INT;
    DECLARE lv_idMax                                INT;
    DECLARE lv_routineName                          VARCHAR(100);
    DECLARE lv_tagDateOfLastModification            VARCHAR(100);
    DECLARE lv_tagDateOfCreation                    VARCHAR(100);
    DECLARE lv_tagFunctionOfStoredProcedure         VARCHAR(100);
    DECLARE lv_tagEoh                               VARCHAR(100);
    DECLARE lv_tagError                             VARCHAR(100);
    DECLARE lv_tagLength                            INT;
    DECLARE lv_errorDescription                     VARCHAR(100);
    DECLARE lv_svnRevision                          VARCHAR(100);
    DECLARE lv_svnId                                VARCHAR(100);
    DECLARE lv_svnDate                              VARCHAR(100);
    
    SET lv_databaseName =
                (SELECT database() );
    
    # svn keyword substitution used :-) (so that the svn generated string is used value is use)
    # for testing purpose
    
    PREPARE stmt_SetSvnId FROM 'SET @getDatabaseInfo_svnId = ''$Id$'';';
    PREPARE stmt_SetSvnRevision FROM 'SET @getDatabaseInfo_svnRevision = ''$Revision$'';';
    PREPARE stmt_SetSvnDate FROM 'SET @getDatabaseInfo_svnDate = ''$Date$'';';
    PREPARE stmt_SetSvnDate FROM 'SET @getDatabaseInfo_svnHead = ''$Head$'';';
    
    EXECUTE stmt_SetSvnId;
    EXECUTE stmt_SetSvnRevision;
    EXECUTE stmt_SetSvnDate;
    EXECUTE stmt_SetSvnHead;
    
    SELECT @getDatabaseInfo_svnId;
    SELECT @getDatabaseInfo_svnRevision;
    SELECT @getDatabaseInfo_svnDate;
    SELECT @getDatabaseInfo_svnHead;
    
    #MySQL server version
    #SELECT version();
    
    SELECT TABLE_NAME, CREATE_TIME, UPDATE_TIME FROM INFORMATION_SCHEMA.TABLES WHERE table_schema = lv_databaseName;
          
    CREATE TEMPORARY TABLE IF NOT EXISTS routines_tmpSPgetDatabaseInfo(
            ID                          INT AUTO_INCREMENT      ,
            ROUTINE_NAME                VARCHAR(100)            ,
            ROUTINE_TYPE                VARCHAR(100)            ,
            CREATED                     VARCHAR(100)            ,
            LAST_ALTERED                VARCHAR(100)            ,
            DATE_OF_CREATION            VARCHAR(100)            ,
            DATE_OF_LAST_MODIFICATION   VARCHAR(100)            ,
            PRIMARY KEY(`ID`)  
        );
    TRUNCATE TABLE routines_tmpSPgetDatabaseInfo;
    
    CREATE TEMPORARY TABLE IF NOT EXISTS errors_tmpSPgetDatabaseInfo(
            ID                          INT AUTO_INCREMENT      ,
            ERROR_NUMBER                INT                     ,
            ERROR_DESCRIPTION           VARCHAR(100)            ,
            ROUTINE_NAME                VARCHAR(100)            ,
            PRIMARY KEY(`ID`)  
        );
    TRUNCATE TABLE errors_tmpSPgetDatabaseInfo;
    
    #insert some parameters of all routines for current database into table routines_tmpSPgetDatabaseInfo
    INSERT INTO routines_tmpSPgetDatabaseInfo
        (
            ROUTINE_NAME         ,
            ROUTINE_TYPE         ,
            CREATED              ,
            LAST_ALTERED         
        )
    SELECT ROUTINE_NAME, ROUTINE_TYPE, CREATED, LAST_ALTERED FROM INFORMATION_SCHEMA.ROUTINES WHERE routine_schema = lv_databaseName;
    
    SET lv_id = 1;
    SET lv_idMax = 
            (SELECT MAX(ID) FROM routines_tmpSPgetDatabaseInfo);
    #iterate over all routines of current database and get further infos directly from the sourcecode of the routines
    WHILE lv_id  <= lv_idMax
    DO
        #get routine name of current row
        SET lv_routineName = 
                    (SELECT ROUTINE_NAME FROM routines_tmpSPgetDatabaseInfo WHERE ID=lv_id);
        
        #get positions of tags in sourcecode of routines
        SET lv_tagDateOfLastModification = 
                    (SELECT LOCATE ("#DATE OF LAST MODIFICATION:",
                                    (SELECT ROUTINE_DEFINITION FROM INFORMATION_SCHEMA.ROUTINES WHERE routine_schema = lv_databaseName AND ROUTINE_NAME = lv_routineName)
                                   )
                    );
        SET lv_tagDateOfCreation = 
                    (SELECT LOCATE ("#DATE OF CREATION:",
                                    (SELECT ROUTINE_DEFINITION FROM INFORMATION_SCHEMA.ROUTINES WHERE routine_schema = lv_databaseName AND ROUTINE_NAME = lv_routineName)
                                   )
                    );
        SET lv_tagFunctionOfStoredProcedure = 
                    (SELECT LOCATE ("#FUNCTION OF STORED PROCEDURE:",
                                    (SELECT ROUTINE_DEFINITION FROM INFORMATION_SCHEMA.ROUTINES WHERE routine_schema = lv_databaseName AND ROUTINE_NAME = lv_routineName)
                                   )
                    );
        SET lv_tagError = 
                    (SELECT LOCATE ("#ERROR",
                                    (SELECT ROUTINE_DEFINITION FROM INFORMATION_SCHEMA.ROUTINES WHERE routine_schema = lv_databaseName AND ROUTINE_NAME = lv_routineName)
                                   )
                    );                   
        SET lv_tagEoh = 
                    (SELECT LOCATE ("#EOH",
                                    (SELECT ROUTINE_DEFINITION FROM INFORMATION_SCHEMA.ROUTINES WHERE routine_schema = lv_databaseName AND ROUTINE_NAME = lv_routineName)
                                   )
                    );             
                    
        #get routine infos directly from routine sourcecode
        #get tag #DATE OF CREATION: from routine sourcecode header
        SET lv_tagLength = lv_tagDateOfLastModification - (lv_tagDateOfCreation + 24);
        UPDATE routines_tmpSPgetDatabaseInfo SET DATE_OF_CREATION = 
                                                            (SELECT MID( (SELECT ROUTINE_DEFINITION FROM INFORMATION_SCHEMA.ROUTINES WHERE routine_schema = lv_databaseName AND ROUTINE_NAME = lv_routineName),
                                                                         lv_tagDateOfCreation + 23,
                                                                         lv_tagLength
                                                                       )
                                                            ) WHERE ID=lv_id;
        #get tag #DATE OF LAST MODIFICATION: from routine sourcecode header
        SET lv_tagLength = lv_tagFunctionOfStoredProcedure - (lv_tagDateOfLastModification + 33);
        UPDATE routines_tmpSPgetDatabaseInfo SET DATE_OF_LAST_MODIFICATION = 
                                                            (SELECT MID( (SELECT ROUTINE_DEFINITION FROM INFORMATION_SCHEMA.ROUTINES WHERE routine_schema = lv_databaseName AND ROUTINE_NAME = lv_routineName),
                                                                         lv_tagDateOfLastModification + 32,
                                                                         lv_tagLength
                                                                       )
                                                        ) WHERE ID=lv_id;
        
        
        
        #get tag #ERROR: from routine sourcecode header
        SET lv_tagLength = lv_tagEoh - (lv_tagError + 12);
        SET lv_errorDescription =
                (SELECT MID( (SELECT ROUTINE_DEFINITION FROM INFORMATION_SCHEMA.ROUTINES WHERE routine_schema = lv_databaseName AND ROUTINE_NAME = lv_routineName),
                                                                         lv_tagError + 11,
                                                                         lv_tagLength
                           )
                );
                                                                                
        INSERT INTO errors_tmpSPgetDatabaseInfo 
            (
                ERROR_DESCRIPTION       ,
                ROUTINE_NAME
            )
        VALUES
            (
                lv_errorDescription     ,
                lv_routineName          
            );
                
#increment lv_id to get infos for next routine
        SET lv_id = lv_id + 1;
    END WHILE;
    
    SELECT * FROM routines_tmpSPgetDatabaseInfo;
    SELECT * FROM errors_tmpSPgetDatabaseInfo;
END

$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;