use sakila;

CREATE TABLE employees (
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `officeCode` varchar(10) NOT NULL,
  `reportsTo` int(11) DEFAULT NULL,
  `jobTitle` varchar(50) NOT NULL,
  PRIMARY KEY (`employeeNumber`)
);

insert  into `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) values 

(1002,'Murphy','Diane','x5800','dmurphy@classicmodelcars.com','1',NULL,'President'),

(1056,'Patterson','Mary','x4611','mpatterso@classicmodelcars.com','1',1002,'VP Sales'),

(1076,'Firrelli','Jeff','x9273','jfirrelli@classicmodelcars.com','1',1002,'VP Marketing');

CREATE TABLE employees_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employeeNumber INT NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    changedat DATETIME DEFAULT NULL,
    action VARCHAR(50) DEFAULT NULL
);

DELIMITER $$
CREATE TRIGGER before_employee_update 
    BEFORE UPDATE ON employees
    FOR EACH ROW 
BEGIN
    INSERT INTO employees_audit
    SET action = 'update',
     employeeNumber = OLD.employeeNumber,
        lastname = OLD.lastname,
        changedat = NOW(); 
END$$
DELIMITER ;

UPDATE employees 
SET 
    lastName = 'Phan'
WHERE
    employeeNumber = 1056;
    
SELECT 
    *
FROM
    employees_audit;

#1- Insert a new employee to , but with an null email. Explain what happens.
insert  into `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) values
(1111,'Parker','Peter','6321',NULL,'1',1002,'Spiderman');

#I can't insert an employee without an email because it's a NOT NULL field.

#2- Run the first the query

UPDATE employees SET employeeNumber = employeeNumber - 20;
# 20 is subtracted  from employeeNumber value

UPDATE employees SET employeeNumber = employeeNumber + 20;
#SQL Error [1062] [23000]: Duplicate entry '1056' for key 'employees.PRIMARY'

#3- Add a age column to the table employee where and it can only accept values from 16 up to 70 years old.
alter table employees
	add age int check(age >= 16 and age <= 70);
	
#4- Describe the referential integrity between tables film, actor and film_actor in sakila db.

#The film_actor table works as a many to many between the tables film and actor.

#5- Create a new column called lastUpdate to table employee and use trigger(s) to keep the date-time updated on inserts and updates operations.
#Bonus: add a column lastUpdateUser and the respective trigger(s) to specify who was the last MySQL user that changed the row
#(assume multiple users, other than root, can connect to MySQL and change this table).

alter table employees
	add lastUpdate datetime;

ALTER TABLE employees 
	ADD COLUMN lastUpdateUser VARCHAR(255);

DELIMITER $$
CREATE Trigger before_employee_update BEFORE UPDATE ON employees FOR EACH ROW
BEGIN
SET NEW.lastUpdate = CURRENT_TIMESTAMP;
SET NEW.lastUpdateUser = CURRENT_USER;
END$$
DELIMITER;

#6 Find all the triggers in sakila db related to loading film_text table. 
#What do they do? Explain each of them using its source code for the explanation.

-- sakila.film_text definition
CREATE TABLE `film_text` (
  `film_id` smallint(6) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  PRIMARY KEY (`film_id`),
  FULLTEXT KEY `idx_title_description` (`title`,`description`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*triggers: */
CREATE DEFINER=`user`@`%` TRIGGER `ins_film` AFTER INSERT ON `film` FOR EACH ROW BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
  END
/*cuando se agrega una film se agrega tambien en sakila.film_tex */

CREATE DEFINER=`user`@`%` TRIGGER `upd_film` AFTER UPDATE ON `film` FOR EACH ROW BEGIN
    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
  END
/*cuando se actualiza una film se actualiza tambien en sakila.film_tex*/

CREATE DEFINER=`user`@`%` TRIGGER `del_film` AFTER DELETE ON `film` FOR EACH ROW BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
  END
/*cuando se elimina una film se elimina tambien en sakila.film_tex*/

	