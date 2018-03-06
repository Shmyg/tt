SELECT RTP.SHDES AS BSCS_RP_CODE, RTP.DES AS BSCS_RP_DES, 
       SP.SPCODE, SP.SHDES AS "Offer Code", SP.DES AS "Offer Label", 
       SN.SNCODE, SN.SHDES AS "Service Code", SN.DES AS "Service Label",
       TMB.SUBSCRIPT AS "One Time Charge", TMB.ACCESSFEE AS "Recurring Charge",
       DECODE(NVL(TMB.PROIND,'NA'),'Y','Yes','N','No','N/A') AS "RC Proration",
       DECODE(NVL(TMB.ADVIND,'NA'),'A','Advance','P','Past','N/A') AS "RC Advance",
       DECODE(NVL(TMB.SUSIND,'NA'),'Y','Yes','N','No','N/A') AS "RC Bill Suspended",
       SUB.REV_ACCOUNT AS "OTC Rev. GL", SUB.REV_NAME AS "OTC Rev. GL Name", 
       SUB.DISC_ACCOUNT AS "OTC Disc GL", SUB.DIS_NAME AS "OTC Disc GL Name",
       ACC.REV_ACCOUNT AS "RC Rev. GL", ACC.REV_NAME AS "RC Rev. GL Name",
       ACC.DISC_ACCOUNT AS "RC Disc GL", ACC.DIS_NAME AS "RC Disc GL Name",
       DECODE(NVL(NET.SNCODE,0),0,'No','Yes') AS "Required Resource",
       NPSHDES AS NPCODE_PUB,
       DRSHDES AS RSCODE_PUB,
       DECODE(NVL(PRM.PARAMETER_ID,0),0,'No','Yes') AS "Service Parameter",
       DECODE(NVL(PRM.PARAMETER_ID,0),0,'','N/A') AS "Parameter Value",
       TMB.SUBSERV_CATCODE AS "Tax % on OTC",
       TMB.ACCSERV_CATCODE AS "Tax % on RC"
       FROM   RATEPLAN RTP,
       MPUSPTAB SP,
       MPUSNTAB SN,
       MPULKTMB TMB,
       (SELECT XV.SNCODE, NP.SHDES AS NPSHDES, DR.SHDES AS DRSHDES
          FROM MPULKNXV XV, MPDNPTAB NP, MPDDRTAB DR
         WHERE XV.DIRNUM_NPCODE = NP.NPCODE
           AND XV.RSCODE = DR.RSCODE(+))  NET,
       (SELECT XV.SNCODE, SP.PARAMETER_ID FROM MPULKNXV XV, SERVICE_PARAMETER SP WHERE XV.SSCODE = SP.SVCODE AND SP.SCCODE = 6 ) PRM,
       (SELECT GP.GL_ACC_PACK_ID, GP.REV_ACCOUNT, REV.GLADESC AS REV_NAME, GP.DISC_ACCOUNT, DIS.GLADESC AS DIS_NAME, GP.MINCOMM_ACCOUNT, MCO.GLADESC AS MIN_NAME
          FROM GL_ACCOUNT_PACKAGE_VERSION GP, GLACCOUNT_ALL REV, GLACCOUNT_ALL DIS, GLACCOUNT_ALL MCO
         WHERE GP.REV_ACCOUNT = REV.GLACODE AND GP.DISC_ACCOUNT = DIS.GLACODE AND GP.MINCOMM_ACCOUNT = MCO.GLACODE) ACC,
       (SELECT GP.GL_ACC_PACK_ID, GP.REV_ACCOUNT, REV.GLADESC AS REV_NAME, GP.DISC_ACCOUNT, DIS.GLADESC AS DIS_NAME, GP.MINCOMM_ACCOUNT, MCO.GLADESC AS MIN_NAME
          FROM GL_ACCOUNT_PACKAGE_VERSION GP, GLACCOUNT_ALL REV, GLACCOUNT_ALL DIS, GLACCOUNT_ALL MCO
         WHERE GP.REV_ACCOUNT = REV.GLACODE AND GP.DISC_ACCOUNT = DIS.GLACODE AND GP.MINCOMM_ACCOUNT = MCO.GLACODE) SUB
WHERE  TMB.SNCODE = SN.SNCODE
AND    RTP.SHDES NOT IN ('OCC','PDFG')
AND    TMB.TMCODE = RTP.TMCODE
AND    TMB.SPCODE = SP.SPCODE
AND    TMB.SNCODE = NET.SNCODE(+)
AND    TMB.SNCODE = PRM.SNCODE(+)
AND    TMB.SUB_GL_ACC_PACK_ID = SUB.GL_ACC_PACK_ID(+)
AND    TMB.ACC_GL_ACC_PACK_ID = ACC.GL_ACC_PACK_ID(+)
and tmb.tmcode = 3 
ORDER BY TMB.TMCODE, TMB.SPCODE, TMB.SNCODE;
