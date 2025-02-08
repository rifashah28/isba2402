/********************************************
********************************************/


-- in-class exercise
-- Q. Which paintings did Van Gogh paint?

SELECT title
FROM painting
WHERE a_id = (
	SELECT a_id FROM artist WHERE name = 'Van Gogh'
    );

-- Q: Who painted the Mona Lisa?
SELECT name
FROM artist
WHERE a_id = (
	SELECT a_id FROM painting WHERE title = 'Mona Lisa'
    );

-- Q: For which artists did you purchase paintings in Kentucky or Indiana? 
SELECT name
FROM artist
WHERE a_id in (
	SELECT a_id 
    FROM painting
    WHERE state IN ('KY','IN')
);

/********************************************
********************************************/

-- union
/* Q: find four users who sent the highest number of emails and four users who received the highest number of emails, 
then sort the result of the union by the user name */

(SELECT CONCAT(srcuser, '@', srchost) AS user, COUNT(*) AS emails
FROM mail GROUP BY srcuser, srchost ORDER BY emails DESC LIMIT 4)
UNION ALL
(SELECT CONCAT(dstuser, '@', dsthost) AS user, COUNT(*) AS emails
FROM mail GROUP BY dstuser, dsthost ORDER BY emails DESC LIMIT 4)
ORDER BY user;


/********************************************
********************************************/

#Q: how many emails were sent by a particular user and how many emails they received
-- correlated subquery
SELECT CONCAT(srcuser,'@',srchost) AS user,
COUNT(*) AS mails_sent,
(SELECT COUNT(*) FROM mail AS d
WHERE d.dstuser = s.srcuser AND d.dsthost = s.srchost) AS mails_recd
FROM mail as s
GROUP BY srcuser, srchost
ORDER BY mails_sent DESC;