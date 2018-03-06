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

  File:    NotificationTXT.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> TXT stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms charge notification messages.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/NotificationTXT.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="xsl set">

  <xsl:variable name="charge-details" select="document(/Bill/Part/@File)/Document/ChargeNotification"/>

  <!-- charge notification -->
  <xsl:template match="ChargeNotification">

    <xsl:variable name="co-id" select="@CoId"/>

      <!-- MSISDN -->
      <xsl:if test="Addr/@MSISDN">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','485')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="Addr/@MSISDN"/>
        <xsl:value-of select="$line-feed"/>
      </xsl:if>
      <!-- email -->
      <xsl:if test="Addr/@Email">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','486')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="Addr/@Email"/>
        <xsl:value-of select="$line-feed"/>
      </xsl:if>
      <!-- kind of message -->
      <xsl:choose>
        <!-- advance notification -->
        <xsl:when test="@Type='NOTADV'">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','468')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </xsl:when>
        <!-- insufficient credit -->
        <xsl:when test="@Type='NOTICR'">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','469')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </xsl:when>
        <!-- charge booked -->
        <xsl:when test="@Type='NOTCHB'">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','470')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </xsl:when>
        <!-- overdraft clearance -->
        <xsl:when test="@Type='NOTOCP'">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','471')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </xsl:when>
        <!-- unknown short message -->
        <xsl:otherwise>
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','472')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','484')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
      <xsl:text> </xsl:text>
      <!-- receiver address header -->
      <xsl:value-of select="concat(Addr/@Line1,' ',Addr/@Line2,' ',Addr/@Line3)"/>
      <xsl:value-of select="$line-feed"/>
      <!-- contract -->
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','109')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
      <xsl:text>: </xsl:text>
      <xsl:value-of select="@CoId"/>
      <xsl:value-of select="$line-feed"/>
      <!-- remaining credit -->
      <xsl:if test="Charge">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','175')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:text>: </xsl:text>
        <xsl:variable name="number-format">
          <xsl:call-template name="number-format">
            <xsl:with-param name="number" select="Charge/@Amount"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$number-format"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="Charge/@CurrCode"/>
        <xsl:value-of select="$line-feed"/>
      </xsl:if>
      <!-- balance snapshots -->
      <xsl:if test="BalSsh">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','167')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:value-of select="$line-feed"/>
        <xsl:for-each select="BalSsh">
          <xsl:apply-templates select="."/>
        </xsl:for-each>
      </xsl:if>
      <!-- action -->
      <xsl:if test="Action">
        <xsl:value-of select="$line-feed"/>
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','473')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:value-of select="$line-feed"/>
        <xsl:for-each select="Action">
          <xsl:apply-templates select="."/>
        </xsl:for-each>
      </xsl:if>
      <!-- charge details (the BOP info is not given here !) -->
      <!-- recurring charge details info -->
      <xsl:call-template name="print-charge-details">
        <xsl:with-param name="co-id" select="$co-id"/>
        <xsl:with-param name="bopind" select="'N'"/>
        <xsl:with-param name="bopseqno" select="''"/>
        <xsl:with-param name="boptype" select="''"/>
        <xsl:with-param name="charge-details" select="$charge-details"/>
        <xsl:with-param name="charge-type" select="'A'"/>
      </xsl:call-template>
      <!-- one-time charge details info -->
      <xsl:call-template name="print-charge-details">
        <xsl:with-param name="co-id" select="$co-id"/>
        <xsl:with-param name="bopind" select="'N'"/>
        <xsl:with-param name="bopseqno" select="''"/>
        <xsl:with-param name="boptype" select="''"/>
        <xsl:with-param name="charge-details" select="$charge-details"/>
        <xsl:with-param name="charge-type" select="'S'"/>
      </xsl:call-template>

  </xsl:template>

  <!-- action -->
  <xsl:template match="Action">

    <!-- event -->
    <xsl:for-each select="$txt">
      <xsl:value-of select="key('txt-index','474')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text>: </xsl:text>
    <xsl:choose>
      <!-- gmd action id (only one)-->
      <xsl:when test="@Id='8'">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','481')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>-</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$line-feed"/>
    <!-- service -->
    <xsl:for-each select="$txt">
      <xsl:value-of select="key('txt-index','475')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text>: </xsl:text>
    <xsl:call-template name="LgnMap">
      <xsl:with-param name="Mode"  select="'0'"/>
      <xsl:with-param name="Index" select="@SN"/>
      <xsl:with-param name="Type"  select="'SN'"/>
      <xsl:with-param name="Desc"  select="'1'"/>
    </xsl:call-template>
    <xsl:value-of select="$line-feed"/>
    <!-- type -->
    <!-- kind of message -->
    <xsl:for-each select="$txt">
      <xsl:value-of select="key('txt-index','477')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text>: </xsl:text>
    <xsl:choose>
      <!-- activation -->
      <xsl:when test="@Action='A'">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','478')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </xsl:when>
      <!-- deactivation -->
      <xsl:when test="@Action='D'">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','479')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </xsl:when>
      <!-- suspension -->
      <xsl:when test="@Action='S'">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','480')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </xsl:when>
      <!-- unknown action -->
      <xsl:otherwise>
        <xsl:value-of select="@Action"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$line-feed"/>

  </xsl:template>

</xsl:stylesheet>
