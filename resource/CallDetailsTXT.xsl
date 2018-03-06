<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2010 LHS Telekom GmbH & Co. KG

  The copyright in this work is vested in LHS. The information contained in this work
  (either in whole or in part) is confidential and must not be modified, reproduced,
  disclosed or disseminated to others or used for purposes other than that for which
  it is supplied, without the prior written permission of LHS.  If this work or any
  part hereof is furnished to a third party by virtue of a contract with that party,
  use of this work by such party shall be governed by the express contractual terms
  between LHS, which is party to that contract and the said party.

  The information in this document is subject to change without notice and should not
  be construed as a commitment by LHS. LHS assumes no responsibility for any errors
  that may appear in this document. With the appearance of a new version of this
  document all older versions become invalid.

  All rights reserved.

  File:    CallDetailsTXT.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> TXT stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms call details.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/CallDetailsTXT.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="xsl set">

  <xsl:key name="co-id" match="Contract" use="@Id"/>

  <xsl:template name="remove-duplicates">

    <xsl:param name="list-of-services"/>
    <xsl:param name="last-service" select="''"/>
    <xsl:variable name="next-service">
      <xsl:value-of select="substring-before($list-of-services, ' ')"/>
    </xsl:variable>
    <xsl:variable name="remaining-services">
      <xsl:value-of select="substring-after($list-of-services, ' ')"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="not(string-length(normalize-space($list-of-services)))">
        <!-- empty list, do nothing -->
      </xsl:when>
      <xsl:when test="not($last-service=$next-service)">
        <xsl:value-of select="$next-service"/>
        <xsl:text> </xsl:text>
        <xsl:call-template name="remove-duplicates">
          <xsl:with-param name="list-of-services" select="$remaining-services"/>
          <xsl:with-param name="last-service" select="$next-service"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$last-service=$next-service">
        <xsl:call-template name="remove-duplicates">
          <xsl:with-param name="list-of-services" select="$remaining-services"/>
          <xsl:with-param name="last-service" select="$next-service"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>

  </xsl:template>

  <!--  charge details  -->
  <xsl:template name="print-charge-details">

    <xsl:param name="co-id"/>
    <xsl:param name="bopind"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>
    <xsl:param name="charge-details"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>
    <xsl:param name="charge-type"/>

    <!-- get the services for which there are one-time and recurring charges -->
    <xsl:variable name="list-of-services">
      <xsl:for-each select="$charge-details/ChDet/XCD[@SrvChType=$charge-type]/@SN">
        <xsl:sort select="."/>
          <xsl:value-of select="."/>
          <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="list-of-unique-services">
      <xsl:call-template name="remove-duplicates">
        <xsl:with-param name="list-of-services" select="$list-of-services"/>
        <xsl:with-param name="last-service" select="''"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="normalize-space($list-of-unique-services)!=''">

      <!-- recurring charges -->
      <xsl:if test="$charge-type='A'">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','482')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:value-of select="$line-feed"/>
      </xsl:if>
      <!-- one-time charges -->
      <xsl:if test="$charge-type='S'">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','483')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:value-of select="$line-feed"/>
      </xsl:if>

      <xsl:call-template name="group-charges-by-services">
        <xsl:with-param name="co-id" select="$co-id"/>
        <xsl:with-param name="bopind" select="$bopind"/>
        <xsl:with-param name="bopseqno" select="$bopseqno"/>
        <xsl:with-param name="boptype" select="$boptype"/>
        <xsl:with-param name="charge-details" select="$charge-details"/>
        <xsl:with-param name="list-of-unique-services" select="$list-of-unique-services"/>
        <xsl:with-param name="period-start" select="$period-start"/>
        <xsl:with-param name="period-end" select="$period-end"/>
        <xsl:with-param name="charge-type" select="$charge-type"/>
      </xsl:call-template>
    </xsl:if>

  </xsl:template>

  <!-- charge details group by services -->
  <xsl:template name="group-charges-by-services">

    <xsl:param name="co-id" select="''"/>
    <xsl:param name="bopind"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>
    <xsl:param name="charge-details"/>
    <xsl:param name="list-of-unique-services"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>
    <xsl:param name="charge-type"/>

    <xsl:if test="normalize-space($list-of-unique-services)!=''">

      <xsl:variable name="next-service">
        <xsl:value-of select="substring-before($list-of-unique-services, ' ')"/>
      </xsl:variable>

      <xsl:variable name="remaining-services">
        <xsl:value-of select="substring-after($list-of-unique-services, ' ')"/>
      </xsl:variable>
      <!-- service -->
      <xsl:for-each select="$xcd">
        <xsl:value-of select="key('xcd-index','SN')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
      <xsl:text>: </xsl:text>
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="$next-service"/>
        <xsl:with-param name="Type"  select="'SN'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
      
      <xsl:value-of select="$line-feed"/>

      <xsl:for-each select="$charge-details/ChDet/XCD[@SN=$next-service and @SrvChType=$charge-type]">
        <xsl:call-template name="ChDet">
          <xsl:with-param name="node" select="parent::ChDet"/>
          <xsl:with-param name="charge-type" select="$charge-type"/>
        </xsl:call-template>
      </xsl:for-each>

      <xsl:if test="normalize-space($remaining-services)!=''">
        <xsl:call-template name="group-charges-by-services">
          <xsl:with-param name="co-id" select="$co-id"/>
          <xsl:with-param name="bopind" select="$bopind"/>
          <xsl:with-param name="bopseqno" select="$bopseqno"/>
          <xsl:with-param name="boptype" select="$boptype"/>
          <xsl:with-param name="charge-details" select="$charge-details"/>
          <xsl:with-param name="list-of-unique-services" select="$remaining-services"/>
          <xsl:with-param name="period-start" select="$period-start"/>
          <xsl:with-param name="period-end" select="$period-end"/>
          <xsl:with-param name="charge-type" select="$charge-type"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>

  </xsl:template>

  <!-- charge details -->
  <xsl:template name="ChDet">

    <xsl:param name="node"/>
    <xsl:param name="charge-type"/>
    <!-- charge details -->
    <xsl:call-template name="charge-details">
      <xsl:with-param name="node" select="$node/XCD"/>
      <xsl:with-param name="charge-type" select="$charge-type"/>
    </xsl:call-template>
    <!-- cch free units -->
    <xsl:if test="$node/FUP">
    <!-- free units -->
    <xsl:for-each select="$txt">
      <xsl:value-of select="key('txt-index','280')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>      
    <xsl:value-of select="$line-feed"/>
      <xsl:for-each select="$node/FUP">
        <xsl:apply-templates select="." mode="charge-details"/>
      </xsl:for-each>
    </xsl:if>

  </xsl:template>

  <!-- several flexible charge attributes (see table charge_detail_info) -->
  <xsl:template name="charge-details">

    <xsl:param name="node"/>
    <xsl:param name="charge-type"/>

    <!-- timestamp -->
    <xsl:for-each select="$xcd">
      <xsl:value-of select="key('xcd-index','CTs')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text>: </xsl:text>
    <xsl:call-template name="date-time-format">
      <xsl:with-param name="date" select="$node/@CTs"/>
    </xsl:call-template>
    <xsl:value-of select="$line-feed"/>
    <!-- prepaid indicator -->
    <xsl:for-each select="$xcd">
      <xsl:value-of select="key('xcd-index','PrInd')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>        
    <xsl:text>: </xsl:text>
    <xsl:call-template name="DataDomainLgnMap">
      <xsl:with-param name="Index"     select="$node/@PrInd"/>
      <xsl:with-param name="Type"      select="'DD'"/>
      <xsl:with-param name="Desc"      select="'1'"/>
      <xsl:with-param name="ClassId"   select="'YES/NO_BOOLEAN_INDICATOR'"/>
    </xsl:call-template>
    <xsl:value-of select="$line-feed"/>    
    <xsl:choose>
      <xsl:when test="$node/@BOPTM or $node/@BOPSP">
        <!-- tariff model / version -->
        <xsl:for-each select="$xcd">
          <xsl:value-of select="key('xcd-index','TM')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:text>: </xsl:text>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="$node/@BOPTM"/>
          <xsl:with-param name="Type"  select="'TM'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$node/@TMV"/>
        <xsl:value-of select="$line-feed"/>
        <!-- service package -->
        <xsl:for-each select="$xcd">
          <xsl:value-of select="key('xcd-index','SP')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:text>: </xsl:text>        
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="$node/@BOPSP"/>
          <xsl:with-param name="Type"  select="'SP'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
        <xsl:value-of select="$line-feed"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- tariff model / version -->
        <xsl:for-each select="$xcd">
          <xsl:value-of select="key('xcd-index','TM')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:text>: </xsl:text>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="$node/@TM"/>
          <xsl:with-param name="Type"  select="'TM'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$node/@TMV"/>
        <xsl:value-of select="$line-feed"/>
        <!-- service package -->
        <xsl:for-each select="$xcd">
          <xsl:value-of select="key('xcd-index','SP')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:text>: </xsl:text>        
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="$node/@SP"/>
          <xsl:with-param name="Type"  select="'SP'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
        <xsl:value-of select="$line-feed"/>
      </xsl:otherwise>
    </xsl:choose>
    <!-- quantity -->
    <xsl:for-each select="$xcd">
      <xsl:value-of select="key('xcd-index','NumIt')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text>: </xsl:text>
    <xsl:value-of select="$node/@Numit"/>
    <xsl:value-of select="$line-feed"/>
    <!-- active days -->
    <xsl:for-each select="$xcd">
      <xsl:value-of select="key('xcd-index','NumDays')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text>: </xsl:text>
    <xsl:value-of select="$node/@NumDays"/>
    <xsl:value-of select="$line-feed"/>
    <!-- service charge subtype -->
    <xsl:for-each select="$xcd">
      <xsl:value-of select="key('xcd-index','SrvChSType')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text>: </xsl:text>        
    <xsl:call-template name="DataDomainLgnMap">
      <xsl:with-param name="Index"     select="$node/@SrvChSType"/>
      <xsl:with-param name="Type"      select="'DD'"/>
      <xsl:with-param name="Desc"      select="'1'"/>
      <xsl:with-param name="ClassId"   select="'CHARGE_SUBTYPE_CLASS'"/>
    </xsl:call-template>
    <xsl:value-of select="$line-feed"/>    
    <!-- service period, status -->
    <xsl:for-each select="$xcd">
      <xsl:value-of select="key('xcd-index','ChrgStTime')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text>: </xsl:text>
    <xsl:if test="@ChrgStartTime">
      <xsl:call-template name="date-time-format">
        <xsl:with-param name="date" select="@ChrgStartTime"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="@ChrgEndTime">
      <xsl:text> - </xsl:text>
      <xsl:call-template name="date-time-format">
        <xsl:with-param name="date" select="@ChrgEndTime"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:value-of select="$line-feed"/>
    <xsl:if test="@SrvSt">
      <xsl:for-each select="$xcd">
        <xsl:value-of select="key('xcd-index','SrvSt')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
      <xsl:text>: </xsl:text>
      <xsl:value-of select="$node/@SrvSt"/>
      <xsl:value-of select="$line-feed"/>
    </xsl:if>
    <!-- market -->
    <xsl:for-each select="$xcd">
      <xsl:value-of select="key('xcd-index','MKT')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text>: </xsl:text>
    <xsl:call-template name="LgnMap">
      <xsl:with-param name="Mode"  select="'0'"/>
      <xsl:with-param name="Index" select="$node/@MKT"/>
      <xsl:with-param name="Type"  select="'MRKT'"/>
      <xsl:with-param name="Desc"  select="'1'"/>
    </xsl:call-template>
    <xsl:value-of select="$line-feed"/>   
    <!-- service info ( @PrmValueId can be mapped to the description via the respective SumItem ) -->
    <!--
    <xsl:if test="$charge-type='S'">
      <xsl:for-each select="$xcd">
        <xsl:value-of select="key('xcd-index','PrmValueId')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
      <xsl:text>: </xsl:text>
      <xsl:value-of select="$node/@PrmValueId"/>
      <xsl:value-of select="$line-feed"/>
    </xsl:if>
    -->
    <!-- price -->
    <xsl:for-each select="$xcd">
      <xsl:value-of select="key('xcd-index','Price')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text>: </xsl:text>
    <xsl:call-template name="number-format">
      <xsl:with-param name="number" select="$node/@Price"/>
    </xsl:call-template>    
    <xsl:text> </xsl:text>
    <xsl:value-of select="$node/@PriceCurr"/>
    <xsl:value-of select="$line-feed"/>
    <!-- profile -->
    <xsl:for-each select="$xcd">
      <xsl:value-of select="key('xcd-index','PRO')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text>: </xsl:text>
    <xsl:call-template name="LgnMap">
      <xsl:with-param name="Mode"  select="'0'"/>
      <xsl:with-param name="Index" select="$node/@PRO"/>
      <xsl:with-param name="Type"  select="'PRO'"/>
      <xsl:with-param name="Desc"  select="'1'"/>
    </xsl:call-template>
    <xsl:value-of select="$line-feed"/>
    <!-- amount -->
    <xsl:for-each select="$xcd">
      <xsl:value-of select="key('xcd-index','OAmt')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text>: </xsl:text>
    <xsl:call-template name="number-format">
      <xsl:with-param name="number" select="$node/@OAmt"/>
    </xsl:call-template>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$node/@CC"/>
    <xsl:value-of select="$line-feed"/>

  </xsl:template>

  <!-- cch free units -->
  <xsl:template match="FUP" mode="charge-details">

    <!-- cost control service -->
    <xsl:for-each select="$fup">
      <xsl:value-of select="key('fup-index','SN')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text>: </xsl:text>
    <xsl:call-template name="LgnMap">
      <xsl:with-param name="Mode"  select="'0'"/>
      <xsl:with-param name="Index" select="@SN"/>
      <xsl:with-param name="Type"  select="'SN'"/>
      <xsl:with-param name="Desc"  select="'1'"/>
    </xsl:call-template>
    <xsl:value-of select="$line-feed"/>
    <!-- profile -->
    <xsl:for-each select="$fup">
      <xsl:value-of select="key('fup-index','Profile')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>      
    <xsl:text>: </xsl:text>
    <xsl:call-template name="LgnMap">
      <xsl:with-param name="Mode"  select="'0'"/>
      <xsl:with-param name="Index" select="@Profile"/>
      <xsl:with-param name="Type"  select="'PRO'"/>
      <xsl:with-param name="Desc"  select="'1'"/>
    </xsl:call-template>
    <xsl:value-of select="$line-feed"/>
    <!-- discount amount -->
    <xsl:for-each select="$fup">
      <xsl:value-of select="key('fup-index','Amt')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>      
    <xsl:text>: </xsl:text>
    <xsl:call-template name="number-format">
      <xsl:with-param name="number" select="@Amt"/>
    </xsl:call-template>
    <xsl:text> </xsl:text>
    <xsl:value-of select="@AmtCurrCode"/>
    <xsl:value-of select="$line-feed"/>

  </xsl:template>

</xsl:stylesheet>
