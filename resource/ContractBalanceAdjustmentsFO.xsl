<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    ContractBalanceAdjustmentsFO.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> XSL-FO stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms balance adjustments.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/ContractBalanceAdjustmentsFO.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">

  <xsl:variable name="contract-balance-adjustments" select="document(/Bill/Part/@File)/Document/InvoiceInfo/BalAdPerCo"/>

  <!-- contract balance adjustments -->
  <xsl:template name="contract-balance-adjustments">

    <xsl:param name="co-id" select="''"/>

    <xsl:if test="$contract-balance-adjustments[$co-id = @CoId]">

      <xsl:call-template name="balance-adjustments-by-stand-alone-contracts">
        <xsl:with-param name="list-of-unique-balance-adjustments-contracts" select="concat($co-id,' ')"/>    
        <xsl:with-param name="header" select="'Y'"/>
        <xsl:with-param name="sum-sheet-contract" select="'Y'"/>
      </xsl:call-template>

    </xsl:if>

  </xsl:template>

  <!-- stand-alone balance adjustments -->
  <xsl:template name="balance-adjustments">

    <!-- build a unique list of balance adjustments contracts -->
    <xsl:variable name="list-of-balance-adjustments-contracts">
      <xsl:for-each select="$contract-balance-adjustments/@CoId">
        <xsl:sort select="." data-type="text"/>
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="list-of-unique-balance-adjustments-contracts">
      <xsl:call-template name="remove-duplicates">
        <xsl:with-param name="list-of-services" select="$list-of-balance-adjustments-contracts"/>
        <xsl:with-param name="last-service" select="''"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="normalize-space($list-of-unique-balance-adjustments-contracts)!=''">

      <xsl:call-template name="balance-adjustments-by-stand-alone-contracts">
        <xsl:with-param name="list-of-unique-balance-adjustments-contracts" select="$list-of-unique-balance-adjustments-contracts"/>
        <xsl:with-param name="header" select="'Y'"/>
        <xsl:with-param name="sum-sheet-contract" select="'N'"/>
      </xsl:call-template>

    </xsl:if>  

  </xsl:template>

  <!-- stand-alone balance adjustments -->
  <xsl:template name="balance-adjustments-by-stand-alone-contracts">

    <xsl:param name="list-of-unique-balance-adjustments-contracts" select="''"/>
    <xsl:param name="header" select="'N'"/>
    <xsl:param name="sum-sheet-contract" select="'N'"/>

    <xsl:if test="normalize-space($list-of-unique-balance-adjustments-contracts)!=''">

      <xsl:variable name="next-balance-adjustments-contract">
        <xsl:value-of select="substring-before($list-of-unique-balance-adjustments-contracts, ' ')"/>
      </xsl:variable>

      <xsl:variable name="remaining-balance-adjustments-contracts">
        <xsl:value-of select="substring-after($list-of-unique-balance-adjustments-contracts, ' ')"/>
      </xsl:variable>

      <xsl:if test="(not(contains($list-of-unique-sum-sheet-contracts,$next-balance-adjustments-contract)) and $sum-sheet-contract = 'N') or
                        (contains($list-of-unique-sum-sheet-contracts,$next-balance-adjustments-contract)  and $sum-sheet-contract = 'Y')">

        <xsl:if test="$header = 'Y'">
          <fo:block space-before="3mm" text-align="center" font-weight="bold" font-size="10pt">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','242')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </fo:block>
        </xsl:if>

        <fo:block space-before="3mm" text-align="center" font-weight="bold" font-size="7pt">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','110')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$next-balance-adjustments-contract"/>
        </fo:block>
  
        <fo:block space-before="1mm">
          <fo:table width="160mm" table-layout="fixed">
            <fo:table-column column-width="13mm" column-number="1"/>
            <fo:table-column column-width="12mm" column-number="2"/>
            <fo:table-column column-width="26mm" column-number="3"/>
            <fo:table-column column-width="20mm" column-number="4"/>
            <fo:table-column column-width="20mm" column-number="5"/>
            <fo:table-column column-width="18mm" column-number="6"/>
            <fo:table-column column-width="17mm" column-number="7"/>
            <fo:table-column column-width="17mm" column-number="8"/>
            <fo:table-column column-width="17mm" column-number="9"/>
     
            <fo:table-header space-after="1mm" font-size="7pt" font-weight="bold" text-align="center">

              <fo:table-row>
                <xsl:for-each select="$txt">
                  <!-- request date -->
                  <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                    <fo:block>
                      <xsl:value-of select="key('txt-index','244')[@xml:lang=$lang]/@Des"/>
                    </fo:block>
                  </fo:table-cell>
                  <!-- purpose -->
                  <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                    <fo:block>
                      <xsl:value-of select="key('txt-index','245')[@xml:lang=$lang]/@Des"/>
                    </fo:block>
                  </fo:table-cell>                 
                  <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                    <!-- period -->
                    <fo:block>
                      <xsl:value-of select="key('txt-index','145')[@xml:lang=$lang]/@Des"/>
                    </fo:block>
                    <!-- adjustment -->
                    <fo:block>
                      <xsl:value-of select="key('txt-index','246')[@xml:lang=$lang]/@Des"/>
                    </fo:block>
                  </fo:table-cell>
                  <!-- reason -->
                  <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                    <fo:block>
                      <xsl:value-of select="key('txt-index','247')[@xml:lang=$lang]/@Des"/>
                    </fo:block>
                  </fo:table-cell>                  
                  <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                    <!-- service -->
                    <fo:block>
                      <xsl:value-of select="key('txt-index','249')[@xml:lang=$lang]/@Des"/>
                    </fo:block>
                    <!-- shared account -->
                    <fo:block>
                      <xsl:value-of select="key('txt-index','257')[@xml:lang=$lang]/@Des"/>
                    </fo:block>                    
                  </fo:table-cell>
                  <!-- bundle product -->
                  <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                    <fo:block>
                      <xsl:value-of select="key('txt-index','251')[@xml:lang=$lang]/@Des"/>
                    </fo:block>
                  </fo:table-cell>
                  <!-- accumulated volume -->
                  <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                    <fo:block>
                      <xsl:value-of select="key('txt-index','254')[@xml:lang=$lang]/@Des"/>
                    </fo:block>
                  </fo:table-cell>
                  <!-- accumulated  credit -->
                  <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                    <fo:block>
                      <xsl:value-of select="key('txt-index','255')[@xml:lang=$lang]/@Des"/>
                    </fo:block>
                  </fo:table-cell>
                  <!-- remaining credit -->
                  <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                    <fo:block>
                      <xsl:value-of select="key('txt-index','256')[@xml:lang=$lang]/@Des"/>
                    </fo:block>
                  </fo:table-cell>
                </xsl:for-each>
              </fo:table-row>
            </fo:table-header>
            <fo:table-body font-size="7pt">
              <xsl:for-each select="$contract-balance-adjustments[$next-balance-adjustments-contract = @CoId]/BalAd">
                <fo:table-row>
                  <xsl:apply-templates select="."/>
                </fo:table-row>
              </xsl:for-each>
            </fo:table-body>
          </fo:table>
        </fo:block>
      </xsl:if>

      <xsl:if test="normalize-space($remaining-balance-adjustments-contracts) != ''">
        <xsl:call-template name="balance-adjustments-by-stand-alone-contracts">
          <xsl:with-param name="list-of-unique-balance-adjustments-contracts" select="$remaining-balance-adjustments-contracts"/>
          <xsl:with-param name="header" select="'N'"/>
          <xsl:with-param name="sum-sheet-contract" select="$sum-sheet-contract"/>
        </xsl:call-template>
      </xsl:if>

    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
