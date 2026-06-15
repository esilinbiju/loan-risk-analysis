/*
==================================================
LOAN RISK ANALYSIS PROJECT
TABLEAU DASHBOARD DATASETS
==================================================

This script contains the final SQL queries used to
generate the datasets powering the Tableau dashboard.

Dashboard Components:
1. Credit Grade Risk
2. Interest Rate Risk
3. DTI Risk
4. KPI Cards

==================================================
*/

/*
==================================================
GRADE RISK
Objective:
Measure bad-loan rates across credit grades
==================================================
*/

SELECT 
	grade,
	ROUND(
		SUM(CASE WHEN loan_category = 'Bad loans' THEN 1 ELSE 0 END)* 100.0
		/ COUNT(*),
		2
	) AS bad_loan_rate
FROM loans
GROUP BY grade
ORDER BY grade;

/*
==================================================
INTEREST RATE RISK
Objective:
Identify bad-loan rates across rate bands
==================================================
*/

SELECT
	CASE
		WHEN int_rate < 8 THEN 'Under 8%'
		WHEN int_rate < 12 THEN '8-12%'
		WHEN int_rate < 16 THEN '12-16%'
		WHEN int_rate < 20 THEN '16-20%'
		ELSE '20%+'
	END AS rate_band,

	ROUND(
		SUM(CASE WHEN loan_category = 'Bad loans' THEN 1 ELSE 0 END) * 100.0
		/ COUNT(*),
		2
	) AS bad_loan_rate
FROM loans
GROUP BY rate_band
ORDER BY
    CASE
        WHEN rate_band = 'Under 8%' THEN 1
        WHEN rate_band = '8-12%' THEN 2
        WHEN rate_band = '12-16%' THEN 3
        WHEN rate_band = '16-20%' THEN 4
        ELSE 5
    END;

/*
==================================================
Debt-to-Income (DTI) RISK
Objective:
Analyse bad loan rates across different DTI bands
==================================================
*/

SELECT 
	CASE
		WHEN dti < 10 THEN 'Low (<10)'
		WHEN dti < 20 THEN 'Moderate (10-19)'
		WHEN dti < 30 THEN 'High (20-29)'
		ELSE 'Very High (30+)'
	END AS dti_band,

	ROUND(
		SUM(CASE WHEN loan_category = 'Bad loans' THEN 1 ELSE 0 END) * 100.0
		/ COUNT(*),
		2
	) AS bad_loan_rate
FROM loans
GROUP BY dti_band
ORDER BY
    CASE
        WHEN dti_band = 'Low (<10)' THEN 1
        WHEN dti_band = 'Moderate (10-19)' THEN 2
        WHEN dti_band = 'High (20-29)' THEN 3
        ELSE 4
    END;

/*
==================================================
KPI Cards
==================================================
*/

SELECT 
	COUNT(*) AS total_loans,
	ROUND(
		SUM(CASE WHEN loan_category = 'Bad loans' THEN 1 ELSE 0 END) * 100.0
		/ COUNT(*),
		2
	) AS bad_loan_rate,
	ROUND(CAST(AVG(loan_amnt) AS numeric), 0) AS avg_loan_amount,
	ROUND(CAST(AVG(int_rate) AS numeric), 2) AS avg_interest_rate
FROM loans;