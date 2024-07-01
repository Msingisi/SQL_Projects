UPDATE avocado_fact
SET type = 
LOWER(type)
WHERE type IN ('Organic', 'organic',
	'conventional', 'Conventional')
	
-- Average price by year and Total volume by year
-- Aside from the price decrease from $1.5 to $1.3 from 2019 and 2020 which also showed an 
-- increase of 1 billion in sales, there are not strong correlations between the price and volume

SELECT year, AVG(AveragePrice)
FROM avocado_fact
GROUP BY year
ORDER BY year ASC

SELECT year, SUM(TotalVolume) AS TotalVol
FROM avocado_fact
GROUP BY year
ORDER BY year ASC
	
-- The average price per type of conventional and organic avocados.
-- About 50% of organic avocado sales averaged $1.68 per avocado and roughly 
-- 50% of conventional avocados averaged $1.60 per avocado.
-- Despite organic avocado having slighly higher average price, We can see that the total volume output of 
-- conventional avocados far out numbers the total volume output of organic avocados
	
SELECT type, AVG(AveragePrice) AS avg_price, SUM(TotalVolume) AS TotalVol,
	COUNT(*) as type_count, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM avocado_fact
WHERE region NOT IN ('TotalUS', 'West', 'California', 'SouthCentral', 'Northeast', 'Southeast', 'GreatLakes', 'Midsouth', 'Plains')
GROUP BY type

SELECT year, type, SUM(TotalVolume) AS TotalVol
FROM avocado_fact
WHERE region NOT IN ('TotalUS', 'West', 'California', 'SouthCentral', 'Northeast', 'Southeast', 'GreatLakes', 'Midsouth', 'Plains')
GROUP BY type, year
ORDER BY year ASC

-- Average Price Per Type, Year
-- the average price of organic avocados is generally always higher than conventional avocados

SELECT year, type, AVG(AveragePrice) AS avg_price
FROM avocado_fact
WHERE region NOT IN ('TotalUS', 'West', 'California', 'SouthCentral', 'Northeast', 'Southeast', 'GreatLakes', 'Midsouth', 'Plains')
GROUP BY type, year
ORDER BY year ASC
	
-- Product preference
-- The most popular avocado variety is the plu 4046, the small size avocado

SELECT year, SUM(TotalVolume) AS TotalVol, SUM(plu4046) AS plu4046, SUM(plu4225) AS plu4225, SUM(plu4770) AS plu4770
FROM avocado_fact
WHERE region NOT IN ('TotalUS', 'West', 'California', 'SouthCentral', 'Northeast', 'Southeast', 'GreatLakes', 'Midsouth', 'Plains')
GROUP BY year
ORDER BY year ASC


SELECT year, SUM(plu4046) AS plu4046, SUM(plu4225) AS plu4225, SUM(plu4770) AS plu4770
FROM avocado_fact
WHERE region NOT IN ('TotalUS', 'West', 'California', 'SouthCentral', 'Northeast', 'Southeast', 'GreatLakes', 'Midsouth', 'Plains')
GROUP BY year
ORDER BY year ASC

-- Top Regions and consumption
-- Los Angeles & Dallas are the two majors contributors to the sales of avocados in the U.S 
-- followed by Phoenix, Houston and New York
	
SELECT region, SUM(TotalVolume) AS TotalVol
FROM avocado_fact
WHERE region NOT IN ('TotalUS', 'West', 'California', 'SouthCentral', 'Northeast', 'Southeast', 'GreatLakes', 'Midsouth', 'Plains')
GROUP BY region
ORDER BY TotalVol desc
LIMIT 10

-- Los Angeles purchasing power
-- We see that despite the price increase, the quantity bought doesn’t fluctuate much

SELECT year, AVG(AveragePrice) AS avg_price, SUM(TotalVolume) AS TotalVol, SUM(plu4046) AS plu4046, SUM(plu4225) AS plu4225, SUM(plu4770) AS plu4770
FROM avocado_fact
WHERE region = 'LosAngeles'
GROUP BY year
ORDER BY year ASC

-- Yearly Trends of Average price and Total volume

SELECT SUM(TotalVolume) AS TotalVol, AVG(AveragePrice) AS AvgPrice, year
FROM avocado_fact
GROUP BY year
ORDER BY year asc
	
-- Best region for Millennials
	
SELECT region, AVG(AveragePrice) AS avg_price
FROM avocado_fact
WHERE type = 'conventional'
AND region NOT IN ('TotalUS', 'West', 'California', 'SouthCentral', 'Northeast', 'Southeast', 'GreatLakes', 'Midsouth', 'Plains')
GROUP BY region
ORDER BY avg_price ASC
LIMIT 10;
