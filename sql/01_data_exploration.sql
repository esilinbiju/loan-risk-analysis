/*
==================================================
LOAN RISK ANALYSIS PROJECT
DATA EXPLORATION
==================================================

This script contains exploratory SQL queries used
to understand the structure, distribution, and
characteristics of the Lending Club loan dataset.

Dataset:
Lending Club Loans (2007-2015)

==================================================
*/

/*
==================================================
TOTAL LOANS
Objective:
Determine the number of unique loans in dataset
==================================================
*/

SELECT COUNT(*) AS total_loans
FROM loans;

/*
============================================================
LOAN CATEGORY DISTRIBUTION
Objective:
Determine the distribution of good and bad loans in dataset
============================================================
*/

SELECT loan_category, 
		COUNT(*) AS loan_count,
		ROUND(
			COUNT(*) * 100.0 /
			SUM(COUNT(*)) OVER (),
			2
		) AS percentage
FROM loans
GROUP BY loan_category;

/*
==================================================
LOAN STATUS DISTRIBUTION
Objective:
Analyse the  distribution of loan statuses
==================================================
*/

SELECT loan_status,
		COUNT(*) AS loan_count
FROM loans
GROUP BY loan_status
ORDER BY loan_count DESC;

/*
==================================================
DATASET DATE RANGE
Objective:
Understand the time period of the dataset
==================================================
*/

SELECT MIN(issue_d) AS earliest_loan,
		MAX(issue_d) AS latest_loan
FROM loans;

/*
==================================================
AVERAGE LOAN AMOUNT AND INTEREST RATE
Objective:
Determine the mean loan amount and interest rate
==================================================
*/

SELECT  ROUND(
		CAST(AVG(loan_amnt) AS numeric),2) 
			AS avg_loan_amount,
		ROUND(
		CAST(AVG(int_rate) AS numeric), 2) 
			AS avg_interest_rate
FROM loans;

/*
=====================================================
GRADE DISTRIBUTION
Objective:
Understand the distribution of total loans by grade
=====================================================
*/

SELECT grade,
		COUNT(*) AS total_loans,
		ROUND(
			COUNT(*) * 100.0/
			SUM(COUNT(*)) OVER(),
			2
		) AS percentage
FROM loans
GROUP BY grade
ORDER BY total_loans DESC;

/*
=======================================================
TOP LOAN PURPOSES
Objective:
Understand the distribution of purposes by total loans
=======================================================
*/

SELECT purpose,
		COUNT(*) AS total_loans,
		ROUND(
			COUNT(*) * 100.0/
			SUM(COUNT(*)) OVER(),
			2
		) AS percentage
FROM loans
GROUP BY purpose
ORDER BY total_loans DESC
LIMIT 10;