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

  File:    DepositRequest.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> HTML stylesheet
  @(#) BSCS iX R4, Bill Formatter

  This stylesheet transforms deposit requests.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/DepositRequest.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" exclude-result-prefixes="xsl cur">

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

    <table width="100%" border="1" cellspacing="0" cellpadding="0">
      <!-- deposit request date -->
      <tr>
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','219')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:value-of select="$inv-date-format"/>
        </font></td>
      </tr>
      <!-- payment due date -->
      <tr>
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','240')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:value-of select="$due-date-format"/>
        </font></td>
      </tr>
      <!-- contract -->
      <tr>
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','220')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:value-of select="@CoId"/>
        </font></td>
      </tr>
      <!-- amount to pay -->
      <xsl:for-each select="Charge">
        <xsl:variable name="number-format">
          <xsl:call-template name="number-format">
            <xsl:with-param name="number" select="@Amount"/>
          </xsl:call-template>
        </xsl:variable>
        <tr>
          <td><font color="red" size="-1">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','226')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </font></td>
          <td align="right"><font color="red" size="-1">
            <xsl:value-of select="$number-format"/>
            <xsl:text> </xsl:text>
            <xsl:for-each select="@CurrCode">
              <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
          </font></td>
        </tr>
      </xsl:for-each>
    </table>
    <xsl:if test="ChargePerCS">
      <br/>
      <table width="100%" border="1" cellspacing="0" cellpadding="0">
        <tr>
          <xsl:for-each select="$txt">
            <th nowrap="nowrap"><font size="-1">
              <xsl:value-of select="key('txt-index','221')[@xml:lang=$lang]/@Des"/>
            </font></th>
            <th nowrap="nowrap"><font size="-1">
              <xsl:value-of select="key('txt-index','222')[@xml:lang=$lang]/@Des"/>
            </font></th>
            <th nowrap="nowrap"><font size="-1">
              <xsl:value-of select="key('txt-index','223')[@xml:lang=$lang]/@Des"/>
            </font></th>
            <th nowrap="nowrap"><font size="-1">
              <xsl:value-of select="key('txt-index','224')[@xml:lang=$lang]/@Des"/>
            </font></th>
            <th nowrap="nowrap"><font size="-1">
              <xsl:value-of select="key('txt-index','225')[@xml:lang=$lang]/@Des"/>
            </font></th>
          </xsl:for-each>
        </tr>
        <xsl:for-each select="ChargePerCS">
          <tr>
            <xsl:apply-templates select="."/>
          </tr>
        </xsl:for-each>
      </table>
    </xsl:if>

  </xsl:template>

  <!-- charge per contracted service -->
  <xsl:template match="ChargePerCS">

    <xsl:apply-templates select="CS"/>
    <xsl:for-each select="Charge">
      <xsl:variable name="number-format">
        <xsl:call-template name="number-format">
          <xsl:with-param name="number" select="@Amount"/>
        </xsl:call-template>
      </xsl:variable>
      <td align="right"><font size="-1">
        <xsl:value-of select="$number-format"/>
        <xsl:text> </xsl:text>
        <xsl:for-each select="@CurrCode">
          <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
        </xsl:for-each>
      </font></td>
    </xsl:for-each>

  </xsl:template>

  <!-- contracted service -->
  <xsl:template match="CS">

    <td><font size="-1">
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="@SN"/>
        <xsl:with-param name="Type"  select="'SN'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
    </font></td>
    <td><font size="-1">
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="@SP"/>
        <xsl:with-param name="Type"  select="'SP'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
    </font></td>
    <td><font size="-1">
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="@TM"/>
        <xsl:with-param name="Type"  select="'TM'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
    </font></td>
    <td><font size="-1">
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="@PRO"/>
        <xsl:with-param name="Type"  select="'PRO'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
    </font></td>

  </xsl:template>

</xsl:stylesheet>