# DATA ANALYSIS PROCESS - LOAN DATASET

## INTRODUCTION
The loan analysis project analyze various aspects related to loan data. This includes assessing borrower profiles, credit scores, financial histories, and repayment patterns. Through the application of data analysis techniques, the project aims to identify trends, risks, and opportunities within the lending portfolio. The ultimate goal is to enhance decision-making processes, optimize lending strategies, and ensure the overall health of the lending business.

## PART A: UNIVARIATE ANALYSIS

**1. Number of Loan applicants**
```SQL
SELECT
  COUNT(*) AS num_applicants
FROM LoanData;
```
| num_applicants  |
|-----------------|
| 39667           |

**2. Loan amount statistics**
```SQL
WITH loan_amnt_summary AS (
  SELECT
    MIN(loan_amnt) OVER () AS min_amnt,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY loan_amnt) OVER() AS Q1_amnt,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY loan_amnt) OVER () AS median_amnt,
    AVG(loan_amnt) OVER() AS avg_amnt,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY loan_amnt) OVER () AS Q3_amnt,
    MAX(loan_amnt) OVER() AS max_amnt
  FROM LoanData
)
  SELECT
    DISTINCT *
  FROM loan_amnt_summary;
```
| min_amnt | Q1_amnt | median_amnt | avg_amnt | Q3_amnt | max_amnt  |
|----------|---------|-------------|----------|---------|-----------|
| 500      | 5500    | 10000       | 11227    | 15000   | 35000     |

The distribution of loan amounts in the dataset appears to be a little right-skewed. This suggests that there is a higher frequency of smaller loan amounts, while larger loan amounts are less common. 

In addition to being right-skewed, the distribution of loan amounts also exhibits a long tail. This means that there are a few loans with very high values that extend far beyond the majority of the data points.

**3. How many loan application are there in each term ?**

Term is the number of payments on the loan. Values are in months and can be either 36 or 60.

```SQL
SELECT 
  term,
  COUNT(*) AS num_loan_applications,
  ROUND(CAST(COUNT(*) AS FLOAT) * 100 / (SELECT COUNT(*) FROM LoanData)
    , 2) AS percent_loan_applications
FROM LoanData
GROUP BY term
ORDER BY term;
```
| term | num_loan_applications | percent_loan_applications  |
|------|-----------------------|----------------------------|
| 36   | 29049                 | 73.23                      |
| 60   | 10618                 | 26.77                      |


**4. Number of loans by interest rate**
```sql
SELECT
  ROUND(int_rate, 2) AS interest,
  COUNT(*) AS num_loan_applications,
  ROUND(CAST(COUNT(*) AS FLOAT) * 100 / (SELECT COUNT(*) FROM LoanData)
    , 2) AS percent_loan_applications
FROM LoanData
GROUP BY ROUND(int_rate, 2)
ORDER BY interest;
```

| interest | num_loan_applications | percent_loan_applications  |
|----------|-----------------------|----------------------------|
| 0.05     | 573                   | 1.44                       |
| 0.06     | 1532                  | 3.86                       |
| 0.07     | 3272                  | 8.25                       |
| 0.08     | 3386                  | 8.54                       |
| 0.09     | 1520                  | 3.83                       |
| 0.1      | 3434                  | 8.66                       |
| 0.11     | 5082                  | 12.81                      |
| 0.12     | 3239                  | 8.17                       |
| 0.13     | 4754                  | 11.98                      |
| 0.14     | 2890                  | 7.29                       |
| 0.15     | 2606                  | 6.57                       |
| 0.16     | 2674                  | 6.74                       |
| 0.17     | 1518                  | 3.83                       |
| 0.18     | 1189                  | 3                          |
| 0.19     | 878                   | 2.21                       |
| 0.2      | 496                   | 1.25                       |
| 0.21     | 352                   | 0.89                       |
| 0.22     | 194                   | 0.49                       |
| 0.23     | 49                    | 0.12                       |
| 0.24     | 28                    | 0.07                       |
| 0.25     | 1                     | 0                          |

Most of the loans' interest rate concentrate in the range of 0.1 to 0.16.

**5. Installment distribution**

```sql
WITH installment_bins AS (
	SELECT
		CASE 
			WHEN installment <= 100 THEN '0 - 100'
			WHEN installment > 100 AND installment <= 200 THEN '100 - 200'
			WHEN installment > 200 AND installment <= 300 THEN '200 - 300'
			WHEN installment > 300 AND installment <= 400 THEN '300 - 400'
			WHEN installment > 400 AND installment <= 500 THEN '400 - 500'
			WHEN installment > 500 AND installment <= 600 THEN '500 - 600'
			ELSE '600 - 1200'
		END AS installment_range
	FROM LoanData
)
SELECT 
	installment_range,
	COUNT(*) AS num_loan_applications,
	ROUND(CAST(COUNT(*) AS FLOAT) * 100 / (SELECT COUNT(*) FROM LoanData)
		, 2) AS percent_loan_applications
FROM installment_bins
GROUP BY installment_range
ORDER BY CASE 
		WHEN installment_range = '0 - 100' THEN 1
		WHEN installment_range = '100 - 200' THEN 2
		WHEN installment_range = '200 - 300' THEN 3
		WHEN installment_range = '300 - 400' THEN 4
		WHEN installment_range = '400 - 500' THEN 5
		WHEN installment_range = '500 - 600' THEN 6
		ELSE 7
	END;
```
| installment_range | num_loan_applications | percent_loan_applications  |
|-------------------|-----------------------|----------------------------|
| 0 - 100           | 4013                  | 10.12                      |
| 100 - 200         | 9231                  | 23.27                      |
| 200 - 300         | 7806                  | 19.68                      |
| 300 - 400         | 7355                  | 18.54                      |
| 400 - 500         | 4124                  | 10.4                       |
| 500 - 600         | 2748                  | 6.93                       |
| 600 - 1200        | 4390                  | 11.07                      |


The data suggests that the majority of borrowers are paying between 100 USD - 300 USD monthly installments. We can see that about 62% of loans have installment amounts that are in the range 100 USD - 300 USD. 

There are about 11% of loans with significantly higher installment amounts of others (600 - 1200).

This information is crucial for understanding the affordability of loans for borrowers and for making informed decisions about lending terms and conditions.

**6. Number of loans in each Grade**

```sql
SELECT
	grade,
	COUNT(*) AS num_loan_applications,
	ROUND(CAST(COUNT(*) AS FLOAT) * 100 / (SELECT COUNT(*) FROM LoanData)
		, 2) AS percent_loan_applications
FROM LoanData
GROUP BY grade
ORDER BY grade;
```
| grade | num_loan_applications | percent_loan_applications  |
|-------|-----------------------|----------------------------|
| A     | 10085                 | 25.42                      |
| B     | 12019                 | 30.3                       |
| C     | 8084                  | 20.38                      |
| D     | 5291                  | 13.34                      |
| E     | 2831                  | 7.14                       |
| F     | 1043                  | 2.63                       |
| G     | 314                   | 0.79                       |

Most loan applications is in Grade A, B and C.

**7. Home Ownership**

```sql
SELECT
	home_ownership,
	COUNT(*) AS num_loan_applications,
	ROUND(CAST(COUNT(*) AS FLOAT) * 100 / (SELECT COUNT(*) FROM LoanData)
		, 2) AS percent_loan_applications
FROM LoanData
GROUP BY home_ownership
ORDER BY num_loan_applications DESC;
```

| home_ownership | num_loan_applications | percent_loan_applications  |
|----------------|-----------------------|----------------------------|
| Rent           | 18867                 | 47.56                      |
| Mortgage       | 17648                 | 44.49                      |
| Own            | 3053                  | 7.7                        |
| Other          | 96                    | 0.24                       |
| None           | 3                     | 0.01                       |

In the dataset, a significant portion (92%) of the borrowers' housing situations can be classified into two main categories: renting and mortgage. 

This observation sheds light on the prevailing trend among borrowers in terms of their residential arrangements.

**8. Annual income**

_8a. Find min, max, average and standard deviation of annual income_

```sql
SELECT
	MIN(annual_inc) AS min_inc,
	AVG(annual_inc) AS avg_inc,
	MAX(annual_inc) AS max_inc,
	STDEV(annual_inc) AS sd_inc
FROM LoanData;
```

| min_inc | avg_inc          | max_inc | sd_inc           |
|---------|------------------|---------|------------------|
| 4000    | 68999.5237582878 | 6000000 | 63789.4654493437 |

There is a significant disparity between the lowest income ($4,000 USD) and the highest income ($6,000,000 USD) in the Lending Club dataset, and the standard deviation of income is also quite high. This indicates (1) a wide range of income levels among borrowers, from those with low income to those with very high income or (2) There are outliners in annual income, These outliers can introduce noise to the analysis and lead to incorrect conclusions or (3) both.

To understand more about the distribution of annual income, we can look at the percentiles of it.

_8b. Find percentiles of annual income_

```sql
SELECT
	DISTINCT PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY annual_inc) OVER() AS percentile_5th_inc,
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY annual_inc) OVER() AS Q1_inc,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY annual_inc) OVER () AS Q2_inc,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY annual_inc) OVER () AS Q3_inc,
	PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY annual_inc) OVER() AS percentile_95th_inc
FROM LoanData;
```

| percentile_5th_inc | Q1_inc   | Q2_inc | Q3_inc | percentile_95th_inc  |
|--------------------|----------|--------|--------|----------------------|
| 24000              | 40516.32 | 59000  | 82400  | 142000               |

There is a big difference between the lowest value and the 5th percentile, as well as between the highest value and the 95th percentile in the dataset.

These differences could suggest the presence of unusual values that might affect the analysis. It's important to address these outliers to ensure reliable results from the data analysis. Let's considere the values that smaller than 5th percentile and greater than 95th percentile are outliners and remove it. Once we remove them, we can then analyze the statistics of the annual income to gain a better understanding of the income distribution without the influence of extreme values.

_8c. Find min, max and average of annual income after remove outliner_

```sql
WITH percentile_inc AS (
	SELECT
		*,
		PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY annual_inc) OVER() AS percentile_5th_inc,
		PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY annual_inc) OVER() AS percentile_95th_inc
	FROM LoanData
),
remove_inc_outliner AS (
	SELECT
		*
	FROM percentile_inc
	WHERE annual_inc >= percentile_5th_inc AND annual_inc <= percentile_95th_inc
)
SELECT
	MIN(annual_inc) AS new_min_inc,
	AVG(annual_inc) AS new_avg_inc,
	MAX(annual_inc) AS new_max_inc,
	STDEV(annual_inc) AS new_sd_inc
FROM remove_inc_outliner;
```

| new_min_inc | new_avg_inc      | new_max_inc | new_sd_inc       |
|-------------|------------------|-------------|------------------|
| 24000       | 63257.7057925811 | 142000      | 26722.7854207024 |

 As you can see, after remove outliners, both the mean and standard deviation decrease.
 - The mean decrease from 68K to 63K.
 - The standard deviation decrease from 63K to 26K.
 - The lowest income move from 4K to 24K.
 - The highest income move from 6M to 140K.

**9. Number of loans by verification status**

```sql
SELECT
	verification_status,
	COUNT(*) AS num_loan_applications,
	ROUND(CAST(COUNT(*) AS FLOAT) * 100 / (SELECT COUNT(*) FROM LoanData)
		, 2) AS percent_loan_applications
FROM LoanData
GROUP BY verification_status
ORDER BY num_loan_applications DESC;
```

| verification_status | num_loan_applications | percent_loan_applications  |
|---------------------|-----------------------|----------------------------|
| Not Verified        | 16892                 | 42.58                      |
| Verified            | 12799                 | 32.27                      |
| Source Verified     | 9976                  | 25.15                      |

There are lots of borrowers in the data have unverified income.

**10. Issue Year**

```sql
WITH loan_year AS(
	SELECT
		YEAR(issue_d) AS issue_year,
		COUNT(*) AS num_loan_applications,
		ROUND(CAST(COUNT(*) AS FLOAT) * 100 / (SELECT COUNT(*) FROM LoanData)
			, 2) AS percent_loan_applications
	FROM LoanData
	GROUP BY YEAR(issue_d)
)
SELECT 
	issue_year,
	num_loan_applications,
	percent_loan_applications,
	CAST (num_loan_applications - LAG(num_loan_applications) OVER (ORDER BY issue_year) AS FLOAT)
		/LAG(num_loan_applications) OVER (ORDER BY issue_year) 
		* 100 AS percent_increase
FROM loan_year
ORDER BY issue_year;
```

| issue_year | num_loan_applications | percent_loan_applications | percent_increase  |
|------------|-----------------------|---------------------------|-------------------|
| 2007       | 251                   | 0.63                      | NULL              |
| 2008       | 1554                  | 3.92                      | 519.123505976096  |
| 2009       | 4702                  | 11.85                     | 202.574002574003  |
| 2010       | 11513                 | 29.02                     | 144.853253934496  |
| 2011       | 21647                 | 54.57                     | 88.0222357335186  |

Over the course of the years from 2007 to 2011, there was a pronounced and noteworthy upsurge in the quantity of loans being issued. This growth, however, exhibited a trend of diminishing percentage increases as the years progressed. While the total count of loans exhibited a substantial rise during this period, the rate of increase progressively declined over the years.

**11. Loan status**

12. Purposes

13. Borrowers Address state

14. Debt-to-income ratio (dti ratio)

15. Total credit revolving balance

16. Revolving line utilization rate (the amount of credit the borrower is using relative to all available revolving credit)

17. The total number of credit lines currently in the borrower's credit file

18, 19 and 20. Total payments, principal and interest received to date for total amount funded

## PART B: BIVARIATE ANALYSIS
