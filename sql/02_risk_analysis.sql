/*
==================================================
LOAN RISK ANALYSIS PROJECT
RISK ANALYSIS
==================================================

This script investigates factors associated with
loan defaults and evaluates borrower risk across
credit grades, loan purposes, income levels,
interest-rate bands, DTI bands, employment tenure,
and loan-size categories.

==================================================
*/

/*
============================================================
OVERALL BAD LOAN RATE
Objective:
Determine the consolidated bad loan rate for the dataset
============================================================
*/

SELECT
	ROUND (
			SUM(CASE WHEN loan_category = 'Bad loans' THEN 1 ELSE 0 END) * 100.0
			/ COUNT(*),
			2
	) AS bad_loan_percentage
FROM loans;

/*
==================================================
BAD LOAN RATE BY GRADE
Objective:
Analyse the grade-wise bad loan rate 
==================================================
*/

SELECT grade,
		COUNT(*) AS total_loans,
		SUM(CASE WHEN loan_category = 'Bad loans' THEN 1 ELSE 0 END) AS bad_loans,
		ROUND(
			SUM(CASE WHEN loan_category = 'Bad loans' THEN 1 ELSE 0 END) * 100.0
			/ COUNT(*),
			2
		) AS bad_loan_rate
FROM loans
GROUP BY grade
ORDER BY bad_loan_rate DESC;

/*
==============================================================
BAD LOAN RATE BY PURPOSE
Objective:
Identify loan purposes associated with higher bad-loan rates	
==============================================================
*/

SELECT purpose,
		COUNT(*) AS total_loans,
		ROUND(
			SUM(CASE WHEN loan_category = 'Bad loans' THEN 1 ELSE 0 END) * 100.0
			/ COUNT(*),
			2
		) AS bad_loan_rate
FROM loans
GROUP BY purpose
HAVING COUNT(*) > 1000
ORDER BY bad_loan_rate DESC;

/*
==============================================================
INTEREST RATE COMPARISON
Objective:
Understand the average interest rate for good and bad loans
==============================================================
*/

SELECT loan_category,
		ROUND(CAST(AVG(int_rate) AS numeric), 2) AS average_interest_rate
FROM loans
GROUP BY loan_category;

/*
=========================================================
INCOME COMPARISON
Objective:
Analyse the average annual income based on loan category
=========================================================
*/

SELECT loan_category,
		ROUND(CAST(AVG(annual_inc) AS numeric), 2) AS avg_annual_income
FROM loans
GROUP BY loan_category;

/*
============================================================
STATE-WISE RISK ANALYSIS
Objective:
Understand the distribution of bad loan rates across states
============================================================
*/

SELECT addr_state,
		COUNT(*) AS total_loans,
		ROUND(
			SUM(CASE WHEN loan_category = 'Bad loans' THEN 1 ELSE 0 END) * 100.0
			/COUNT(*),
			2
		) AS bad_loan_rate
FROM loans
GROUP BY addr_state
HAVING COUNT(*) > 1000
ORDER BY bad_loan_rate DESC;

/*
==================================================
DTI ANALYSIS
Objective:
Analyse bad loan rates based on DTI bands 
==================================================
*/

SELECT 
	CASE
		WHEN dti < 10 THEN 'Low (<10)'
		WHEN dti < 20 THEN 'Moderate (10-19)'
		WHEN dti < 30 THEN 'High (20-29)'
		ELSE 'Very High (30+)'
	END AS dti_band,

	COUNT(*) AS total_loans,

	ROUND(
		SUM(CASE WHEN loan_category = 'Bad loans' THEN 1 ELSE 0 END) * 100.0
		/ COUNT(*),
		2
	) AS bad_loan_rate

FROM loans
GROUP BY dti_band
ORDER BY bad_loan_rate DESC;

/*
=====================================================
INTEREST RATE BAND ANALYSIS
Objective:
Analyse the bad loan rate on the basis of rate bands
=====================================================
*/

SELECT 
	CASE
		WHEN int_rate < 8 THEN 'Under 8%'
		WHEN int_rate < 12 THEN '8%-12%'
		WHEN int_rate < 16 THEN '12-16%'
		WHEN int_rate < 20 THEN '16-20%'
		ELSE '20%+'
	END AS rate_band,

	COUNT(*) AS total_loans,

	ROUND(
		SUM(CASE WHEN loan_category = 'Bad loans' THEN 1 ELSE 0 END) * 100.0
		/ COUNT(*),
		2
	) AS bad_loan_rate

FROM loans
GROUP BY rate_band
ORDER BY bad_loan_rate DESC;

/*
========================================================================
EMPLOYMENT LENGTH ANALYSIS
Objective:
Evaluate the relationship between employment tenure and bad-loan rates
========================================================================
*/

SELECT 
	emp_length,
	
	COUNT(*) AS total_loans,

	ROUND(
		SUM(CASE WHEN loan_category = 'Bad loans' THEN 1 ELSE 0 END) * 100
		/ COUNT(*),
		2
	) AS bad_loan_rate
FROM loans
WHERE emp_length IS NOT NULL

GROUP BY emp_length
HAVING COUNT(*) > 1000

ORDER BY bad_loan_rate DESC;

/*
========================================================
LOAN AMOUNT ANALYSIS
Objective:
Analyse bad loan rate based on loan amount distribution
========================================================
*/

SELECT 
	CASE
		WHEN loan_amnt < 5000 THEN 'Under $5K'
		WHEN loan_amnt < 10000 THEN '$5K-$10K'
		WHEN loan_amnt < 20000 THEN '$10K-$20K'
		ELSE '$20K+'
	END AS loan_band,

	COUNT(*) AS total_loans,

	ROUND(
		SUM(CASE WHEN loan_category = 'Bad loans' THEN 1 ELSE 0 END) * 100.0
		/ COUNT (*),
		2
	) AS bad_loan_rate

FROM loans
GROUP BY loan_band
ORDER BY bad_loan_rate DESC;

/*
==================================================
LOAN YEAR ANALYSIS
Objective:
Evaluate lending volume and bad-loan rates over time
==================================================
*/

SELECT
    DATE_TRUNC('year', issue_d) AS loan_year,
    COUNT(*) AS total_loans,
    ROUND(
        SUM(CASE WHEN loan_category = 'Bad loans' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS bad_loan_rate
FROM loans
GROUP BY loan_year
ORDER BY loan_year;