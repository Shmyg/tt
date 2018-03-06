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

  File:    DepositRequestFO.xsl

  Owners:  Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> XSL-FO stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms deposit requests.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/DepositRequestFO.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" exclude-result-prefixes="xsl cur">

  <!-- deposit request -->
  <xsl:template match="DepositRequest">

    <xsl:variable name="inv-date-format">
      <xsl:call-template name="date-time-format">
        <xsl:with-param name="date" select="Date[@Type='INV']/@Date"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="due-date-format">
      <xsl:call-template name="date-time-format">
        <xsl:with-param name="date" select="Date[@Type='DUE_DATE']/@Date"/>
      </xsl:call-template>
    </xsl:variable>

    <fo:table table-layout="fixed" width="160mm">
      <fo:table-column column-width="80mm" column-number="1"/>
      <fo:table-column column-width="80mm" column-number="2"/>
      <fo:table-body>
        <!-- deposit request date -->
        <fo:table-row>
          <fo:table-cell>
            <fo:block space-before="6mm" font-size="8pt" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','219')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block space-before="6mm" font-size="8pt" text-align="right">
              <xsl:value-of select="$inv-date-format"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <!-- payment due date -->
        <fo:table-row>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','240')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="right">
              <xsl:value-of select="$due-date-format"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <!-- contract -->
        <fo:table-row>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','220')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="right">
              <xsl:value-of select="@CoId"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <xsl:for-each select="Charge">
          <xsl:variable name="number-format">
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="@Amount"/>
            </xsl:call-template>
          </xsl:variable>
          <!-- amount to pay -->
          <fo:table-row>
            <fo:table-cell>
              <fo:block font-size="8pt" text-align="left">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','226')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block font-size="8pt" text-align="right">
              <xsl:value-of select="$number-format"/>
              <xsl:text> </xsl:text>
              <xsl:for-each select="@CurrCode">
                <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>
      </fo:table-body>
    </fo:table>

    <xsl:if test="ChargePerCS">

      <fo:table space-before="6mm" width="160mm" table-layout="fixed">

        <fo:table-column column-width="32mm" column-number="1"/>
        <fo:table-column column-width="32mm" column-number="2"/>
        <fo:table-column column-width="32mm" column-number="3"/>
        <fo:table-column column-width="32mm" column-number="4"/>
        <fo:table-column column-width="32mm" column-number="5"/>

        <fo:table-header space-after="2pt">
          <fo:table-row>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','221')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','222')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','223')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','224')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','225')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-header>
        <fo:table-body>
          <xsl:for-each select="ChargePerCS">
            <fo:table-row>
              <xsl:apply-templates select="."/>
            </fo:table-row>
          </xsl:for-each>
        </fo:table-body>
      </fo:table>
    </xsl:if>

  </xsl:template>

  <!-- charge per contracted service -->
  <xsl:template match="ChargePerCS">

    <xsl:apply-templates select="CS"/>
    <fo:table-cell>
      <fo:block font-size="8pt" font-weight="normal" text-align="right">
        <xsl:for-each select="Charge">
          <xsl:variable name="number-format">
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="@Amount"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:value-of select="$number-format"/>
          <xsl:text> </xsl:text>
          <xsl:for-each select="@CurrCode">
            <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
          </xsl:for-each>
        </xsl:for-each>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <!-- contracted service -->
  <xsl:template match="CS">

    <fo:table-cell>
      <fo:block font-size="8pt" font-weight="normal" text-align="left">
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@SN"/>
          <xsl:with-param name="Type"  select="'SN'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell>
      <fo:block font-size="8pt" font-weight="normal" text-align="left">
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@SP"/>
          <xsl:with-param name="Type"  select="'SP'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell>
      <fo:block font-size="8pt" font-weight="normal" text-align="left">
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@TM"/>
          <xsl:with-param name="Type"  select="'TM'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell>
      <fo:block font-size="8pt" font-weight="normal" text-align="left">
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@PRO"/>
          <xsl:with-param name="Type"  select="'PRO'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>

  </xsl:template>

</xsl:stylesheet>
