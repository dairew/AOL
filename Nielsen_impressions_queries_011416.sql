-- Total impressions by month since DECEMBER 2015
SELECT
     CONCAT(YEAR(campaign_data_date),MONTH(campaign_data_date)) AS Month
    , SUM(impressions)
FROM dwh.raw_nielsen_campaign_placement
WHERE 
    campaign_data_date > '2015-11-30'
GROUP BY
    CONCAT(YEAR(campaign_data_date), MONTH(campaign_data_date))
ORDER BYDec
	Month;

---DECEMBER
--impression volume grouped by placement_id
SELECT
     tag_placement_id AS Tag, 
     placement_id AS Placement_ID,
     SUM(impressions) AS Impressions
FROM dwh.raw_nielsen_campaign_placement
WHERE 
    campaign_data_date > '2015-11-30' and campaign_data_date < '2016-01-01'
GROUP BY
    tag_placement_id, placement_id
ORDER BY
	SUM(impressions) DESC;
	
--impression volume broken down by gender demo
SELECT
     b.name AS "Demographic", SUM(a.impressions) as "Impressions"
FROM dwh.raw_nielsen_campaign_placement a
JOIN dwh.dim_nielsen_demo_group b
ON a.demo_id = b.demo_id
WHERE 
    campaign_data_date > '2015-11-30' AND campaign_data_date < '2016-01-01' AND b.start_age IS NOT NULL AND b.end_age IS NOT NULL
GROUP BY
	b.name
ORDER BY
	SUM(a.impressions) DESC;
--Notes: Impression volume highest among older demographic (near positive linear correlation between age and impressions). Gender does not seem to be a key differentiator.

--most run aol_campaigns - ERRORs
SELECT
	c.name, c.aolcampaignid, c.type, COUNT(a.campaign_id) AS "COUNT"
FROM 
	dwh.raw_nielsen_campaign_placement a
JOIN dwh.dim_nielsen_campaign b --missing this table from Vertica (exists only on Hive)
ON a.campaign_id = b.nielsen_campaign_id
JOIN dwh.vidible_dim_nielsencampaign c
ON b.aol_campaign_id = c.aolcampaignid
WHERE
	campaign_data_date > '2015-11-30' AND campaign_data_date < '2016-01-01'
GROUP BY
	c.name, c.aolcampaignid, c.type
ORDER BY
	"COUNT" DESC;

---January-Present
--impression volume grouped by placement_id
SELECT
     tag_placement_id AS Tag, 
     placement_id AS Placement_ID,
     SUM(impressions) AS Impressions
FROM dwh.raw_nielsen_campaign_placement
WHERE 
    campaign_data_date > '2015-12-31'
GROUP BY
    tag_placement_id, placement_id
ORDER BY
	SUM(impressions) DESC;
--impression volume broken down by gender demo
SELECT
     b.name AS "Demographic", SUM(a.impressions) as "Impressions"
FROM dwh.raw_nielsen_campaign_placement a
JOIN dwh.dim_nielsen_demo_group b
ON a.demo_id = b.demo_id
WHERE 
    campaign_data_date > '2015-12-31' AND b.start_age IS NOT NULL AND b.end_age IS NOT NULL
GROUP BY
	b.name
ORDER BY
	SUM(a.impressions) DESC;
--Notes: Impression volume highest among older demographic (near positive linear correlation between age and impressions). Gender does not seem to be a key differentiator.
    
