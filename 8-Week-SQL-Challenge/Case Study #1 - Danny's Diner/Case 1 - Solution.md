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


## 3. What was the first item from the menu purchased by each customer?
```sql

```
### Result:

