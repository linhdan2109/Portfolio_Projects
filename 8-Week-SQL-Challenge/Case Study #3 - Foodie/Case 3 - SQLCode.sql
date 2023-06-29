-- B. Data Analysis Questions
-- 1. How many customers has Foodie-Fi ever had?
SELECT 
	COUNT(DISTINCT customer_id) AS total_customers
FROM subscriptions;

-- 2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
SELECT
	DATEPART(month, s.start_date) AS month,
	COUNT(*) AS monthly_distribution
FROM subscriptions s
JOIN plans p ON s.plan_id = p.plan_id
WHERE p.plan_name = 'trial'
GROUP BY DATEPART(month, start_date)
ORDER BY DATEPART(month, start_date);

-- 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
SELECT
	p.plan_id,
	p.plan_name,
	COUNT(*) AS count_of_event
FROM subscriptions s
JOIN plans p ON s.plan_id = p.plan_id
WHERE DATEPART(year, s.start_date) > 2020
GROUP BY p.plan_id, p.plan_name
ORDER BY p.plan_id;

-- 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
SELECT
	COUNT(CASE WHEN p.plan_name = 'churn' THEN 1 ELSE NULL END) AS number_customer_churned,
	ROUND(
		CAST(COUNT(CASE WHEN p.plan_name = 'churn' THEN 1 ELSE NULL END)*100 AS float)/
		CAST(COUNT(DISTINCT s.customer_id) AS float)
		, 2) AS percentage_customer_churned
FROM subscriptions s
JOIN plans p ON s.plan_id = p.plan_id;

-- 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
SELECT 
	COUNT(CASE WHEN plan_name = 'trial' AND next_plan = 'churn' THEN 1 ELSE NULL END) 
		AS number_customer_churned_after_trial,
	ROUND(
		CAST(COUNT(CASE WHEN plan_name = 'trial' AND next_plan = 'churn' THEN 1 ELSE NULL END)*100 AS float)/
		CAST(COUNT(DISTINCT customer_id) AS float)
		, 0)
		AS percentage_customer_churned_after_trial
FROM
(
	SELECT
		s.customer_id,
		p.plan_name,
		LEAD(p.plan_name) OVER (PARTITION BY s.customer_id ORDER BY s.start_date) AS next_plan
	FROM subscriptions s
	JOIN plans p ON s.plan_id = p.plan_id
) temp

-- 6. What is the number and percentage of customer plans after their initial free trial?
SELECT
	next_plan,
	ROUND(
		CAST(COUNT(DISTINCT customer_id)*100 AS float)/
		(SELECT CAST(COUNT(DISTINCT customer_id) AS FLOAT) FROM subscriptions)
		, 2) AS percentage_plans_after_trial
FROM
(	
	SELECT
		s.customer_id,
		p.plan_name,
		LEAD(p.plan_name) OVER (PARTITION BY s.customer_id ORDER BY s.start_date) AS next_plan
	FROM subscriptions s
	JOIN plans p ON s.plan_id = p.plan_id
) temp
WHERE plan_name = 'trial'
GROUP BY next_plan
ORDER BY CASE 
			WHEN next_plan = 'basic monthly' THEN 1
			WHEN next_plan = 'pro monthly' THEN 2
			WHEN next_plan = 'pro annual' THEN 3
			WHEN next_plan = 'churn' THEN 4
		END

-- 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
 WITH CTE AS
 (
	SELECT 
		s.customer_id,
		p.plan_id,
		p.plan_name,
		ROW_NUMBER () OVER (PARTITION BY s.customer_id ORDER BY s.start_date DESC) AS order_lastest_plan
	FROM subscriptions s
	JOIN plans p ON s.plan_id = p.plan_id
	WHERE s.start_date <= '2020-12-31'
 )
 SELECT 
	plan_id,
	plan_name,
	COUNT(*) AS customer_count,
	ROUND(
		CAST(COUNT(*) *100 AS float)/
		CAST((SELECT COUNT(DISTINCT customer_id) FROM subscriptions) AS float)
		,2) AS percentage_customer_count
 FROM CTE
 WHERE order_lastest_plan = 1
 GROUP BY plan_id, plan_name
 ORDER BY plan_id;

-- 8. How many customers have upgraded to an annual plan in 2020?
SELECT 
	p.plan_name,
	COUNT(DISTINCT s.customer_id) AS number_customer_upgraded
FROM subscriptions s
JOIN plans p ON s.plan_id = p.plan_id
WHERE p.plan_name = 'pro annual' AND DATEPART(year, s.start_date) = 2020
GROUP BY p.plan_name;

-- 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
SELECT
	AVG(days_from_trial_to_annual) AS avg_days_from_trial_to_annual
FROM
(
	SELECT 
		s_trial.customer_id,
		s_trial.start_date AS trial_start_date,
		s_annual.start_date AS annual_start_date,
		DATEDIFF(day, s_trial.start_date, s_annual.start_date) AS days_from_trial_to_annual
	FROM subscriptions s_trial
	JOIN plans p_trial ON s_trial.plan_id = p_trial.plan_id
	JOIN subscriptions s_annual ON s_annual.customer_id = s_trial.customer_id 
	JOIN plans p_annual ON s_annual.plan_id = p_annual.plan_id
	WHERE p_trial.plan_name = 'trial' AND p_annual.plan_name = 'pro annual'
) temp

-- 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
SELECT
	days_from_trial_to_annual/30 AS order_number,
	CONCAT((days_from_trial_to_annual/30)*30, '-', (days_from_trial_to_annual/30)*30 + 30) AS period,
	COUNT(days_from_trial_to_annual) AS count_customer_from_trial_to_annual
FROM
(
	SELECT 
		s_trial.customer_id,
		s_trial.start_date AS trial_start_date,
		s_annual.start_date AS annual_start_date,
		DATEDIFF(day, s_trial.start_date, s_annual.start_date) AS days_from_trial_to_annual
	FROM subscriptions s_trial
	JOIN plans p_trial ON s_trial.plan_id = p_trial.plan_id
	JOIN subscriptions s_annual ON s_annual.customer_id = s_trial.customer_id 
	JOIN plans p_annual ON s_annual.plan_id = p_annual.plan_id
	WHERE p_trial.plan_name = 'trial' AND p_annual.plan_name = 'pro annual'
) temp
GROUP BY days_from_trial_to_annual/30, 
		 CONCAT((days_from_trial_to_annual/30)*30, '-', (days_from_trial_to_annual/30)*30 + 30)
ORDER BY days_from_trial_to_annual/30;


-- 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
SELECT 
	COUNT(DISTINCT s_pro.customer_id) AS number_customer_downgrade
FROM subscriptions s_pro
JOIN plans p_pro ON s_pro.plan_id = p_pro.plan_id
JOIN subscriptions s_basic ON s_basic.customer_id = s_pro.customer_id 
JOIN plans p_basic ON s_basic.plan_id = p_basic.plan_id
WHERE p_pro.plan_name = 'pro monthly'
	AND p_basic.plan_name = 'basic monthly'
	AND DATEDIFF(day, s_pro.start_date, s_basic.start_date) > 0
	AND DATEPART(year, s_basic.start_date) = 2020

