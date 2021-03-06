SELECT TBLMEDIAPLANLINES.EXTERNALLINEITEMID AS adt_campaign_id,
     TBLMEDIAPLANLINES.SEQUENCENUMBER,
     TBLMEDIAPLANS.ADTECHID AS ADT_Master_Campaign_id,
     TBLMEDIAPLANS.MEDIAPLANID,
     TBLMEDIAPLANS.NAME AS MEDIA_PLAN_NAME,
     TBLMEDIAPLANLINES.NAME AS MEDIA_PLAN_LINE_NAME,
     TBLMEDIAPLANS.VERSION,
     TBLMEDIAPLANS.INDUSTRYID,                                -- new in V1_1
     TBLMEDIAPLANS.ADVERTISERID,
     TBLMEDIAPLANS.AGENCYID,
     TBLMEDIAPLANS.FLIGHTSTARTDATE AS plan_start_date,
     TBLMEDIAPLANS.FLIGHTENDDATE AS plan_end_date,
     TBLMEDIAPLANS.CURRENCYCODEID,
     -- 'GMT' AS time_zone, -- new in V1_1  MPS now has the column, see below so this line is commented out
     CASE                                                       -- new in V4
        WHEN tz.JAVATIMEZONEID = 'N/A' THEN 'Europe/Madrid'
        ELSE tz.JAVATIMEZONEID
     END
        AS time_zone,
     TBLMEDIAPLANS.LEGALSTATUSID,
     CASE WHEN TBLMEDIAPLANS.REPORTINGSOURCEID = 4 THEN 'N' ELSE 'Y' END
        AS third_party_stats_flg,
     TBLMEDIAPLANLINES.LINETYPE,
     TBLMEDIAPLANS.GOVERNINGCOUNTRYID,
     TBLFLIGHT.STARTDATE AS line_start_date,
     TBLFLIGHT.ENDDATE AS line_end_date,
     TBLMEDIAPLANLINES.RATETYPEID,
     SOLDRATE AS RATE,                       -- New in V1_2, Updated in V1_3
     TBLPRODUCT.DELIVERYTYPEID,
     'N' AS targeted_flg,                -- Not targteed in MPS, ddone in FW
     CASE WHEN TBLDELIVERYTYPE.ID IN (1, 2, 3) THEN 'Y' ELSE 'N' END -- New in V1_3
        AS Reserved_flg,
     CASE WHEN TBLDELIVERYTYPE.ID IN (2, 3) THEN 'Y' ELSE 'N' END -- New in V1_3
        AS SOV_flg,
     CASE WHEN TBLVALUETYPE.ID = 5 THEN 'Y' ELSE 'N' END AS House_flg,
     CASE WHEN TBLVALUETYPE.ID IN (1, 2, 6) THEN 'Y' ELSE 'N' END -- New in V1_3
        AS Paid_flg,
     NULL AS NORMALIZEDRULE,
     CASE WHEN TBLPRODUCT.MEDIATYPEID in (3, 10, 11, 14) OR TBLMEDIAPLANLINES.RATETYPEID = 12 THEN 'Y' ELSE 'N' END 
        AS is_view
