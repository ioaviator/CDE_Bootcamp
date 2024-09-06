
SELECT 
      s.id,
      s.name AS sales_rep,
	  r.name AS region,
SUM(total_amt_usd) AS total_order 	
FROM orders o
INNER JOIN region r
ON o.id = r.id
INNER JOIN sales_reps s
ON s.region_id = r.id	
GROUP BY sales_rep,
         s.id,
	     region
ORDER BY total_order DESC