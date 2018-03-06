<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    ContractBalanceSnapshotsFO.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> CSV stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms balance snapshots.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/ContractBalanceSnapshotsCSV.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bgh="http://www.lhsgroup.com/BSCS/BGH"  exclude-result-prefixes="xsl bgh">

  <xsl:variable name="contract-balance-snapshots" select="document(/Bill/Part/@File)/Document/InvoiceInfo/BalSshPerCo"/>

  <!-- contract balance snapshots -->
  <xsl:template name="contract-balance-snapshots">

    <xsl:param name="co-id" select="''"/>

    <xsl:if test="$contract-balance-snapshots[$co-id = @CoId]">

      <xsl:call-template name="balance-snapshots-by-stand-alone-contracts">
        <xsl:with-param name="list-of-unique-balance-snapshots-contracts" select="concat($co-id,' ')"/>    
        <xsl:with-param name="header" select="'Y'"/>
        <xsl:with-param name="sum-sheet-contract" select="'Y'"/>
      </xsl:call-template>

    </xsl:if>

  </xsl:template>
  

  <!-- stand-alone balance snapshots -->
  <xsl:template name="balance-snapshots">

    <!-- build a unique list of balance snapshots contracts -->
    <xsl:variable name="list-of-balance-snapshots-contracts">
      <xsl:for-each select="$contract-balance-snapshots/@CoId">
        <xsl:sort select="." data-type="text"/>
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="list-of-unique-balance-snapshots-contracts">
      <xsl:call-template name="remove-duplicates">
        <xsl:with-param name="list-of-services" select="$list-of-balance-snapshots-contracts"/>
        <xsl:with-param name="last-service" select="''"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="normalize-space($list-of-unique-balance-snapshots-contracts)!=''">

      <xsl:call-template name="balance-snapshots-by-stand-alone-contracts">
        <xsl:with-param name="list-of-unique-balance-snapshots-contracts" select="$list-of-unique-balance-snapshots-contracts"/>
        <xsl:with-param name="header" select="'Y'"/>
        <xsl:with-param name="sum-sheet-contract" select="'N'"/>
      </xsl:call-template>

    </xsl:if>  

  </xsl:template>

  <!-- Stand-alone balance snapshots -->
  <xsl:template name="balance-snapshots-by-stand-alone-contracts">

    <xsl:param name="list-of-unique-balance-snapshots-contracts" select="''"/>
    <xsl:param name="header" select="'N'"/>
    <xsl:param name="sum-sheet-contract" select="'N'"/>

    <xsl:if test="normalize-space($list-of-unique-balance-snapshots-contracts)!=''">

      <xsl:variable name="next-balance-snapshots-contract">
        <xsl:value-of select="substring-before($list-of-unique-balance-snapshots-contracts, ' ')"/>
      </xsl:variable>

      <xsl:variable name="remaining-balance-snapshots-contracts">
        <xsl:value-of select="substring-after($list-of-unique-balance-snapshots-contracts, ' ')"/>
      </xsl:variable>

      <xsl:if test="(not(contains($list-of-unique-sum-sheet-contracts,$next-balance-snapshots-contract)) and $sum-sheet-contract = 'N') or
                        (contains($list-of-unique-sum-sheet-contracts,$next-balance-snapshots-contract)  and $sum-sheet-contract = 'Y')">

        <xsl:if test="$header = 'Y'">
        
            <bgh:row>
              <bgh:cell>
          
                <xsl:for-each select="$txt"><!-- Balance Snapshots -->
                  <xsl:value-of select="key('txt-index','167')[@xml:lang=$lang]/@Des"/>
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
              <xsl:value-of select="$next-balance-snapshots-contract"/>
            
          </bgh:cell>
        </bgh:row>
          
            
        <bgh:row>
            <bgh:cell/>
            <bgh:cell/>
          
            <xsl:for-each select="$txt">
            
                <bgh:cell>
                    <!-- snapshot date -->
                    <xsl:value-of select="key('txt-index','168')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- service -->
                    <xsl:value-of select="key('txt-index','170')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- shared account -->
                    <xsl:value-of select="key('txt-index','257')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>                
                <bgh:cell>
                    <!-- bundle product -->
                    <xsl:value-of select="key('txt-index','445')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- used volume -->
                    <xsl:value-of select="key('txt-index','173')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- used credit -->
                    <xsl:value-of select="key('txt-index','174')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- remaining credit -->
                    <xsl:value-of select="key('txt-index','175')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
              
            </xsl:for-each>
                
        </bgh:row>
              
              <!-- See template for BalSsh in SummaryCSV -->
              <xsl:for-each select="$contract-balance-snapshots[$next-balance-snapshots-contract = @CoId]/BalSsh">
                
                  <xsl:apply-templates select="."/>
                
              </xsl:for-each>
            
        <bgh:row/>  
        
      </xsl:if>

      <xsl:if test="normalize-space($remaining-balance-snapshots-contracts) != ''">
        <xsl:call-template name="balance-snapshots-by-stand-alone-contracts">
          <xsl:with-param name="list-of-unique-balance-snapshots-contracts" select="$remaining-balance-snapshots-contracts"/>
          <xsl:with-param name="header" select="'N'"/>
          <xsl:with-param name="sum-sheet-contract" select="$sum-sheet-contract"/>
        </xsl:call-template>
      </xsl:if>

    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
