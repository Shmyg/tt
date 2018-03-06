<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2010 LHS Telekom GmbH & Co. KG

  The copyright in this work is vested in LHS. The information contained in this work
  (either in whole or in part) is confidential and must not be modified, reproduced,
  disclosed or disseminated to others or used for purposes other than that for which
  it is supplied, without the prior written permission of LHS.  If this work or any
  part hereof is furnished to a third party by virtue of a contract with that party,
  use of this work by such party shall be governed by the express contractual terms
  between LHS, which is party to that contract and the said party.

  The information in this document is subject to change without notice and should not
  be construed as a commitment by LHS. LHS assumes no responsibility for any errors
  that may appear in this document. With the appearance of a new version of this
  document all older versions become invalid.

  All rights reserved.

  File:    InvoiceCSV.xsl

  Owners:  Matthias Fehrenbacher
           Natalie Kather

  @(#) ABSTRACT : XML -> CSV stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms invoice documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/InvoiceCSV.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" xmlns:date="http://exslt.org/dates-and-times" xmlns:bgh="http://www.lhsgroup.com/BSCS/BGH" exclude-result-prefixes="xsl cur date bgh">
  
  <xsl:variable name="address-page" select="document(/Bill/Part/@File)/Document/AddressPage" />
  
  <xsl:key name="ct"         match="InvoiceItem[Charge/@PT='P']" use="@CT"/>
  <xsl:key name="ct-prepaid" match="InvoiceItem[Charge/@PT='A' and @PrepaidTransaction='N']" use="@CT"/>
  <xsl:key name="ct-prepaid-credits" match="InvoiceItem[Charge/@PT='A' and @PrepaidTransaction='Y' and @Debit='N']" use="@CT"/>
  <xsl:key name="ct-prepaid-debits" match="InvoiceItem[Charge/@PT='A' and @PrepaidTransaction='Y' and @Debit='Y']" use="@CT"/>

  
  <!-- Invoice -->
  <xsl:template match="Invoice">
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
            <!-- invoice date -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','1')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
            <!-- invoice date -->
              <xsl:call-template name="date-time-format">
                <xsl:with-param name="date" select="Date[@Type='INV']/@Date"/>
              </xsl:call-template>
        </bgh:cell>
    </bgh:row>
    
    <xsl:if test="$bit != 'DN'">
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                <!-- period -->
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','2')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
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
            </bgh:cell>
        </bgh:row>
    </xsl:if>
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
              <!-- payment term package -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','501')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="PaymentTerm/@TermShname"/>
                <xsl:with-param name="Type"  select="'PT'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
        </bgh:cell>
    </bgh:row>
    
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
            <!-- payment term due date -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','240')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
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
        </bgh:cell>
    </bgh:row>

    <bgh:row />
      
    
    <!-- cash discounts -->
    <xsl:if test="CashDiscount">
      
        <xsl:for-each select="CashDiscount">
        
              <!-- date sorting -->
              <xsl:sort select="Date[@Type='DISCOUNT']/@Date" data-type="text" order="ascending"/>
              
              <xsl:variable name="discount-amount" select="Charge[@Id='12' and @Type='9' and @PT='P']/@Amount"/>
              <xsl:variable name="discount-percentage" select="Charge[@Id='12' and @Type='9' and @PT='P']/@DiscountPercentage"/>
              <xsl:variable name="total-amount" select="../InvoiceTotals/Charge[@Id='77' and @Type='5' and @PT='P']/@Amount"/>
                      
            <bgh:row>
              
                 <bgh:cell>
                    <xsl:value-of select="concat(position(),'.')"/>
                 
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
                      <xsl:call-template name="currency">
                        <xsl:with-param name="CurrCode" select="Charge[@Id='12' and @Type='9' and @PT='P']/@CurrCode"/>
                      </xsl:call-template>
                </bgh:cell>
          
            </bgh:row>
          
        </xsl:for-each>
        
        <bgh:row/>
      
    </xsl:if>
    
    <xsl:if test="DebitNote">
        <xsl:apply-templates select="DebitNote"/>
    </xsl:if>
    
    <!-- Invoicing party -->
    <xsl:for-each select="$address-page/InvParty">
        <xsl:apply-templates select="."/>
    </xsl:for-each>
        
    <!-- Bank account of recipient -->
    <xsl:for-each select="$address-page/BillAcc/FiCont">
        <xsl:apply-templates select="."/>
    </xsl:for-each>
    
    

    <!-- invoice items (postpaid) -->
    <xsl:if test="InvoiceItem[Charge/@PT='P']">
        
        <bgh:row>
            <bgh:cell>
            <!-- Charges -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','89')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
            </bgh:cell>
        </bgh:row>
        
        <xsl:for-each select="InvoiceItem[generate-id(.)=generate-id(key('ct',@CT)[1])]">
            <xsl:sort select="@CT" data-type="text" order="ascending"/>
            <!--
            <xsl:for-each select="key('ct',@CT)[Charge/@PT='P']">
            -->
            <xsl:for-each select="key('ct',@CT)">
            
              <xsl:if test="position()='1'">
                
                <bgh:row>
                    <bgh:cell/>
                    <bgh:cell>
                    
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
                    
                    </bgh:cell>
                </bgh:row>
                
                <xsl:call-template name="invoice-item-table-head">
                    <xsl:with-param name="PT" select="'P'" />
                </xsl:call-template>
                
              </xsl:if>
              
                <xsl:apply-templates select="."/>
              
            </xsl:for-each>
          </xsl:for-each>

          <bgh:row/>
          
    </xsl:if>

    <!-- tax info (postpaid) -->
    <xsl:if test="Tax[Charge/@PT='P']">
      
        
        
        <bgh:row>
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','70')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
        </bgh:row>
        
        <xsl:call-template name="tax-table-head">
            <xsl:with-param name="PT" select="'P'" />
        </xsl:call-template>

        
        <xsl:for-each select="Tax[Charge/@PT='P']">

            <xsl:apply-templates select="."/>

        </xsl:for-each>

        <bgh:row/>
    </xsl:if>

    <!-- invoice items (prepaid) -->
    <xsl:if test="InvoiceItem[Charge/@PT='A' and @PrepaidTransaction='N']">

        <bgh:row>
            <bgh:cell>
            
                <!-- "Charges (prepaid)" -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','89')[@xml:lang=$lang]/@Des"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="key('txt-index','286')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
          
            </bgh:cell>
        </bgh:row>
        

          <xsl:for-each select="InvoiceItem[generate-id(.)=generate-id(key('ct-prepaid',@CT)[1])]">
            <xsl:sort select="@CT" data-type="text" order="ascending"/>

            <xsl:for-each select="key('ct-prepaid',@CT)">
              <xsl:if test="position()='1'">
                
                <bgh:row>
                    <bgh:cell/>
                    <bgh:cell>
                    
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
                    
                    </bgh:cell>
                </bgh:row>
                
              </xsl:if>
              
                <xsl:call-template name="invoice-item-table-head">
                    <xsl:with-param name="PT" select="'A'" />
                    <xsl:with-param name="PrepaidTransaction" select="'N'" />
                </xsl:call-template>
              
                <xsl:apply-templates select="."/>
              
            </xsl:for-each>
            
          </xsl:for-each>
          <bgh:row/>
    </xsl:if>

    <!-- prepaid credits -->
    <xsl:if test="InvoiceItem[Charge/@PT='A' and @PrepaidTransaction='Y' and @Debit='N']">

        
        <bgh:row>
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','522')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
        </bgh:row> 
        
          <xsl:for-each select="InvoiceItem[generate-id(.)=generate-id(key('ct-prepaid-credits',@CT)[1])]">
            <xsl:sort select="@CT" data-type="text" order="ascending"/>
            <xsl:for-each select="key('ct-prepaid-credits',@CT)">
              <xsl:if test="position()='1'">
                
                <bgh:row>
                    <bgh:cell/>
                    <bgh:cell>
                    
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
                    
                    </bgh:cell>
                </bgh:row>
                
                <xsl:call-template name="invoice-item-table-head">
                    <xsl:with-param name="PT" select="'A'"/>
                    <xsl:with-param name="PrepaidTransaction" select="'Y'"/>
                    <xsl:with-param name="Debit" select="'N'"/>
                </xsl:call-template>

              </xsl:if>
              
                <xsl:apply-templates select="."/>
              
            </xsl:for-each>
          </xsl:for-each>
        
        <bgh:row/>
      
    </xsl:if>

    
    <!-- prepaid debits -->
    <xsl:if test="InvoiceItem[Charge/@PT='A' and @PrepaidTransaction='Y' and @Debit='Y']">
      
        <bgh:row/>
        
        <bgh:row>
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','523')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
        </bgh:row>
        

          <xsl:for-each select="InvoiceItem[generate-id(.)=generate-id(key('ct-prepaid-debits',@CT)[1])]">
            <xsl:sort select="@CT" data-type="text" order="ascending"/>
            <xsl:for-each select="key('ct-prepaid-debits',@CT)">
              <xsl:if test="position()='1'">
                
                <bgh:row>
                    <bgh:cell/>
                    <bgh:cell>
                    
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
                    
                    </bgh:cell>
                </bgh:row>
                
                  
                <xsl:call-template name="invoice-item-table-head">
                    <xsl:with-param name="PT" select="'A'" />
                    <xsl:with-param name="PrepaidTransaction" select="'Y'" />
                    <xsl:with-param name="Debit" select="'Y'" />
                </xsl:call-template>
                
              </xsl:if>
              
                <xsl:apply-templates select="."/>
              
            </xsl:for-each>
          </xsl:for-each>
          
      <bgh:row/>
    </xsl:if>
    

    <!-- tax info (prepaid) -->
    <xsl:if test="Tax[Charge/@PT='A']">
      
        <bgh:row>
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','70')[@xml:lang=$lang]/@Des"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="key('txt-index','286')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
        </bgh:row>
      
        
        <xsl:call-template name="tax-table-head">
            <xsl:with-param name="PT" select="'A'" />
        </xsl:call-template>
        
        
          <xsl:for-each select="Tax[Charge/@PT='A']">
            
              <xsl:apply-templates select="."/>
            
          </xsl:for-each>
        <bgh:row/>
    </xsl:if>

    <!-- Discount totals -->
    <xsl:apply-templates select="DiscountTotals"/>

    <!-- Invoice totals (postpaid) -->
    <xsl:apply-templates select="InvoiceTotals[Charge[@PT='P' and 0 != number(@Amount) ] ]" mode="postpaid"/>

    <!-- Invoice totals (prepaid) -->
    <xsl:apply-templates select="InvoiceTotals[Charge[@PT='A' and 0 != number(@Amount) ] ]" mode="prepaid"/>

  </xsl:template>


  <!-- Print table head for Invoice Items -->  
  <xsl:template name="invoice-item-table-head">
    <xsl:param name="PT" select="''"/>
    <xsl:param name="PrepaidTransaction" select="''"/>
    <xsl:param name="Debit" select="''"/>
  
  
    <xsl:choose>
      <xsl:when test="$PT='P'">
      
        <!-- Invoice Item (postpaid) -->
        
        <bgh:row>
            <bgh:cell/>
            <bgh:cell/>
            <bgh:cell>
                <!-- Quantity -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','56')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <!-- Service -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','58')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <!-- Package -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','59')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <!-- Tariff Model -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','60')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <!-- Discount -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','71')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <!-- Tax (%) -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','69')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <!-- Tax -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','70')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <!-- Net -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','64')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
        </bgh:row>
        
        <!-- Invoice Item (postpaid) END -->
      </xsl:when>
      
      <xsl:when test="$PT='A' and $PrepaidTransaction='N'">
        <!-- Invoice Item (prepaid) START -->
      
         <bgh:row>
            <bgh:cell/>
            <bgh:cell/>
            <bgh:cell>
                <!-- quantity -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','56')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <!-- service -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','58')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>        
            
            <bgh:cell>
                <!-- package -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','59')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <!-- tariff model -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','60')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <!-- discount -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','71')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <!-- tax (percentage) -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','69')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <!-- tax -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','70')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <!-- net amount -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','64')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
        </bgh:row>
        <!-- Invoice Item (prepaid) END -->
      </xsl:when>
      
      <xsl:when test="$PT='A' and $PrepaidTransaction='Y' and $Debit='N'">
        <!-- Prepaid Credits START -->

        <bgh:row>
            <bgh:cell/>
            <bgh:cell/>
            <bgh:cell>
                <!-- quantity -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','56')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <!-- service -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','58')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
              
            <bgh:cell>
                <!-- transaction type -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','524')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <!-- package -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','59')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <!-- tariff model -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','60')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <!-- discount -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','71')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <!-- tax (percentage) -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','69')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <!-- tax -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','70')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <!-- net amount -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','64')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
        </bgh:row>
      
        <!-- Prepaid Credits END -->
      </xsl:when>
      
      <xsl:when test="$PT='A' and $PrepaidTransaction='Y' and $Debit='Y'">
        <!-- Prepaid Debits START -->

        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','56')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','58')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
              
            <bgh:cell>
                <!-- transaction type -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','524')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
              
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','59')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
              
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','60')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
              
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','71')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
              
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','69')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
              
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','70')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
              
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','64')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
              
        </bgh:row>
      
        <!-- Prepaid Debits END -->
      </xsl:when>
      
      <xsl:when test="$PT='A' and $PrepaidTransaction='Y' and $Debit='Y'">
        <!-- Prepaid Debits START -->

        
      
        <!-- Prepaid Debits END -->
      </xsl:when>
      
      <xsl:otherwise/>
    </xsl:choose>
  
  </xsl:template>
  
  
  
  <!-- Print table head for Tax -->  
  <xsl:template name="tax-table-head">
    <xsl:param name="PT"/>
  
  
    <xsl:choose>
      <xsl:when test="$PT='P'">
      
        <!-- Tax Info (postpaid) -->
        
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','340')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','343')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','344')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','345')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','346')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
        </bgh:row>
        
        <!-- Tax Info (postpaid) END -->
      </xsl:when>
      
      <xsl:when test="$PT='A'">
        <!-- Tax Info (prepaid) START -->
      
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','340')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
              
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','343')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
              
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','344')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
              
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','345')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
              
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','346')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            
        </bgh:row>
      
        <!-- Tax Info (prepaid) START -->
      </xsl:when>
      
      <xsl:when test="$PT='XY'">
        <!--  -->
      
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  
  </xsl:template>
  
  
  

  
  
  
  <!-- Invoice Item -->
  <xsl:template match="InvoiceItem">
  
    <bgh:row>
        <bgh:cell/>
        <bgh:cell/>
    
        <bgh:cell>
            <!-- quantity -->
            <xsl:value-of select="@NumItem"/>
        </bgh:cell>
      
        <!-- service -->
        <xsl:apply-templates select="AggSet" mode="invoice-item"/>
    
        <!-- promotion -->
        <bgh:cell>
            <xsl:choose>
              <xsl:when test="PromoItem">
                    <xsl:for-each select="PromoItem">
                      <xsl:apply-templates select="." mode="invoice-item"/>
                    </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                    <xsl:text>-</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
        </bgh:cell>
    
        <!-- tax -->
        <xsl:choose>
          <xsl:when test="Tax">
            <xsl:apply-templates select="Tax"/>
          </xsl:when>
          <xsl:otherwise>
            
          </xsl:otherwise>
        </xsl:choose>

    <!-- print net amount (multiple currency) -->
      
      <bgh:cell>
        <xsl:for-each select="Charge[@Id='125']">
        
          <xsl:variable name="number-format">
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="@Amount"/>
            </xsl:call-template>
          </xsl:variable>

              <xsl:value-of select="$number-format"/>
              <xsl:text> </xsl:text>
              
              <xsl:call-template name="currency">
                <xsl:with-param name="CurrCode" select="@CurrCode"/>
              </xsl:call-template>

            <xsl:if test="position()!=last()"> / </xsl:if>
          
        </xsl:for-each>
    
          
      </bgh:cell>

    </bgh:row>

  </xsl:template>

  
  <!-- invoice totals of postpaid amounts -->
  <xsl:template match="InvoiceTotals" mode="postpaid">
    
    <bgh:row>
        <bgh:cell>
            <!-- "Summary" -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','74')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        </bgh:cell>
    </bgh:row>


    
    <xsl:if test="Charge[@PT='P' and @Id='79' and @Type!='19']">
    
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
              <!-- invoice net (multiple currency) -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','80')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <xsl:for-each select="Charge[@PT='P' and @Id='79' and @Type!='19']">
                    <xsl:variable name="number-format">
                      <xsl:call-template name="number-format">
                        <xsl:with-param name="number" select="@Amount"/>
                      </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="$number-format"/>
                    <xsl:text> </xsl:text>
                      <xsl:call-template name="currency">
                        <xsl:with-param name="CurrCode" select="@CurrCode"/>
                      </xsl:call-template>
                    <xsl:if test="position()!=last()"> / </xsl:if>
                </xsl:for-each>
            </bgh:cell>
        </bgh:row>
    
    </xsl:if>
      
      
    <!-- invoice gross (multiple currency) -->
    <xsl:if test="Charge[@PT='P' and @Id='77' and @Type!='19']">

        <bgh:row>
            <bgh:cell/>
            <bgh:cell>

              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','77')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>

            </bgh:cell>
            <bgh:cell>
                <xsl:for-each select="Charge[@PT='P' and @Id='77' and @Type!='19']">
                  
                    <xsl:variable name="number-format">
                      <xsl:call-template name="number-format">
                        <xsl:with-param name="number" select="@Amount"/>
                      </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="$number-format"/>
                    <xsl:text> </xsl:text>
                      <xsl:call-template name="currency">
                        <xsl:with-param name="CurrCode" select="@CurrCode"/>
                      </xsl:call-template>
                    <xsl:if test="position()!=last()"> / </xsl:if>
                </xsl:for-each>
            </bgh:cell>
        </bgh:row>

    </xsl:if>
    
    
    <!-- own amount gross (multiple currency) -->
    <xsl:if test="Charge[@PT='P' and @Id='703']">

        <bgh:row>
            <bgh:cell/>
            <bgh:cell>

                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','442')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>

            </bgh:cell>
            <bgh:cell>

                <xsl:for-each select="Charge[@PT='P' and @Id='703']">
                  
                    <xsl:variable name="number-format">
                      <xsl:call-template name="number-format">
                        <xsl:with-param name="number" select="@Amount"/>
                      </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="$number-format"/>
                    <xsl:text> </xsl:text>
                      <xsl:call-template name="currency">
                        <xsl:with-param name="CurrCode" select="@CurrCode"/>
                      </xsl:call-template>
                    <xsl:if test="position()!=last()"> / </xsl:if>
                </xsl:for-each>
            </bgh:cell>
        </bgh:row>

    </xsl:if>
      
      
    <!-- collected amount gross (multiple currency) -->
    <xsl:if test="Charge[@PT='P' and @Id='704']">

        <bgh:row>
            <bgh:cell/>
            <bgh:cell>

              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','443')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>

            </bgh:cell>
            <bgh:cell>

            <xsl:for-each select="Charge[@PT='P' and @Id='704']">
              
                <xsl:variable name="number-format">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$number-format"/>
                <xsl:text> </xsl:text>
                  <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="@CurrCode"/>
                  </xsl:call-template>
              <xsl:if test="position()!=last()"> / </xsl:if>
            </xsl:for-each>

            </bgh:cell>
        </bgh:row>
            
    </xsl:if>
    
    
    <!-- old balance (multiple currency) -->
    <xsl:if test="Charge[@PT='P' and @Id='76']">

        <bgh:row>
            <bgh:cell/>
            <bgh:cell>

              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','76')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>

            </bgh:cell>
            <bgh:cell>

            <xsl:for-each select="Charge[@PT='P' and @Id='76']">
              
                <xsl:variable name="number-format">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$number-format"/>
                <xsl:text> </xsl:text>
                  <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="@CurrCode"/>
                  </xsl:call-template>
                <xsl:if test="position()!=last()"> / </xsl:if>
            </xsl:for-each>

            </bgh:cell>
        </bgh:row>

    </xsl:if>
      
      
    <!-- new balance (multiple currency) -->
    <xsl:if test="Charge[@PT='P' and @Id='78']">

        <bgh:row>
            <bgh:cell/>
            <bgh:cell>

              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','79')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>

            </bgh:cell>
            <bgh:cell>

            <xsl:for-each select="Charge[@PT='P' and @Id='78']">
              
                <xsl:variable name="number-format">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$number-format"/>
                <xsl:text> </xsl:text>
                  <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="@CurrCode"/>
                  </xsl:call-template>
                <xsl:if test="position()!=last()"> / </xsl:if>
            </xsl:for-each>

            </bgh:cell>
        </bgh:row>

    </xsl:if>
    
    
    
    <!-- amount to pay (multiple currency) -->
    <xsl:if test="Charge[@PT='P' and @Id='178']">

        <bgh:row>
            <bgh:cell/>
            <bgh:cell>

              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','82')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>

            </bgh:cell>
            <bgh:cell>

            <xsl:for-each select="Charge[@PT='P' and @Id='178']">
              
                <xsl:variable name="number-format">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$number-format"/>
                <xsl:text> </xsl:text>
                  <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="@CurrCode"/>
                  </xsl:call-template>
                <xsl:if test="position()!=last()"> / </xsl:if>
            </xsl:for-each>

            </bgh:cell>
        </bgh:row>
        
        <bgh:row/>
    </xsl:if>
        
  </xsl:template>
  

  <!-- invoice totals of prepaid amounts -->
  <xsl:template match="InvoiceTotals" mode="prepaid">

    <bgh:row>
        <bgh:cell>
      
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','74')[@xml:lang=$lang]/@Des"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="key('txt-index','286')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
      
        </bgh:cell>
    </bgh:row>
    

        
    <!-- invoice net (multiple currency) -->
    <xsl:if test="Charge[@PT='A' and @Id='79' and @Type!='19']">

        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
        
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','80')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>

            </bgh:cell>
            <bgh:cell>

                <xsl:for-each select="Charge[@PT='A' and @Id='79' and @Type!='19']">
                  
                    <xsl:variable name="number-format">
                      <xsl:call-template name="number-format">
                        <xsl:with-param name="number" select="@Amount"/>
                      </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="$number-format"/>
                    <xsl:text> </xsl:text>
                      <xsl:call-template name="currency">
                        <xsl:with-param name="CurrCode" select="@CurrCode"/>
                      </xsl:call-template>
                    <xsl:if test="position()!=last()"> / </xsl:if>
                </xsl:for-each>

            </bgh:cell>
        </bgh:row>
        
    </xsl:if>
      
      
      
    <!-- invoice gross (multiple currency) -->
    <xsl:if test="Charge[@PT='A' and @Id='77' and @Type!='19']">

        <bgh:row>
            <bgh:cell/>
            <bgh:cell>

              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','77')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>

            </bgh:cell>
            <bgh:cell>

              <xsl:for-each select="Charge[@PT='A' and @Id='77' and @Type!='19']">
              
                <xsl:variable name="number-format">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$number-format"/>
                <xsl:text> </xsl:text>
                  <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="@CurrCode"/>
                  </xsl:call-template>
                <xsl:if test="position()!=last()"> / </xsl:if>
              </xsl:for-each>

            </bgh:cell>
        </bgh:row>

    </xsl:if>
      
      
      
    <!-- old balance (multiple currency) -->
    <xsl:if test="Charge[@Id='700' and @PT='A']">

        <bgh:row>
            <bgh:cell/>
            <bgh:cell>

              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','427')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>

            </bgh:cell>
            <bgh:cell>

            <xsl:for-each select="Charge[@PT='A' and @Id='700']">
              
                <xsl:variable name="number-format">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$number-format"/>
                <xsl:text> </xsl:text>
                  <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="@CurrCode"/>
                  </xsl:call-template>
                <xsl:if test="position()!=last()"> / </xsl:if>
            </xsl:for-each>

            </bgh:cell>
        </bgh:row>

    </xsl:if>
          
          
          
    <!-- new balance (multiple currency) -->
    <xsl:if test="Charge[@Id='701' and @PT='A']">        

        <bgh:row>
            <bgh:cell/>
            <bgh:cell>

              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','428')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>

            </bgh:cell>
            <bgh:cell>

                <xsl:for-each select="Charge[@PT='A' and @Id='701']">
                  
                    <xsl:variable name="number-format">
                      <xsl:call-template name="number-format">
                        <xsl:with-param name="number" select="@Amount"/>
                      </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="$number-format"/>
                    <xsl:text> </xsl:text>
                      <xsl:call-template name="currency">
                        <xsl:with-param name="CurrCode" select="@CurrCode"/>
                      </xsl:call-template>
                    <xsl:if test="position()!=last()"> / </xsl:if>
                </xsl:for-each>

            </bgh:cell>
        </bgh:row>

    </xsl:if>
          
          
    <!-- amount to pay (multiple currency) -->
    <xsl:if test="Charge[@Id='702' and @PT='A']">

        <bgh:row>
            <bgh:cell/>
            <bgh:cell>

              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','429')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>

            </bgh:cell>
            <bgh:cell>

                <xsl:for-each select="Charge[@PT='A' and @Id='702']">
                  
                    <xsl:variable name="number-format">
                      <xsl:call-template name="number-format">
                        <xsl:with-param name="number" select="@Amount"/>
                      </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="$number-format"/>
                    <xsl:text> </xsl:text>
                      <xsl:call-template name="currency">
                        <xsl:with-param name="CurrCode" select="@CurrCode"/>
                      </xsl:call-template>
                    <xsl:if test="position()!=last()"> / </xsl:if>
                </xsl:for-each>

            </bgh:cell>
        </bgh:row>    

        <bgh:row/>
    </xsl:if>
          

  </xsl:template>

  
  <!-- discount totals -->
  <xsl:template match="DiscountTotals">

    <bgh:row>
        <bgh:cell>
            
              <xsl:for-each select="$txt"><!-- Discount Totals -->
                <xsl:value-of select="key('txt-index','397')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
              
        </bgh:cell>
            
    </bgh:row>

    <bgh:row>
      <bgh:cell/>
      
      <xsl:for-each select="$txt">
        
        <bgh:cell>
            <!-- Original -->
            <xsl:value-of select="key('txt-index','157')[@xml:lang=$lang]/@Des"/>
        </bgh:cell>
        <bgh:cell>
            <!-- Granted -->
           <xsl:value-of select="key('txt-index','158')[@xml:lang=$lang]/@Des"/>
        </bgh:cell>
        
      </xsl:for-each>
    </bgh:row>
    
    <!-- monetary discount info -->
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
            <xsl:for-each select="Charge[@Id='56']">
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="@Amount"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                  <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="@CurrCode"/>
                  </xsl:call-template>
                  <xsl:if test="position()!=last()"> / </xsl:if>
            </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
            <xsl:for-each select="Charge[@Id='55']">
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="@Amount"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                  <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="@CurrCode"/>
                  </xsl:call-template>
                  <xsl:if test="position()!=last()"> / </xsl:if>
            </xsl:for-each>
        </bgh:cell>
    </bgh:row>
        
        <!-- non monetary discount info -->
        <xsl:for-each select="DiscountValue">
            <bgh:row>
                <bgh:cell/>
                <xsl:apply-templates select="."/>
            </bgh:row>
        </xsl:for-each>
        
    <bgh:row/>

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
        
       
        
        <bgh:cell>
            <!-- tax rate -->
            <xsl:value-of select="$tax-rate"/>
        </bgh:cell>
    
        <bgh:cell>
          <!-- tax amount (multiple currency) -->
          <xsl:for-each select="Charge">
            
              <xsl:variable name="number-format">
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="@Amount"/>
                </xsl:call-template>
              </xsl:variable>

              <xsl:value-of select="$number-format"/>
              <xsl:text> </xsl:text>
                  <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="@CurrCode"/>
                  </xsl:call-template>
                  
                  <xsl:if test="position()!=last()"> / </xsl:if>

          </xsl:for-each>
        
        </bgh:cell>
            
        
      </xsl:when>
      <xsl:when test="name(..)='Invoice'">
        
        <bgh:row>  
            <bgh:cell/>
            <bgh:cell>
                <!-- tax category -->
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="@Cat"/>
                  <xsl:with-param name="Type"  select="'TCA'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
            </bgh:cell>
        
            <bgh:cell>
                <!-- tax rate -->
                <xsl:value-of select="$tax-rate"/>
            </bgh:cell>
        
            <bgh:cell>
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
            </bgh:cell>
        
            <bgh:cell>
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
            </bgh:cell>
        
            <bgh:cell>
                <!-- total tax amount (multiple currency) -->
                <xsl:for-each select="Charge[@Id='124']">
                
                  <xsl:variable name="number-format">
                    <xsl:call-template name="number-format">
                      <xsl:with-param name="number" select="@Amount"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:value-of select="$number-format"/>
                  <xsl:text> </xsl:text>
                  <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="@CurrCode"/>
                  </xsl:call-template>
                  
                  <xsl:if test="position()!=last()"> / </xsl:if>
            
                </xsl:for-each>
            </bgh:cell>
          
          </bgh:row>
        
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>
  
  
  <!-- Debit Note -->
  <xsl:template match="DebitNote">
  
  <bgh:row>
    <bgh:cell>
        <!-- Debit Note Purpose -->
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','530')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
    </bgh:cell>
    <bgh:cell>
        <xsl:value-of select="@Purpose"/>
    </bgh:cell>
  </bgh:row>
  
  <xsl:for-each select="DocRef">
    <bgh:row>
    
        <xsl:choose>
            <xsl:when test="position() = 1">
                <bgh:cell>
                    <!-- Referenced documents -->
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','531')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                </bgh:cell>
            </xsl:when>
            <xsl:otherwise>
                <bgh:cell/>
            </xsl:otherwise>
        </xsl:choose>
            
        <bgh:cell>
            <xsl:value-of select="@RefNum"/>
        </bgh:cell>
    </bgh:row>
    
  
  </xsl:for-each>
  
  
  <bgh:row/>
  
  </xsl:template>

</xsl:stylesheet>
