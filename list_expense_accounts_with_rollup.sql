/*
 * Returns a table that can be used as the basis for a hierarchical tree
 * of accounts of type 'EXPENSE' with the account they roll up 
 * in their hierarchy. Works for accounts with max. 5 nested levels. E.g.
 * ROOT:Expenses:Auto:Gas returns Gas | Auto
 * Columns:
 * account | rollup_account
*/

SELECT a3.name AS account,
	a3.name as rollup_account
FROM accounts AS a1
LEFT JOIN accounts AS a2 ON a2.parent_guid = a1.guid
LEFT JOIN accounts AS a3 ON a3.parent_guid = a2.guid
WHERE a1.account_type = 'ROOT' 
	AND a2.account_type = 'EXPENSE'
	AND a3.name IS NOT NULL
UNION
SELECT 
	CASE WHEN a5.name IS NOT NULL THEN a5.name ELSE a4.name END AS account,
	a3.name AS rollup_account
FROM accounts AS a1
	LEFT JOIN accounts AS a2 ON a2.parent_guid = a1.guid
	LEFT JOIN accounts AS a3 ON a3.parent_guid = a2.guid
	LEFT JOIN accounts AS a4 ON a4.parent_guid = a3.guid
	LEFT JOIN accounts AS a5 ON a5.parent_guid = a4.guid
WHERE a1.account_type = 'ROOT'
	AND a2.account_type = 'EXPENSE'
	AND a3.name IS NOT NULL
	AND (a4.name IS NOT NULL OR a5.name IS NOT NULL)
ORDER BY 2,1;
