--Player IDs with most bots_q4
SELECT
	player_id, sum(bots_q4) as "Q4 Frequency"
FROM
	dwh.vidible_performance_player
GROUP BY
	player_id
ORDER BY
	sum(bots_q4) DESC
LIMIT 25;
	

--Site with most bots_q4
SELECT
	site, sum(bots_q4)
FROM
	dwh.vidible_performance_player
WHERE 
	site LIKE 'aol.com' or site LIKE 'swagbucks.com'
GROUP BY
	site
ORDER BY
	sum(bots_q4) DESC;

	