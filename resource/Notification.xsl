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

  File:    Notification.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> HTML stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms charge notification messages.
  VERSION = @@CBIO_PCP1503_150728

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="xsl cur set">

  <xsl:variable name="charge-details" select="document(/Bill/Part/@File)/Document/ChargeNotification"/>

  <!-- charge notification -->
  <xsl:template match="ChargeNotification">

    <xsl:variable name="co-id" select="@CoId"/>
    <div>
      <!-- receiver address header -->
      <u><xsl:value-of select="concat(Addr/@Name ,'&#160;',
                                      Addr/@Line1,'&#160;',Addr/@Line2,'&#160;',
                                      Addr/@Line3,'&#160;',Addr/@Line4,'&#160;',
                                      Addr/@Line5,'&#160;',Addr/@Line6,'&#160;',
                                      Addr/@Zip  ,'&#160;',Addr/@City ,'&#160;',
                                      Addr/@Country)"/>
      </u><br/>
      <!-- MSISDN -->
      <xsl:if test="Addr/@MSISDN">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','485')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="Addr/@MSISDN"/>
      </xsl:if>
      <!-- email -->
      <xsl:if test="Addr/@Email">
        <br/>
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','486')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="Addr/@Email"/>
        <br/>
      </xsl:if>
    </div>
    <div>
    <center><h2>
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
      </xsl:choose></h2></center>
      <p>
        <!-- contract -->
        <xsl:if test="@CoId">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','109')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
          <xsl:text>: </xsl:text>
          <i><xsl:value-of select="@CoId"/></i>
          <br/>
        </xsl:if>
        <!-- remaining credit -->
        <xsl:if test="Charge">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','175')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
          <xsl:variable name="number-format">
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="Charge/@Amount"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:text>: </xsl:text>
          <i><font color="red">
          <xsl:value-of select="$number-format"/>
          <xsl:text> </xsl:text>
            <xsl:for-each select="Charge/@CurrCode">
              <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
          </font></i>
        </xsl:if>
      </p>
      <!-- balance snapshots -->
      <xsl:if test="BalSsh">
        <table border="1" width="100%" cellspacing="0" cellpadding="0">
          <thead>
            <tr>
              <td align="center" colspan="6"><font size="-1"><b>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','167')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </b></font></td>
            </tr>
            <tr>
              <xsl:for-each select="$txt">
                <!-- snapshot date -->
                <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                  <xsl:value-of select="key('txt-index','168')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <!-- service -->
                <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                  <xsl:value-of select="key('txt-index','170')[@xml:lang=$lang]/@Des"/><br/>
                </font></th>
                <!-- bundle product -->
                <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                  <xsl:value-of select="key('txt-index','445')[@xml:lang=$lang]/@Des"/><br/>
                </font></th>
                <!-- used volume -->
                <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                  <xsl:value-of select="key('txt-index','173')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <!-- used credit -->
                <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                  <xsl:value-of select="key('txt-index','174')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <!-- remaining credit -->
                <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                  <xsl:value-of select="key('txt-index','175')[@xml:lang=$lang]/@Des"/>
                </font></th>
              </xsl:for-each>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="BalSsh">
              <tr>
                <xsl:apply-templates select="."/>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </xsl:if>
      <!-- action -->
      <xsl:if test="Action">
        <br/>
        <table border="1" width="100%" cellspacing="0" cellpadding="0">
          <thead>
            <tr>
              <td align="center" colspan="4"><font size="-1"><b>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','473')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </b></font></td>
            </tr>
            <tr>
              <xsl:for-each select="$txt">
                <!-- event -->
                <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                  <xsl:value-of select="key('txt-index','474')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <!-- service -->
                <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                  <xsl:value-of select="key('txt-index','475')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <!-- profile -->
                <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                  <xsl:value-of select="key('txt-index','476')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <!-- type -->
                <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                  <xsl:value-of select="key('txt-index','477')[@xml:lang=$lang]/@Des"/>
                </font></th>
              </xsl:for-each>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="Action">
              <tr>
                <xsl:apply-templates select="."/>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </xsl:if>
      <!-- charge details (the BOP info is not given here !) -->
      <xsl:if test="ChDet">
        <p>
          <!-- recurring charge details info -->
          <xsl:call-template name="print-charge-details">
            <xsl:with-param name="co-id" select="$co-id"/>
            <xsl:with-param name="bopind" select="'N'"/>
            <xsl:with-param name="bopseqno" select="''"/>
            <xsl:with-param name="boptype" select="''"/>
            <xsl:with-param name="charge-details" select="$charge-details"/>
            <xsl:with-param name="charge-type" select="'A'"/>
          </xsl:call-template>
        </p>
        <p>
          <!-- one-time charge details info -->
          <xsl:call-template name="print-charge-details">
            <xsl:with-param name="co-id" select="$co-id"/>
            <xsl:with-param name="bopind" select="'N'"/>
            <xsl:with-param name="bopseqno" select="''"/>
            <xsl:with-param name="boptype" select="''"/>
            <xsl:with-param name="charge-details" select="$charge-details"/>
            <xsl:with-param name="charge-type" select="'S'"/>
          </xsl:call-template>
        </p>
      </xsl:if>
    </div>
  </xsl:template>

  <!-- action -->
  <xsl:template match="Action">

    <!-- event -->
    <td nowrap="nowrap" align="center"><font face="Arial Narrow" size="-1">
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
    </font></td>
    <!-- service -->
    <td nowrap="nowrap" align="center"><font face="Arial Narrow" size="-1">
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="@SN"/>
        <xsl:with-param name="Type"  select="'SN'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
    </font></td>
    <!-- profile -->
    <td nowrap="nowrap" align="center"><font face="Arial Narrow" size="-1">
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="@PRO"/>
        <xsl:with-param name="Type"  select="'PRO'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
    </font></td>
    <!-- type -->
    <td nowrap="nowrap" align="center"><font face="Arial Narrow" size="-1">
      <!-- kind of message -->
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
    </font></td>

  </xsl:template>

</xsl:stylesheet>
