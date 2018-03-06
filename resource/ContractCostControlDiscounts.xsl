<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    ContractCostControlDiscounts.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> HTML stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms cost control discounts.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/ContractCostControlDiscounts.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">

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
              <h3><center>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','401')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </center></h3>
              <br/>
            </xsl:if>
    
            <h3><center> 
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','110')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$next-cost-control-discounts-contract"/>
            </center></h3>
            <br/>
            <table border="1" width="100%" cellspacing="0" cellpadding="0">
              <thead>
                <tr>
                  <xsl:for-each select="$txt">
                    <!-- service -->
                    <th nowrap="nowrap"><font size="-1">
                      <xsl:value-of select="key('txt-index','140')[@xml:lang=$lang]/@Des"/>
                    </font></th>
                    <!-- original value -->
                    <th nowrap="nowrap"><font size="-1">
                      <xsl:value-of select="key('txt-index','399')[@xml:lang=$lang]/@Des"/>
                    </font></th>
                    <!-- discount value -->
                    <th nowrap="nowrap"><font size="-1">
                      <xsl:value-of select="key('txt-index','400')[@xml:lang=$lang]/@Des"/>
                    </font></th>
                  </xsl:for-each>
                </tr>
              </thead>
              <tbody>
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
              </tbody>
            </table>
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
