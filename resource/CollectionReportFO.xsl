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

  File:    CollectionReportFO.xsl

  Owners:  Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> XSL-FO stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms collection reports.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/CollectionReportFO.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" exclude-result-prefixes="xsl cur">

  <!-- collection report -->
  <xsl:template match="CollectionReport">
    <fo:block space-before="3mm" text-align="center" font-weight="bold" font-size="14pt">
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','432')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
    </fo:block>
    <fo:table table-layout="fixed" width="160mm">
      <fo:table-column column-width="80mm" column-number="1"/>
      <fo:table-column column-width="80mm" column-number="2"/>
      <fo:table-body>
        <!-- total period -->
        <fo:table-row>
          <fo:table-cell>
            <fo:block space-before="6mm" font-size="8pt" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','433')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block space-before="6mm" font-size="8pt" text-align="right">
              <!-- period start -->
              <xsl:if test="Date[@Type='START']">
                <xsl:call-template name="date-format">
                  <xsl:with-param name="date" select="Date[@Type='START']/@Date"/>
                </xsl:call-template>
              </xsl:if>
              <xsl:if test="Date[@Type='END']">
                <xsl:text> - </xsl:text>
                <!-- period end -->
                <xsl:call-template name="date-format">
                  <xsl:with-param name="date" select="Date[@Type='END']/@Date"/>
                </xsl:call-template>
              </xsl:if>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
    <!-- BSCS iX R3, R4 -->
    <xsl:for-each select="CollectionDataPerBu">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    <!-- BSCS iX R2 -->
    <xsl:for-each select="CollectionDataPerCo">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:template>

  <!-- collected data per business unit -->
  <xsl:template match="CollectionDataPerBu">
    <fo:table table-layout="fixed" width="160mm">
      <fo:table-column column-width="80mm" column-number="1"/>
      <fo:table-column column-width="80mm" column-number="2"/>
      <fo:table-body>
        <!-- business unit -->
        <fo:table-row>
          <fo:table-cell>
            <fo:block space-before="3mm" font-size="8pt" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','495')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block space-before="3mm" font-size="8pt" text-align="right">
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="@BuShdes"/>
                <xsl:with-param name="Type"  select="'BU'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>              
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
    <xsl:for-each select="CollectionDataPerCo">
      <xsl:apply-templates select="."/>
    </xsl:for-each>    
  </xsl:template>

  <!-- collected data per contract -->
  <xsl:template match="CollectionDataPerCo">
    <fo:table table-layout="fixed" width="160mm">
      <fo:table-column column-width="80mm" column-number="1"/>
      <fo:table-column column-width="80mm" column-number="2"/>
      <fo:table-body>
        <!-- customer id -->
        <fo:table-row>
          <fo:table-cell>
            <fo:block space-before="3mm" font-size="8pt" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','434')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block space-before="3mm" font-size="8pt" text-align="right">
              <xsl:value-of select="@CustId"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <!-- contract id -->
        <fo:table-row>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','435')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="right">
              <xsl:value-of select="@CoId"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <!-- billed amount -->
        <fo:table-row>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','436')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="right">
              <xsl:variable name="number-format-705">
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="Charge[@Id='705']/@Amount"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:value-of select="$number-format-705"/>
              <xsl:text> </xsl:text>
              <xsl:for-each select="Charge[@Id='705']/@CurrCode">
                <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <!-- paid amount -->
        <fo:table-row>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','437')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="right">
              <xsl:variable name="number-format-706">
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="Charge[@Id='706']/@Amount"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:value-of select="$number-format-706"/>
              <xsl:text> </xsl:text>
              <xsl:for-each select="Charge[@Id='706']/@CurrCode">
                <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <!-- open amount -->
        <fo:table-row>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','438')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="right">
              <xsl:variable name="number-format-707">
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="Charge[@Id='706']/@Amount"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:value-of select="$number-format-707"/>
              <xsl:text> </xsl:text>
              <xsl:for-each select="Charge[@Id='707']/@CurrCode">
                <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
    <xsl:if test="CollectionDataPerSN">
      <fo:table width="160mm" table-layout="fixed">
        <fo:table-column column-width="32.0mm" column-number="1"/>
        <fo:table-column column-width="32.0mm" column-number="2"/>
        <fo:table-column column-width="32.0mm" column-number="3"/>
        <fo:table-column column-width="32.0mm" column-number="4"/>
        <fo:table-column column-width="32.0mm" column-number="5"/>
        <fo:table-header space-after="2pt">
          <fo:table-row>
            <!-- article -->
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block space-before="2mm" font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','439')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <!-- service -->
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block space-before="2mm" font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','440')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <!-- billed amount -->
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block space-before="2mm" font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','436')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <!-- paid amount -->
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block space-before="2mm" font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','437')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <!-- open amount -->
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block space-before="2mm" font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','438')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-header>
        <fo:table-body>
          <xsl:for-each select="CollectionDataPerSN">
            <fo:table-row>
              <xsl:apply-templates select="."/>
            </fo:table-row>
          </xsl:for-each>
        </fo:table-body>
      </fo:table>
    </xsl:if>
  </xsl:template>

  <!-- collected data per service -->
  <xsl:template match="CollectionDataPerSN">
    <!-- article -->
    <fo:table-cell>
      <fo:block font-size="8pt" text-align="center">
        <xsl:value-of select="@AS"/>
      </fo:block>
    </fo:table-cell>
    <!-- service -->
    <fo:table-cell>
      <fo:block font-size="8pt" text-align="center">
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@SN"/>
          <xsl:with-param name="Type"  select="'SN'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <!-- billed amount -->
    <fo:table-cell>
      <fo:block font-size="8pt" text-align="right">
        <xsl:variable name="number-format-705">
          <xsl:call-template name="number-format">
            <xsl:with-param name="number" select="Charge[@Id='705']/@Amount"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$number-format-705"/>
        <xsl:text> </xsl:text>
        <xsl:for-each select="Charge[@Id='705']/@CurrCode">
          <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
        </xsl:for-each>
      </fo:block>
    </fo:table-cell>
    <!-- paid amount -->
    <fo:table-cell>
      <fo:block font-size="8pt" text-align="right">
        <xsl:variable name="number-format-706">
          <xsl:call-template name="number-format">
            <xsl:with-param name="number" select="Charge[@Id='706']/@Amount"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$number-format-706"/>
        <xsl:text> </xsl:text>
        <xsl:for-each select="Charge[@Id='706']/@CurrCode">
          <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
        </xsl:for-each>
      </fo:block>
    </fo:table-cell>
    <!-- open amount -->
    <fo:table-cell>
      <fo:block font-size="8pt" text-align="right">
        <xsl:variable name="number-format-707">
          <xsl:call-template name="number-format">
            <xsl:with-param name="number" select="Charge[@Id='707']/@Amount"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$number-format-707"/>
        <xsl:text> </xsl:text>
        <xsl:for-each select="Charge[@Id='707']/@CurrCode">
          <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
        </xsl:for-each>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

</xsl:stylesheet>