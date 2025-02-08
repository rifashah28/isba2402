-- Q1: Compute new cases for each day
SELECT state, date, total_cases, total_cases - LAG(total_cases) OVER (PARTITION BY state ORDER BY date) AS new_cases
FROM statistics;

-- Q2: Compute a smoothed rolling average (5-day window)
SELECT state, date,
    AVG(total_cases) OVER (PARTITION BY state ORDER BY date ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS smoothed_average
FROM statistics;

-- Q3: Fetch latest available per state data
SELECT state, date, total_cases, total_deaths
FROM (SELECT state, date, total_cases, total_deaths,
        ROW_NUMBER() OVER (PARTITION BY state ORDER BY date DESC) AS row_num FROM statistics) ranked_statistics
WHERE row_num = 1;

-- Q4: Compute mortality per 100,000 population
WITH latest_data AS (SELECT state, date, total_deaths,
        ROW_NUMBER() OVER (PARTITION BY state ORDER BY date DESC) AS row_num
    FROM statistics)
SELECT ld.state, ld.date, d.population, ld.total_deaths,
    (ld.total_deaths * 100000.0) / d.population AS mortality_per_100k
FROM latest_data ld
JOIN demographics d
ON ld.state = d.state
WHERE ld.row_num = 1;

-- Q5: Find the biggest spike in new deaths per state, sorted by date and count
WITH new_deaths AS (SELECT state, date, 
        total_deaths - LAG(total_deaths) OVER (PARTITION BY state ORDER BY date) AS biggest_spike
    FROM statistics)
SELECT state, date, biggest_spike
FROM (SELECT state, date, biggest_spike,
        RANK() OVER (PARTITION BY state ORDER BY biggest_spike DESC, date DESC) AS rank1
    FROM new_deaths) ranked
WHERE rank1 = 1
ORDER BY biggest_spike DESC, date DESC;
