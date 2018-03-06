<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    ContractBalanceAdjustmentsCSV.xsl

  Owner: M. Fehrenbacher
             N. Kather

  @(#) ABSTRACT : XML -> CSV stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms balance adjustments.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/ContractBalanceAdjustmentsCSV.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bgh="http://www.lhsgroup.com/BSCS/BGH" exclude-result-prefixes="xsl bgh">

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
                        (contains($list-of-unique-sum-sheet-contracts,$next-balance-adjustments-contract) and $sum-sheet-contract = 'Y')">

        <xsl:if test="$header = 'Y'">
        
            <bgh:row>
                <bgh:cell>
          
            <xsl:for-each select="$txt"><!-- Balance Requests -->
              <xsl:value-of select="key('txt-index','242')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
            
                </bgh:cell>
            </bgh:row>
          
        </xsl:if>

        
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
        
              <xsl:for-each select="$txt"><!-- Contract -->
                <xsl:value-of select="key('txt-index','110')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$next-balance-adjustments-contract"/>
        
            </bgh:cell>
        </bgh:row>
          
        

        <bgh:row>   
            <bgh:cell/>
            <bgh:cell/>
            
            <xsl:for-each select="$txt">
                    
                <bgh:cell>    
                    <!-- request date -->
                    <xsl:value-of select="key('txt-index','244')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- purpose -->
                    <xsl:value-of select="key('txt-index','245')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- period -->
                    <xsl:value-of select="key('txt-index','145')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- adjustment -->    
                    <xsl:value-of select="key('txt-index','246')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>                
                <bgh:cell>
                    <!-- reason -->
                    <xsl:value-of select="key('txt-index','247')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- service -->
                    <xsl:value-of select="key('txt-index','249')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- shared account -->
                    <xsl:value-of select="key('txt-index','257')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>                
                <bgh:cell>
                    <!-- bundle product -->
                    <xsl:value-of select="key('txt-index','251')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>                
                <bgh:cell>
                    <!-- accumulated volume -->
                    <xsl:value-of select="key('txt-index','254')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- accumulated  credit -->
                    <xsl:value-of select="key('txt-index','255')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- remaining credit -->
                    <xsl:value-of select="key('txt-index','256')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>   
                  
            </xsl:for-each>
                
        </bgh:row>
              

              <xsl:for-each select="$contract-balance-adjustments[$next-balance-adjustments-contract = @CoId]/BalAd">
                
                  <xsl:apply-templates select="."/>
                
              </xsl:for-each>

        <bgh:row/>

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
