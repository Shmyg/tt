<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2012 Ericsson

  All rights reserved.

  File:    InvoiceXMLSS.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> XMLSS stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms invoice documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/InvoiceXMLSS.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

  XML Spreadsheet Reference : http://msdn.microsoft.com/en-us/library/aa140066%28office.10%29.aspx

-->

<xsl:stylesheet version="1.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:html="http://www.w3.org/TR/REC-html40" 
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" 
 xmlns:o="urn:schemas-microsoft-com:office:office" 
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:date="http://exslt.org/dates-and-times" 
 exclude-result-prefixes="xsl date">

  <xsl:key name="ct" match="InvoiceItem" use="@CT"/>

  <xsl:variable name="sender"   select="document(/Bill/Part/@File)/Document/AddressPage/InvParty"/>
  <xsl:variable name="receiver" select="document(/Bill/Part/@File)/Document/AddressPage/BillAcc"/>

  <xsl:variable name="invoice-date">
    <xsl:call-template name="date-format">
      <xsl:with-param name="date"    select="document(/Bill/Part/@File)/Document/Invoice/Date[@Type='INV']/@Date"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="start-date">
    <xsl:call-template name="date-time-format">
      <xsl:with-param name="date" select="document(/Bill/Part/@File)/Document/Invoice/Date[@Type='START']/@Date"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="end-date">
    <xsl:call-template name="date-time-format">
      <xsl:with-param name="date" select="document(/Bill/Part/@File)/Document/Invoice/Date[@Type='END']/@Date"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="due-date">
    <xsl:call-template name="date-format">
      <xsl:with-param name="date"    select="document(/Bill/Part/@File)/Document/Invoice/Date[@Type='DUE_DATE']/@Date"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- invoice -->
  <xsl:template match="Invoice">

      <!-- invoice date, period, due date -->
      <ss:Row>
        <ss:Cell  ss:StyleID="s10">
          <ss:Data ss:Type="String">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','1')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </ss:Data>
        </ss:Cell>
        <ss:Cell ss:MergeAcross="6"/>
        <ss:Cell ss:StyleID="longDate">
          <ss:Data ss:Type="DateTime">
            <xsl:value-of select="$invoice-date"/>
          </ss:Data>
        </ss:Cell>
      </ss:Row>

      <!-- billing period -->
      <ss:Row>
        <ss:Cell  ss:StyleID="s10">
          <ss:Data ss:Type="String">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','2')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </ss:Data>
        </ss:Cell>
        <ss:Cell ss:MergeAcross="3"/>
        <ss:Cell ss:StyleID="longDate">
          <ss:Data ss:Type="DateTime">
            <xsl:value-of select="$start-date"/>
          </ss:Data>
        </ss:Cell>
        <ss:Cell ss:StyleID="longTime">
          <ss:Data ss:Type="DateTime">
            <xsl:value-of select="$start-date"/>
          </ss:Data>
        </ss:Cell>
        <ss:Cell ss:StyleID="longDate">
          <ss:Data ss:Type="DateTime">
            <xsl:value-of select="$end-date"/>
          </ss:Data>
        </ss:Cell>
        <ss:Cell ss:StyleID="longTime">
          <ss:Data ss:Type="DateTime">
            <xsl:value-of select="$end-date"/>
          </ss:Data>
        </ss:Cell>
      </ss:Row>

      <ss:Row/>
      
      <!-- invoice items -->
      <ss:Row>
        <ss:Cell ss:MergeAcross="3"/>
        <ss:Cell ss:StyleID="s12">
          <ss:Data ss:Type="String">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','89')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </ss:Data>
        </ss:Cell>
        <ss:Cell ss:MergeAcross="3"/>
      </ss:Row>

      <ss:Row/>

      <xsl:call-template name="invoice-item-header"/>

      <!-- charge type grouping -->
      <xsl:for-each select="InvoiceItem[generate-id(.)=generate-id(key('ct',@CT)[1])]">

        <!-- charge type sorting -->
        <xsl:sort select="@CT" data-type="text" order="ascending"/>

          <!-- charge type processing -->
          <xsl:for-each select="key('ct',@CT)">

            <xsl:if test="position()='1'">
              <ss:Row>
                <ss:Cell ss:MergeAcross="3"/>
                <ss:Cell ss:StyleID="s10c">
                  <ss:Data ss:Type="String">
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
                  </ss:Data>
                </ss:Cell>
                <ss:Cell ss:MergeAcross="3"/>
              </ss:Row>
            </xsl:if>

            <ss:Row>
              <xsl:apply-templates select="."/>
            </ss:Row>

          </xsl:for-each>

        </xsl:for-each>

        <!-- amount to pay -->
        <ss:Row>
          <ss:Cell ss:StyleID="CenterC">
            <ss:Data ss:Type="String">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','82')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="CenterC" ss:MergeAcross="6"/>
          <ss:Cell ss:StyleID="RightC">
            <ss:Data ss:Type="String">
              <xsl:for-each select="InvoiceTotals/Charge[@Id='178']">
                <xsl:variable name="number-format">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$number-format"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="@CurrCode"/>
                <xsl:if test="position()!=last()">
                  <xsl:text> / </xsl:text>
                </xsl:if>
              </xsl:for-each>
            </ss:Data>
          </ss:Cell>
        </ss:Row>

        <ss:Row/>
        <ss:Row/>

        <!-- payment conditions -->
        <xsl:if test="PaymentTerm">

          <!-- payment term package -->
          <ss:Row>
            <ss:Cell ss:StyleID="s10">
              <ss:Data ss:Type="String">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','501')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </ss:Data>
            </ss:Cell>
            <ss:Cell ss:StyleID="Center">
              <ss:Data ss:Type="String">            
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="PaymentTerm/@TermShname"/>
                  <xsl:with-param name="Type"  select="'PT'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </ss:Data>
            </ss:Cell>
          </ss:Row>

          <!-- payment term due date -->
          <ss:Row>
            <ss:Cell ss:StyleID="s10">
              <ss:Data ss:Type="String">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','240')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>      
              </ss:Data>
            </ss:Cell>
            <!-- days -->
            <ss:Cell ss:StyleID="Right">
              <ss:Data ss:Type="String">
                <xsl:variable name="duration">
                  <!-- return value is a duration: PnYnMnDTnHnMnS, see http://www.w3.org/TR/xmlschema-2/#duration  -->
                  <xsl:call-template name="date:difference">
                    <xsl:with-param name="start" select="$invoice-date" />
                    <xsl:with-param name="end" select="$due-date" />
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

              </ss:Data>
            </ss:Cell>

            <!-- due date -->
            <ss:Cell ss:StyleID="longDate">
              <ss:Data ss:Type="DateTime">
                <xsl:value-of select="$due-date"/>
              </ss:Data>
            </ss:Cell>

          </ss:Row>

          <!-- payment conditions -->
          <xsl:if test="CashDiscount">
            
              <xsl:for-each select="CashDiscount">

                <!-- date sorting -->
                <xsl:sort select="Date[@Type='DISCOUNT']/@Date" data-type="number" order="ascending"/>

                  <xsl:variable name="discount-amount" select="Charge[@Id='12' and @Type='9' and @PT='P']/@Amount"/>
                  <xsl:variable name="discount-percentage" select="Charge[@Id='12' and @Type='9' and @PT='P']/@DiscountPercentage"/>
                  <xsl:variable name="discount-currency" select="Charge[@Id='12' and @Type='9' and @PT='P']/@CurrCode"/>

                  <ss:Row>

                    <!-- payment within -->
                    <ss:Cell ss:StyleID="s10">
                      <ss:Data ss:Type="String">
                        <xsl:choose>
                          <xsl:when test="position()=1">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','505')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </xsl:when>
                          <xsl:otherwise/>
                        </xsl:choose>
                      </ss:Data>
                    </ss:Cell>
                    <ss:Cell ss:StyleID="Right">
                      <ss:Data ss:Type="String">     
                        <xsl:value-of select="@Days"/>
                        <xsl:text> </xsl:text>
                        <xsl:for-each select="$txt">
                          <xsl:value-of select="key('txt-index','504')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>                
                      </ss:Data>
                    </ss:Cell>
                    <ss:Cell ss:StyleID="longDate">
                      <ss:Data ss:Type="DateTime">
                        <xsl:variable name="discount-date">
                          <xsl:call-template name="date-format">
                            <xsl:with-param name="date" select="Date[@Type='DISCOUNT']/@Date"/>
                          </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="$discount-date"/>
                      </ss:Data>
                    </ss:Cell>
                    <ss:Cell/>

                    <!-- discount -->
                    <ss:Cell ss:StyleID="s10">
                      <ss:Data ss:Type="String">     
                        <xsl:for-each select="$txt">
                          <xsl:value-of select="key('txt-index','467')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                      </ss:Data>
                    </ss:Cell>                  
                  
                    <!-- percentage -->
                    <ss:Cell ss:StyleID="Percent">
                      <ss:Data ss:Type="Number">
                        <xsl:variable name="percentage">       
                          <xsl:call-template name="number-format">
                            <xsl:with-param name="number" select="$discount-percentage * 100"/>
                          </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="$percentage"/>
                      </ss:Data>
                    </ss:Cell>

                    <!-- amount -->
                    <ss:Cell ss:StyleID="Right">
                      <ss:Data ss:Type="String">
                        <xsl:variable name="number-format">
                          <xsl:call-template name="number-format">
                            <xsl:with-param name="number" select="$discount-amount"/>
                          </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="$number-format"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$discount-currency"/>
                      </ss:Data>
                    </ss:Cell>
                  </ss:Row>                
              </xsl:for-each>  
          </xsl:if>
        </xsl:if>

        <!-- payment method -->
        <ss:Row>
          <ss:Cell ss:StyleID="s10">
            <ss:Data ss:Type="String">       
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','128')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="Center">
            <ss:Data ss:Type="String">                 
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="$receiver/@PayMeth"/>
                <xsl:with-param name="Type"  select="'PMT'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
            </ss:Data>
          </ss:Cell>
        </ss:Row>      

        <!-- receiver bank info -->
        <ss:Row/>
        <ss:Row>
          <ss:Cell ss:StyleID="s10">
            <ss:Data ss:Type="String">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','5')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="Center">
            <ss:Data ss:Type="String">
              <xsl:value-of select="concat($receiver/FiCont/Account/@HolderName1,'&#160;',$receiver/FiCont/Account/@HolderName2)"/>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10">
            <ss:Data ss:Type="String">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','6')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>  
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="Center">
            <ss:Data ss:Type="String">
              <xsl:value-of select="$receiver/FiCont/Account/@Num"/>
            </ss:Data>
          </ss:Cell>
        </ss:Row>
        <ss:Row>
          <ss:Cell ss:StyleID="s10">
            <ss:Data ss:Type="String">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','7')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="Center">
            <ss:Data ss:Type="String">
              <xsl:value-of select="$receiver/FiCont/Bank/@Code"/>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10">
            <ss:Data ss:Type="String">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','8')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="Center">
            <ss:Data ss:Type="String">
              <xsl:value-of select="$receiver/FiCont/Bank/@Name"/>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10">
            <ss:Data ss:Type="String">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','9')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="Center">
            <ss:Data ss:Type="String">
              <xsl:value-of select="$receiver/FiCont/Bank/@Branch"/>
            </ss:Data>
          </ss:Cell>
        </ss:Row>

        <!-- contact -->
        <ss:Row/>
        <ss:Row>
          <ss:Cell ss:StyleID="s10">
            <ss:Data ss:Type="String">   
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','11')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10">
            <ss:Data ss:Type="String">
              <xsl:value-of select="$sender/CCContact/@Person"/>
            </ss:Data>
          </ss:Cell>
        </ss:Row>

        <xsl:for-each select="$sender/CCContact/Contact">
          <ss:Row>
            <xsl:choose>      
            <xsl:when test="@Type='TE'">
              <ss:Cell ss:StyleID="s10">
                <ss:Data ss:Type="String">   
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','12')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </ss:Data>
              </ss:Cell>
            </xsl:when>
            <xsl:when test="@Type='TX'">           
              <ss:Cell ss:StyleID="s10">
                <ss:Data ss:Type="String">   
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','13')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </ss:Data>
              </ss:Cell>
            </xsl:when>
            <xsl:when test="@Type='FX'">
              <ss:Cell ss:StyleID="s10">
                <ss:Data ss:Type="String">   
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','14')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </ss:Data>
              </ss:Cell>    
            </xsl:when>
            <xsl:when test="@Type='EM'">
              <ss:Cell ss:StyleID="s10">
                <ss:Data ss:Type="String">   
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','326')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </ss:Data>
              </ss:Cell>
            </xsl:when>
            <xsl:otherwise>
              <ss:Cell/>
            </xsl:otherwise>
          </xsl:choose>
          <ss:Cell ss:StyleID="Center">
            <ss:Data ss:Type="String">   
              <xsl:value-of select="@Value"/>
            </ss:Data>
          </ss:Cell>
        </ss:Row>
      </xsl:for-each>

  </xsl:template>

  <xsl:template name="invoice-item-header">

      <ss:Row>
        <xsl:for-each select="$txt">
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('txt-index','56')[@xml:lang=$lang]/@Des"/>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('txt-index','58')[@xml:lang=$lang]/@Des"/>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('txt-index','59')[@xml:lang=$lang]/@Des"/>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('txt-index','60')[@xml:lang=$lang]/@Des"/>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('txt-index','71')[@xml:lang=$lang]/@Des"/>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('txt-index','69')[@xml:lang=$lang]/@Des"/>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('txt-index','70')[@xml:lang=$lang]/@Des"/>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('txt-index','64')[@xml:lang=$lang]/@Des"/>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('txt-index','65')[@xml:lang=$lang]/@Des"/>
            </ss:Data>
          </ss:Cell>
        </xsl:for-each>
      </ss:Row>

  </xsl:template>

  <!-- invoice item -->
  <xsl:template match="InvoiceItem">

    <!-- quantity -->
    <ss:Cell ss:StyleID="Number">
      <ss:Data ss:Type="Number">
        <xsl:value-of select="@NumItem"/>
      </ss:Data>
    </ss:Cell>

    <!-- service -->
    <xsl:apply-templates select="AggSet" mode="invoice-item"/>

    <!-- promotion -->
    <xsl:choose>
      <xsl:when test="PromoItem">
        <ss:Cell ss:StyleID="Currency">
          <ss:Data ss:Type="String">
            <xsl:for-each select="PromoItem/Charge[@Id='53']">
              <xsl:variable name="number-format">
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="@Amount"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:value-of select="$number-format"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="@CurrCode"/>
              <xsl:if test="position()!=last()">
                <xsl:text> / </xsl:text>
              </xsl:if>
            </xsl:for-each>
          </ss:Data>
        </ss:Cell>
      </xsl:when>
      <xsl:otherwise>
        <ss:Cell ss:StyleID="Center">
          <ss:Data ss:Type="String">
            <xsl:text>-</xsl:text>
          </ss:Data>
        </ss:Cell>
      </xsl:otherwise>
    </xsl:choose>

    <!-- tax -->
    <xsl:choose>
      <xsl:when test="Tax">
      <ss:Cell ss:StyleID="Right">
        <ss:Data ss:Type="String">
          <!-- tax -->
          <xsl:for-each select="Tax">
            <xsl:variable name="tax-rate">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Rate"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$tax-rate"/>
            <xsl:if test="position()!=last()">
              <xsl:text> / </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </ss:Data>
      </ss:Cell>
      <ss:Cell ss:StyleID="Right">
        <ss:Data ss:Type="String">
          <!-- tax amount -->
          <xsl:for-each select="Tax/Charge">
            <xsl:variable name="number-format">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$number-format"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="@CurrCode"/>
            <xsl:if test="position()!=last()">
              <xsl:text> / </xsl:text>
            </xsl:if>
          </xsl:for-each>
          </ss:Data>
        </ss:Cell>        
      </xsl:when>
      <xsl:otherwise>
        <ss:Cell ss:MergeAcross="1"/>
      </xsl:otherwise>
    </xsl:choose>

    <!-- charges -->
    <xsl:choose>
      <xsl:when test="Charge">
        <ss:Cell ss:StyleID="Right">
          <ss:Data ss:Type="String">
            <xsl:for-each select="Charge[@Id='125']">
              <xsl:variable name="number-format">
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="@Amount"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:value-of select="$number-format"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="@CurrCode"/>
            <xsl:if test="position()!=last()">
              <xsl:text> / </xsl:text>
            </xsl:if>
            </xsl:for-each>
          </ss:Data>
        </ss:Cell>   
        <ss:Cell ss:StyleID="Currency">
          <ss:Data ss:Type="String">
            <xsl:for-each select="Charge[@Id='203']">
              <xsl:variable name="number-format">
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="@Amount"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:value-of select="$number-format"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="@CurrCode"/>
              <xsl:if test="position()!=last()">
                <xsl:text> / </xsl:text>
              </xsl:if>
            </xsl:for-each>
          </ss:Data>
        </ss:Cell>
      </xsl:when>
      <xsl:otherwise>
        <ss:Cell ss:MergeAcross="1"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

</xsl:stylesheet>
