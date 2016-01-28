-- Group by sites and gender
SELECT
	a.site_id, sum(a.impressions), b.name
FROM
	raw_nielsen_campaign_summary a
LEFT JOIN
	dim_nielsen_demo_group b
ON a.demo_id = b.demo_id 
-- Joining the two tables based on what demographic is in common
-- This allows the dim_nielsen_demo_group tablet to attach to the raw_nielsen_campaign_summary
-- in a way that attaches attributes such as demo, gender, and age to the raw_nielsen table
WHERE
	campaign_data_date = '12/15/2015'
GROUP BY
	a.site_id, b.name;


-- GOLDEN Question: What is the demographic breakdown across all our owned and operated sites?
-- First have to query correctly for all our O&O sites...(see query above)
-- Creating a temp table for the list of O&O brands? --> Ask Justin for clarification in case you f up hadoop
SELECT
	a.tag_placement_id as Domain, -- domain name and grouping attribute
	SUM(a.impressions) as Impressions, -- sum of impressions for that domain
	SUM(a.reach) as Reach, -- sum of reach for that domain
	MAX(a.universe_estimate) as Universe, -- largest universe for that domain 
	c.name as Demo -- demo info (gender and age) --> may need to convert to just gender (str) and age (int)
FROM
	raw_nielsen_campaign_placement a
LEFT JOIN
	dim_nielsen_demo_group c
ON 
	a.demo_id = c.demo_id -- tack demo attributes from demo dim table onto raw_nielsen table
WHERE
	a.campaign_data_date = "12/15/2015" AND
	a.tag_placement_id IN ( -- find a list of O&O brand domains
		SELECT
			DISTINCT b.tag_placement_id	
		FROM
			raw_nielsen_campaign_placement b
		WHERE
			b.campaign_data_date = '12/15/2015' AND
			b.site_id = 4574995 AND
		        (b.tag_placement_id LIKE 'aol.com' OR
			     b.tag_placement_id LIKE 'features.aol.com' OR
			     b.tag_placement_id LIKE 'on.aol.com' OR
			     b.tag_placement_id LIKE 'huffingtonpost.com' OR
			     b.tag_placement_id LIKE 'm.huffpost.com' OR
			     b.tag_placement_id LIKE 'engadget.com' OR
			     b.tag_placement_id LIKE 'live.huffingtonpost.com' OR
			     b.tag_placement_id LIKE 'huffingtonpost.co.uk' OR
			     b.tag_placement_id LIKE 'aol.co.uk' OR
			     b.tag_placement_id LIKE 'autoblog.com' OR
			     b.tag_placement_id LIKE 'techcrunch.com' OR
			     b.tag_placement_id LIKE 'm.aol.com' OR
			     b.tag_placement_id LIKE 'makers.com' OR
			     b.tag_placement_id LIKE 'ipad.aol.com' OR
			     b.tag_placement_id LIKE 'on.aol.ca' OR
			     b.tag_placement_id LIKE 'travel.aol.co.uk' OR
			     b.tag_placement_id LIKE 'aol.de' OR
			     b.tag_placement_id LIKE 'hp.features.aol.com' OR
			     b.tag_placement_id LIKE 'aol.ca' OR
			     b.tag_placement_id LIKE 'on.aol.co.uk' OR
			     b.tag_placement_id LIKE 'mandatory.com' OR
			     b.tag_placement_id LIKE 'news.moviefeone.com' OR
			     b.tag_placement_id LIKE 'mom.me' OR
			     b.tag_placement_id LIKE 'games.aol.co.uk' OR
			     b.tag_placement_id LIKE 'huffingtonpost.fr' OR
			     b.tag_placement_id LIKE 'aolplatforms.com' OR
			     b.tag_placement_id LIKE 'cars.aol.co.uk' OR
			     b.tag_placement_id LIKE 'jobs.aol.com' OR
			     b.tag_placement_id LIKE 'huffingtonpost.kr' OR
			     b.tag_placement_id LIKE 'm.on.aol.com' OR
			     b.tag_placement_id LIKE 'aol.fr' OR
			     b.tag_placement_id LIKE 'aoltv.com' OR
			     b.tag_placement_id LIKE 'mapquest.com' OR
			     b.tag_placement_id LIKE 'huffingtonpost.es' OR
			     b.tag_placement_id LIKE 'cn.engadget.com' OR
			     b.tag_placement_id LIKE 'blog.games.com' OR
			     b.tag_placement_id LIKE 'huffpostmaghreb.com' OR
			     b.tag_placement_id LIKE 'jp.techcrunch.com' OR
			     b.tag_placement_id LIKE 'huffingtonpost.de' OR
			     b.tag_placement_id LIKE 'kitchendaily.com' OR
			     b.tag_placement_id LIKE 'es.engadget.com' OR
			     b.tag_placement_id LIKE 'huffingtonpost.it' OR
			     b.tag_placement_id LIKE 'help.aol.com' OR
			     b.tag_placement_id LIKE 'techcrunch.cn' OR
			     b.tag_placement_id LIKE 'travel.aol.com' OR
			     b.tag_placement_id LIKE 'news.aol.jp' OR
			     b.tag_placement_id LIKE 'main.aol.com' OR
			     b.tag_placement_id LIKE 'joystiq.com' OR
			     b.tag_placement_id LIKE 'green.autoblog.com' OR
			     b.tag_placement_id LIKE 'tested.com' OR
			     b.tag_placement_id LIKE 'autos.aol.com' OR
			     b.tag_placement_id LIKE 'blog.aol.com' OR
			     b.tag_placement_id LIKE 'patch.com' OR
			     b.tag_placement_id LIKE 'get.aol.com' OR
			     b.tag_placement_id LIKE 'hp-consumer.aol.co.uk' OR
			     b.tag_placement_id LIKE 'downloaded.aol.com' OR
			     b.tag_placement_id LIKE 'help.aolonnetwork.com' OR
			     b.tag_placement_id LIKE 'learn.adap.tv' OR
			     b.tag_placement_id LIKE 'aolonnetwork.com' OR
			     b.tag_placement_id LIKE 'news.moviefone.ca' OR
			     b.tag_placement_id LIKE 'app.engadget.com' OR
			     b.tag_placement_id LIKE 'pawnation.com' OR
			     b.tag_placement_id LIKE 'embed.live.huffingtonpost.com' OR
			     b.tag_placement_id LIKE 'dailyfinance.com' OR
			     b.tag_placement_id LIKE 'twistings.aol.com' OR
			     b.tag_placement_id LIKE 'huffingtonpost.ca')
      )
GROUP BY
	a.tag_placement_id, c.name; -- grouping attributes; every domain gets each type of demo breakdown

