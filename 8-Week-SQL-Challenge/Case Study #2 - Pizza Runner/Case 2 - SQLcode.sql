----------------------------------
-- CASE STUDY #2: PIZZA RUNNER --
-- Tool used: MS SQL Server

----------------------------------
-- ANSWER CASE STUDY QUESTIONS --
----------------------------------

-- DATA CLEANING
-- 1. customer_orders table
-- NULL values: exclusions & extras columns
-- Create a view to prevent data loss
DROP VIEW IF EXISTS customer_orders_clean;
GO
CREATE VIEW customer_orders_clean
AS
SELECT
	order_id,
	customer_id,
    pizza_id,
	CASE WHEN exclusions = '' OR exclusions = 'null' THEN NULL ELSE exclusions END AS exclusions,
	CASE WHEN extras = '' OR extras = 'null' THEN NULL ELSE extras END AS extras,
	order_time
FROM customer_orders;
GO

-- 2. runner_orders table
-- NULL values: pickup_time, distance, duration & cancellation columns
-- Data type: transform pickup_time colunm to DATETIME type
-- Remove characters in  distance & duration colunms and change the datatype into float
-- Create a view to prevent data loss
DROP VIEW IF EXISTS runner_orders_clean;
GO
CREATE VIEW runner_orders_clean
AS
SELECT 
	order_id,
	runner_id,
	CAST(
		 CASE 
			WHEN pickup_time = '' OR pickup_time = 'null' THEN NULL 
			ELSE pickup_time 
		 END	
		 AS DATETIME
		 ) AS pickup_time,
	CAST(	
		CASE
			WHEN distance = '' OR distance = 'null' THEN NULL 
			WHEN distance LIKE '%km%' THEN TRIM('km ' FROM distance)
			ELSE distance 
		END
		AS FLOAT
		) AS distance,
	CAST(
		 CASE 
			WHEN duration = '' OR duration = 'null' THEN NULL 
			WHEN duration LIKE '%min%' THEN TRIM('minutes ' FROM duration)
			ELSE duration
		 END
		 AS FLOAT
		)AS duration,
	CASE WHEN cancellation = '' OR cancellation = 'null' THEN NULL ELSE cancellation END AS cancellation
FROM runner_orders;
GO

-- A. PIZZA METRICS
-- 1. How many pizzas were ordered?
SELECT COUNT(*) AS total_pizzas_ordered 
FROM customer_orders_clean;

-- 2. How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS total_unique_ordered 
FROM customer_orders_clean;

-- 3. How many successful orders were delivered by each runner?
SELECT 
	runner_id,
	COUNT(*) AS successful_orders
FROM runner_orders_clean
WHERE cancellation IS NULL
GROUP BY runner_id
ORDER BY runner_id;

-- 4. How many of each type of pizza was delivered?
SELECT 
	p.pizza_id,
	CAST(p.pizza_name AS NVARCHAR(100)) AS pizza_name,
	COUNT(*) AS pizza_delivered
FROM customer_orders_clean c
JOIN runner_orders_clean r ON c.order_id = r.order_id
JOIN pizza_names p ON c.pizza_id = p.pizza_id
WHERE r.cancellation IS NULL
GROUP BY p.pizza_id, CAST(p.pizza_name AS NVARCHAR(100))
ORDER BY p.pizza_id;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT 
	c.customer_id, 
	COUNT(CASE WHEN p.pizza_name LIKE 'Meatlovers' THEN 1 ELSE NULL END) AS Meatlovers,
	COUNT(CASE WHEN p.pizza_name LIKE 'Vegetarian' THEN 1 ELSE NULL END) AS Vegetarian
FROM customer_orders_clean c
JOIN pizza_names p ON c.pizza_id= p.pizza_id
GROUP BY customer_id
ORDER BY customer_id;

-- 6. What was the maximum number of pizzas delivered in a single order?
SELECT 
	MAX(pizza_delivered) AS maximum_number_pizzas_in_a_order
FROM
(
	SELECT 
		c.order_id,
		COUNT(*) AS pizza_delivered
	FROM customer_orders_clean c
	JOIN runner_orders_clean r ON c.order_id = r.order_id
	WHERE r.cancellation IS NULL
	GROUP BY c.order_id
) temp

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT 
	c.customer_id,
	COUNT(CASE WHEN c.exclusions IS NULL AND c.extras IS NULL THEN 1 ELSE NULL END) AS no_change,
	COUNT(CASE WHEN NOT(c.exclusions IS NULL AND c.extras IS NULL) THEN 1 ELSE NULL END) AS at_least_1_change
FROM customer_orders_clean c
JOIN runner_orders_clean r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY customer_id
ORDER BY customer_id;

-- 8. How many pizzas were delivered that had both exclusions and extras?
SELECT 
	COUNT(CASE WHEN c.exclusions IS NOT NULL AND c.extras IS NOT NULL THEN 1 ELSE NULL END) AS both_exclusions_and_extras
FROM customer_orders_clean c
JOIN runner_orders_clean r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL

-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT 
	DATEPART(hour, order_time) AS hour,
	COUNT(*) AS total_pizza
FROM customer_orders_clean
GROUP BY DATEPART(hour, order_time)
ORDER BY DATEPART(hour, order_time);

-- 10. What was the volume of orders for each day of the week?
SELECT 
	DATEPART(dw, order_time) AS weekday,
	COUNT(*) AS total_pizza
FROM customer_orders_clean
GROUP BY DATEPART(dw, order_time)
ORDER BY DATEPART(dw, order_time);

-- B. RUNNER AND CUSTOMER EXPERIENCE
-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT 
	DATEPART(ww, registration_date) AS registration_week,
	COUNT(*) AS total_runner_sign_up
FROM runners
GROUP BY DATEPART(ww, registration_date)
ORDER BY DATEPART(ww, registration_date);

-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SELECT 
	r.runner_id,
	AVG(DATEDIFF(minute, c.order_time, r.pickup_time)) AS avg_time
FROM customer_orders_clean c
JOIN runner_orders_clean r ON c.order_id = r.order_id
GROUP BY r.runner_id
ORDER BY r.runner_id;

-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
SELECT 
	c.order_id,
	AVG(DATEDIFF(minute, c.order_time, r.pickup_time)) AS avg_time,
	COUNT(*) AS num_pizza
FROM customer_orders_clean c
JOIN runner_orders_clean r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY c.order_id
ORDER BY COUNT(*);

-- 4. What was the average distance travelled for each customer?
SELECT
	c.customer_id,
	AVG(r.distance) AS avg_distance
FROM customer_orders_clean c
JOIN runner_orders_clean r ON c.order_id = r.order_id
GROUP BY c.customer_id
ORDER BY c.customer_id;

-- 5. What was the difference between the longest and shortest delivery times for all orders?
SELECT 
	MAX(duration) - MIN(duration) AS difference
FROM runner_orders_clean;

-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT
	order_id,
	runner_id,
	ROUND(distance/(duration/60), 2) AS speed_kmh
FROM runner_orders_clean
WHERE cancellation IS NULL
ORDER BY order_id, runner_id;

-- 7. What is the successful delivery percentage for each runner?
SELECT
	runner_id,
	CONCAT(CAST(COUNT(CASE WHEN cancellation IS NULL THEN 1 ELSE NULL END) AS FLOAT)/CAST(COUNT(*) AS FLOAT)*100, '%')  AS successful_percentage
FROM runner_orders_clean
GROUP BY runner_id
ORDER BY runner_id;
GO

-- C. INGREDIENT OPTIMISATION
-- Create a view that Split toppings field in the pizza_recipes
DROP VIEW IF EXISTS pizza_recipes_split;
GO
CREATE VIEW pizza_recipes_split
AS
SELECT 
	pizza_id,
	value AS topping_id
FROM pizza_recipes
CROSS APPLY STRING_SPLIT(REPLACE(CAST(toppings AS nvarchar(50)), ' ',''), ',');
GO
-- 1.What are the standard ingredients for each pizza?
SELECT 
	pr.pizza_id,
	pn.pizza_name,
	pt.topping_name
FROM pizza_recipes_split pr
JOIN pizza_toppings pt ON pr.topping_id= pt.topping_id
JOIN pizza_names pn ON pr.pizza_id = pn.pizza_id
ORDER BY pizza_id;

-- 2. What was the most commonly added extra?
SELECT TOP 1
	CAST(pt.topping_name AS nvarchar(50)) AS most_added_extra,
	COUNT(temp.extra_topping_id) AS times_add
FROM
(
	SELECT 
		value AS extra_topping_id
	FROM customer_orders_clean
	CROSS APPLY STRING_SPLIT(REPLACE(CAST(extras AS nvarchar(50)), ' ',''), ',')
) temp
JOIN pizza_toppings pt ON temp.extra_topping_id= pt.topping_id
GROUP BY CAST(pt.topping_name AS nvarchar(50))
ORDER BY COUNT(temp.extra_topping_id) DESC;

-- 3. What was the most common exclusion?
SELECT TOP 1
	CAST(pt.topping_name AS nvarchar(50)) AS most_added_exclusion,
	COUNT(temp.exclusion_topping_id) AS times_add
FROM
(
	SELECT 
		value AS exclusion_topping_id
	FROM customer_orders_clean
	CROSS APPLY STRING_SPLIT(REPLACE(CAST(exclusions AS nvarchar(50)), ' ',''), ',')
) temp
JOIN pizza_toppings pt ON temp.exclusion_topping_id= pt.topping_id
GROUP BY CAST(pt.topping_name AS nvarchar(50))
ORDER BY COUNT(temp.exclusion_topping_id) DESC;


-- 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
-- total quantity = toppings in a regular pizza - exclusions + extras
WITH CTE AS
(
-- toppings in a regular pizza - exclusions
	SELECT
		pr.topping_id
	FROM pizza_recipes_split pr
	JOIN customer_orders c ON pr.pizza_id = c.pizza_id
	JOIN runner_orders_clean r ON c.order_id = r.order_id
	WHERE r.cancellation IS NULL 
		AND pr.topping_id NOT IN (SELECT value FROM
								   (SELECT
										order_id,
										exclusions,
										value
									FROM customer_orders_clean
									CROSS APPLY STRING_SPLIT(REPLACE(CAST(exclusions AS nvarchar(50)), ' ',''), ',')) temp
									WHERE temp.exclusions = c.exclusions AND temp.order_id = c.order_id)
-- + extras
	UNION ALL
	SELECT 
		value AS extra_topping_id
	FROM customer_orders_clean
	CROSS APPLY STRING_SPLIT(REPLACE(CAST(extras AS nvarchar(50)), ' ',''), ',')
) 
SELECT
	CAST(pt.topping_name AS nvarchar(50)) AS topping_name,
	COUNT(CTE.topping_id) AS total_quantity
FROM CTE 
JOIN pizza_toppings pt ON CTE.topping_id = pt.topping_id
GROUP BY CAST(pt.topping_name AS nvarchar(50))
ORDER BY COUNT(CTE.topping_id) DESC;


-- D. PRICING AND RATINGS
-- 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes 
-- how much money has Pizza Runner made so far if there are no delivery fees?
SELECT
	SUM(
		CASE
			WHEN CAST(p.pizza_name AS nvarchar(50)) = 'Meatlovers' THEN 12 
			WHEN CAST(p.pizza_name AS nvarchar(50)) = 'Vegetarian' THEN 10
		END
		) AS total_money
FROM customer_orders_clean c
JOIN runner_orders_clean r ON c.order_id = r.order_id
JOIN pizza_names p ON p.pizza_id = c.pizza_id
WHERE r.cancellation IS NULL;

-- 2. What if there was an additional $1 charge for any pizza extras?
-- Ex: Add cheese is $1 extra
SELECT
	SUM(pizza_money +  extra_money) AS total_money
FROM
(
	SELECT
		SUM(
			CASE
				WHEN CAST(p.pizza_name AS nvarchar(50)) = 'Meatlovers' THEN 12 
				WHEN CAST(p.pizza_name AS nvarchar(50)) = 'Vegetarian' THEN 10
			END
			) AS pizza_money,
		SUM(1 + LEN(extras) - LEN(REPLACE(extras, ',', ''))) AS extra_money
	FROM customer_orders_clean c
	JOIN runner_orders_clean r ON c.order_id = r.order_id
	JOIN pizza_names p ON p.pizza_id = c.pizza_id
	WHERE r.cancellation IS NULL
) temp;


-- 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner.
-- Design an additional table for this new dataset. 
-- Generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
DROP TABLE IF EXISTS runner_rating;
CREATE TABLE runner_rating
(
	order_id int,
	rating int CHECK(rating > 0 AND rating < 6),
	comment varchar(255)
);
INSERT INTO runner_rating
VALUES
(1, 3, ''),
(2, 5, 'Good'),
(3, 2, 'Long wait'),
(4, 3, 'Cold food'),
(5, 5, ''),
(7, 5, ''),
(8, 1, 'Bad attitude'),
(10, 4, 'Great');

SELECT *
FROM runner_rating;


-- 4. Using your newly generated table - join all of the information together to form a table which has the following information for successful deliveries.
-- customer_id
-- order_id
-- runner_id
-- rating
-- order_time
-- pickup_time
-- Time between order and pickup
-- Delivery duration
-- Average speed
-- Total number of pizzas

SELECT 
	coc.order_id,
	coc.customer_id,
	roc.runner_id,
	rr.rating,
	coc.order_time,
	roc.pickup_time,
	DATEDIFF (minute, coc.order_time, roc.pickup_time) AS time_between_order_and_pickup,
	roc.duration,
	ROUND(roc.distance/(roc.duration/60), 2) AS speed_kmh,
	COUNT(*) OVER (PARTITION BY coc.order_id) AS total_pizzas_per_order
FROM customer_orders_clean coc
JOIN runner_orders_clean roc ON coc.order_id = roc.order_id
JOIN runner_rating rr ON coc.order_id = rr.order_id
WHERE roc.cancellation IS NULL
ORDER BY coc.order_id;


-- 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled 
-- how much money does Pizza Runner have left over after these deliveries?
WITH CTE AS 
(
	SELECT
		c.order_id,
		p.pizza_name,
		distance,
		ROW_NUMBER() OVER (PARTITION BY c.order_id ORDER BY c.order_id) AS row_num_by_order_id
	FROM customer_orders_clean c
	JOIN runner_orders_clean r ON c.order_id = r.order_id
	JOIN pizza_names p ON p.pizza_id = c.pizza_id
	WHERE r.cancellation IS NULL
)
SELECT
	pizza_money - shipping_fee AS afterdelivery_money
FROM
(
	SELECT
		SUM(
			CASE
				WHEN CAST(pizza_name AS nvarchar(50)) = 'Meatlovers' THEN 12
				WHEN CAST(pizza_name AS nvarchar(50))= 'Vegetarian' THEN 10
			END
			) AS pizza_money,
		SUM(
			CASE
				WHEN row_num_by_order_id > 1 THEN 0
				ELSE distance * 0.3
			END
			) AS shipping_fee
	FROM CTE
) temp;
