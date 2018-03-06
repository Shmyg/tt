<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    InvoiceFO.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> XSL-FO stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms invoice documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/InvoiceFO.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" xmlns:svg="http://www.w3.org/2000/svg" xmlns:svgu="http://www.ora.com/XSLTCookbook/ns/svg-utils" xmlns:external="http://ExternalFunction.xalan-c++.xml.apache.org" xmlns:math="http://exslt.org/math" xmlns:date="http://exslt.org/dates-and-times" exclude-result-prefixes="xsl cur svg svgu external math date">


  <xsl:include href="svg-utils.xsl"/>

  <xsl:variable name="pie-chart-postpaid" select="document(/Bill/Part/@File)/Document/Summary/Sums/Charge[@PT='P' and (@Id='910' or @Id='911' or @Id='912' or @Id='913') and @Type='9' and number(@Amount) &gt; '0.00']/@Amount"/>   
  <xsl:variable name="number-of-slices" select="count(document(/Bill/Part/@File)/Document/Summary/Sums/Charge[@PT='P' and (@Id='910' or @Id='911' or @Id='912' or @Id='913') and @Type='9' and number(@Amount) &gt; '0.00'])"/>

  <xsl:key name="ct"         match="InvoiceItem[Charge/@PT='P']" use="@CT"/>
  <xsl:key name="ct-prepaid" match="InvoiceItem[Charge/@PT='A' and @PrepaidTransaction='N']" use="@CT"/>
  <xsl:key name="ct-prepaid-credits" match="InvoiceItem[Charge/@PT='A' and @PrepaidTransaction='Y' and @Debit='N']" use="@CT"/>
  <xsl:key name="ct-prepaid-debits" match="InvoiceItem[Charge/@PT='A' and @PrepaidTransaction='Y' and @Debit='Y']" use="@CT"/>

  <xsl:variable name="billing-account" select="document(/Bill/Part/@File)/Document/AddressPage/BillAcc"/>

  <!-- invoice -->
  <xsl:template match="Invoice">

    <fo:table table-layout="fixed" width="160mm">
      <fo:table-column column-width="80mm" column-number="1"/>
      <fo:table-column column-width="80mm" column-number="2"/>
      <fo:table-body>
        <!-- invoice date -->
        <fo:table-row>
          <fo:table-cell>
            <fo:block space-before="6mm" font-size="8pt" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','1')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block space-before="6mm" font-size="8pt" text-align="right">
              <!-- invoice date -->
              <xsl:call-template name="date-time-format">
                <xsl:with-param name="date" select="Date[@Type='INV']/@Date"/>
              </xsl:call-template>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <!-- period -->
        <xsl:if test="$bit != 'DN'">
            <fo:table-row>
              <fo:table-cell>
                <fo:block font-size="8pt" text-align="left">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','2')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block font-size="8pt" text-align="right">
                  <!-- period start -->
                  <xsl:if test="Date[@Type='START']">
                    <xsl:call-template name="date-time-format">
                      <xsl:with-param name="date" select="Date[@Type='START']/@Date"/>
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="Date[@Type='END']">
                    <xsl:text> - </xsl:text>
                    <!-- period end -->
                    <xsl:call-template name="date-time-format">
                      <xsl:with-param name="date" select="Date[@Type='END']/@Date"/>
                    </xsl:call-template>
                  </xsl:if>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
        </xsl:if>
        <!-- payment term package -->
        <fo:table-row>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','501')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="right">
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="PaymentTerm/@TermShname"/>
                <xsl:with-param name="Type"  select="'PT'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <!-- payment term due date -->
        <fo:table-row>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','240')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="right">
              <!-- days -->
              <xsl:variable name="duration">
                <!-- return value is a duration: PnYnMnDTnH nMnS, see http://www.w3.org/TR/xmlschema-2/#duration  -->
                <xsl:call-template name="date:difference">
                  <xsl:with-param name="start" select="Date[@Type='INV']/@Date" />
                  <xsl:with-param name="end" select="Date[@Type='DUE_DATE']/@Date" />
                </xsl:call-template>
              </xsl:variable>
              <xsl:choose>
                <xsl:when test="contains($duration,'Y')">
                  <xsl:value-of select="substring-before(substring-after($duration,'P'),'Y')"/>
                  <xsl:text> </xsl:text>
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','502')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                  <xsl:if test="contains($duration,'M')">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="substring-before(substring-after($duration,'Y'),'M')"/>
                    <xsl:text> </xsl:text>
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','503')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                    <xsl:if test="contains($duration,'D')">
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="substring-before(substring-after($duration,'M'),'D')"/>
                      <xsl:text> </xsl:text>
                      <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','504')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </xsl:if>
                  </xsl:if>
                </xsl:when>                                              
                <xsl:when test="contains($duration,'M')">
                  <xsl:value-of select="substring-before(substring-after($duration,'P'),'M')"/>
                  <xsl:text> </xsl:text>
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','503')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                  <xsl:if test="contains($duration,'D')">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="substring-before(substring-after($duration,'M'),'D')"/>
                    <xsl:text> </xsl:text>
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','504')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </xsl:if>
                </xsl:when>
                <xsl:when test="contains($duration,'D')">
                  <xsl:value-of select="substring-before(substring-after($duration,'P'),'D')"/>
                  <xsl:text> </xsl:text>
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','504')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>0 </xsl:text>
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','504')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
              <!-- date -->
              <xsl:text> - </xsl:text>
              <xsl:call-template name="date-time-format">
                <xsl:with-param name="date" select="Date[@Type='DUE_DATE']/@Date"/>
              </xsl:call-template>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>        
      </fo:table-body>
    </fo:table>
    <!-- cash discounts -->
    <xsl:if test="CashDiscount">
      <fo:list-block  start-indent="2mm" provisional-distance-between-starts="10mm" provisional-label-separation="4mm">
        <xsl:for-each select="CashDiscount">
          <!-- date sorting -->
          <xsl:sort select="Date[@Type='DISCOUNT']/@Date" data-type="text" order="ascending"/>
          <xsl:variable name="discount-amount" select="Charge[@Id='12' and @Type='9' and @PT='P']/@Amount"/>
          <xsl:variable name="discount-percentage" select="Charge[@Id='12' and @Type='9' and @PT='P']/@DiscountPercentage"/>
          <xsl:variable name="total-amount" select="../InvoiceTotals/Charge[@Id='77' and @Type='5' and @PT='P']/@Amount"/>
          <fo:list-item space-before="1mm">
            <fo:list-item-label end-indent="label-end()">
              <fo:block font-family="Courier" font-size="8pt">
                <xsl:value-of select="concat(position(),'.')"/>
              </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
              <fo:block font-size="8pt">
                <!-- payment within -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','505')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
                <xsl:text> </xsl:text>
                <xsl:value-of select="@Days"/>
                <xsl:text> </xsl:text>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','504')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
                <!-- discount percentage -->
                <xsl:text> - </xsl:text>
                <xsl:call-template name="number-format">
                  <!--xsl:with-param name="number" select="$discount-amount div $total-amount * 100"/-->
                  <xsl:with-param name="number" select="$discount-percentage * 100"/>
                </xsl:call-template>
                <xsl:text> %</xsl:text>
                <xsl:text> </xsl:text>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','467')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
                <xsl:text> / </xsl:text>
                <!-- discount date -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','466')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
                <xsl:variable name="date-format">
                  <xsl:call-template name="date-time-format">
                    <xsl:with-param name="date" select="Date[@Type='DISCOUNT']/@Date"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$date-format"/>
                <xsl:text> - </xsl:text>
                <!-- discount amount -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','467')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
                <xsl:variable name="number-format">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="Charge[@Id='12' and @Type='9' and @PT='P']/@Amount"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$number-format"/>
                <xsl:text> </xsl:text>
                <xsl:for-each select="Charge[@Id='12' and @Type='9' and @PT='P']/@CurrCode">
                  <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                </xsl:for-each>
              </fo:block>
            </fo:list-item-body>
          </fo:list-item>
        </xsl:for-each>
      </fo:list-block>
    </xsl:if>

    <!-- payment method -->
    <fo:block font-size="8pt">
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','128')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
      <xsl:text> </xsl:text>
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="$billing-account/@PayMeth"/>
        <xsl:with-param name="Type"  select="'PMT'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
    </fo:block>

    <!-- receiver bank info -->
    <xsl:apply-templates select="$billing-account/FiCont"/>
    
    <!-- pie chart postpaid invoice item charges -->
    <!-- fop 0.93 svg is in the sandbox -->
    <!--
    <xsl:if test="( ( function-available('math:sin') and function-available('math:cos') ) or 
                    ( function-available('external:sin') and function-available('external:cos') ) ) and
                  $number-of-slices &gt; 1">

        <fo:block space-before="6mm" font-size="8pt" text-align="center">
            <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','540')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        </fo:block>
        <fo:block text-align="center">
          <fo:instream-foreign-object>
            <svg:svg width="125" height="125">
              <xsl:call-template name="svgu:pie">
                <xsl:with-param name="data" select="$pie-chart-postpaid"/>
                <xsl:with-param name="cx" select="62.5"/>
                <xsl:with-param name="cy" select="62.5"/>
                <xsl:with-param name="r" select="25"/>
                <xsl:with-param name="theta" select="-90"/>
              </xsl:call-template>
              <xsl:call-template name="svgu:pieLabels">
                <xsl:with-param name="data" select="$pie-chart-postpaid"/>
                <xsl:with-param name="cx" select="62.5"/>
                <xsl:with-param name="cy" select="62.5"/>
                <xsl:with-param name="r" select="35"/>
                <xsl:with-param name="theta" select="-90"/>
              </xsl:call-template>
            </svg:svg>
          </fo:instream-foreign-object>
        </fo:block>
    </xsl:if>
    -->
    <xsl:if test="DebitNote">
        <xsl:apply-templates select="DebitNote"/>
    </xsl:if>
    
    <!-- invoice items (postpaid) -->
    <xsl:if test="InvoiceItem[Charge/@PT='P']">
      <fo:block>

      <fo:table width="160mm" table-layout="fixed">
        <fo:table-column column-width="14.0mm" column-number="1"/>
        <fo:table-column column-width="23.0mm" column-number="2"/>
        <fo:table-column column-width="23.0mm" column-number="3"/>
        <fo:table-column column-width="23.0mm" column-number="4"/>
        <fo:table-column column-width="17.0mm" column-number="5"/>
        <fo:table-column column-width="10.0mm" column-number="6"/>
        <fo:table-column column-width="25.0mm" column-number="7"/>
        <fo:table-column column-width="25.0mm" column-number="8"/>
        <fo:table-header>
            <fo:table-row>
                <fo:table-cell padding-top="6mm" padding-bottom="2mm"  number-columns-spanned="8">
                  <fo:block font-size="9pt" font-weight="bold" text-align="center">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','89')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
            </fo:table-row>
          <fo:table-row>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','56')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','58')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','59')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','60')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','71')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','69')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','70')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','64')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-header>

        <fo:table-body>
          <xsl:for-each select="InvoiceItem[generate-id(.)=generate-id(key('ct',@CT)[1])]">
            <xsl:sort select="@CT" data-type="text" order="ascending"/>
            <!--
            <xsl:for-each select="key('ct',@CT)[Charge/@PT='P']">
            -->
            <xsl:for-each select="key('ct',@CT)">
              <xsl:if test="position()='1'">
                <fo:table-row>
                  <fo:table-cell padding-top="2pt" padding-bottom="1pt" number-columns-spanned="8">
                    <fo:block font-size="8pt" font-weight="bold" text-align="center">
                      <xsl:choose>
                        <xsl:when test="@CT='A'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','292')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='O'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','293')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='S'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','294')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='U'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','295')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='P'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','296')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='T'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','513')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='B'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','177')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                          <xsl:text> </xsl:text>
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','184')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>                          
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="@CT"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>
              <fo:table-row>
                <xsl:apply-templates select="."/>
              </fo:table-row>
            </xsl:for-each>
          </xsl:for-each>
        </fo:table-body>
      </fo:table>
      </fo:block>
    </xsl:if>

    <!-- tax info (postpaid) -->
    <xsl:if test="Tax[Charge/@PT='P']">
      
      <fo:block>

      <fo:table width="160mm" table-layout="fixed">
        <fo:table-column column-width="69mm" column-number="1"/>
        <fo:table-column column-width="23mm" column-number="2"/>
        <fo:table-column column-width="23mm" column-number="3"/>
        <fo:table-column column-width="23mm" column-number="4"/>
        <fo:table-column column-width="22mm" column-number="5"/>
        <fo:table-header space-after="2pt"> 
            <fo:table-row>
                <fo:table-cell padding-top="6mm" padding-bottom="2mm"  number-columns-spanned="5">
                  <fo:block font-size="9pt" font-weight="bold" text-align="center">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','70')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
            </fo:table-row>
          <fo:table-row>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','340')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','343')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','344')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','345')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','346')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-header>
        <fo:table-body>
          <xsl:for-each select="Tax[Charge/@PT='P']">
            <fo:table-row>
              <xsl:apply-templates select="."/>
            </fo:table-row>
          </xsl:for-each>
        </fo:table-body>
      </fo:table>
      </fo:block>
    </xsl:if>

    <!-- invoice items (prepaid) -->
    <xsl:if test="InvoiceItem[Charge/@PT='A' and @PrepaidTransaction='N']">
      <fo:block>

      <fo:table width="160mm" table-layout="fixed">
        <fo:table-column column-width="14.0mm" column-number="1"/>
        <fo:table-column column-width="23.0mm" column-number="2"/>
        <fo:table-column column-width="23.0mm" column-number="3"/>
        <fo:table-column column-width="23.0mm" column-number="4"/>
        <fo:table-column column-width="17.0mm" column-number="5"/>
        <fo:table-column column-width="10.0mm" column-number="6"/>
        <fo:table-column column-width="25.0mm" column-number="7"/>
        <fo:table-column column-width="25.0mm" column-number="8"/>
        <fo:table-header> 
            <fo:table-row>
                <fo:table-cell padding-top="6mm" padding-bottom="2mm"  number-columns-spanned="8">
                  <fo:block font-size="9pt" font-weight="bold" text-align="center">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','89')[@xml:lang=$lang]/@Des"/>
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="key('txt-index','286')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
            </fo:table-row>
          <fo:table-row>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <!-- quantity -->
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','56')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <!-- service -->
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','58')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>              
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <!-- package -->
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','59')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <!-- tariff model -->
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','60')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <!-- discount -->
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','71')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <!-- tax (percentage) -->
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','69')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <!-- tax -->
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','70')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <!-- net amount -->
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','64')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-header>
        <fo:table-body>
          <xsl:for-each select="InvoiceItem[generate-id(.)=generate-id(key('ct-prepaid',@CT)[1])]">
            <xsl:sort select="@CT" data-type="text" order="ascending"/>
            <!--
            <xsl:for-each select="key('ct',@CT)[Charge/@PT='A']">
            -->
            <xsl:for-each select="key('ct-prepaid',@CT)">
              <xsl:if test="position()='1'">
                <fo:table-row>
                  <fo:table-cell padding-top="2pt" padding-bottom="1pt" number-columns-spanned="8">
                    <fo:block font-size="8pt" font-weight="bold" text-align="center">
                      <xsl:choose>
                        <xsl:when test="@CT='A'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','292')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='O'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','293')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='S'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','294')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='U'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','295')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='P'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','296')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='T'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','513')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='B'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','177')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                          <xsl:text> </xsl:text>
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','184')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>                          
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="@CT"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>
              <fo:table-row>
                <xsl:apply-templates select="."/>
              </fo:table-row>
            </xsl:for-each>
          </xsl:for-each>
        </fo:table-body>
      </fo:table>
      </fo:block>
    </xsl:if>

    <!-- prepaid credits -->
    <xsl:if test="InvoiceItem[Charge/@PT='A' and @PrepaidTransaction='Y' and @Debit='N']">
    
      <fo:block>
      
      <fo:table width="160mm" table-layout="fixed">
        <fo:table-column column-width="14.0mm" column-number="1"/>
        <fo:table-column column-width="23.0mm" column-number="2"/>
        <fo:table-column column-width="23.0mm" column-number="3"/>
        <fo:table-column column-width="23.0mm" column-number="4"/>
        <fo:table-column column-width="17.0mm" column-number="5"/>
        <fo:table-column column-width="10.0mm" column-number="6"/>
        <fo:table-column column-width="25.0mm" column-number="7"/>
        <fo:table-column column-width="25.0mm" column-number="8"/>
        <fo:table-header>
            <fo:table-row>
                <fo:table-cell padding-top="6mm" padding-bottom="2mm"  number-columns-spanned="8">
                  <fo:block font-size="9pt" font-weight="bold" text-align="center">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','522')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
            </fo:table-row>
          <fo:table-row>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <!-- quantity -->
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','56')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <!-- service -->
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','58')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
              <!-- transaction type -->
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','524')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <!-- package -->
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','59')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <!-- tariff model -->
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','60')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <!-- discount -->
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','71')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <!-- tax (percentage) -->
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','69')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <!-- tax -->
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','70')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <!-- net amount -->
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','64')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-header>
        <fo:table-body>
          <xsl:for-each select="InvoiceItem[generate-id(.)=generate-id(key('ct-prepaid-credits',@CT)[1])]">
            <xsl:sort select="@CT" data-type="text" order="ascending"/>
            <xsl:for-each select="key('ct-prepaid-credits',@CT)">
              <xsl:if test="position()='1'">
                <fo:table-row>
                  <fo:table-cell padding-top="2pt" padding-bottom="1pt" number-columns-spanned="8">
                    <fo:block font-size="8pt" font-weight="bold" text-align="center">
                      <xsl:choose>
                        <xsl:when test="@CT='A'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','292')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='O'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','293')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='S'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','294')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='U'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','295')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='P'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','296')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='T'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','513')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='B'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','177')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                          <xsl:text> </xsl:text>
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','184')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>                          
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="@CT"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>
              <fo:table-row>
                <xsl:apply-templates select="."/>
              </fo:table-row>
            </xsl:for-each>
          </xsl:for-each>
        </fo:table-body>
      </fo:table>
      </fo:block>
    </xsl:if>

    <!-- prepaid debits -->
    <xsl:if test="InvoiceItem[Charge/@PT='A' and @PrepaidTransaction='Y' and @Debit='Y']">
      <fo:block>

      <fo:table width="160mm" table-layout="fixed">
        <fo:table-column column-width="14.0mm" column-number="1"/>
        <fo:table-column column-width="23.0mm" column-number="2"/>
        <fo:table-column column-width="23.0mm" column-number="3"/>
        <fo:table-column column-width="23.0mm" column-number="4"/>
        <fo:table-column column-width="17.0mm" column-number="5"/>
        <fo:table-column column-width="10.0mm" column-number="6"/>
        <fo:table-column column-width="25.0mm" column-number="7"/>
        <fo:table-column column-width="25.0mm" column-number="8"/>
        <fo:table-header> 
            <fo:table-row>
                <fo:table-cell padding-top="6mm" padding-bottom="2mm"  number-columns-spanned="8">
                  <fo:block font-size="9pt" font-weight="bold" text-align="center">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','523')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
            </fo:table-row>
          <fo:table-row>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','56')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','58')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
              <!-- transaction type -->
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','524')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','59')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','60')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','71')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','69')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','70')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','64')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-header>
        <fo:table-body>
          <xsl:for-each select="InvoiceItem[generate-id(.)=generate-id(key('ct-prepaid-debits',@CT)[1])]">
            <xsl:sort select="@CT" data-type="text" order="ascending"/>
            <xsl:for-each select="key('ct-prepaid-debits',@CT)">
              <xsl:if test="position()='1'">
                <fo:table-row>
                  <fo:table-cell padding-top="2pt" padding-bottom="1pt" number-columns-spanned="8">
                    <fo:block font-size="8pt" font-weight="bold" text-align="center">
                      <xsl:choose>
                        <xsl:when test="@CT='A'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','292')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='O'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','293')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='S'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','294')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='U'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','295')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='P'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','296')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='T'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','513')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@CT='B'">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','177')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                          <xsl:text> </xsl:text>
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','184')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>                          
                        </xsl:when>                        
                        <xsl:otherwise>
                          <xsl:value-of select="@CT"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>
              <fo:table-row>
                <xsl:apply-templates select="."/>
              </fo:table-row>
            </xsl:for-each>
          </xsl:for-each>
        </fo:table-body>
      </fo:table>
      </fo:block>
    </xsl:if>

    <!-- tax info (prepaid) -->
    <xsl:if test="Tax[Charge/@PT='A']">
      
      <fo:block>

      <fo:table width="160mm" table-layout="fixed">
        <fo:table-column column-width="69mm" column-number="1"/>
        <fo:table-column column-width="23mm" column-number="2"/>
        <fo:table-column column-width="23mm" column-number="3"/>
        <fo:table-column column-width="23mm" column-number="4"/>
        <fo:table-column column-width="22mm" column-number="5"/>
        <fo:table-header space-after="2pt"> 
            <fo:table-row>
                <fo:table-cell padding-top="6mm" padding-bottom="2mm"  number-columns-spanned="5">
                  <fo:block font-size="9pt" font-weight="bold" text-align="center">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','70')[@xml:lang=$lang]/@Des"/>
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="key('txt-index','286')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
            </fo:table-row>
          <fo:table-row>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','340')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','343')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','344')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','345')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block font-size="8pt" font-weight="bold" text-align="center">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','346')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-header>
        <fo:table-body>
          <xsl:for-each select="Tax[Charge/@PT='A']">
            <fo:table-row>
              <xsl:apply-templates select="."/>
            </fo:table-row>
          </xsl:for-each>
        </fo:table-body>
      </fo:table>
      </fo:block>
    </xsl:if>

    <!-- Discount totals -->
    <xsl:if test="DiscountTotals">
      <xsl:apply-templates select="DiscountTotals"/>
    </xsl:if>

    <!-- Invoice totals (postpaid) -->
    <xsl:apply-templates select="InvoiceTotals[Charge[@PT='P' and 0 != number(@Amount) ] ]" mode="postpaid"/>

    <!-- Invoice totals (prepaid) -->
    <xsl:apply-templates select="InvoiceTotals[Charge[@PT='A' and 0 != number(@Amount) ] ]" mode="prepaid"/>

  </xsl:template>

  <!-- invoice item -->
  <xsl:template match="InvoiceItem">
    <!-- quantity -->
    <fo:table-cell>
      <fo:block font-size="8pt" text-align="center">
        <xsl:value-of select="@NumItem"/>
      </fo:block>
    </fo:table-cell>
    <!-- service -->
    <xsl:apply-templates select="AggSet" mode="invoice-item"/>
    <!-- promotion -->
    <xsl:choose>
      <xsl:when test="PromoItem">
        <fo:table-cell>
          <fo:block font-size="8pt" text-align="center">
            <xsl:for-each select="PromoItem">
              <xsl:apply-templates select="." mode="invoice-item"/>
              <xsl:text>
              </xsl:text>
            </xsl:for-each>
          </fo:block>
        </fo:table-cell>
      </xsl:when>
      <xsl:otherwise>
        <fo:table-cell>
          <fo:block font-size="8pt" text-align="center">
            <xsl:text>-</xsl:text>
          </fo:block>
        </fo:table-cell>
      </xsl:otherwise>
    </xsl:choose>
    <!-- tax -->
    <xsl:choose>
      <xsl:when test="Tax">
        <!--
        <xsl:apply-templates select="Tax"/>
        -->
        <fo:table-cell>
          <fo:block>
            <!-- tax rate -->
            <xsl:for-each select="Tax">
              <xsl:variable name="tax-rate">
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="@Rate"/>
                </xsl:call-template>
              </xsl:variable>
              <fo:block font-size="8pt" text-align="right">
                <xsl:value-of select="$tax-rate"/>
              </fo:block>
            </xsl:for-each>
          </fo:block>
        </fo:table-cell>
        <fo:table-cell>
          <fo:block>
            <!-- tax amount -->
            <xsl:for-each select="Tax/Charge">
              <fo:block font-size="8pt" text-align="right">
                <xsl:variable name="number-format">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$number-format"/>
                <xsl:text> </xsl:text>
                <xsl:for-each select="@CurrCode">
                  <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                </xsl:for-each>
              </fo:block>
            </xsl:for-each>
          </fo:block>
        </fo:table-cell>
      </xsl:when>
      <xsl:otherwise>
        <fo:table-cell number-columns-spanned="2"><fo:block/></fo:table-cell>
      </xsl:otherwise>
    </xsl:choose>
    <!-- print net amount (multiple currency) -->
    <fo:table-cell>
      <xsl:for-each select="Charge[@Id='125']">
        <fo:block font-size="8pt" text-align="right">
          <xsl:variable name="number-format">
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="@Amount"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:value-of select="$number-format"/>
          <xsl:text> </xsl:text>
          <xsl:for-each select="@CurrCode">
            <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
          </xsl:for-each>
        </fo:block>
      </xsl:for-each>
    </fo:table-cell>

  </xsl:template>

  <!-- invoice totals of postpaid amounts -->
  <xsl:template match="InvoiceTotals" mode="postpaid">
    <fo:block>
      <fo:block space-before="6mm" font-size="9pt" font-weight="bold" text-align="center">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','74')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </fo:block>

      <fo:table width="160mm" table-layout="fixed">
        <fo:table-column column-width="80mm" column-number="1"/>
        <fo:table-column column-width="80mm" column-number="2"/>
      
        <fo:table-body> 
          <xsl:if test="Charge[@PT='P' and @Id='79' and @Type!='19']">
        <fo:table-row>
          <fo:table-cell padding-top="2pt" border-top-style="solid" border-top-width="0.01pt" border-top-color="black">
            <fo:block font-size="8pt" text-align="left">
              <!-- invoice net (multiple currency) -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','80')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell padding-top="2pt" border-top-style="solid" border-top-width="0.01pt" border-top-color="black">
            <xsl:for-each select="Charge[@PT='P' and @Id='79' and @Type!='19']">
              <fo:block font-size="8pt" text-align="right">
                <xsl:variable name="number-format">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$number-format"/>
                <xsl:text> </xsl:text>
                <xsl:for-each select="@CurrCode">
                  <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                </xsl:for-each>
              </fo:block>
            </xsl:for-each>
          </fo:table-cell>
        </fo:table-row>
      </xsl:if>
          <!-- invoice gross (multiple currency) -->
          <xsl:if test="Charge[@PT='P' and @Id='77' and @Type!='19']">
        <fo:table-row>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','77')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
              <fo:table-cell>
            <xsl:for-each select="Charge[@PT='P' and @Id='77' and @Type!='19']">
              <fo:block font-size="8pt" text-align="right">
                <xsl:variable name="number-format">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$number-format"/>
                <xsl:text> </xsl:text>
                <xsl:for-each select="@CurrCode">
                  <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                </xsl:for-each>
              </fo:block>
            </xsl:for-each>
          </fo:table-cell>
        </fo:table-row>
      </xsl:if>
          <!-- own amount gross (multiple currency) -->
          <xsl:if test="Charge[@PT='P' and @Id='703']">
        <fo:table-row>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','442')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <xsl:for-each select="Charge[@PT='P' and @Id='703']">
              <fo:block font-size="8pt" text-align="right">
                <xsl:variable name="number-format">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$number-format"/>
                <xsl:text> </xsl:text>
                <xsl:for-each select="@CurrCode">
                  <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                </xsl:for-each>
              </fo:block>
            </xsl:for-each>
          </fo:table-cell>
        </fo:table-row>
      </xsl:if>
          <!-- collected amount gross (multiple currency) -->
          <xsl:if test="Charge[@PT='P' and @Id='704']">
        <fo:table-row>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','443')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <xsl:for-each select="Charge[@PT='P' and @Id='704']">
              <fo:block font-size="8pt" text-align="right">
                <xsl:variable name="number-format">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$number-format"/>
                <xsl:text> </xsl:text>
                <xsl:for-each select="@CurrCode">
                  <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                </xsl:for-each>
              </fo:block>
            </xsl:for-each>
          </fo:table-cell>
        </fo:table-row>
      </xsl:if>
          <!-- old balance (multiple currency) -->
          <xsl:if test="Charge[@PT='P' and @Id='76']">
        <fo:table-row>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','76')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <xsl:for-each select="Charge[@PT='P' and @Id='76']">
              <fo:block font-size="8pt" text-align="right">
                <xsl:variable name="number-format">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$number-format"/>
                <xsl:text> </xsl:text>
                <xsl:for-each select="@CurrCode">
                  <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                </xsl:for-each>
              </fo:block>
            </xsl:for-each>
          </fo:table-cell>
        </fo:table-row>
      </xsl:if>
          <!-- new balance (multiple currency) -->
          <xsl:if test="Charge[@PT='P' and @Id='78']">
        <fo:table-row>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','79')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <xsl:for-each select="Charge[@PT='P' and @Id='78']">
              <fo:block font-size="8pt" text-align="right">
                <xsl:variable name="number-format">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$number-format"/>
                <xsl:text> </xsl:text>
                <xsl:for-each select="@CurrCode">
                  <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                </xsl:for-each>
              </fo:block>
            </xsl:for-each>
          </fo:table-cell>
        </fo:table-row>
      </xsl:if>
          <!-- amount to pay (multiple currency) -->
          <xsl:if test="Charge[@PT='P' and @Id='178']">
        <fo:table-row>
          <fo:table-cell>
            <fo:block font-size="8pt" color="red" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','82')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <xsl:for-each select="Charge[@PT='P' and @Id='178']">
              <fo:block font-size="8pt" color="red" text-align="right">
                <xsl:variable name="number-format">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$number-format"/>
                <xsl:text> </xsl:text>
                <xsl:for-each select="@CurrCode">
                  <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                </xsl:for-each>
              </fo:block>
            </xsl:for-each>
          </fo:table-cell>
        </fo:table-row>
          </xsl:if>
        </fo:table-body>
      </fo:table>
    </fo:block>
  </xsl:template>

  <!-- invoice totals of prepaid amounts -->
  <xsl:template match="InvoiceTotals" mode="prepaid">
        
    <fo:block>
      <fo:block space-before="6mm" font-size="9pt" font-weight="bold" text-align="center">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','74')[@xml:lang=$lang]/@Des"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="key('txt-index','286')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </fo:block>
    
      <fo:table width="160mm" table-layout="fixed">
        <fo:table-column column-width="80mm" column-number="1"/>
        <fo:table-column column-width="80mm" column-number="2"/>
        <fo:table-body>
          <!-- invoice net (multiple currency) -->
          <xsl:if test="Charge[@PT='A' and @Id='79' and @Type!='19']">
        <fo:table-row>
          <fo:table-cell padding-top="2pt" border-top-style="solid" border-top-width="0.01pt" border-top-color="black">
            <fo:block font-size="8pt" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','80')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell padding-top="2pt" border-top-style="solid" border-top-width="0.01pt" border-top-color="black">
            <xsl:for-each select="Charge[@PT='A' and @Id='79' and @Type!='19']">
              <fo:block font-size="8pt" text-align="right">
                <xsl:variable name="number-format">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$number-format"/>
                <xsl:text> </xsl:text>
                <xsl:for-each select="@CurrCode">
                  <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                </xsl:for-each>
              </fo:block>
            </xsl:for-each>
          </fo:table-cell>
        </fo:table-row>
      </xsl:if>
          <!-- invoice gross (multiple currency) -->
          <xsl:if test="Charge[@PT='A' and @Id='77' and @Type!='19']">
        <fo:table-row>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','77')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <xsl:for-each select="Charge[@PT='A' and @Id='77' and @Type!='19']">
              <fo:block font-size="8pt" text-align="right">
                <xsl:variable name="number-format">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$number-format"/>
                <xsl:text> </xsl:text>
                <xsl:for-each select="@CurrCode">
                  <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                </xsl:for-each>
              </fo:block>
            </xsl:for-each>
          </fo:table-cell>
        </fo:table-row>
      </xsl:if>
          <!-- old balance (multiple currency) -->
          <xsl:if test="Charge[@Id='700' and @PT='A']">
        <fo:table-row>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','427')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <xsl:for-each select="Charge[@PT='A' and @Id='700']">
              <fo:block font-size="8pt" text-align="right">
                <xsl:variable name="number-format">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$number-format"/>
                <xsl:text> </xsl:text>
                <xsl:for-each select="@CurrCode">
                  <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                </xsl:for-each>
              </fo:block>
            </xsl:for-each>
          </fo:table-cell>
        </fo:table-row>
          </xsl:if>
          <!-- new balance (multiple currency) -->
          <xsl:if test="Charge[@Id='701' and @PT='A']">        
        <fo:table-row>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','428')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <xsl:for-each select="Charge[@PT='A' and @Id='701']">
              <fo:block font-size="8pt" text-align="right">
                <xsl:variable name="number-format">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$number-format"/>
                <xsl:text> </xsl:text>
                <xsl:for-each select="@CurrCode">
                  <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                </xsl:for-each>
              </fo:block>
            </xsl:for-each>
          </fo:table-cell>
        </fo:table-row>
          </xsl:if>
          <!-- amount to pay (multiple currency) -->
          <xsl:if test="Charge[@Id='702' and @PT='A']">
        <fo:table-row>
          <fo:table-cell>
            <fo:block font-size="8pt" color="red" text-align="left">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','429')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <xsl:for-each select="Charge[@PT='A' and @Id='702']">
              <fo:block font-size="8pt" color="red" text-align="right">
                <xsl:variable name="number-format">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$number-format"/>
                <xsl:text> </xsl:text>
                <xsl:for-each select="@CurrCode">
                  <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                </xsl:for-each>
              </fo:block>
            </xsl:for-each>
          </fo:table-cell>
        </fo:table-row>
          </xsl:if>
        </fo:table-body>
      </fo:table>
    </fo:block>
  </xsl:template>

  <!-- discount totals -->
  <xsl:template match="DiscountTotals">

    <fo:table width="160mm" table-layout="fixed" space-before="6mm">
      <fo:table-column column-width="80mm" column-number="1"/>
      <fo:table-column column-width="80mm" column-number="2"/>

      <fo:table-header space-after="2pt"> 
        <fo:table-row>
          <fo:table-cell number-columns-spanned="2" padding-after="2mm">
            <fo:block font-weight="bold" font-size="9pt" text-align="center">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','397')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <fo:table-row font-size="8pt" font-weight="bold" text-align="center">
          <xsl:for-each select="$txt">
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block>
                <xsl:value-of select="key('txt-index','157')[@xml:lang=$lang]/@Des"/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
              <fo:block>
               <xsl:value-of select="key('txt-index','158')[@xml:lang=$lang]/@Des"/>
              </fo:block>
            </fo:table-cell>
          </xsl:for-each>
        </fo:table-row>
      </fo:table-header>

      <fo:table-body font-size="8pt" >
        <!-- monetary discount info -->
        <fo:table-row>
          <fo:table-cell text-align="right">            
            <fo:block>
              <xsl:for-each select="Charge[@Id='56']">
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="@Amount"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:for-each select="@CurrCode">
                  <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                </xsl:for-each>
              </xsl:for-each>
            </fo:block>            
          </fo:table-cell>
          <fo:table-cell text-align="right">
            <fo:block>
              <xsl:for-each select="Charge[@Id='55']">
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="@Amount"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:for-each select="@CurrCode">
                  <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                </xsl:for-each>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <!-- non monetary discount info -->
        <xsl:for-each select="DiscountValue">
          <fo:table-row>
            <xsl:apply-templates select="."/>
          </fo:table-row>
        </xsl:for-each>
      </fo:table-body>
    </fo:table>

  </xsl:template>

  <!-- tax -->
  <xsl:template match="Tax">

    <xsl:variable name="tax-rate">
      <xsl:call-template name="number-format">
        <xsl:with-param name="number" select="@Rate"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="name(..)='InvoiceItem'">
        <fo:table-cell>
          <!-- tax rate -->
          <fo:block font-size="8pt" text-align="center">
            <xsl:value-of select="$tax-rate"/>
          </fo:block>
        </fo:table-cell>
        <fo:table-cell>
          <!-- tax amount (multiple currency) -->
          <xsl:for-each select="Charge">
            <fo:block font-size="8pt" text-align="right">
              <xsl:variable name="number-format">
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="@Amount"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:value-of select="$number-format"/>
              <xsl:text> </xsl:text>
              <xsl:for-each select="@CurrCode">
                <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
            </fo:block>
          </xsl:for-each>
        </fo:table-cell>
      </xsl:when>
      <xsl:when test="name(..)='Invoice'">
        <fo:table-cell>
          <fo:block font-size="8pt" text-align="center">
            <!-- tax category -->
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="@Cat"/>
              <xsl:with-param name="Type"  select="'TCA'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </fo:block>
        </fo:table-cell>
        <fo:table-cell>
          <fo:block font-size="8pt" text-align="center">
            <!-- tax rate -->
            <xsl:value-of select="$tax-rate"/>
          </fo:block>
        </fo:table-cell>
        <fo:table-cell>
          <fo:block font-size="8pt" text-align="center">
            <!-- tax calculation method -->
            <xsl:choose>
              <xsl:when test="@CalcMethod='A'">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','347')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </xsl:when>
              <xsl:when test="@CalcMethod='R'">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','348')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </xsl:when>
              <xsl:when test="@CalcMethod='M'">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','349')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@CalcMethod"/>
              </xsl:otherwise>
            </xsl:choose>
          </fo:block>
        </fo:table-cell>
        <fo:table-cell>
          <fo:block font-size="8pt" text-align="center">
            <!-- tax exemption -->
            <xsl:choose>
              <xsl:when test="@Exemption='S'">
                <xsl:text>-</xsl:text>
              </xsl:when>
              <xsl:when test="@CalcMethod='E'">
                <xsl:text>+</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@Exemption"/>
              </xsl:otherwise>
            </xsl:choose>
          </fo:block>
        </fo:table-cell>
        <!-- total tax amount (multiple currency) -->
        <fo:table-cell>
          <xsl:for-each select="Charge[@Id='124']">
            <fo:block font-size="8pt" text-align="right">
              <xsl:variable name="number-format">
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="@Amount"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:value-of select="$number-format"/>
              <xsl:text> </xsl:text>
              <xsl:for-each select="@CurrCode">
                <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
            </fo:block>
          </xsl:for-each>
        </fo:table-cell>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>
  
  <!-- Debit Note -->
  <xsl:template match="DebitNote">
    
    <fo:block space-before="6mm" font-size="8pt">
      <fo:table table-layout="fixed" width="160mm">
        <fo:table-column column-width="80mm" column-number="1"/>
        <fo:table-column column-width="80mm" column-number="2"/>
        <fo:table-body>
          <!-- Purpose -->
          <fo:table-row>
            <fo:table-cell>
              <fo:block>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','530')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block text-align="right">
                <xsl:value-of select="@Purpose"/>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
          <!-- Referenced documents -->
          <fo:table-row>
            <fo:table-cell>
              <fo:block>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','531')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <xsl:for-each select="DocRef">
                  <fo:block text-align="right">
                    <xsl:value-of select="@RefNum"/>
                  </fo:block>
              </xsl:for-each>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </fo:block>
    
  </xsl:template>

</xsl:stylesheet>
