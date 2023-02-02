# 🍕 Case Study #2: Pizza Runner
![image](https://user-images.githubusercontent.com/85982220/216307691-5613a630-8264-4f72-bfc8-6d32d8473241.png)


[Case study source](https://8weeksqlchallenge.com/case-study-2/)


## Introduction
Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”


Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!


Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.


## Problem Statement
### Available Data
Danny has prepared for us an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations.

All datasets exist within the pizza_runner database schema - be sure to include this reference within your SQL scripts as you start exploring the data and answering the case study questions.


Danny has shared with you 6 key datasets for this case study:
- runners: The table shows the registration_date for each new runner
- customer_orders: Customer pizza orders are captured in the customer_orders table with 1 row for each individual pizza that is part of the order.
- runner_orders: After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer.
- pizza_names: Contains the name of the pizza currently available at the store
- pizza_recipes: Each pizza_id has a standard set of toppings which are used as part of the pizza recipe.
- pizza_toppings: This table contains all of the topping_name values with their corresponding topping_id value


![image](https://user-images.githubusercontent.com/85982220/216308699-558a2bd4-53f4-40db-a9ff-23aec64fd2f5.png)


### Data cleaning
#### customer_orders table


As we can see, there are text values like '' and 'null' in the exclusions and extras columns. We need to convert these 2 values to NULL value.


| exclusions | extras  |
|------------|---------|
|            |         |
|            |         |
|            |         |
|            | NULL    |
| 4          |         |
| 4          |         |
| 4          |         |
| null       | 1       |
| null       | null    |
| null       | 1       |
| null       | null    |
| 4          | 1, 5    |
| null       | null    |
| 2, 6       | 1, 4    |


#### runner_orders table
- The text values '' and 'null' in the pickup_time, distance, duration and cancellation columns need to be cconverted to NULL value.
- In the distance column, we need to remove the 'km' string and convert the column format to float.
- In the duration column, distance column, the 'minutes', 'mins' 'minute' must be stripped and and the column format will be float.
In the cancellation column, there are blank spaces and null values.

| pickup_time         | distance | duration   | cancellation             |
|---------------------|----------|------------|--------------------------|
| 2020-01-01 18:15:34 | 20km     | 32 minutes |                          |
| 2020-01-01 19:10:54 | 20km     | 27 minutes |                          |
| 2020-01-03 00:12:37 | 13.4km   | 20 mins    | NULL                     |
| 2020-01-04 13:53:03 | 23.4     | 40         | NULL                     |
| 2020-01-08 21:10:57 | 10       | 15         | NULL                     |
| null                | null     | null       | Restaurant Cancellation  |
| 2020-01-08 21:30:45 | 25km     | 25mins     | null                     |
| 2020-01-10 00:15:02 | 23.4 km  | 15 minute  | null                     |
| null                | null     | null       | Customer Cancellation    |
| 2020-01-11 18:50:20 | 10km     | 10minutes  | null                     |



## Case Study Questions
This case study has LOTS of questions - they are broken up by area of focus including:
- Pizza Metrics
- Runner and Customer Experience
- Ingredient Optimisation
- Pricing and Ratings
- Bonus DML Challenges (DML = Data Manipulation Language)


### A. Pizza Metrics
1. How many pizzas were ordered?
How many unique customer orders were made?
How many successful orders were delivered by each runner?
How many of each type of pizza was delivered?
How many Vegetarian and Meatlovers were ordered by each customer?
What was the maximum number of pizzas delivered in a single order?
For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
How many pizzas were delivered that had both exclusions and extras?
What was the total volume of pizzas ordered for each hour of the day?
What was the volume of orders for each day of the week?
### B. Runner and Customer Experience
How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
Is there any relationship between the number of pizzas and how long the order takes to prepare?
What was the average distance travelled for each customer?
What was the difference between the longest and shortest delivery times for all orders?
What was the average speed for each runner for each delivery and do you notice any trend for these values?
What is the successful delivery percentage for each runner?
### C. Ingredient Optimisation
What are the standard ingredients for each pizza?
What was the most commonly added extra?
What was the most common exclusion?
Generate an order item for each record in the customers_orders table in the format of one of the following:
Meat Lovers
Meat Lovers - Exclude Beef
Meat Lovers - Extra Bacon
Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
### D. Pricing and Ratings
If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
What if there was an additional $1 charge for any pizza extras?
Add cheese is $1 extra
The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
customer_id
order_id
runner_id
rating
order_time
pickup_time
Time between order and pickup
Delivery duration
Average speed
Total number of pizzas
If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
## Bonus Questions
If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?

## Solution
[Click here](https://github.com/linhdan2109/Portfolio_Projects/blob/main/8-Week-SQL-Challenge/Case%20Study%20%232%20-%20Pizza%20Runner/Case%202%20-%20Solution.md) to view my solution of this case study!
[Click here](https://github.com/linhdan2109/Portfolio_Projects/blob/main/8-Week-SQL-Challenge/Case%20Study%20%232%20-%20Pizza%20Runner/Case%202%20-%20SQLcode.sql) to get my SQL code file for the solution of this case study!
[Click here](https://github.com/linhdan2109/Portfolio_Projects/blob/main/8-Week-SQL-Challenge/Case%20Study%20%232%20-%20Pizza%20Runner/Case%202%20-%20Data.sql) to get the SQL file comtains the data of this case study!
