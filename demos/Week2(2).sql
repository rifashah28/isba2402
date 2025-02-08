
/* driver_log.sql */
-- sorting result
SELECT * FROM driver_log;

#sorting using one column
SELECT * FROM driver_log
ORDER BY name;

# sorting using multiple columns
SELECT * FROM driver_log
ORDER BY name, trav_date;

# ASC DESC mixed order sorting, by default, ASC
SELECT * FROM driver_log
ORDER BY name, trav_date DESC;

# USING alias
-- mail.sql
SELECT t, srcuser, CONCAT(size/1024,'K') AS size_in_K
FROM mail 
WHERE size > 50000 ### where conditions only apply names from orginal attributes TRY  WHERE size_in_K > 50
ORDER BY size_in_K; ### ORDER BY can use alias

# Sorting using multiple columns : the sequence of attributes matters 
SELECT * FROM driver_log
ORDER BY name, trav_date;

SELECT * FROM driver_log
ORDER BY trav_date, name;


-- LIMIT, driver_log

#return 5 records
SELECT * FROM driver_log LIMIT 5;

# FIND the OLDEST record
SELECT * FROM driver_log
ORDER BY trav_date
LIMIT 1;

#MIN(trav_date)

#FIND the TOP 3 record with the longest travel distance
SELECT * FROM driver_log
ORDER BY miles DESC
LIMIT 3;


-- WORK w/ multiple tables

#Save query result into a table
CREATE TABLE mail_list
SELECT t, size/1024 AS KILOBYTE, 
CONCAT(srcuser,'@',srchost) AS sender,
CONCAT(dstuser, '@', dsthost) AS receiver
FROM mail
ORDER BY KILOBYTE;

#Cloning a table
CREATE TABLE mail2 LIKE mail;
INSERT INTO mail2 SELECT * FROM mail WHERE srcuser = 'barb';


-- Finding Matches Between Tables
-- JOINs
/*artist.sql*/

# WHERE
SELECT * FROM artist INNER JOIN painting
WHERE artist.a_id = painting.a_id
ORDER BY artist.a_id;

#ON
SELECT * FROM artist INNER JOIN painting
ON artist.a_id = painting.a_id
ORDER BY artist.a_id;

#USING
SELECT * FROM artist INNER JOIN painting
USING (a_id)
ORDER BY a_id;

# conventional way of using these
SELECT * FROM artist INNER JOIN painting
ON artist.a_id = painting.a_id
WHERE painting.state = 'KY';


#Specifying the columns selection
SELECT artist.name, painting.title, painting.state, painting.price
FROM artist INNER JOIN painting
ON artist.a_id = painting.a_id
WHERE painting.state = 'KY';

 #can use aliases 
SELECT a.name, p.title, p.state, p.price
FROM artist AS a INNER JOIN painting AS p  #can also use aliases 
ON a.a_id = p.a_id
WHERE p.state = 'KY';