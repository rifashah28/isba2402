-- Q1. Find the titles of all movies directed by Steven Spielberg.

SELECT title FROM Movie
WHERE director='Steven Spielberg';

-- Q2. Find the movies names that contain the word "THE"

SELECT title FROM Movie
WHERE title LIKE '%THE%';

-- Q3. Find those rating records higher than 3 stars before 2011/1/15 or after 2011/1/20 

SELECT * FROM Rating
WHERE stars > 3 AND (ratingDate < '2011-01-15' OR ratingDate > '2011-01-20');
    
/* Q4. Some reviewers did rating on the same movie more than once. 
How many rating records are there with different movie and different reviewer's rating? */

SELECT COUNT(*) FROM
(SELECT DISTINCT rID, mID FROM Rating) AS Unique_Rating;

-- Q5. Which are the top 3 records with the highest ratings?

SELECT * FROM Rating
ORDER BY stars DESC
LIMIT 3;

-- Q6. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.

SELECT DISTINCT m.year FROM Movie m
JOIN Rating r ON m.mID = r.mID
WHERE r.stars IN (4, 5)
ORDER BY m.year ASC;

-- Q7. Find the titles of all movies that have no ratings.

SELECT title FROM Movie m
WHERE NOT EXISTS
(SELECT 1 FROM Rating r WHERE m.mID = r.mID);

/* Q8. Some reviewers didn't provide a date with their rating. 
 Find the names of all reviewers who have ratings with a NULL value for the date. */

SELECT DISTINCT reviewer.reviewer_name
FROM Reviewer reviewer
JOIN Rating r ON reviewer.rID = r.rID
WHERE r.ratingDate IS NULL;
 
/* Q9. Write a query to return the ratings data in a more readable format in only one field(column): 
"reviewer name, movie title, stars, ratingDate". 
Assign a new name to the new column as "Review_details"
Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 
Hint: join three tables, using join twice. 
Hint: use CONCAT_WS(separator, string1, string2) instead of CONCAT() for creating new column because of NULL values */

SELECT CONCAT_WS(',',reviewer.reviewer_name, movie.title, CONCAT(r.stars, 'stars'), r.ratingDate) AS Review_details
FROM Reviewer reviewer
JOIN Rating r ON reviewer.rID = r.rID
JOIN Movie movie ON movie.mID = r.mID
ORDER BY reviewer.reviewer_name, movie.title, r.stars;
