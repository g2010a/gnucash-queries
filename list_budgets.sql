/*
 * Returns list of budgets
 * Columns:
 * budget_guid | name | description
 */

SELECT
	guid AS budget_guid,
  name AS budget_name,
  description AS budget_description
FROM budgets
WHERE num_periods = 12;
