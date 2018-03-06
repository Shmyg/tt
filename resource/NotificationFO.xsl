<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    NotificationFO.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> XSL-FO stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms charge notification messages.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/NotificationFO.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:cur="http://www.unece.org/etrades/unedocs" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="xsl cur set">

  <xsl:variable name="charge-details" select="document(/Bill/Part/@File)/Document/ChargeNotification"/>

  <!-- charge notification -->
  <xsl:template match="ChargeNotification">

    <xsl:variable name="co-id" select="@CoId"/>

    <!-- receiver address header -->
    <fo:block font-family="Helvetica" font-size="8pt">
      <fo:inline text-decoration="underline">
        <xsl:value-of select="concat(Addr/@Name ,' ',
                                     Addr/@Line1,' ',Addr/@Line2,' ',
                                     Addr/@Line3,' ',Addr/@Line4,' ',
                                     Addr/@Line5,' ',Addr/@Line6,' ',
                                     Addr/@Zip  ,' ',Addr/@City ,' ',
                                     Addr/@Country)"/>
      </fo:inline>
    </fo:block>
    <fo:block font-family="Helvetica" font-size="8pt" space-before="2mm">
      <!-- MSISDN -->
      <xsl:if test="Addr/@MSISDN">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','485')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="Addr/@MSISDN"/>
      </xsl:if>
    </fo:block>
    <fo:block font-family="Helvetica" font-size="8pt" space-after="2mm">
      <!-- email -->
      <xsl:if test="Addr/@Email">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','486')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="Addr/@Email"/>
      </xsl:if>
    </fo:block>
    <fo:block space-before="3mm" text-align="center" font-weight="bold" font-size="14pt">
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
    </fo:block>
    <!-- contract -->
    <xsl:if test="@CoId">
      <fo:block space-before="2mm" font-size="8pt" text-align="left">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','109')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="@CoId"/>
      </fo:block>
    </xsl:if>
    <!-- remaining credit -->
    <xsl:if test="Charge">
      <fo:block font-size="8pt" color="red" text-align="left">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','175')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:variable name="number-format">
          <xsl:call-template name="number-format">
            <xsl:with-param name="number" select="Charge/@Amount"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="$number-format"/>
        <xsl:text> </xsl:text>
        <xsl:for-each select="Charge/@CurrCode">
          <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
        </xsl:for-each>
      </fo:block>
    </xsl:if>
    <!-- balance snapshots -->
    <xsl:if test="BalSsh">
      <fo:block space-before="2mm">
        <fo:table width="160mm" table-layout="fixed">
          <fo:table-column column-width="20mm" column-number="1"/>
          <fo:table-column column-width="40mm" column-number="2"/>
          <fo:table-column column-width="40mm" column-number="3"/>
          <fo:table-column column-width="20mm" column-number="4"/>
          <fo:table-column column-width="20mm" column-number="5"/>
          <fo:table-column column-width="20mm" column-number="6"/>
          <fo:table-header space-after="2pt">
            <fo:table-row font-size="7pt" font-weight="bold" text-align="center">
              <fo:table-cell number-columns-spanned="6">
                <fo:block text-align="center" font-weight="bold" font-size="9pt">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','167')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row font-size="7pt" font-weight="bold" text-align="center">
              <xsl:for-each select="$txt">
                <!-- snapshot date -->
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block>
                    <xsl:value-of select="key('txt-index','168')[@xml:lang=$lang]/@Des"/>
                  </fo:block>
                </fo:table-cell>
                <!-- service -->
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block>
                    <xsl:value-of select="key('txt-index','170')[@xml:lang=$lang]/@Des"/>
                  </fo:block>
                </fo:table-cell>
                <!-- bundle product -->
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block>
                    <xsl:value-of select="key('txt-index','445')[@xml:lang=$lang]/@Des"/>
                  </fo:block>
                </fo:table-cell>
                <!-- used volume -->
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block>
                    <xsl:value-of select="key('txt-index','173')[@xml:lang=$lang]/@Des"/>
                  </fo:block>
                </fo:table-cell>
                <!-- used credit -->
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block>
                    <xsl:value-of select="key('txt-index','174')[@xml:lang=$lang]/@Des"/>
                  </fo:block>
                </fo:table-cell>
                <!-- remaining credit -->
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block>
                    <xsl:value-of select="key('txt-index','175')[@xml:lang=$lang]/@Des"/>
                  </fo:block>
                </fo:table-cell>
              </xsl:for-each>
            </fo:table-row>
          </fo:table-header>
          <fo:table-body font-size="7pt">
            <xsl:for-each select="BalSsh">
              <fo:table-row>
                <xsl:apply-templates select="."/>
              </fo:table-row>
            </xsl:for-each>
          </fo:table-body>
        </fo:table>
      </fo:block>
    </xsl:if>
    <!-- action -->
    <xsl:if test="Action">
     <fo:block space-before="2mm">
        <fo:table width="160mm" table-layout="fixed">
          <fo:table-column column-width="40mm" column-number="1"/>
          <fo:table-column column-width="40mm" column-number="2"/>
          <fo:table-column column-width="40mm" column-number="3"/>
          <fo:table-column column-width="40mm" column-number="4"/>
          <fo:table-header space-after="2pt">
            <fo:table-row font-size="7pt" font-weight="bold" text-align="center">
              <fo:table-cell number-columns-spanned="4">
                <fo:block text-align="center" font-weight="bold" font-size="9pt">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','473')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row font-size="7pt" font-weight="bold" text-align="center">
              <xsl:for-each select="$txt">
                <!-- event -->
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block>
                    <xsl:value-of select="key('txt-index','474')[@xml:lang=$lang]/@Des"/>
                  </fo:block>
                </fo:table-cell>
                <!-- service -->
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block>
                    <xsl:value-of select="key('txt-index','475')[@xml:lang=$lang]/@Des"/>
                  </fo:block>
                </fo:table-cell>
                <!-- profile -->
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block>
                    <xsl:value-of select="key('txt-index','476')[@xml:lang=$lang]/@Des"/>
                  </fo:block>
                </fo:table-cell>
                <!-- type -->
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block>
                    <xsl:value-of select="key('txt-index','477')[@xml:lang=$lang]/@Des"/>
                  </fo:block>
                </fo:table-cell>
              </xsl:for-each>
            </fo:table-row>
          </fo:table-header>
          <fo:table-body font-size="7pt">
            <xsl:for-each select="Action">
              <fo:table-row>
                <xsl:apply-templates select="."/>
              </fo:table-row>
            </xsl:for-each>
          </fo:table-body>
        </fo:table>
      </fo:block>
    </xsl:if>

    <!-- charge details (the BOP info is not given here !) -->
    <xsl:if test="ChDet">
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
    </xsl:if>

  </xsl:template>

  <!-- action -->
  <xsl:template match="Action">

    <!-- event -->
    <fo:table-cell text-align="center">
      <fo:block>
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
      </fo:block>
    </fo:table-cell>
    <!-- service -->
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@SN"/>
          <xsl:with-param name="Type"  select="'SN'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <!-- profile -->
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@PRO"/>
          <xsl:with-param name="Type"  select="'PRO'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <!-- type -->
    <fo:table-cell text-align="center">
      <fo:block>
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
      </fo:block>
    </fo:table-cell>

  </xsl:template>

</xsl:stylesheet>
