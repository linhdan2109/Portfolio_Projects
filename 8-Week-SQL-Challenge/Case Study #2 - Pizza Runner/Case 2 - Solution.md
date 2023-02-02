# Case Study #2: Solution
## Table of contents:


[DATA CLEANING](#DC)


[A. PIZZA METRICS](#A)


[B. RUNNER AND CUSTOMER EXPERIENCE](#B)


[C. INGREDIENT OPTIMISATION](#C)


[D. PRICING AND RATINGS](#D)


## Data cleaning <a name="DC"></a>
### 1. customer_orders table
- There are text values like '' and 'null' in the exclusions and extras columns. We need to convert these 2 values to NULL value.
- Create a view that contain the copy of the customer_orders table in order to clean and prevent loss of data.
```sql
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
```
#### Original table:


![image](https://user-images.githubusercontent.com/85982220/216330684-002af5cb-02c1-4bd7-8c91-f78466bb5952.png)


#### Cleaned view:


![image](https://user-images.githubusercontent.com/85982220/216330772-f8376c29-9f48-4148-bc47-e7eaf4260441.png)


### 2. runner_orders table
- Convert the text values '' and 'null' in the pickup_time, distance, duration and cancellation columns to NULL value.
- Change the data type of pickup_time column from VARCHAR to DATETIME
- Remove the 'km' and convert the column format to FLOAT in the distance column.
- Remove the 'minutes', 'mins' 'minute' and change the column format to FLOAT.
```sql
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
```
#### Original table:


![image](https://user-images.githubusercontent.com/85982220/216331980-2a265ff8-e9e8-40c8-82d5-279be8c65753.png)


#### Cleaned view:


![image](https://user-images.githubusercontent.com/85982220/216332151-bd026002-e4de-404c-8108-cb07cf14cd73.png)


## A. PIZZA METRICS <a name="A"></a>
### 1. How many pizzas were ordered?
```sql
SELECT COUNT(*) AS total_pizzas_ordered 
FROM customer_orders_clean;
```
#### Result:
| total_pizzas_ordered  |
|-----------------------|
| 14                    |

### 2. How many unique customer orders were made?
```sql
SELECT COUNT(DISTINCT order_id) AS total_unique_ordered 
FROM customer_orders_clean;
```
#### Result:
| total_unique_ordered  |
|-----------------------|
| 10                    |


### 3. How many successful orders were delivered by each runner?
```sql
SELECT 
	runner_id,
	COUNT(*) AS successful_orders
FROM runner_orders_clean
WHERE cancellation IS NULL
GROUP BY runner_id
ORDER BY runner_id;
```
#### Result:

| runner_id | successful_orders  |
|-----------|--------------------|
| 1         | 4                  |
| 2         | 3                  |
| 3         | 1                  |

### 4. How many of each type of pizza was delivered?
```sql
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
```
#### Result:
| pizza_id | pizza_name | pizza_delivered  |
|----------|------------|------------------|
| 1        | Meatlovers | 9                |
| 2        | Vegetarian | 3                |

### 5. How many Vegetarian and Meatlovers were ordered by each customer?
```sql
SELECT 
	c.customer_id, 
	COUNT(CASE WHEN p.pizza_name LIKE 'Meatlovers' THEN 1 ELSE NULL END) AS Meatlovers,
	COUNT(CASE WHEN p.pizza_name LIKE 'Vegetarian' THEN 1 ELSE NULL END) AS Vegetarian
FROM customer_orders_clean c
JOIN pizza_names p ON c.pizza_id= p.pizza_id
GROUP BY customer_id
ORDER BY customer_id;
```
#### Result:
| customer_id | Meatlovers | Vegetarian  |
|-------------|------------|-------------|
| 101         | 2          | 1           |
| 102         | 2          | 1           |
| 103         | 3          | 1           |
| 104         | 3          | 0           |
| 105         | 0          | 1           |

### 6. What was the maximum number of pizzas delivered in a single order?
```sql
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
```
#### Result:
| maximum_number_pizzas_in_a_order  |
|-----------------------------------|
| 3                                 |

### 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
```sql
SELECT 
	c.customer_id,
	COUNT(CASE WHEN c.exclusions IS NULL AND c.extras IS NULL THEN 1 ELSE NULL END) AS no_change,
	COUNT(CASE WHEN NOT(c.exclusions IS NULL AND c.extras IS NULL) THEN 1 ELSE NULL END) AS at_least_1_change
FROM customer_orders_clean c
JOIN runner_orders_clean r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY customer_id
ORDER BY customer_id;
```
#### Result:
| customer_id | no_change | at_least_1_change  |
|-------------|-----------|--------------------|
| 101         | 2         | 0                  |
| 102         | 3         | 0                  |
| 103         | 0         | 3                  |
| 104         | 1         | 2                  |
| 105         | 0         | 1                  |

### 8. How many pizzas were delivered that had both exclusions and extras?
```sql
SELECT 
	COUNT(CASE WHEN c.exclusions IS NOT NULL AND c.extras IS NOT NULL THEN 1 ELSE NULL END) AS both_exclusions_and_extras
FROM customer_orders_clean c
JOIN runner_orders_clean r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL;
```
#### Result:
| both_exclusions_and_extras  |
|-----------------------------|
| 1                           |

### 9. What was the total volume of pizzas ordered for each hour of the day?
```sql
SELECT 
	DATEPART(hour, order_time) AS hour,
	COUNT(*) AS total_pizza
FROM customer_orders_clean
GROUP BY DATEPART(hour, order_time)
ORDER BY DATEPART(hour, order_time);
```
#### Result:
| hour | total_pizza  |
|------|--------------|
| 11   | 1            |
| 13   | 3            |
| 18   | 3            |
| 19   | 1            |
| 21   | 3            |
| 23   | 3            |

### 10. What was the volume of orders for each day of the week?
```sql
SELECT 
	DATEPART(dw, order_time) AS weekday,
	COUNT(*) AS total_pizza
FROM customer_orders_clean
GROUP BY DATEPART(dw, order_time)
ORDER BY DATEPART(dw, order_time);
```
#### Result:
| weekday | total_pizza  |
|---------|--------------|
| 4       | 5            |
| 5       | 3            |
| 6       | 1            |
| 7       | 5            |

## B. RUNNER AND CUSTOMER EXPERIENCE <a name="B"></a>
### 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
```sql
SELECT 
	DATEPART(ww, registration_date) AS registration_week,
	COUNT(*) AS total_runner_sign_up
FROM runners
GROUP BY DATEPART(ww, registration_date)
ORDER BY DATEPART(ww, registration_date);
```
#### Result:
| registration_week | total_runner_sign_up  |
|-------------------|-----------------------|
| 1                 | 1                     |
| 2                 | 2                     |
| 3                 | 1                     |

### 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
```sql
SELECT 
	r.runner_id,
	AVG(DATEDIFF(minute, c.order_time, r.pickup_time)) AS avg_time
FROM customer_orders_clean c
JOIN runner_orders_clean r ON c.order_id = r.order_id
GROUP BY r.runner_id
ORDER BY r.runner_id;
```
#### Result:
| runner_id | avg_time  |
|-----------|-----------|
| 1         | 15        |
| 2         | 24        |
| 3         | 10        |

### 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
```sql
SELECT 
	c.order_id,
	AVG(DATEDIFF(minute, c.order_time, r.pickup_time)) AS avg_time,
	COUNT(*) AS num_pizza
FROM customer_orders_clean c
JOIN runner_orders_clean r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY c.order_id
ORDER BY COUNT(*);
```
#### Result:
| order_id | avg_time | num_pizza  |
|----------|----------|------------|
| 1        | 10       | 1          |
| 2        | 10       | 1          |
| 5        | 10       | 1          |
| 7        | 10       | 1          |
| 8        | 21       | 1          |
| 10       | 16       | 2          |
| 3        | 21       | 2          |
| 4        | 30       | 3          |

### 4. What was the average distance travelled for each customer?
```sql
SELECT
	c.customer_id,
	AVG(r.distance) AS avg_distance
FROM customer_orders_clean c
JOIN runner_orders_clean r ON c.order_id = r.order_id
GROUP BY c.customer_id
ORDER BY c.customer_id;
```
#### Reslut:
| customer_id | avg_distance      |
|-------------|-------------------|
| 101         | 20                |
| 102         | 16.7333333333333  |
| 103         | 23.4              |
| 104         | 10                |
| 105         | 25                |

### 5. What was the difference between the longest and shortest delivery times for all orders?
```sql
SELECT 
	MAX(duration) - MIN(duration) AS difference
FROM runner_orders_clean;
```
#### Result:
| difference  |
|-------------|
| 30          |

### 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
```sql
SELECT
	order_id,
	runner_id,
	ROUND(distance/(duration/60), 2) AS speed_kmh
FROM runner_orders_clean
WHERE cancellation IS NULL
ORDER BY order_id, runner_id;
```
#### Result:
| order_id | runner_id | speed_kmh  |
|----------|-----------|------------|
| 1        | 1         | 37.5       |
| 2        | 1         | 44.44      |
| 3        | 1         | 40.2       |
| 4        | 2         | 35.1       |
| 5        | 3         | 40         |
| 7        | 2         | 60         |
| 8        | 2         | 93.6       |
| 10       | 1         | 60         |

### 7. What is the successful delivery percentage for each runner?
```sql
SELECT
	runner_id,
	CONCAT(CAST(COUNT(CASE WHEN cancellation IS NULL THEN 1 ELSE NULL END) AS FLOAT)/CAST(COUNT(*) AS FLOAT)*100, '%')  AS successful_percentage
FROM runner_orders_clean
GROUP BY runner_id
ORDER BY runner_id;
```
#### Result:
| runner_id | successful_percentage  |
|-----------|------------------------|
| 1         | 100%                   |
| 2         | 75%                    |
| 3         | 50%                    |

## C. INGREDIENT OPTIMISATION <a name="C"></a>
### Create a view that Split toppings field in the pizza_recipes
```sql
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
```
#### Original table:


![image](https://user-images.githubusercontent.com/85982220/216337139-d9c2bd14-3798-4459-9a3f-0fc741714f01.png)


#### Splitted view:


![image](https://user-images.githubusercontent.com/85982220/216337328-f8188d19-2916-4f93-9b71-61d33645ddef.png)


### 1.What are the standard ingredients for each pizza?
```sql
SELECT 
	pr.pizza_id,
	pn.pizza_name,
	pt.topping_name
FROM pizza_recipes_split pr
JOIN pizza_toppings pt ON pr.topping_id= pt.topping_id
JOIN pizza_names pn ON pr.pizza_id = pn.pizza_id
ORDER BY pizza_id;
```
#### Result:
| pizza_id | pizza_name | topping_name  |
|----------|------------|---------------|
| 1        | Meatlovers | Bacon         |
| 1        | Meatlovers | BBQ Sauce     |
| 1        | Meatlovers | Beef          |
| 1        | Meatlovers | Cheese        |
| 1        | Meatlovers | Chicken       |
| 1        | Meatlovers | Mushrooms     |
| 1        | Meatlovers | Pepperoni     |
| 1        | Meatlovers | Salami        |
| 2        | Vegetarian | Cheese        |
| 2        | Vegetarian | Mushrooms     |
| 2        | Vegetarian | Onions        |
| 2        | Vegetarian | Peppers       |
| 2        | Vegetarian | Tomatoes      |
| 2        | Vegetarian | Tomato Sauce  |

### 2. What was the most commonly added extra?
```sql
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
```

#### Result:
| most_added_extra | times_add  |
|------------------|------------|
| Bacon            | 4          |

### 3. What was the most common exclusion?
```sql
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
```
#### Result:
| most_added_exclusion | times_add  |
|----------------------|------------|
| Cheese               | 4          |

### 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
  - Meat Lovers
  - Meat Lovers - Exclude Beef
  - Meat Lovers - Extra Bacon
  - Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
```sql

```

### 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
  -  For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
```sql

```

### 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
- Note that: total quantity of each ingredient used = toppings in a regular pizza - exclusions + extras
```sql
WITH CTE AS
(
-- toppings in a regular pizza - exclusions
	SELECT
		pr.topping_id
	FROM pizza_recipes_split pr
	JOIN customer_orders c ON pr.pizza_id = c.pizza_id
	JOIN runner_orders_clean r ON c.order_id = r.order_id
	WHERE r.cancellation IS NULL 
	  AND pr.topping_id NOT IN (SELECT value 
                                    FROM (SELECT
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
```
#### Result:
| topping_name | total_quantity  |
|--------------|-----------------|
| Bacon        | 13              |
| Mushrooms    | 11              |
| Cheese       | 10              |
| Chicken      | 10              |
| Pepperoni    | 9               |
| Salami       | 9               |
| Beef         | 9               |
| BBQ Sauce    | 8               |
| Peppers      | 3               |
| Onions       | 3               |
| Tomato Sauce | 3               |
| Tomatoes     | 3               |

## D. PRICING AND RATINGS <a name="D"></a>
### 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes. How much money has Pizza Runner made so far if there are no delivery fees?
```sql
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
```
#### Result:
| total_money  |
|--------------|
| 138          |

### 2. What if there was an additional $1 charge for any pizza extras?
  - Ex: Add cheese is $1 extra
```sql
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
```
#### Result:
| total_money  |
|--------------|
| 142          |

### 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner. Design an additional table for this new dataset.  Generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
```sql
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
```
```sql
SELECT *
FROM runner_rating;
``` 
#### Result:
| order_id | rating | comment       |
|----------|--------|---------------|
| 1        | 3      |               |
| 2        | 5      | Good          |
| 3        | 2      | Long wait     |
| 4        | 3      | Cold food     |
| 5        | 5      |               |
| 7        | 5      |               |
| 8        | 1      | Bad attitude  |
| 10       | 4      | Great         |

### 4. Using your newly generated table - join all of the information together to form a table which has the following information for successful deliveries.
  - customer_id
  - order_id
  - runner_id
  - rating
  - order_time
  - pickup_time
  - Time between order and pickup
  - Delivery duration
  - Average speed
  - Total number of pizzas
```sql
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
```
#### Result:
| order_id | customer_id | runner_id | rating | order_time              | pickup_time             | time_between_order_and_pickup | duration | speed_kmh | total_pizzas_per_order  |
|----------|-------------|-----------|--------|-------------------------|-------------------------|-------------------------------|----------|-----------|-------------------------|
| 1        | 101         | 1         | 3      | 2020-01-01 18:05:02.000 | 2020-01-01 18:15:34.000 | 10                            | 32       | 37.5      | 1                       |
| 2        | 101         | 1         | 5      | 2020-01-01 19:00:52.000 | 2020-01-01 19:10:54.000 | 10                            | 27       | 44.44     | 1                       |
| 3        | 102         | 1         | 2      | 2020-01-02 23:51:23.000 | 2020-01-03 00:12:37.000 | 21                            | 20       | 40.2      | 2                       |
| 3        | 102         | 1         | 2      | 2020-01-02 23:51:23.000 | 2020-01-03 00:12:37.000 | 21                            | 20       | 40.2      | 2                       |
| 4        | 103         | 2         | 3      | 2020-01-04 13:23:46.000 | 2020-01-04 13:53:03.000 | 30                            | 40       | 35.1      | 3                       |
| 4        | 103         | 2         | 3      | 2020-01-04 13:23:46.000 | 2020-01-04 13:53:03.000 | 30                            | 40       | 35.1      | 3                       |
| 4        | 103         | 2         | 3      | 2020-01-04 13:23:46.000 | 2020-01-04 13:53:03.000 | 30                            | 40       | 35.1      | 3                       |
| 5        | 104         | 3         | 5      | 2020-01-08 21:00:29.000 | 2020-01-08 21:10:57.000 | 10                            | 15       | 40        | 1                       |
| 7        | 105         | 2         | 5      | 2020-01-08 21:20:29.000 | 2020-01-08 21:30:45.000 | 10                            | 25       | 60        | 1                       |
| 8        | 102         | 2         | 1      | 2020-01-09 23:54:33.000 | 2020-01-10 00:15:02.000 | 21                            | 15       | 93.6      | 1                       |
| 10       | 104         | 1         | 4      | 2020-01-11 18:34:49.000 | 2020-01-11 18:50:20.000 | 16                            | 10       | 60        | 2                       |
| 10       | 104         | 1         | 4      | 2020-01-11 18:34:49.000 | 2020-01-11 18:50:20.000 | 16                            | 10       | 60        | 2                       |


### 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled . How much money does Pizza Runner have left over after these deliveries?
```sql
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
```
#### Result:
| afterdelivery_money  |
|----------------------|
| 94.44                |

