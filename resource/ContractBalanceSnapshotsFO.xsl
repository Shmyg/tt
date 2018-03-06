<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    ContractBalanceSnapshotsFO.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> XSL-FO stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms balance snapshots.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/ContractBalanceSnapshotsFO.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">

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

  <!-- stand-alone balance snapshots -->
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
          <fo:block space-before="3mm" text-align="center" font-weight="bold" font-size="10pt">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','167')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </fo:block>
        </xsl:if>

        <fo:block space-before="3mm" text-align="center" font-weight="bold" font-size="7pt">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','110')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$next-balance-snapshots-contract"/>
        </fo:block>
  
        <fo:block space-before="1mm">
          <fo:table width="160mm" table-layout="fixed">
            <fo:table-column column-width="20mm" column-number="1"/>
            <fo:table-column column-width="40mm" column-number="2"/>
            <fo:table-column column-width="40mm" column-number="3"/>
            <fo:table-column column-width="20mm" column-number="4"/>
            <fo:table-column column-width="20mm" column-number="5"/>
            <fo:table-column column-width="20mm" column-number="6"/>
            <fo:table-header space-after="2pt">

              <fo:table-row font-size="7pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <!-- snapshot date -->
                  <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                    <fo:block>
                      <xsl:value-of select="key('txt-index','168')[@xml:lang=$lang]/@Des"/>
                    </fo:block>
                  </fo:table-cell>
                  <!-- service -->
                  <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                    <fo:block>
                      <xsl:value-of select="key('txt-index','170')[@xml:lang=$lang]/@Des"/>
                    </fo:block>
                    <!-- shared account -->
                    <fo:block>
                      <xsl:value-of select="key('txt-index','257')[@xml:lang=$lang]/@Des"/>
                    </fo:block>                    
                  </fo:table-cell>
                  <!-- bundle product -->
                  <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                    <fo:block>
                      <xsl:value-of select="key('txt-index','445')[@xml:lang=$lang]/@Des"/>
                    </fo:block>
                  </fo:table-cell>
                  <!-- used volume -->
                  <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                    <fo:block>
                      <xsl:value-of select="key('txt-index','173')[@xml:lang=$lang]/@Des"/>
                    </fo:block>
                  </fo:table-cell>
                  <!-- used credit -->
                  <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                    <fo:block>
                      <xsl:value-of select="key('txt-index','174')[@xml:lang=$lang]/@Des"/>
                    </fo:block>
                  </fo:table-cell>
                  <!-- remaining credit -->
                  <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                    <fo:block>
                      <xsl:value-of select="key('txt-index','175')[@xml:lang=$lang]/@Des"/>
                    </fo:block>
                  </fo:table-cell>
                </xsl:for-each>
              </fo:table-row>
            </fo:table-header>
            <fo:table-body font-size="7pt">
              <xsl:for-each select="$contract-balance-snapshots[$next-balance-snapshots-contract = @CoId]/BalSsh">
                <fo:table-row>
                  <xsl:apply-templates select="."/>
                </fo:table-row>
              </xsl:for-each>
            </fo:table-body>
          </fo:table>
        </fo:block>
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
