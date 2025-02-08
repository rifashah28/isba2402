USE demo1;

## String operations
SET @email := 'abc@google.com';

SELECT UPPER(@email);
SELECT LEFT(@email,3), RIGHT(@email,3);
SELECT LENGTH(@email);


SELECT
	LOCATE('a', @email), #try 'o'
	LOCATE('@', @email),
    LOCATE('.', @email);
    
SELECT MID(@email, LOCATE('@', @email)+1) AS Domain; 
	# could specify the length, If omitted, the whole string will be returned (from the start position)
    #or SUBSTR(@email,4); #SUBSTR(string, start, length) 
    
SELECT REPLACE(@email, '@', '#');

###pattern matching
SELECT @email LIKE 'a%';
SELECT @email LIKE 'a_';


-- fulltext search

-- Create FULLTEXT index for (title, body)

## ADD FULLTEXT index
ALTER TABLE articles
ADD FULLTEXT(title, body);

-- You can define the FULLTEXT index when create a new table, like:
-- 		CREATE TABLE table_name(
-- 			column_list,
-- 			...,
-- 			FULLTEXT (column1,column2,..)
-- 		);

-- MATCH (...) AGAINST (...) essentially returns a relevance score
SELECT *,
    MATCH (title,body) AGAINST ('database') AS score
FROM articles;

-- MATCH (...) AGAINST (...)
-- Q: Search for "database" against "title, body" columns
SELECT * 
FROM articles
WHERE MATCH (title,body)
	AGAINST ('database' IN NATURAL LANGUAGE MODE); #by default is the natural language mode
# return records MATCH returns a value (match find)
    



-- NUMERIC FUNCTIONS

SET @num:=4.7;
SELECT 
		CEIL(@num),
        FLOOR(@num),
        ROUND(@num);
        
SELECT POWER(3,2), RAND();  # a randome number between 0 and 1;
        
        
# randomly select some records

SELECT *, rand() AS rand_val
FROM driver_log
ORDER BY rand_val
LIMIT 5;


-- statistics

# testscore.sql
SELECT COUNT(score) AS n,
SUM(score) AS sum,
MIN(score) AS minimum,
MAX(score) AS maximum,
AVG(score) AS mean,
STDDEV_SAMP(score) AS 'std. dev.',
VAR_SAMP(score) AS 'variance'
FROM testscore;

# by group #sex
SELECT sex, COUNT(score) AS n,
SUM(score) AS sum,
MIN(score) AS minimum,
MAX(score) AS maximum,
AVG(score) AS mean,
STDDEV_SAMP(score) AS 'std. dev.',
VAR_SAMP(score) AS 'variance'
FROM testscore
GROUP BY sex;


## simple histogram
SELECT score, REPEAT('*',COUNT(score)) AS 'count histogram'
FROM testscore GROUP BY score;


