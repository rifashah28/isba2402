# Solution to the in-class ex

#find the driver with the most total miles
#Method 1
SELECT name, SUM(miles)
FROM driver_log
GROUP BY name
ORDER BY SUM(miles) DESC LIMIT 1;

#Method 2, Using HAVING clause
DROP TABLE if exists tmp;
CREATE TEMPORARY TABLE tmp
SELECT name, SUM(miles) sum_miles
FROM driver_log
GROUP BY name;
#SELECT * FROM tmp;

SET @max_total_miles := (SELECT max(sum_miles) FROM tmp);

SELECT name, SUM(miles) sum_miles
FROM driver_log
GROUP BY name
HAVING SUM(miles) = @max_total_miles;

-- In-CLASS exercise
/* For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, 
return the reviewer's name and the title of the movie. */

SELECT Reviewer.name, Movie.title
FROM Rating AS r1
INNER JOIN Rating as r2 USING (rID, mID)
INNER JOIN Reviewer USING(rId)
INNER JOIN Movie USING(mId)
WHERE r1.stars<r2.stars AND r1.ratingDate<r2.ratingDate;


/*For each movie that has at least one rating, 
find the highest number of stars that movie received. 
Return the movie title and number of stars. Sort by movie title.*/
DROP TABLE if exists TMP;
CREATE TEMPORARY TABLE TMP
SELECT mID, max(stars) AS maxStars
FROM Rating
GROUP BY mID;

SELECT Movie.title, TMP.maxStars
FROM Movie
INNER JOIN TMP USING (mID)
ORDER BY Movie.title;

/* For each movie, return the title and the 'rating spread', that is, 
the difference between highest and lowest ratings given to that movie. 
Sort by rating spread from highest to lowest, then by movie title. */

DROP TABLE if exists TMP2;
CREATE TEMPORARY TABLE TMP2
SELECT mID, (max(stars) - min(stars)) AS 'rating_spread'
FROM Rating 
GROUP BY mID;

SELECT Movie.title, TMP2.rating_spread
FROM Movie
INNER JOIN TMP2 USING (mID)
ORDER BY rating_spread DESC, Movie.title;




-- UNION.  

SELECT distinct srcuser, srchost FROM mail;
SELECT distinct dstuser, dsthost FROM mail;


###by default result used the colnames in the first table

SELECT distinct srcuser, srchost FROM mail
UNION DISTINCT
SELECT distinct dstuser, dsthost FROM mail 
ORDER BY srcuser, srchost;

SELECT distinct srcuser, srchost FROM mail
UNION ALL
SELECT distinct dstuser, dsthost FROM mail 
ORDER BY srcuser, srchost;




-- SUBQUERY

-- min max
-- Q: the record with max MILES USING subquery
SELECT *
FROM driver_log
WHERE miles = (SELECT MAX(miles) FROM driver_log);



-- Q: which paintings are more expensive than 'Starry Night' in your collection?
-- Q: which paintings are more expensive than the average of the painting prices . 

SELECT title
FROM painting
WHERE price > (
	SELECT price   #avg(price)
    FROM painting
    WHERE title = 'Starry Night'
);


-- ANY SOME
-- Q: select Ben's record as long as it is larger than any Henry record of miles

### CHECK EACH INDIVIDUAL RECORD FIRST AND TAKE A NOTE of the MILES values
SELECT *
FROM driver_log
WHERE name = 'Ben';

SELECT *
FROM driver_log
WHERE name = 'Henry';

SELECT *
FROM driver_log
WHERE miles > ANY (
	SELECT miles
    FROM driver_log
    WHERE name = 'Henry') 
    AND name = 'Ben';


-- ALL
SELECT *
FROM driver_log
WHERE name = 'Ben' AND
	miles > ALL (
	SELECT miles
    FROM driver_log
    WHERE name = 'Henry');
#<ALL which records returned?

SELECT *
FROM driver_log
WHERE name = 'Henry' AND 
	miles > ALL (
	SELECT miles
    FROM driver_log
    WHERE name = 'Ben');



-- correlated subquery
-- Q: return the records in driver log that is larger than their own average miles
SELECT *
FROM driver_log AS d
WHERE miles > (
	SELECT AVG(miles)
    FROM driver_log
    WHERE name = d.name
)
ORDER BY name;    


-- EXISTS

#using in
# find whose painting exist in the collection
# three methods

## INNER JOIN USING a_id
SELECT DISTINCT name
FROM artist 
INNER JOIN painting USING (a_id);

## subquery
SELECT name
FROM artist
WHERE a_id IN (
	SELECT a_id
    FROM painting
);

#using EXISTS
SELECT name
FROM artist a
WHERE EXISTS (
	SELECT *
    FROM painting
    WHERE a_id = a.a_id #correlated query
); 

/*LEFT JOIN, NOT IN, NOT EXISTS 
return the same results for the following question:
which artist we do not have the painting in collection */



-- Subquery in SELECT AND FROM
-- Q: total miles per driver and percentage of each driver’s mileage 
# used user-defined var previously
# add another return result: difference between the total per driver and average of driver

SELECT name, sum(miles) AS 'total miles per driver',
sum(miles)/(SELECT sum(miles) FROM driver_log) AS 'percentage',
sum(miles)- (SELECT sum(miles)/COUNT(DISTINCT name) FROM driver_log) AS diff
FROM driver_log
GROUP BY name;
USE demo;

-- create view
CREATE VIEW driver
	AS 
    SELECT name, sum(miles) AS 'total miles per driver',
	sum(miles)/(SELECT sum(miles) FROM driver_log) AS 'percentage',
	sum(miles)- (SELECT sum(miles)/COUNT(DISTINCT name) FROM driver_log) AS diff
	FROM driver_log
	GROUP BY name;
    








