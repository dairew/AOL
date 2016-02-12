-- USDM Mark Query - MASTER

SELECT mediaplanlines.ss_mpli_id AS free_wheel_placement_id, --choose name for this
       mediaplanlines.mpli_seq_no AS SEQUENCENUMBER,
       mediaplans.adt_mst_campg_id AS ADT_MASTER_CAMPAIGN_ID,
       mediaplans.media_plan_id AS MEDIAPLANID,
       mediaplanlines.product_id,
       mediaplans.media_plan_name AS MEDIA_PLAN_NAME,
       mediaplanlines.mpli_name AS MEDIA_PLAN_LINE_NAME,
       mediaplans.version AS VERSION,
       mediaplans.industry_id AS INDUSTRYID,   
       mediaplans.mps_adv_id AS ADVERTISERID,
       mediaplans.agency_id AS AGENCYID,
       mediaplans.flight_start_ts AS PLAN_START_DATE,
       mediaplans.flight_end_ts AS PLAN_END_DATE,
       mediaplans.currency_code_id AS CURRENCYCODEID,
       CASE                            
          WHEN tz.java_timezone = 'N/A' THEN 'Europe/Madrid'
          ELSE tz.java_timezone
       END
        AS TIME_ZONE,
       mediaplans.legal_status_id AS LEGALSTATUSID,
       CASE WHEN mediaplans.reporting_source_id = 4 THEN 'N' ELSE 'Y' END
          AS THIRD_PARTY_STATUS_ID,
       mediaplanlines.line_type AS LINETYPE,
       mediaplans.governing_country_id AS GOVERNINGCOUNTRYID,
       flight.flt_start_ts AS LINE_START_DATE,
       flight.flt_end_ts AS LINE_END_DATE,
       mediaplanlines.rate_type_id RATETYPEID,
       flight.sold_rate AS RATE,       
       product.delivery_type_id DELIVERYTYPEID,
       'N' AS TARGETED_FLG, 
       CASE
          WHEN deliverytype.delivery_type_id IN (1, 2, 3) THEN 'Y'
          ELSE 'N'
       END                        
          AS RESERVED_FLG,
       CASE
          WHEN deliverytype.delivery_type_id IN (2, 3) THEN 'Y'
          ELSE 'N'
       END                         
          AS SOV_FLG,
       CASE WHEN valuetype.value_type_id = 5 THEN 'Y' ELSE 'N' END
          AS HOUSE_FLG,
       CASE WHEN valuetype.value_type_id IN (1, 2, 6) THEN 'Y' ELSE 'N' END
          AS PAID_FLG,
       NULL AS NORMALIZEDRULE,   
       CASE
          WHEN  PRODUCT.MEDIA_TYPE_ID IN (3, 10, 11, 14)
                OR MEDIAPLANLINES.RATE_TYPE_ID = 12
          THEN
             'Y'
          ELSE
             'N'
       END
          AS IS_VIEW_FLG
  FROM usdm.mps_product_dim_v product
       INNER JOIN usdm.mps_delivery_type_dim_v deliverytype  
          ON deliverytype.delivery_type_id = product.delivery_type_id
       INNER JOIN usdm.mps_media_plan_lines_dim_v mediaplanlines
          ON (mediaplanlines.product_id = product.product_id)
       INNER JOIN usdm.mps_media_plans_dim_v mediaplans
          ON     (mediaplans.media_plan_id = mediaplanlines.media_plan_id)
             AND (mediaplans.version = mediaplanlines.version)
       INNER JOIN (SELECT media_plan_id, MAX (version) AS version 
                     FROM usdm.mps_media_plans_dim_v 
                    WHERE legal_status_id = 2            
                   GROUP BY media_plan_id) max_plan
          ON     mediaplanlines.media_plan_id = max_plan.media_plan_id
             AND mediaplanlines.version = max_plan.version
       INNER JOIN usdm.mps_flight_dim_v flight
          ON (mediaplanlines.media_plan_line_id = flight.line_id)
       INNER JOIN usdm.mps_value_type_dim_v valuetype        
          ON valuetype.value_type_id = mediaplanlines.value_type_id
       INNER JOIN usdm.mps_timezone_dim_v tz
          ON flight.timezone_id = tz.timezone_id
WHERE mpli_name LIKE '%VIDEO-MSFT%'
  AND mediaplanlines.is_deleted_flg = 'N'  
ORDER BY line_start_date DESC;