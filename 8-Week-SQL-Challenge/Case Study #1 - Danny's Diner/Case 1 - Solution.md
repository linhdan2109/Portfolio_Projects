# Case Study #1: Solution
## 1. What is the total amount each customer spent at the restaurant?
```sql
SELECT 
	s.customer_id,
	SUM(m.price) AS total_spend
FROM sales s
JOIN menu  m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;
```
### Result:
| customer_id | total_spend  |
|-------------|--------------|
| A           | 76           |
| B           | 74           |
| C           | 36           |


## 2. How many days has each customer visited the restaurant?
```sql
SELECT
	customer_id,
	COUNT (DISTINCT order_date) AS days_visted
FROM sales
GROUP BY customer_id
ORDER BY customer_id;
```
### Result:
| customer_id | days_visted  |
|-------------|--------------|
| A           | 4            |
| B           | 6            |
| C           | 2            |


## 3. What was the first item from the menu purchased by each customer?
```sql
SELECT DISTINCT
	s.customer_id,
	m.product_name
FROM sales s
JOIN menu  m ON s.product_id = m.product_id
WHERE s.order_date = (SELECT MIN(order_date) FROM sales temp
						WHERE s.customer_id = temp.customer_id)
ORDER BY s.customer_id;
```
### Result:
| customer_id | product_name  |
|-------------|---------------|
| A           | curry         |
| A           | sushi         |
| B           | curry         |
| C           | ramen         |

## 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
```sql
SELECT TOP 1
	m.product_name AS most_purchased_item,
	COUNT(s.product_id) AS times_purchased
FROM sales s
JOIN menu  m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY COUNT(s.product_id) DESC;
```
### Result:
| most_purchased_item | times_purchased  |
|---------------------|------------------|
| ramen               | 8                |

## 5. Which item was the most popular for each customer?
```sql
WITH CTE AS (
	SELECT
		s.customer_id,
		m.product_name,
		COUNT(s.product_id)  AS times_purchased
	FROM sales s
	JOIN menu  m ON s.product_id = m.product_id
	GROUP BY s.customer_id, m.product_name
)
SELECT 
	c.customer_id,
	c.product_name,
	c.times_purchased
FROM CTE c
WHERE c.times_purchased = (SELECT MAX(times_purchased) FROM CTE temp		
							 WHERE c.customer_id = temp.customer_id)
ORDER BY c.customer_id;
```
### Result:
| customer_id | product_name | times_purchased  |
|-------------|--------------|------------------|
| A           | ramen        | 3                |
| B           | sushi        | 2                |
| B           | curry        | 2                |
| B           | ramen        | 2                |
| C           | ramen        | 3                |

## 6. Which item was purchased first by the customer after they became a member?
```sql
SELECT 
	s.customer_id,
	menu.product_name
FROM sales s
JOIN members ON s.customer_id= members.customer_id
JOIN menu ON s.product_id = menu.product_id
WHERE s.order_date = (SELECT TOP 1 order_date FROM sales 
						WHERE order_date >= members.join_date AND customer_id = s.customer_id
						ORDER BY order_date ASC)
ORDER BY s.customer_id;
```
### Result:
| customer_id | product_name  |
|-------------|---------------|
| A           | curry         |
| B           | sushi         |

## 7.  Which item was purchased just before the customer became a member?
```sql
SELECT 
	s.customer_id,
	menu.product_name
FROM sales s
JOIN members ON s.customer_id= members.customer_id
JOIN menu ON s.product_id = menu.product_id
WHERE s.order_date = (SELECT TOP 1 order_date FROM sales 
						WHERE order_date < members.join_date AND customer_id = s.customer_id
						ORDER BY order_date DESC)
ORDER BY s.customer_id;
```
### Result:
| customer_id | product_name  |
|-------------|---------------|
| A           | sushi         |
| A           | curry         |
| B           | sushi         |

## 8. What is the total items and amount spent for each member before they became a member?
```sql
SELECT 
	s.customer_id,
	COUNT(s.product_id) AS total_items,
	SUM(menu.price) AS  total_spend
FROM sales s
JOIN members ON s.customer_id= members.customer_id
JOIN menu ON s.product_id = menu.product_id
WHERE s.order_date < members.join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;
```
### Result:
| customer_id | total_items | total_spend  |
|-------------|-------------|--------------|
| A           | 2           | 25           |
| B           | 3           | 40           |

## 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier how many points would each customer have?
```sql
WITH CTE AS 
(
	SELECT 
		s.customer_id,
		m.product_name,
		CASE
			WHEN m.product_name = 'sushi' THEN m.price*10*2
			ELSE m.price*10
		END AS point
	FROM sales s
	JOIN menu m ON s.product_id = m.product_id
)
SELECT 
	customer_id,
	SUM(point) AS total_points
FROM CTE
GROUP BY customer_id
ORDER BY customer_id;
```
### Result:
| customer_id | total_points  |
|-------------|---------------|
| A           | 860           |
| B           | 940           |
| C           | 360           |

## 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi how many points do customer A and B have at the end of January?
```sql
WITH CTE AS 
(
	SELECT 
		s.customer_id,
		menu.product_name,
		s.order_date,
		CASE
			WHEN s.order_date BETWEEN members.join_date AND DATEADD(day, 6, members.join_date) THEN menu.price*10*2
			WHEN menu.product_name = 'sushi' THEN menu.price*10*2
			ELSE menu.price*10
		END AS point
	FROM sales s
	JOIN members ON s.customer_id= members.customer_id
	JOIN menu ON s.product_id = menu.product_id
)
SELECT 
	customer_id,
	SUM(point) AS total_points
FROM CTE
GROUP BY customer_id
ORDER BY customer_id;
```
### Result:
| customer_id | total_points  |
|-------------|---------------|
| A           | 1370          |
| B           | 940           |

## Bonus Questions 1: Join All The Things
```sql
SELECT 
	s.customer_id,
	s.order_date,
	menu.product_name,
	menu.price,
	CASE 
		WHEN s.order_date >= members.join_date THEN 'Y'
		ELSE 'N'
	END AS member
FROM sales s
FULL OUTER JOIN members ON s.customer_id= members.customer_id
JOIN menu ON s.product_id = menu.product_id
ORDER BY s.customer_id, 
		 s.order_date;
```
### Result:
| customer_id | order_date | product_name | price | member  |
|-------------|------------|--------------|-------|---------|
| A           | 2021-01-01 | sushi        | 10    | N       |
| A           | 2021-01-01 | curry        | 15    | N       |
| A           | 2021-01-07 | curry        | 15    | Y       |
| A           | 2021-01-10 | ramen        | 12    | Y       |
| A           | 2021-01-11 | ramen        | 12    | Y       |
| A           | 2021-01-11 | ramen        | 12    | Y       |
| B           | 2021-01-01 | curry        | 15    | N       |
| B           | 2021-01-02 | curry        | 15    | N       |
| B           | 2021-01-04 | sushi        | 10    | N       |
| B           | 2021-01-11 | sushi        | 10    | Y       |
| B           | 2021-01-16 | ramen        | 12    | Y       |
| B           | 2021-02-01 | ramen        | 12    | Y       |
| C           | 2021-01-01 | ramen        | 12    | N       |
| C           | 2021-01-01 | ramen        | 12    | N       |
| C           | 2021-01-07 | ramen        | 12    | N       |

## Bonus Questions 2: Rank All The Things
```sql
SELECT 
	s.customer_id,
	s.order_date,
	menu.product_name,
	menu.price,
	CASE 
		WHEN s.order_date >= members.join_date THEN 'Y'
		ELSE 'N'
	END AS member,
	CASE 
		WHEN s.order_date >= members.join_date 
			THEN RANK () OVER (PARTITION BY s.customer_id, CASE WHEN s.order_date >= members.join_date THEN 1 ELSE 2 END
							   ORDER BY s.order_date ASC)
		ELSE null
	END AS ranking
FROM sales s
FULL OUTER JOIN members ON s.customer_id= members.customer_id
JOIN menu ON s.product_id = menu.product_id
ORDER BY s.customer_id, 
		 s.order_date;
```
### Result:
| customer_id | order_date | product_name | price | member  |          |
|-------------|------------|--------------|-------|---------|----------|
| A           | 2021-01-01 | sushi        | 10    | N       |          |
| customer_id | order_date | product_name | price | member  | ranking  |
| A           | 2021-01-01 | sushi        | 10    | N       | NULL     |
| A           | 2021-01-01 | curry        | 15    | N       | NULL     |
| A           | 2021-01-07 | curry        | 15    | Y       | 1        |
| A           | 2021-01-10 | ramen        | 12    | Y       | 2        |
| A           | 2021-01-11 | ramen        | 12    | Y       | 3        |
| A           | 2021-01-11 | ramen        | 12    | Y       | 3        |
| B           | 2021-01-01 | curry        | 15    | N       | NULL     |
| B           | 2021-01-02 | curry        | 15    | N       | NULL     |
| B           | 2021-01-04 | sushi        | 10    | N       | NULL     |
| B           | 2021-01-11 | sushi        | 10    | Y       | 1        |
| B           | 2021-01-16 | ramen        | 12    | Y       | 2        |
| B           | 2021-02-01 | ramen        | 12    | Y       | 3        |
| C           | 2021-01-01 | ramen        | 12    | N       | NULL     |
