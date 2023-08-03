SELECT id, account_id, occurred_at
FROM orders;

SELECT TOP 100 id, account_id, occurred_at
FROM orders;
--return the 10 earliest orders in the orders table
SELECT TOP 10 id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at;
--return the top 5 orders in terms of largest total_amt_usd
SELECT TOP 5 id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC;
--return the lowest 20 orders in terms of smallest total_amt_usd. 
SELECT TOP 20 id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd;

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id;

--Pull the first 5 rows and all columns from the orders table that 
--have a dollar amount of gloss_amt_usd greater than or equal to 1000.
SELECT TOP 5 *
FROM orders
WHERE gloss_amt_usd >= 100;

SELECT TOP 10 *
FROM orders
WHERE total_amt_usd  < 500;

--Filter the accounts table to include the company name, website, 
--and the primary point of contact (primary_poc) just for the Exxon Mobil company

SELECT name, website, primary_poc 
FROM accounts
WHERE name ='Exxon Mobil';

--Create a column that divides the standard_amt_usd by the standard_qty to find 
--the unit price for standard paper for each order. Limit the results to the first 10 orders

SELECT TOP 10 id, account_id, standard_amt_usd / standard_qty AS unit_price
FROM orders;

--finds the percentage of revenue that comes from poster paper for each order. 
--You will need to use only the columns that end with _usd
SELECT TOP 10 id, account_id, 
   poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd) AS post_per
FROM orders;

--All the companies whose names start with 'C'.
SELECT name
FROM accounts
WHERE name LIKE 'C%';

--Use the accounts table to find the account name, primary_poc,
--and sales_rep_id for Walmart, Target, and Nordstrom.
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');


--Use the web_events table to find all information regarding 
--individuals who were contacted via the channel of organic or adwords.
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');

--Using the accounts table, find all the companies whose names do not start with 'C' and end with 's'

SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s';

-- order date and gloss_qty data for all orders where gloss_qty is between 24 and 29
SELECT occurred_at, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29;

--list of orders where the standard_qty is zero
--and either the gloss_qty or poster_qty is over 1000
SELECT *
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000);

--pulling all the data from the accounts table, and all the data from the orders table.

SELECT accounts.*, orders.*
FROM orders
JOIN accounts
ON accounts.id = orders.account_id;

--pulling standard_qty, gloss_qty, and poster_qty from the orders table, 
--and the website and the primary_poc from the accounts table.

SELECT accounts.website, accounts.primary_poc, orders.standard_qty, orders.gloss_qty, orders.poster_qty
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;

--Provide a table for all web_events associated with account name of Walmart. 
--There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event.

SELECT web_events.occurred_at, web_events.channel, accounts.primary_poc, accounts.name
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
WHERE accounts.name ='Walmart';

----Provide a table that provides the region for each sales_rep along with their associated accounts. 
--Sort the accounts alphabetically 

SELECT region.name region, sales_reps.name sales, accounts.name account
FROM sales_reps
JOIN region
ON region.id = sales_reps.region_id
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
ORDER BY accounts.name;


--Provide the name for each region for every order, as well as the account name and 
--the unit price they paid (total_amt_usd/total) for the order.A few accounts have 0 for total, 
--so I divided by (total + 0.01) to assure not dividing by zero.

SELECT region.name region, accounts.name account,(orders.total_amt_usd / (orders.total +0.01)) unit_price
FROM region
JOIN sales_reps
ON sales_reps.region_id = region.id
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
JOIN orders
ON accounts.id = orders.account_id;


SELECT region.name region, sales_reps.name sales
FROM sales_reps
LEFT JOIN region
ON region.id = sales_reps.region_id

--Provide a table that provides the region for each sales_rep along with their associated accounts. 
--This time only for the Midwest region. Sort the account alphabetically
SELECT region.name Region, sales_reps.name Sales, accounts.name Account
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
WHERE region.name = 'Midwest'
ORDER BY accounts.name;

--Provide a table that provides the region for each sales_rep along with their associated accounts. 
--This time only for accounts where the sales rep has a last name starting with K and in the Midwest region.
--Sort by account

SELECT region.name Region, sales_reps.name Sales, accounts.name A
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
WHERE sales_reps.name LIKE '% K%' AND region.name = 'Midwest'
ORDER BY accounts.name;

--What are the different channels used by account id 1001?
SELECT DISTINCT accounts.id, web_events.channel
FROM accounts
JOIN web_events
ON accounts.id = web_events.account_id
WHERE accounts.id = 1001;

--Find all the orders that occurred in 2015.
SELECT orders.occurred_at, accounts.name, orders.total, orders.total_amt_usd
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
WHERE orders.occurred_at BETWEEN '2015-01-01' AND '2015-12-31'
ORDER BY orders.occurred_at DESC;

SELECT SUM(poster_qty) AS poster_ordered
FROM orders;

--Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table.
SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders;

--Find the standard_amt_usd per unit of standard_qty paper.
SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit
FROM orders;

--When was the earliest order ever placed?
SELECT MIN(occurred_at)
FROM orders;

--When did the most recent (latest) web_event occur?
SELECT MAX(occurred_at)
FROM web_events;

--Find the mean (AVERAGE) amount spent per order on each paper type,
--as well as the mean amount of each paper type purchased per order
SELECT AVG(standard_qty) mean_standard, AVG(gloss_qty) mean_gloss, 
           AVG(poster_qty) mean_poster, AVG(standard_amt_usd) mean_standard_usd, 
           AVG(gloss_amt_usd) mean_gloss_usd, AVG(poster_amt_usd) mean_poster_usd
FROM orders;

--Which account (by name) placed the earliest order? 
SELECT accounts.name AS acct_name, occurred_at date_of_order
FROM accounts
JOIN orders
ON accounts.id = orders.account_id
ORDER BY occurred_at

--Find the total sales in usd for each account.
SELECT accounts.name AS acct_name, SUM(total_amt_usd) total_sales
FROM accounts
JOIN orders
ON accounts.id = orders.account_id
GROUP BY accounts.name
ORDER BY total_sales DESC;

--Via what channel did the most recent (latest) web_event occur, 
--which account was associated with this web_event
SELECT TOP 1 accounts.name AS acct_name, web_events.channel channel, web_events.occurred_at date
FROM accounts
JOIN web_events
ON accounts.id = web_events.account_id
ORDER BY web_events.occurred_at DESC;
