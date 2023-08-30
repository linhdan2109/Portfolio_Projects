# DATA ANALYSIS PROCESS - LOAN DATASET

## INTRODUCTION
This loan analysis project analyze various aspects related to loan data. This includes assessing borrower profiles, credit scores, financial histories, and repayment patterns. Through the application of data analysis techniques, the project aims to identify trends, risks, and opportunities for the company. The ultimate goal is to enhance decision-making processes, optimize lending strategies, and ensure the overall health of the lending business.

Download the SQL code file [here](https://github.com/linhdan2109/Portfolio_Projects/blob/main/Loan%20Analytics/DA_SQLcode.sql)

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

72% of the observations in the dataset have 36-month loans and 27% have 60-month loans.

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

There is a significant disparity between the lowest income ($4,000 USD) and the highest income ($6,000,000 USD) in the Lending Club dataset, and the standard deviation of income is also quite high. This indicates:

- (1) a wide range of income levels among borrowers, from those with low income to those with very high income or
- (2) There are outliners in annual income, These outliers can introduce noise to the analysis and lead to incorrect conclusions or
- (3) both (1) and (2).

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

Between 2007 and 2011, there was a significant increase in the number of loans issued. However, this growth slowed down as the years went by. While the total number of loans went up during this time, the rate of increase decreased over the years.

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

California has the highest number of loan applications, comprising about 17.88% of the total. Texas follows with around 6.86% of the total loan applications.

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

The debt-to-income ratio (DTI ratio) is a financial metric that reflects the proportion of a borrower's debt to their income. A DTI ratio exceeding 1 implies that the borrower's debt obligations surpass their income. 

From the table above, there are 38,703 borrowers in the dataset have DTI ratio > 1, that means 38,703 borrowers have more debt than their income. From a logical standpoint, this scenario is highly improbable and defies financial prudence. Borrowers would typically struggle to meet their obligations if their debt surpasses their income.

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
- Alternative Hypothesis (H1): There is a significant difference between the means of the two status.
  
--- 

_Step 2: Calculate the t-statistic and Degrees of Freedom:_


![image](https://github.com/linhdan2109/Portfolio_Projects/assets/85982220/c6e94c68-76d9-41bf-8477-eaf59e5d2645)


--- 

_Step 3: Determine Critical Value:_

The significance level is this analysis is 0.05.
Look up the critical value from a [t-distribution table](https://www.sjsu.edu/faculty/gerstman/StatPrimer/t-table.pdf) based on the chosen significance level.

Due to the large number of records in our dataset, we can safely assume that the degrees of freedom (df) approach infinity. As a result, the critical t-value for a significance level of 0.05 is approximately 1.96.

--- 

_Step 4: Compare Results:_

Compare the calculated t-statistic to the critical value (1.96) If the calculated t-statistic is larger than 1.96, we can reject the null hypothesis

--- 

_Step 5: Interpret Results:_

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

If we build a model to predict which loan applicants might default, it would be a good idea to include all these numeric variables in the model.

### B2. Categorical  variables vs Loan status

The categorical variables we need to analyze is:

- (1) Term
- (2) Grade
- (3) Home ownership
- (4) Verification status
- (5) Issue year
- (6) Purpose
- (7) State

When it comes to categorical variables, my approach involves comparing the distribution of different categories within each variable. The goal is to identify significant differences in distribution patterns between loans that are 'fully paid' and those that are 'charged off'. This analysis will provide valuable insights into how specific categories within these variables could be influential factors in determining loan status.

**The base rate of loan status**

In statistics, the term "base rate" refers to the natural frequency of an event occurring within a population. It represents the proportion an event occurs without any additional factors or interventions. The base rate is often used as a benchmark for comparison when evaluating the effectiveness of a model, test, or intervention.

The table below shows the base rate of loan status:

| loan_status | percent_loan_applications (base rate)  |
|-------------|----------------------------------------|
| Charged Off | 14.56                                  |
| Fully Paid  | 85.44                                  |


**(1) Term vs Loan status**
```sql
WITH term_status AS (
	SELECT 
		CASE
			WHEN term = 36 THEN '36 months' 
			WHEN term = 60 THEN '60 months'
		END AS term,
		CAST(COUNT(CASE WHEN loan_status = 'Fully Paid' THEN 1 ELSE NULL END) AS FLOAT) AS fully_paid,
		CAST(COUNT(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE NULL END) AS FLOAT) AS charged_off
	FROM LoanData
	GROUP BY term
)
SELECT 
	term,
	SUM(fully_paid)/SUM(fully_paid + charged_off) * 100 AS percent_fully_paid,
	SUM(charged_off)/SUM(fully_paid + charged_off) * 100 AS percent_charged_off
FROM term_status
GROUP BY term
ORDER BY term;
```

| term      | percent_fully_paid | percent_charged_off  |
|-----------|--------------------|----------------------|
| 36 months | 88.9359358325588   | 11.0640641674412     |
| 60 months | 74.7098543996624   | 25.2901456003376     |

The loan term duration appears to have a significant impact on the likelihood of a loan being fully paid or charged off.

Loans with a term duration of 36 months have a higher likelihood of being fully paid, with nearly 88.94% falling into this category. This suggests that loans with a shorter term are more likely to be successfully repaid. On the other hand, loans with a term duration of 60 months have a higher likelihood of being charged off, with approximately 25.29% falling into this category. This indicates that loans with a longer term might carry a somewhat higher risk of default.


**(2) Grade vs Loan status**
```sql
WITH grade_status AS (
	SELECT 
		grade,
		CAST(COUNT(CASE WHEN loan_status = 'Fully Paid' THEN 1 ELSE NULL END) AS FLOAT) AS fully_paid,
		CAST(COUNT(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE NULL END) AS FLOAT) AS charged_off
	FROM LoanData
	GROUP BY grade
)
SELECT 
	grade,
	SUM(fully_paid)/SUM(fully_paid + charged_off) * 100 AS percent_fully_paid,
	SUM(charged_off)/SUM(fully_paid + charged_off) * 100 AS percent_charged_off
FROM grade_status
GROUP BY grade
ORDER BY grade;
```

| grade | percent_fully_paid | percent_charged_off  |
|-------|--------------------|----------------------|
| A     | 94.006968641115    | 5.99303135888502     |
| B     | 87.793387013877    | 12.206612986123      |
| C     | 82.8260869565217   | 17.1739130434783     |
| D     | 78.0035509962517   | 21.9964490037483     |
| E     | 73.1900452488688   | 26.8099547511312     |
| F     | 67.4226804123711   | 32.5773195876289     |
| G     | 66.6666666666667   | 33.3333333333333     |

We see the grade of the loan clearly have a significant correlation with the loan status.

Higher-grade loans (A and B) have a higher likelihood of being fully paid and a lower likelihood of being charged off. These grades represent lower risk profiles. As loan grades descend (C, D, E, F, G), the percentage of fully paid loans decreases, and the percentage of charged-off loans increases. This suggests higher risk associated with lower-grade loans.

The data shows a clear gradation in default risk from higher to lower grades. Lenders assign grades based on risk assessment, and this data supports that grading system's accuracy in predicting loan outcomes.


**(3) Home ownership vs Loan status**
```sql
WITH home_status AS (
	SELECT 
		home_ownership,
		CAST(COUNT(CASE WHEN loan_status = 'Fully Paid' THEN 1 ELSE NULL END) AS FLOAT) AS fully_paid,
		CAST(COUNT(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE NULL END) AS FLOAT) AS charged_off
	FROM LoanData
	GROUP BY home_ownership
)
SELECT 
	home_ownership,
	SUM(fully_paid)/SUM(fully_paid + charged_off) * 100 AS percent_fully_paid,
	SUM(charged_off)/SUM(fully_paid + charged_off) * 100 AS percent_charged_off
FROM home_status
GROUP BY home_ownership
ORDER BY home_ownership;
```

| home_ownership | percent_fully_paid | percent_charged_off  |
|----------------|--------------------|----------------------|
| Mortgage       | 86.3433274544386   | 13.6566725455614     |
| None           | 100                | 0                    |
| Other          | 81.25              | 18.75                |
| Own            | 85.1515151515152   | 14.8484848484848     |
| Rent           | 84.6650043365134   | 15.3349956634866     |

For most home ownership categories, the percentage of loans that were "Fully Paid" is higher than the percentage that was "Charged Off." This indicates a general trend of better loan performance across various home ownership types. Futhermore, in different home ownership categories, the rate of both statuses 'Fully Paid' and 'Charged Off' are close to the base rate we have calculated before. 

So, Home ownership status don't seem to have any impact on loan outcomes.

**(4) Verification status vs Loan status**
```sql
WITH verified_status AS (
	SELECT 
		verification_status,
		CAST(COUNT(CASE WHEN loan_status = 'Fully Paid' THEN 1 ELSE NULL END) AS FLOAT) AS fully_paid,
		CAST(COUNT(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE NULL END) AS FLOAT) AS charged_off
	FROM LoanData
	GROUP BY verification_status
)
SELECT 
	verification_status,
	SUM(fully_paid)/SUM(fully_paid + charged_off) * 100 AS percent_fully_paid,
	SUM(charged_off)/SUM(fully_paid + charged_off) * 100 AS percent_charged_off
FROM verified_status
GROUP BY verification_status
ORDER BY verification_status;
```

| verification_status | percent_fully_paid | percent_charged_off  |
|---------------------|--------------------|----------------------|
| Not Verified        | 87.1887188718872   | 12.8112811281128     |
| Source Verified     | 85.195530726257    | 14.804469273743      |
| Verified            | 83.2322072810758   | 16.7677927189242     |

Same at home ownership atribute, across different verification status categories, the proportions of both 'Fully Paid' and 'Charged Off' statuses closely align with the base rate.

So, loan status appear to be unaffected by the verification status.

**(5) issue year vs Loan status**
```sql
WITH year_status AS (
	SELECT 
		YEAR(issue_d) AS issue_year,
		CAST(COUNT(CASE WHEN loan_status = 'Fully Paid' THEN 1 ELSE NULL END) AS FLOAT) AS fully_paid,
		CAST(COUNT(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE NULL END) AS FLOAT) AS charged_off
	FROM LoanData
	GROUP BY YEAR(issue_d)
)
SELECT 
	issue_year,
	SUM(fully_paid)/SUM(fully_paid + charged_off) * 100 AS percent_fully_paid,
	SUM(charged_off)/SUM(fully_paid + charged_off) * 100 AS percent_charged_off
FROM year_status
GROUP BY issue_year
ORDER BY issue_year;
```

| issue_year | percent_fully_paid | percent_charged_off  |
|------------|--------------------|----------------------|
| 2007       | 82.0717131474104   | 17.9282868525896     |
| 2008       | 84.3629343629344   | 15.6370656370656     |
| 2009       | 87.430880476393    | 12.569119523607      |
| 2010       | 87.1449665595414   | 12.8550334404586     |
| 2011       | 84.142000292583    | 15.857999707417      |

Same with the home and verification status, the issue year seems to not correlate with loan status.


**(6) Purpose vs Loan status**
```sql
WITH purpose_status AS (
	SELECT 
		purpose,
		CAST(COUNT(CASE WHEN loan_status = 'Fully Paid' THEN 1 ELSE NULL END) AS FLOAT) AS fully_paid,
		CAST(COUNT(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE NULL END) AS FLOAT) AS charged_off
	FROM LoanData
	GROUP BY purpose
)
SELECT 
	purpose,
	SUM(fully_paid)/SUM(fully_paid + charged_off) * 100 AS percent_fully_paid,
	SUM(charged_off)/SUM(fully_paid + charged_off) * 100 AS percent_charged_off
FROM purpose_status
GROUP BY purpose
ORDER BY percent_fully_paid DESC;
```

| purpose            | percent_fully_paid | percent_charged_off  |
|--------------------|--------------------|----------------------|
| Major Purchase     | 89.6921641791045   | 10.3078358208955     |
| Wedding            | 89.6216216216216   | 10.3783783783784     |
| Car                | 89.3787575150301   | 10.6212424849699     |
| Credit Card        | 89.2338308457711   | 10.7661691542289     |
| Home Improvement   | 88.01393728223     | 11.98606271777       |
| Vacation           | 85.8288770053476   | 14.1711229946524     |
| Debt Consolidation | 84.6921243695616   | 15.3078756304384     |
| Medical            | 84.5360824742268   | 15.4639175257732     |
| Moving             | 83.9721254355401   | 16.0278745644599     |
| House              | 83.9237057220708   | 16.0762942779292     |
| Other              | 83.6708203530633   | 16.3291796469367     |
| Educational        | 82.6086956521739   | 17.3913043478261     |
| Renewable Energy   | 81.3725490196078   | 18.6274509803922     |
| Small Business     | 72.9035938391329   | 27.0964061608671     |


Different loan purposes show varying percentages of both "Fully Paid" and "Charged Off" outcomes. This indicates that loan purpose might play a role in influencing loan repayment success or default rates.

Loan purposes such as "Car," "Credit Card," "Major Purchase," "Home Improvement" and "Wedding" exhibit relatively high percentages of "Fully Paid" outcomes. Borrowers with these loan purposes are more likely to fully repay their loans.

Loan purposes such as "Small Business," "Renewable Energy," "Educational" and "House" show relatively high percentages of "Charged Off" outcomes. These categories might carry a higher risk of default.

This variable could provide useful information in predicting loan status.


**(7) State vs Loan status**
```sql
WITH addr_status AS (
	SELECT 
		addr_state,
		CAST(COUNT(CASE WHEN loan_status = 'Fully Paid' THEN 1 ELSE NULL END) AS FLOAT) AS fully_paid,
		CAST(COUNT(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE NULL END) AS FLOAT) AS charged_off
	FROM LoanData
	GROUP BY addr_state
)
SELECT 
	addr_state,
	SUM(fully_paid)/SUM(fully_paid + charged_off) * 100 AS percent_fully_paid,
	SUM(charged_off)/SUM(fully_paid + charged_off) * 100 AS percent_charged_off
FROM addr_status
GROUP BY addr_state
ORDER BY percent_fully_paid DESC;
```

| addr_state | percent_fully_paid | percent_charged_off |
|------------|--------------------|---------------------|
| IN         | 100                | 0                   |
| ME         | 100                | 0                   |
| IA         | 100                | 0                   |
| WY         | 95                 | 5                   |
| DC         | 92.822966507177    | 7.17703349282297    |
| DE         | 90.1785714285714   | 9.82142857142857    |
| MS         | 89.4736842105263   | 10.5263157894737    |
| VT         | 88.6792452830189   | 11.3207547169811    |
| AR         | 88.4615384615385   | 11.5384615384615    |
| TN         | 88.2352941176471   | 11.7647058823529    |
| TX         | 88.1732580037665   | 11.8267419962335    |
| KS         | 87.7952755905512   | 12.2047244094488    |
| WV         | 87.7906976744186   | 12.2093023255814    |
| AL         | 87.7880184331797   | 12.2119815668203    |
| PA         | 87.7732240437158   | 12.2267759562842    |
| MA         | 87.7314814814815   | 12.2685185185185    |
| LA         | 87.5878220140515   | 12.4121779859485    |
| CO         | 87.2062663185379   | 12.7937336814621    |
| VA         | 87.1345029239766   | 12.8654970760234    |
| RI         | 87.1134020618557   | 12.8865979381443    |
| CT         | 87.0523415977961   | 12.9476584022039    |
| OH         | 86.9676320272572   | 13.0323679727428    |
| MT         | 86.7469879518072   | 13.2530120481928    |
| MN         | 86.7330016583748   | 13.2669983416252    |
| IL         | 86.6621530128639   | 13.3378469871361    |
| NY         | 86.6107654855288   | 13.3892345144712    |
| OK         | 86.0627177700349   | 13.9372822299652    |
| WI         | 85.876993166287    | 14.123006833713     |
| SC         | 85.6209150326797   | 14.3790849673203    |
| AZ         | 85.5791962174941   | 14.4208037825059    |
| KY         | 85.5305466237942   | 14.4694533762058    |
| MI         | 85.3693181818182   | 14.6306818181818    |
| NH         | 84.9397590361446   | 15.0602409638554    |
| NC         | 84.7797062750334   | 15.2202937249666    |
| WA         | 84.4553243574051   | 15.5446756425949    |
| NJ         | 84.4257703081232   | 15.5742296918768    |
| MD         | 84.2311459353575   | 15.7688540646425    |
| GA         | 84.1795437821928   | 15.8204562178072    |
| UT         | 84.1269841269841   | 15.8730158730159    |
| OR         | 83.8709677419355   | 16.1290322580645    |
| CA         | 83.8087006626333   | 16.1912993373668    |
| NM         | 83.6065573770492   | 16.3934426229508    |
| ID         | 83.3333333333333   | 16.6666666666667    |
| MO         | 83.1091180866966   | 16.8908819133034    |
| HI         | 83.030303030303    | 16.969696969697     |
| FL         | 81.9064748201439   | 18.0935251798561    |
| AK         | 80.7692307692308   | 19.2307692307692    |
| SD         | 80.327868852459    | 19.672131147541     |
| NV         | 77.4058577405858   | 22.5941422594142    |
| NE         | 40                 | 60                  |


From the table above, we see some states, such as "IN," "ME," and "IA," show a 100% "Fully Paid" rate. Other states with higher percentages of "Charged Off" outcomes include "NE," "NV," "AK," and "FL." These states have a higher risk of loans not being repaidThis might be due to limited data or specific characteristics unique to those states or just because there are only a few loan applications come from these states.

Many states exhibit percentages of "Fully Paid" and "Charged Off" outcomes around the 80-90% range. These states might represent more typical loan repayment patterns.

"NE" (Nebraska) state stands out with a notably higher "Charged Off" rate of 60%, suggesting a significantly higher risk of default compared to other states.

Different states show varying percentages of both "Fully Paid" and "Charged Off" outcomes, indicating that the location of borrowers might influence loan repayment success or default rates.


## CONCLUSION

In conclusion, our project aimed to identify the factors that distinguish between loans that are 'fully paid' and those that are 'charged off'. Through thorough analysis, we uncovered several key insights that shed light on the determinants of loan outcomes. We observed that various factors play significant roles in predicting whether a loan will be fully paid or charged off (see the table below).


| Variables (Feature)                | Correlate with loan status | How the variables correlate with loan status                   |
|------------------------------------|----------------------------|----------------------------------------------------------------|
| Loan amount                        | :heavy_check_mark:         | Larger loan amounts &rarr; Higher chance of default            |
| Interest rate                      | :heavy_check_mark:         | Higher interest rate &rarr; Higher chance of default           |
| Installment                        | :heavy_check_mark:         | Higher installment &rarr; Higher chance of default             |
| Annual income                      | :heavy_check_mark:         | Lower annual income &rarr; Higher chance of default            |
| Debt-to-income ratio               | :heavy_check_mark:         | Higher dti ratio &rarr; Higher chance of default               |
| Revolving line utilization rate    | :heavy_check_mark:         | Higher revolving rate &rarr; Higher chance of default          |
| The total number of credit account | :heavy_check_mark:         | Lower number of credit account &rarr; Higher chance of default |
| Term                               | :heavy_check_mark:         | Longer term &rarr; Higher chance of default                    |
| Grade                              | :heavy_check_mark:         | Lower grade &rarr; Higher chance of default                    |
| Home ownership                     | :x:                        |                                                                |
| Verification status                | :x:                        |                                                                |
| Issue year                         | :x:                        |                                                                |
| Purpose                            | :heavy_check_mark:         | Different purpose, different chance of default                 |
| State                              | :heavy_check_mark:         | Different state, different chance of default                   |

By understanding the interplay of these feature, Lending Club can make more informed decisions about loan approval. These insights contribute to a more comprehensive understanding of the factors that distinguish between 'fully paid' and 'charged off' loans, aiding in the development of effective lending strategies and risk management practices.

For futher development of this project, I want to use the insights I found to make a model that can predict if a loan will be 'fully paid' or 'charged off'. I will apply data science technique to create a strong predictive model for loan status to improve lending decisions and manage risks better. 

_(The author is still in the process of refining the data science workflow.)_
