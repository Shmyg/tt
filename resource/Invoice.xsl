<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    Invoice.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> HTML stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms invoice documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/Invoice.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" xmlns:svg="http://www.w3.org/2000/svg" xmlns:svgu="http://www.ora.com/XSLTCookbook/ns/svg-utils" xmlns:date="http://exslt.org/dates-and-times" exclude-result-prefixes="xsl cur svg svgu date">

  <xsl:key name="ct"         match="InvoiceItem[Charge/@PT='P']" use="@CT"/>
  <xsl:key name="ct-prepaid" match="InvoiceItem[Charge/@PT='A' and @PrepaidTransaction='N']" use="@CT"/>
  <xsl:key name="ct-prepaid-credits" match="InvoiceItem[Charge/@PT='A' and @PrepaidTransaction='Y' and @Debit='N']" use="@CT"/>
  <xsl:key name="ct-prepaid-debits" match="InvoiceItem[Charge/@PT='A' and @PrepaidTransaction='Y' and @Debit='Y']" use="@CT"/>
  <!--
  <xsl:include href="svg-utils.xsl"/>
  -->
  <xsl:variable name="pie-chart-postpaid" select="document(/Bill/Part/@File)/Document/Summary/Sums/Charge[@PT='P' and (@Id='910' or @Id='911' or @Id='912' or @Id='913') and @Type='9' and number(@Amount) != '0.00']/@Amount"/>

  <xsl:variable name="billing-account" select="document(/Bill/Part/@File)/Document/AddressPage/BillAcc"/>

  <!-- invoice -->
  <xsl:template match="Invoice">

      <!-- invoice date, period, due date -->
      <p>
        <xsl:for-each select="Date">

          <xsl:variable name="date-format">
            <xsl:call-template name="date-time-format">
              <xsl:with-param name="date" select="@Date"/>
            </xsl:call-template>
          </xsl:variable>

          <xsl:choose>
            <!-- invoicing date -->
            <xsl:when test="@Type='INV'">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','1')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
              <xsl:text> </xsl:text>
              <i><xsl:value-of select="$date-format"/></i><br/>
            </xsl:when>          
            <!-- billing period start ( not for debit notes ) -->
            <xsl:when test="@Type='START' and $bit != 'DN'">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','2')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
              <xsl:text> </xsl:text>
              <i><xsl:value-of select="$date-format"/></i>
            </xsl:when>
            <!-- billing period end ( not for debit notes ) -->
            <xsl:when test="@Type='END' and $bit != 'DN'">
              <xsl:text> </xsl:text>
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','3')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
              <xsl:text> </xsl:text>
              <i><xsl:value-of select="$date-format"/></i><br/>
            </xsl:when>
            <xsl:otherwise/>
          </xsl:choose>
        </xsl:for-each>
        <!-- flexible payment term -->
        <xsl:if test="PaymentTerm">
          <!-- payment term package -->
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','501')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
          <xsl:text> </xsl:text>
          <i>
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="PaymentTerm/@TermShname"/>
              <xsl:with-param name="Type"  select="'PT'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </i><br/>
          <!-- payment term due date -->
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','240')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
          <xsl:text> </xsl:text>
          <i>
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
          </i>
          <!-- payment term cash discounts -->
          <xsl:if test="CashDiscount">
            <ol>
              <xsl:for-each select="CashDiscount">
                <!-- date sorting -->
                <xsl:sort select="Date[@Type='DISCOUNT']/@Date" data-type="text" order="ascending"/>
                <xsl:variable name="discount-amount" select="Charge[@Id='12' and @Type='9' and @PT='P']/@Amount"/>
                <xsl:variable name="discount-percentage" select="Charge[@Id='12' and @Type='9' and @PT='P']/@DiscountPercentage"/>
                <xsl:variable name="total-amount" select="../InvoiceTotals/Charge[@Id='77' and @Type='5' and @PT='P']/@Amount"/>
                <li>
                  <!-- payment within -->
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','505')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                  <xsl:text> </xsl:text>
                  <i>
                  <xsl:value-of select="@Days"/>
                  <xsl:text> </xsl:text>
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','504')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>                
                  <!-- discount percentage -->
                  <xsl:text> - </xsl:text>
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="$discount-percentage * 100"/>
                  </xsl:call-template>
                  <xsl:text> %</xsl:text>
                  <xsl:text> </xsl:text>
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','467')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                  </i>
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
                  <i><xsl:value-of select="$date-format"/></i>
                  <xsl:text> - </xsl:text>
                  <!-- discount -->
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','467')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                  <xsl:variable name="number-format">
                    <xsl:call-template name="number-format">
                      <xsl:with-param name="number" select="$discount-amount"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:text> </xsl:text>
                  <i>
                    <xsl:value-of select="$number-format"/>
                    <xsl:text> </xsl:text>
                    <xsl:for-each select="Charge[@Id='12' and @Type='9' and @PT='P']/@CurrCode">
                      <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                    </xsl:for-each>
                  </i>
                </li>
              </xsl:for-each>
            </ol>
          </xsl:if>
        </xsl:if>
        <!-- payment method -->
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','128')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>                     
        <xsl:text> </xsl:text>
        <i>
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="$billing-account/@PayMeth"/>
            <xsl:with-param name="Type"  select="'PMT'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
        </i>
        <br/>
        <!-- receiver account / bank info -->
        <xsl:apply-templates select="$billing-account/FiCont" mode="receiver"/>
      </p>
      <!-- pie chart postpaid invoice item charges -->
      <!-- to render SVG objects (pie chart's, barcode's) you need IE >= 5.5 and the plugin
           Adobe SVG Viewer, see http://www.adobe.com/svg -->
      <!--
      <div align="center">
        <svg:svg width="250" height="250">
          <xsl:call-template name="svgu:pie">
            <xsl:with-param name="data" select="$pie-chart-postpaid"/>
            <xsl:with-param name="cx" select="125"/>
            <xsl:with-param name="cy" select="125"/>
            <xsl:with-param name="r" select="50"/>
            <xsl:with-param name="theta" select="-90"/>
          </xsl:call-template>
          <xsl:call-template name="svgu:pieLabels">
            <xsl:with-param name="data" select="$pie-chart-postpaid"/>
            <xsl:with-param name="cx" select="125"/>
            <xsl:with-param name="cy" select="125"/>
            <xsl:with-param name="r" select="70"/>
            <xsl:with-param name="theta" select="-90"/>
          </xsl:call-template>
        </svg:svg>
      </div>
      -->
    <xsl:if test="DebitNote">
        <xsl:apply-templates select="DebitNote"/>
    </xsl:if>
      
      <!--  invoice items  (postpaid)  -->
      <xsl:if test="InvoiceItem[Charge/@PT='P']">
        <table width="100%" border="1" cellspacing="0" cellpadding="0">
          <thead>
            <tr>
              <td colspan="10"><font size="-1"><b>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','89')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </b></font></td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <xsl:for-each select="$txt">
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','291')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','56')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','58')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','59')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','60')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','71')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','69')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','70')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','64')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','65')[@xml:lang=$lang]/@Des"/>
                </font></th>
              </xsl:for-each>
            </tr>
            <!-- charge type grouping -->
            <xsl:for-each select="InvoiceItem[generate-id(.)=generate-id(key('ct',@CT)[1])]">
              <!-- charge type sorting -->
              <xsl:sort select="@CT" data-type="text" order="ascending"/>
              <!-- charge type processing -->
              <!--
              <xsl:for-each select="key('ct',@CT)[Charge/@PT='P']">
              -->
              <xsl:for-each select="key('ct',@CT)">
                <tr>
                  <xsl:if test="position()='1'">
                    <td nowrap="nowrap" align="center">
                      <xsl:attribute name="rowspan">
                        <xsl:value-of select="count(key('ct',@CT))"/>
                      </xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="@CT='A'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','292')[@xml:lang=$lang]/@Des"/>
                           </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='O'">
                         <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','293')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='S'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','294')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='U'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','295')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='P'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','296')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='T'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','513')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='B'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','177')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                            <xsl:text> </xsl:text>
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','184')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:otherwise>
                          <font size="-1">
                            <xsl:value-of select="@CT"/>
                          </font>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                  </xsl:if>
                  <xsl:apply-templates select="."/>
                </tr>
              </xsl:for-each>
            </xsl:for-each>
          </tbody>
        </table>
      </xsl:if>

      <!--   tax (postpaid)  -->
      <xsl:if test="Tax[Charge/@PT='P']">
        <br/>
        <table border="1" width="100%" cellspacing="0" cellpadding="0">
          <thead>
            <tr>
              <td colspan="8"><font size="-1"><b>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','70')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </b></font></td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <xsl:for-each select="$txt">
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','340')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','343')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','344')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','345')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','346')[@xml:lang=$lang]/@Des"/>
                </font></th>
              </xsl:for-each>
            </tr>
            <xsl:for-each select="Tax[Charge/@PT='P']">
              <xsl:apply-templates select="."/>
            </xsl:for-each>
          </tbody>
        </table>
      </xsl:if>
      <br/>

      <!--  invoice items  (prepaid)  -->
      <xsl:if test="InvoiceItem[Charge/@PT='A' and @PrepaidTransaction='N']">
        <table width="100%" border="1" cellspacing="0" cellpadding="0">
          <thead>
            <tr>
              <td colspan="10"><font size="-1"><b>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','89')[@xml:lang=$lang]/@Des"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="key('txt-index','286')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </b></font></td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <xsl:for-each select="$txt">
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','291')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','56')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','58')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','59')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','60')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','71')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','69')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','70')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','64')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','65')[@xml:lang=$lang]/@Des"/>
                </font></th>
              </xsl:for-each>
            </tr>
            <!-- charge type grouping -->
            <xsl:for-each select="InvoiceItem[generate-id(.)=generate-id(key('ct-prepaid',@CT)[1])]">
              <!-- charge type sorting -->
              <xsl:sort select="@CT" data-type="text" order="ascending"/>
              <!-- charge type processing -->
              <!--
              <xsl:for-each select="key('ct',@CT)[Charge/@PT='A']">
              -->
              <xsl:for-each select="key('ct-prepaid',@CT)">
                <tr>
                  <xsl:if test="position()='1'">
                    <td nowrap="nowrap" align="center">
                      <xsl:attribute name="rowspan">
                        <xsl:value-of select="count(key('ct-prepaid',@CT))"/>
                      </xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="@CT='A'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','292')[@xml:lang=$lang]/@Des"/>
                           </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='O'">
                         <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','293')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='S'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','294')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='U'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','295')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='P'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','296')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='T'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','513')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='B'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','177')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                            <xsl:text> </xsl:text>
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','184')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:otherwise>
                          <font size="-1">
                            <xsl:value-of select="@CT"/>
                          </font>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                  </xsl:if>
                  <xsl:apply-templates select="."/>
                </tr>
              </xsl:for-each>
            </xsl:for-each>
          </tbody>
        </table>
        <br/>
      </xsl:if>

      <!--  prepaid credits  -->
      <xsl:if test="InvoiceItem[Charge/@PT='A' and @PrepaidTransaction='Y' and @Debit='N']">
        <table width="100%" border="1" cellspacing="0" cellpadding="0">
          <thead>
            <tr>
              <td colspan="10"><font size="-1"><b>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','522')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </b></font></td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <xsl:for-each select="$txt">
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','291')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','56')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','58')[@xml:lang=$lang]/@Des"/><br/>
                  <!-- transaction type -->
                  <xsl:value-of select="key('txt-index','524')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','59')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','60')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','71')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','69')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','70')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','64')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','65')[@xml:lang=$lang]/@Des"/>
                </font></th>
              </xsl:for-each>
            </tr>
            <!-- charge type grouping -->
            <xsl:for-each select="InvoiceItem[generate-id(.)=generate-id(key('ct-prepaid-credits',@CT)[1])]">
              <!-- charge type sorting -->
              <xsl:sort select="@CT" data-type="text" order="ascending"/>
              <!-- charge type processing -->
              <xsl:for-each select="key('ct-prepaid-credits',@CT)">
                <tr>
                  <xsl:if test="position()='1'">
                    <td nowrap="nowrap" align="center">
                      <xsl:attribute name="rowspan">
                        <xsl:value-of select="count(key('ct-prepaid-credits',@CT))"/>
                      </xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="@CT='A'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','292')[@xml:lang=$lang]/@Des"/>
                           </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='O'">
                         <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','293')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='S'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','294')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='U'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','295')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='P'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','296')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='T'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','513')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='B'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','177')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                            <xsl:text> </xsl:text>
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','184')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:otherwise>
                          <font size="-1">
                            <xsl:value-of select="@CT"/>
                          </font>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                  </xsl:if>
                  <xsl:apply-templates select="."/>
                </tr>
              </xsl:for-each>
            </xsl:for-each>
          </tbody>
        </table>
        <br/>
      </xsl:if>

      <!--  prepaid debits  -->
      <xsl:if test="InvoiceItem[Charge/@PT='A' and @PrepaidTransaction='Y' and @Debit='Y']">
        <table width="100%" border="1" cellspacing="0" cellpadding="0">
          <thead>
            <tr>
              <td colspan="10"><font size="-1"><b>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','523')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </b></font></td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <xsl:for-each select="$txt">
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','291')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','56')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','58')[@xml:lang=$lang]/@Des"/><br/>
                  <!-- transaction type -->
                  <xsl:value-of select="key('txt-index','524')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','59')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','60')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','71')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','69')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','70')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','64')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','65')[@xml:lang=$lang]/@Des"/>
                </font></th>
              </xsl:for-each>
            </tr>
            <!-- charge type grouping -->
            <xsl:for-each select="InvoiceItem[generate-id(.)=generate-id(key('ct-prepaid-debits',@CT)[1])]">
              <!-- charge type sorting -->
              <xsl:sort select="@CT" data-type="text" order="ascending"/>
              <!-- charge type processing -->
              <xsl:for-each select="key('ct-prepaid-debits',@CT)">
                <tr>
                  <xsl:if test="position()='1'">
                    <td nowrap="nowrap" align="center">
                      <xsl:attribute name="rowspan">
                        <xsl:value-of select="count(key('ct-prepaid-debits',@CT))"/>
                      </xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="@CT='A'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','292')[@xml:lang=$lang]/@Des"/>
                           </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='O'">
                         <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','293')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='S'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','294')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='U'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','295')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='P'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','296')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='T'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','513')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:when test="@CT='B'">
                          <font size="-1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','177')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                            <xsl:text> </xsl:text>
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','184')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font>
                        </xsl:when>
                        <xsl:otherwise>
                          <font size="-1">
                            <xsl:value-of select="@CT"/>
                          </font>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                  </xsl:if>
                  <xsl:apply-templates select="."/>
                </tr>
              </xsl:for-each>
            </xsl:for-each>
          </tbody>
        </table>
      </xsl:if>

      <!--   tax (prepaid)  -->
      <xsl:if test="Tax[Charge/@PT='A']">
        <br/>
        <table border="1" width="100%" cellspacing="0" cellpadding="0">
          <thead>
            <tr>
              <td colspan="8"><font size="-1"><b>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','70')[@xml:lang=$lang]/@Des"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="key('txt-index','286')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </b></font></td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <xsl:for-each select="$txt">
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','340')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','343')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','344')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','345')[@xml:lang=$lang]/@Des"/>
                </font></th>
                <th nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="key('txt-index','346')[@xml:lang=$lang]/@Des"/>
                </font></th>
              </xsl:for-each>
            </tr>
            <xsl:for-each select="Tax[Charge/@PT='A']">
              <xsl:apply-templates select="."/>
            </xsl:for-each>
          </tbody>
        </table>
      </xsl:if>
      <br/>

      <!-- Discount totals -->
      <xsl:apply-templates select="DiscountTotals"/>
      <br/>

      <!-- Invoice totals (postpaid) -->
      <xsl:apply-templates select="InvoiceTotals[Charge[@PT='P' and 0 != number(@Amount) ] ]" mode="postpaid"/>
      <br/>

      <!-- Invoice totals (prepaid) -->
      <xsl:apply-templates select="InvoiceTotals[Charge[@PT='A' and 0 != number(@Amount) ] ]" mode="prepaid"/>

  </xsl:template>

  <!-- invoice item -->
  <xsl:template match="InvoiceItem">
    <!-- quantity -->
    <td align="center"><font size="-1">
      <xsl:value-of select="@NumItem"/>
    </font></td>
    <!-- service -->
    <xsl:apply-templates select="AggSet" mode="invoice-item"/>
    <!-- promotion -->
    <xsl:choose>
      <xsl:when test="PromoItem">
        <td align="right"><font size="-1">
          <xsl:for-each select="PromoItem">
            <xsl:apply-templates select="." mode="invoice-item"/>
            <br/>
          </xsl:for-each>
        </font></td>
      </xsl:when>
      <xsl:otherwise>
        <td align="center">-</td>
      </xsl:otherwise>
    </xsl:choose>
    <!-- tax -->
    <xsl:choose>
      <xsl:when test="Tax">
        <td align="right"><font size="-1">
          <!-- tax (multiple) -->
          <xsl:for-each select="Tax">
            <xsl:variable name="tax-rate">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Rate"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$tax-rate"/>
            <br/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <!-- tax amount (multiple currency) -->
          <xsl:for-each select="Tax/Charge">
            <xsl:variable name="number-format">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$number-format"/>
            <xsl:text> </xsl:text>
            <xsl:for-each select="@CurrCode">
              <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
            <br/>
          </xsl:for-each>
        </font></td>
      </xsl:when>
      <xsl:otherwise>
        <td colspan="2"/>
      </xsl:otherwise>
    </xsl:choose>
    <!-- charges -->
    <xsl:choose>
      <xsl:when test="Charge">
        <td align="right"><font size="-1">
          <xsl:for-each select="Charge">
            <!-- sort the charges -->
            <xsl:sort select="@Id"   data-type="number" order="ascending"/>
            <xsl:variable name="number-format">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
            </xsl:variable>
            <!-- print net amount (multiple currency) -->
            <xsl:if test="@Id='125'">
              <xsl:choose>
                <xsl:when test="position()=last()">
                  <xsl:value-of select="$number-format"/>
                  <xsl:text> </xsl:text>
                  <xsl:for-each select="@CurrCode">
                    <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="following-sibling::Charge[1]/@Id!='125'">
                      <xsl:value-of select="$number-format"/>
                      <xsl:text> </xsl:text>
                      <xsl:for-each select="@CurrCode">
                        <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                      </xsl:for-each>
                      <br/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="./@CurrCode!=following-sibling::Charge[1]/@CurrCode">
                        <xsl:value-of select="$number-format"/>
                        <xsl:text> </xsl:text>
                        <xsl:for-each select="@CurrCode">
                          <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                        </xsl:for-each>
                        <br/>
                      </xsl:if>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:for-each select="Charge">
            <!-- sort the charges -->
            <xsl:sort select="@Id"   data-type="number" order="ascending"/>
            <xsl:variable name="number-format">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
            </xsl:variable>
            <!-- print gross amount (multiple currency) -->
            <xsl:if test="@Id='203'">
              <xsl:choose>
                <xsl:when test="position()=last()">
                  <xsl:value-of select="$number-format"/>
                  <xsl:text> </xsl:text>
                  <xsl:for-each select="@CurrCode">
                    <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="following-sibling::Charge[1]/@Id!='203'">
                      <xsl:value-of select="$number-format"/>
                      <xsl:text> </xsl:text>
                      <xsl:for-each select="@CurrCode">
                        <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                      </xsl:for-each>
                      <br/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="./@CurrCode!=following-sibling::Charge[1]/@CurrCode">
                        <xsl:value-of select="$number-format"/>
                        <xsl:text> </xsl:text>
                        <xsl:for-each select="@CurrCode">
                          <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                        </xsl:for-each>
                        <br/>
                      </xsl:if>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
          </xsl:for-each>
        </font></td>
      </xsl:when>
      <xsl:otherwise>
        <td/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- postpaid invoice totals -->
  <xsl:template match="InvoiceTotals" mode="postpaid">

    <table border="1" width="100%" cellspacing="0" cellpadding="0">
      <thead>
        <tr>
          <td colspan="2"><font size="-1"><b>
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','74')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </b></font></td>
        </tr>
      </thead>
      <tbody>
      <!-- invoice net (multiple currency) -->
      <tr>
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','80')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:for-each select="Charge[@PT='P' and @Id='79' and @Type!='19']">
            <xsl:variable name="number-format">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$number-format"/>
            <xsl:text> </xsl:text>
            <xsl:for-each select="@CurrCode">
              <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
            <br/>
          </xsl:for-each>
        </font></td>
      </tr>
      <!-- invoice gross (multiple currency) -->
      <tr>
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','77')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:for-each select="Charge[@PT='P' and @Id='77' and @Type!='19']">
            <xsl:variable name="number-format">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$number-format"/>
            <xsl:text> </xsl:text>
            <xsl:for-each select="@CurrCode">
              <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
            <br/>
          </xsl:for-each>
        </font></td>
      </tr>
      <!-- own amount gross (multiple currency) -->
      <tr>
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','442')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:for-each select="Charge[@PT='P' and @Id='703']">
            <xsl:variable name="number-format">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$number-format"/>
            <xsl:text> </xsl:text>
            <xsl:for-each select="@CurrCode">
              <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
            <br/>
          </xsl:for-each>
        </font></td>
      </tr>
      <!-- collected amount gross (multiple currency) -->
      <tr>
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','443')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:for-each select="Charge[@PT='P' and @Id='704']">
            <xsl:variable name="number-format">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$number-format"/>
            <xsl:text> </xsl:text>
            <xsl:for-each select="@CurrCode">
              <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
            <br/>
          </xsl:for-each>
        </font></td>
      </tr>
      <!-- old balance (multiple currency) -->
      <tr>
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','76')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:for-each select="Charge[@PT='P' and @Id='76']">
            <xsl:variable name="number-format">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$number-format"/>
            <xsl:text> </xsl:text>
            <xsl:for-each select="@CurrCode">
              <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
            <br/>
          </xsl:for-each>
        </font></td>
      </tr>
      <!-- new balance (multiple currency) -->
      <tr>
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','79')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:for-each select="Charge[@PT='P' and @Id='78']">
            <xsl:variable name="number-format">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$number-format"/>
            <xsl:text> </xsl:text>
            <xsl:for-each select="@CurrCode">
              <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
            <br/>
          </xsl:for-each>
        </font></td>
      </tr>
      <!-- amount to pay (multiple currency) -->
      <tr>
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','82')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1" color="red">
          <xsl:for-each select="Charge[@PT='P' and @Id='178']">
            <xsl:variable name="number-format">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$number-format"/>
            <xsl:text> </xsl:text>
            <xsl:for-each select="@CurrCode">
              <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
            <br/>
          </xsl:for-each>
        </font></td>
      </tr>

      </tbody>
    </table>

  </xsl:template>

  <!-- prepaid invoice totals -->
  <xsl:template match="InvoiceTotals" mode="prepaid">

    <table border="1" width="100%" cellspacing="0" cellpadding="0">
      <thead>
        <tr>
          <td colspan="2"><font size="-1"><b>
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','74')[@xml:lang=$lang]/@Des"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="key('txt-index','286')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </b></font></td>
        </tr>
      </thead>
      <tbody>
      <!-- invoice net (multiple currency) -->
      <tr>
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','80')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:for-each select="Charge[@PT='A' and @Id='79' and @Type!='19']">
            <xsl:variable name="number-format">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$number-format"/>
            <xsl:text> </xsl:text>
            <xsl:for-each select="@CurrCode">
              <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
            <br/>
          </xsl:for-each>
        </font></td>
      </tr>
      <!-- invoice gross (multiple currency) -->
      <tr>
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','77')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:for-each select="Charge[@PT='A' and @Id='77' and @Type!='19']">
            <xsl:variable name="number-format">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$number-format"/>
            <xsl:text> </xsl:text>
            <xsl:for-each select="@CurrCode">
              <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
            <br/>
          </xsl:for-each>
        </font></td>
      </tr>
      <!-- old balance (multiple currency) -->
      <tr>
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','427')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:for-each select="Charge[@PT='A' and @Id='700']">
            <xsl:variable name="number-format">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$number-format"/>
            <xsl:text> </xsl:text>
            <xsl:for-each select="@CurrCode">
              <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
            <br/>
          </xsl:for-each>
        </font></td>
      </tr>
      <!-- new balance (multiple currency) -->
      <tr>
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','428')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:for-each select="Charge[@PT='A' and @Id='701']">
            <xsl:variable name="number-format">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$number-format"/>
            <xsl:text> </xsl:text>
            <xsl:for-each select="@CurrCode">
              <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
            <br/>
          </xsl:for-each>
        </font></td>
      </tr>
      <!-- amount to pay (multiple currency) -->
      <tr>
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','429')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1" color="red">
          <xsl:for-each select="Charge[@PT='A' and @Id='702']">
            <xsl:variable name="number-format">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$number-format"/>
            <xsl:text> </xsl:text>
            <xsl:for-each select="@CurrCode">
              <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
            <br/>
          </xsl:for-each>
        </font></td>
      </tr>

      </tbody>
    </table>

  </xsl:template>

  <!-- prepaid accounting -->
  <!-- discount totals  -->
  <xsl:template match="DiscountTotals">
    <table border="1" width="100%" cellspacing="0" cellpadding="0">
      <thead>
        <tr>
          <td colspan="2"><font size="-1"><b>
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','397')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </b></font></td>
        </tr>
      </thead>
      <tbody>
        <tr>
          <xsl:for-each select="$txt">
            <th nowrap="nowrap"><font size="-1">
               <xsl:value-of select="key('txt-index','157')[@xml:lang=$lang]/@Des"/>
            </font></th>
            <th nowrap="nowrap"><font size="-1">
              <xsl:value-of select="key('txt-index','158')[@xml:lang=$lang]/@Des"/>
            </font></th>
          </xsl:for-each>
        </tr>
        <!-- monetary discount info -->
        <xsl:if test="Charge">
          <tr>
            <td align="right"><font size="-1">
              <xsl:for-each select="Charge[@Id='56']">
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="@Amount"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:for-each select="@CurrCode">
                  <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                </xsl:for-each>
                <br/>
              </xsl:for-each>
            </font></td>
            <td align="right"><font size="-1">
              <xsl:for-each select="Charge[@Id='55']">
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="@Amount"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:for-each select="@CurrCode">
                  <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                </xsl:for-each>
                <br/>
              </xsl:for-each>
            </font></td>
          </tr>
        </xsl:if>
        <!-- non monetary discount info -->
        <xsl:for-each select="DiscountValue">
          <tr>
            <xsl:apply-templates select="."/>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>

  <!-- tax -->
  <xsl:template match="Tax">

    <xsl:variable name="tax-rate">
      <xsl:call-template name="number-format">
        <xsl:with-param name="number" select="@Rate"/>
      </xsl:call-template>
    </xsl:variable>
    <tr>
      <xsl:choose>
        <xsl:when test="@Cat != ''">
          <td><font size="-1">
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="@Cat"/>
              <xsl:with-param name="Type"  select="'TCA'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </font></td>
        </xsl:when>
        <xsl:otherwise>
          <td align="center"><font size="-1">-</font></td>
        </xsl:otherwise>
      </xsl:choose>
      <td align="right"><font size="-1">
        <xsl:value-of select="$tax-rate"/>
      </font></td>
      <td align="center"><font size="-1">
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
      </font></td>
      <td align="center"><font size="-1">
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
      </font></td>
      <td align="right"><font size="-1">
        <xsl:if test="Charge">
          <!-- total tax amount (multiple currency) -->
          <xsl:for-each select="Charge">
            <xsl:sort select="@Id"   data-type="number" order="ascending"/>
            <xsl:sort select="@Type" data-type="number" order="ascending"/>
            <xsl:if test="@Id='124'">
              <xsl:variable name="number-format">
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="@Amount"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:value-of select="$number-format"/>
              <xsl:text> </xsl:text>
              <xsl:for-each select="@CurrCode">
                <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
              <br/>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>
      </font></td>
    </tr>

  </xsl:template>
  
  
  <!-- Debit Note -->
  <xsl:template match="DebitNote">
    
    <table border="1" width="50%" cellspacing="0" cellpadding="0">
      <tr>
        <td valign="top" width="40%"><font size="-1">
            <!-- Debit Note Purpose -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','530')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        </font></td>
        <td><font size="-1">
            <xsl:value-of select="@Purpose"/>
        </font></td>
      </tr>
      <tr>
        <td valign="top"><font size="-1">
            <!-- Referenced documents -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','531')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        </font></td>
        <td><font size="-1">
          <xsl:for-each select="DocRef">
            <xsl:value-of select="@RefNum"/>
            <xsl:if test="position()!=last()"><br/></xsl:if>
          </xsl:for-each>
        </font></td>
      </tr>
    </table>
    <br/>
    
  </xsl:template>

</xsl:stylesheet>
