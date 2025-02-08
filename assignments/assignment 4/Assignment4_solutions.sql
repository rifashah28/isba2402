# change the datetime to date
ALTER TABLE statistics
MODIFY column date DATE;

/*Q1.Compute new cases for each day. */ #(3pts)

SELECT date, sum(new_cases_per_state)
FROM (SELECT
	total_cases - LAG(total_cases) OVER (PARTITION BY state ORDER BY date) AS new_cases_per_state,
	date
	FROM statistics) AS t
GROUP BY date
ORDER BY date;



/*Q2.To account for "administrative weekends" with fewer reports or missing data, 
compute the smoothed rolling average between two preceding days and two following days. */ #(3pts)

SELECT *,
AVG(total_cases_by_date) OVER w as case_rolling_avg,
AVG(total_deaths_by_date) OVER w as death_rolling_avg
FROM (
	SELECT date, SUM(total_cases) AS total_cases_by_date,
    SUM(total_deaths) AS total_deaths_by_date
	FROM statistics
	GROUP BY date
	ORDER BY date) AS t
WINDOW w AS (rows BETWEEN 2 preceding and 2 following)
;



/*Q3. Fetch latest available per state data from statistics. Note that states may have different latest submission dates. (hint: ROW_NUMBER())*/ #(3pts)

SELECT *
FROM (SELECT *,
	ROW_NUMBER() OVER (partition by state order by date DESC) as state_recd_day
	FROM statistics) AS t
WHERE state_recd_day = 1;


/*Q4.Use the "latest data" derived from the above query and demographic information to compute the mortality per 100,000 population.*/ #(3pts)

CREATE TEMPORARY table temp
SELECT *
FROM (SELECT *,
	ROW_NUMBER() OVER (partition by state order by date DESC) as state_recd_day
	FROM statistics) AS t
WHERE state_recd_day = 1;

SELECT s.total_deaths/d.population*100000 as mortality_per100000
FROM temp AS s INNER JOIN demographics as d USING(state);


/*Q5.Find the biggest spike in new deaths per state. Sort them by the most recent date, then by the count of new deaths. (hint: RANK())*/ #(3pts)

CREATE TEMPORARY table temp1
SELECT *,
RANK() OVER (PARTITION BY state ORDER BY new_deaths_per_state DESC) AS new_death_rank
FROM (SELECT date, state,
	total_deaths - LAG(total_deaths) OVER (PARTITION BY state ORDER BY date) AS new_deaths_per_state
	FROM statistics) AS t;

SELECT * 
FROM temp1
WHERE new_death_rank = 1
ORDER BY date DESC, new_deaths_per_state;

