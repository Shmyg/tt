<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    ContractBundleProductsCSV.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> CSV stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms bundle products.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/ContractBundleProductsCSV.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bgh="http://www.lhsgroup.com/BSCS/BGH" exclude-result-prefixes="xsl bgh">

  <xsl:variable name="contract-bundle-products" select="document(/Bill/Part/@File)/Document/InvoiceInfo/BundleInfoPerCo"/>

  <!-- contract bundle products -->
  <xsl:template name="contract-bundle-products">

    <xsl:param name="co-id" select="''"/>
    <xsl:param name="bopind" select="''"/>
    <xsl:param name="bopseqno" select="''"/>
    <xsl:param name="boptype" select="''"/>

    <xsl:if test="$contract-bundle-products[$co-id = @CoId]">

      <xsl:call-template name="bundle-products-by-stand-alone-contracts">
        <xsl:with-param name="list-of-unique-bundle-products-contracts" select="concat($co-id,' ')"/>    
        <xsl:with-param name="header" select="'Y'"/>
        <xsl:with-param name="bopind" select="$bopind"/>
        <xsl:with-param name="bopseqno" select="$bopseqno"/>
        <xsl:with-param name="boptype" select="$boptype"/>
        <xsl:with-param name="sum-sheet-contract" select="'Y'"/>
      </xsl:call-template>

    </xsl:if>

  </xsl:template>

  <!-- stand-alone bundle products -->
  <xsl:template name="bundle-products">

    <!-- build a unique list of bundle products contracts -->
    <xsl:variable name="list-of-bundle-products-contracts">
      <xsl:for-each select="$contract-bundle-products/@CoId">
        <xsl:sort select="." data-type="text"/>
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="list-of-unique-bundle-products-contracts">
      <xsl:call-template name="remove-duplicates">
        <xsl:with-param name="list-of-services" select="$list-of-bundle-products-contracts"/>
        <xsl:with-param name="last-service" select="''"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="normalize-space($list-of-unique-bundle-products-contracts)!=''">

      <xsl:call-template name="bundle-products-by-stand-alone-contracts">
        <xsl:with-param name="list-of-unique-bundle-products-contracts" select="$list-of-unique-bundle-products-contracts"/>
        <xsl:with-param name="header" select="'Y'"/>
        <xsl:with-param name="bopind" select="''"/>
        <xsl:with-param name="bopseqno" select="''"/>
        <xsl:with-param name="boptype" select="''"/>
        <xsl:with-param name="sum-sheet-contract" select="'N'"/>
      </xsl:call-template>

    </xsl:if>  

  </xsl:template>

  <!-- stand-alone bundle products -->
  <xsl:template name="bundle-products-by-stand-alone-contracts">

    <xsl:param name="list-of-unique-bundle-products-contracts" select="''"/>
    <xsl:param name="header" select="'N'"/>
    <xsl:param name="bopind" select="''"/>
    <xsl:param name="bopseqno" select="''"/>
    <xsl:param name="boptype" select="''"/>
    <xsl:param name="sum-sheet-contract" select="'N'"/>


    <xsl:if test="normalize-space($list-of-unique-bundle-products-contracts)!=''">

      <xsl:variable name="next-bundle-products-contract">
        <xsl:value-of select="substring-before($list-of-unique-bundle-products-contracts, ' ')"/>
      </xsl:variable>

      <xsl:variable name="remaining-bundle-products-contracts">
        <xsl:value-of select="substring-after($list-of-unique-bundle-products-contracts, ' ')"/>
      </xsl:variable>

      <xsl:if test="(not(contains($list-of-unique-sum-sheet-contracts,$next-bundle-products-contract)) and $sum-sheet-contract = 'N') or
                        (contains($list-of-unique-sum-sheet-contracts,$next-bundle-products-contract)  and $sum-sheet-contract = 'Y')">

        <xsl:if test="(string-length($bopseqno) &gt; 0 and $contract-bundle-products[$next-bundle-products-contract = @CoId and 
                       ./BOPAlt/AggSet/Att/@Id=$bopseqno]/BundleInfo) or 
                       (string-length($bopseqno) = 0  and $contract-bundle-products[$next-bundle-products-contract = @CoId]/BundleInfo)">

            <xsl:if test="$header = 'Y'">
              <bgh:row>
                <bgh:cell>
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','446')[@xml:lang=$lang]/@Des"/>
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
                <xsl:value-of select="$next-bundle-products-contract"/>
              </bgh:cell>
            </bgh:row>

            <bgh:row>
                <bgh:cell/>
                <bgh:cell>
                    <!-- purchase -->
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','447')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                </bgh:cell>
            </bgh:row>
                                      
            <bgh:row>
                <bgh:cell/>
                <bgh:cell/>
            
                <xsl:for-each select="$txt">
                    <bgh:cell>
                        <!-- bundle name -->
                        <xsl:value-of select="key('txt-index','455')[@xml:lang=$lang]/@Des"/>
                    </bgh:cell>
                    <bgh:cell>
                        <!-- purchase date -->
                        <xsl:value-of select="key('txt-index','462')[@xml:lang=$lang]/@Des"/>
                    </bgh:cell>
                    <bgh:cell>
                        <!-- consumption period -->
                        <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','448')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                    </bgh:cell>
                    <bgh:cell>
                        <!-- products in bundle -->
                        <xsl:value-of select="key('txt-index','449')[@xml:lang=$lang]/@Des"/>
                    </bgh:cell>
                    <bgh:cell>
                        <!-- price -->
                        <xsl:value-of select="key('txt-index','452')[@xml:lang=$lang]/@Des"/>
                    </bgh:cell>
                </xsl:for-each>
            </bgh:row>

            <xsl:for-each select="$contract-bundle-products[$next-bundle-products-contract = @CoId]/BundleInfo">
              <xsl:call-template name="BundleInfo">
                <xsl:with-param name="co-id" select="$next-bundle-products-contract"/>
                <xsl:with-param name="bopind" select="$bopind"/>
                <xsl:with-param name="bopseqno" select="$bopseqno"/>
                <xsl:with-param name="boptype" select="$boptype"/>
              </xsl:call-template>
            </xsl:for-each>

            <bgh:row/>

        </xsl:if>

      </xsl:if>

      <xsl:if test="normalize-space($remaining-bundle-products-contracts) != ''">
        <xsl:call-template name="bundle-products-by-stand-alone-contracts">
          <xsl:with-param name="list-of-unique-bundle-products-contracts" select="$remaining-bundle-products-contracts"/>
          <xsl:with-param name="header" select="'N'"/>
          <xsl:with-param name="bopind" select="$bopind"/>
          <xsl:with-param name="bopseqno" select="$bopseqno"/>
          <xsl:with-param name="boptype" select="$boptype"/>
          <xsl:with-param name="sum-sheet-contract" select="'N'"/>
        </xsl:call-template>
      </xsl:if>

    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
