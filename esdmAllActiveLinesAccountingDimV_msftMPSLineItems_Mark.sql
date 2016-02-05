SELECT  active_lines.mpli_seq_no  
    , active_lines.fulfillment_center_name  
    , active_lines.mpli_name  
    , active_lines.product_name  
    , active_lines.mpli_created_ts
FROM usdm.mps_all_active_lines_accounting_dim_v active_lines 
WHERE (UPPER(active_lines.fulfillment_center_name) LIKE UPPER('freewheel%'))
    AND (active_lines.product_name <> active_lines.mpli_name)   
ORDER BY active_lines.mpli_created_ts   DESC