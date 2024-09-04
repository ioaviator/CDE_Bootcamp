/* Find a list of order IDs where either gloss_qty or poster_qty is greater than 4000. 
Only include the id field in the resulting table. */

SELECT id FROM orders 
WHERE gloss_qty > 4000 OR poster_qty > 4000



-- /* Write a query that returns a list of orders where the standard_qty is zero and 
-- either the gloss_qty or poster_qty is over 1000. */

SELECT * FROM orders 
WHERE standard_qty = 0 AND (gloss_qty > 100 OR poster_qty > 100)



-- /* Find all the company names that start with a 'C' or 'W', and where 
-- the primary contact contains 'ana' or 'Ana', but does not contain 'eana'. */

SELECT name
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%')
  AND (primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%')
  AND primary_poc NOT LIKE '%eana%';



/* Provide a table that shows the region for each sales rep along with their associated accounts. 
Your final table should include three columns: the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) by account name. */
 
 SELECT s_rep.name AS sales_rep, rgn.name AS region, acct.name AS account_name 
FROM sales_reps AS s_rep
LEFT JOIN region AS rgn 
	ON s_rep.region_id = rgn.id
RIGHT JOIN accounts AS acct 
	ON acct.sales_rep_id = s_rep.id

