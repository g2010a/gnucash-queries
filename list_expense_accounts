/*
 * Returns list of accounts of type 'EXPENSE'
 * Columns:
 * parent_account | account | account_is_hidden | account_is_placeholder
 */
 
SELECT
  	accounts.name AS parent_account,
    p_acc.name AS account,
    p_acc.hidden AS account_is_hidden,
    p_acc.placeholder AS account_is_placeholder
FROM accounts
INNER JOIN accounts AS p_acc ON p_acc.parent_guid = accounts.guid
	WHERE accounts.account_type = 'EXPENSE'
	AND accounts.hidden = 0
  AND p_acc.hidden = 0;
