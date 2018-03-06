<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    ContractSharedAccountsCSV.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> CSV stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms shared accounts.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/ContractSharedAccountsCSV.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bgh="http://www.lhsgroup.com/BSCS/BGH" exclude-result-prefixes="xsl bgh">

  <xsl:variable name="contract-shared-accounts" select="document(/Bill/Part/@File)/Document/InvoiceInfo/SapPerCo"/>

  <!-- contract shared accounts -->
  <xsl:template name="contract-shared-accounts">

    <xsl:param name="co-id" select="''"/>

    <xsl:if test="$contract-shared-accounts[$co-id = @CoId]">

      <xsl:call-template name="shared-accounts-by-stand-alone-contracts">
        <xsl:with-param name="list-of-unique-shared-account-contracts" select="concat($co-id,' ')"/>    
        <xsl:with-param name="header" select="'Y'"/>
        <xsl:with-param name="sum-sheet-contract" select="'Y'"/>
      </xsl:call-template>

    </xsl:if>

  </xsl:template>

  <!-- stand-alone shared account contracts -->
  <xsl:template name="shared-accounts">

    <!-- build a unique list of shared account contracts -->
    <xsl:variable name="list-of-shared-account-contracts">
      <xsl:for-each select="$contract-shared-accounts/@CoId">
        <xsl:sort select="." data-type="text"/>
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="list-of-unique-shared-account-contracts">
      <xsl:call-template name="remove-duplicates">
        <xsl:with-param name="list-of-services" select="$list-of-shared-account-contracts"/>
        <xsl:with-param name="last-service" select="''"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="normalize-space($list-of-unique-shared-account-contracts)!=''">

      <xsl:call-template name="shared-accounts-by-stand-alone-contracts">
        <xsl:with-param name="list-of-unique-shared-account-contracts" select="$list-of-unique-shared-account-contracts"/>
        <xsl:with-param name="header" select="'Y'"/>
        <xsl:with-param name="sum-sheet-contract" select="'N'"/>
      </xsl:call-template>

    </xsl:if>  

  </xsl:template>

  <!-- stand-alone shared account contracts -->
  <xsl:template name="shared-accounts-by-stand-alone-contracts">

    <xsl:param name="list-of-unique-shared-account-contracts" select="''"/>
    <xsl:param name="header" select="'N'"/>
    <xsl:param name="sum-sheet-contract" select="'N'"/>

    <xsl:if test="normalize-space($list-of-unique-shared-account-contracts)!=''">

      <xsl:variable name="next-shared-account-contract">
        <xsl:value-of select="substring-before($list-of-unique-shared-account-contracts, ' ')"/>
      </xsl:variable>

      <xsl:variable name="remaining-shared-account-contracts">
        <xsl:value-of select="substring-after($list-of-unique-shared-account-contracts, ' ')"/>
      </xsl:variable>

      <xsl:if test="(not(contains($list-of-unique-sum-sheet-contracts,$next-shared-account-contract)) and $sum-sheet-contract = 'N') or
                        (contains($list-of-unique-sum-sheet-contracts,$next-shared-account-contract)  and $sum-sheet-contract = 'Y')">

        <xsl:if test="$header = 'Y'">

          <bgh:row>
            <bgh:cell>              
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','563')[@xml:lang=$lang]/@Des"/>
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
            <xsl:value-of select="$next-shared-account-contract"/>
          </bgh:cell>
        </bgh:row>

        <bgh:row>
          <bgh:cell/>
          <bgh:cell/>

          <xsl:for-each select="$txt">
            <!-- shared account -->
            <bgh:cell>
              <xsl:value-of select="key('txt-index','566')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <!-- period -->
            <bgh:cell>
              <xsl:value-of select="key('txt-index','567')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <!-- account type -->
            <bgh:cell>
              <xsl:value-of select="key('txt-index','568')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
          </xsl:for-each>
        </bgh:row>

        <xsl:for-each select="$contract-shared-accounts[$next-shared-account-contract = @CoId]/Sap">              
          <xsl:apply-templates select="."/>              
        </xsl:for-each>

        <bgh:row/>
        
      </xsl:if>

      <xsl:if test="normalize-space($remaining-shared-account-contracts) != ''">
        <xsl:call-template name="shared-accounts-by-stand-alone-contracts">
          <xsl:with-param name="list-of-unique-shared-account-contracts" select="$remaining-shared-account-contracts"/>
          <xsl:with-param name="header" select="'N'"/>
          <xsl:with-param name="sum-sheet-contract" select="$sum-sheet-contract"/>
        </xsl:call-template>
      </xsl:if>      

    </xsl:if>

  </xsl:template>

  <!-- shared account -->
  <xsl:template match="Sap">

    <bgh:row>

      <bgh:cell/>
      <bgh:cell/>
      <!-- shared account -->
      <bgh:cell>    
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@Package"/>
          <xsl:with-param name="Type"  select="'SAP'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </bgh:cell>

      <!-- period -->
      <bgh:cell>                
        <xsl:call-template name="date-time-format">
          <xsl:with-param name="date" select="Date[@Type='VALID_FROM']/@Date"/>
        </xsl:call-template>
        <xsl:text> - </xsl:text>
        <xsl:call-template name="date-time-format">
          <xsl:with-param name="date" select="Date[@Type='VALID_TO']/@Date"/>
        </xsl:call-template>
      </bgh:cell>

      <!-- account type -->
      <bgh:cell>                
        <xsl:choose>
          <xsl:when test="../@Role = 'O'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','564')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','565')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </bgh:cell>

    </bgh:row>
    
  </xsl:template>

</xsl:stylesheet>
