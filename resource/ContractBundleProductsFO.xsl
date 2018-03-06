<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    ContractBundleProductsFO.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> XSL-FO stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms the bundle products.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/ContractBundleProductsFO.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">

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

  <!-- stand-alone contract bundle products -->
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

  <!-- stand-alone bundle-products -->
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
                       ( string-length($bopseqno) = 0  and $contract-bundle-products[$next-bundle-products-contract = @CoId]/BundleInfo)">

            <xsl:if test="$header = 'Y'">
              <fo:block space-before="3mm" text-align="center" font-weight="bold" font-size="10pt">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','446')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </xsl:if>
    
            <fo:block space-before="3mm" text-align="center" font-weight="bold" font-size="7pt">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','110')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$next-bundle-products-contract"/>
            </fo:block>
      
            <fo:block space-before="1mm">

                <fo:table width="160mm" table-layout="fixed">
                  <fo:table-column column-width="32mm" column-number="1"/>
                  <fo:table-column column-width="32mm" column-number="2"/>
                  <fo:table-column column-width="32mm" column-number="3"/>
                  <fo:table-column column-width="32mm" column-number="4"/>
                  <fo:table-column column-width="32mm" column-number="5"/>
      
                  <fo:table-header space-after="2pt">

                    <fo:table-row font-size="7pt" font-weight="bold" text-align="center">
                      <!-- purchase -->
                      <fo:table-cell number-columns-spanned="5" padding-after="1mm">
                        <fo:block text-align="center" font-weight="bold" font-size="9pt">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','447')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row font-size="7pt" font-weight="bold" text-align="center">
                      <xsl:for-each select="$txt">
                        <!-- bundle name -->
                        <fo:table-cell>
                          <fo:block>
                            <xsl:value-of select="key('txt-index','455')[@xml:lang=$lang]/@Des"/>
                          </fo:block>
                        </fo:table-cell>
                        <!-- purchase date -->
                        <fo:table-cell>
                          <fo:block>
                            <xsl:value-of select="key('txt-index','462')[@xml:lang=$lang]/@Des"/>
                          </fo:block>
                        </fo:table-cell>
                        <!-- consumption period -->
                        <fo:table-cell>
                          <fo:block>
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','448')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </fo:block>
                        </fo:table-cell>
                        <!-- products in bundle -->
                        <fo:table-cell>
                          <fo:block>
                            <xsl:value-of select="key('txt-index','449')[@xml:lang=$lang]/@Des"/>
                          </fo:block>
                        </fo:table-cell>
                        <!-- price -->
                        <fo:table-cell>
                          <fo:block>
                            <xsl:value-of select="key('txt-index','452')[@xml:lang=$lang]/@Des"/>
                          </fo:block>
                        </fo:table-cell>
                      </xsl:for-each>
                    </fo:table-row>
                  </fo:table-header>
                  <fo:table-body font-size="7pt">
                    <xsl:for-each select="$contract-bundle-products[$next-bundle-products-contract = @CoId]/BundleInfo">
                      <xsl:call-template name="BundleInfo">
                        <xsl:with-param name="co-id" select="$next-bundle-products-contract"/>
                        <xsl:with-param name="bopind" select="$bopind"/>
                        <xsl:with-param name="bopseqno" select="$bopseqno"/>
                        <xsl:with-param name="boptype" select="$boptype"/>
                      </xsl:call-template>
                    </xsl:for-each>
                  </fo:table-body>
                </fo:table>

            </fo:block>

        </xsl:if>
        
      </xsl:if>

      <xsl:if test="normalize-space($remaining-bundle-products-contracts) != ''">
        <xsl:call-template name="bundle-products-by-stand-alone-contracts">
          <xsl:with-param name="list-of-unique-bundle-products-contracts" select="$remaining-bundle-products-contracts"/>
          <xsl:with-param name="header" select="'N'"/>
          <xsl:with-param name="bopind" select="$bopind"/>
          <xsl:with-param name="bopseqno" select="$bopseqno"/>
          <xsl:with-param name="boptype" select="$boptype"/>
          <xsl:with-param name="sum-sheet-contract" select="$sum-sheet-contract"/>
        </xsl:call-template>
      </xsl:if>

    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
