<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 

  All rights reserved.

  File:    ContractExternalDiscounts.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> HTML stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms external discounts (e. g. charging system).
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/ContractExternalDiscounts.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">

  <xsl:variable name="contract-external-discounts" select="document(/Bill/Part/@File)/Document/InvoiceInfo/CSDiscountInfoPerCo"/>

  <!-- contract external discounts -->
  <xsl:template name="contract-external-discounts">

    <xsl:param name="co-id" select="''"/>

    <xsl:if test="$contract-external-discounts[$co-id = @CoId]">

      <xsl:call-template name="external-discounts-by-stand-alone-contracts">
        <xsl:with-param name="list-of-unique-external-discounts-contracts" select="concat($co-id,' ')"/>    
        <xsl:with-param name="header" select="'Y'"/>
        <xsl:with-param name="sum-sheet-contract" select="'Y'"/>
      </xsl:call-template>

    </xsl:if>

  </xsl:template>

  <!-- stand-alone external discounts -->
  <xsl:template name="external-discounts">

    <!-- build a unique list of external discounts contracts -->
    <xsl:variable name="list-of-external-discounts-contracts">
      <xsl:for-each select="$contract-external-discounts/@CoId">
        <xsl:sort select="." data-type="text"/>
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="list-of-unique-external-discounts-contracts">
      <xsl:call-template name="remove-duplicates">
        <xsl:with-param name="list-of-services" select="$list-of-external-discounts-contracts"/>
        <xsl:with-param name="last-service" select="''"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="normalize-space($list-of-unique-external-discounts-contracts)!=''">

      <xsl:call-template name="external-discounts-by-stand-alone-contracts">
        <xsl:with-param name="list-of-unique-external-discounts-contracts" select="$list-of-unique-external-discounts-contracts"/>
        <xsl:with-param name="header" select="'Y'"/>
        <xsl:with-param name="sum-sheet-contract" select="'N'"/>
      </xsl:call-template>

    </xsl:if>  

  </xsl:template>

  <!-- stand-alone external discounts -->
  <xsl:template name="external-discounts-by-stand-alone-contracts">

    <xsl:param name="list-of-unique-external-discounts-contracts" select="''"/>
    <xsl:param name="header" select="'N'"/>
    <xsl:param name="sum-sheet-contract" select="'N'"/>

    <xsl:if test="normalize-space($list-of-unique-external-discounts-contracts)!=''">

      <xsl:variable name="next-external-discounts-contract">
        <xsl:value-of select="substring-before($list-of-unique-external-discounts-contracts, ' ')"/>
      </xsl:variable>

      <xsl:variable name="remaining-external-discounts-contracts">
        <xsl:value-of select="substring-after($list-of-unique-external-discounts-contracts, ' ')"/>
      </xsl:variable>

      <xsl:if test="(not(contains($list-of-unique-sum-sheet-contracts,$next-external-discounts-contract)) and $sum-sheet-contract = 'N') or
                        (contains($list-of-unique-sum-sheet-contracts,$next-external-discounts-contract)  and $sum-sheet-contract = 'Y')">

        <xsl:if test="$contract-external-discounts[$next-external-discounts-contract = @CoId]/CSDiscountInfo">


            <xsl:if test="$header = 'Y'">
              <h3><center>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','547')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </center></h3>
              <br/>
            </xsl:if>
    
            <h3><center> 
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','110')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$next-external-discounts-contract"/>
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
                  <xsl:for-each select="$contract-external-discounts[$next-external-discounts-contract = @CoId]/CSDiscountInfo">
                      <xsl:apply-templates select="."/>
                  </xsl:for-each>
              </tbody>
            </table>
        </xsl:if>
      </xsl:if>

      <xsl:if test="normalize-space($remaining-external-discounts-contracts) != ''">
        <xsl:call-template name="external-discounts-by-stand-alone-contracts">
          <xsl:with-param name="list-of-unique-external-discounts-contracts" select="$remaining-external-discounts-contracts"/>
          <xsl:with-param name="header" select="'N'"/>
          <xsl:with-param name="sum-sheet-contract" select="$sum-sheet-contract"/>
        </xsl:call-template>
      </xsl:if>

    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
