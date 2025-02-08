USE Demo1;

/********************************************************
********************************************************/

#Exercise
SET @STR := 'SQL Tutorial';

-- Extract a substring (start at position 5, extract 3 characters)
SELECT SUBSTR(@STR, 5, 3);
-- Replace letter “l(L)” with “_”
SELECT REPLACE(@STR, 'L', '_');
-- Find if string contains any word starting with “t”
SELECT @STR LIKE 't%' OR @STR LIKE '% t%';

-- Driver_log.sql calculate total, average, min, max, standard deviation of miles per driver
SELECT
	name,
    SUM(miles),
    AVG(miles),
    MIN(miles),
    MAX(miles),
    STDDEV_SAMP(miles)
FROM driver_log
GROUP BY name;

-- mail.sql generate a simple histogram for srchost

SELECT srchost, REPEAT('*', COUNT(srchost))
FROM mail
GROUP BY srchost;



-- DATE TIME FORMAT

SELECT CURDATE();
SELECT CURTIME();
SELECT NOW();

SELECT STR_TO_DATE('May 13, 2007','%M %d, %Y');

SELECT DATE_FORMAT(CURTIME(),'%M %d, %Y');
SELECT DATE_FORMAT(CURTIME(),'%m/%d/%Y');
SELECT TIME_FORMAT(CURTIME(), '%r'); ## 12-h time with AM PM suffix

SELECT TIME_FORMAT(CURTIME(), '%H - %i - %s - %f');
SELECT TIME_FORMAT(CURTIME(6), '%H - %i - %s - %f'); # SET the precision (1-6), 0 by default

SELECT 
	YEAR(NOW()),
    MONTH(NOW()),
    DAYOFYEAR(NOW()),
    DAYNAME(NOW());

# EXTRACT function
SELECT 
	EXTRACT(DAY FROM NOW()),
	EXTRACT(MONTH FROM NOW()),
    EXTRACT(YEAR FROM NOW());
    


-- datetime data calculation

SELECT curdate(), DATE_ADD(curdate(), INTERVAL 3 DAY);
SELECT curdate() + INTERVAL 3 DAY;

SELECT NOW(), DATE_SUB(NOW(), INTERVAL '1 3' day_hour);  #1day and 3hour ago
SELECT NOW(), DATE_ADD(NOW(), INTERVAL '1 1:1:1' DAY_SECOND); #day h-m-s
SELECT NOW(), DATE_ADD(NOW(), INTERVAL '-1 3' day_hour);
SELECT NOW(), DATE_ADD(NOW(), INTERVAL -1 WEEK); #USING neg value is DATE_SUB



### boolean data type
DROP table test;
CREATE table test(
	rid int AUTO_INCREMENT PRIMARY KEY,
	col1 bool);
    
DESCRIBE test;
    
INSERT INTO test(col1)
VALUES 
(FALSE), (4), (TRUE), (0), (0), (1), (123), (false), (-1);

select * FROM test
where col1 is TRUE;

### CASE

SELECT *,
	CASE
		WHEN size>500000 THEN 'DELETE'
        WHEN size>10000  THEN 'ARCHIVE'
        ELSE 'HOLD'
	END AS Status
FROM mail;


#******************************
#******************************

# cumulative sum

#rainfall.sql
SELECT * FROM rainfall;

# calculate cumulative precipitation per day, assuming no missing days

SELECT t1.date, t1.precip AS 'daily precip',
SUM(t2.precip) AS 'cum. precip'
FROM rainfall AS t1 INNER JOIN rainfall AS t2
ON t1.date >= t2.date
GROUP BY t1.date
ORDER BY t1.date;

# Add columns to show elapsed days and running average of amount of
# precipitation, assuming no missing days

SELECT t1.date, t1.precip AS 'daily precip',
SUM(t2.precip) AS 'cum. precip',
COUNT(DISTINCT t2.date) AS 'days elapsed',
AVG(t2.precip) AS 'avg. precip'
FROM rainfall AS t1 INNER JOIN rainfall AS t2
ON t1.date >= t2.date
GROUP BY t1.date
ORDER BY t1.date;

#rainfall.sql
SELECT * FROM rainfall;


-- WINDOW function

SELECT sum(precip)
FROM rainfall;

SELECT date, precip, sum(precip)
FROM rainfall;  ## error msg

SELECT date, precip,
	(SELECT sum(precip) FROM rainfall) AS total_precip
FROM rainfall;

# aggregate function using WINDOW FUNCTION
SELECT date, precip,
	sum(precip) OVER () AS total_precip
FROM rainfall;


#rank
SELECT date, precip,
	rank() OVER (order by precip DESC) as ranking #try ASC
FROM rainfall;

#position of the record
# ROW_NUMBER
SELECT date, precip,
	ROW_NUMBER() OVER() as position
FROM rainfall;

SELECT date, precip,
	ROW_NUMBER() OVER(order by precip DESC) as position
FROM rainfall;

#COMBINE rank() and ROW_NUMBER()
SELECT date, precip,
	ROW_NUMBER() OVER() as position,
    rank() OVER (order by precip DESC) as ranking
FROM rainfall;
#return RANK and original position


SELECT name, miles,
	ROW_NUMBER() OVER(partition by name) as group_position,
    RANK() OVER(partition by name order by miles) as group_rank
FROM driver_log;
#WHERE name = 'Henry'



##### lag lead

SELECT date, precip,
	LAG(precip) OVER w as 'lag',
    LEAD(precip) OVER w AS 'lead',
	precip - LAG(precip) OVER w AS 'lag diff',
	precip - LEAD(precip) OVER w AS 'lead diff'
FROM rainfall
WINDOW w AS (order by date);


# Can also be lag/lead for more than one
SELECT date, precip,
	LAG(precip,2) OVER w as 'lag2',
    LEAD(precip,2) OVER w AS 'lead2'
FROM rainfall
WINDOW w AS (order by date);

######frame specification

-- Frame specification keywords:
-- 	CURRENT ROW
-- 	UNBOUNDED PRECEDING -- the first partition row
-- 	UNBOUNDED FOLLOWING - the last partition row
-- 	expr PRECEDING
-- 	expr FOLLOWING

SELECT *,
	avg(precip) OVER (rows BETWEEN
    unbounded preceding and unbounded following)
FROM rainfall;
-- average of all records

## cumulative sum
SELECT *,
	SUM(precip) OVER w AS cum_sum,
    COUNT(precip) OVER w AS days_elapsed,
    AVG(precip) OVER w AS cum_avg
FROM rainfall
WINDOW w AS (rows BETWEEN
    unbounded preceding and current row);
    
    
## rolling calculation
SELECT *,
	sum(precip) OVER w AS cum_sum,
    COUNT(precip) OVER w AS cum_days,
    avg(precip) OVER w AS cum_avg
FROM rainfall
WINDOW w AS (rows BETWEEN
    1 preceding and 1 following);
    

