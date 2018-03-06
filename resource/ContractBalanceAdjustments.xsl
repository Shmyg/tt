<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    ContractBalanceAdjustments.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> HTML stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms balance adjustments.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/ContractBalanceAdjustments.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015
  
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">

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

  <!-- stand-alone balance snapshots -->
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
          <h3><center>
             <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','242')[@xml:lang=$lang]/@Des"/>
             </xsl:for-each>
             <xsl:text> </xsl:text>
          </center></h3>
          <br/>
        </xsl:if>

        <h3><center> 
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','110')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$next-balance-adjustments-contract"/>
        </center></h3>
        <br/>

        <table border="1" width="100%" cellspacing="0" cellpadding="0">
          <thead>          
            <tr>
              <xsl:for-each select="$txt">
                <!-- request date -->
                <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                  <xsl:value-of select="key('txt-index','244')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <!-- purpose -->
                <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                  <xsl:value-of select="key('txt-index','245')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                  <!-- period -->
                  <xsl:value-of select="key('txt-index','145')[@xml:lang=$lang]/@Des"/><br/>
                  <!-- adjustment -->
                  <xsl:value-of select="key('txt-index','246')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <!-- reason -->
                <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                  <xsl:value-of select="key('txt-index','247')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <!-- service -->
                <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                  <xsl:value-of select="key('txt-index','249')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <!-- shared account -->
                <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                  <xsl:value-of select="key('txt-index','257')[@xml:lang=$lang]/@Des"/>
                </font></th>                
                <!-- bundle product -->
                <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                  <xsl:value-of select="key('txt-index','251')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <!-- accumulated volume -->
                <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                  <xsl:value-of select="key('txt-index','254')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <!-- accumulated credit -->
                <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                  <xsl:value-of select="key('txt-index','255')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <!-- remaining credit -->
                <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                  <xsl:value-of select="key('txt-index','256')[@xml:lang=$lang]/@Des"/>
                </font></th>
              </xsl:for-each>
            </tr>
          </thead>  
          <tbody>  
            <xsl:for-each select="$contract-balance-adjustments[$next-balance-adjustments-contract = @CoId]/BalAd">
              <tr>
                <xsl:apply-templates select="."/>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>

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
