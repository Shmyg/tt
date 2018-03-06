create or replace view rtx_bch as
SELECT 'UDR_LT' TABLE_NAME
,AGGREG_INFO_AGGREG_PURPOSE
,AGGREG_INFO_AGG_TRANS_ID
,AGGREG_INFO_APPLIED_PACK_ID
,AGGREG_INFO_REC_COUNTER
,AGGREG_INFO_SUMMARY_ID
,ALT_RATED_AMOUNT
,ALT_RATED_CURRENCY
,ALT_TARIFF_CLICKS_VOLUME
,ALT_TMCODE
,AN_PACK_AN_PACKAGE_ID_LIST
,AN_PACK_ORIG_AN_PACK_ID_LIST
,BAL_AUDIT_DATA_ACCOUNT_ID
,BAL_AUDIT_DATA_ACCOUNT_TYPE
,BAL_AUDIT_DATA_ACCOUNT_TYPE_ID
,BAL_AUDIT_DAT_BALANCE_ACCUM
,BAL_AUDIT_DAT_BALANCE_PROD_ID
,BAL_AUDIT_DAT_BALANCE_TYPE
,BAL_AUDIT_DAT_BAL_AFTER_CHG
,BAL_AUDIT_DAT_BAL_BEFORE_CHG
,BAL_AUDIT_DAT_BUNDL_PROD_ID
,BAL_AUDIT_DAT_CONTRACT_ID
,BAL_AUDIT_DAT_OFFER_SEQNO
,BAL_AUDIT_DAT_OFFER_SNCODE
,BAL_AUDIT_DAT_PREP_CREDIT_IND
,BAL_AUDIT_DAT_PURCHASE_SEQ_NO
,BAL_AUDIT_DAT_SHACC_PACKID
,BAL_AUDIT_DAT_USER_PROFILE_ID
,BAL_AUDIT_DAT_VALID_FROM
,BAL_AUDIT_DAT_VALID_TO
,BOP_INFO_BOP_PACKAGE_ID
,BOP_INFO_BOP_PACKAGE_PKEY
,BOP_INFO_BOP_PACKAGE_VERSION
,BOP_INFO_DETAIL_BILLED_IND
,BOP_INFO_DETAIL_BOP_ALTERN_IND
,BOP_INFO_DETAIL_CONTRACTED_IND
,BOP_INFO_DETAIL_SEQUENCE_RP
,BOP_INFO_DETAIL_SEQUENCE_SP
,BOP_TARIFF_INFO_DAY_CATCODE
,BOP_TARIFF_INFO_EGCODE
,BOP_TARIFF_INFO_EGVERSION
,BOP_TARIFF_INFO_GVCODE
,BOP_TARIFF_INFO_RPCODE
,BOP_TARIFF_INFO_RPVERSION
,BOP_TARIFF_INFO_SNCODE
,BOP_TARIFF_INFO_SPCODE
,BOP_TARIFF_INFO_TIME_BAND_CODE
,BOP_TARIFF_INFO_TMCODE
,BOP_TARIFF_INFO_TMVERSION
,BOP_TARIFF_INFO_TM_USED_TYPE
,BOP_TARIFF_INFO_TWCODE
,BOP_TARIFF_INFO_USAGE_IND
,BOP_TARIFF_INFO_ZNCODE
,BOP_TARIFF_INFO_ZPCODE
,BPARTN_SUM_INFO_TIME_SLICE_LB
,BPARTN_SUM_INFO_TIME_SLICE_RB
,BUNDLE_INFO_BUNDLE_PURCHASE_ID
,BUNDLE_INFO_BUNDLE_PURCH_IND
,BUNDLE_INFO_CONTRACT_ID
,BUNDLE_INFO_PURCHASE_SEQ_NO
,BUNDLE_INFO_SEQUENCE_NUMBER
,BUNDLE_INFO_SNCODE
,BUNDLE_INFO_STATE
,BUNDLE_INFO_TERMINATION
,BUNDLE_INFO_USER_PROFILE_ID
,BUNDLE_INFO_VALID_FROM
,BUNDLE_INFO_VALID_TO
,BUNDLE_INFO_VERSION
,BUNDLE_USG_BUNDLE_COVERED_USG
,BUSINESS_INFO_BS_ID
,BUSINESS_INFO_BS_VERSION
,BUSINESS_INFO_CHARGE_ITEM_ID
,BUSINESS_INFO_CHARGE_PARTY_ID
,BUSINESS_INFO_C_P_FIELD_REF
,BUSINESS_INFO_O_P_FIELD_REF
,BUSINESS_INFO_PRE_BS_ID
,BUSINESS_INFO_PRE_BS_VERSION
,BUS_PARTNER_INFO_TAX_MODE
,CALL_DEST
,CALL_TYPE
,CAMEL_DEST_ADDR_USER_PROF_ID
,CAMEL_MSC_ADDRESS
,CAMEL_MSC_ADDR_USER_PROF_ID
,CAMEL_REFERENCE_NUMBER
,CAMEL_SRV_ADDR_USER_PROF_ID
,CHARGE_INFO_CASH_FLOW_DIRECT
,CHARGE_INFO_DISABLE_TAX
,CHARGING_CHARACTERISTICS
,CHRGAGGRINFO_REQUEST_ID
,CONSUMER_INFO_ADDRESS
,CONSUMER_INFO_CONTRACT_ID
,CONSUMER_INFO_NUMBERING_PLAN
,CONTENT_ADVISED_CHARGE_IND
,CONTENT_AUTHORISATION_CODE
,CONTENT_CONTENT_CHARGING_POINT
,CONTENT_CONTRACT_PKEY
,CONTENT_DESC_SUPPRESS
,CONTENT_PAID_IND
,CONTENT_PAYMENT_METHOD
,CONTENT_PROVIDER_ADDRESS
,CONTENT_PROVIDER_CARRIER_CODE
,CONTENT_PROVIDER_CLIR
,CONTENT_PROVIDER_IAC
,CONTENT_PROVIDER_MODIF_IND
,CONTENT_PROVIDER_NETWORK_CODE
,CONTENT_PROVID_DYNAMIC_ADDRESS
,CONTENT_PROVID_LOCAL_PREF_LEN
,CONTENT_PROVID_NUMBERING_PLAN
,CONTENT_PROVID_OTHER_LOCATION
,CONTENT_PROVID_TYPE_OF_NUMBER
,CONTENT_PROVID_USER_PROFILE_ID
,CONTENT_REFUND_IND
,CONTENT_SHORT_DESC
,CONTENT_TRANSACTION_ID
,CONTROL_DATA_RECORD_AGE
,CUG_INFO_CUG_ID
,CUG_INFO_CUG_INDEX
,CUSTOMER_INFO_CONTRACT_TYPE_ID
,CUSTOMER_INFO_CONTRAGGRPACK_ID
,CUSTOMER_INFO_RECO_IND
,CUST_INFO_ADDRESS
,CUST_INFO_ALTERNATE_TMCODE
,CUST_INFO_AN_PACKAGE_ID_LIST
,CUST_INFO_BILL_CYCLE
,CUST_INFO_BU_ADDRESS
,CUST_INFO_BU_NUMBERING_PLAN
,CUST_INFO_CHARGING_ENGINE
,CUST_INFO_CONTRACT_ID
,CUST_INFO_CUSTOMER_GROUP
,CUST_INFO_CUSTOMER_ID
,CUST_INFO_DELETE_AFTER_BILLING
,CUST_INFO_DN_ID
,CUST_INFO_MAIN_MSISDN
,CUST_INFO_NUMBERING_PLAN
,CUST_INFO_PARENT_CONTRACT_ID
,CUST_INFO_PORT_ID
,CUST_INFO_SERV_BID_ID
,CUST_INFO_SIM_NUMBER
,CUST_INFO_SIM_SERNUMBER
,CUST_INFO_SUBS_CODE
,CUST_INFO_SUBS_TAG
,CUST_INFO_USER_PROFILE_ID
,DATA_VOLUME
,DATA_VOLUME_UMCODE
,DESC_PROD_USAGE_LONG_DESC
,DESTINATION_FIELD_ID
,DOWNLINK_VOLUME_UMCODE
,DOWNLINK_VOLUME_VOLUME
,DURATION_UMCODE
,DURATION_VOLUME
,ENTRY_DATE_OFFSET
,ENTRY_DATE_TIMESTAMP
,EVENT_INFO_EVENT_TYPE
,EVENT_STATUS_INFO_MESSAGE_ID
,EVENT_UMCODE
,EVENT_VOLUME
,EXPORT_FILE
,EXT_BALANCE_AMNT_AMOUNT
,FOLLOW_UP_CALL_TYPE
,FOR_AMOUNT_AMOUNT
,FOR_AMOUNT_CURRENCY
,FOR_AMOUNT_GROSS_IND
,FOR_AMOUNT_TAX
,FOR_FREECHRG_AMOUNT
,FOR_FREECHRG_CURRENCY
,FOR_FREECHRG_GROSS_IND
,FOR_FREECHRG_TAX
,FREE_CHARGE_AMOUNT
,FREE_CHARGE_AMOUNT_NON_RPC
,FREE_CHARGE_CURRENCY
,FREE_CHARGE_CURR_NON_RPC
,FREE_CHARGE_GROSS_IND
,FREE_CHARGE_GROSS_IND_NRPC
,FREE_CHARGE_TAX
,FREE_CHARGE_TAX_NRPC
,FREE_CLICKS_UMCODE
,FREE_CLICKS_VOLUME
,FREE_RATED_VOLUME_UMCODE
,FREE_RATED_VOLUME_VOLUME
,FREE_ROUNDED_VOLUME_UMCODE
,FREE_ROUNDED_VOLUME_VOLUME
,FREE_UNITS_INFO_ACCOUNT_KEY
,FREE_UNITS_INFO_ACCOUNT_ORIGIN
,FREE_UNITS_INFO_ACC_HIST_ID
,FREE_UNITS_INFO_APPL_METHOD
,FREE_UNITS_INFO_CHG_RED_QUOTA
,FREE_UNITS_INFO_DISCOUNT_RATE
,FREE_UNITS_INFO_DISCOUNT_TYPE
,FREE_UNITS_INFO_FREEUNITOPTION
,FREE_UNITS_INFO_FUP_SEQ
,FREE_UNITS_INFO_FU_PACK_ID
,FREE_UNITS_INFO_PART_CREATOR
,FREE_UNITS_INFO_PREVIOUS_SEQNO
,FREE_UNITS_INFO_SEQNO
,FREE_UNITS_INFO_VERSION
,HOME_NETWORK_CODE
,HSCSD_INFO_AIUR
,HSCSD_INFO_CHANNELS_MAX
,HSCSD_INFO_CHANNELS_USED
,HSCSD_INFO_CODING_ACC
,HSCSD_INFO_CODING_USED
,HSCSD_INFO_FNUR
,HSCSD_INFO_INIT_PARTY
,IMP_PARTY1_ADDRESS
,IMP_PARTY1_ALTERNATE_TMCODE
,IMP_PARTY1_AN_PACKAGE_ID_LIST
,IMP_PARTY1_BILL_CYCLE
,IMP_PARTY1_NUMBERING_PLAN
,IMP_PARTY1_PARENT_CONTRACT_ID
,IMP_PARTY1_USER_PROFILE_ID
,IMP_PARTY2_ADDRESS
,IMP_PARTY2_ALTERNATE_TMCODE
,IMP_PARTY2_AN_PACKAGE_ID_LIST
,IMP_PARTY2_BILL_CYCLE
,IMP_PARTY2_NUMBERING_PLAN
,IMP_PARTY2_PARENT_CONTRACT_ID
,IMP_PARTY2_USER_PROFILE_ID
,IMP_PARTY3_ADDRESS
,IMP_PARTY3_ALTERNATE_TMCODE
,IMP_PARTY3_AN_PACKAGE_ID_LIST
,IMP_PARTY3_BILL_CYCLE
,IMP_PARTY3_NUMBERING_PLAN
,IMP_PARTY3_PARENT_CONTRACT_ID
,IMP_PARTY3_USER_PROFILE_ID
,IMP_PARTY4_ADDRESS
,IMP_PARTY4_ALTERNATE_TMCODE
,IMP_PARTY4_AN_PACKAGE_ID_LIST
,IMP_PARTY4_BILL_CYCLE
,IMP_PARTY4_NUMBERING_PLAN
,IMP_PARTY4_PARENT_CONTRACT_ID
,IMP_PARTY4_USER_PROFILE_ID
,IMP_PARTY5_ADDRESS
,IMP_PARTY5_ALTERNATE_TMCODE
,IMP_PARTY5_AN_PACKAGE_ID_LIST
,IMP_PARTY5_BILL_CYCLE
,IMP_PARTY5_NUMBERING_PLAN
,IMP_PARTY5_PARENT_CONTRACT_ID
,IMP_PARTY5_USER_PROFILE_ID
,INITIAL_START_TIME_TIMESTAMP
,INITIAL_START_TIME_TIME_OFFSET
,LCS_QOS_DELIV_HORIZONTAL_ACCUR
,LCS_QOS_DELIV_TRACKING_FREQUEN
,LCS_QOS_DELIV_TRACKING_PERIOD
,LCS_QOS_DELIV_VERTICAL_ACCUR
,LCS_QOS_INFO_AGE_OF_LOCATION
,LCS_QOS_INFO_POSITION_METHOD
,LCS_QOS_INFO_RESPONSE_TIME
,LCS_QOS_INFO_RESPONSE_TIME_CAT
,LCS_QOS_REQ_HORIZONTAL_ACCUR
,LCS_QOS_REQ_TRACKING_FREQUENCY
,LCS_QOS_REQ_TRACKING_PERIOD
,LCS_QOS_REQ_VERTICAL_ACCUR
,LDC_INFO_CARRIER_CODE
,LDC_INFO_CONTRACT_PKEY
,LDC_INFO_HOME_NET_IND
,LEC_INFO_CONTRACT_PKEY
,LEC_INFO_HOME_NET_IND
,LZLIST
,MC_INFO_CODE
,MC_INFO_IND
,MC_INFO_MICRO_CELL_INFORMATION
,MC_SCALEFACTOR
,MESSAGES_UMCODE
,MESSAGES_VOLUME
,MICRO_CELL_IMCSCALEFACTORTYPE
,MICRO_CELL_MC_CODE
,MICRO_CELL_MC_PKEY
,MICRO_CELL_MC_TYPE
,MICRO_CELL_SCALEFACTOR
,NETWORK_INIT_CONTEXT_IND
,NET_ELEMENT_ADDRESS
,NET_ELEMENT_HOME_BID_ID
,NET_ELEMENT_NETWORK_CODE
,NET_ELEMENT_NETW_ELEMENT_ID
,NET_ELEMENT_NUMBERING_PLAN
,NET_ELEMENT_TYPE_OF_NUMBER
,NET_ELEMENT_USER_PROFILE_ID
,NORMED_NET_ELEM_ADDRESS
,NORMED_NET_ELEM_INT_ACC_CODE
,NORMED_NET_ELEM_NUMBER_PLAN
,NORMED_RTD_NUM_ADDRESS
,NORMED_RTD_NUM_INT_ACC_CODE
,NORMED_RTD_NUM_NUMBER_PLAN
,NORMTRKGRP_IN_ADDRESS
,NORMTRKGRP_IN_NUMBERINGPLAN
,NORMTRKGRP_OUT_ADDRESS
,NORMTRKGRP_OUT_NUMBERINGPLAN
,NUMBER_OF_REJECTIONS
,OFFER_OFFER_SEQNO
,OFFER_OFFER_SNCODE
,ORIGIN_FIELD_ID
,ORIG_ENTRY_DATE_TIMESTAMP
,ORIG_ENTRY_DATE_TIMEZONE_ID
,ORIG_ENTRY_DATE_TIMEZONE_PKEY
,ORIG_ENTRY_DATE_TIME_OFFSET
,OR_FLAG
,O_P_NORMED_NUM_ADDRESS
,O_P_NORMED_NUM_INT_ACC_CODE
,O_P_NORMED_NUM_NUMBER_PLAN
,O_P_NUMBER_ADDRESS
,O_P_NUMBER_BACKUP_ADDRESS
,O_P_NUMBER_CARRIER_CODE
,O_P_NUMBER_CLIR
,O_P_NUMBER_NUMBERING_PLAN
,O_P_NUMBER_OTHER_LOCATION
,O_P_NUMBER_TYPE_OF_NUMBER
,O_P_NUMBER_USER_PROFILE_ID
,O_P_PUBID_ADDRESS
,O_P_PUBID_NUMBERING_PLAN
,O_P_PUBID_TYPE_OF_NUMBER
,PRICE_PLAN_INFO_CHRGPLANID
,PRICE_PLAN_INFO_EVALQUANTITY
,PRICE_PLAN_INFO_THRESHOLD
,PROGRAM_ID
,PROGRAM_NAME
,PROMO_INFO_B_NUMBER_CAT
,QOS_NEGOT_DELAY
,QOS_NEGOT_MEAN_THROUGHPUT
,QOS_NEGOT_PEAK_THROUGHPUT
,QOS_NEGOT_PRECEDENCE
,QOS_NEGOT_RELIABILITY
,QOS_PROFILE
,QOS_REQ_DELAY
,QOS_REQ_MEAN_THROUGHPUT
,QOS_REQ_PEAK_THROUGHPUT
,QOS_REQ_PRECEDENCE
,QOS_REQ_RELIABILITY
,RATED_CLICKS_UMCODE
,RATED_CLICKS_VOLUME
,RATED_FLAT_AMNT_GROSS_IND_NRPC
,RATED_FLAT_AMNT_ORIG_CURRENCY
,RATED_FLAT_AMNT_ORIG_DISC_AMNT
,RATED_FLAT_AMNT_ORIG_GROSS_IND
,RATED_FLAT_AMNT_TAX_NRPC
,RATED_FLAT_AMOUNT
,RATED_FLAT_AMOUNT_CURRENCY
,RATED_FLAT_AMOUNT_DISC_AMOUNT
,RATED_FLAT_AMOUNT_GROSS_IND
,RATED_FLAT_AMOUNT_NON_RPC
,RATED_FLAT_AMOUNT_NON_RPC_CURR
,RATED_FLAT_AMOUNT_ORIG_AMOUNT
,RATED_FLAT_AMOUNT_ORIG_TAX
,RATED_FLAT_AMOUNT_TAX
,RATED_VOLUME
,RATED_VOLUME_UMCODE
,RECIPIENT_NET_ADDRESS
,RECIPIENT_NET_NUMBERING_PLAN
,RECORD_ID_CALL_ID
,RECORD_ID_CDR_ID
,RECORD_ID_CDR_SUB_ID
,RECORD_ID_EVENT_REF
,RECORD_ID_ORIG_CDR_ID
,RECORD_ID_RAP_SEQUENCE_NUM
,RECORD_ID_RERATE_SEQNO
,RECORD_ID_SHAACC_UNIQUE_ID
,RECORD_ID_TAP_SEQUENCE_NUM
,RECORD_ID_UDR_FILE_ID
,RECORD_TYPE_RECORD_CATEGORY
,RECORD_TYPE_SUMMARY_IND
,REFER_CONTR_CONTRACT_ID
,REFER_CONTR_REFERENCE_TYPE
,REJECTED_BASE_PART
,REJECT_REASON_CODE
,REMARK
,RERATE_INFO_RERATE_REASON_ID
,RERATE_INFO_RERATE_RECORD_TYPE
,RERATE_INFO_RERATE_REQUEST_ID
,RERATE_INFO_URH_ID
,ROUNDED_VOLUME
,ROUNDED_VOLUME_UMCODE
,ROUTING_ADDRESS
,ROUTING_NETWORK_CODE
,ROUTING_NUMBERING_PLAN
,ROUTING_NUMBER_BACKUP_ADDRESS
,ROUTING_TYPE_OF_NUMBER
,ROUTING_USER_PROFILE_ID
,SCU_ID_ADDRESS
,SCU_ID_USER_PROFILE_ID
,SCU_INFO_PRIORITY_CODE
,SERVICE_ACTION_CODE
,SERVICE_GUARANTEED_BIT_RATE
,SERVICE_HSCSD_IND
,SERVICE_IMS_SIGNALLING_CONTEXT
,SERVICE_LOGIC_CODE
,SERVICE_MAX_BIT_RATE
,SERVICE_SERVICE_TYPE
,SERVICE_USED_SERVICE
,SERVICE_USER_PROTOCOL_IND
,SERVICE_VAS_CODE
,SERV_PDP_ADDR_APN_SPLIT_IND
,SGSN_ADDRESSES
,SPEC_NUM_INFO_APPLY_FREE_UNITS
,START_TIME_CHARGE_OFFSET
,START_TIME_CHARGE_TIMESTAMP
,START_TIME_OFFSET
,START_TIME_TIMESTAMP
,SUM_REFERENCE_SINGLE_ID
,S_PDP_ADDRESS
,S_PDP_CARRIER_CODE
,S_PDP_CLIR
,S_PDP_INTERN_ACCESS_CODE
,S_PDP_MODIFICATION_IND
,S_PDP_NETWORK_CODE
,S_PDP_NUMBERING_PLAN
,S_PDP_TYPE_OF_NUMBER
,S_PDP_USER_PROFILE_ID
,S_P_EQUIPMENT_CLASS_MARK
,S_P_EQUIPMENT_NUMBER
,S_P_HOME_ID_DESCRIPTION
,S_P_HOME_ID_HOME_BID_ID
,S_P_HOME_ID_NAME
,S_P_HOME_ID_NETWORK
,S_P_HOME_LOC_ADDRESS
,S_P_HOME_LOC_NUMBERING_PLAN
,S_P_LOCATION_ADDRESS
,S_P_LOCATION_NUMBERING_PLAN
,S_P_LOC_SERVING_BID_ID
,S_P_LOC_SERVING_LOCATION
,S_P_NUMBER_ADDRESS
,S_P_NUMBER_HOME_BID_ID
,S_P_NUMBER_NETWORK_CODE
,S_P_NUMBER_NUMBERING_PLAN
,S_P_NUMBER_USER_PROFILE_ID
,S_P_PORT_ADDRESS
,S_P_PORT_NUMBERING_PLAN
,S_P_PORT_USER_PROFILE_ID
,TARIFF_DETAIL_CHGBL_QUANTITY
,TARIFF_DETAIL_EXT_CHRG_UDMCODE
,TARIFF_DETAIL_INTERCONNECT_IND
,TARIFF_DETAIL_PRICGALTERNPKEY
,TARIFF_DETAIL_PRICINGALTERNID
,TARIFF_DETAIL_RATE_TYPE_ID
,TARIFF_DETAIL_RTX_CHARGE_TYPE
,TARIFF_DETAIL_TTCODE
,TARIFF_INFO_CATALOGUE_ID
,TARIFF_INFO_CATALOGUE_VERS
,TARIFF_INFO_CTLG_ELM_ID
,TARIFF_INFO_EGCODE
,TARIFF_INFO_EGVERSION
,TARIFF_INFO_GVCODE
,TARIFF_INFO_PRICELIST_ID
,TARIFF_INFO_PRICELIST_PKEY
,TARIFF_INFO_PRICELIST_VERS
,TARIFF_INFO_PRICE_DEF_VERS
,TARIFF_INFO_RPCODE
,TARIFF_INFO_RPVERSION
,TARIFF_INFO_SNCODE
,TARIFF_INFO_SPCODE
,TARIFF_INFO_TIME_BAND_CODE
,TARIFF_INFO_TMCODE
,TARIFF_INFO_TMVERSION
,TARIFF_INFO_TM_USED_TYPE
,TARIFF_INFO_TWCODE
,TARIFF_INFO_USAGE_IND
,TARIFF_INFO_ZNCODE
,TARIFF_INFO_ZPCODE
,TARIFF_INFO_ZPCODE_DAY_CATCODE
,TAX_INFO_SERV_CAT
,TAX_INFO_SERV_CODE
,TAX_INFO_SERV_TYPE
,TECHN_INFO_FIXED_MOBILE_IND
,TECHN_INFO_HOME_TERMINATED_IND
,TECHN_INFO_PREPAY_IND
,TECHN_INFO_PRE_RATED_IND
,TECHN_INFO_REV_CHARGING_IND
,TECHN_INFO_SCCODE
,TECHN_INFO_TERMINATION_IND
,TRUNK_GROUP_IN_ADDRESS
,TRUNK_GROUP_IN_NUMBERINGPLAN
,TRUNK_GROUP_IN_TYPEOFNUMBER
,TRUNK_GROUP_OUT_ADDRESS
,TRUNK_GROUP_OUT_NUMBERINGPLAN
,TRUNK_GROUP_OUT_TYPEOFNUMBER
,T_P_NUMBER_ADDRESS
,T_P_NUMBER_NUMBERING_PLAN
,T_P_NUMBER_TYPE_OF_NUMBER
,T_P_NUMBER_USER_PROFILE_ID
,UDR_BASEPART_ID
,UDR_CHARGEPART_ID
,UDS_BASE_PART_ID
,UDS_CHARGE_PART_ID
,UDS_FREE_UNIT_PART_ID
,UDS_PROMOTION_PART_ID
,UDS_RECORD_ID
,UDS_STREAM_ID
,UMTS_QOS_NEGOT_ALLC_RETN_PRIOR
,UMTS_QOS_NEGOT_DELAY
,UMTS_QOS_NEGOT_DELIVERY_ORDER
,UMTS_QOS_NEGOT_ERRONEOUS_SDUS
,UMTS_QOS_NEGOT_HANDL_PRIORITY
,UMTS_QOS_NEGOT_MAX_SIZE_SDU
,UMTS_QOS_NEGOT_RATE_DOWNLINK
,UMTS_QOS_NEGOT_RATE_UPLINK
,UMTS_QOS_NEGOT_RESIDUAL_BER
,UMTS_QOS_NEGOT_SDU_ERR_RATIO
,UMTS_QOS_NEGOT_TRAFFIC_CLASS
,UMTS_QOS_REQ_ALLC_RETN_PRIOR
,UMTS_QOS_REQ_DELAY
,UMTS_QOS_REQ_DELIVERY_ORDER
,UMTS_QOS_REQ_ERRONEOUS_SDUS
,UMTS_QOS_REQ_HANDL_PRIORITY
,UMTS_QOS_REQ_MAX_SIZE_SDU
,UMTS_QOS_REQ_RATE_DOWNLINK
,UMTS_QOS_REQ_RATE_UPLINK
,UMTS_QOS_REQ_RESIDUAL_BER
,UMTS_QOS_REQ_SDU_ERROR_RATIO
,UMTS_QOS_REQ_TRAFFIC_CLASS
,UNBILLEDAMTPAYMRESP_CUSTOMERID
,UNBILLED_AMOUNT_AMOUNT
,UNBILLED_AMOUNT_BILLING_ACC
,UNBILLED_AMOUNT_COMPL_COND_ID
,UNBILLED_AMOUNT_CURRENCY
,UNBILLED_AMOUNT_GROSS_IND
,UNBILLED_AMOUNT_TAX
,UPLINK_VOLUME_UMCODE
,UPLINK_VOLUME_VOLUME
,VPN_INFO_VPN_CALL_TYPE
,VPN_NUMBER_ADDRESS
,VPN_NUMBER_CARRIER_CODE
,VPN_NUMBER_CLIR
,VPN_NUMBER_DYNAMIC_ADDRESS
,VPN_NUMBER_INT_ACCESS_CODE
,VPN_NUMBER_LOCAL_PREFIX_LEN
,VPN_NUMBER_MODIFICATION_IND
,VPN_NUMBER_NETWORK_CODE
,VPN_NUMBER_NUMBERING_PLAN
,VPN_NUMBER_TYPE_OF_NUMBER
,VPN_NUMBER_USER_PROFILE_ID
,XFILE_BASE_CHARGE_AMOUNT
,XFILE_BASE_CHARGE_CURRENCY
,XFILE_BASE_CHARGE_GROSS_IND
,XFILE_BASE_CHARGE_TAX
,XFILE_CALL_TYPE
,XFILE_CHARGE_AMOUNT
,XFILE_CHARGE_CURRENCY
,XFILE_CHARGE_GROSS_IND
,XFILE_CHARGE_TAX
,XFILE_DAY_CATEGORY_CODE
,XFILE_DISCOUNT_AMOUNT
,XFILE_DISCOUNT_CURRENCY
,XFILE_IC_CHARGE_AMOUNT
,XFILE_IC_CHARGE_CURRENCY
,XFILE_IC_CHARGE_GROSS_IND
,XFILE_IC_CHARGE_TAX
,XFILE_IND
,XFILE_TIME_BAND_CODE
,ZERO_RATED_VOLUME_UMCODE
,ZERO_RATED_VOLUME_VOLUME
,ZERO_ROUNDED_VOLUME_UMCODE
,ZERO_ROUNDED_VOLUME_VOLUME
FROM UDR_LT
WITH READ ONLY
/