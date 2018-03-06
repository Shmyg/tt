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

  File:    CallDetailStatement.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> HTML stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms call detail statement documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/CallDetailStatement.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="xsl cur set">

  <xsl:variable name="call-detail-statement" select="document(/Bill/Part/@File)/Document/CallDetailStatement"/>
  <xsl:variable name="call-details-cds" select="document(/Bill/Part/@File)/Document/CallDetailStatement/CallsPerPeriod"/>

  <xsl:template name="CallDetailStatement">

    <xsl:for-each select="$call-detail-statement">
      <!-- print contract header -->
      <xsl:if test="position()='1'">
        <table border="1" width="50%" cellspacing="0" cellpadding="0">
          <tr>
            <td><font size="-1">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','404')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </font></td>
            <td align="right"><font size="-1">
              <!-- no LB date for new contract -->
              <xsl:if test="Date[@Type='LB_DATE']">
                <!-- last bill date -->
                <xsl:call-template name="date-time-format">
                  <xsl:with-param name="date" select="Date[@Type='LB_DATE']/@Date"/>
                </xsl:call-template>
              </xsl:if>
            </font></td>
          </tr>
          <tr>
            <!-- total period -->
            <td><font size="-1"><b>
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','423')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </b></font></td>
            <td align="right"><font size="-1"><b>
              <!-- period start -->
              <xsl:if test="Date[@Type='START']">
                <xsl:call-template name="date-time-format">
                  <xsl:with-param name="date" select="Date[@Type='START']/@Date"/>
                </xsl:call-template>
              </xsl:if>
              <xsl:if test="Date[@Type='END']">
                <xsl:text> - </xsl:text>
                <!-- period end -->
                <xsl:call-template name="date-time-format">
                  <xsl:with-param name="date" select="Date[@Type='END']/@Date"/>
                </xsl:call-template>
              </xsl:if>
            </b></font></td>
          </tr>
          <tr>
            <td><font size="-1">
              <!-- market -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','111')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </font></td>
            <td align="right"><font size="-1">
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="@MRKT"/>
                <xsl:with-param name="Type"  select="'MRKT'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
            </font></td>
          </tr>
          <tr>
            <td><font size="-1">
              <!-- sim number -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','112')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </font></td>
            <td align="right"><font size="-1">
              <xsl:value-of select="@SM"/>
            </font></td>
          </tr>
          <xsl:choose>
            <!-- DN's -->
            <xsl:when test="DN">
              <xsl:for-each select="DN">
                <!-- sort the directory numbers -->
                <xsl:sort select="." data-type="number" order="ascending"/>
                <tr>
                  <xsl:apply-templates select="."/>
                </tr>
              </xsl:for-each>
            </xsl:when>
            <!-- DN block(s) -->
            <xsl:when test="DNBlock">
              <xsl:for-each select="DNBlock">
                <tr>
                  <xsl:apply-templates select="."/>
                </tr>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
          </xsl:choose>
        </table>
      </xsl:if>

      <!-- calls per period -->
      <xsl:for-each select="CallsPerPeriod">
        <!-- print header for each new sequence -->
        <xsl:if test="@SeqNo='0'">
          <xsl:call-template name="CallsPerPeriod"/>
        </xsl:if>
      </xsl:for-each>

    </xsl:for-each>

  </xsl:template>

  <xsl:template name="CallsPerPeriod">

    <xsl:variable name="period-start" select="Date[@Type='START']/@Date"/>
    <xsl:variable name="period-end" select="Date[@Type='END']/@Date"/>

    <!-- period info -->
    <br/>
    <table width="50%" cellspacing="0" cellpadding="0">
      <tr>
        <td><font size="-1"><b>
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','405')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </b></font></td>
        <td align="right"><font size="-1"><b>
          <!-- period start -->
          <xsl:if test="Date[@Type='START']">
            <xsl:call-template name="date-time-format">
              <xsl:with-param name="date" select="$period-start"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="Date[@Type='END']">
            <xsl:text> - </xsl:text>
            <!-- period end -->
            <xsl:call-template name="date-time-format">
              <xsl:with-param name="date" select="$period-end"/>
            </xsl:call-template>
          </xsl:if>
        </b></font></td>
      </tr>
    </table>

    <xsl:choose>
      <xsl:when test="BOPAlt">
        <!-- number of alternatives -->
        <table width="50%" cellspacing="0" cellpadding="0">
          <tr>
            <td><font size="-1">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','406')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </font></td>
            <td align="right"><font size="-1">
              <xsl:value-of select="count(BOPAlt)"/>
            </font></td>
          </tr>
        </table>
        <!-- billed alternative first -->
        <xsl:for-each select="BOPAlt">
          <xsl:sort select="@BILLED" data-type="text" order="descending"/>
          <xsl:sort select="@CONTR" data-type="text" order="descending"/>
          <xsl:call-template name="bop-cds">
            <xsl:with-param name="period-start" select="$period-start"/>
            <xsl:with-param name="period-end" select="$period-end"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <!-- select all calls for a given period over all documents and sequences including late calls -->
      <xsl:otherwise>
        <!-- sum udr tap -->
        <xsl:call-template name="print-sum-udr-tap">
          <xsl:with-param name="co-id"        select="../@CoId"/>
          <xsl:with-param name="call-details" select="$call-details-cds
           [(Date[@Type='START']/@Date = $period-start) and (Date[@Type='END']/@Date = $period-end)]"/>
        </xsl:call-template>
        <!-- sum udr rap -->
        <xsl:call-template name="print-sum-udr-rap">
          <xsl:with-param name="co-id"        select="../@CoId"/>
          <xsl:with-param name="call-details" select="$call-details
           [(Date[@Type='START']/@Date = $period-start) and (Date[@Type='END']/@Date = $period-end)]"/>
        </xsl:call-template>
        <!-- bundle usage -->
        <xsl:call-template name="print-call-details-bundle-usage">
          <xsl:with-param name="co-id"        select="../@CoId"/>
          <xsl:with-param name="call-details" select="$call-details-cds
           [(Date[@Type='START']/@Date = $period-start) and (Date[@Type='END']/@Date = $period-end)]"/>
        </xsl:call-template>
        <!-- not bundled usage -->
        <xsl:call-template name="print-call-details">
          <xsl:with-param name="co-id" select="../@CoId"/>
          <xsl:with-param name="bopind" select="'N'"/>
          <xsl:with-param name="call-details" select="$call-details-cds
           [(Date[@Type='START']/@Date = $period-start) and (Date[@Type='END']/@Date = $period-end)]"/>
        </xsl:call-template>
        <!-- call details in case of large volumes -->
        <!--
        <xsl:call-template name="print-call-details-large-volume">
          <xsl:with-param name="co-id"        select="../@CoId"/>
          <xsl:with-param name="bopind"       select="'N'"/>
          <xsl:with-param name="call-details" select="$call-details-cds
           [(Date[@Type='START']/@Date = $period-start) and (Date[@Type='END']/@Date = $period-end)]"/>
        </xsl:call-template>
        -->
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="bop-cds">

    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>

    <br/>
    <table width="50%" border="1" cellspacing="0" cellpadding="0">
      <tr>
        <td><font size="-1">
          <!-- bop package -->
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','407')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="@BOPPack"/>
            <xsl:with-param name="Type"  select="'BOP'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
        </font></td>
      </tr>
      <tr>
        <td><font size="-1">
          <!-- bop purpose -->
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','408')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="@BOPPurp"/>
            <xsl:with-param name="Type"  select="'BPURP'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
        </font></td>
      </tr>
      <tr bgcolor="#B0C4DE">
        <td><font size="-1">
          <!-- alternate tariff model or package -->
          <xsl:choose>
            <xsl:when test="AggSet/Att/@Ty='TM'">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','409')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','410')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text> (</xsl:text>
          <xsl:choose>
            <xsl:when test="@CONTR='Y'">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','411')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','412')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text>, </xsl:text>
          <xsl:choose>
            <xsl:when test="@BILLED='Y'">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','413')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','414')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text>)</xsl:text>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="AggSet/Att/@Id"/>
            <xsl:with-param name="Type"  select="AggSet/Att/@Ty"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
          </font></td>
        </tr>
        <tr>
          <td><font size="-1">
            <!-- bop sequence -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','415')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </font></td>
          <td align="right"><font size="-1">
            <xsl:value-of select="@BOPSeqNo"/>
          </font></td>
        </tr>
      </table>
      <!-- select all calls for a given period and BOP alternative over all documents and sequences
           including late calls -->
      <!-- sum udr tap -->
      <xsl:call-template name="print-sum-udr-tap">
        <xsl:with-param name="co-id"        select="../../@CoId"/>
        <xsl:with-param name="call-details" select="$call-details-cds
         [(Date[@Type='START']/@Date = $period-start) and (Date[@Type='END']/@Date = $period-end)]"/>
      </xsl:call-template>
      <!-- sum udr rap -->
      <xsl:call-template name="print-sum-udr-rap">
        <xsl:with-param name="co-id"        select="../../@CoId"/>
        <xsl:with-param name="call-details" select="$call-details
         [(Date[@Type='START']/@Date = $period-start) and (Date[@Type='END']/@Date = $period-end)]"/>
      </xsl:call-template>
      <!-- bundle usage -->
      <xsl:call-template name="print-call-details-bundle-usage">
        <xsl:with-param name="co-id"        select="../../@CoId"/>
        <xsl:with-param name="call-details" select="$call-details-cds
         [(Date[@Type='START']/@Date = $period-start) and (Date[@Type='END']/@Date = $period-end)]"/>
      </xsl:call-template>
      <!-- not bundled usage -->
      <xsl:call-template name="print-call-details">
        <xsl:with-param name="co-id" select="../../@CoId"/>
        <xsl:with-param name="bopind" select="'Y'"/>
        <xsl:with-param name="bopseqno" select="@BOPSeqNo"/>
        <xsl:with-param name="boptype" select="AggSet/Att/@Ty"/>
        <xsl:with-param name="call-details" select="$call-details-cds
         [(Date[@Type='START']/@Date = $period-start) and (Date[@Type='END']/@Date = $period-end)]"/>
      </xsl:call-template>
      <!-- call details in case of large volumes -->
      <!--
      <xsl:call-template name="print-call-details-large-volume">
        <xsl:with-param name="co-id"        select="../../@CoId"/>
        <xsl:with-param name="bopind"       select="'Y'"/>
        <xsl:with-param name="bopseqno"     select="@BOPSeqNo"/>
        <xsl:with-param name="boptype"      select="AggSet/Att/@Ty"/>
        <xsl:with-param name="call-details" select="$call-details-cds
         [(Date[@Type='START']/@Date = $period-start) and (Date[@Type='END']/@Date = $period-end)]"/>
      </xsl:call-template>
      -->
  </xsl:template>

</xsl:stylesheet>
