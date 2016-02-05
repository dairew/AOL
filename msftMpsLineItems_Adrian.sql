SELECT mediaplanlines.mpli_seq_no AS free_wheel_placement_id, 
       mediaplanlines.ss_mpli_id, 
       mediaplans.adt_mst_campg_id AS adt_master_campaign_id, 
       mediaplans.media_plan_id, 
       URI_PERCENT_ENCODE(mediaplans.media_plan_name) AS media_plan_name, 
       URI_PERCENT_ENCODE(mediaplanlines.mpli_name) AS media_plan_line_name, 
       mediaplans.version, 
       mediaplans.industry_id, 
       mediaplans.mps_adv_id, 
       mediaplans.agency_id, 
       mediaplans.flight_start_ts AS plan_start_date, 
       mediaplans.flight_end_ts AS plan_end_date, 
       mediaplans.currency_code_id, 
       'gmt' AS time_zone, 
       mediaplans.legal_status_id, 
       CASE WHEN mediaplans.reporting_source_id = 4 THEN 'N' ELSE 'Y' END AS third_party_stats_flg, 
       mediaplanlines.line_type, 
       mediaplans.governing_country_id, 
       flight.flt_start_ts AS line_start_date, 
       flight.flt_end_ts AS line_end_date, 
       mediaplanlines.rate_type_id, 
       flight.sold_rate AS rate, 
       product.delivery_type_id, 
       'N' AS targeted_flg, 
       CASE 
          WHEN deliverytype.delivery_type_id IN (1, 2, 3) THEN 'Y' 
          ELSE 'N' 
       END AS reserved_flg, 
       CASE 
          WHEN deliverytype.delivery_type_id IN (2, 3) THEN 'Y' 
          ELSE 'N' 
       END AS sov_flg, 
       CASE WHEN valuetype.value_type_id = 5 THEN 'Y' ELSE 'N' END AS house_flg, 
       CASE WHEN valuetype.value_type_id IN (1, 2, 6) THEN 'Y' ELSE 'N' END AS paid_flg, 
       NULL AS normalizedrule 
FROM eudm.mpseu_product_dim_v product 
INNER JOIN eudm.mpseu_delivery_type_dim_v deliverytype 
ON deliverytype.delivery_type_id = product.delivery_type_id 
INNER JOIN eudm.mpseu_media_plan_lines_dim_v mediaplanlines 
ON (mediaplanlines.product_id = product.product_id) 
INNER JOIN eudm.mpseu_media_plans_dim_v mediaplans 
ON (mediaplans.media_plan_id = mediaplanlines.media_plan_id) 
AND (mediaplans.version = mediaplanlines.version) 
INNER JOIN (SELECT media_plan_id, MAX (version) AS version 
            FROM eudm.mpseu_media_plans_dim_v 
            WHERE legal_status_id = 2 
            GROUP BY media_plan_id) max_plan 
ON mediaplanlines.media_plan_id = max_plan.media_plan_id 
AND mediaplanlines.version = max_plan.version 
INNER JOIN eudm.mpseu_flight_dim_v flight 
ON (mediaplanlines.media_plan_line_id = flight.line_id) 
INNER JOIN eudm.mpseu_value_type_dim_v valuetype 
ON valuetype.value_type_id = mediaplanlines.value_type_id 
WHERE mediaplanlines.product_id IN (507286, 507287, 507278, 507706) 
AND (mediaplanlines.is_deleted_flg = 'N') 
AND mediaplanlines.mpli_seq_no in (10141551,10141550)