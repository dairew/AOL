--Nielsen
--01.28.16 added in demo impression % info
SELECT
    a.tag_placement_id 
    , b.name
    , SUM(impressions) -- % of total impressions for each demo calculated in excel
FROM
    raw_nielsen_campaign_placement a
LEFT JOIN
    dim_nielsen_demo_group b
ON
    a.demo_id = b.demo_id 
WHERE 
    site_id = 4574995 
    AND campaign_data_date > '12/29/2015'
GROUP BY 
    a.tag_placement_id, b.name;

---------------------------------------------------------------------

-- IAS, Distil
SELECT 
      PP.domain --groupby column
    , SUM(displays) AS displays
    , SUM(video_plays) AS video_plays
    , SUM(impressions) AS impressions
    , SUM(ad_requests) AS ad_requests
    , SUM(clicks) AS clicks
    , SUM(ad_clicks) AS ad_clicks
    , SUM(dbg_display_time_sum) AS dbg_display_time_sum
    , SUM(dbg_display_time_count) AS dbg_display_time_count
    , SUM(dbg_display_time_sum) / SUM(dbg_display_time_count) AS Avg_Player_Load_Time_Ms
        /*ad blocking*/
    , SUM(ad_blocks_yes) AS Ad_blocks_yes
    , SUM(ad_blocks_no) AS ad_blocks_no
    , SUM(ad_blocks_yes) / (SUM(ad_blocks_yes) + SUM(ad_blocks_no)) AS Ad_block_rate
        /*fraud, bots*/
    , SUM(bots_q0) AS bots_q0_Distill
    , SUM(bots_q4) AS bots_q4_Distill
    , SUM(bots_q4)/(SUM(bots_q4) + SUM(bots_q3) + SUM(bots_q2) + SUM(bots_q1) + SUM(bots_q0)) AS perc_bots_q4
    , SUM(ias_impressions_fraud) AS ias_impressions_fraud
    , SUM(ias_impressions_ok) AS ias_impressions_ok
    , SUM(ias_measurable) AS ias_measurable
    , SUM(ias_impressions_fraud) / SUM(ias_measurable) AS ias_impressions_fraud_rate 
FROM dwh.vidible_performance_player AS PP
WHERE 
    PP.date < GETDATE() - 1 
    AND PP.date > GETDATE() - 2
GROUP BY      
      PP.domain
HAVING
        SUM(displays) > 0
    AND SUM(video_plays) > 0
    AND SUM(impressions) > 0
    AND SUM(ad_requests) > 0
    AND SUM(clicks) > 0
    AND SUM(ad_clicks) > 0
    AND SUM(dbg_display_time_sum) > 0
    AND SUM(dbg_display_time_count) > 0;

--IAS, Distil Bot Breakdown Percentages
-- IAS, Distil
SELECT 
      PP.domain --groupby column
    , SUM(bots_q0)/(SUM(bots_q4) + SUM(bots_q3) + SUM(bots_q2) + SUM(bots_q1) + SUM(bots_q0)) AS perc_bots_q0
    , SUM(bots_q4)/(SUM(bots_q4) + SUM(bots_q3) + SUM(bots_q2) + SUM(bots_q1) + SUM(bots_q0)) AS perc_bots_q4
FROM dwh.vidible_performance_player AS PP
WHERE 
    PP.date < GETDATE() - 1 
    AND PP.date > GETDATE() - 2
GROUP BY      
      PP.domain;

--------------------------------------------------------------------

--MOAT
--1.28.16 Update: Added InViewRates for MRC and Group M
SELECT 
      MT.domain
      , CASE
        WHEN avg_player_width < 400 THEN 1
        ELSE 0
        END AS small_player_count
    , SUM(viewability_measurable_impressions) AS viewability_measurable_impressions
    , SUM(mrc_view) AS mrc_view
    , SUM(groupm_view) AS groupm_view
    , SUM(groupm_view)/SUM(viewability_measurable_impressions) AS group_m_InViewRate
    , SUM(mrc_view)/SUM(viewability_measurable_impressions) AS mrc_InViewRate
FROM dwh.moat_viewability_pivot AS MT
WHERE 
    datetime < GETDATE() - 1 AND datetime > GETDATE() - 29   /*pull last 28d, excluding partial data today*/
GROUP BY
      MT.domain
HAVING
    SUM(viewability_measurable_impressions) > 0
    AND SUM(mrc_view) > 0
    AND SUM(groupm_view) > 0;

--1.28.16 Update: Get player width and classify as small or "not small"
SELECT COUNT(*) FROM (
    
    SELECT 
          MT.domain
          , SUM (CASE
                WHEN avg_player_width < 400 THEN 1
                ELSE 0
            END) AS small_player_count
          , SUM(viewability_measurable_impressions) AS viewability_measurable_impressions
    FROM 
        dwh.moat_viewability_pivot AS MT
    WHERE 
        datetime < GETDATE() - 1 
        AND datetime > GETDATE() - 29   /*pull last 28d, excluding partial data today*/
    GROUP BY
          MT.domain
    HAVING
        SUM(viewability_measurable_impressions) > 100
) spc

-- Get player width AND total player count (for % spc purposes)
SELECT 
      MT.domain
      , SUM (CASE
            WHEN avg_player_width < 400 THEN 1
            ELSE 0
        END) AS small_player_count
      , COUNT(avg_player_width)
      , SUM (viewability_measurable_impressions) AS viewability_measurable_impressions
FROM 
    dwh.moat_viewability_pivot AS MT
WHERE 
    datetime < GETDATE() - 1 
    AND datetime > GETDATE() - 29   /*pull last 28d, excluding partial data today*/
GROUP BY
      MT.domain
HAVING
    SUM(viewability_measurable_impressions) > 5;


---------------------------------------------------------------------
--EXCEL matching

--nielsen
=IF(ISERROR(MATCH(Master!A2,nielsen_domains!$A$2:$A$3142,0)), "", INDEX(nielsen_domains!$B$2:$B$3142, MATCH(Master!A2,nielsen_domains!$A$2:$A$3142,0)))

--ias-distil
=IF(ISERROR(MATCH(Master!A2,id_domains!$A$2:$A$2001,0)), "", INDEX(id_domains!$B$2:$B$2001, MATCH(Master!A2,id_domains!$A$2:$A$2001,0)))

--moat
=IF(ISERROR(MATCH(Master!A2,nielsen_domains!$A$2:$A$1344,0)), "", INDEX(nielsen_domains!$B$2:$B$1344, MATCH(Master!A2,nielsen_domains!$A$2:$A$1344,0)))

---------------------------------------------------------------------
--Excel tier rating in Master tab

--FRAUD
--if the value is less than 3%, then plat, if not, but less than 
=IF(W2>Quality_Breakdown!C13,Quality_Breakdown!B10,IF(Master!W2<Quality_Breakdown!C13,Quality_Breakdown!C10,IF(Master!W2<Quality_Breakdown!D13,Quality_Breakdown!D10,IF(Master!W2<Quality_Breakdown!E13,Quality_Breakdown!E10,Quality_Breakdown!F10))))
-- ADD DOLLAR SIGNS
=IF(W2<



















