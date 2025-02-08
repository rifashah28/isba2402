USE Demo;

-- Stored procedure

DROP PROCEDURE IF exists get_results;
# define a new delimiter to define the end of the entire procedure, but inside it, individual statements are each terminated by ;
DELIMITER $$ 
CREATE PROCEDURE get_results()
BEGIN
	SELECT * FROM driver_log;
END$$

DELIMITER ;

CALL get_results();

-- Procedure with parameters get_results_driver()
DELIMITER $$
CREATE PROCEDURE get_results_driver(driver varchar(50))
BEGIN
	SELECT * 
    FROM driver_log d
    WHERE d.name = driver;
END$$
DELIMITER ;

CALL get_results_driver('Ben');



-- Trigger
# assignment 1 tables
USE business;
# create a new table payments
DROP TABLE IF exists payments;

CREATE table if not exists payments(
	customer_id int primary key,
    amount int);
    
INSERT INTO payments VALUES
(2,500),(3,250);

DROP trigger if exists payments_after_insert;
DELIMITER $$
CREATE TRIGGER payments_after_insert
	AFTER INSERT ON order_list
    FOR EACH ROW
BEGIN
    UPDATE payments
    SET amount = amount + NEW.quantity * 100
    WHERE customer_id = new.customer_id;
END $$
DELIMITER ;

INSERT INTO order_list VALUES
(4,3,2,1);
#check the updates in payments table


# adding log for trigger 
drop table if exists order_logs;
# CREATE A log table
CREATE TABLE IF NOT EXISTS order_logs(
	customer_id INT,
    item_id int,
    quantity int,
    action_type VARCHAR(50),
    action_date DATETIME
);

    
DROP trigger if exists payments_after_insert_with_log;
DELIMITER $$
CREATE TRIGGER payments_after_insert_with_log
	AFTER INSERT ON order_list
    FOR EACH ROW
BEGIN
	UPDATE payments
    SET amount = amount + NEW.quantity * 100
    WHERE customer_id = new.customer_id;
    
    INSERT INTO order_logs VALUES
    (
		NEW.customer_id,
        NEW.item_id,
        NEW.quantity,
        'insert',
        NOW()
    );
END $$
DELIMITER ;


INSERT INTO order_list VALUES
(5,2,2,5);
#check the log table


-- event
/***********
***********/
-- turn on event_scheduler
SHOW VARIABLES LIKE 'event%';
SET GLOBAL event_scheduler = 'ON';




DELIMITER $$

CREATE EVENT yearly_delete_stale_payment_logs
ON SCHEDULE
    EVERY 1 YEAR
DO BEGIN
	DELETE FROM payment_logs
    WHERE action_date < NOW() - INTERVAL 1 YEAR;
END$$

DELIMITER ;
