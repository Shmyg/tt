<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    ContractPromotionCreditsFO.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> XSL-FO stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms the promotion credits for a prepaid balance.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/ContractPromotionCreditsFO.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">

  <xsl:variable name="contract-promo-credits" select="document(/Bill/Part/@File)/Document/InvoiceInfo/PromoCreditsPerCo"/>

  <!-- contract promo credits -->
  <xsl:template name="contract-promo-credits">

    <xsl:param name="co-id" select="''"/>

    <xsl:if test="$contract-promo-credits[$co-id = @CoId]">

      <xsl:call-template name="promo-credits-by-stand-alone-contracts">
        <xsl:with-param name="list-of-unique-promo-credits-contracts" select="concat($co-id,' ')"/>    
        <xsl:with-param name="header" select="'Y'"/>
        <xsl:with-param name="sum-sheet-contract" select="'Y'"/>
      </xsl:call-template>

    </xsl:if>

  </xsl:template>

  <!-- stand-alone contract promo credits -->
  <xsl:template name="promo-credits">

    <!-- build a unique list of promo credits contracts -->
    <xsl:variable name="list-of-promo-credits-contracts">
      <xsl:for-each select="$contract-promo-credits/@CoId">
        <xsl:sort select="." data-type="text"/>
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="list-of-unique-promo-credits-contracts">
      <xsl:call-template name="remove-duplicates">
        <xsl:with-param name="list-of-services" select="$list-of-promo-credits-contracts"/>
        <xsl:with-param name="last-service" select="''"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="normalize-space($list-of-unique-promo-credits-contracts)!=''">

      <xsl:call-template name="promo-credits-by-stand-alone-contracts">
        <xsl:with-param name="list-of-unique-promo-credits-contracts" select="$list-of-unique-promo-credits-contracts"/>
        <xsl:with-param name="header" select="'Y'"/>
        <xsl:with-param name="sum-sheet-contract" select="'N'"/>
      </xsl:call-template>

    </xsl:if>  

  </xsl:template>

  <!-- stand-alone promo-credits -->
  <xsl:template name="promo-credits-by-stand-alone-contracts">

    <xsl:param name="list-of-unique-promo-credits-contracts" select="''"/>
    <xsl:param name="header" select="'N'"/>
    <xsl:param name="sum-sheet-contract" select="'N'"/>

    <xsl:if test="normalize-space($list-of-unique-promo-credits-contracts)!=''">

      <xsl:variable name="next-promo-credits-contract">
        <xsl:value-of select="substring-before($list-of-unique-promo-credits-contracts, ' ')"/>
      </xsl:variable>

      <xsl:variable name="remaining-promo-credits-contracts">
        <xsl:value-of select="substring-after($list-of-unique-promo-credits-contracts, ' ')"/>
      </xsl:variable>

      <xsl:if test="(not(contains($list-of-unique-sum-sheet-contracts,$next-promo-credits-contract)) and $sum-sheet-contract = 'N') or
                        (contains($list-of-unique-sum-sheet-contracts,$next-promo-credits-contract)  and $sum-sheet-contract = 'Y')">

        <xsl:if test="$contract-promo-credits[$next-promo-credits-contract = @CoId]/PromoCreditPerBal">

            <xsl:if test="$header = 'Y'">
              <fo:block space-before="3mm" text-align="center" font-weight="bold" font-size="10pt">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','430')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </xsl:if>
    
            <fo:block space-before="3mm" text-align="center" font-weight="bold" font-size="7pt">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','110')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$next-promo-credits-contract"/>
            </fo:block>
      
            <fo:block space-before="1mm">

                <fo:table width="160mm" table-layout="fixed">
                  <fo:table-column column-width="25mm" column-number="1"/>
                  <fo:table-column column-width="25mm" column-number="2"/>
                  <fo:table-column column-width="25mm" column-number="3"/>
                  <fo:table-column column-width="25mm" column-number="4"/>
                  <fo:table-column column-width="20mm" column-number="5"/>
                  <fo:table-column column-width="20mm" column-number="6"/>
                  <fo:table-column column-width="20mm" column-number="7"/>
        
                  <fo:table-header space-after="2pt">
        
                    <fo:table-row font-size="8pt" font-weight="bold" text-align="center">
                      <xsl:for-each select="$txt">
                        <!-- service -->
                        <fo:table-cell number-columns-spanned="2">
                          <fo:block>
                            <xsl:value-of select="key('txt-index','249')[@xml:lang=$lang]/@Des"/>
                          </fo:block>
                        </fo:table-cell>
                        <!-- profile -->
                        <fo:table-cell number-columns-spanned="2">
                          <fo:block>
                            <xsl:value-of select="key('txt-index','139')[@xml:lang=$lang]/@Des" />
                          </fo:block>
                        </fo:table-cell>
                        <!-- pricing type -->
                        <fo:table-cell number-columns-spanned="2">
                          <fo:block>
                            <xsl:value-of select="key('txt-index','253')[@xml:lang=$lang]/@Des"/>
                          </fo:block>
                        </fo:table-cell>
                        <!-- credit amount -->
                        <fo:table-cell>
                          <fo:block>
                            <xsl:value-of select="key('txt-index','431')[@xml:lang=$lang]/@Des"/>
                          </fo:block>
                        </fo:table-cell>
                      </xsl:for-each>
                    </fo:table-row>
                  </fo:table-header>
                  <fo:table-body font-size="7pt">
                    <xsl:for-each select="$contract-promo-credits[$next-promo-credits-contract = @CoId]/PromoCreditPerBal">
                      <xsl:apply-templates select="."/>
                      <!-- promotions -->
                      <xsl:if test="PromoItem">
                        <fo:table-row font-size="7pt" font-weight="bold" text-align="center">
                          <xsl:for-each select="$txt">
                            <fo:table-cell>
                              <fo:block/>
                            </fo:table-cell>
                            <fo:table-cell background-color="gainsboro">
                              <fo:block>
                                <xsl:value-of select="key('txt-index','318')[@xml:lang=$lang]/@Des"/>
                              </fo:block>
                            </fo:table-cell>
                            <fo:table-cell background-color="gainsboro">
                              <fo:block>
                                <xsl:value-of select="key('txt-index','313')[@xml:lang=$lang]/@Des"/>
                              </fo:block>
                            </fo:table-cell>
                            <fo:table-cell background-color="gainsboro">
                              <fo:block>
                                <xsl:value-of select="key('txt-index','314')[@xml:lang=$lang]/@Des"/>
                              </fo:block>
                            </fo:table-cell>
                            <fo:table-cell background-color="gainsboro">
                              <fo:block>
                                <xsl:value-of select="key('txt-index','315')[@xml:lang=$lang]/@Des"/>
                              </fo:block>
                            </fo:table-cell>
                            <fo:table-cell background-color="gainsboro">
                              <fo:block>
                                <xsl:value-of select="key('txt-index','316')[@xml:lang=$lang]/@Des"/>
                              </fo:block>
                            </fo:table-cell>
                            <fo:table-cell background-color="gainsboro">
                              <fo:block>
                                <xsl:value-of select="key('txt-index','148')[@xml:lang=$lang]/@Des"/>
                              </fo:block>
                            </fo:table-cell>
                          </xsl:for-each>
                        </fo:table-row>
                        <xsl:for-each select="PromoItem">
                          <fo:table-row background-color="gainsboro">
                            <xsl:if test="position()='1'">
                              <fo:table-cell background-color="gainsboro" font-size="7pt" font-weight="bold" text-align="center" display-align="center">
                                <xsl:attribute name="number-rows-spanned">
                                  <xsl:value-of select="count(../PromoItem)"/>
                                </xsl:attribute>
                                <fo:block>
                                  <xsl:for-each select="$txt">
                                    <xsl:value-of select="key('txt-index','309')[@xml:lang=$lang]/@Des"/>
                                  </xsl:for-each>
                                </fo:block>
                              </fo:table-cell>
                            </xsl:if>
                            <xsl:apply-templates select="." mode="credit-per-bal"/>
                          </fo:table-row>
                        </xsl:for-each>
                      </xsl:if>
                    </xsl:for-each>
                  </fo:table-body>
                </fo:table>

            </fo:block>

        </xsl:if>
        
      </xsl:if>

      <xsl:if test="normalize-space($remaining-promo-credits-contracts) != ''">
        <xsl:call-template name="promo-credits-by-stand-alone-contracts">
          <xsl:with-param name="list-of-unique-promo-credits-contracts" select="$remaining-promo-credits-contracts"/>
          <xsl:with-param name="header" select="'N'"/>
          <xsl:with-param name="sum-sheet-contract" select="$sum-sheet-contract"/>
        </xsl:call-template>
      </xsl:if>

    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
