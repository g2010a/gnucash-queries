/*
 * Budgeted expenses by year and month. Requires budgets' names to start with the
 * four digit year: '2020 Budget'
 * Columns:
 * budget_guid | account | budget_month | budget_year | period_yearmonth | budget_amount
 */
SELECT
	ba.budget_guid AS budget_guid,
	acc.name AS account,
    substr('0' || (ba.period_num+1) , -2, 2) AS budget_month,
    substr(budgets.name,1,4) AS budget_year,
    substr(budgets.name,1,4) || '-' || substr('0' || (ba.period_num+1) , -2, 2) AS period_yearmonth,
    1.0*ba.amount_num/ba.amount_denom AS budget_amount
FROM budgets
JOIN budget_amounts ba ON ba.budget_guid = budgets.guid
JOIN (
	SELECT guid,
    	name
    FROM accounts
    	WHERE account_type='EXPENSE'
    	AND hidden = 0
 ) AS acc ON acc.guid = ba.account_guid;
