/*
 * Aggregates the value of transactions of type 'EXPENSE' by month and account
 * Columns:
 * ebm_postdate | ebm_year | ebm_month | period_yearmonth | account | ebm_amount
 */

SELECT
	transactions.post_date AS ebm_postdate,
	strftime('%Y', timezone_adjusted_post_date) AS ebm_year,
	strftime('%m', timezone_adjusted_post_date)  AS ebm_month,
  substr(timezone_adjusted_post_date,1,7) AS period_yearmonth,
	acc.name AS account,
    SUM(1.0*splits.value_num/splits.value_denom) AS ebm_amount
FROM (
    /* Adjust for GnuCash time zone bug */
    SELECT *, 
    (CASE WHEN substr(post_date,9,6) >= '220000' 
        THEN date(substr(post_date,1,4)|| '-' ||substr(post_date,5,2)||'-'|| substr(post_date,7,2), '+1 day')
        ELSE date(substr(post_date,1,4)|| '-' ||substr(post_date,5,2)||'-'|| substr(post_date,7,2))
        END
        ) as timezone_adjusted_post_date
    FROM transactions
) AS transactions
    INNER JOIN splits ON splits.tx_guid = transactions.guid
    INNER JOIN (
        SELECT guid,
        	name 
        FROM accounts
        	WHERE account_type='EXPENSE'
            AND hidden = 0
    ) AS acc ON acc.guid = splits.account_guid
GROUP by 1,2,3,4
ORDER by 1,2,3,4;
