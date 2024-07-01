SELECT COUNT(order_details_id) AS Total_orders_placed
FROM order_details_dim

--
	
SELECT Sum(quantity) AS total_quantity_ordered
FROM order_details_dim

-- Typical Number of Pizzas in an Order
-- The average number of pizzas per order

SELECT AVG(quantity) AS avg_pizzas_per_order
FROM order_details_dim
	
--
	
SELECT ROUND(SUM(order_details_dim.quantity * pizzas_dim.price),2) AS total_sales
FROM order_details_dim JOIN pizzas_dim
ON pizzas_dim.pizza_id = order_details_dim.pizza_id

--
	
SELECT pizza_types_dim.name, pizzas_dim.price
FROM pizza_types_dim
JOIN pizzas_dim
ON pizza_types_dim.pizza_type_id = pizzas_dim.pizza_type_id
ORDER BY price DESC
LIMIT 10

--
	
SELECT pizzas_dim.size, SUM(order_details_dim.quantity) AS order_quantity
FROM order_details_dim JOIN pizzas_dim
ON order_details_dim.pizza_id = pizzas_dim.pizza_id
GROUP BY pizzas_dim.size
ORDER BY order_quantity DESC

--
	
SELECT pizza_types_dim.name, SUM(order_details_dim.quantity) AS quantity_ordered,
	SUM(order_details_dim.quantity * pizzas_dim.price) AS total_sales
FROM pizza_types_dim JOIN pizzas_dim
ON pizza_types_dim.pizza_type_id = pizzas_dim.pizza_type_id
JOIN order_details_dim
ON order_details_dim.pizza_id = pizzas_dim.pizza_id
GROUP BY pizza_types_dim.name
ORDER BY quantity_ordered DESC
LIMIT 10

--

SELECT pizza_types_dim.name, SUM(order_details_dim.quantity) AS quantity_ordered, 
	SUM(order_details_dim.quantity * pizzas_dim.price) AS total_sales
FROM pizza_types_dim JOIN pizzas_dim
ON pizza_types_dim.pizza_type_id = pizzas_dim.pizza_type_id
JOIN order_details_dim
ON order_details_dim.pizza_id = pizzas_dim.pizza_id
GROUP BY pizza_types_dim.name
ORDER BY quantity_ordered ASC
LIMIT 10

--
	
SELECT pizza_types_dim.category, SUM(order_details_dim.quantity) AS quantity_ordered, 
	SUM(order_details_dim.quantity * pizzas_dim.price) AS total_sales
FROM pizza_types_dim JOIN pizzas_dim
ON pizza_types_dim.pizza_type_id = pizzas_dim.pizza_type_id
JOIN order_details_dim
ON order_details_dim.pizza_id = pizzas_dim.pizza_id
GROUP BY pizza_types_dim.category
ORDER BY quantity_ordered DESC

	
-- Populate orders_dim table with month, day, and hour

ALTER TABLE orders_dim
ADD COLUMN month_text
TEXT;

ALTER TABLE orders_dim
ADD COLUMN day_text
TEXT;

ALTER TABLE orders_dim
ADD COLUMN hour
INTEGER;

ALTER TABLE orders_dim
ADD COLUMN month
INTEGER;

ALTER TABLE orders_dim
ADD COLUMN day
INTEGER;
	
UPDATE orders_dim SET
month = EXTRACT(MONTH FROM TO_TIMESTAMP(date || ' ' || time, 'YYYY-MM-DD 
	HH24:MI:SS')),
day = EXTRACT(DAY FROM TO_TIMESTAMP(date || ' ' || time, 'YYYY-MM-DD
	HH24:MI:SS')),
hour = EXTRACT(HOUR FROM TO_TIMESTAMP(date || ' ' || time, 'YYYY-MM-DD 
	HH24:MI:SS'));

UPDATE orders_dim SET
month_text = TO_CHAR(TO_TIMESTAMP(date || ' ' || time, 'YYYY-MM-DD
	HH24:MI:SS'), 'Month'),
day_text = TO_CHAR(TO_TIMESTAMP(date || ' ' || time, 'YYYY-MM-DD
	HH24:MI:SS'), 'Day');
	
ALTER TABLE orders_dim
DROP COLUMN month;
ALTER TABLE orders_dim
DROP COLUMN day;

--

SELECT orders_dim.hour, COUNT(order_details_dim.order_details_id) AS orders_placed 
FROM order_details_dim JOIN orders_dim
ON order_details_dim.order_id = orders_dim.order_id
GROUP BY orders_dim.hour
ORDER BY orders_placed DESC;

--

SELECT orders_dim.month_text, COUNT(order_details_dim.order_details_id) AS orders_placed 
FROM order_details_dim JOIN orders_dim
ON order_details_dim.order_id = orders_dim.order_id
GROUP BY orders_dim.month_text
ORDER BY orders_placed DESC 

--
	
SELECT orders_dim.day_text, COUNT(order_details_dim.order_details_id) AS orders_placed 
FROM order_details_dim JOIN orders_dim
ON order_details_dim.order_id = orders_dim.order_id
GROUP BY orders_dim.day_text
ORDER BY orders_placed DESC

-- Daily Customer Traffic and Peak Hours:	
SELECT date, COUNT(DISTINCT order_id) AS num_customers
FROM orders_dim
GROUP BY date

SELECT hour, COUNT(order_id) AS num_orders
FROM public.orders_dim
GROUP BY hour
ORDER BY num_orders DESC
LIMIT 1;

-- Top 5 Orders with the highest quantity of pizzas sold

SELECT order_id, SUM(quantity) AS total_pizzas
FROM order_details_dim
GROUP BY order_id
ORDER BY total_pizzas DESC
LIMIT 5;

--
SELECT pizza_types_dim.name, SUM(pizzas_dim.price * order_details_dim.quantity) AS top_selling_pizzas
FROM pizza_types_dim JOIN pizzas_dim
ON pizza_types_dim.pizza_type_id = pizzas_dim.pizza_type_id
JOIN order_details_dim
ON order_details_dim.pizza_id = pizzas_dim.pizza_id
GROUP BY pizza_types_dim.name
ORDER BY top_selling_pizzas DESC
LIMIT 3

--

SELECT pizza_types_dim.name, SUM(pizzas_dim.price * order_details_dim.quantity) AS top_selling_pizzas
FROM pizza_types_dim JOIN pizzas_dim
ON pizza_types_dim.pizza_type_id = pizzas_dim.pizza_type_id
JOIN order_details_dim
ON order_details_dim.pizza_id = pizzas_dim.pizza_id
GROUP BY pizza_types_dim.name
ORDER BY top_selling_pizzas ASC
LIMIT 3

--



