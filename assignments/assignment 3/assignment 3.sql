/*1.Find the names of aircraft such that all pilots certified to operate them have salaries more than $80,000. */
SELECT DISTINCT a.aname
FROM aircraft a
JOIN certified c ON a.aid = c.aid
JOIN employees e ON c.eid = e.eid
GROUP BY a.aid, a.aname
HAVING MIN(e.salary) > 80000;

/*2.Find the names of employees whose salary is less than the price of the cheapest route from Bangalore to Frankfurt. */
SELECT e.ename
FROM employees e
WHERE e.salary < (SELECT MIN(f.price) FROM flight f
WHERE f.origin = 'Bangalore' AND f.destination = 'Frankfurt');

/*3.For all aircraft with cruising range over 1,000 miles,
find the name of the aircraft and the average salary of all pilots certified for this aircraft.*/
SELECT aname, AVG(e.salary) AS avg_salary
FROM certified c
LEFT JOIN aircraft USING (aid)
LEFT JOIN employees as e USING (eid)
WHERE cruisingrange > 1000
GROUP BY aid;

/*4.Identify the routes that can be piloted by every pilot who makes more than $70,000.
(In other words, find the routes with distance less than the least cruising range of aircrafts driven by pilots who make more than $70,000) */
SELECT f.flno, f.origin, f.destination, f.distance
FROM flight f
WHERE f.distance < (SELECT MIN(a.cruisingrange) FROM aircraft a
JOIN certified c ON a.aid = c.aid
JOIN employees e ON c.eid = e.eid
WHERE e.salary > 70000);

/*5. Print the names of pilots who can operate planes with cruising range greater than 3,000 miles but are not certified on any Boeing aircraft. */
SELECT DISTINCT e.ename
FROM employees e
JOIN certified c ON e.eid = c.eid
JOIN aircraft a ON c.aid = a.aid
WHERE a.cruisingrange > 3000
AND e.eid NOT IN (SELECT c.eid FROM certified c
JOIN aircraft a ON c.aid = a.aid
WHERE a.aname LIKE '%Boeing%');

/*6. Compute the difference between the average salary of a pilot and the average salary of all employees (including pilots).*/
SELECT (SELECT AVG(e.salary) FROM employees e WHERE e.eid IN (SELECT c.eid FROM certified c))
- (SELECT AVG(e.salary) FROM employees e) AS diff_salary;

/*7. Print the name and salary of every non-pilot whose salary is more than the average salary for pilots.*/
SELECT e.ename, e.salary
FROM employees e
WHERE e.eid NOT IN (SELECT c.eid FROM certified c)
AND e.salary > (SELECT AVG(e.salary) FROM employees e
WHERE e.eid IN (SELECT c.eid FROM certified c));
