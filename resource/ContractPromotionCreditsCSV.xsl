<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    ContractPromotionCreditsCSV.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> CSV stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms the promotion credits of a prepaid balance.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/ContractPromotionCreditsCSV.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bgh="http://www.lhsgroup.com/BSCS/BGH" exclude-result-prefixes="xsl bgh">

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

  <!-- stand-alone promo credits -->
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
    <xsl:param name="header" select="''"/>
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

            <bgh:row>
                <bgh:cell>
                      <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','430')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                </bgh:cell>
            </bgh:row>

            <bgh:row>
                <bgh:cell>
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','110')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$next-promo-credits-contract"/>
                </bgh:cell>
            </bgh:row>
                
            <bgh:row>
                <bgh:cell/>
                <xsl:for-each select="$txt">
                    <bgh:cell>
                        <!-- service -->
                        <xsl:value-of select="key('txt-index','249')[@xml:lang=$lang]/@Des"/>
                    </bgh:cell>
                    <bgh:cell>
                        <!-- profile -->
                        <xsl:value-of select="key('txt-index','139')[@xml:lang=$lang]/@Des" />
                    </bgh:cell>
                    <bgh:cell>
                        <!-- pricing type -->
                        <xsl:value-of select="key('txt-index','253')[@xml:lang=$lang]/@Des"/>
                    </bgh:cell>
                    <bgh:cell>
                        <!-- credit amount -->
                        <xsl:value-of select="key('txt-index','431')[@xml:lang=$lang]/@Des"/>
                    </bgh:cell>
                </xsl:for-each>
            </bgh:row>

            <xsl:for-each select="$contract-promo-credits[$next-promo-credits-contract = @CoId]/PromoCreditPerBal">
            
                <xsl:apply-templates select="."/>
                
                <!-- promotions -->
                <xsl:if test="PromoItem">
                  
                    <xsl:for-each select="PromoItem">
    
                        <xsl:if test="position()='1'">
                            <bgh:row>
                                <bgh:cell/>
                                <bgh:cell>
                                    <xsl:for-each select="$txt">
                                        <xsl:value-of select="key('txt-index','309')[@xml:lang=$lang]/@Des"/>
                                    </xsl:for-each>
                                </bgh:cell>
                            </bgh:row>
                            
                            <bgh:row>
                                <bgh:cell/>
                                <bgh:cell/>
                            
                            <xsl:for-each select="$txt">
                                <bgh:cell>
                                    <!-- mechanism -->
                                    <xsl:value-of select="key('txt-index','318')[@xml:lang=$lang]/@Des"/>
                                <bgh:cell>
                                </bgh:cell>
                                    <!-- package -->
                                    <xsl:value-of select="key('txt-index','313')[@xml:lang=$lang]/@Des"/>
                                <bgh:cell>
                                </bgh:cell>
                                    <!-- model -->
                                    <xsl:value-of select="key('txt-index','314')[@xml:lang=$lang]/@Des"/>
                                <bgh:cell>
                                </bgh:cell>
                                    <!-- element -->
                                    <xsl:value-of select="key('txt-index','315')[@xml:lang=$lang]/@Des"/>
                                <bgh:cell>
                                </bgh:cell>
                                    <!-- version -->
                                    <xsl:value-of select="key('txt-index','316')[@xml:lang=$lang]/@Des"/>
                                <bgh:cell>
                                </bgh:cell>
                                    <!-- discount -->
                                    <xsl:value-of select="key('txt-index','148')[@xml:lang=$lang]/@Des"/>
                                </bgh:cell>
                            </xsl:for-each>
                              
                            </bgh:row>
                          
                        </xsl:if>

                        <xsl:apply-templates select="." mode="credit-per-bal"/>
                      
                    </xsl:for-each>

                  </xsl:if>

                </xsl:for-each>
            
            <bgh:row/>

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
