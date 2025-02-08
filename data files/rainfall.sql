# rainfall.sql

# rainfall table: each record indicates date of measurement and amount
# of precipitation on that day.

# This file sets up the table and runs a self join to calculate
# running totals and averages for amount of precipitation each
# day, assuming no missing days.  rainfall2.sql shows the calculations
# if missing days are permitted.

DROP TABLE IF EXISTS rainfall;
#@ _CREATE_TABLE_
CREATE TABLE rainfall
(
  date    DATE NOT NULL,
  precip  FLOAT(10,2) NOT NULL,
  PRIMARY KEY(date)
);
#@ _CREATE_TABLE_

INSERT INTO rainfall (date, precip)
  VALUES
    ('2014-06-01', 1.5),
    ('2014-06-02', 0),
    ('2014-06-03', 0.5),
    ('2014-06-04', 0),
    ('2014-06-05', 1.0)
;

