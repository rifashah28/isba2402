#### SQL query tips

#this is a comment
-- this is a comment
/*this
is
a
comment*/

SELECT NOW();
#not matter if broke into lines
SELECT
NOW();

SHOW databases;

#####CREATE DATABASE

CREATE DATABASE Demo; 
#check the action output

CREATE SCHEMA Demo;
# see the error msg

CREATE DATABASE IF NOT EXISTS Demo;

DROP DATABASE Demo;


##### create table

USE Demo;

CREATE TABLE if not exists Customer(
	CustomerID 	int 		primary key,
	Customer_Name 	varchar(20) not null 	unique,
	Status 		varchar(20) not null
);
CREATE TABLE if not exists Billing(
	InvoiceNo 		int 		primary key,
	CustomerID 	int 	not null,
	Amount 		int 	not null,
	foreign key CustomerID_fk(customerID) 
		references Customer(customerID)
		on update cascade
		on delete cascade
);


INSERT INTO Customer(CustomerID, Customer_Name, Status)
VALUES (1, 'Google', 'Active');

INSERT INTO Customer
VALUES (2, 'Amazon', 'Active');