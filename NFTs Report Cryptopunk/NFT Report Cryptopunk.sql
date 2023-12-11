-- USE DATABASE
USE Prashant;

-- Understand the full Dataset
SELECT * FROM pricedata;

-- How many sales occurred during this time period? 
SELECT COUNT(usd_price) AS Total_Sales
FROM pricedata;

-- Return the top 5 most expensive transactions (by USD price) for this data set. 
-- Return the name, ETH price, and USD price, as well as the date.
SELECT name,eth_price,usd_price,event_date
FROM pricedata
ORDER BY usd_price DESC LIMIT 5;

-- Return a table with a row for each transaction with an event column, a USD price column, and a 
-- moving average of USD price that averages the last 50 transactions.
SELECT event_date,usd_price,AVG(usd_price)
OVER(ORDER BY event_date ASC ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) AS Moving_avg
FROM pricedata;

-- Return all the NFT names and their average sale price in USD. 
-- Sort descending. Name the average column as average_price.
SELECT name,AVG(usd_price) AS average_price
FROM pricedata
GROUP BY name 
ORDER BY average_price DESC;

-- Return each day of the week and the number of sales that occurred on that day of the week, 
-- as well as the average price in ETH. Order by the count of transactions in ascending order.
SELECT DAY(event_date) AS day_of_week,COUNT(*) AS count_txn, AVG(eth_price)
FROM pricedata
GROUP BY day_of_week
ORDER BY count_txn ASC;

-- Construct a column that describes each sale and is called summary. 
-- The sentence should include who sold the NFT name, who bought the NFT, who sold the NFT, the date, 
-- and what price it was sold for in USD rounded to the nearest thousandth.
SELECT CONCAT( name,' was sold for ', ROUND(usd_price,3) ,' to ', 
buyer_address,' from ', seller_address,' on ',event_date)
AS Summary
FROM pricedata;

-- Create a view called “1919_purchases” and contains any sales 
-- where “0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685” was the buyer.
CREATE VIEW 1919_purchases AS
SELECT * FROM pricedata
WHERE buyer_address ='0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685';

-- Return a Union query that contains the highest price each NFT was bought for and a new column called status 
-- saying “highest” with a query that has the lowest price each NFT was bought for and the status column saying “lowest”. 
-- The table should have a name column, a price column called price, and a status column. 
-- Order the result set by the name of the NFT, and the status, in ascending order. 

-- Query for the highest price each NFT was bought for
SELECT name,MAX(usd_price) AS price,
'highest' AS status
FROM pricedata
GROUP BY name
UNION
-- Query for the lowest price each NFT was bought for
SELECT name, MIN(usd_price) AS price,
'lowest' AS status
FROM pricedata
GROUP BY name
ORDER BY name ASC, status ASC;

-- What NFT sold the most each month / year combination? Also, what was the name and the price in USD? 
-- Order in chronological format. 
SELECT MAX(usd_price) AS Max_price,DATE_FORMAT(EVENT_DATE, '%m-%Y')AS month_year,name,usd_price
FROM pricedata
GROUP BY month_year,name,usd_price
ORDER BY month_year;

-- Return the total volume (sum of all sales), round to the nearest hundred on a monthly basis (month/year).
SELECT ROUND(SUM(usd_price),-2) AS Total_sale,DATE_FORMAT(EVENT_DATE, '%m-%Y') AS month_year
FROM pricedata
GROUP BY month_year
ORDER BY month_year;

-- Count how many transactions the wallet "0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685"had over this time period.
SELECT COUNT(*) AS COUNT
FROM pricedata
WHERE buyer_address="0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685"
UNION
SELECT COUNT(*) AS COUNT
FROM pricedata
WHERE seller_address="0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685";


-- 
















