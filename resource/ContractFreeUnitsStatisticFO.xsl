<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    ContractFreeUnitsStatisticFO.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> XSL-FO stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms the free units statistic ( inlcuding price plans ).
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/ContractFreeUnitsStatisticFO.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">

  <xsl:variable name="contract-free-units-statistic" select="document(/Bill/Part/@File)/Document/InvoiceInfo/FUDiscountInfoPerCo"/>

  <!-- contract free units statistic -->
  <xsl:template name="contract-free-units-statistic">

    <xsl:param name="co-id" select="''"/>
    <xsl:param name="bop-id" select="''"/>

    <xsl:if test="$contract-free-units-statistic[$co-id = @CoId]">

      <xsl:call-template name="free-units-statistic-by-stand-alone-contracts">
        <xsl:with-param name="list-of-unique-free-units-statistic-contracts" select="concat($co-id,' ')"/>    
        <xsl:with-param name="header" select="'Y'"/>
        <xsl:with-param name="bop-id" select="$bop-id"/>
        <xsl:with-param name="sum-sheet-contract" select="'Y'"/>
      </xsl:call-template>

    </xsl:if>

  </xsl:template>

  <!-- stand-alone free unit statistic -->
  <xsl:template name="free-units-statistic">

    <!-- build a unique list of free units statistic contracts -->
    <xsl:variable name="list-of-free-units-statistic-contracts">
      <xsl:for-each select="$contract-free-units-statistic/@CoId">
        <xsl:sort select="." data-type="text"/>
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="list-of-unique-free-units-statistic-contracts">
      <xsl:call-template name="remove-duplicates">
        <xsl:with-param name="list-of-services" select="$list-of-free-units-statistic-contracts"/>
        <xsl:with-param name="last-service" select="''"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="normalize-space($list-of-unique-free-units-statistic-contracts)!=''">

      <xsl:call-template name="free-units-statistic-by-stand-alone-contracts">
        <xsl:with-param name="list-of-unique-free-units-statistic-contracts" select="$list-of-unique-free-units-statistic-contracts"/>
        <xsl:with-param name="header" select="'Y'"/>
        <xsl:with-param name="bop-id" select="''"/>
        <xsl:with-param name="sum-sheet-contract" select="'N'"/>
      </xsl:call-template>

    </xsl:if>  

  </xsl:template>

  <!-- stand-alone free-units-statistic -->
  <xsl:template name="free-units-statistic-by-stand-alone-contracts">

    <xsl:param name="list-of-unique-free-units-statistic-contracts" select="''"/>
    <xsl:param name="header" select="'N'"/>
    <xsl:param name="bop-id" select="''"/>
    <xsl:param name="sum-sheet-contract" select="'N'"/>

    <xsl:if test="normalize-space($list-of-unique-free-units-statistic-contracts)!=''">

      <xsl:variable name="next-free-units-statistic-contract">
        <xsl:value-of select="substring-before($list-of-unique-free-units-statistic-contracts, ' ')"/>
      </xsl:variable>

      <xsl:variable name="remaining-free-units-statistic-contracts">
        <xsl:value-of select="substring-after($list-of-unique-free-units-statistic-contracts, ' ')"/>
      </xsl:variable>

      <xsl:if test="(not(contains($list-of-unique-sum-sheet-contracts,$next-free-units-statistic-contract)) and $sum-sheet-contract = 'N') or
                        (contains($list-of-unique-sum-sheet-contracts,$next-free-units-statistic-contract)  and $sum-sheet-contract = 'Y')">

        <xsl:if test="(string-length($bop-id) &gt; 0 and $contract-free-units-statistic[$next-free-units-statistic-contract = @CoId and 
                       ./BOPAlt/AggSet/Att/@Id=$bop-id]/FUDiscountInfo) or 
                       ( string-length($bop-id) = 0  and $contract-free-units-statistic[$next-free-units-statistic-contract = @CoId]/FUDiscountInfo)">

            <xsl:if test="$header = 'Y'">
              <fo:block space-before="3mm" text-align="center" font-weight="bold" font-size="10pt">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','398')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </xsl:if>
    
            <fo:block space-before="3mm" text-align="center" font-weight="bold" font-size="7pt">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','110')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$next-free-units-statistic-contract"/>
            </fo:block>
      
            <fo:block space-before="1mm">

              <fo:table width="160mm" table-layout="fixed">
                <fo:table-column column-width="60mm" column-number="1"/>
                <fo:table-column column-width="50mm" column-number="2"/>
                <fo:table-column column-width="50mm" column-number="3"/>
                <fo:table-header space-after="2pt">
                  <fo:table-row font-size="7pt" font-weight="bold" text-align="center">
                    <xsl:for-each select="$txt">
                      <!-- discount package -->
                      <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                        <fo:block>
                          <xsl:value-of select="key('txt-index','141')[@xml:lang=$lang]/@Des"/>
                        </fo:block>
                      </fo:table-cell>
                      <!-- eligible amount -->
                      <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                        <fo:block>
                          <xsl:value-of select="key('txt-index','399')[@xml:lang=$lang]/@Des"/>
                        </fo:block>
                      </fo:table-cell>
                      <!-- discounted amount -->
                      <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                        <fo:block>
                          <xsl:value-of select="key('txt-index','400')[@xml:lang=$lang]/@Des"/>
                        </fo:block>
                      </fo:table-cell>
                    </xsl:for-each>
                  </fo:table-row>
                </fo:table-header>
                <fo:table-body font-size="7pt">
                  <xsl:choose>
                      <xsl:when test="string-length($bop-id) &gt; 0">
                          <xsl:for-each select="$contract-free-units-statistic[$next-free-units-statistic-contract = @CoId and 
                                                ./BOPAlt/AggSet/Att/@Id=$bop-id]/FUDiscountInfo">                            
                              <xsl:apply-templates select="."/>                            
                          </xsl:for-each>
                      </xsl:when>
                      <xsl:otherwise>
                          <xsl:for-each select="$contract-free-units-statistic[$next-free-units-statistic-contract = @CoId]/FUDiscountInfo">                            
                              <xsl:apply-templates select="."/>                            
                          </xsl:for-each>
                      </xsl:otherwise>                  
                  </xsl:choose>
                </fo:table-body>
              </fo:table>
            </fo:block>
        </xsl:if>
        
      </xsl:if>

      <xsl:if test="normalize-space($remaining-free-units-statistic-contracts) != ''">
        <xsl:call-template name="free-units-statistic-by-stand-alone-contracts">
          <xsl:with-param name="list-of-unique-free-units-statistic-contracts" select="$remaining-free-units-statistic-contracts"/>
          <xsl:with-param name="header" select="'N'"/>
          <xsl:with-param name="bop-id" select="$bop-id"/>
          <xsl:with-param name="sum-sheet-contract" select="$sum-sheet-contract"/>
        </xsl:call-template>
      </xsl:if>

    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
