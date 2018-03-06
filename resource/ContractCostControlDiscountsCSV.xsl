<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    ContractCostControlDiscountsCSV.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> CSV stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms the cost control discounts.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/ContractCostControlDiscountsCSV.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bgh="http://www.lhsgroup.com/BSCS/BGH" exclude-result-prefixes="xsl bgh">

  <xsl:variable name="contract-cost-control-discounts" select="document(/Bill/Part/@File)/Document/InvoiceInfo/CCHDiscountInfoPerCo"/>

  <!-- contract cost control discounts -->
  <xsl:template name="contract-cost-control-discounts">

    <xsl:param name="co-id" select="''"/>
    <xsl:param name="bop-id" select="''"/>

    <xsl:if test="$contract-cost-control-discounts[$co-id = @CoId]">

      <xsl:call-template name="cost-control-discounts-by-stand-alone-contracts">
        <xsl:with-param name="list-of-unique-cost-control-discounts-contracts" select="concat($co-id,' ')"/>    
        <xsl:with-param name="header" select="'Y'"/>
        <xsl:with-param name="bop-id" select="$bop-id"/>
        <xsl:with-param name="sum-sheet-contract" select="'Y'"/>
      </xsl:call-template>

    </xsl:if>

  </xsl:template>

  <!-- stand-alone cost control discounts -->
  <xsl:template name="cost-control-discounts">

    <!-- build a unique list of cost control discounts contracts -->
    <xsl:variable name="list-of-cost-control-discounts-contracts">
      <xsl:for-each select="$contract-cost-control-discounts/@CoId">
        <xsl:sort select="." data-type="text"/>
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="list-of-unique-cost-control-discounts-contracts">
      <xsl:call-template name="remove-duplicates">
        <xsl:with-param name="list-of-services" select="$list-of-cost-control-discounts-contracts"/>
        <xsl:with-param name="last-service" select="''"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="normalize-space($list-of-unique-cost-control-discounts-contracts)!=''">

      <xsl:call-template name="cost-control-discounts-by-stand-alone-contracts">
        <xsl:with-param name="list-of-unique-cost-control-discounts-contracts" select="$list-of-unique-cost-control-discounts-contracts"/>
        <xsl:with-param name="header" select="'Y'"/>
        <xsl:with-param name="bop-id" select="''"/>
        <xsl:with-param name="sum-sheet-contract" select="'N'"/>
      </xsl:call-template>

    </xsl:if>  

  </xsl:template>

  <!-- stand-alone cost-control-discounts -->
  <xsl:template name="cost-control-discounts-by-stand-alone-contracts">

    <xsl:param name="list-of-unique-cost-control-discounts-contracts" select="''"/>
    <xsl:param name="header" select="'N'"/>
    <xsl:param name="bop-id" select="''"/>
    <xsl:param name="sum-sheet-contract" select="'N'"/>

    <xsl:if test="normalize-space($list-of-unique-cost-control-discounts-contracts)!=''">

      <xsl:variable name="next-cost-control-discounts-contract">
        <xsl:value-of select="substring-before($list-of-unique-cost-control-discounts-contracts, ' ')"/>
      </xsl:variable>

      <xsl:variable name="remaining-cost-control-discounts-contracts">
        <xsl:value-of select="substring-after($list-of-unique-cost-control-discounts-contracts, ' ')"/>
      </xsl:variable>

      <xsl:if test="(not(contains($list-of-unique-sum-sheet-contracts,$next-cost-control-discounts-contract)) and $sum-sheet-contract = 'N') or
                        (contains($list-of-unique-sum-sheet-contracts,$next-cost-control-discounts-contract)  and $sum-sheet-contract = 'Y')">

        <xsl:if test="(string-length($bop-id) &gt; 0 and $contract-cost-control-discounts[$next-cost-control-discounts-contract = @CoId and 
                       ./BOPAlt/AggSet/Att/@Id=$bop-id]/CCHDiscountInfo) or 
                       ( string-length($bop-id) = 0  and $contract-cost-control-discounts[$next-cost-control-discounts-contract = @CoId]/CCHDiscountInfo)">

            <xsl:if test="$header = 'Y'">
              <bgh:row>
                <bgh:cell>
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','401')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </bgh:cell>
              </bgh:row>
            </xsl:if>
    
            <bgh:row>
              <bgh:cell/>
              <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','110')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$next-cost-control-discounts-contract"/>
              </bgh:cell>
            </bgh:row>

            <xsl:for-each select="$txt">
                <bgh:row>
                    <bgh:cell/>
                    <bgh:cell>
                        <!-- service -->
                        <xsl:value-of select="key('txt-index','140')[@xml:lang=$lang]/@Des"/>
                    </bgh:cell>
                    <bgh:cell>
                        <!-- original value -->
                        <xsl:value-of select="key('txt-index','399')[@xml:lang=$lang]/@Des"/>
                    </bgh:cell>
                    <bgh:cell>
                        <!-- discount value -->
                        <xsl:value-of select="key('txt-index','400')[@xml:lang=$lang]/@Des"/>
                    </bgh:cell>
                </bgh:row>
            </xsl:for-each>
                                    
            <xsl:choose>
                <xsl:when test="string-length($bop-id) &gt; 0">
                  <xsl:for-each select="$contract-cost-control-discounts[$next-cost-control-discounts-contract = @CoId and 
                                              ./BOPAlt/AggSet/Att/@Id=$bop-id]/CCHDiscountInfo">
                    <xsl:apply-templates select="."/>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="$contract-cost-control-discounts[$next-cost-control-discounts-contract = @CoId]/CCHDiscountInfo">
                    <xsl:apply-templates select="."/>
                  </xsl:for-each>
                </xsl:otherwise>                  
            </xsl:choose>              

            <bgh:row/>

        </xsl:if>

      </xsl:if>

      <xsl:if test="normalize-space($remaining-cost-control-discounts-contracts) != ''">
        <xsl:call-template name="cost-control-discounts-by-stand-alone-contracts">
          <xsl:with-param name="list-of-unique-cost-control-discounts-contracts" select="$remaining-cost-control-discounts-contracts"/>
          <xsl:with-param name="header" select="'N'"/>
          <xsl:with-param name="bop-id" select="$bop-id"/>
          <xsl:with-param name="sum-sheet-contract" select="$sum-sheet-contract"/>
        </xsl:call-template>
      </xsl:if>

    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
