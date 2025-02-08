-- Week 2
USE Demo;

-- DDL

-- change table definitions

# add a new column
ALTER TABLE Customer
ADD Contact varchar(40) DEFAULT NULL;

# drop a column
ALTER TABLE Customer
DROP COLUMN Contact;

# drop a key
ALTER TABLE Customer
DROP PRIMARY KEY;

ALTER TABLE Billing
DROP PRIMARY KEY;



-- Create a table with AUTO_INCREMENT
#DROP TABLE animals;

CREATE TABLE if not exists animals (
	id INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(30) NOT NULL,
	PRIMARY KEY (id)
);

INSERT INTO animals (name) 
VALUES ('dog'),('cat'),('penguin'),('lax'),('whale'),('ostrich');

# reset the values of auto-increment
INSERT INTO animals (id,name) VALUES(100,'rabbit');
INSERT INTO animals (id,name) VALUES(NULL,'mouse');
ALTER TABLE animals AUTO_INCREMENT = 200;
INSERT INTO animals (name) VALUES ('racoon'),('bear');




-- SELECT STATEMENT, using MAIL.sql
SELECT * FROM mail;
SELECT t, srcuser, size FROM mail; 

# using where for conditions
SELECT * FROM MAIL
WHERE size < 5000; 

SELECT * FROM MAIL
WHERE srchost =  'mars';

SELECT * FROM MAIL
WHERE t > '2014-05-16';

# pattern matches
SELECT * FROM MAIL
WHERE dsthost LIKE 's%';

SELECT * FROM MAIL
WHERE dsthost LIKE '%s';

SELECT * FROM MAIL
WHERE dsthost LIKE '%n%';

# multiple conditions
#on the same column
SELECT * FROM MAIL
WHERE size > 5000 AND size < 10000;
# same as 
#WHERE size between 5000 and 10000;

# on different columns
SELECT * FROM MAIL
WHERE size < 5000 or srchost = 'saturn'; #vs AND

#IN or NOT IN
SELECT * FROM MAIL
WHERE srcuser IN ('barb', 'gene');
#same as following
SELECT * FROM MAIL
WHERE srcuser = 'barb' OR srcuser = 'gene';

-- Creating New Columns
SELECT t, size, CONCAT(srcuser,'@', srchost)
FROM mail;

# Creating New Columns with alias
SELECT t, size, CONCAT(srcuser,'@', srchost) AS sender
FROM mail;

SELECT t, size/1024 AS kilobytes
FROM mail;

-- DISTINC VALUES
SELECT srcuser FROM mail;
SELECT DISTINCT srcuser FROM mail;

-- Work with Null Values
SELECT * FROM mail
WHERE size = NULL; ## not working

SELECT * FROM mail
WHERE size IS NULL;

SELECT * FROM mail
WHERE size IS NOT NULL;


-- COUNT ROWS
SELECT COUNT(*) FROM mail;
#comparison
SELECT COUNT(size) FROM mail;

#adding conditions
SELECT COUNT(*) FROM mail
WHERE dsthost = 'venus';

#Count distinct values
SELECT COUNT(DISTINCT srcuser) FROM mail;