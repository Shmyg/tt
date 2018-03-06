<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    ContractFreeUnitsAccounts.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> HTML stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms free units accounts.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/ContractFreeUnitsAccounts.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">

  <xsl:variable name="contract-free-units-accounts" select="document(/Bill/Part/@File)/Document/InvoiceInfo/FUAccInfoPerCo"/>

  <!-- contract free units accounts -->
  <xsl:template name="contract-free-units-accounts">

    <xsl:param name="co-id" select="''"/>
    <xsl:param name="bop-id" select="''"/>

    <xsl:if test="$contract-free-units-accounts[$co-id = @CoId]">

      <xsl:call-template name="free-units-accounts-by-stand-alone-contracts">
        <xsl:with-param name="list-of-unique-free-units-accounts-contracts" select="concat($co-id,' ')"/>    
        <xsl:with-param name="header" select="'Y'"/>
        <xsl:with-param name="bop-id" select="$bop-id"/>
        <xsl:with-param name="sum-sheet-contract" select="'Y'"/>
      </xsl:call-template>

    </xsl:if>

  </xsl:template>

  <!-- stand-alone free unit accounts -->
  <xsl:template name="free-units-accounts">

    <!-- build a unique list of free units accounts contracts -->
    <xsl:variable name="list-of-free-units-accounts-contracts">
      <xsl:for-each select="$contract-free-units-accounts/@CoId">
        <xsl:sort select="." data-type="text"/>
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="list-of-unique-free-units-accounts-contracts">
      <xsl:call-template name="remove-duplicates">
        <xsl:with-param name="list-of-services" select="$list-of-free-units-accounts-contracts"/>
        <xsl:with-param name="last-service" select="''"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="normalize-space($list-of-unique-free-units-accounts-contracts)!=''">

      <xsl:call-template name="free-units-accounts-by-stand-alone-contracts">
        <xsl:with-param name="list-of-unique-free-units-accounts-contracts" select="$list-of-unique-free-units-accounts-contracts"/>
        <xsl:with-param name="header" select="'Y'"/>
        <xsl:with-param name="bop-id" select="''"/>
        <xsl:with-param name="sum-sheet-contract" select="'N'"/>
      </xsl:call-template>

    </xsl:if>  

  </xsl:template>

  <!-- stand-alone free-units-accounts -->
  <xsl:template name="free-units-accounts-by-stand-alone-contracts">

    <xsl:param name="list-of-unique-free-units-accounts-contracts" select="''"/>
    <xsl:param name="header" select="'N'"/>
    <xsl:param name="bop-id" select="''"/>
    <xsl:param name="sum-sheet-contract" select="'N'"/>

    <xsl:if test="normalize-space($list-of-unique-free-units-accounts-contracts)!=''">

      <xsl:variable name="next-free-units-accounts-contract">
        <xsl:value-of select="substring-before($list-of-unique-free-units-accounts-contracts, ' ')"/>
      </xsl:variable>

      <xsl:variable name="remaining-free-units-accounts-contracts">
        <xsl:value-of select="substring-after($list-of-unique-free-units-accounts-contracts, ' ')"/>
      </xsl:variable>

      <xsl:if test="(not(contains($list-of-unique-sum-sheet-contracts,$next-free-units-accounts-contract)) and $sum-sheet-contract = 'N') or
                        (contains($list-of-unique-sum-sheet-contracts,$next-free-units-accounts-contract)  and $sum-sheet-contract = 'Y')">

        <xsl:if test="(string-length($bop-id) &gt; 0 and $contract-free-units-accounts[$next-free-units-accounts-contract = @CoId and 
                       ./BOPAlt/AggSet/Att/@Id=$bop-id]/FUAccInfo) or 
                       ( string-length($bop-id) = 0  and $contract-free-units-accounts[$next-free-units-accounts-contract = @CoId]/FUAccInfo)">


            <xsl:if test="$header = 'Y'">
              <h3><center>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','151')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </center></h3>
              <br/>
            </xsl:if>
    
            <h3><center> 
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','110')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$next-free-units-accounts-contract"/>
            </center></h3>
            <br/>
            <table border="1" width="100%" cellspacing="0" cellpadding="0">
              <thead>
                <tr>
                  <xsl:for-each select="$txt">                
                    <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                      <!-- account -->
                      <xsl:value-of select="key('txt-index','152')[@xml:lang=$lang]/@Des"/><br/>
                      <!-- type -->
                      <xsl:value-of select="key('txt-index','541')[@xml:lang=$lang]/@Des"/>
                    </font></th>
                    <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                      <!-- package / element / version -->
                      <xsl:value-of select="key('txt-index','153')[@xml:lang=$lang]/@Des"/><br/>
                      <!-- charge plan -->
                      <xsl:value-of select="key('txt-index','542')[@xml:lang=$lang]/@Des"/>
                    </font></th>
                    <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                      <!-- period -->
                      <xsl:value-of select="key('txt-index','155')[@xml:lang=$lang]/@Des"/><br/>
                      <!-- carry over expiration date -->
                      <xsl:value-of select="key('txt-index','156')[@xml:lang=$lang]/@Des"/>
                    </font></th>                
                    <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                      <!-- markup fee -->
                      <xsl:value-of select="key('txt-index','543')[@xml:lang=$lang]/@Des"/>
                    </font></th>
                    <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                      <!-- currently reduced -->
                      <xsl:value-of select="key('txt-index','162')[@xml:lang=$lang]/@Des"/><br/>
                      <!-- totally reduced -->
                      <xsl:value-of select="key('txt-index','163')[@xml:lang=$lang]/@Des"/>
                    </font></th>
                    <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                      <!-- original -->
                      <xsl:value-of select="key('txt-index','157')[@xml:lang=$lang]/@Des"/><br/>
                      <!-- granted -->
                      <xsl:value-of select="key('txt-index','158')[@xml:lang=$lang]/@Des"/>
                    </font></th>
                    <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                      <!-- carry over -->
                      <xsl:value-of select="key('txt-index','161')[@xml:lang=$lang]/@Des"/>
                    </font></th>
                    <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                      <!-- currently used -->
                      <xsl:value-of select="key('txt-index','159')[@xml:lang=$lang]/@Des"/><br/>
                      <!-- totally used -->
                      <xsl:value-of select="key('txt-index','160')[@xml:lang=$lang]/@Des"/>
                    </font></th>
                  </xsl:for-each>
                </tr>
              </thead>
              <tbody>
                <xsl:choose>
                    <xsl:when test="string-length($bop-id) &gt; 0">
                        <xsl:for-each select="$contract-free-units-accounts[$next-free-units-accounts-contract = @CoId and 
                                              ./BOPAlt/AggSet/Att/@Id=$bop-id]/FUAccInfo">
                          <tr>
                            <xsl:apply-templates select="."/>
                          </tr>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="$contract-free-units-accounts[$next-free-units-accounts-contract = @CoId]/FUAccInfo">
                          <tr>
                            <xsl:apply-templates select="."/>
                          </tr>
                        </xsl:for-each>
                    </xsl:otherwise>                  
                </xsl:choose>
              </tbody>
            </table>
        </xsl:if>
      </xsl:if>

      <xsl:if test="normalize-space($remaining-free-units-accounts-contracts) != ''">
        <xsl:call-template name="free-units-accounts-by-stand-alone-contracts">
          <xsl:with-param name="list-of-unique-free-units-accounts-contracts" select="$remaining-free-units-accounts-contracts"/>
          <xsl:with-param name="header" select="'N'"/>
          <xsl:with-param name="bop-id" select="$bop-id"/>
          <xsl:with-param name="sum-sheet-contract" select="$sum-sheet-contract"/>
        </xsl:call-template>
      </xsl:if>

    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
