# DATA ANALYSIS PROCESS - LOAN DATASET

## INTRODUCTION
The loan analysis project analyze various aspects related to loan data. This includes assessing borrower profiles, credit scores, financial histories, and repayment patterns. Through the application of data analysis techniques, the project aims to identify trends, risks, and opportunities within the lending portfolio. The ultimate goal is to enhance decision-making processes, optimize lending strategies, and ensure the overall health of the lending business.

Download the SQL code file [here]()

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

There is a significant disparity between the lowest income ($4,000 USD) and the highest income ($6,000,000 USD) in the Lending Club dataset, and the standard deviation of income is also quite high. This indicates (1) a wide range of income levels among borrowers, from those with low income to those with very high income or (2) There are outliners in annual income, These outliers can introduce noise to the analysis and lead to incorrect conclusions or (3) both (1) and (2).

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

**11. Number of loan applications by Loan status**

_11a. Loan status (with current applications)_

```sql
SELECT
	loan_status,
	COUNT(*) AS num_loan_applications,
	ROUND(CAST(COUNT(*) AS FLOAT) * 100 / (SELECT COUNT(*) FROM LoanData)
		, 2) AS percent_loan_applications
FROM LoanData
GROUP BY loan_status
ORDER BY loan_status;
```

| loan_status | num_loan_applications | percent_loan_applications  |
|-------------|-----------------------|----------------------------|
| Charged Off | 5611                  | 14.15                      |
| Current     | 1140                  | 2.87                       |
| Fully Paid  | 32916                 | 82.98                      |


_11b. Loan status (without current applications)_

```sql
SELECT
	loan_status,
	COUNT(*) AS num_loan_applications,
	ROUND(CAST(COUNT(*) AS FLOAT) * 100 / (SELECT COUNT(*) FROM LoanData WHERE loan_status != 'Current')
		, 2) AS percent_loan_applications
```

| loan_status | num_loan_applications | percent_loan_applications  |
|-------------|-----------------------|----------------------------|
| Charged Off | 5611                  | 14.56                      |
| Fully Paid  | 32916                 | 85.44                      |

The rate of fully repaid loans stands at 85%. Certainly, it's important to keep in mind the high rate of fully repaid loans as we move forward with building a predictive model for loan status. This information serves as a valuable benchmark and reference point

**12. Number of loan applications by Purposes**

```sql
SELECT
	purpose,
	COUNT(*) AS num_loan_applications,
	ROUND(CAST(COUNT(*) AS FLOAT) * 100 / (SELECT COUNT(*) FROM LoanData)
		, 2) AS percent_loan_applications
FROM LoanData
GROUP BY purpose
ORDER BY num_loan_applications DESC;
```

| purpose            | num_loan_applications | percent_loan_applications  |
|--------------------|-----------------------|----------------------------|
| Debt Consolidation | 18629                 | 46.96                      |
| Credit Card        | 5128                  | 12.93                      |
| Other              | 3980                  | 10.03                      |
| Home Improvement   | 2971                  | 7.49                       |
| Major Purchase     | 2181                  | 5.5                        |
| Small Business     | 1827                  | 4.61                       |
| Car                | 1547                  | 3.9                        |
| Wedding            | 946                   | 2.38                       |
| Medical            | 691                   | 1.74                       |
| Moving             | 581                   | 1.46                       |
| House              | 381                   | 0.96                       |
| Vacation           | 380                   | 0.96                       |
| Educational        | 322                   | 0.81                       |
| Renewable Energy   | 103                   | 0.26                       |

'Debt Consolidation' purpose has the highest number of loan applications, accounting for approximately 46.96% of the total. Debt consolidation loans are typically sought to merge multiple debts into a single loan for easier management. The credit card purpose category has the second-highest number of loan applications, making up around 12.93% of the total.

**13. Top 10 states have the most loan applications**

```sql
WITH top10_addr_state AS (
	SELECT TOP 10
		addr_state,
		COUNT(*) AS num_loan_applications,
		ROUND(CAST(COUNT(*) AS FLOAT) * 100 / (SELECT COUNT(*) FROM LoanData)
			, 2) AS percent_loan_applications
	FROM LoanData
	GROUP BY addr_state
),
top10_and_other_addr_state AS (
	SELECT 
		*,
		CASE 
			WHEN addr_state IN (SELECT addr_state FROM top10_addr_state) THEN addr_state
			ELSE 'Other'
		END AS addr_state_temp
	FROM LoanData
)
SELECT 
	addr_state_temp,
	COUNT(*) AS num_loan_applications,
	ROUND(CAST(COUNT(*) AS FLOAT) * 100 / (SELECT COUNT(*) FROM LoanData)
		, 2) AS percent_loan_applications
FROM top10_and_other_addr_state
GROUP BY addr_state_temp
ORDER BY num_loan_applications DESC;
```

| addr_state_temp | num_loan_applications | percent_loan_applications  |
|-----------------|-----------------------|----------------------------|
| Other           | 21975                 | 55.4                       |
| CA              | 7092                  | 17.88                      |
| TX              | 2723                  | 6.86                       |
| IL              | 1524                  | 3.84                       |
| VA              | 1406                  | 3.54                       |
| GA              | 1398                  | 3.52                       |
| AZ              | 876                   | 2.21                       |
| NC              | 787                   | 1.98                       |
| CT              | 751                   | 1.89                       |
| MO              | 685                   | 1.73                       |
| OR              | 450                   | 1.13                       |

California has the highest number of loan applications, comprising about 17.88% of the total. The significant percentage suggests that a substantial number of loan applicants have temporary addresses in California. Texas follows with around 6.86% of the total loan applications.

**14. Debt-to-income ratio (dti ratio)**

_14a. View number of borrower by dti ratio (whether it's smaller than 1 or not)_

```sql
SELECT
	CASE 
		WHEN dti < 1 THEN 'dti < 1'
		ELSE 'dti > 1'
	END AS dti,
	COUNT(*) AS num_borrower
FROM LoanData
GROUP BY CASE WHEN dti < 1 THEN 'dti < 1' ELSE 'dti > 1' END;
```

| dti            | num_borrower  |
|----------------|---------------|
| dti > 1        | 38703         |
| dti < 1        | 964           |

A significant number of loan borrowers have a DTI ratio greater than 1. This observation is quite unusual and raises concerns about the accuracy of the data itself.

The debt-to-income ratio (DTI ratio) is a financial metric that reflects the proportion of a borrower's debt to their income. A DTI ratio exceeding 1 implies that the borrower's debt obligations surpass their monthly income. From a logical standpoint, this scenario is highly improbable and defies financial prudence. Borrowers would typically struggle to meet their obligations if their debt surpasses their income.

In conclusion, the presence of a substantial number of borrowers with a debt-to-income ratio greater than 1 is a clear red flag. Let's check the min, average and max of DTI ratio.

_14b. Find min, max and average of dti ratio_

```sql
SELECT
	MIN(dti) AS min_dti,
	AVG(dti) AS avg_dti,
	MAX(dti) AS max_dti
FROM LoanData;
```

| min_dti | avg_dti          | max_dti  |
|---------|------------------|----------|
| 0       | 13.3187044646684 | 29.99    |

The average DTI ratio is 13.3 and the max DTI ratio is 30. That means on average, a borrower at Lending Club has debt exceeds their reported income by a factor of 13. This signals potential data quality issues or anomalies. The anomaly could be attributed to the fact that the debt-to-income ratio (DTI) values are presented as percentages, rather than decimal values. If the data is indeed represented as percentages, it implies that the values need to be normalized by dividing them by 100 to obtain the correct decimal form of the debt-to-income ratio.

_14c. Divide dti by 100_

```sql
SELECT
	MIN(dti/100) AS min_dti,
	AVG(dti/100) AS avg_dti,
	MAX(dti/100) AS max_dti
FROM LoanData;
```
| min_dti | avg_dti           | max_dti  |
|---------|-------------------|----------|
| 0       | 0.133187044646683 | 0.2999   |

Now the average DTI is 0.13 and the max dti is 0.3, this makes more sense. 

Generally, it's a good idea to keep your DTI ratio below 43%, though 35% or less is considered “good.”

![image](https://github.com/linhdan2109/Portfolio_Projects/assets/85982220/30ef64aa-cbc6-4929-8c4c-7d48df36e113)

The highest DTI ratio in this dataset is 0.3 so all loans have good dti ratios

**15-16. Credit revolving balance and Revolving line utilization rate**

_15. Revolving balance statistic_

Revolving balance is the outstanding amount of credit that a borrower owes on a revolving credit account

```sql
SELECT
	MIN(revol_bal) AS min_bal,
	AVG(revol_bal) AS avg_val,
	MAX(revol_bal) AS max_bal,
	STDEV(revol_bal) AS sd_bal
FROM LoanData;
```

| min_bal | avg_val          | max_bal | sd_bal          |
|---------|------------------|---------|-----------------|
| 0       | 13398.1553936522 | 149588  | 15887.036743361 |

These statistics give us an overview of the distribution and variability of revolving balances within the dataset. But examining the revolving balance alone is not sufficient to gain a comprehensive understanding of the financial health and behavior of borrowers. It's important to also consider the revolving utilization rate, which provides a more holistic view of how borrowers are utilizing their available credit.

_16. Revolving line utilization rate_

The revolving line utilization rate, also known as the credit utilization rate, is a measure of how much of a borrower's available credit they are currently using. It is calculated by dividing the total amount of revolving credit currently in use by the total available revolving credit limit.

A lower revolving line utilization rate is generally considered favorable, as it indicates that the borrower is not using a large portion of their available credit. Lenders often use this rate to assess a borrower's creditworthiness, with lower utilization rates being associated with lower risk.

```sql
SELECT 
	ROUND(revol_util, 1) AS revol_util,
	COUNT(*) AS num_loan_applications
FROM LoanData
GROUP BY ROUND(revol_util, 1)
ORDER BY ROUND(revol_util, 1);
```

| revol_util | num_loan_applications  |
|------------|------------------------|
| 0          | 2695                   |
| 0.1        | 3469                   |
| 0.2        | 3583                   |
| 0.3        | 4034                   |
| 0.4        | 4140                   |
| 0.5        | 4354                   |
| 0.6        | 4334                   |
| 0.7        | 4174                   |
| 0.8        | 3955                   |
| 0.9        | 3472                   |
| 1          | 1457                   |

The data indicates that there isn't a substantial variation in the distribution of loan applications across different levels of revolving utilization rates. The number of loan applications remains relatively consistent across the various utilization rate categories, with only slight fluctuations.


**17. Total number of credit lines currently in the borrower's credit file**

```sql
WITH total_acc_count AS (
	SELECT
		*,
		CASE 
			WHEN total_acc <= 10 THEN '0-10'
			WHEN total_acc > 10 AND total_acc <= 20 THEN '10 - 20'
			WHEN total_acc > 20 AND total_acc <= 30 THEN '20 - 30'
			WHEN total_acc > 30 AND total_acc <= 40 THEN '30 - 40'
			WHEN total_acc > 40 AND total_acc <= 50 THEN '40 - 50'
			WHEN total_acc > 50 AND total_acc <= 60 THEN '50 - 60'
			ELSE '> 50'
		END AS total_acc_range,
		CASE 
			WHEN total_acc <= 10 THEN 1
			WHEN total_acc > 10 AND total_acc <= 20 THEN 2
			WHEN total_acc > 20 AND total_acc <= 30 THEN 3
			WHEN total_acc > 30 AND total_acc <= 40 THEN 4
			WHEN total_acc > 40 AND total_acc <= 50 THEN 5
			WHEN total_acc > 50 AND total_acc <= 60 THEN 6
			ELSE 7
		END AS total_acc_range_order
FROM LoanData
)
SELECT 
	total_acc_range,
	COUNT(*) AS num_loan_applications
FROM total_acc_count
GROUP BY total_acc_range, total_acc_range_order
ORDER BY total_acc_range_order;
```

| total_acc_range | num_loan_applications  |
|-----------------|------------------------|
| 0-10            | 5917                   |
| 10 - 20         | 14001                  |
| 20 - 30         | 11299                  |
| 30 - 40         | 5663                   |
| 40 - 50         | 1993                   |
| 50 - 60         | 584                    |
| > 50            | 210                    |

The majority of loan applications (around 23.42%) fall within the range of 10 to 20 total accounts, indicating that a significant number of borrowers have a moderate number of accounts. The next most common range is 20 to 30 total accounts, accounting for approximately 18.85% of the loan applications.

**18-19-20. Total payments, principal and interest received to date for total amount funded**

_Sum of payments, interest and principal in the period 2007 - 2011_ 

```sql
SELECT 
	SUM(total_pymnt) AS sum_payment,
	SUM(total_rec_prncp) AS sum_principle,
	SUM(total_rec_int) AS sum_interest
FROM LoanData
```

| sum_payment      | sum_principle    | sum_interest     |
|------------------|------------------|------------------|
| 482482303.019469 | 388791568.000008 | 89860770.7000007 |

_b. Tracking total payments, interest and principal for loan applications' status is 'Charged Off'_

```sql
SELECT 
	id, 
	loan_amnt,
	total_pymnt,
	total_rec_prncp,
	total_rec_int,
	total_rec_prncp/loan_amnt AS debt_payoff_rate
FROM LoanData
WHERE loan_status = 'Charged Off'
```

| id      | loan_amnt | total_pymnt | total_rec_prncp | total_rec_int | debt_payoff_rate    |
|---------|-----------|-------------|-----------------|---------------|---------------------|
| 1077430 | 2500      | 1008.71     | 456.46          | 435.17        | 0.182584            |
| 1071795 | 5600      | 646.02      | 162.02          | 294.94        | 0.0289321428571429  |
| 1071570 | 5375      | 1476.19     | 673.48          | 533.42        | 0.125298604651163   |
| 1064687 | 9000      | 2270.7      | 1256.14         | 570.26        | 0.139571111111111   |
| 1069057 | 10000     | 7471.99     | 5433.47         | 1393.42       | 0.543347            |
| 1039153 | 21000     | 14025.4     | 10694.96        | 3330.44       | 0.509283809523809   |
| 1069559 | 6000      | 2050.14     | 1305.58         | 475.25        | 0.217596666666667   |
| 1069800 | 15000     | 0           | 0               | 0             | 0                   |
| 1069657 | 5000      | 1609.12     | 629.05          | 719.11        | 0.12581             |
| 1069465 | 5000      | 5021.37     | 4217.38         | 696.99        | 0.843476            |
| 1069248 | 15000     | 16177.77    | 13556.45        | 2374.34       | 0.903763333333333   |
| 1069243 | 12000     | 3521.95     | 1903.66         | 1039.35       | 0.158638333333333   |
| 1069410 | 21000     | 18319.14    | 8990.81         | 9328.33       | 0.428133809523809   |
| 1069126 | 10000     | 8772.91     | 5495.38         | 2429.23       | 0.549538            |
| ...     | ...       | ...         | ...             | ...           | ...                 |

_c. Tracking total payments, interest and principal for loan applications' status is 'Current'_
```sql
SELECT 
	id, 
	loan_amnt,
	total_pymnt,
	total_rec_prncp,
	total_rec_int,
	total_rec_prncp/loan_amnt AS debt_payoff_rate
FROM LoanData
WHERE loan_status = 'Current'
```

| id      | id      | loan_amnt | total_pymnt | total_rec_prncp | total_rec_int |
|---------|---------|-----------|-------------|-----------------|---------------|
| 1077430 | 1075358 | 3000      | 3513.33     | 2475.94         | 1037.39       |
| 1071795 | 1065420 | 10000     | 12594.24    | 8150.89         | 4443.35       |
| 1071570 | 1069346 | 12500     | 14636.3     | 10318.58        | 4317.72       |
| 1064687 | 1063958 | 14000     | 18176.96    | 11362.67        | 6814.29       |
| 1069057 | 1068575 | 15300     | 21988.2     | 12174.21        | 9813.99       |
| 1039153 | 1067874 | 6000      | 7037.39     | 4958.01         | 2079.38       |
| 1069559 | 1034693 | 16000     | 20908.55    | 12966.72        | 7941.83       |
| 1069800 | 1046969 | 11000     | 13131.62    | 9058.73         | 4072.89       |
| 1069657 | 1066664 | 21000     | 15297.1     | 9564.9          | 5732.2        |
| 1069465 | 1066659 | 16000     | 20783.1     | 12990.27        | 7792.83       |
| 1069248 | 1064063 | 18825     | 24593.14    | 15252.82        | 9340.32       |
| 1069243 | 1066173 | 12300     | 14688.44    | 10131.81        | 4556.63       |
| 1069410 | 1065145 | 18000     | 22354.28    | 14718           | 7636.28       |
| 1069126 | 1065342 | 20000     | 24548.68    | 16421.38        | 8127.3        |
| ...     | ...     | ...       | ...         | ...             | ...           |

_d. Total payments by loan status and year_
```sql
SELECT
	YEAR(issue_d) AS issue_year,
	ROUND(SUM(CASE WHEN loan_status = 'Fully Paid' THEN total_pymnt ELSE 0 END), 2) AS fully_paid,
	ROUND(SUM(CASE WHEN loan_status = 'Charged Off' THEN total_pymnt ELSE 0 END), 2) AS charged_off,
	ROUND(SUM(CASE WHEN loan_status = 'Current' THEN total_pymnt ELSE 0 END), 2) AS current_loan,
	ROUND(SUM(CASE WHEN loan_status = 'Fully Paid' THEN total_pymnt ELSE 0 END)/ SUM(total_pymnt), 2) AS fully_paid_rate
FROM LoanData
GROUP BY YEAR(issue_d)
ORDER BY YEAR(issue_d);
```

| issue_year | fully_paid   | charged_off | current_loan | fully_paid_rate  |
|------------|--------------|-------------|--------------|------------------|
| 2007       | 1931151.63   | 281540.03   | 0            | 0.87             |
| 2008       | 12698676.53  | 1335765.68  | 0            | 0.9              |
| 2009       | 46928428.71  | 3339311.94  | 0            | 0.93             |
| 2010       | 121337767.31 | 9085461.1   | 0            | 0.93             |
| 2011       | 236235319.39 | 24396602.55 | 24912278.14  | 0.83             |



The table showcases the trends of fully paid and charged off amounts, indicating how these figures have changed and evolved over the specified period. Additionally, the introduction of the "current_loan" category in 2011 reflects loans that are currently active. 


## PART B: BIVARIATE ANALYSIS

If the company approves the loan, there are 3 possible loan status:

- Fully paid: Applicant has fully paid the loan (the principal and the interest rate)

- Charged-off: Applicant has not paid the loan in due time for a long period of time (default)

- Current: Applicant is in the process of paying the loan.

The main purpose of Lending Club is to minimize the default loan status.

The provided data includes details about previous loan applicants and their status. This will help me identify what factors distinguish between loans that are 'fully paid' and those that are 'charged off'. The objective is to uncover patterns that could suggest whether an individual is prone to defaulting. These insights can then be used for making decisions such as denying loans, adjusting loan amounts, or providing loans (to high-risk applicants) with higher interest rates, among other actions.

I will use t-tests for numeric variables to compare their means between different loan statuses. This will help me determine if there are significant differences in these variables between loans that are 'fully paid' and 'charged off'. For categorical variables, I will compare different categories within each variable to see if there are any notable differences in their distribution between 'fully paid' and 'charged off' loans. This will give me insights into how various categories within these variables might impact loan status.

### B1. Numerical variables vs Loan status

The numerical variables we need to analyze is: 
- (1) Loan amount
- (2) Interest rate
- (3) Installment
- (4) Annual income
- (5) Debt-to-income ratio
- (6) Revolving line utilization rate
- (7) The total number of credit account


**Steps to do a t-test:**

--- 

_Step 1: Define Hypotheses:_

- Null Hypothesis (H0): There is no significant difference between the means of the two status.
- Alternative Hypothesis (H1): There is a significant difference between the means of the two status.\
  
--- 

_Step 2: Choose the Appropriate t-test:_

Depending on whether the variances of the two samples are equal or not, we can choose between the equal variance t-test (also known as the pooled t-test) or the unequal variance t-test (also known as the Welch's t-test).

--- 

_Step 3: Calculate the t-statistic and Degrees of Freedom:_


![image](https://github.com/linhdan2109/Portfolio_Projects/assets/85982220/c6e94c68-76d9-41bf-8477-eaf59e5d2645)


--- 

_Step 4: Determine Critical Value:_

The significance level is this analysis is 0.05.
Look up the critical value from a [t-distribution table](https://www.sjsu.edu/faculty/gerstman/StatPrimer/t-table.pdf) based on the chosen significance level.

Due to the large number of records in our dataset, we can safely assume that the degrees of freedom (df) approach infinity. As a result, the critical t-value for a significance level of 0.05 is approximately 1.96.

--- 

_Step 5: Compare Results:_

Compare the calculated t-statistic to the critical value (1.96) If the calculated t-statistic is larger than 1.96, we can reject the null hypothesis

--- 

_Step 6: Interpret Results:_

If we reject the null hypothesis, it indicates that there is a significant difference between the means of the two samples. This could imply that the variable we are seeing has an impact on the outcome of loan status.

--- 

**(1) Loan amount vs Loan status**
```sql
WITH amnt_status AS (
	SELECT 
		loan_status,
		MIN(loan_amnt) OVER (PARTITION BY loan_status) AS min_amnt,
		PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY loan_amnt) OVER (PARTITION BY loan_status) AS Q1_amnt,
		AVG(loan_amnt) OVER (PARTITION BY loan_status) AS avg_amnt,
		PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY loan_amnt) OVER (PARTITION BY loan_status) AS Q2_amnt,
		PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY loan_amnt) OVER (PARTITION BY loan_status) AS Q3_amnt,
		MAX(loan_amnt) OVER (PARTITION BY loan_status) AS max_amnt,
		VAR(loan_amnt) OVER (PARTITION BY loan_status) AS var_amnt,
		STDEV(loan_amnt) OVER (PARTITION BY loan_status) AS sd_amnt,
		COUNT(loan_amnt) OVER (PARTITION BY loan_status) AS num_record
	FROM LoanData
)
SELECT 
	DISTINCT *
FROM amnt_status
WHERE loan_status != 'Current'
ORDER BY loan_status DESC;
```

| loan_status | min_amnt | Q1_amnt | avg_amnt | Q2_amnt | Q3_amnt | max_amnt | sd_amnt          | num_record  |
|-------------|----------|---------|----------|---------|---------|----------|------------------|-------------|
| Fully Paid  | 500      | 5200    | 10873    | 9600    | 15000   | 35000    | 7199.57064668193 | 32916       |
| Charged Off | 900      | 5600    | 12123    | 10000   | 16500   | 35000    | 8085.75485136552 | 5611        |



The t-value are calculated as followed:

![image](https://github.com/linhdan2109/Portfolio_Projects/assets/85982220/df6b430f-b99d-495a-aa60-33ac50439660)


Compare the t-value with the critical value, we have: 11.79 > 1.96 (t-value > critical value)

&rarr; Reject the null Hypothesis 

&rarr; There are different between loan amount of the two status 'Fully Paid' and 'Charged Off'

We can observe that the average loan amount for applications marked as 'charged off' is higher compared to those labeled as 'fully paid.' This suggests a potential connection between larger loan amounts and a higher chance of default.

**(2) Interest rate vs Loan status**

```sql
WITH int_status AS (
SELECT 
	loan_status,
	MIN(int_rate) OVER (PARTITION BY loan_status) AS min_int,
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY int_rate) OVER (PARTITION BY loan_status) AS Q1_int,
	AVG(int_rate) OVER (PARTITION BY loan_status) AS avg_int,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY int_rate) OVER (PARTITION BY loan_status) AS Q2_int,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY int_rate) OVER (PARTITION BY loan_status) AS Q3_int,
	MAX(int_rate) OVER (PARTITION BY loan_status) AS max_int,
	STDEV(int_rate) OVER (PARTITION BY loan_status) AS sd_int,
	COUNT(int_rate) OVER (PARTITION BY loan_status) AS num_record
FROM LoanData
)
SELECT 
	DISTINCT *
FROM int_status
WHERE loan_status != 'Current'
ORDER BY loan_status DESC;
```

| loan_status | min_int | Q1_int | avg_int           | Q2_int | Q3_int | max_int | sd_int             | num_record  |
|-------------|---------|--------|-------------------|--------|--------|---------|--------------------|-------------|
| Fully Paid  | 0.0542  | 0.0849 | 0.116058925750398 | 0.1149 | 0.1399 | 0.2411  | 0.0359907291755711 | 32916       |
| Charged Off | 0.0542  | 0.1128 | 0.138133166993404 | 0.1357 | 0.164  | 0.244   | 0.0365397137929156 | 5611        |


Instead of calculating manually, we can use a [t-test calculator](https://www.inchcalculator.com/t-test-calculator/) to compute the t-value. This tool simplifies the process and ensures accurate results.

Another way is to use statistical software such as R studio, SPSS Eview to do t-test, or if you know how to code, you also can use programing language such as R or Python to calculate t-value.

Now let's enter our data in to [t-test calculator](https://www.inchcalculator.com/t-test-calculator/) to compute the t-value to see if there are any different in interest rate between the two status.

![image](https://github.com/linhdan2109/Portfolio_Projects/assets/85982220/88c81446-65cb-4a97-ad28-1b95239104dd)

Here is the result:

![image](https://github.com/linhdan2109/Portfolio_Projects/assets/85982220/cab6858c-80c0-42b3-b2fa-0daa50b20a01)


Compare the t-value with the critical value, we have: 42.37 > 1.96 (t-value > critical value) 

Or we can use the p-value, if the p-value is smaller than the significant level (0.05) we can reject the null hypothesis. We have p-value is equal to 0.000000 (< 0.05)

&rarr; Reject the null Hypothesis 

&rarr; There are different between interest rate of the two status 'Fully Paid' and 'Charged Off'

We can observe that the average interest rate for applications marked as 'charged off' is higher compared to those labeled as 'fully paid.' (13% vs 11%). This suggests a potential connection between larger interest rate and a higher chance of default.

**Calculate the t-value for other numerical variables in the dataset**

| Variable                           | Average (Fully Paid) | SD (Fully Paid) | Sample size (Fully Paid) | Average (Charged Off) | SD (Charged Off) | Sample size (Charged Off) | t-value | Reject Hypothesis  | Interpretation                                                                              |
|------------------------------------|----------------------|-----------------|--------------------------|-----------------------|------------------|---------------------------|---------|--------------------|---------------------------------------------------------------------------------------------|
| Installment                        | 320.3                | 207.09          | 32916                    | 336.64                | 217.08           | 5611                      | 5.42    | :heavy_check_mark: | There are different between installment of the two status 'Fully Paid' and 'Charged Off'    |
| Annual income                      | 69882.63             | 66550.77        | 32916                    | 62512.27              | 47809.5          | 5611                      | 7.95    | :heavy_check_mark: | There are different between annual income of the two status 'Fully Paid' and 'Charged Off'  |
| Debt-to-income ratio               | 13.15                | 6.68            | 32916                    | 14                    | 6.58             | 5611                      | 8.83    | :heavy_check_mark: | There are different between dti of the two status 'Fully Paid' and 'Charged Off'            |
| Revolving line utilization rate    | 0.48                 | 0.28            | 32916                    | 0.56                  | 0.28             | 5611                      | 19.78   | :heavy_check_mark: | There are different between revolving rate of the two status 'Fully Paid' and 'Charged Off' |
| The total number of credit account | 22                   | 11.42           | 32916                    | 21                    | 11.45            | 5611                      | 6.06    | :heavy_check_mark: | There are different between total accounts of the two status 'Fully Paid' and 'Charged Off' |



**In general, in every numeric variable we analyze, I observe there are differences between the two groups: "Charged Off" and "Fully Paid".**

I have used t-tests calculation for numeric variables to compare their means between different loan statuses. And in the end, we have found that there was significant differences in all numeric variables we analyzed between loans that are 'fully paid' and 'charged off'. 

For futher analysis, if we build a model to predict which loan applicants might default, it would be a good idea to include all these numeric variables in the model.

### B2. Categorical  variables vs Loan status



















