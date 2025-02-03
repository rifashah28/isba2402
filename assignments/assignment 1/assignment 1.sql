-- Create Database 'Business'
CREATE DATABASE IF NOT EXISTS Business;
USE Business;

-- Create Table 'customer'
CREATE TABLE IF NOT EXISTS customer(
  -- Define Primary Key
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(50) NOT NULL,
  customer_email VARCHAR(50) NOT NULL);

-- Create Table 'item'
CREATE TABLE IF NOT EXISTS item(
  -- Define Primary Key
  item_id INT PRIMARY KEY,
  item_name VARCHAR(50) NOT NULL,
  item_price INT NOT NULL);

-- Create Table 'orders'
CREATE TABLE IF NOT EXISTS orders(
  -- Define Primary Key
  order_id INT PRIMARY KEY,
  customer_id INT NOT NULL,
  item_id INT NOT NULL,
  -- Define Foreign Key
  FOREIGN KEY customer_id_fk(customer_id)
  REFRENCES customer(customer_id)
  -- Update, Same Change
  ON UPDATE CASCADE
  -- Delete, No Action
  ON DELETE NO ACTION,
  FOREIGN KEY item_id_fk(item_id)
  REFRENCES item(item_id)
  -- Update, Same Change
  ON UPDATE CASCADE
  -- Delete, No Action
  ON DELETE NO ACTION,
  quantity INT NOT NULL);

-- Insert Records into 'customer'
INSERT INTO customer(customer_id, customer_name, customer_email)
VALUES (1, "Rosalyn Rivera", "rr@adatum.com"), (2, "Jayne Sargen", "jayne@test.com"), (3, "Dean Luong", "dean@test.com");

-- Insert Records into 'item'
INSERT INTO item(item_id, item_name, item_price)
VALUES (1, "Chair", 200),(2, "Table", 100),(3, "Lamp", 50);

-- Insert Records into 'orders'
INSERT INTO orders(order_id, customer_id, item_id, quantity)
VALUES (1, 2, 1, 1),(2,2,2,3),(3,3,3,5);
  
  
