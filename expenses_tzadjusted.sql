/*
 * Returns transaction list for 'EXPENSE' accounts, correcting some timezone issues.
 * Columns:
 * account | e_commodity_mnemonic | e_commodity_name | e_commodity_namespace | e_transaction_postdate |
 * e_transaction_year | e_transaction_month | e_transaction_day | period_yearmonth |
 * e_transaction_description | e_split_guid | e_split_memo | e_split_action | e_amount |
 * e_quantity | timezone_adjusted_post_date
 */
 
 SELECT
    acc.name AS account,
    commodities.mnemonic AS e_commodity_mnemonic,
    commodities.fullname AS e_commodity_name,
    commodities.namespace AS e_commodity_namespace,
    transactions.post_date AS e_transaction_postdate,
    substr(timezone_adjusted_post_date,1,4) AS e_transaction_year,
    substr(timezone_adjusted_post_date,6,2) AS e_transaction_month,
    substr(timezone_adjusted_post_date,9,2) AS e_transaction_day,
    substr(timezone_adjusted_post_date,1,7) AS period_yearmonth,
    transactions.description AS e_transaction_description,
    splits.guid AS e_split_guid,
    splits.memo AS e_split_memo,
    splits.action AS e_split_action,
    1.0*value_num/value_denom AS e_amount,
    1.0*splits.quantity_num/splits.quantity_denom AS e_quantity,
    timezone_adjusted_post_date
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
    SELECT 
        guid,
        name,
        commodity_guid
    FROM accounts
        WHERE account_type = 'EXPENSE'
        AND hidden = 0
) AS acc ON acc.guid = splits.account_guid
JOIN commodities ON acc.commodity_guid = commodities.guid
ORDER BY transactions.timezone_adjusted_post_date;
