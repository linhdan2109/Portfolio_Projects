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
			WHEN installment <= 200 THEN '0-200'
			WHEN installment > 200 AND installment <= 400 THEN '200 - 400'
			WHEN installment > 400 AND installment <= 600 THEN '400 - 600'
			WHEN installment > 600 AND installment <= 800 THEN '600 - 800'
			WHEN installment > 800 AND installment <= 1000 THEN '800 - 1000'
			WHEN installment > 1000 AND installment <= 1200 THEN '1000 - 1200'
			ELSE '> 1200'
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
			WHEN installment_range = '0-200' THEN 1
			WHEN installment_range = '200 - 400' THEN 2
			WHEN installment_range = '400 - 600' THEN 3
			WHEN installment_range = '600 - 800' THEN 4
			WHEN installment_range = '800 - 1000' THEN 5
			WHEN installment_range = '1000 - 1200' THEN 6
			ELSE 7
		END;
```
| installment_range | num_loan_applications | percent_loan_applications  |
|-------------------|-----------------------|----------------------------|
| 0-200             | 13244                 | 33.39                      |
| 200 - 400         | 15161                 | 38.22                      |
| 400 - 600         | 6872                  | 17.32                      |
| 600 - 800         | 2772                  | 6.99                       |
| 800 - 1000        | 1383                  | 3.49                       |
| 1000 - 1200       | 176                   | 0.44                       |
| > 1200            | 59                    | 0.15                       |

The data suggests that the majority of borrowers are paying relatively lower monthly installments. We can see that about 88.93% of loans have installment amounts that are under 600. 

There are a few loans with significantly higher installment amounts of others.

This information is crucial for understanding the affordability of loans for borrowers and for making informed decisions about lending terms and conditions.

**6. Grade**

7. Home Ownership

8. Annual income

9. Verification status

10. Issue Year

11. Loan status

12. Purposes

13. Borrowers Address state

14. Debt-to-income ratio (dti ratio)

15. Total credit revolving balance

16. Revolving line utilization rate (the amount of credit the borrower is using relative to all available revolving credit)

17. The total number of credit lines currently in the borrower's credit file

18, 19 and 20. Total payments, principal and interest received to date for total amount funded

## PART B: BIVARIATE ANALYSIS
