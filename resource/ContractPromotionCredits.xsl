<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    ContractPromotionCredits.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> HTML stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms the promotion credits of a prepaid balance.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/ContractPromotionCredits.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">

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

  <!-- stand-alone promo credits -->
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
              <h3><center>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','430')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </center></h3>
              <br/>
            </xsl:if>
    
            <h3><center> 
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','110')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$next-promo-credits-contract"/>
            </center></h3>
            <br/>

            <table border="1" width="100%" cellspacing="0" cellpadding="0">      
              <tbody>
                <tr>
                  <xsl:for-each select="$txt">
                    <!--  service -->
                    <th colspan="2" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                      <xsl:value-of select="key('txt-index','249')[@xml:lang=$lang]/@Des"/>
                    </font></th>
                    <!--  profile -->
                    <th colspan="2" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                        <xsl:value-of select="key('txt-index','139')[@xml:lang=$lang]/@Des" />
                    </font></th>
                    <!--  pricing type -->
                    <th colspan="2" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                      <xsl:value-of select="key('txt-index','253')[@xml:lang=$lang]/@Des"/>
                    </font></th>
                    <!--  credit amount -->
                    <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                      <xsl:value-of select="key('txt-index','431')[@xml:lang=$lang]/@Des"/>
                    </font></th>
                  </xsl:for-each>
                </tr>
                <xsl:for-each select="$contract-promo-credits[$next-promo-credits-contract = @CoId]/PromoCreditPerBal">
                  <xsl:apply-templates select="."/>
                  <!-- promotions -->
                  <xsl:if test="PromoItem">
                    <tr>
                      <xsl:for-each select="$txt">
                        <th/>
                        <th bgcolor="#DCDCDC" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                          <xsl:value-of select="key('txt-index','318')[@xml:lang=$lang]/@Des"/>
                        </font></th>
                        <th bgcolor="#DCDCDC" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                          <xsl:value-of select="key('txt-index','313')[@xml:lang=$lang]/@Des"/>
                        </font></th>
                        <th bgcolor="#DCDCDC" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                          <xsl:value-of select="key('txt-index','314')[@xml:lang=$lang]/@Des"/>
                        </font></th>
                        <th bgcolor="#DCDCDC" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                          <xsl:value-of select="key('txt-index','315')[@xml:lang=$lang]/@Des"/>
                        </font></th>
                        <th bgcolor="#DCDCDC" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                          <xsl:value-of select="key('txt-index','316')[@xml:lang=$lang]/@Des"/>
                        </font></th>
                        <th bgcolor="#DCDCDC" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                          <xsl:value-of select="key('txt-index','148')[@xml:lang=$lang]/@Des"/>
                        </font></th>
                      </xsl:for-each>
                    </tr>
                    <xsl:for-each select="PromoItem">
                      <tr bgcolor="#DCDCDC">
                        <xsl:if test="position()='1'">
                          <td nowrap="nowrap" bgcolor="#DCDCDC">
                            <xsl:attribute name="rowspan">
                              <xsl:value-of select="count(../PromoItem)"/>
                            </xsl:attribute>
                            <xsl:for-each select="$txt">
                              <b><font face="Arial Narrow" size="-1">
                                <xsl:value-of select="key('txt-index','309')[@xml:lang=$lang]/@Des"/>
                              </font></b>
                            </xsl:for-each>
                          </td>
                        </xsl:if>
                        <xsl:apply-templates select="." mode="credit-per-bal"/>
                      </tr>
                    </xsl:for-each>
                  </xsl:if>
                </xsl:for-each>
              </tbody>
            </table>
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
