-- PART A: UNIVARIATE ANALYSIS

-- 1. Number of Loan applicants
	SELECT
		COUNT(*) AS num_applicants
	FROM LoanData;

-- 2. Loan amount statistics
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

-- 3. term
	SELECT 
		term,
		COUNT(*) AS num_loan_applications,
		ROUND(CAST(COUNT(*) AS FLOAT) * 100 / (SELECT COUNT(*) FROM LoanData)
			, 2) AS percent_loan_applications
	FROM LoanData
	GROUP BY term
	ORDER BY term;

-- 4. Interest rate
	SELECT
		ROUND(int_rate, 2) AS interest,
		COUNT(*) AS num_loan_applications,
		ROUND(CAST(COUNT(*) AS FLOAT) * 100 / (SELECT COUNT(*) FROM LoanData)
			, 2) AS percent_loan_applications
	FROM LoanData
	GROUP BY ROUND(int_rate, 2)
	ORDER BY interest;

-- 5. Installment distribution
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

-- 6. Grade
	SELECT
		grade,
		COUNT(*) AS num_loan_applications,
		ROUND(CAST(COUNT(*) AS FLOAT) * 100 / (SELECT COUNT(*) FROM LoanData)
			, 2) AS percent_loan_applications
	FROM LoanData
	GROUP BY grade
	ORDER BY grade;

-- 7. Home Ownership
	SELECT
		home_ownership,
		COUNT(*) AS num_loan_applications,
		ROUND(CAST(COUNT(*) AS FLOAT) * 100 / (SELECT COUNT(*) FROM LoanData)
			, 2) AS percent_loan_applications
	FROM LoanData
	GROUP BY home_ownership
	ORDER BY num_loan_applications DESC;

-- 8. Annual income
	-- Find min, max, average and standard deviation of annual income
	SELECT
		MIN(annual_inc) AS min_inc,
		AVG(annual_inc) AS avg_inc,
		MAX(annual_inc) AS max_inc,
		STDEV(annual_inc) AS sd_inc
	FROM LoanData;

	-- Find percentiles of annual income
	SELECT
		DISTINCT PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY annual_inc) OVER() AS percentile_5th_inc,
		PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY annual_inc) OVER() AS Q1_inc,
		PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY annual_inc) OVER () AS Q2_inc,
		PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY annual_inc) OVER () AS Q3_inc,
		PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY annual_inc) OVER() AS percentile_95th_inc
	FROM LoanData;

	-- Find min, max and average of annual income after remove outliner
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

-- 9. Verification status
	SELECT
		verification_status,
		COUNT(*) AS num_loan_applications,
		ROUND(CAST(COUNT(*) AS FLOAT) * 100 / (SELECT COUNT(*) FROM LoanData)
			, 2) AS percent_loan_applications
	FROM LoanData
	GROUP BY verification_status
	ORDER BY num_loan_applications DESC;

-- 10. Issue Year
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

-- 11. Loan status
	-- Loan status (with current applications)
	SELECT
		loan_status,
		COUNT(*) AS num_loan_applications,
		ROUND(CAST(COUNT(*) AS FLOAT) * 100 / (SELECT COUNT(*) FROM LoanData)
			, 2) AS percent_loan_applications
	FROM LoanData
	GROUP BY loan_status
	ORDER BY loan_status;

	-- Loan status (without current applications)
	SELECT
		loan_status,
		COUNT(*) AS num_loan_applications,
		ROUND(CAST(COUNT(*) AS FLOAT) * 100 / (SELECT COUNT(*) FROM LoanData WHERE loan_status != 'Current')
			, 2) AS percent_loan_applications
	FROM LoanData
	WHERE loan_status != 'Current'
	GROUP BY loan_status
	ORDER BY loan_status;

-- 12. Purposes
	SELECT
		purpose,
		COUNT(*) AS num_loan_applications,
		ROUND(CAST(COUNT(*) AS FLOAT) * 100 / (SELECT COUNT(*) FROM LoanData)
			, 2) AS percent_loan_applications
	FROM LoanData
	GROUP BY purpose
	ORDER BY num_loan_applications DESC;

-- 13. Borrowers Address state
	-- TOP 10 state have the most loan applicants
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

-- 14. Debt-to-income ratio (dti ratio)
	-- View number of borrower by dti ratio (whether it's smaller than 1 or not)
	SELECT
		CASE 
			WHEN dti < 1 THEN 'dti < 1'
			ELSE 'dti > 1'
		END AS dti,
		COUNT(*) AS num_borrower
	FROM LoanData
	GROUP BY CASE WHEN dti < 1 THEN 'dti < 1' ELSE 'dti > 1' END;
	
	-- Find min, max and average of dti ratio
	SELECT
		MIN(dti) AS min_dti,
		AVG(dti) AS avg_dti,
		MAX(dti) AS max_dti
	FROM LoanData;

	-- Divide dti by 100
	SELECT
		MIN(dti/100) AS min_dti,
		AVG(dti/100) AS avg_dti,
		MAX(dti/100) AS max_dti
	FROM LoanData;

-- 15. Total credit revolving balance 
	-- Find min, max, average and standard deviation of total credit revolving balance 
	SELECT
		MIN(revol_bal) AS min_bal,
		AVG(revol_bal) AS avg_val,
		MAX(revol_bal) AS max_bal,
		STDEV(revol_bal) AS sd_bal
	FROM LoanData;


-- 16. Revolving line utilization rate (the amount of credit the borrower is using relative to all available revolving credit)
	SELECT 
		ROUND(revol_util, 1) AS revol_util,
		COUNT(*) AS num_loan_applications
	FROM LoanData
	GROUP BY ROUND(revol_util, 1)
	ORDER BY ROUND(revol_util, 1);


-- 17. The total number of credit lines currently in the borrower's credit file
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

-- 18, 19 and 20: Total payments, principal and interest received to date for total amount funded
	-- Sum of payments, interest and principal in the period 2007 - 2011 
	SELECT 
		SUM(total_pymnt) AS sum_payment,
		SUM(total_rec_prncp) AS sum_principle,
		SUM(total_rec_int) AS sum_interest
	FROM LoanData

	-- Tracking total payments, interest and principal for loan applications' status is 'Charged Off'
	SELECT 
		id, 
		loan_amnt,
		total_pymnt,
		total_rec_prncp,
		total_rec_int,
		total_rec_prncp/loan_amnt AS debt_payoff_rate
	FROM LoanData
	WHERE loan_status = 'Charged Off'

	
	-- Tracking total payments, interest and principal for loan applications' status is 'Current
	SELECT 
		id, 
		loan_amnt,
		total_pymnt,
		total_rec_prncp,
		total_rec_int,
		total_rec_prncp/loan_amnt AS debt_payoff_rate
	FROM LoanData
	WHERE loan_status = 'Current'

	-- Total payments by loan status and year
	SELECT
		YEAR(issue_d) AS issue_year,
		ROUND(SUM(CASE WHEN loan_status = 'Fully Paid' THEN total_pymnt ELSE 0 END), 2) AS fully_paid,
		ROUND(SUM(CASE WHEN loan_status = 'Charged Off' THEN total_pymnt ELSE 0 END), 2) AS charged_off,
		ROUND(SUM(CASE WHEN loan_status = 'Current' THEN total_pymnt ELSE 0 END), 2) AS current_loan,
		ROUND(SUM(CASE WHEN loan_status = 'Fully Paid' THEN total_pymnt ELSE 0 END)/ SUM(total_pymnt), 2) AS fully_paid_rate
	FROM LoanData
	GROUP BY YEAR(issue_d)
	ORDER BY YEAR(issue_d);


-- PART B: BIVARIATE ANALYSIS
-- Loan amount vs Loan status
	WITH amnt_status AS (
		SELECT 
			loan_status,
			MIN(loan_amnt) OVER (PARTITION BY loan_status) AS min_amnt,
			PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY loan_amnt) OVER (PARTITION BY loan_status) AS Q1_amnt,
			AVG(loan_amnt) OVER (PARTITION BY loan_status) AS avg_amnt,
			PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY loan_amnt) OVER (PARTITION BY loan_status) AS Q2_amnt,
			PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY loan_amnt) OVER (PARTITION BY loan_status) AS Q3_amnt,
			MAX(loan_amnt) OVER (PARTITION BY loan_status) AS max_amnt,
			STDEV(loan_amnt) OVER (PARTITION BY loan_status) AS sd_amnt,
			COUNT(loan_amnt) OVER (PARTITION BY loan_status) AS num_record
		FROM LoanData
	)
	SELECT 
		DISTINCT *
	FROM amnt_status
	WHERE loan_status != 'Current'
	ORDER BY loan_status DESC;

-- Term vs Loan status
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

-- Interest rate vs loan status
	-- interest rate statistic by loan status
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

-- Installment vs Loan status
	WITH installment_status AS (
		SELECT 
			loan_status,
			MIN(installment) OVER (PARTITION BY loan_status) AS min_installment,
			PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY installment) OVER (PARTITION BY loan_status) AS Q1_installment,
			AVG(installment) OVER (PARTITION BY loan_status) AS avg_installment,
			PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY installment) OVER (PARTITION BY loan_status) AS Q2_installment,
			PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY installment) OVER (PARTITION BY loan_status) AS Q3_installment,
			MAX(installment) OVER (PARTITION BY loan_status) AS max_installment,
			STDEV(installment) OVER (PARTITION BY loan_status) AS sd_installment,
			COUNT(int_rate) OVER (PARTITION BY loan_status) AS num_record
		FROM LoanData
	)
	SELECT 
		DISTINCT *
	FROM installment_status
	WHERE loan_status != 'Current'
	ORDER BY loan_status DESC;

-- Grade vs Loan status
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

-- Home ownership vs Loan status
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

-- Annual income vs Loan status
	WITH inc_status AS (
		SELECT 
			loan_status,
			MIN(annual_inc) OVER (PARTITION BY loan_status) AS min_inc,
			PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY annual_inc) OVER (PARTITION BY loan_status) AS Q1_inc,
			AVG(annual_inc) OVER (PARTITION BY loan_status) AS avg_inc,
			PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY annual_inc) OVER (PARTITION BY loan_status) AS Q2_inc,
			PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY annual_inc) OVER (PARTITION BY loan_status) AS Q3_inc,
			MAX(annual_inc) OVER (PARTITION BY loan_status) AS max_inc,
			STDEV(annual_inc) OVER (PARTITION BY loan_status) AS sd_inc,
			COUNT(int_rate) OVER (PARTITION BY loan_status) AS num_record
		FROM LoanData
	)
	SELECT 
		DISTINCT *
	FROM inc_status
	WHERE loan_status != 'Current'
	ORDER BY loan_status DESC;

-- Verification status va Loan status
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

-- Issue year vs Loan status
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

-- Purpose vs Loan status
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

-- Address state vs Loan status
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

-- DTI vs Loan status
	WITH dti_status AS (
		SELECT 
			loan_status,
			MIN(dti) OVER (PARTITION BY loan_status) AS min_dti,
			PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY dti) OVER (PARTITION BY loan_status) AS Q1_dti,
			AVG(dti) OVER (PARTITION BY loan_status) AS avg_dti,
			PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY dti) OVER (PARTITION BY loan_status) AS Q2_dti,
			PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY dti) OVER (PARTITION BY loan_status) AS Q3_dti,
			MAX(dti) OVER (PARTITION BY loan_status) AS max_dti,
			STDEV(dti) OVER (PARTITION BY loan_status) AS sd_dti,
			COUNT(int_rate) OVER (PARTITION BY loan_status) AS num_record
		FROM LoanData
	)
	SELECT 
		DISTINCT *
	FROM dti_status
	WHERE loan_status != 'Current'
	ORDER BY loan_status DESC;

--  Revolving utilization rate vs Loan status 
	WITH revol_status AS (
	SELECT 
		loan_status,
		MIN(revol_util) OVER (PARTITION BY loan_status) AS min_revol,
		PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY revol_util) OVER (PARTITION BY loan_status) AS Q1_revol,
		AVG(revol_util) OVER (PARTITION BY loan_status) AS avg_revol,
		PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY revol_util) OVER (PARTITION BY loan_status) AS Q2_revol,
		PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY revol_util) OVER (PARTITION BY loan_status) AS Q3_revol,
		MAX(revol_util) OVER (PARTITION BY loan_status) AS max_revol,
		STDEV(revol_util) OVER (PARTITION BY loan_status) AS sd_revol,
		COUNT(int_rate) OVER (PARTITION BY loan_status) AS num_record
	FROM LoanData
)
	SELECT 
		DISTINCT *
	FROM revol_status
	WHERE loan_status != 'Current'
	ORDER BY loan_status DESC;

-- Total account vs Loan status
	WITH acc_status AS (
		SELECT 
			loan_status,
			MIN(total_acc) OVER (PARTITION BY loan_status) AS min_acc,
			PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_acc) OVER (PARTITION BY loan_status) AS Q1_acc,
			AVG(total_acc) OVER (PARTITION BY loan_status) AS avg_acc,
			PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_acc) OVER (PARTITION BY loan_status) AS Q2_acc,
			PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_acc) OVER (PARTITION BY loan_status) AS Q3_acc,
			MAX(total_acc) OVER (PARTITION BY loan_status) AS max_acc,
			STDEV(total_acc) OVER (PARTITION BY loan_status) AS sd_acc,
			COUNT(int_rate) OVER (PARTITION BY loan_status) AS num_record
		FROM LoanData
	)
	SELECT 
		DISTINCT *
	FROM acc_status
	WHERE loan_status != 'Current'
	ORDER BY loan_status DESC;