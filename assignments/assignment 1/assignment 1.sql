CREATE DATABASE IF NOT EXISTS Business;
USE Business;
CREATE TABLE IF NOT EXISTS customer(
	customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    customer_email VARCHAR(50) NOT NULL
);
CREATE TABLE IF NOT EXISTS item (
	item_id INT PRIMARY KEY,
    item_name VARCHAR(50) NOT NULL,
    item_price INT NOT NULL
);
CREATE TABLE IF NOT EXISTS orders (
	order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    item_id INT NOT NULL,
    FOREIGN KEY customer_id_fk(customer_id) REFERENCES customer(customer_id) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY item_id_fk(item_id) REFERENCES item(item_id) ON UPDATE CASCADE ON DELETE NO ACTION,
    quantity INT NOT NULL
);
INSERT INTO customer (customer_id, customer_name, customer_email)
VALUES (1, "Rosalyn Rivera", "rr@adatum.com"),(2, "Jayne Sargen", "jayne@test.com"),(3, "Dean Luong", "dean@test.com");

INSERT INTO item (item_id, item_name, item_price)
VALUES (1, "Chair", 200),(2, "Table", 100),(3, "Lamp", 50);

INSERT INTO orders (order_id, customer_id, item_id, quantity)
VALUES (1, 2, 1, 1),(2,2,2,3),(3,3,3,5);
