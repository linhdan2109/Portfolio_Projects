----------------------------------
-- CASE STUDY #1: DANNY'S DINER --
-- Tool used: MS SQL Server

----------------------------------
-- ANSWER CASE STUDY QUESTIONS --
----------------------------------

-- 1. What is the total amount each customer spent at the restaurant?
SELECT 
	s.[customer_id],
	SUM(m.[price]) AS total_spend
FROM [dannys_diner].[dbo].[sales] s
JOIN [dannys_diner].[dbo].[menu]  m ON s.[product_id] = m.[product_id]
GROUP BY s.[customer_id]
ORDER BY s.[customer_id];

-- 2. How many days has each customer visited the restaurant?
SELECT
	[customer_id],
	COUNT (DISTINCT [order_date]) AS days_visted
FROM [dannys_diner].[dbo].[sales]
GROUP BY [customer_id]
ORDER BY [customer_id];

-- 3. What was the first item from the menu purchased by each customer?
SELECT DISTINCT
	s.[customer_id],
	m.[product_name]
FROM [dannys_diner].[dbo].[sales] s
JOIN [dannys_diner].[dbo].[menu]  m ON s.[product_id] = m.[product_id]
WHERE s.[order_date] = (SELECT MIN([order_date]) FROM [dannys_diner].[dbo].[sales] temp
						WHERE s.[customer_id] = temp.[customer_id])
ORDER BY s.[customer_id];

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT TOP 1
	m.[product_name] AS most_purchased_item,
	COUNT(s.[product_id]) AS times_purchased
FROM [dannys_diner].[dbo].[sales] s
JOIN [dannys_diner].[dbo].[menu]  m ON s.[product_id] = m.[product_id]
GROUP BY m.[product_name]
ORDER BY COUNT(s.[product_id]) DESC;

-- 5. Which item was the most popular for each customer?
WITH CTE AS (
	SELECT
		s.[customer_id],
		m.[product_name],
		COUNT(s.[product_id])  AS times_purchased
	FROM [dannys_diner].[dbo].[sales] s
	JOIN [dannys_diner].[dbo].[menu]  m ON s.[product_id] = m.[product_id]
	GROUP BY s.[customer_id], m.[product_name]
)
SELECT 
	c.[customer_id],
	c.[product_name],
	c.[times_purchased]
FROM CTE c
WHERE c.[times_purchased] = (SELECT MAX([times_purchased]) FROM CTE temp		
							 WHERE c.[customer_id] = temp.[customer_id])
ORDER BY c.[customer_id];

-- 6. Which item was purchased first by the customer after they became a member?
SELECT 
	s.[customer_id],
	menu.[product_name]
FROM [dannys_diner].[dbo].[sales] s
JOIN [dannys_diner].[dbo].[members] ON s.[customer_id]= members.[customer_id]
JOIN [dannys_diner].[dbo].[menu] ON s.[product_id] = menu.[product_id]
WHERE s.[order_date] = (SELECT TOP 1 [order_date] FROM [dannys_diner].[dbo].[sales] 
						WHERE [order_date] >= members.[join_date] AND [customer_id] = s.[customer_id]
						ORDER BY [order_date] ASC)
ORDER BY s.[customer_id];

-- 7. Which item was purchased just before the customer became a member?
SELECT 
	s.[customer_id],
	menu.[product_name]
FROM [dannys_diner].[dbo].[sales] s
JOIN [dannys_diner].[dbo].[members] ON s.[customer_id]= members.[customer_id]
JOIN [dannys_diner].[dbo].[menu] ON s.[product_id] = menu.[product_id]
WHERE s.[order_date] = (SELECT TOP 1 [order_date] FROM [dannys_diner].[dbo].[sales] 
						WHERE [order_date] < members.[join_date] AND [customer_id] = s.[customer_id]
						ORDER BY [order_date] DESC)
ORDER BY s.[customer_id];

-- 8. What is the total items and amount spent for each member before they became a member?
SELECT 
	s.[customer_id],
	COUNT(s.[product_id]) AS total_items,
	SUM(menu.[price]) AS  total_spend
FROM [dannys_diner].[dbo].[sales] s
JOIN [dannys_diner].[dbo].[members] ON s.[customer_id]= members.[customer_id]
JOIN [dannys_diner].[dbo].[menu] ON s.[product_id] = menu.[product_id]
WHERE s.[order_date] < members.[join_date]
GROUP BY s.[customer_id]
ORDER BY s.[customer_id];

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier 
-- how many points would each customer have?
WITH CTE AS 
(
	SELECT 
		s.[customer_id],
		m.[product_name],
		CASE
			WHEN m.[product_name] = 'sushi' THEN m.[price]*10*2
			ELSE m.[price]*10
		END AS point
	FROM [dannys_diner].[dbo].[sales] s
	JOIN [dannys_diner].[dbo].[menu] m ON s.[product_id] = m.[product_id]
)
SELECT 
	[customer_id],
	SUM(point) AS total_points
FROM CTE
GROUP BY [customer_id]
ORDER BY [customer_id];

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi 
-- how many points do customer A and B have at the end of January?
WITH CTE AS 
(
	SELECT 
		s.[customer_id],
		menu.[product_name],
		s.[order_date],
		CASE
			WHEN s.[order_date] BETWEEN members.[join_date] AND DATEADD(day, 6, members.[join_date]) THEN menu.[price]*10*2
			WHEN menu.[product_name] = 'sushi' THEN menu.[price]*10*2
			ELSE menu.[price]*10
		END AS point
	FROM [dannys_diner].[dbo].[sales] s
	JOIN [dannys_diner].[dbo].[members] ON s.[customer_id]= members.[customer_id]
	JOIN [dannys_diner].[dbo].[menu] ON s.[product_id] = menu.[product_id]
)
SELECT 
	[customer_id],
	SUM(point) AS total_points
FROM CTE
GROUP BY [customer_id]
ORDER BY [customer_id];

-- Bonus Questions: Join All The Things
SELECT 
	s.[customer_id],
	s.[order_date],
	menu.[product_name],
	menu.[price],
	CASE 
		WHEN s.[order_date] >= members.[join_date] THEN 'Y'
		ELSE 'N'
	END AS member
FROM [dannys_diner].[dbo].[sales] s
FULL OUTER JOIN [dannys_diner].[dbo].[members] ON s.[customer_id]= members.[customer_id]
JOIN [dannys_diner].[dbo].[menu] ON s.[product_id] = menu.[product_id]
ORDER BY s.[customer_id], 
		 s.[order_date];

-- Bonus Questions: Rank All The Things
SELECT 
	s.[customer_id],
	s.[order_date],
	menu.[product_name],
	menu.[price],
	CASE 
		WHEN s.[order_date] >= members.[join_date] THEN 'Y'
		ELSE 'N'
	END AS member,
	CASE 
		WHEN s.[order_date] >= members.[join_date] 
			THEN RANK () OVER (PARTITION BY s.[customer_id], CASE WHEN s.[order_date] >= members.[join_date] THEN 1 ELSE 2 END
							   ORDER BY s.[order_date] ASC)
		ELSE null
	END AS ranking
FROM [dannys_diner].[dbo].[sales] s
FULL OUTER JOIN [dannys_diner].[dbo].[members] ON s.[customer_id]= members.[customer_id]
JOIN [dannys_diner].[dbo].[menu] ON s.[product_id] = menu.[product_id]
ORDER BY s.[customer_id], 
		 s.[order_date];

