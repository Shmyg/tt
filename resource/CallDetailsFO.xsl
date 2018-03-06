<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    CallDetailsFO.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> XSL-FO stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms call-charge details.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/CallDetailsFO.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="xsl cur set">

  <xsl:variable name="start-date">
    <xsl:value-of select="document(/Bill/Part/@File)/Document/Invoice/Date[@Type='START']/@Date"/>
  </xsl:variable>

  <!--  sum udr tap (no bop, no bundle) -->
  <xsl:template name="print-sum-udr-tap">

    <xsl:param name="co-id"/>
    <xsl:param name="call-details"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>

    <xsl:variable name="call-details-local" select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call[XCD[@CO=$co-id]]" />
    
    <!-- using a exslt set template to eliminate the duplicated data ( avoids recursion ) -->
    <xsl:variable name="list-of-unique-services" select="set:distinct($call-details-local/XCD/@TapSeqNo)" />

    <xsl:if test="count($list-of-unique-services) !=0 ">

      <fo:block space-before="3mm" text-align="center" font-weight="bold" font-size="10pt">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','463')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </fo:block>

      <xsl:call-template name="group-by-tap">
        <xsl:with-param name="co-id"                   select="$co-id"/>
        <xsl:with-param name="call-details"            select="$call-details-local"/>
        <xsl:with-param name="list-of-unique-services" select="$list-of-unique-services"/>
        <xsl:with-param name="period-start"            select="$period-start"/>
        <xsl:with-param name="period-end"              select="$period-end"/>
      </xsl:call-template>

    </xsl:if>

  </xsl:template>

  <!-- group by TapSeqNo -->
  <xsl:template name="group-by-tap">

    <xsl:param name="co-id" select="''"/>
    <xsl:param name="call-details"/>
    <xsl:param name="list-of-unique-services"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>

    <xsl:for-each select="$list-of-unique-services">

      <xsl:sort select="." />
      <xsl:variable name="current-service">
        <xsl:value-of select="."/>
      </xsl:variable>

      <fo:block space-before="1mm">
        <fo:table width="160mm" table-layout="fixed">
          <fo:table-column column-width="20mm" column-number="1"/>
          <fo:table-column column-width="20mm" column-number="2"/>
          <fo:table-column column-width="20mm" column-number="3"/>
          <fo:table-column column-width="20mm" column-number="4"/>
          <fo:table-column column-width="20mm" column-number="5"/>
          <fo:table-column column-width="20mm" column-number="6"/>
          <fo:table-column column-width="20mm" column-number="7"/>
          <fo:table-column column-width="20mm" column-number="8"/>

          <fo:table-header space-after="1mm" font-size="7pt" font-weight="bold" text-align="center">

            <fo:table-row>
               <fo:table-cell number-columns-spanned="8" padding-after="5mm">
                <fo:block space-before="1mm" font-weight="bold" font-size="9pt" text-align="center">
                  <xsl:for-each select="$xcd">
                    <xsl:value-of select="key('xcd-index','TapSeqNo')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$current-service"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <xsl:for-each select="$xcd">
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <!-- date -->
                  <fo:block><xsl:value-of select="key('xcd-index','CRTs')[@xml:lang=$lang]/@Des"/></fo:block>
                </fo:table-cell>
              </xsl:for-each>
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <!-- udr type -->
                  <xsl:for-each select="$txt">
                    <fo:block><xsl:value-of select="key('txt-index','464')[@xml:lang=$lang]/@Des"/></fo:block>
                  </xsl:for-each>
                  <!-- service -->
                  <xsl:for-each select="$xcd">
                    <fo:block><xsl:value-of select="key('xcd-index','SN')[@xml:lang=$lang]/@Des"/></fo:block>
                  </xsl:for-each>
                </fo:table-cell>
              <xsl:for-each select="$xcd">
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <!-- rated volume -->
                  <fo:block><xsl:value-of select="key('xcd-index','DRV')[@xml:lang=$lang]/@Des"/></fo:block>
                  <!-- file name -->
                  <!--
                             <fo:block><xsl:value-of select="key('xcd-index','FileName')[@xml:lang=$lang]/@Des"/></fo:block>
                             -->
                </fo:table-cell>
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <!-- network indicator -->
                  <fo:block><xsl:value-of select="key('xcd-index','NI')[@xml:lang=$lang]/@Des"/></fo:block>
                  <!-- rerate type -->
                  <!--
                  <fo:block><xsl:value-of select="key('xcd-index','RRT')[@xml:lang=$lang]/@Des"/></fo:block>
                  -->
                </fo:table-cell>
                <!-- tariff time and tariff zone -->
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block><xsl:value-of select="key('xcd-index','TT')[@xml:lang=$lang]/@Des"/></fo:block>
                  <fo:block><xsl:value-of select="key('xcd-index','TZ')[@xml:lang=$lang]/@Des"/></fo:block>
                </fo:table-cell>
                <!-- tariff model and service package -->
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block><xsl:value-of select="key('xcd-index','TM')[@xml:lang=$lang]/@Des"/></fo:block>
                  <fo:block><xsl:value-of select="key('xcd-index','SP')[@xml:lang=$lang]/@Des"/></fo:block>
                </fo:table-cell>
                <!-- amounts -->
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block><xsl:value-of select="key('xcd-index','OAmt')[@xml:lang=$lang]/@Des"/></fo:block>
                  <fo:block><xsl:value-of select="key('xcd-index','DAmt')[@xml:lang=$lang]/@Des"/></fo:block>
                </fo:table-cell>
                <!-- external amount/tax -->
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block><xsl:value-of select="key('xcd-index','ExtAmt')[@xml:lang=$lang]/@Des"/></fo:block>
                  <fo:block><xsl:value-of select="key('xcd-index','ExtTax')[@xml:lang=$lang]/@Des"/></fo:block>
                </fo:table-cell>
              </xsl:for-each>
            </fo:table-row>
          </fo:table-header>
          <fo:table-body>
            <xsl:for-each select="$call-details/XCD[@TapSeqNo=$current-service and @CO=$co-id]">
              <xsl:sort select="@CTs"/>
              <xsl:apply-templates select="parent::Call"/>
            </xsl:for-each>
          </fo:table-body>
        </fo:table>
      </fo:block>
    </xsl:for-each>

  </xsl:template>

  <!--  sum udr rap (no bop, no bundle) -->
  <xsl:template name="print-sum-udr-rap">

    <xsl:param name="co-id"/>
    <xsl:param name="call-details"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>

    <xsl:variable name="call-details-local" select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call[XCD[@CO=$co-id]]" />
    
    <xsl:variable name="list-of-unique-services" select="set:distinct($call-details-local/XCD/@RapSeqNo)" />

    <xsl:if test="count($list-of-unique-services) !=0 ">

      <fo:block space-before="3mm" text-align="center" font-weight="bold" font-size="10pt">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','465')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </fo:block>

      <xsl:call-template name="group-by-rap">
        <xsl:with-param name="co-id"                   select="$co-id"/>
        <xsl:with-param name="call-details"            select="$call-details-local"/>
        <xsl:with-param name="list-of-unique-services" select="$list-of-unique-services"/>
        <xsl:with-param name="period-start"            select="$period-start"/>
        <xsl:with-param name="period-end"              select="$period-end"/>
      </xsl:call-template>

    </xsl:if>

  </xsl:template>

  <!-- group by RapSeqNo -->
  <xsl:template name="group-by-rap">

    <xsl:param name="co-id" select="''"/>
    <xsl:param name="call-details"/>
    <xsl:param name="list-of-unique-services"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>

    <xsl:for-each select="$list-of-unique-services">

      <xsl:sort select="." />
      <xsl:variable name="current-service">
        <xsl:value-of select="."/>
      </xsl:variable>

      <fo:block space-before="1mm">
        <fo:table width="160mm" table-layout="fixed">
          <fo:table-column column-width="20mm" column-number="1"/>
          <fo:table-column column-width="20mm" column-number="2"/>
          <fo:table-column column-width="20mm" column-number="3"/>
          <fo:table-column column-width="20mm" column-number="4"/>
          <fo:table-column column-width="20mm" column-number="5"/>
          <fo:table-column column-width="20mm" column-number="6"/>
          <fo:table-column column-width="20mm" column-number="7"/>
          <fo:table-column column-width="20mm" column-number="8"/>

          <fo:table-header space-after="1mm" font-size="7pt" font-weight="bold" text-align="center">

            <fo:table-row>
               <fo:table-cell number-columns-spanned="8" padding-after="5mm">
                <fo:block space-before="1mm" font-weight="bold" font-size="9pt" text-align="center">
                  <xsl:for-each select="$xcd">
                    <xsl:value-of select="key('xcd-index','RapSeqNo')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$current-service"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <xsl:for-each select="$xcd">
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <!-- date -->
                  <fo:block><xsl:value-of select="key('xcd-index','CRTs')[@xml:lang=$lang]/@Des"/></fo:block>
                </fo:table-cell>
              </xsl:for-each>
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <!-- udr type -->
                  <xsl:for-each select="$txt">
                    <fo:block><xsl:value-of select="key('txt-index','464')[@xml:lang=$lang]/@Des"/></fo:block>
                  </xsl:for-each>
                  <!-- service -->
                  <xsl:for-each select="$xcd">
                    <fo:block><xsl:value-of select="key('xcd-index','SN')[@xml:lang=$lang]/@Des"/></fo:block>
                  </xsl:for-each>
                </fo:table-cell>
              <xsl:for-each select="$xcd">
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <!-- rated volume -->
                  <fo:block><xsl:value-of select="key('xcd-index','DRV')[@xml:lang=$lang]/@Des"/></fo:block>
                  <!-- file name -->
                  <!--
                             <fo:block><xsl:value-of select="key('xcd-index','FileName')[@xml:lang=$lang]/@Des"/></fo:block>
                             -->
                </fo:table-cell>
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <!-- network indicator -->
                  <fo:block><xsl:value-of select="key('xcd-index','NI')[@xml:lang=$lang]/@Des"/></fo:block>
                  <!-- rerate type -->
                  <!--
                  <fo:block><xsl:value-of select="key('xcd-index','RRT')[@xml:lang=$lang]/@Des"/></fo:block>
                  -->
                </fo:table-cell>
                <!-- tariff time and tariff zone -->
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block><xsl:value-of select="key('xcd-index','TT')[@xml:lang=$lang]/@Des"/></fo:block>
                  <fo:block><xsl:value-of select="key('xcd-index','TZ')[@xml:lang=$lang]/@Des"/></fo:block>
                </fo:table-cell>
                <!-- tariff model and service package -->
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block><xsl:value-of select="key('xcd-index','TM')[@xml:lang=$lang]/@Des"/></fo:block>
                  <fo:block><xsl:value-of select="key('xcd-index','SP')[@xml:lang=$lang]/@Des"/></fo:block>
                </fo:table-cell>
                <!-- amounts -->
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block><xsl:value-of select="key('xcd-index','OAmt')[@xml:lang=$lang]/@Des"/></fo:block>
                  <fo:block><xsl:value-of select="key('xcd-index','DAmt')[@xml:lang=$lang]/@Des"/></fo:block>
                </fo:table-cell>
                <!-- external amount/tax -->
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block><xsl:value-of select="key('xcd-index','ExtAmt')[@xml:lang=$lang]/@Des"/></fo:block>
                  <fo:block><xsl:value-of select="key('xcd-index','ExtTax')[@xml:lang=$lang]/@Des"/></fo:block>
                </fo:table-cell>
              </xsl:for-each>
            </fo:table-row>
          </fo:table-header>
          <fo:table-body>
            <xsl:for-each select="$call-details/XCD[@RapSeqNo=$current-service and @CO=$co-id]">
              <xsl:sort select="@CTs"/>
              <xsl:apply-templates select="parent::Call"/>
            </xsl:for-each>
          </fo:table-body>
        </fo:table>
      </fo:block>
    </xsl:for-each>

  </xsl:template>

  <!-- call details -->
  <xsl:template name="print-call-details">

    <xsl:param name="co-id"/>
    <xsl:param name="bopind"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>
    <xsl:param name="call-details"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>
    
    <!-- get the not-bundled services for which there are calls with respective BOPSeqNo or non BOP related calls or late calls -->
    <xsl:variable name="call-details-local" select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call[XCD[@CO=$co-id and not(@TapSeqNo) and not(@RapSeqNo)
           and not(@BundPurInd) and not(@BundUsgInd) and (@BOPSeqNoRP=$bopseqno or @BOPSeqNoSP=$bopseqno
           or not(@BOPSeqNoRP or @BOPSeqNoSP) or (@CTs &lt; $start-date))]]"/>

    <xsl:variable name="list-of-unique-services" select="set:distinct($call-details-local/XCD/@SN)" />
    
    <xsl:if test="count($list-of-unique-services) !=0 ">

      <fo:block space-before="3mm" text-align="center" font-weight="bold" font-size="10pt">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','459')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </fo:block>

      <xsl:call-template name="group-by-services">
        <xsl:with-param name="co-id"                   select="$co-id"/>
        <xsl:with-param name="bopind"                  select="$bopind"/>
        <xsl:with-param name="bopseqno"                select="$bopseqno"/>
        <xsl:with-param name="boptype"                 select="$boptype"/>
        <xsl:with-param name="call-details"            select="$call-details-local"/>
        <xsl:with-param name="list-of-unique-services" select="$list-of-unique-services"/>
        <xsl:with-param name="period-start"            select="$period-start"/>
        <xsl:with-param name="period-end"              select="$period-end"/>
      </xsl:call-template>

    </xsl:if>

  </xsl:template>

  <!--  bundle purchase  -->
  <xsl:template name="print-call-details-bundle-purchase-price">

    <xsl:param name="co-id"/>
    <xsl:param name="service"/>
    <xsl:param name="sequence-no"/>
    <xsl:param name="call-details"/>
    <xsl:param name="bopind"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>

    <xsl:if test="$bopind='N'">
      <xsl:for-each select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call/XCD[@CO=$co-id and @SN=$service and @PurSeqNo=$sequence-no and @BundPurInd]">
        <xsl:call-template name="number-format">
          <xsl:with-param name="number" select="@DAmt"/>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:for-each select="@CC">
          <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="$bopind='Y'">
      <xsl:for-each select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call/XCD[@CO=$co-id and @SN=$service and @PurSeqNo=$sequence-no and @BundPurInd and (@BOPSeqNoRP=$bopseqno or @BOPSeqNoSP=$bopseqno)]">
        <xsl:call-template name="number-format">
          <xsl:with-param name="number" select="@DAmt"/>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:for-each select="@CC">
          <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:if>

  </xsl:template>

  <!--  bundle usage  -->
  <xsl:template name="print-call-details-bundle-usage">

    <xsl:param name="co-id"/>
    <xsl:param name="call-details"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>
    <xsl:param name="bopind" select="'N'"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>
    
    <xsl:variable name="call-details-local" select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call[XCD[@CO=$co-id and @BundUsgInd 
                        and ( ($bopind='Y' and ( $bopseqno=@BOPSeqNoRP or $bopseqno=@BOPSeqNoSP ) ) or $bopind='N' )]]" />
                        
    
    <xsl:variable name="list-of-unique-services" select="set:distinct($call-details-local/XCD/@SN)" />

    <xsl:if test="count($list-of-unique-services) != 0">

      <fo:block space-before="2mm" text-align="center" font-weight="bold" font-size="8pt">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','461')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </fo:block>

      <xsl:call-template name="group-by-services-bundle-usage">
        <xsl:with-param name="co-id" select="$co-id"/>
        <xsl:with-param name="bopind" select="$bopind"/>
        <xsl:with-param name="bopseqno" select="$bopseqno"/>
        <xsl:with-param name="boptype" select="$boptype"/>
        <xsl:with-param name="call-details" select="$call-details-local"/>
        <xsl:with-param name="list-of-unique-services" select="$list-of-unique-services"/>
        <xsl:with-param name="period-start" select="$period-start"/>
        <xsl:with-param name="period-end" select="$period-end"/>
      </xsl:call-template>

    </xsl:if>

  </xsl:template>

  <!-- call details (no contract specified) -->
  <xsl:template name="print-call-details-only">

    <xsl:param name="call-details"/>

    <xsl:variable name="call-details-local" select="$call-details/ContrCalls/ServCalls/Call" />
    
    <xsl:variable name="list-of-unique-services" select="set:distinct($call-details-local/XCD/@SN)" />

    <xsl:if test="count($list-of-unique-services) != 0">

      <fo:block break-before="page" space-after="5mm" text-align="center" font-weight="bold" font-size="12pt">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','395')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </fo:block>

      <xsl:call-template name="group-by-services">
        <xsl:with-param name="call-details" select="$call-details-local"/>
        <xsl:with-param name="list-of-unique-services" select="$list-of-unique-services"/>
      </xsl:call-template>

    </xsl:if>

  </xsl:template>

  <!-- not bundled call details grouped by services -->
  <xsl:template name="group-by-services">

    <xsl:param name="co-id" select="''"/>
    <xsl:param name="bopind"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>
    <xsl:param name="call-details"/>
    <xsl:param name="list-of-unique-services"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>

    <xsl:if test="$fmt='rtf'">
      <fo:block text-align="center" color="white" font-size="10pt">
        <xsl:text>-</xsl:text>
      </fo:block>
    </xsl:if>

    <xsl:for-each select="$list-of-unique-services">

      <xsl:sort select="." />
      <xsl:variable name="current-service">
        <xsl:value-of select="."/>
      </xsl:variable>

      <fo:block space-before="1mm">
        <fo:table width="160mm" table-layout="fixed">
          <fo:table-column column-width="18mm" column-number="1"/>
          <fo:table-column column-width="16mm" column-number="2"/>
          <fo:table-column column-width="17mm" column-number="3"/>
          <fo:table-column column-width="19mm" column-number="4"/>
          <fo:table-column column-width="17mm" column-number="5"/>
          <fo:table-column column-width="17mm" column-number="6"/>
          <fo:table-column column-width="19mm" column-number="7"/>
          <fo:table-column column-width="19mm" column-number="8"/>
          <fo:table-column column-width="18mm" column-number="9"/>

          <fo:table-header space-after="1mm" font-size="7pt" font-weight="bold" text-align="center">

            <fo:table-row>
               <fo:table-cell number-columns-spanned="9" padding-after="5mm">
                <!-- service title -->
                <fo:block space-before="1mm" font-weight="bold" font-size="9pt" text-align="center">
                  <xsl:call-template name="LgnMap">
                    <xsl:with-param name="Mode"  select="'0'"/>
                    <xsl:with-param name="Index" select="$current-service"/>
                    <xsl:with-param name="Type"  select="'SN'"/>
                    <xsl:with-param name="Desc"  select="'1'"/>
                  </xsl:call-template>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <xsl:for-each select="$xcd">
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <!-- date -->
                  <fo:block><xsl:value-of select="key('xcd-index','CTs')[@xml:lang=$lang]/@Des"/></fo:block>
                  <!-- prepaid indicator -->
                  <fo:block><xsl:value-of select="key('xcd-index','PrInd')[@xml:lang=$lang]/@Des"/></fo:block>
                </fo:table-cell>
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <!-- call type -->
                  <fo:block><xsl:value-of select="key('xcd-index','CT')[@xml:lang=$lang]/@Des"/></fo:block>
                  <fo:block>
                    <!-- rate type -->
                    <xsl:value-of select="key('xcd-index','RT')[@xml:lang=$lang]/@Des"/>
                    <xsl:text> / </xsl:text>
                    <!-- rerate type -->
                    <xsl:value-of select="key('xcd-index','RRT')[@xml:lang=$lang]/@Des"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <!-- rated volume -->
                  <fo:block><xsl:value-of select="key('xcd-index','DRV')[@xml:lang=$lang]/@Des"/></fo:block>                  
                  <fo:block>
                    <!-- bop sequence no. -->
                    <xsl:value-of select="key('xcd-index','BOPSeqNoRP')[@xml:lang=$lang]/@Des"/>
                    <xsl:text> / </xsl:text>
                    <!-- pricing alternative -->
                    <xsl:value-of select="key('xcd-index','TIDPA')[@xml:lang=$lang]/@Des"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <!-- record type -->
                  <fo:block><xsl:value-of select="key('xcd-index','NI')[@xml:lang=$lang]/@Des"/></fo:block>
                  <!-- network name -->
                  <fo:block><xsl:value-of select="key('xcd-index','NN')[@xml:lang=$lang]/@Des"/></fo:block>
                </fo:table-cell>
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <!-- destination type -->
                  <fo:block><xsl:value-of select="key('xcd-index','DES')[@xml:lang=$lang]/@Des"/></fo:block>
                  <!-- zone point -->
                  <fo:block><xsl:value-of select="key('xcd-index','DZP')[@xml:lang=$lang]/@Des"/></fo:block>
                </fo:table-cell>
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <!-- other party number -->
                  <fo:block><xsl:value-of select="key('xcd-index','OPN')[@xml:lang=$lang]/@Des"/></fo:block>
                  <!-- A party -->
                  <fo:block><xsl:value-of select="key('xcd-index','APN')[@xml:lang=$lang]/@Des"/></fo:block>
                </fo:table-cell>
                <!-- tarif time and tarif zone -->
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block><xsl:value-of select="key('xcd-index','TT')[@xml:lang=$lang]/@Des"/></fo:block>
                  <fo:block><xsl:value-of select="key('xcd-index','TZ')[@xml:lang=$lang]/@Des"/></fo:block>
                </fo:table-cell>
                <!-- tariff model and service package -->
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block><xsl:value-of select="key('xcd-index','TM')[@xml:lang=$lang]/@Des"/></fo:block>
                  <fo:block><xsl:value-of select="key('xcd-index','SP')[@xml:lang=$lang]/@Des"/></fo:block>
                </fo:table-cell>
                <!-- amounts -->
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block><xsl:value-of select="key('xcd-index','OAmt')[@xml:lang=$lang]/@Des"/></fo:block>
                  <fo:block><xsl:value-of select="key('xcd-index','DAmt')[@xml:lang=$lang]/@Des"/></fo:block>
                </fo:table-cell>
              </xsl:for-each>
            </fo:table-row>
          </fo:table-header>
          
          <!-- Filter out mark-up fee charge parts because we print them separately -->
          <xsl:variable name="call-details-local" select="$call-details/XCD[@ChType!='M']"/>
          
          <fo:table-body>

            <xsl:choose>
              <!-- contract available ? -->
              <xsl:when test="$co-id!=''">

                <xsl:choose>
                  <!-- if contract has no BOP -->
                  <xsl:when test="$bopind='N'">

                    <xsl:for-each select="$call-details-local[@SN=$current-service and @CO=$co-id
                     and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd)]">
                      <xsl:sort select="@CTs"/>
                      <xsl:sort select="@Id"/>
                      <xsl:sort select="@SubId"/>
                      <xsl:apply-templates select="parent::Call"/>
                    </xsl:for-each>

                  </xsl:when>
                  <!-- if contract has BOP -->
                  <xsl:otherwise>
                  
                    <!-- print late calls first -->
                    <xsl:for-each select="$call-details-local[@SN=$current-service and @CO=$co-id
                     and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd) and (@CTs &lt; $start-date) and not(@BOPAltInd)]">
                      <xsl:sort select="@CTs"/>
                      <xsl:sort select="@Id"/>
                      <xsl:sort select="@SubId"/>
                      <xsl:apply-templates select="parent::Call"/>
                    </xsl:for-each>
                    
                    <!-- print call details -->
                    <xsl:choose>
                    
                      <xsl:when test="$boptype='TM'">
                        <xsl:for-each select="$call-details-local[@SN=$current-service and @CO=$co-id
                         and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd) and (@CTs &gt;= $start-date) and (@BOPSeqNoRP=$bopseqno or not(@BOPSeqNoRP))]">
                          <xsl:sort select="@CTs"/>
                          <xsl:sort select="@Id"/>
                          <xsl:sort select="@SubId"/>
                          <xsl:apply-templates select="parent::Call"/>
                        </xsl:for-each>
                      </xsl:when>
                      
                      <xsl:when test="$boptype='SP'">
                        <xsl:for-each select="$call-details-local[@SN=$current-service and @CO=$co-id
                         and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd) and (@CTs &gt;= $start-date) and (@BOPSeqNoSP=$bopseqno or not(@BOPSeqNoSP))]">
                          <xsl:sort select="@CTs"/>
                          <xsl:sort select="@Id"/>
                          <xsl:sort select="@SubId"/>
                          <xsl:apply-templates select="parent::Call"/>
                        </xsl:for-each>
                      </xsl:when>
                      
                    </xsl:choose>
                    
                  </xsl:otherwise>
                  
                </xsl:choose>
              </xsl:when>
              
              <!-- no contracts (not CDS relevant) -->
              <xsl:otherwise>
                <!-- print call details  -->
                <xsl:for-each select="$call-details-local[@SN=$current-service
                 and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd)]">

                  <xsl:if test="position()='1' or @CO != preceding::XCD[1]/@CO">
                    <!-- print contract id header -->
                    <fo:table-row font-size="7pt" font-weight="bold">
                      <fo:table-cell number-columns-spanned="9" border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black"
                          padding-before="1mm">
                        <fo:block>
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','375')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                          <xsl:text>: </xsl:text>
                          <xsl:value-of select="@CO"/>
                        </fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                  </xsl:if>

                  <xsl:apply-templates select="parent::Call"/>

                </xsl:for-each>
              </xsl:otherwise>
              
            </xsl:choose>
            
          </fo:table-body>
        </fo:table>
      </fo:block>
      
      
        <!-- Print mark-up fees -->
        
        <xsl:choose>
          <!-- contract available ? -->
          <xsl:when test="$co-id!=''">
        
            <xsl:choose>
              <!-- if contract has no BOP -->
              <xsl:when test="$bopind='N'">
                
                <xsl:call-template name="print-markup-fees">
                    <xsl:with-param name="markup-fees" select="$call-details/XCD[@ChType='M' and @SN=$current-service and @CO=$co-id
                         and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd)]"/>
                </xsl:call-template>
        
              </xsl:when>
              
              <!-- if contract has BOP -->
              <xsl:otherwise>
              
                <!-- print late calls first -->

                <xsl:choose>
                
                  <xsl:when test="$boptype='TM'">
                  
                  
                    <xsl:call-template name="print-markup-fees">
                        <xsl:with-param name="markup-fees" select="$call-details/XCD[@ChType='M' and 
                        (
                            ( @SN=$current-service and @CO=$co-id and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd) 
                                and (@CTs &lt; $start-date) and not(@BOPAltInd) ) 
                            or 
                            ( @SN=$current-service and @CO=$co-id and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd) 
                                and (@CTs &gt;= $start-date) and (@BOPSeqNoRP=$bopseqno or not(@BOPSeqNoRP)) )
                        )]"/>
                    </xsl:call-template>
                    
                    
                  </xsl:when>
                  
                  <xsl:when test="$boptype='SP'">
                  
                  
                    <xsl:call-template name="print-markup-fees">
                        <xsl:with-param name="markup-fees" select="$call-details/XCD[@ChType='M' and 
                        (
                            ( @SN=$current-service and @CO=$co-id and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd) 
                                and (@CTs &lt; $start-date) and not(@BOPAltInd) ) 
                            or 
                            ( @SN=$current-service and @CO=$co-id and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd)
                                and (@CTs &gt;= $start-date) and (@BOPSeqNoSP=$bopseqno or not(@BOPSeqNoSP)) )
                        )]"/>
                    </xsl:call-template>
                  
                  </xsl:when>
                  
                </xsl:choose>
                
              </xsl:otherwise>
              
            </xsl:choose>
          </xsl:when>
          
          <!-- no contracts (not CDS relevant) -->
          <xsl:otherwise>
          
                <!-- print call details  -->
                
                <xsl:call-template name="print-markup-fees">
                    <xsl:with-param name="markup-fees" select="$call-details/XCD[@ChType='M' and @SN=$current-service
                         and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd) ]"/>
                    <xsl:with-param name="print-contract-id-header" select="'1'"/>
                </xsl:call-template>
                
          </xsl:otherwise>
          
        </xsl:choose>
    
    
    
    </xsl:for-each>

  </xsl:template>
  
  
  <!-- Print mark-up fees (to be called per service)
       Param markup-fees: list of XCD elements with ChType='M' -->
  <xsl:template name="print-markup-fees">
    
    <xsl:param name="markup-fees"/>
    <xsl:param name="print-contract-id-header"/>
    
    <xsl:if test="$markup-fees">
    
      <fo:block space-before="1mm">
        

        <fo:table width="160mm" table-layout="fixed">
          <fo:table-column column-width="30mm" column-number="1"/>
          <fo:table-column column-width="20mm" column-number="2"/>
          <fo:table-column column-width="45mm" column-number="3"/>
          <fo:table-column column-width="45mm" column-number="4"/>
          <fo:table-column column-width="20mm" column-number="5"/>
              
              
          <fo:table-header space-after="1mm" font-size="8pt" font-weight="bold" text-align="center">
            
            <fo:table-row>
               <fo:table-cell number-columns-spanned="5" padding-after="1mm">
                <fo:block space-before="1mm" font-weight="bold" font-size="9pt" text-align="center">
                    <!-- Mark-up fees -->
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','549')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            
            
            <fo:table-row>
            
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <!-- date -->
                  <fo:block>
                    <xsl:for-each select="$xcd">
                      <xsl:value-of select="key('xcd-index','CTs')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
                
              <xsl:for-each select="$fup">
                
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <!-- Account -->
                  <fo:block>
                    <xsl:value-of select="key('fup-index','FUAccId')[@xml:lang=$lang]/@Des"/>
                  </fo:block>
                </fo:table-cell>
                
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <!-- Package/element/version -->
                  <fo:block>
                    <xsl:value-of select="key('fup-index','FUP')[@xml:lang=$lang]/@Des"/>
                    <xsl:text> / </xsl:text>
                    <xsl:value-of select="key('fup-index','FUE')[@xml:lang=$lang]/@Des"/>
                    <xsl:text> / </xsl:text>
                    <xsl:value-of select="key('fup-index','FUEV')[@xml:lang=$lang]/@Des"/>
                  </fo:block>
                </fo:table-cell>
                
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <!-- Charge plan -->
                  <fo:block>
                    <xsl:value-of select="key('fup-index','ChPlan')[@xml:lang=$lang]/@Des"/>
                  </fo:block>
                </fo:table-cell>
                
              </xsl:for-each>
                
                <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                  <!-- Amount -->
                  <fo:block>
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','50')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
                
            </fo:table-row>
            
          </fo:table-header>
          
          <fo:table-body>
            
            
            <xsl:choose>
                <xsl:when test="$print-contract-id-header">
                    <!-- Print contract id header, don't change sorting -->
                    
                    <xsl:for-each select="$markup-fees">
                        
                        <xsl:if test="position()='1' or @CO != preceding::XCD[1]/@CO">
                            <!-- print contract id header -->
                            <fo:table-row font-size="8pt" font-weight="bold">
                              <fo:table-cell number-columns-spanned="5" border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black"
                                  padding-before="1mm">
                                <fo:block>
                                  <xsl:for-each select="$txt"><!-- Contract -->
                                    <xsl:value-of select="key('txt-index','375')[@xml:lang=$lang]/@Des"/>
                                  </xsl:for-each>
                                  <xsl:text>: </xsl:text>
                                  <xsl:value-of select="@CO"/>
                                </fo:block>
                              </fo:table-cell>
                            </fo:table-row>
                        </xsl:if>
                        
                        <xsl:call-template name="print-markup-fee">
                          <xsl:with-param name="markup-fee" select="."/>
                        </xsl:call-template>
                        
                    </xsl:for-each>
                    
                    
                </xsl:when>
                
                <xsl:otherwise>
                    <!-- Default: sort records -->
                    
                    <xsl:for-each select="$markup-fees">
                        <xsl:sort select="@CTs"/>
                        <xsl:sort select="@Id"/>
                        <xsl:sort select="@SubId"/>
                                  
                        <xsl:call-template name="print-markup-fee">
                          <xsl:with-param name="markup-fee" select="."/>
                        </xsl:call-template>
                        
                    </xsl:for-each>
                    
                    
                </xsl:otherwise>
            </xsl:choose>
            
            
            
            
        </fo:table-body>
          
        </fo:table>
        
        
      </fo:block>
    
    </xsl:if>
       
  </xsl:template>
    
  <!-- Prints a single mark-up fee -->
  <xsl:template name="print-markup-fee">
  
    <xsl:param name="markup-fee"/>
    
    <xsl:variable name="fu-part" select="$markup-fee/following-sibling::FUP"/>
    
    <fo:table-row font-size="6.5pt">
    
        <fo:table-cell>
            <fo:block text-align="center">
              <!-- timestamp -->
              <xsl:call-template name="date-time-format">
                <xsl:with-param name="date" select="$markup-fee/@CTs"/>
              </xsl:call-template>
            </fo:block>
        </fo:table-cell>
        
        <fo:table-cell text-align="center">
            <fo:block>
                <!-- free unit account id -->
                <xsl:value-of select="$fu-part/@FUAccId"/>          
                <xsl:text> / </xsl:text>
                <!-- free unit account history id -->
                <xsl:value-of select="$fu-part/@FUAccHistId"/>
            </fo:block>
        </fo:table-cell>
        
        <fo:table-cell text-align="center">
            <fo:block>
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="$fu-part/@FUP"/>
                  <xsl:with-param name="Type"  select="'FUP'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
                <!-- free unit element -->
                <xsl:if test="$fu-part/@FUE">
                  <xsl:text> / </xsl:text>
                  <xsl:value-of select="$fu-part/@FUE"/>
                </xsl:if>
                <!-- free unit version -->
                <xsl:if test="$fu-part/@FUEV">
                  <xsl:text> / </xsl:text>
                  <xsl:value-of select="$fu-part/@FUEV"/>
                </xsl:if>
            </fo:block>
        </fo:table-cell>
        
        <fo:table-cell text-align="center">
            <fo:block>
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="$fu-part/@ChPlan"/>
                  <xsl:with-param name="Type"  select="'CPD'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
            </fo:block>
        </fo:table-cell>
        
        <fo:table-cell text-align="right" padding-right="1mm">
            <fo:block>
                <!-- discounted amount -->
                <xsl:if test="$markup-fee/@DAmt">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="$markup-fee/@DAmt"/>
                  </xsl:call-template>
                  <xsl:text> </xsl:text>
                  <xsl:for-each select="$markup-fee/@CC">
                    <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                  </xsl:for-each>
                </xsl:if>
            </fo:block>
        </fo:table-cell>
        
    </fo:table-row>
    
  </xsl:template>
  

  <!-- bundle usage grouped by service (not TAP/RAP relevant) -->
  <xsl:template name="group-by-services-bundle-usage">

    <xsl:param name="co-id" select="''"/>
    <xsl:param name="bopind" select="'N'"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>
    <xsl:param name="call-details"/>
    <xsl:param name="list-of-unique-services"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>

    <xsl:for-each select="$list-of-unique-services">

      <xsl:sort select="." />
      <xsl:variable name="current-service">
        <xsl:value-of select="."/>
      </xsl:variable>

      <fo:block space-before="1mm">
        <fo:table width="160mm" table-layout="fixed">
          <fo:table-column column-width="40mm" column-number="1"/>
          <fo:table-column column-width="40mm" column-number="2"/>
          <fo:table-column column-width="40mm" column-number="3"/>
          <fo:table-column column-width="40mm" column-number="4"/>
          <fo:table-header space-after="1mm" font-size="7pt" font-weight="bold" text-align="center">

            <fo:table-row>
               <fo:table-cell number-columns-spanned="4" padding-after="1mm">
                <!-- service title -->
                <fo:block space-before="1mm" font-weight="bold" font-size="7pt" text-align="center">
                  <xsl:call-template name="LgnMap">
                    <xsl:with-param name="Mode"  select="'0'"/>
                    <xsl:with-param name="Index" select="$current-service"/>
                    <xsl:with-param name="Type"  select="'SN'"/>
                    <xsl:with-param name="Desc"  select="'1'"/>
                  </xsl:call-template>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <!-- date / time -->
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <xsl:for-each select="$xcd">
                  <fo:block><xsl:value-of select="key('xcd-index','CTs')[@xml:lang=$lang]/@Des"/></fo:block>
                </xsl:for-each>
              </fo:table-cell>
              <!-- bundle name -->
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <xsl:for-each select="$txt">
                  <fo:block><xsl:value-of select="key('txt-index','455')[@xml:lang=$lang]/@Des"/></fo:block>
                </xsl:for-each>
              </fo:table-cell>
              <!-- bundle product -->
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <xsl:for-each select="$fup">
                  <fo:block><xsl:value-of select="key('fup-index','BPROD')[@xml:lang=$lang]/@Des"/></fo:block>
                </xsl:for-each>
              </fo:table-cell>
              <!-- quantity -->
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <xsl:for-each select="$xcd">
                  <fo:block><xsl:value-of select="key('xcd-index','ORV')[@xml:lang=$lang]/@Des"/></fo:block>
                </xsl:for-each>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-header>
          <fo:table-body>
            <xsl:choose>
              <!-- contract available ? -->
              <xsl:when test="$co-id!=''">

                <xsl:choose>
                  <!-- if contract has no BOP -->
                  <xsl:when test="$bopind='N'">

                    <xsl:for-each select="$call-details/XCD[@SN=$current-service and @CO=$co-id and @BundUsgInd]">
                      <xsl:sort select="@CTs"/>
                      <xsl:sort select="@Id"/>
                      <xsl:sort select="@SubId"/>
                      <xsl:apply-templates select="parent::Call"/>
                    </xsl:for-each>

                  </xsl:when>
                  <!-- if contract has BOP -->
                  <xsl:otherwise>
                    <!-- print late calls first -->
                    <xsl:for-each select="$call-details/XCD[@SN=$current-service and @CO=$co-id and @BundUsgInd and (@CTs &lt; $start-date) and not(@BOPAltInd)]">
                      <xsl:sort select="@CTs"/>
                      <xsl:sort select="@Id"/>
                      <xsl:sort select="@SubId"/>
                      <xsl:apply-templates select="parent::Call"/>
                    </xsl:for-each>
                    <!-- print call details -->
                    <xsl:choose>
                      <xsl:when test="$boptype='TM'">
                        <xsl:for-each select="$call-details/XCD[@SN=$current-service and @CO=$co-id and @BundUsgInd and (@CTs &gt;= $start-date) and (@BOPSeqNoRP=$bopseqno or not(@BOPSeqNoRP))]">
                          <xsl:sort select="@CTs"/>
                          <xsl:sort select="@Id"/>
                          <xsl:sort select="@SubId"/>
                          <xsl:apply-templates select="parent::Call"/>
                        </xsl:for-each>
                      </xsl:when>
                      <xsl:when test="$boptype='SP'">
                        <xsl:for-each select="$call-details/XCD[@SN=$current-service and @CO=$co-id and @BundUsgInd and (@CTs &gt;= $start-date) and (@BOPSeqNoSP=$bopseqno or not(@BOPSeqNoSP))]">
                          <xsl:sort select="@CTs"/>
                          <xsl:sort select="@Id"/>
                          <xsl:sort select="@SubId"/>
                          <xsl:apply-templates select="parent::Call"/>
                        </xsl:for-each>
                      </xsl:when>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <!-- no contracts (not CDS relevant) -->
              <xsl:otherwise>
                <!-- print call details  -->
                <xsl:for-each select="$call-details/XCD[@SN=$current-service and @BundUsgInd]">

                  <xsl:if test="position()='1' or @CO != preceding::XCD[1]/@CO">
                    <!-- print contract id header -->
                    <fo:table-row font-size="7pt" font-weight="bold">
                      <fo:table-cell number-columns-spanned="9" border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black"
                          padding-before="1mm">
                        <fo:block>
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','375')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                          <xsl:text>: </xsl:text>
                          <xsl:value-of select="@CO"/>
                        </fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                  </xsl:if>

                  <xsl:apply-templates select="parent::Call"/>

                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </fo:table-body>
        </fo:table>
      </fo:block>
    </xsl:for-each>

  </xsl:template>

  <!-- helper template to remove duplicate strings -->
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

  <!--  call details large volume -->
  <xsl:template name="print-call-details-large-volume">

    <xsl:param name="co-id"/>
    <xsl:param name="bopind"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>
    <xsl:param name="call-details"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>

    <fo:block space-before="3mm" text-align="center" font-weight="bold" font-size="10pt">
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','260')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
    </fo:block>

    <fo:block space-before="1mm">
      <fo:table width="160mm" table-layout="fixed">
        <fo:table-column column-width="18mm" column-number="1"/>
        <fo:table-column column-width="16mm" column-number="2"/>
        <fo:table-column column-width="17mm" column-number="3"/>
        <fo:table-column column-width="19mm" column-number="4"/>
        <fo:table-column column-width="17mm" column-number="5"/>
        <fo:table-column column-width="17mm" column-number="6"/>
        <fo:table-column column-width="19mm" column-number="7"/>
        <fo:table-column column-width="19mm" column-number="8"/>
        <fo:table-column column-width="18mm" column-number="9"/>

        <fo:table-header space-after="1mm" font-size="7pt" font-weight="bold" text-align="center">

          <fo:table-row>
            <xsl:for-each select="$xcd">
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <!-- date -->
                <fo:block><xsl:value-of select="key('xcd-index','CTs')[@xml:lang=$lang]/@Des"/></fo:block>
                <!-- prepaid indicator -->
                <fo:block><xsl:value-of select="key('xcd-index','PrInd')[@xml:lang=$lang]/@Des"/></fo:block>
              </fo:table-cell>
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <!-- call type -->
                <fo:block><xsl:value-of select="key('xcd-index','CT')[@xml:lang=$lang]/@Des"/></fo:block>                
                <fo:block>
                  <!-- rate type -->
                  <xsl:value-of select="key('xcd-index','RT')[@xml:lang=$lang]/@Des"/>
                  <xsl:text> / </xsl:text>
                  <!-- rerate type -->
                  <xsl:value-of select="key('xcd-index','RRT')[@xml:lang=$lang]/@Des"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <!-- rated volume -->
                <fo:block><xsl:value-of select="key('xcd-index','DRV')[@xml:lang=$lang]/@Des"/></fo:block>
                <!-- bop sequence no. -->
                <fo:block><xsl:value-of select="key('xcd-index','BOPSeqNoRP')[@xml:lang=$lang]/@Des"/></fo:block>
              </fo:table-cell>
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <!-- record type -->
                <fo:block><xsl:value-of select="key('xcd-index','NI')[@xml:lang=$lang]/@Des"/></fo:block>
                <!-- network name -->
                <fo:block><xsl:value-of select="key('xcd-index','NN')[@xml:lang=$lang]/@Des"/></fo:block>
              </fo:table-cell>
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <!-- destination type -->
                <fo:block><xsl:value-of select="key('xcd-index','DES')[@xml:lang=$lang]/@Des"/></fo:block>
                <!-- zone point -->
                <fo:block><xsl:value-of select="key('xcd-index','DZP')[@xml:lang=$lang]/@Des"/></fo:block>
              </fo:table-cell>
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <!-- other party number -->
                <fo:block><xsl:value-of select="key('xcd-index','OPN')[@xml:lang=$lang]/@Des"/></fo:block>
                <!-- A party -->
                <fo:block><xsl:value-of select="key('xcd-index','APN')[@xml:lang=$lang]/@Des"/></fo:block>
              </fo:table-cell>
              <!-- tarif time and tarif zone -->
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <fo:block><xsl:value-of select="key('xcd-index','TT')[@xml:lang=$lang]/@Des"/></fo:block>
                <fo:block><xsl:value-of select="key('xcd-index','TZ')[@xml:lang=$lang]/@Des"/></fo:block>
              </fo:table-cell>
              <!-- tariff model and service package -->
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <fo:block><xsl:value-of select="key('xcd-index','TM')[@xml:lang=$lang]/@Des"/></fo:block>
                <fo:block><xsl:value-of select="key('xcd-index','SP')[@xml:lang=$lang]/@Des"/></fo:block>
              </fo:table-cell>
              <!-- amounts -->
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <fo:block><xsl:value-of select="key('xcd-index','OAmt')[@xml:lang=$lang]/@Des"/></fo:block>
                <fo:block><xsl:value-of select="key('xcd-index','DAmt')[@xml:lang=$lang]/@Des"/></fo:block>
              </fo:table-cell>
            </xsl:for-each>
          </fo:table-row>
        </fo:table-header>
        <fo:table-body>
          <xsl:choose>
            <!-- contract available ? -->
            <xsl:when test="$co-id!=''">
               <xsl:choose>
                <!-- if contract has no BOP -->
                <xsl:when test="$bopind='N'">
                   <xsl:for-each select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call/XCD[@CO=$co-id]">
                     <xsl:apply-templates select="parent::Call"/>
                   </xsl:for-each>
                </xsl:when>
                <!-- if contract has BOP -->
               <xsl:otherwise>
                  <!-- print late calls first -->
                  <xsl:for-each select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call/XCD[@CO=$co-id and (@CTs &lt; $start-date) and not(@BOPAltInd)]">
                    <xsl:apply-templates select="parent::Call"/>
                  </xsl:for-each>
                  <!-- print call details -->
                  <xsl:choose>
                    <xsl:when test="$boptype='TM'">
                      <xsl:for-each select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call/XCD[@CO=$co-id and (@CTs &gt;= $start-date) and (@BOPSeqNoRP=$bopseqno or not(@BOPSeqNoRP))]">
                        <xsl:apply-templates select="parent::Call"/>
                      </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="$boptype='SP'">
                      <xsl:for-each select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call/XCD[@CO=$co-id and (@CTs &gt;= $start-date) and (@BOPSeqNoSP=$bopseqno or not(@BOPSeqNoSP))]">
                        <xsl:apply-templates select="parent::Call"/>
                      </xsl:for-each>
                    </xsl:when>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <!-- no contracts (not CDS relevant) -->
            <xsl:otherwise>
              <!-- print call details  -->
              <xsl:for-each select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call/XCD">
                <xsl:if test="position()='1' or @CO != preceding::XCD[1]/@CO">
                  <!-- print contract id header -->
                  <fo:table-row font-size="7pt" font-weight="bold">
                    <fo:table-cell number-columns-spanned="9" border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black"
                        padding-before="1mm">
                      <fo:block>
                        <xsl:for-each select="$txt">
                          <xsl:value-of select="key('txt-index','375')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="@CO"/>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>
                <xsl:apply-templates select="parent::Call"/>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </fo:table-body>
      </fo:table>
    </fo:block>

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
    <!-- This template is used both for pre-grouped charge details (charge details of an invoice) and ungrouped charge details
    (of a charge notification) . -->
    
    <xsl:choose>
        <xsl:when test="$charge-details/ContrCalls">
        
            <!-- pregrouped -->
            <xsl:variable name="list-of-services">
              <xsl:for-each select="$charge-details/ContrCalls[@Id=$co-id]/ServCalls/ChDet/XCD[@SrvChType=$charge-type and @CO=$co-id]/@SN">
                <xsl:sort select="."/>
                  <xsl:value-of select="."/>
                  <xsl:text> </xsl:text>
              </xsl:for-each>
            </xsl:variable>
            
            <xsl:variable name="list-of-unique-services">
              <xsl:call-template name="remove-duplicates">
                <xsl:with-param name="list-of-services" select="$list-of-services"/>
                <xsl:with-param name="last-service" select="'$charge-type'"/>
              </xsl:call-template>
            </xsl:variable>
                    
            <xsl:if test="normalize-space($list-of-unique-services)!=''">
        
              <fo:block keep-together="always">
                <!-- recurring charges -->
                <fo:block space-before="4mm" font-weight="bold" font-size="10pt" text-align="center">
                  <xsl:if test="$charge-type='A'">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','482')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </xsl:if>
                </fo:block>
                <!-- one-time charges -->
                <fo:block font-weight="bold" font-size="10pt" text-align="center">
                  <xsl:if test="$charge-type='S'">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','483')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </xsl:if>
                </fo:block>
                <fo:block space-before="3mm">
                
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
                
                </fo:block>
              </fo:block>
                
            </xsl:if>
            
        </xsl:when>
        <xsl:when test="$charge-details/ChDet">
        
            <!-- ungrouped -->
            <xsl:variable name="list-of-services">
              <xsl:for-each select="$charge-details/ChDet/XCD[@SrvChType=$charge-type and @CO=$co-id]/@SN">
                <xsl:sort select="."/>
                  <xsl:value-of select="."/>
                  <xsl:text> </xsl:text>
              </xsl:for-each>
            </xsl:variable>
            
            <xsl:variable name="list-of-unique-services">
              <xsl:call-template name="remove-duplicates">
                <xsl:with-param name="list-of-services" select="$list-of-services"/>
                <xsl:with-param name="last-service" select="'$charge-type'"/>
              </xsl:call-template>
            </xsl:variable>
            
            <xsl:if test="normalize-space($list-of-unique-services)!=''">
        
              <fo:block keep-together="always">
                <!-- recurring charges -->
                <fo:block space-before="4mm" font-weight="bold" font-size="10pt" text-align="center">
                  <xsl:if test="$charge-type='A'">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','482')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </xsl:if>
                </fo:block>
                <!-- one-time charges -->
                <fo:block font-weight="bold" font-size="10pt" text-align="center">
                  <xsl:if test="$charge-type='S'">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','483')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </xsl:if>
                </fo:block>
                <fo:block space-before="3mm">
                
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
                
                </fo:block>
              </fo:block>
                
            </xsl:if>
            
        </xsl:when>
        <xsl:otherwise/>
    </xsl:choose>

  </xsl:template>

  <!-- charge details group by service -->
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

      <fo:block space-before="1mm">
        <fo:table width="160mm" table-layout="fixed">

          <fo:table-column column-width="30mm" column-number="1"/>
          <fo:table-column column-width="30mm" column-number="2"/>
          <fo:table-column column-width="15mm" column-number="3"/>
          <fo:table-column column-width="20mm" column-number="4"/>          
          <fo:table-column column-width="30mm" column-number="5"/>
          <fo:table-column column-width="15mm" column-number="6"/>
          <fo:table-column column-width="20mm" column-number="7"/>
          
          <fo:table-header space-after="1mm" font-size="7pt" font-weight="bold" text-align="center">

            <fo:table-row>
              <fo:table-cell number-columns-spanned="7" padding-after="1mm">
                <!-- service -->
                <fo:block space-before="1mm" font-weight="bold" font-size="7pt" text-align="center">
                  <xsl:call-template name="LgnMap">
                    <xsl:with-param name="Mode"  select="'0'"/>
                    <xsl:with-param name="Index" select="$next-service"/>
                    <xsl:with-param name="Type"  select="'SN'"/>
                    <xsl:with-param name="Desc"  select="'1'"/>
                  </xsl:call-template>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <!-- date -->
                <fo:block>
                  <xsl:for-each select="$xcd">
                    <xsl:value-of select="key('xcd-index','CTs')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
                <!-- prepaid indicator -->
                <fo:block>
                  <xsl:for-each select="$xcd">
                    <xsl:value-of select="key('xcd-index','PrInd')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <!-- tariff model -->
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <fo:block>
                  <xsl:for-each select="$xcd">
                    <xsl:value-of select="key('xcd-index','TM')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
                <!-- service package -->
                <fo:block>
                  <xsl:for-each select="$xcd">                
                    <xsl:value-of select="key('xcd-index','SP')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>                    
                </fo:block>
              </fo:table-cell>              
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <!-- quantity -->
                <fo:block>
                  <xsl:for-each select="$xcd">
                    <xsl:value-of select="key('xcd-index','Numit')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>                    
                </fo:block>
                <!-- active days -->
                <fo:block>
                  <xsl:for-each select="$xcd">
                    <xsl:value-of select="key('xcd-index','NumDays')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <!-- service charge subtype -->
                <fo:block>
                  <xsl:for-each select="$xcd">
                    <xsl:value-of select="key('xcd-index','SrvChSType')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>                    
                </fo:block>
              </fo:table-cell>              
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <!-- period, status info -->
                <fo:block>
                  <xsl:for-each select="$xcd">
                    <xsl:value-of select="key('xcd-index','ChrgStartTime')[@xml:lang=$lang]/@Des"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="key('xcd-index','SrvSt')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
                <!-- market -->
                <fo:block>
                  <xsl:for-each select="$xcd">
                    <xsl:value-of select="key('xcd-index','MKT')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <!-- price -->
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <fo:block>
                  <xsl:for-each select="$xcd">
                    <xsl:value-of select="key('xcd-index','Price')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
                <!-- profile -->
                <fo:block>
                  <xsl:for-each select="$xcd">
                    <xsl:value-of select="key('xcd-index','PRO')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <!-- amount -->
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <fo:block>
                  <xsl:for-each select="$xcd">                
                    <xsl:value-of select="key('xcd-index','OAmt')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>                    
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-header>
          <fo:table-body>
          
          <xsl:choose>
            <xsl:when test="$charge-details/ContrCalls">
                <!-- Pregrouped charge details -->
                
                <xsl:for-each select="$charge-details/ContrCalls[@Id=$co-id]/ServCalls/ChDet/XCD[@SN=$next-service and @SrvChType=$charge-type and @CO=$co-id]">
                  <xsl:call-template name="ChDet">
                    <xsl:with-param name="node" select="parent::ChDet"/>
                    <xsl:with-param name="charge-type" select="$charge-type"/>
                  </xsl:call-template>
                </xsl:for-each>
                
            </xsl:when>
            
            <xsl:when test="$charge-details/ChDet">
                <!-- Pregrouped charge details -->
            
                <xsl:for-each select="$charge-details/ChDet/XCD[@SN=$next-service and @SrvChType=$charge-type and @CO=$co-id]">
                  <xsl:call-template name="ChDet">
                    <xsl:with-param name="node" select="parent::ChDet"/>
                    <xsl:with-param name="charge-type" select="$charge-type"/>
                  </xsl:call-template>
                </xsl:for-each>
            
            </xsl:when>
            
            <xsl:otherwise/>
            
          </xsl:choose>
          

          </fo:table-body>
        </fo:table>
      </fo:block>

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
    
    <xsl:call-template name="charge-details">
      <xsl:with-param name="node" select="$node/XCD"/>
      <xsl:with-param name="charge-type" select="$charge-type"/>
    </xsl:call-template>

    <xsl:if test="$node/FUP[(not(FUP/@FUPrepayInd) or (FUP/@FUPrepayInd != 1))]">
      <fo:table-row font-size="7pt" font-weight="bold" text-align="center">

          <xsl:for-each select="$fup">
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <!-- cost control service -->
            <fo:table-cell number-columns-spanned="2" background-color="gainsboro" text-align="center">
              <fo:block>
                <xsl:value-of select="key('fup-index','SN')[@xml:lang=$lang]/@Des"/>
              </fo:block>
            </fo:table-cell>
            <!-- profile -->
            <fo:table-cell number-columns-spanned="2" background-color="gainsboro" text-align="center">
              <fo:block>
                <xsl:value-of select="key('fup-index','Profile')[@xml:lang=$lang]/@Des"/>
              </fo:block>
            </fo:table-cell>
            <!-- discount amount -->
            <fo:table-cell number-columns-spanned="2" background-color="gainsboro" text-align="center">
              <fo:block>
                <xsl:value-of select="key('fup-index','Amt')[@xml:lang=$lang]/@Des"/>
              </fo:block>
            </fo:table-cell>
          </xsl:for-each>
      </fo:table-row>
      <xsl:for-each select="$node/FUP[(not(FUP/@FUPrepayInd) or (FUP/@FUPrepayInd != 1))]">
        <fo:table-row font-size="6.5pt" background-color="gainsboro">

          <xsl:if test="position()='1'">
            <fo:table-cell font-size="7pt" font-weight="bold">
              <xsl:attribute name="number-rows-spanned">
                <xsl:value-of select="count($node/FUP[(not(FUP/@FUPrepayInd) or (FUP/@FUPrepayInd != 1))])"/>
              </xsl:attribute>
              <fo:block text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','280')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
          </xsl:if>
          <xsl:apply-templates select="." mode="charge-details"/>
        </fo:table-row>
      </xsl:for-each>
    </xsl:if>

  </xsl:template>

  <!-- call -->
  <xsl:template match="Call">

    <fo:table-row font-size="6.5pt">
      <xsl:apply-templates select="XCD"/>
    </fo:table-row>

    <xsl:if test="FUP and not(FUP/@BPROD) and (not(FUP/@FUPrepayInd) or (FUP/@FUPrepayInd != 1))">

      <xsl:if test="not(XCD/@TapSeqNo or XCD/@RapSeqNo)">

        <fo:table-row font-size="7pt" font-weight="bold" text-align="center">

          <xsl:for-each select="$fup">
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <!-- cost control contract id -->
            <fo:table-cell background-color="gainsboro">
              <fo:block>
                <xsl:value-of select="key('fup-index','CoId')[@xml:lang=$lang]/@Des"/>
              </fo:block>
            </fo:table-cell>
            <!-- free unit account id / history id -->
            <fo:table-cell background-color="gainsboro">
              <fo:block>
                <xsl:value-of select="key('fup-index','FUAccId')[@xml:lang=$lang]/@Des"/>
              </fo:block>
            </fo:table-cell>
            <!-- free unit part type -->
            <fo:table-cell background-color="gainsboro">
              <fo:block>
                <xsl:value-of select="key('fup-index','FUOption')[@xml:lang=$lang]/@Des"/>
              </fo:block>
            </fo:table-cell>            
            <!-- free unit package / element / version -->
            <fo:table-cell background-color="gainsboro" number-columns-spanned="2">
              <fo:block>
                <xsl:value-of select="key('fup-index','FUP')[@xml:lang=$lang]/@Des"/>
                <xsl:text> / </xsl:text>
                <xsl:value-of select="key('fup-index','FUE')[@xml:lang=$lang]/@Des"/>
                <xsl:text> / </xsl:text>
                <xsl:value-of select="key('fup-index','FUEV')[@xml:lang=$lang]/@Des"/>
              </fo:block>
            </fo:table-cell>
            <!-- charge plan -->
            <fo:table-cell background-color="gainsboro">
              <fo:block>
                <xsl:value-of select="key('fup-index','ChPlan')[@xml:lang=$lang]/@Des"/>
              </fo:block>
            </fo:table-cell>  
            <!-- cost control service -->
            <fo:table-cell background-color="gainsboro">
              <fo:block>
                <xsl:value-of select="key('fup-index','SN')[@xml:lang=$lang]/@Des"/>
              </fo:block>
            </fo:table-cell>
            <!-- discount amount -->
            <fo:table-cell background-color="gainsboro">
              <fo:block>
                <xsl:value-of select="key('fup-index','Amt')[@xml:lang=$lang]/@Des"/>
              </fo:block>
            </fo:table-cell>
          </xsl:for-each>
        </fo:table-row>
        
        <xsl:for-each select="FUP[(not(FUP/@FUPrepayInd) or (FUP/@FUPrepayInd != 1))]">
          <fo:table-row font-size="6.5pt" background-color="gainsboro">
            <xsl:if test="position()='1'">
              <fo:table-cell font-size="7pt" font-weight="bold">
                <xsl:attribute name="number-rows-spanned">
                  <xsl:value-of select="count(../FUP[(not(FUP/@FUPrepayInd) or (FUP/@FUPrepayInd != 1))])"/>
                </xsl:attribute>
                <fo:block text-align="center">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','301')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
            </xsl:if>
            <xsl:apply-templates select="." mode="normal"/>
          </fo:table-row>
        </xsl:for-each>          
        
      </xsl:if>

      <xsl:if test="XCD/@TapSeqNo or XCD/@RapSeqNo">

        <fo:table-row font-size="7pt" font-weight="bold" text-align="center">

          <xsl:for-each select="$fup">

            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <!-- cost control contract id -->
            <fo:table-cell background-color="gainsboro">
              <fo:block>
                <xsl:value-of select="key('fup-index','CoId')[@xml:lang=$lang]/@Des"/>
              </fo:block>
            </fo:table-cell>            
            <fo:table-cell background-color="gainsboro">
              <!-- free unit account id / history id -->
              <fo:block>
                <xsl:value-of select="key('fup-index','FUAccId')[@xml:lang=$lang]/@Des"/>
                <xsl:text> / </xsl:text>
                <xsl:value-of select="key('fup-index','FUAccHistId')[@xml:lang=$lang]/@Des"/>
              </fo:block>
              <!-- free unit part type -->
              <fo:block>
                <xsl:value-of select="key('fup-index','FUOption')[@xml:lang=$lang]/@Des"/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell background-color="gainsboro" number-columns-spanned="2">
              <!-- free unit package / element / version -->
              <fo:block>
                <xsl:value-of select="key('fup-index','FUP')[@xml:lang=$lang]/@Des"/>
                <xsl:text> / </xsl:text>
                <xsl:value-of select="key('fup-index','FUE')[@xml:lang=$lang]/@Des"/>
                <xsl:text> / </xsl:text>
                <xsl:value-of select="key('fup-index','FUEV')[@xml:lang=$lang]/@Des"/>
              </fo:block>
              <!-- charge plan -->
              <fo:block>
                <xsl:value-of select="key('fup-index','ChPlan')[@xml:lang=$lang]/@Des"/>
              </fo:block>
            </fo:table-cell>
            <!-- cost control service -->
            <fo:table-cell background-color="gainsboro">
              <fo:block>
                <xsl:value-of select="key('fup-index','SN')[@xml:lang=$lang]/@Des"/>
              </fo:block>
            </fo:table-cell>
            <!-- discount amount -->
            <fo:table-cell background-color="gainsboro" number-columns-spanned="2">
              <fo:block text-align="center">
                <xsl:value-of select="key('fup-index','Amt')[@xml:lang=$lang]/@Des"/>
              </fo:block>
            </fo:table-cell>
          </xsl:for-each>

        </fo:table-row>

        <xsl:for-each select="FUP[(not(FUP/@FUPrepayInd) or (FUP/@FUPrepayInd != 1))]">
          <fo:table-row font-size="6.5pt" background-color="gainsboro">
            <xsl:if test="position()='1'">
              <fo:table-cell font-size="7pt" font-weight="bold">
                <xsl:attribute name="number-rows-spanned">
                  <xsl:value-of select="count(../FUP[(not(FUP/@FUPrepayInd) or (FUP/@FUPrepayInd != 1))])"/>
                </xsl:attribute>
                <fo:block text-align="center">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','301')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
            </xsl:if>
            <xsl:apply-templates select="." mode="external"/>
          </fo:table-row>
        </xsl:for-each>

      </xsl:if>

    </xsl:if>

  </xsl:template>

  <!-- (some) flexible call attributes (see table charge_detail_info) -->
  <xsl:template match="XCD">

    <xsl:choose>
      <xsl:when test="not(@BundPurInd) and not(@BundUsgInd)">
        <!-- date -->
        <fo:table-cell>
          <fo:block text-align="center">
            <xsl:if test="not(@TapSeqNo or @RapSeqNo)">
              <!-- timestamp -->
              <xsl:call-template name="date-time-format">
                <xsl:with-param name="date" select="@CTs"/>
              </xsl:call-template>
            </xsl:if>
            <xsl:if test="@TapSeqNo or @RapSeqNo">
              <!-- sum udr foh generation date -->
              <xsl:call-template name="date-time-format">
                <xsl:with-param name="date" select="@CTs"/>
              </xsl:call-template>
            </xsl:if>
          </fo:block>
          <xsl:if test="not(@TapSeqNo or @RapSeqNo)">
            <fo:block>
              <!-- prepaid indicator -->
              <xsl:call-template name="DataDomainLgnMap">
                <xsl:with-param name="Index"     select="@PrInd"/>
                <xsl:with-param name="Type"      select="'DD'"/>
                <xsl:with-param name="Desc"      select="'1'"/>
                <xsl:with-param name="ClassId"   select="'YES/NO_BOOLEAN_INDICATOR'"/>
              </xsl:call-template>
            </fo:block>
          </xsl:if>
        </fo:table-cell>
        <!-- call type -->
        <fo:table-cell text-align="center">
          <fo:block>
            <xsl:call-template name="DataDomainLgnMap">
              <xsl:with-param name="Index"     select="@CT"/>
              <xsl:with-param name="Type"      select="'DD'"/>
              <xsl:with-param name="Desc"      select="'1'"/>
              <xsl:with-param name="ClassId"   select="'CALL_TYPE_CLASS'"/>
            </xsl:call-template>
          </fo:block>          
          <xsl:if test="not(@TapSeqNo) and not(@RapSeqNo)">
            <fo:block>
              <!-- rate type -->
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="@RT"/>
                <xsl:with-param name="Type"  select="'RT'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
              <xsl:text> / </xsl:text>
              <!-- rerate type -->              
              <xsl:call-template name="DataDomainLgnMap">
                <xsl:with-param name="Index"     select="@RRT"/>
                <xsl:with-param name="Type"      select="'DD'"/>
                <xsl:with-param name="Desc"      select="'1'"/>
                <xsl:with-param name="ClassId"   select="'RERATE_RECORD_TYPE_CLASS'"/>
              </xsl:call-template>
            </fo:block>
          </xsl:if>
          <!-- TAP / RAP -->
          <xsl:if test="@TapSeqNo or @RapSeqNo">
            <fo:block>
              <!-- service -->
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="@SN"/>
                <xsl:with-param name="Type"  select="'SN'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
            </fo:block>
          </xsl:if>
        </fo:table-cell>
        <!-- rated volume -->
        <fo:table-cell text-align="right" padding-right="2mm">
          <fo:block>
            <xsl:choose>
              <xsl:when test="@ORV">
                <!-- original rated volume -->
                <xsl:call-template name="number-unit-format">
                  <xsl:with-param name="number" select="@ORV"/>
                  <xsl:with-param name="unit" select="@UM"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <!-- discounted rated volume -->
                <xsl:call-template name="number-unit-format">
                  <xsl:with-param name="number" select="@DRV"/>
                  <xsl:with-param name="unit" select="@UM"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </fo:block>
          <fo:block>
            <xsl:choose>
              <xsl:when test="@BOPSeqNoRP">
                <!-- best option plan tariff model sequence number -->
                <xsl:value-of select="@BOPSeqNoRP"/>
              </xsl:when>
              <xsl:when test="@BOPSeqNoSP">
                <!-- best option plan service package sequence number -->
                <xsl:value-of select="@BOPSeqNoSP"/>
              </xsl:when>
              <!-- TAP / RAP are not BOP relevant -->
              <xsl:when test="@TapSeqNo or @RapSeqNo">
                <!--
                         <xsl:value-of select="@FileName"/>
                         -->
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>-</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="not(@TapSeqNo) and not(@RapSeqNo)">
              <xsl:text> / </xsl:text>
              <!-- pricing alternative -->
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="@TIDPA"/>
                <xsl:with-param name="Type"  select="'PA'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
            </xsl:if>
          </fo:block>
        </fo:table-cell>
        <!-- network indicator/name -->
        <fo:table-cell text-align="center">
          <fo:block>
            <!-- network indicator -->
            <xsl:call-template name="DataDomainLgnMap">
              <xsl:with-param name="Index"     select="@NI"/>
              <xsl:with-param name="Type"      select="'DD'"/>
              <xsl:with-param name="Desc"      select="'1'"/>
              <xsl:with-param name="ClassId"   select="'XFILE_IND_CLASS'"/>
            </xsl:call-template>
          </fo:block>
          <xsl:if test="not(@TapSeqNo or @RapSeqNo)">
            <fo:block>
              <!-- network name -->
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="@NN"/>
                <xsl:with-param name="Type"  select="'PL'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
            </fo:block>
          </xsl:if>
          <!-- rerate type -->
          <!--
                <xsl:if test="@TapSeqNo or @RapSeqNo">
                  <fo:block>                  
              <xsl:call-template name="DataDomainLgnMap">
                <xsl:with-param name="Index"     select="@RRT"/>
                <xsl:with-param name="Type"      select="'DD'"/>
                <xsl:with-param name="Desc"      select="'1'"/>
                <xsl:with-param name="ClassId"   select="'RERATE_RECORD_TYPE_CLASS'"/>
              </xsl:call-template>
            </fo:block>
          </xsl:if>
          -->
        </fo:table-cell>
        <xsl:if test="not(@TapSeqNo or @RapSeqNo)">
          <!-- destination -->
          <fo:table-cell text-align="center">
            <fo:block>                     
              <xsl:call-template name="DataDomainLgnMap">
                <xsl:with-param name="Index"     select="@DES"/>
                <xsl:with-param name="Type"      select="'DD'"/>
                <xsl:with-param name="Desc"      select="'1'"/>
                <xsl:with-param name="ClassId"   select="'CALL_DEST_CLASS'"/>
              </xsl:call-template>
            </fo:block>
            <fo:block>
              <!-- destination zone point -->
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="@DZP"/>
                <xsl:with-param name="Type"  select="'ZD'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
            </fo:block>
          </fo:table-cell>
        </xsl:if>
        <xsl:if test="not(@TapSeqNo or @RapSeqNo)">
          <fo:table-cell text-align="center">
            <fo:block>
              <!-- other party number -->
              <xsl:choose>
                <xsl:when test="@CpName!=''">
                  <!-- content provider name -->
                  <xsl:call-template name="LgnMap">
                    <xsl:with-param name="Mode"  select="'0'"/>
                    <xsl:with-param name="Index" select="@CpName"/>
                    <xsl:with-param name="Type"  select="'CP'"/>
                    <xsl:with-param name="Desc"  select="'1'"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <!-- dialled digits or connected APN -->
                  <xsl:value-of select="@OPN"/>
                </xsl:otherwise>
              </xsl:choose>
            </fo:block>
            <!-- A-party number -->
            <fo:block>
              <xsl:value-of select="@APN"/>
            </fo:block>
          </fo:table-cell>
        </xsl:if>
        <!-- tariff time -->
        <fo:table-cell text-align="center">
          <!-- tariff time -->
          <fo:block>
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="@TT"/>
              <xsl:with-param name="Type"  select="'TT'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </fo:block>
          <!-- tariff zone -->
          <fo:block>
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="@TZ"/>
              <xsl:with-param name="Type"  select="'TZ'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </fo:block>
        </fo:table-cell>
        <!-- tariff -->
        <fo:table-cell text-align="center">
          <xsl:choose>
            <xsl:when test="@BOPTM or @BOPSP">
              <!-- tariff model -->
              <fo:block>
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="@BOPTM"/>
                  <xsl:with-param name="Type"  select="'TM'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </fo:block>
              <!-- service package -->
              <fo:block>
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="@BOPSP"/>
                  <xsl:with-param name="Type"  select="'SP'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </fo:block>
            </xsl:when>
            <xsl:otherwise>
              <!-- tariff model -->
              <fo:block>
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="@TM"/>
                  <xsl:with-param name="Type"  select="'TM'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </fo:block>
              <!-- service package -->
              <fo:block>
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="@SP"/>
                  <xsl:with-param name="Type"  select="'SP'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </fo:block>
            </xsl:otherwise>
          </xsl:choose>
        </fo:table-cell>
        <!-- amount -->
        <fo:table-cell text-align="right" padding-right="1mm">
          <fo:block>
          <!-- original amount (in case of TAP TAP net rate and amount currency) -->
            <xsl:if test="@OAmt">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@OAmt"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:for-each select="@CC">
                <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
            </xsl:if>
          </fo:block>
          <fo:block>
            <!-- discounted amount -->
            <xsl:if test="@DAmt">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@DAmt"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:for-each select="@CC">
                <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
            </xsl:if>
          </fo:block>
        </fo:table-cell>
        <!-- TAP / RAP -->
        <xsl:if test="@TapSeqNo or @RapSeqNo">
          <fo:table-cell text-align="right" padding-right="1mm">
            <fo:block>
              <!-- external amount  -->
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@ExtAmt"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <!-- normally @ExtCurrCode must be used, but this attribute is missing in the samples -->
              <xsl:for-each select="@CC">
                <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
            </fo:block>
            <fo:block>
              <xsl:if test="@ExtTax">
                <!-- external tax -->
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="@ExtTax"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <!-- normally @ExtCurrCode must be used, but this attribute is missing in the samples -->
                <xsl:for-each select="@CC">
                  <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                </xsl:for-each>
              </xsl:if>
            </fo:block>
          </fo:table-cell>
        </xsl:if>

      </xsl:when>
      <xsl:when test="@BundUsgInd">
        <!-- date / time -->
        <fo:table-cell>
          <fo:block text-align="center">
            <xsl:call-template name="date-time-format">
              <xsl:with-param name="date" select="@CTs"/>
            </xsl:call-template>
          </fo:block>
        </fo:table-cell>
        <!-- bundle name -->
        <fo:table-cell>
          <fo:block text-align="center">
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="../FUP/@SN"/>
              <xsl:with-param name="Type"  select="'SN'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </fo:block>
        </fo:table-cell>
        <!-- bundle product -->
        <fo:table-cell>
          <fo:block text-align="center">
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="../FUP/@BPROD"/>
              <xsl:with-param name="Type"  select="'BPROD'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </fo:block>
        </fo:table-cell>
        <!-- quantity -->
        <fo:table-cell>
          <fo:block text-align="center">
            <xsl:call-template name="number-unit-format">
              <xsl:with-param name="number" select="@ORV"/>
              <xsl:with-param name="unit" select="@UM"/>
            </xsl:call-template>
          </fo:block>
        </fo:table-cell>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>

  </xsl:template>

  <!-- free unit package -->
  <xsl:template match="FUP" mode="normal">

    <!-- cost control contract -->
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:value-of select="@CoId"/>
      </fo:block>
    </fo:table-cell>
    <!-- free unit account -->
    <fo:table-cell text-align="center">
      <fo:block>
        <!-- free unit account id -->
        <xsl:value-of select="@FUAccId"/>          
        <xsl:text> / </xsl:text>
        <!-- free unit account history id -->
        <xsl:value-of select="@FUAccHistId"/>
      </fo:block>
    </fo:table-cell>
    <!-- free unit party type -->
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="DataDomainLgnMap">
          <xsl:with-param name="Index"     select="@FUOption"/>
          <xsl:with-param name="Type"      select="'DD'"/>
          <xsl:with-param name="Desc"      select="'1'"/>
          <xsl:with-param name="ClassId"   select="'FREE_UNIT_OPTION_CLASS'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>      
    <!-- free unit package -->
    <fo:table-cell number-columns-spanned="2" text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@FUP"/>
          <xsl:with-param name="Type"  select="'FUP'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
        <!-- free unit element -->
        <xsl:if test="@FUE">
          <xsl:text> / </xsl:text>
          <xsl:value-of select="@FUE"/>
        </xsl:if>
        <!-- free unit version -->
        <xsl:if test="@FUEV">
          <xsl:text> / </xsl:text>
          <xsl:value-of select="@FUEV"/>
        </xsl:if>
      </fo:block>
    </fo:table-cell>
    <!-- charge plan -->
    <fo:table-cell text-align="center">      
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@ChPlan"/>
          <xsl:with-param name="Type"  select="'CPD'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <!-- cost control service -->
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
    <!-- discount amount -->
    <fo:table-cell text-align="right" padding-right="1mm">
      <fo:block>
        <xsl:if test="@Amt">
          <xsl:call-template name="number-format">
            <xsl:with-param name="number" select="@Amt"/>
          </xsl:call-template>
          <xsl:text> </xsl:text>
          <xsl:for-each select="@AmtCurrCode">
            <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
          </xsl:for-each>
        </xsl:if>
      </fo:block>
    </fo:table-cell>

  </xsl:template>

  <!-- free unit package ( TAP, RAP ) -->
  <xsl:template match="FUP" mode="external">

    <!-- cost control contract -->
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:value-of select="@CoId"/>
      </fo:block>
    </fo:table-cell>    
    <fo:table-cell text-align="center">
      <!-- free unit account -->
      <fo:block>
        <!-- free unit account id -->
        <xsl:value-of select="@FUAccId"/>          
        <xsl:text> / </xsl:text>
        <!-- free unit account history id -->
        <xsl:value-of select="@FUAccHistId"/>
      </fo:block>
       <!-- free unit party type -->
      <fo:block>
        <xsl:call-template name="DataDomainLgnMap">
          <xsl:with-param name="Index"     select="@FUOption"/>
          <xsl:with-param name="Type"      select="'DD'"/>
          <xsl:with-param name="Desc"      select="'1'"/>
          <xsl:with-param name="ClassId"   select="'FREE_UNIT_OPTION_CLASS'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>      
    <fo:table-cell number-columns-spanned="2" text-align="center">
      <fo:block>
        <!-- free unit package -->
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@FUP"/>
          <xsl:with-param name="Type"  select="'FUP'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
        <!-- free unit element -->
        <xsl:if test="@FUE">
          <xsl:text> / </xsl:text>
          <xsl:value-of select="@FUE"/>
        </xsl:if>
        <!-- free unit version -->
        <xsl:if test="@FUEV">
          <xsl:text> / </xsl:text>
          <xsl:value-of select="@FUEV"/>
        </xsl:if>
      </fo:block>
      <!-- charge plan -->
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@ChPlan"/>
          <xsl:with-param name="Type"  select="'CPD'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <!-- cost control service -->
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
    <!-- discount amount -->
    <fo:table-cell text-align="right" padding-right="1mm">
      <fo:block>
        <xsl:if test="@Amt">
          <xsl:call-template name="number-format">
            <xsl:with-param name="number" select="@Amt"/>
          </xsl:call-template>
          <xsl:text> </xsl:text>
          <xsl:for-each select="@AmtCurrCode">
            <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
          </xsl:for-each>
        </xsl:if>
      </fo:block>
    </fo:table-cell>

  </xsl:template>

  <!-- (some) flexible charge attributes (see charge_detail_info) -->
  <xsl:template name="charge-details">

    <xsl:param name="node"/>
    <xsl:param name="charge-type"/>
    
      <fo:table-row font-size="6.5pt">
        <!-- date -->
        <fo:table-cell>
          <fo:block text-align="center">
            <!-- timestamp -->
            <xsl:call-template name="date-time-format">
              <xsl:with-param name="date" select="$node/@CTs"/>
            </xsl:call-template>
          </fo:block>
          <fo:block text-align="center">
            <!-- prepaid indicator -->            
            <xsl:call-template name="DataDomainLgnMap">
              <xsl:with-param name="Index"     select="$node/@PrInd"/>
              <xsl:with-param name="Type"      select="'DD'"/>
              <xsl:with-param name="Desc"      select="'1'"/>
              <xsl:with-param name="ClassId"   select="'YES/NO_BOOLEAN_INDICATOR'"/>
            </xsl:call-template>
          </fo:block>
        </fo:table-cell>
        <!-- tariff -->
        <fo:table-cell text-align="center">
          <xsl:choose>
            <xsl:when test="$node/@BOPTM or $node/@BOPSP">
              <!-- tariff model / version -->
              <fo:block>
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="$node/@BOPTM"/>
                  <xsl:with-param name="Type"  select="'TM'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$node/@TMV"/>
              </fo:block>
              <!-- service package -->
              <fo:block>
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="$node/@BOPSP"/>
                  <xsl:with-param name="Type"  select="'SP'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </fo:block>
            </xsl:when>
            <xsl:otherwise>
              <!-- tariff model -->
              <fo:block>
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="$node/@TM"/>
                  <xsl:with-param name="Type"  select="'TM'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$node/@TMV"/>
              </fo:block>
              <!-- service package -->
              <fo:block>
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="$node/@SP"/>
                  <xsl:with-param name="Type"  select="'SP'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </fo:block>
            </xsl:otherwise>
          </xsl:choose>
        </fo:table-cell>      
        <fo:table-cell text-align="center">
          <!-- quantity -->
          <xsl:choose>
            <xsl:when test="$node/@Numit">
              <fo:block>
                <xsl:value-of select="$node/@Numit"/>
              </fo:block>              
            </xsl:when>
            <xsl:otherwise>
              <fo:block>
                <xsl:text>-</xsl:text>
              </fo:block>
            </xsl:otherwise>
          </xsl:choose>
          <!-- active days -->
          <xsl:choose>
            <xsl:when test="$node/@NumDays">
              <fo:block>
                <xsl:value-of select="$node/@NumDays"/>
              </fo:block>              
            </xsl:when>
            <xsl:otherwise>
              <fo:block>
                <xsl:text>-</xsl:text>
              </fo:block>
            </xsl:otherwise>
          </xsl:choose>
        </fo:table-cell>
        <fo:table-cell text-align="center">
          <!-- service charge subtype -->          
          <fo:block>
            <xsl:call-template name="DataDomainLgnMap">
              <xsl:with-param name="Index"     select="$node/@SrvChSType"/>
              <xsl:with-param name="Type"      select="'DD'"/>
              <xsl:with-param name="Desc"      select="'1'"/>
              <xsl:with-param name="ClassId"   select="'CHARGE_SUBTYPE_CLASS'"/>
            </xsl:call-template>
          </fo:block>
        </fo:table-cell>        
        <!-- service status -->
        <fo:table-cell text-align="center">
          <fo:block>
            <xsl:if test="$node/@ChrgStartTime">
              <xsl:call-template name="date-time-format">
                <xsl:with-param name="date" select="$node/@ChrgStartTime"/>
              </xsl:call-template>              
            </xsl:if>
            <xsl:if test="$node/@ChrgEndTime">
              <xsl:text> - </xsl:text>
              <xsl:call-template name="date-time-format">
                <xsl:with-param name="date" select="$node/@ChrgEndTime"/>
              </xsl:call-template>
            </xsl:if>
            <xsl:if test="$node/@SrvSt">
              <xsl:text>, </xsl:text>
              <xsl:value-of select="$node/@SrvSt"/>
            </xsl:if>
          </fo:block>
          <!-- market -->
          <fo:block>
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="$node/@MKT"/>
              <xsl:with-param name="Type"  select="'MRKT'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </fo:block>
        </fo:table-cell>
        <!-- service info ( @PrmValueId can be mapped to the description via the respective SumItem ) -->
        <!--
        <fo:table-cell text-align="center">
          <fo:block>
            <xsl:value-of select="$node/@PrmValueId"/>
          </fo:block>
        </fo:table-cell>
        -->
        <fo:table-cell text-align="right">
          <!-- price -->
          <fo:block>
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="$node/@Price"/>
            </xsl:call-template>          
            <xsl:text> </xsl:text>
            <xsl:for-each select="$node/@PriceCurr">
              <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
          </fo:block>
          <!-- profile -->
          <fo:block>
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="$node/@PRO"/>
              <xsl:with-param name="Type"  select="'PRO'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </fo:block>
        </fo:table-cell>
        <!-- amount -->
        <fo:table-cell text-align="right" padding-right="1mm">
          <fo:block>
          <!-- original amount -->
            <xsl:if test="$node/@OAmt">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@OAmt"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:for-each select="$node/@CC">
                <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
            </xsl:if>
          </fo:block>
        </fo:table-cell>
      </fo:table-row>

  </xsl:template>

  <!-- cost control discounts -->
  <xsl:template match="FUP" mode="charge-details">

    <!-- cost control service -->
    <fo:table-cell number-columns-spanned="2" text-align="center">      
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
    <fo:table-cell number-columns-spanned="2" text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@Profile"/>
          <xsl:with-param name="Type"  select="'PRO'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>    
    <!-- discount amount -->
    <fo:table-cell number-columns-spanned="2" text-align="right" padding-right="1mm">
      <fo:block>
        <xsl:if test="@Amt">
          <xsl:call-template name="number-format">
            <xsl:with-param name="number" select="@Amt"/>
          </xsl:call-template>
          <xsl:text> </xsl:text>
          <xsl:for-each select="@AmtCurrCode">
            <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
          </xsl:for-each>
        </xsl:if>
      </fo:block>
    </fo:table-cell>

  </xsl:template>

  <xsl:template name="set:distinct">
    <xsl:param name="nodes" select="/.."/>
    <xsl:param name="distinct" select="/.."/>
    <xsl:choose>
      <xsl:when test="$nodes">
        <xsl:call-template name="set:distinct">
        <xsl:with-param name="distinct" select="$distinct | $nodes[1][not(. = $distinct)]"/>
        <xsl:with-param name="nodes" select="$nodes[position() > 1]"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$distinct" mode="set:distinct"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="node()|@*" mode="set:distinct">
     <xsl:copy-of select="." />
  </xsl:template>

</xsl:stylesheet>
