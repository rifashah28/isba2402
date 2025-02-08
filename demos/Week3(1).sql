
-- SOLUTIONS TO THE IN-CLASS PRACTICE
#q1.
SELECT painting.title
FROM artist INNER JOIN painting ON artist.a_id = painting.a_id
WHERE artist.name = 'Van Gogh';

#q2.
SELECT artist.name
FROM artist INNER JOIN painting ON artist.a_id = painting.a_id
WHERE painting.title = 'Mona Lisa';

#q3.
SELECT DISTINCT artist.name
FROM artist INNER JOIN painting ON artist.a_id = painting.a_id
WHERE painting.state IN ('KY','IN');


-- Week 3 topics

-- find all paintings in your collection by the artist who painted The Potato Eaters
SELECT * 
FROM painting AS p1
	INNER JOIN painting as p2
ON p1.a_id = p2.a_id    ######STEP2
WHERE p1.title = 'The Potato Eaters'; ###### STEP1


SELECT p2.title 
FROM painting AS p1
	INNER JOIN painting as p2
ON p1.a_id = p2.a_id
WHERE p1.title = 'The Potato Eaters';
## has to be p2.title,  try p1.title

-- Summaries

-- min(), max()
SELECT MIN(trav_date)
FROM driver_log;

SELECT MAX(trav_date)
FROM driver_log;

SELECT MAX(name)
FROM driver_log;

-- SUM(), AVG()
SELECT
SUM(miles) AS 'total miles',
AVG(miles) AS 'average miles/day'
FROM driver_log;

-- using min() max() to select record

### not working
SELECT * 
FROM driver_log
WHERE trav_date = MAX(trav_date);


# Solution 1: user-defined variable
SET @max = (SELECT MAX(trav_date) FROM driver_log);
SELECT @max;

SELECT * 
FROM driver_log
WHERE trav_date = @max;

#Solution 2: join
DROP table if exists tmp;
CREATE temporary table tmp
SELECT MAX(trav_date) AS latest
FROM driver_log;

SELECT * from tmp;

SELECT *
FROM driver_log INNER JOIN tmp
WHERE driver_log.trav_date = tmp.latest;

-- Grouping
#mail.sql
# colname_group, summary_function 
SELECT srchost, COUNT(srchost) 
FROM mail 
GROUP BY srchost; 

SELECT srcuser,
SUM(size) AS 'total bytes',
AVG(size) AS 'bytes per message'
FROM mail 
GROUP BY srcuser;

#grouping can be fine-grained 
SELECT srcuser, srchost, COUNT(srcuser) FROM mail
GROUP BY srcuser, srchost;

#cannot include any other nonaggregate column in SELECT
SELECT t, srchost, COUNT(srchost) 
FROM mail 
GROUP BY srchost;


#example in slide
SELECT name, trav_date, MAX(miles) 'longest trip'
FROM driver_log
GROUP BY name;

DROP table if exists tmp;
CREATE temporary table tmp
SELECT name, MAX(miles) AS miles 
FROM driver_log
GROUP BY name;

SELECT d.name, d.trav_date, d.miles AS 'longest trop'
FROM driver_log d
INNER JOIN tmp USING(name,miles)
ORDER BY name;


-- HAVING
#driver_log.sql
# drivers in the driver_log table who drove more than three days
SELECT COUNT(name), name FROM driver_log
GROUP BY name
HAVING COUNT(name) > 3; #try WHERE COUNT(*) > 3;

-- using alias with HAVING
SELECT COUNT(name) AS CT, name FROM driver_log
GROUP BY name
HAVING CT > 3;


-- HAVING and COUNT()

/*days on which only one driver was active  =1 
days on which more than one driver was active >1*/
SELECT trav_date, COUNT(trav_date) 
FROM driver_log
GROUP BY trav_date 
HAVING COUNT(trav_date) = 1;  ###>1


-- different summary levels
SELECT @total := SUM(miles) AS 'total miles' 
FROM driver_log;
## SET @test_total = (SELECT SUM(miles) FROM driver_log);

SELECT name,
SUM(miles) AS 'miles/driver',
(SUM(miles)*100)/@total AS 'percent of total miles'
FROM driver_log 
GROUP BY name;

