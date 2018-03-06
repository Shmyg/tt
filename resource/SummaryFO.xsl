<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    SummaryFO.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> XSL-FO stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms sum sheet documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/SummaryFO.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" exclude-result-prefixes="xsl cur">

  <xsl:key name="co-id" match="Contract" use="@Id"/>

  <!-- build a unique list of sum sheet contracts -->
  <xsl:variable name="sum-sheet-contracts" select="document(/Bill/Part/@File)/Document/Summary/CustRef/Contract"/>

  <xsl:variable name="list-of-sum-sheet-contracts">
    <xsl:for-each select="$sum-sheet-contracts/@Id">
      <xsl:sort select="." data-type="text"/>
      <xsl:value-of select="."/>
      <xsl:text> </xsl:text>
    </xsl:for-each>
  </xsl:variable>
        
  <xsl:variable name="list-of-unique-sum-sheet-contracts">
    <xsl:call-template name="remove-duplicates">
      <xsl:with-param name="list-of-services" select="$list-of-sum-sheet-contracts"/>
      <xsl:with-param name="last-service" select="''"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="call-details" select="document(/Bill/Part/@File)/Document/CallDetails"/>
  <xsl:variable name="invoice-charge-details" select="document(/Bill/Part/@File)/Document/ChargeDetails"/>
  <xsl:variable name="top-up-action-details" select="document(/Bill/Part/@File)/Document/RecordDetail"/>

  <!-- sum sheet -->
  <xsl:template match="Summary">
    <!--fo:block space-before="5mm" text-align="center" keep-with-next.within-page="always" font-weight="bold" font-size="9pt" >
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','91')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
    </fo:block-->

    <!-- totals -->
    <xsl:apply-templates select="Sums"/>

    <!-- customer -->
    <xsl:for-each select="CustRef">
      <xsl:sort select="@CustCode" data-type="text" order="ascending"/>
      <xsl:sort select="@BillSeqNo" data-type="number" order="ascending"/>
      <xsl:apply-templates select="."/>
    </xsl:for-each>

  </xsl:template>

  <!-- sums -->
  <xsl:template match="Sums">
    
    <fo:block space-after="6mm">
    
      <fo:block space-before="6mm" text-align="center" font-weight="bold" font-size="9pt">
        <xsl:for-each select="$txt"><!-- Sum Sheet -->
          <xsl:value-of select="key('txt-index','91')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </fo:block>
      
    <!-- postpaid sums -->
    <!-- Print POSTPAID sums only if they are != 0 -->
    <xsl:if test="Charge[@PT = 'P' and 0 != number(@Amount) ]">
    
      <fo:table table-layout="fixed" width="160mm">
        <fo:table-column column-width="30mm"/>
        <fo:table-column column-width="80mm"/>
        <fo:table-column column-width="20mm"/>
        <fo:table-column column-width="30mm"/>
        <fo:table-header space-after="1mm">
        
          <fo:table-row font-size="8pt" font-weight="bold">
            <xsl:for-each select="$txt">
              <fo:table-cell>
                <fo:block/>
              </fo:table-cell>
              <fo:table-cell border-bottom-width="0.1pt" border-bottom-style="solid" border-bottom-color="black">
                <fo:block>
                  <xsl:value-of select="key('txt-index','329')[@xml:lang=$lang]/@Des"/>
              </fo:block>
              </fo:table-cell>
              <fo:table-cell border-bottom-width="0.1pt" border-bottom-style="solid" border-bottom-color="black">
                <fo:block>
                  <xsl:value-of select="key('txt-index','50')[@xml:lang=$lang]/@Des"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block/>
              </fo:table-cell>
            </xsl:for-each>
          </fo:table-row>
        </fo:table-header>
        <fo:table-body font-size="8pt">

          <!-- net invoice amount postpaid (multiple currency) -->
          <xsl:if test="$pricing = 'N' or not(0 = number(Charge[@Id='177' and @PT='P']/@Amount) )  ">
              <fo:table-row>
                <fo:table-cell>
                  <fo:block/>
                </fo:table-cell>
                <fo:table-cell>
                  <fo:block>
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','94')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell text-align="right">
                  <xsl:for-each select="Charge[@Id='177' and @PT='P']">
                    <fo:block>
                      <xsl:call-template name="number-format">
                        <xsl:with-param name="number" select="@Amount"/>
                      </xsl:call-template>
                      <xsl:text> </xsl:text>
                      <xsl:for-each select="@CurrCode">
                        <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                      </xsl:for-each>
                    </fo:block>
                  </xsl:for-each>
                </fo:table-cell>
                <fo:table-cell>
                  <fo:block/>
                </fo:table-cell>
              </fo:table-row>
          </xsl:if>
          
          <!-- gross invoice amount postpaid (multiple currency) -->
          <xsl:if test="$pricing = 'G' or not(0 = number(Charge[@Id='277' and @PT='P']/@Amount) )  ">
              <fo:table-row>
                <fo:table-cell>
                  <fo:block/>
                </fo:table-cell>
                <fo:table-cell>
                  <fo:block>
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','95')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell text-align="right">
                  <xsl:for-each select="Charge[@Id='277' and @PT='P']">
                    <fo:block>
                      <xsl:call-template name="number-format">
                        <xsl:with-param name="number" select="@Amount"/>
                      </xsl:call-template>
                      <xsl:text> </xsl:text>
                      <xsl:for-each select="@CurrCode">
                        <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                      </xsl:for-each>
                    </fo:block>
                  </xsl:for-each>
                </fo:table-cell>
                <fo:table-cell>
                  <fo:block/>
                </fo:table-cell>
              </fo:table-row>
          </xsl:if>
          
          <!-- total net usage postpaid (multiple currency) -->
          <xsl:if test="$pricing = 'N' or not(0 = number(Charge[@Id='812' and @PT='P']/@Amount) )  ">
              <fo:table-row>
                <fo:table-cell>
                  <fo:block/>
                </fo:table-cell>
                <fo:table-cell>
                  <fo:block>
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','96')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell text-align="right">
                  <xsl:for-each select="Charge[@Id='812' and @PT='P']">
                    <fo:block>
                      <xsl:call-template name="number-format">
                        <xsl:with-param name="number" select="@Amount"/>
                      </xsl:call-template>
                      <xsl:text> </xsl:text>
                      <xsl:for-each select="@CurrCode">
                        <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                      </xsl:for-each>
                    </fo:block>
                  </xsl:for-each>
                </fo:table-cell>
                <fo:table-cell>
                  <fo:block/>
                </fo:table-cell>
              </fo:table-row>
          </xsl:if>
          
          <!-- total gross usage postpaid (multiple currency) -->
          <xsl:if test="$pricing = 'G' or not(0 = number(Charge[@Id='912' and @PT='P']/@Amount) )  ">
              <fo:table-row>
                <fo:table-cell>
                  <fo:block/>
                </fo:table-cell>
                <fo:table-cell>
                  <fo:block>
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','99')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell text-align="right">
                  <xsl:for-each select="Charge[@Id='912' and @PT='P']">
                    <fo:block>
                      <xsl:call-template name="number-format">
                        <xsl:with-param name="number" select="@Amount"/>
                      </xsl:call-template>
                      <xsl:text> </xsl:text>
                      <xsl:for-each select="@CurrCode">
                        <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                      </xsl:for-each>
                    </fo:block>
                  </xsl:for-each>
                </fo:table-cell>
                <fo:table-cell>
                  <fo:block/>
                </fo:table-cell>
              </fo:table-row>
          </xsl:if>
          
          <!-- total one-time charges net/gross postpaid (multiple currency) -->
          <fo:table-row>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','97')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell text-align="right">
              <xsl:for-each select="Charge[@Id='910' and @PT='P']">
                <fo:block>
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                  <xsl:text> </xsl:text>
                  <xsl:for-each select="@CurrCode">
                    <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                  </xsl:for-each>
                </fo:block>
              </xsl:for-each>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>
          
          <!-- total recurring charges net/gross postpaid (multiple currency) -->
          <fo:table-row>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','98')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell text-align="right">
              <xsl:for-each select="Charge[@Id='911' and @PT='P']">
                <fo:block>
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                  <xsl:text> </xsl:text>
                  <xsl:for-each select="@CurrCode">
                    <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                  </xsl:for-each>
                </fo:block>
              </xsl:for-each>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>
          
          <!-- total occ charges net/gross postpaid (multiple currency) -->
          <fo:table-row>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','100')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell text-align="right">
              <xsl:for-each select="Charge[@Id='913' and @PT='P']">
                <fo:block>
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                  <xsl:text> </xsl:text>
                  <xsl:for-each select="@CurrCode">
                    <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                  </xsl:for-each>
                </fo:block>
              </xsl:for-each>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
      
    </xsl:if>
      
    </fo:block>
    
    
    <xsl:if test="$fmt='rtf'">  
      <fo:block text-align="center" font-size="10pt" color="white">
        <xsl:text>-</xsl:text>
      </fo:block>
    </xsl:if>
    
    
    <!-- Print PREPAID sums only if they are != 0 -->
    <xsl:if test="Charge[@PT = 'A' and 0 != number(@Amount) ]">
    
    <!-- prepaid sums -->
    <fo:block space-before="5mm" space-after="6mm">
      <fo:table table-layout="fixed" width="160mm">
        <fo:table-column column-width="30mm"/>
        <fo:table-column column-width="80mm"/>
        <fo:table-column column-width="20mm"/>
        <fo:table-column column-width="30mm"/>
        <fo:table-header space-after="1mm">
          <fo:table-row font-size="8pt" font-weight="bold">
            <xsl:for-each select="$txt">
              <fo:table-cell>
                <fo:block/>
              </fo:table-cell>
              <fo:table-cell border-bottom-width="0.1pt" border-bottom-style="solid" border-bottom-color="black">
                <fo:block>
                  <xsl:value-of select="key('txt-index','329')[@xml:lang=$lang]/@Des"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="key('txt-index','286')[@xml:lang=$lang]/@Des"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border-bottom-width="0.1pt" border-bottom-style="solid" border-bottom-color="black">
                <fo:block>
                  <xsl:value-of select="key('txt-index','50')[@xml:lang=$lang]/@Des"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block/>
              </fo:table-cell>
            </xsl:for-each>
          </fo:table-row>
        </fo:table-header>
        <fo:table-body font-size="8pt">
      
      <!-- net invoice amount prepaid (multiple currency) -->
      <xsl:if test="$pricing-prepaid = 'N' or not(0 = number(Charge[@Id='177' and @PT='A']/@Amount) )  ">
          <fo:table-row >
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','94')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell text-align="right">
                    
              <xsl:for-each select="Charge[@Id='177' and @PT='A']">
                <fo:block>
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                  <xsl:text> </xsl:text>
                  <xsl:for-each select="@CurrCode">
                    <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                  </xsl:for-each>
                </fo:block>
              </xsl:for-each>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>
      </xsl:if>

      <!-- gross invoice amount prepaid (multiple currency) -->
      <xsl:if test="$pricing-prepaid = 'G' or not(0 = number(Charge[@Id='277' and @PT='A']/@Amount) )  ">
          <fo:table-row>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <fo:table-cell text-align="left">
              <fo:block>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','95')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell text-align="right">
              <xsl:for-each select="Charge[@Id='277' and @PT='A']">
                <fo:block>
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                  <xsl:text> </xsl:text>
                  <xsl:for-each select="@CurrCode">
                    <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                  </xsl:for-each>
                </fo:block>
              </xsl:for-each>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>
      </xsl:if>

      <!-- total net usage prepaid (multiple currency) -->
      <xsl:if test="$pricing-prepaid = 'N' or not(0 = number(Charge[@Id='812' and @PT='A']/@Amount) )  ">
          <fo:table-row>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','96')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell text-align="right">
              <xsl:for-each select="Charge[@Id='812' and @PT='A']">
                <fo:block>
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                  <xsl:text> </xsl:text>
                  <xsl:for-each select="@CurrCode">
                    <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                  </xsl:for-each>
                </fo:block>
              </xsl:for-each>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>
      </xsl:if>

      <!-- total gross usage prepaid (multiple currency) -->
      <xsl:if test="$pricing-prepaid = 'G' or not(0 = number(Charge[@Id='912' and @PT='A']/@Amount) )  ">
          <fo:table-row>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','99')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell text-align="right">
              <xsl:for-each select="Charge[@Id='912' and @PT='A']">
                <fo:block>
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                  <xsl:text> </xsl:text>
                  <xsl:for-each select="@CurrCode">
                    <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                  </xsl:for-each>
                </fo:block>
              </xsl:for-each>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>
      </xsl:if>

          <!-- total one-time charges net/gross prepaid (multiple currency) -->
          <xsl:if test="Charge[@Id='910' and @PT='A']">          
            <fo:table-row>
              <fo:table-cell>
                <fo:block/>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block>
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','97')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="right">
                <xsl:for-each select="Charge[@Id='910' and @PT='A']">
                  <fo:block>
                    <xsl:call-template name="number-format">
                      <xsl:with-param name="number" select="@Amount"/>
                    </xsl:call-template>
                    <xsl:text> </xsl:text>
                    <xsl:for-each select="@CurrCode">
                      <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                    </xsl:for-each>
                  </fo:block>
                </xsl:for-each>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- total recurring charges net/gross prepaid (multiple currency) -->
          <xsl:if test="Charge[@Id='911' and @PT='A']">          
            <fo:table-row>
              <fo:table-cell>
                <fo:block/>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block>
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','98')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="right">
                <xsl:for-each select="Charge[@Id='911' and @PT='A']">
                  <fo:block>
                    <xsl:call-template name="number-format">
                      <xsl:with-param name="number" select="@Amount"/>
                    </xsl:call-template>
                    <xsl:text> </xsl:text>
                    <xsl:for-each select="@CurrCode">
                      <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                    </xsl:for-each>
                  </fo:block>
                </xsl:for-each>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block/>
              </fo:table-cell>
            </fo:table-row>
            </xsl:if>
            
            <!-- total occ charges net/gross prepaid (multiple currency) -->
            <xsl:if test="Charge[@Id='913' and @PT='A']">
            <fo:table-row>
              <fo:table-cell>
                <fo:block/>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block>
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','100')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="right">
                <xsl:for-each select="Charge[@Id='913' and @PT='A']">
                  <fo:block>
                    <xsl:call-template name="number-format">
                      <xsl:with-param name="number" select="@Amount"/>
                    </xsl:call-template>
                    <xsl:text> </xsl:text>
                    <xsl:for-each select="@CurrCode">
                      <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                    </xsl:for-each>
                  </fo:block>
                </xsl:for-each>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
        </fo:table-body>
      </fo:table>
    </fo:block>
    
    </xsl:if>
    
  </xsl:template>

  <!-- billing account owner -->
  <xsl:template match="CustRef">
    
    <xsl:variable name="billseqno" select="@BillSeqNo"/>
    
    <fo:block space-after="6mm">
      <!-- fees -->
      <xsl:if test="SumItem">
    
    <fo:block space-before="10mm" space-after="1mm" font-size="9pt" font-weight="bold" text-align="center">
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','119')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
    </fo:block>
    
        <!--   Other Credits and Charges            -->
    <fo:block space-before="5mm" space-after="2mm">
      <fo:table width="160mm" table-layout="fixed">
        <fo:table-column column-width="15mm" column-number="1"/>
        <fo:table-column column-width="25mm" column-number="2"/>
        <fo:table-column column-width="20mm" column-number="3"/>
            <fo:table-column column-width="25mm" column-number="4"/>
            <fo:table-column column-width="25mm" column-number="5"/>
            <fo:table-column column-width="35mm" column-number="6"/>
            <fo:table-column column-width="15mm" column-number="7"/>
        
        <fo:table-header space-after="1mm">
          <fo:table-row font-size="8pt" font-weight="bold" text-align="center">
            <xsl:for-each select="$txt">
              <!-- quantity -->
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <fo:block><xsl:value-of select="key('txt-index','125')[@xml:lang=$lang]/@Des"/></fo:block>
              </fo:table-cell>
                  <!-- profile -->
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <fo:block><xsl:value-of select="key('txt-index','139')[@xml:lang=$lang]/@Des"/></fo:block>
              </fo:table-cell>
              <!-- service -->
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <fo:block><xsl:value-of select="key('txt-index','140')[@xml:lang=$lang]/@Des"/></fo:block>
              </fo:table-cell>
              <!-- package -->
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <fo:block><xsl:value-of select="key('txt-index','141')[@xml:lang=$lang]/@Des"/></fo:block>
              </fo:table-cell>
              <!-- tariff model -->
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <fo:block><xsl:value-of select="key('txt-index','142')[@xml:lang=$lang]/@Des"/></fo:block>
              </fo:table-cell>
              <!-- remark -->
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <fo:block><xsl:value-of select="key('txt-index','146')[@xml:lang=$lang]/@Des"/></fo:block>
              </fo:table-cell>
              <!-- charge -->
              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                <fo:block><xsl:value-of select="key('txt-index','143')[@xml:lang=$lang]/@Des"/></fo:block>
              </fo:table-cell>
            </xsl:for-each>
          </fo:table-row>
        </fo:table-header>
        
        <fo:table-body font-size="7pt">
          <xsl:for-each select="SumItem">
            <xsl:apply-templates select="."/>
          </xsl:for-each>
        </fo:table-body>
      </fo:table>
        </fo:block>
      </xsl:if>
    </fo:block>

    <!-- contract(s) -->
        
    <xsl:for-each select="Contract">

      <!-- contract sorting -->
      <xsl:sort select="@Id" data-type="text" order="ascending"/>

      <!-- billed alternative first -->
      <xsl:sort select="BOPAlt/@BILLED" data-type="text" order="descending"/>

      <xsl:if test="$fmt='rtf'" >
        <fo:block text-align="center" font-size="10pt" color="white">
          <xsl:text>-</xsl:text>
        </fo:block>
      </xsl:if>
        
      <!-- customer address -->
      <fo:block space-before="6mm" break-before="page">
          
      <fo:table width="160mm" table-layout="fixed">
        <fo:table-column column-width="110mm" column-number="1"/>
        <fo:table-column column-width="20mm"  column-number="2"/>
        <fo:table-column column-width="30mm"  column-number="3"/>
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell font-size="7pt">
              <fo:block>
                <xsl:apply-templates select="../Addr" mode="line"/>
              </fo:block>
            </fo:table-cell>
            <!-- customer number -->
            <fo:table-cell font-size="7pt">
              <fo:block>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','302')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell text-align="right" font-size="7pt">
              <fo:block>
                <fo:inline font-style="italic">
                  <xsl:value-of select="../@Id"/>
                </fo:inline>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
          <fo:table-row>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <!-- customer code -->
            <fo:table-cell font-size="7pt">
              <fo:block>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','303')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell text-align="right" font-size="7pt">
              <fo:block>
                <fo:inline font-style="italic">
                  <xsl:value-of select="../@CustCode"/>
                </fo:inline>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
          <fo:table-row>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <!-- billing request -->
            <fo:table-cell font-size="7pt">
              <fo:block>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','550')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell text-align="right" font-size="7pt">
              <fo:block>
                <fo:inline font-style="italic">
                  <xsl:value-of select="../@BillSeqNo"/>
                </fo:inline>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
          <fo:table-row>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <!-- billing period -->
            <fo:table-cell font-size="7pt">
              <fo:block>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','551')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell text-align="right" font-size="7pt">
              <fo:block>
                <fo:inline font-style="italic">                                  
                  <!-- period start -->
                  <xsl:if test="../Date[@Type='START']">
                    <xsl:call-template name="date-time-format">
                      <xsl:with-param name="date" select="../Date[@Type='START']/@Date"/>
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="../Date[@Type='END']">
                    <xsl:text> - </xsl:text>
                    <!-- period end -->
                    <xsl:call-template name="date-time-format">
                      <xsl:with-param name="date" select="../Date[@Type='END']/@Date"/>
                    </xsl:call-template>
                  </xsl:if>
                </fo:inline>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>          
        </fo:table-body>
      </fo:table>
    </fo:block>
        
        
        
        <!-- POSTPAID charges of customer -->
        
        <xsl:if test="../Charge[@PT='P' and 0 != number(@Amount) ]">
            
            <fo:block>
              <fo:block font-size="7pt" font-weight="bold" space-before="6mm">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','387')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            
              <fo:table table-layout="fixed" width="160mm">
                <fo:table-column column-width="60mm"/>
                <fo:table-column column-width="40mm"/>
                <fo:table-column column-width="60mm"/>
    
                <fo:table-body font-size="7pt">
                  <fo:table-row>
                    <!--  nested table for POSTPAID charges of customer -->
                    <fo:table-cell border-top-width="0.1pt" border-top-style="solid" border-top-color="black">
                      <fo:block>
                        <fo:table table-layout="fixed" width="160mm">
                          <fo:table-column column-width="40mm"/>
                          <fo:table-column column-width="20mm"/>
                          <fo:table-body>
                          
                            <!-- customer net amount postpaid (multiple currency) -->
                            <xsl:if test="$pricing = 'N' or not(0 = number(../Charge[@Id='830' and @PT='P']/@Amount) )  ">
                                <fo:table-row>
                                  <fo:table-cell>
                                    <fo:block>
                                      <xsl:for-each select="$txt">
                                        <xsl:value-of select="key('txt-index','102')[@xml:lang=$lang]/@Des"/>
                                      </xsl:for-each>
                                    </fo:block>
                                  </fo:table-cell>
                                  <fo:table-cell text-align="right">
                                    <xsl:for-each select="../Charge[@Id='830' and @PT='P']">
                                      <fo:block>
                                        <xsl:call-template name="number-format">
                                          <xsl:with-param name="number" select="@Amount"/>
                                        </xsl:call-template>
                                        <xsl:text> </xsl:text>
                                        <xsl:for-each select="@CurrCode">
                                          <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                                        </xsl:for-each>
                                      </fo:block>
                                    </xsl:for-each>
                                  </fo:table-cell>
                                </fo:table-row>
                            </xsl:if>
                            
                            <!-- customer gross amount postpaid (multiple currency) -->
                            <xsl:if test="$pricing = 'G' or not(0 = number(../Charge[@Id='930' and @PT='P']/@Amount) )  ">
                                <fo:table-row>
                                  <fo:table-cell>
                                    <fo:block>
                                      <xsl:for-each select="$txt">
                                        <xsl:value-of select="key('txt-index','104')[@xml:lang=$lang]/@Des"/>
                                      </xsl:for-each>
                                    </fo:block>
                                  </fo:table-cell>
                                  <fo:table-cell text-align="right">
                                    <xsl:for-each select="../Charge[@Id='930' and @PT='P']">
                                      <fo:block>
                                        <xsl:call-template name="number-format">
                                          <xsl:with-param name="number" select="@Amount"/>
                                        </xsl:call-template>
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
                    </fo:table-cell>
                    <fo:table-cell border-top-width="0.1pt" border-top-style="solid" border-top-color="black">
                      <fo:block/>
                    </fo:table-cell>
                    <fo:table-cell  border-top-width="0.1pt" border-top-style="solid" border-top-color="black">
                      <!-- usage charges of customer -->
                      <fo:block>
                        <fo:table table-layout="fixed" width="160mm">
                          <fo:table-column column-width="40mm"/>
                          <fo:table-column column-width="20mm"/>
                          <fo:table-body>
                          
                            <!-- customer net usage postpaid (multiple currency) -->
                            <xsl:if test="$pricing = 'N' or not(0 = number(../Charge[@Id='835' and @PT='P']/@Amount) )  ">
                                <fo:table-row>
                                  <fo:table-cell>
                                    <fo:block>
                                      <xsl:for-each select="$txt">
                                        <xsl:value-of select="key('txt-index','103')[@xml:lang=$lang]/@Des"/>
                                      </xsl:for-each>
                                    </fo:block>
                                  </fo:table-cell>
                                  <fo:table-cell text-align="right">
                                    <xsl:for-each select="../Charge[@Id='835' and @PT='P']">
                                      <fo:block>
                                        <xsl:call-template name="number-format">
                                          <xsl:with-param name="number" select="@Amount"/>
                                        </xsl:call-template>
                                        <xsl:text> </xsl:text>
                                        <xsl:for-each select="@CurrCode">
                                          <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                                        </xsl:for-each>
                                      </fo:block>
                                    </xsl:for-each>
                                  </fo:table-cell>
                                </fo:table-row>
                            </xsl:if>
                            
                            <!-- customer gross usage postpaid (multiple currency) -->
                            <xsl:if test="$pricing = 'G' or not(0 = number(../Charge[@Id='935' and @PT='P']/@Amount) )  ">
                                <fo:table-row>
                                  <fo:table-cell>
                                    <fo:block>
                                      <xsl:for-each select="$txt">
                                        <xsl:value-of select="key('txt-index','107')[@xml:lang=$lang]/@Des"/>
                                      </xsl:for-each>
                                    </fo:block>
                                  </fo:table-cell>
                                  <fo:table-cell text-align="right">
                                    <xsl:for-each select="../Charge[@Id='935' and @PT='P']">
                                      <fo:block>
                                        <xsl:call-template name="number-format">
                                          <xsl:with-param name="number" select="@Amount"/>
                                        </xsl:call-template>
                                        <xsl:text> </xsl:text>
                                        <xsl:for-each select="@CurrCode">
                                          <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                                        </xsl:for-each>
                                      </fo:block>
                                    </xsl:for-each>
                                  </fo:table-cell>
                                </fo:table-row>
                            </xsl:if>
                            
                            <!-- customer one-time charges net/gross postpaid (multiple currency) -->
                            <fo:table-row>
                              <fo:table-cell>
                                <fo:block>
                                  <xsl:for-each select="$txt">
                                    <xsl:value-of select="key('txt-index','105')[@xml:lang=$lang]/@Des"/>
                                  </xsl:for-each>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell text-align="right">
                                <xsl:for-each select="../Charge[@Id='933' and @PT='P']">
                                  <fo:block>
                                    <xsl:call-template name="number-format">
                                      <xsl:with-param name="number" select="@Amount"/>
                                    </xsl:call-template>
                                    <xsl:text> </xsl:text>
                                    <xsl:for-each select="@CurrCode">
                                      <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                                    </xsl:for-each>
                                  </fo:block>
                                </xsl:for-each>
                              </fo:table-cell>
                            </fo:table-row>
                            
                            <!-- customer recurring charges net/gross postpaid (multiple currency) -->
                            <fo:table-row>
                              <fo:table-cell>
                                <fo:block>
                                  <xsl:for-each select="$txt">
                                    <xsl:value-of select="key('txt-index','106')[@xml:lang=$lang]/@Des"/>
                                  </xsl:for-each>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell text-align="right">
                                <xsl:for-each select="../Charge[@Id='934'and @PT='P']">
                                  <fo:block>
                                    <xsl:call-template name="number-format">
                                      <xsl:with-param name="number" select="@Amount"/>
                                    </xsl:call-template>
                                    <xsl:text> </xsl:text>
                                    <xsl:for-each select="@CurrCode">
                                      <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                                    </xsl:for-each>
                                  </fo:block>
                                </xsl:for-each>
                              </fo:table-cell>
                            </fo:table-row>
                            
                            <!-- customer occ charges net/gross postpaid (multiple currency) -->
                            <fo:table-row>
                              <fo:table-cell>
                                <fo:block>
                                  <xsl:for-each select="$txt">
                                    <xsl:value-of select="key('txt-index','108')[@xml:lang=$lang]/@Des"/>
                                  </xsl:for-each>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell text-align="right">
                                <xsl:for-each select="../Charge[@Id='936' and @PT='P']">
                                  <fo:block>
                                    <xsl:call-template name="number-format">
                                      <xsl:with-param name="number" select="@Amount"/>
                                    </xsl:call-template>
                                    <xsl:text> </xsl:text>
                                    <xsl:for-each select="@CurrCode">
                                      <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                                    </xsl:for-each>
                                  </fo:block>
                                </xsl:for-each>
                              </fo:table-cell>
                            </fo:table-row>
                            
                          </fo:table-body>
                        </fo:table>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </fo:table-body>
              </fo:table>
            </fo:block>
            
        </xsl:if>
        

        
        
        <!-- PREPAID charges of customer -->
        
        <xsl:if test="../Charge[@PT='A' and 0 != number(@Amount) ]">
            
            <fo:block>
              <fo:block font-size="7pt" font-weight="bold" space-before="6mm">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','387')[@xml:lang=$lang]/@Des"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="key('txt-index','286')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
              
              <fo:table table-layout="fixed" width="160mm">
                <fo:table-column column-width="60mm"/>
                <fo:table-column column-width="40mm"/>
                <fo:table-column column-width="60mm"/>
    
                <fo:table-body font-size="7pt">
                  <fo:table-row>
                    <!--  nested table for PREAPAID charges of customer -->
                    <fo:table-cell border-top-width="0.1pt" border-top-style="solid" border-top-color="black">
                      <fo:block>
                        <fo:table table-layout="fixed" width="160mm">
                          <fo:table-column column-width="40mm"/>
                          <fo:table-column column-width="20mm"/>
                          <fo:table-body>
                          
                            <!-- customer net amount prepaid (multiple currency) -->
                            <xsl:if test="$pricing-prepaid = 'N' or not(0 = number(../Charge[@Id='830' and @PT='A']/@Amount) )  ">
                                <fo:table-row>
                                  <fo:table-cell>
                                    <fo:block>
                                      <xsl:for-each select="$txt">
                                        <xsl:value-of select="key('txt-index','102')[@xml:lang=$lang]/@Des"/>
                                      </xsl:for-each>
                                    </fo:block>
                                  </fo:table-cell>
                                  <fo:table-cell text-align="right">
                                    <xsl:for-each select="../Charge[@Id='830' and @PT='A']">
                                      <fo:block>
                                        <xsl:call-template name="number-format">
                                          <xsl:with-param name="number" select="@Amount"/>
                                        </xsl:call-template>
                                        <xsl:text> </xsl:text>
                                        <xsl:for-each select="@CurrCode">
                                          <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                                        </xsl:for-each>
                                      </fo:block>
                                    </xsl:for-each>
                                  </fo:table-cell>
                                </fo:table-row>
                            </xsl:if>
                            
                            <!-- customer gross amount prepaid (multiple currency) -->
                            <xsl:if test="$pricing-prepaid = 'G' or not(0 = number(../Charge[@Id='930' and @PT='A']/@Amount) )  ">
                                <fo:table-row>
                                  <fo:table-cell>
                                    <fo:block>
                                      <xsl:for-each select="$txt">
                                        <xsl:value-of select="key('txt-index','104')[@xml:lang=$lang]/@Des"/>
                                      </xsl:for-each>
                                    </fo:block>
                                  </fo:table-cell>
                                  <fo:table-cell text-align="right">
                                    <xsl:for-each select="../Charge[@Id='930' and @PT='A']">
                                      <fo:block>
                                        <xsl:call-template name="number-format">
                                          <xsl:with-param name="number" select="@Amount"/>
                                        </xsl:call-template>
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
                    </fo:table-cell>
                    <fo:table-cell border-top-width="0.1pt" border-top-style="solid" border-top-color="black">
                      <fo:block/>
                    </fo:table-cell>
                    <fo:table-cell border-top-width="0.1pt" border-top-style="solid" border-top-color="black">
                      <!-- PREPAID usage charges of customer -->
                      <fo:block>
                        <fo:table table-layout="fixed" width="160mm">
                          <fo:table-column column-width="40mm"/>
                          <fo:table-column column-width="20mm"/>
                          <fo:table-body>
                          
                            <!-- customer net usage PREPAID (multiple currency) -->
                            <xsl:if test="$pricing-prepaid = 'N' or not(0 = number(../Charge[@Id='835' and @PT='A']/@Amount) )  ">
                                <fo:table-row>
                                  <fo:table-cell>
                                    <fo:block>
                                      <xsl:for-each select="$txt">
                                        <xsl:value-of select="key('txt-index','96')[@xml:lang=$lang]/@Des"/>
                                      </xsl:for-each>
                                    </fo:block>
                                  </fo:table-cell>
                                  <fo:table-cell text-align="right">
                                    <xsl:for-each select="../Charge[@Id='835' and @PT='A']">
                                      <fo:block>
                                        <xsl:call-template name="number-format">
                                          <xsl:with-param name="number" select="@Amount"/>
                                        </xsl:call-template>
                                        <xsl:text> </xsl:text>
                                        <xsl:for-each select="@CurrCode">
                                          <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                                        </xsl:for-each>
                                      </fo:block>
                                    </xsl:for-each>
                                  </fo:table-cell>
                                </fo:table-row>
                            </xsl:if>
                            
                            <!-- customer gross usage prepaid (multiple currency) -->
                            <xsl:if test="$pricing-prepaid = 'G' or not(0 = number(../Charge[@Id='935' and @PT='A']/@Amount) )  ">
                                <fo:table-row>
                                  <fo:table-cell>
                                    <fo:block>
                                      <xsl:for-each select="$txt">
                                        <xsl:value-of select="key('txt-index','99')[@xml:lang=$lang]/@Des"/>
                                      </xsl:for-each>
                                    </fo:block>
                                  </fo:table-cell>
                                  <fo:table-cell text-align="right">
                                    <xsl:for-each select="../Charge[@Id='935' and @PT='A']">
                                      <fo:block>
                                        <xsl:call-template name="number-format">
                                          <xsl:with-param name="number" select="@Amount"/>
                                        </xsl:call-template>
                                        <xsl:text> </xsl:text>
                                        <xsl:for-each select="@CurrCode">
                                          <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                                        </xsl:for-each>
                                      </fo:block>
                                    </xsl:for-each>
                                  </fo:table-cell>
                                </fo:table-row>
                            </xsl:if>
                            
                            <!-- customer one-time charges net/gross prepaid (multiple currency) -->
                            <xsl:if test="Charge[@Id='933' and @PT='A']">
                            <fo:table-row>
                              <fo:table-cell>
                                <fo:block>
                                  <xsl:for-each select="$txt">
                                    <xsl:value-of select="key('txt-index','105')[@xml:lang=$lang]/@Des"/>
                                  </xsl:for-each>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell text-align="right">
                                <xsl:for-each select="../Charge[@Id='933' and @PT='A']">
                                  <fo:block>
                                    <xsl:call-template name="number-format">
                                      <xsl:with-param name="number" select="@Amount"/>
                                    </xsl:call-template>
                                    <xsl:text> </xsl:text>
                                    <xsl:for-each select="@CurrCode">
                                      <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                                    </xsl:for-each>
                                  </fo:block>
                                </xsl:for-each>
                              </fo:table-cell>
                            </fo:table-row>
                            </xsl:if>
                            
                            <!-- customer recurring charges net/gross prepaid (multiple currency) -->
                            <xsl:if test="Charge[@Id='934' and @PT='A']">
                            <fo:table-row>
                              <fo:table-cell>
                                <fo:block>
                                  <xsl:for-each select="$txt">
                                    <xsl:value-of select="key('txt-index','106')[@xml:lang=$lang]/@Des"/>
                                  </xsl:for-each>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell text-align="right">
                                <xsl:for-each select="../Charge[@Id='934'and @PT='A']">
                                  <fo:block>
                                    <xsl:call-template name="number-format">
                                      <xsl:with-param name="number" select="@Amount"/>
                                    </xsl:call-template>
                                    <xsl:text> </xsl:text>
                                    <xsl:for-each select="@CurrCode">
                                      <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                                    </xsl:for-each>
                                  </fo:block>
                                </xsl:for-each>
                              </fo:table-cell>
                            </fo:table-row>
                            </xsl:if>
                            
                            <!-- customer occ charges net/gross prepaid (multiple currency) -->
                            <xsl:if test="Charge[@Id='936' and @PT='A']">
                            <fo:table-row>
                              <fo:table-cell>
                                <fo:block>
                                  <xsl:for-each select="$txt">
                                    <xsl:value-of select="key('txt-index','108')[@xml:lang=$lang]/@Des"/>
                                  </xsl:for-each>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell text-align="right">
                                <xsl:for-each select="../Charge[@Id='936' and @PT='A']">
                                  <fo:block>
                                    <xsl:call-template name="number-format">
                                      <xsl:with-param name="number" select="@Amount"/>
                                    </xsl:call-template>
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
                    </fo:table-cell>
                  </fo:table-row>
                </fo:table-body>
              </fo:table>
            </fo:block>
            
        </xsl:if>
        

        
    <!-- contract -->
        
    <fo:block>
      <fo:block space-before="6mm" text-align="center" font-weight="bold" font-size="12pt">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','109')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </fo:block>
    
            
      <fo:table table-layout="fixed" font-size="7pt" width="160mm">
        <fo:table-column column-width="25mm" column-number="1"/>
        <fo:table-column column-width="30mm" column-number="2"/>
        <fo:table-column column-width="25mm" column-number="3"/>
        <fo:table-column column-width="50mm" column-number="4"/>
        <fo:table-column column-width="30mm" column-number="5"/>
    
        <fo:table-body>
          <!-- contract number -->
          <fo:table-row>
            <fo:table-cell>
              <fo:block>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','388')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell text-align="right">
              <fo:block>
                <xsl:value-of select="@Id"/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <xsl:choose>
              <xsl:when test="@BOPInd='Y'">
                <!-- BOP package -->
                <fo:table-cell>
                  <fo:block>
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','382')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell text-align="right">
                  <fo:block>
                    <xsl:call-template name="LgnMap">
                      <xsl:with-param name="Mode"  select="'0'"/>
                      <xsl:with-param name="Index" select="BOPAlt/@BOPPack"/>
                      <xsl:with-param name="Type"  select="'BOP'"/>
                      <xsl:with-param name="Desc"  select="'1'"/>
                    </xsl:call-template>
                  </fo:block>
                </fo:table-cell>
              </xsl:when>
              <xsl:otherwise>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
              </xsl:otherwise>
            </xsl:choose>
          </fo:table-row>
          <!-- market -->
          <fo:table-row>
            <fo:table-cell>
              <fo:block>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','111')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell text-align="right">
              <fo:block>
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="@MRKT"/>
                  <xsl:with-param name="Type"  select="'MRKT'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <xsl:choose>
              <xsl:when test="@BOPInd='Y'">
                <!-- BOP purpose -->
                <fo:table-cell>
                  <fo:block>
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','383')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell text-align="right">
                  <fo:block>
                    <xsl:call-template name="LgnMap">
                      <xsl:with-param name="Mode"  select="'0'"/>
                      <xsl:with-param name="Index" select="BOPAlt/@BOPPurp"/>
                      <xsl:with-param name="Type"  select="'BPURP'"/>
                      <xsl:with-param name="Desc"  select="'1'"/>
                    </xsl:call-template>
                  </fo:block>
                </fo:table-cell>
              </xsl:when>
              <xsl:otherwise>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
              </xsl:otherwise>
            </xsl:choose>
          </fo:table-row>
          <!-- sim number -->
          <fo:table-row>
            <fo:table-cell>
              <fo:block>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','112')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell text-align="right">
              <fo:block>
                <xsl:value-of select="@SM"/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <xsl:choose>
              <xsl:when test="@BOPInd='Y'">
                <!-- BOP tariff model or service package -->
                <fo:table-cell>
                  <fo:block>
                    <xsl:choose>
                      <xsl:when test="BOPAlt/AggSet/Att/@Ty='TM'">
                        <xsl:for-each select="$txt">
                          <xsl:value-of select="key('txt-index','369')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:for-each select="$txt">
                          <xsl:value-of select="key('txt-index','370')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text> (</xsl:text>
                    <xsl:choose>
                      <xsl:when test="BOPAlt/@CONTR='Y'">
                        <xsl:for-each select="$txt">
                          <xsl:value-of select="key('txt-index','371')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:for-each select="$txt">
                          <xsl:value-of select="key('txt-index','376')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>, </xsl:text>
                    <xsl:choose>
                      <xsl:when test="BOPAlt/@BILLED='Y'">
                        <xsl:for-each select="$txt">
                          <xsl:value-of select="key('txt-index','372')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:for-each select="$txt">
                          <xsl:value-of select="key('txt-index','377')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>)</xsl:text>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell text-align="right">
                  <fo:block>
                    <xsl:call-template name="LgnMap">
                      <xsl:with-param name="Mode"  select="'0'"/>
                      <xsl:with-param name="Index" select="BOPAlt/AggSet/Att/@Id"/>
                      <xsl:with-param name="Type"  select="BOPAlt/AggSet/Att/@Ty"/>
                      <xsl:with-param name="Desc"  select="'1'"/>
                    </xsl:call-template>
                  </fo:block>
                </fo:table-cell>
              </xsl:when>
              <xsl:otherwise>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
              </xsl:otherwise>
            </xsl:choose>
          </fo:table-row>           

          <xsl:variable name="bop-ind" select="@BOPInd"/>
          <xsl:variable name="bop-seq-no" select="BOPAlt/@BOPSeqNo"/>
          <xsl:choose>
            <!-- DNs -->
            <xsl:when test="DN">
              <xsl:for-each select="DN">
                <!-- sort the directory numbers -->
                <xsl:sort select="." data-type="number" order="ascending"/>
                <fo:table-row>
                  <xsl:apply-templates select="."/>
                  <xsl:call-template name="BOPIndY">
                    <xsl:with-param name="bop-ind" select="$bop-ind"/>
                    <xsl:with-param name="bop-seq-no" select="$bop-seq-no"/>
                  </xsl:call-template>
                </fo:table-row>
              </xsl:for-each>
            </xsl:when>
            <!-- DN block(s) -->
            <xsl:when test="DNBlock">
              <xsl:for-each select="DNBlock">
                <fo:table-row>
                  <xsl:apply-templates select="."/>
                  <xsl:call-template name="BOPIndY">
                    <xsl:with-param name="bop-ind" select="$bop-ind"/>
                    <xsl:with-param name="bop-seq-no" select="$bop-seq-no"/>
                  </xsl:call-template>
                </fo:table-row>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <fo:table-row>
                  <fo:table-cell>
                    <fo:block/>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block/>
                  </fo:table-cell>
                  <xsl:call-template name="BOPIndY">
                    <xsl:with-param name="bop-ind" select="$bop-ind"/>
                    <xsl:with-param name="bop-seq-no" select="$bop-seq-no"/>
                  </xsl:call-template>
                </fo:table-row>
            </xsl:otherwise>
          </xsl:choose>

          <!-- number of alternatives -->
          <xsl:variable name="co-alt" select="count(key('co-id',@Id))"/>
          <xsl:if test="$co-alt > 1 and @BOPInd='Y'">
            <fo:table-row>
              <fo:table-cell>
                <fo:block/>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block/>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block/>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block>
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','384')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="right">
                <fo:block>
                  <xsl:value-of select="count(key('co-id',@Id))"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>    
        </fo:table-body>
      </fo:table>
    </fo:block> 

    <!-- print contract(s) -->
    <xsl:apply-templates select="."/>


  </xsl:for-each>
        
  <!-- if no contracts are available, then print call details only -->
  <xsl:if test="not(Contract)">
    <xsl:call-template name="print-call-details-only">
      <xsl:with-param name="call-details" select="$call-details[parent::Document/@BillSeqNo = $billseqno]"/>
    </xsl:call-template>
  </xsl:if>

  </xsl:template>
  
  <!-- print bop seq no. for DN and DN block -->
  <xsl:template name="BOPIndY">
    <xsl:param name="bop-ind"/>
    <xsl:param name="bop-seq-no"/>
      <fo:table-cell>
        <fo:block/>
      </fo:table-cell>     
      <xsl:choose>
        <xsl:when test="$bop-ind='Y'">
          <!-- bop sequence no. -->
          <fo:table-cell>
            <fo:block>
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','381')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell text-align="right">
            <fo:block>
              <xsl:value-of select="$bop-seq-no"/>
            </fo:block>
          </fo:table-cell>
        </xsl:when>
        <xsl:otherwise>
          <fo:table-cell>
            <fo:block/>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block/>
          </fo:table-cell>
        </xsl:otherwise>
      </xsl:choose>    

  </xsl:template> 

  <!-- contract -->
  <xsl:template match="Contract">

    <xsl:variable name="co-id"     select="@Id"/>
    <xsl:variable name="bop-ind"   select="@BOPInd"/>
    <xsl:variable name="billed"    select="BOPAlt/@BILLED"/>
    <xsl:variable name="bop-id"    select="BOPAlt/AggSet/Att/@Id"/>
    <xsl:variable name="billseqno" select="../@BillSeqNo"/>

    <!-- contract sums  (POSTPAID)  -->
    
    <xsl:if test="Charge[@PT='P' and 0 != number(@Amount) ]">
      
        <fo:block space-before="6mm"  font-size="8pt" font-weight="bold" text-align="center">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','329')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </fo:block>
        
        <fo:table table-layout="fixed" width="160mm">
          <fo:table-column column-width="30mm"/>
          <fo:table-column column-width="80mm"/>
          <fo:table-column column-width="20mm"/>
          <fo:table-column column-width="30mm"/>
          <!-- header column for contract sums -->
            
          <fo:table-body font-size="8pt" space-before="2mm">
          
            <fo:table-row><!-- This row is only here to insert a black line -->
                <fo:table-cell>
                    <fo:block/>
                </fo:table-cell>
                <fo:table-cell border-top-width="0.1pt" border-top-style="solid" border-top-color="black">
                    <fo:block/>
                </fo:table-cell>
                <fo:table-cell border-top-width="0.1pt" border-top-style="solid" border-top-color="black">
                    <fo:block/>
                </fo:table-cell>
                <fo:table-cell>
                    <fo:block/>
                </fo:table-cell>
            </fo:table-row>
          
            <!-- contract net amount postpaid (multiple currency) -->
            <xsl:if test="$pricing-prepaid = 'N' or not(0 = number(Charge[@Id='831' and @PT='P']/@Amount) )  ">
                <fo:table-row line-height="10pt">
                  <fo:table-cell>
                    <fo:block/>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block font-size="8pt">
                      <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','114')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                    <xsl:for-each select="Charge[@Id='831' and @PT='P']">
                      <fo:block>
                        <xsl:call-template name="number-format">
                          <xsl:with-param name="number" select="@Amount"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                        <xsl:for-each select="@CurrCode">
                          <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                        </xsl:for-each>
                      </fo:block>
                    </xsl:for-each>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block/>
                  </fo:table-cell>
                </fo:table-row>
            </xsl:if>
            
            <!-- contract gross amount postpaid (multiple currency) -->
            <xsl:if test="$pricing = 'G' or not(0 = number(Charge[@Id='931' and @PT='P']/@Amount) )  ">
                <fo:table-row line-height="10pt">
                  <fo:table-cell>
                    <fo:block/>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block>
                      <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','115')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="right">
                    <xsl:for-each select="Charge[@Id='931' and @PT='P']">
                      <fo:block>
                        <xsl:call-template name="number-format">
                          <xsl:with-param name="number" select="@Amount"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                        <xsl:for-each select="@CurrCode">
                          <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                        </xsl:for-each>
                      </fo:block>
                    </xsl:for-each>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block/>
                  </fo:table-cell>
                </fo:table-row>
            </xsl:if>
            
          </fo:table-body>
        </fo:table>

      
    </xsl:if>
    
    
    <!-- show prepaid charges only if contract is not BOP related -->
    <xsl:if test="@BOPInd='N' and Charge[@PT='A' and 0 != number(@Amount) ]">
    
      <!-- contract sums  (PREPAID)  -->
      <fo:block space-before="6mm" font-size="8pt" font-weight="bold" text-align="center">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','329')[@xml:lang=$lang]/@Des"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="key('txt-index','286')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </fo:block>
      
      <fo:table table-layout="fixed" width="160mm">
        <fo:table-column column-width="30mm"/>
        <fo:table-column column-width="80mm"/>
        <fo:table-column column-width="20mm"/>
        <fo:table-column column-width="30mm"/>
           
        <fo:table-body font-size="8pt" space-before="2mm">
        
          <fo:table-row><!-- This row is only here to insert a black line -->
            <fo:table-cell>
                <fo:block/>
            </fo:table-cell>
            <fo:table-cell border-top-width="0.1pt" border-top-style="solid" border-top-color="black">
                <fo:block/>
            </fo:table-cell>
            <fo:table-cell border-top-width="0.1pt" border-top-style="solid" border-top-color="black">
                <fo:block/>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block/>
            </fo:table-cell>
          </fo:table-row>
        
          <!-- contract net amount prepaid (multiple currency) -->
          <xsl:if test="$pricing-prepaid = 'N' or not(0 = number(Charge[@Id='831' and @PT='A']/@Amount) )  ">
              <fo:table-row line-height="10pt">
                <fo:table-cell>
                  <fo:block/>
                </fo:table-cell>
                <fo:table-cell >
                  <fo:block>
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','102')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell text-align="right" >
                  <xsl:for-each select="Charge[@Id='831' and @PT='A']">
                    <fo:block>
                      <xsl:call-template name="number-format">
                        <xsl:with-param name="number" select="@Amount"/>
                      </xsl:call-template>
                      <xsl:text> </xsl:text>
                      <xsl:for-each select="@CurrCode">
                        <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                      </xsl:for-each>
                    </fo:block>
                  </xsl:for-each>
                </fo:table-cell>
                <fo:table-cell>
                  <fo:block/>
                </fo:table-cell>
              </fo:table-row>
          </xsl:if>
          
          <!-- contract gross amount prepaid (multiple currency) -->
          <xsl:if test="$pricing-prepaid = 'G' or not(0 = number(Charge[@Id='931' and @PT='A']/@Amount) )  ">
              <fo:table-row line-height="10pt">
                <fo:table-cell>
                  <fo:block/>
                </fo:table-cell>
                <fo:table-cell>
                  <fo:block>
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','104')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell text-align="right">
                  <xsl:for-each select="Charge[@Id='931' and @PT='A']">
                    <fo:block>
                      <xsl:call-template name="number-format">
                        <xsl:with-param name="number" select="@Amount"/>
                      </xsl:call-template>
                      <xsl:text> </xsl:text>
                      <xsl:for-each select="@CurrCode">
                        <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                      </xsl:for-each>
                    </fo:block>
                  </xsl:for-each>
                </fo:table-cell>
                <fo:table-cell>
                  <fo:block/>
                </fo:table-cell>
              </fo:table-row>
          </xsl:if>
          
        </fo:table-body>
      </fo:table>
      
    </xsl:if>

    <!-- charge types -->
    <xsl:for-each select="PerCTInfo">
        
      <fo:block space-before="6mm" font-size="8pt" font-weight="bold"  text-align="center">
        <xsl:choose>
      <xsl:when test="@CT='A'">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','116')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="@CT='P'">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','117')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="@CT='S'">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','118')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="@CT='O'">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','119')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="@CT='U'">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','120')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
    <xsl:if test="@PT='A'">
      <xsl:text> </xsl:text>
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','286')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
    </xsl:if>
      </fo:block>
          
      <fo:table width="160mm" table-layout="fixed">
        <fo:table-column column-width="80mm" column-number="1"/>
        <fo:table-column column-width="80mm" column-number="2"/>

        <!-- Charges on PerCTInfo-Level; amounts per contract and charge type  -->
        <fo:table-body font-size="8pt">
        
          <fo:table-row><!-- This row is only here to insert a black line -->
            <fo:table-cell border-top-width="0.1pt" border-top-style="solid" border-top-color="black">
                <fo:block/>
            </fo:table-cell>
            <fo:table-cell border-top-width="0.1pt" border-top-style="solid" border-top-color="black">
                <fo:block/>
            </fo:table-cell>
          </fo:table-row>
        
          <!-- charge type net postpaid/prepaid (multiple currency) -->
          <xsl:if test="(($pricing = 'N' and @PT = 'P') or ($pricing-prepaid = 'N' and @PT = 'A') ) or not(0 = number(Charge[@Id='832']/@Amount) )  ">
              <fo:table-row line-height="10pt">
                <fo:table-cell >
                  <fo:block>
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','121')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell text-align="right" >
                  <xsl:for-each select="Charge[@Id='832']">
                    <fo:block>
                      <xsl:call-template name="number-format">
                        <xsl:with-param name="number" select="@Amount"/>
                      </xsl:call-template>
                      <xsl:text> </xsl:text>
                      <xsl:for-each select="@CurrCode">
                        <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                      </xsl:for-each>
                    </fo:block>
                  </xsl:for-each>
                </fo:table-cell>
              </fo:table-row>
          </xsl:if>
          
          <!-- charge type net undiscounted (multiple currency) -->
          <xsl:if test="(($pricing = 'N' and @PT = 'P') or ($pricing-prepaid = 'N' and @PT = 'A') ) or not(0 = number(Charge[@Id='838']/@Amount) ) ">
              <fo:table-row line-height="10pt">
                <fo:table-cell>
                  <fo:block>
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','122')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell text-align="right">
                  <xsl:for-each select="Charge[@Id='838']">
                    <fo:block>
                      <xsl:call-template name="number-format">
                        <xsl:with-param name="number" select="@Amount"/>
                      </xsl:call-template>
                      <xsl:text> </xsl:text>
                      <xsl:for-each select="@CurrCode">
                        <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                      </xsl:for-each>
                    </fo:block>
                  </xsl:for-each>
                </fo:table-cell>
              </fo:table-row>
          </xsl:if>
          
          <!-- charge type net ATM (multiple currency) -->
          <!-- ATM is not available for BOP case and for Prepaid -->
          <xsl:if test="ancestor::Contract[@BOPInd='N'] and @PT='P'">
            <xsl:if test="$pricing = 'N' and not(0 = number(Charge[@Id='837']/@Amount) ) ">
                <fo:table-row line-height="10pt">
                  <fo:table-cell>
                    <fo:block>
                      <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','137')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="right">
                    <xsl:for-each select="Charge[@Id='837']">
                      <fo:block>
                        <xsl:call-template name="number-format">
                          <xsl:with-param name="number" select="@Amount"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                        <xsl:for-each select="@CurrCode">
                          <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                        </xsl:for-each>
                      </fo:block>
                    </xsl:for-each>
                  </fo:table-cell>
                </fo:table-row>
            </xsl:if>
          </xsl:if>
          
          <!-- charge type gross (multiple currency) -->
          <xsl:if test="(($pricing = 'G' and @PT = 'P') or ($pricing-prepaid = 'G' and @PT = 'A') ) or not(0 = number(Charge[@Id='932']/@Amount) ) ">
              <fo:table-row line-height="10pt">
                <fo:table-cell>
                  <fo:block font-size="8pt">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','123')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell text-align="right">
                  <xsl:for-each select="Charge[@Id='932']">
                    <fo:block>
                      <xsl:call-template name="number-format">
                        <xsl:with-param name="number" select="@Amount"/>
                      </xsl:call-template>
                      <xsl:text> </xsl:text>
                      <xsl:for-each select="@CurrCode">
                        <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                      </xsl:for-each>
                    </fo:block>
                  </xsl:for-each>
                </fo:table-cell>
              </fo:table-row>
          </xsl:if>
          
          <!-- charge type gross undiscounted (multiple currency) -->
          <xsl:if test="(($pricing = 'G' and @PT = 'P') or ($pricing-prepaid = 'G' and @PT = 'A') ) or not(0 = number(Charge[@Id='938']/@Amount) ) ">
              <fo:table-row line-height="10pt">
                <fo:table-cell>
                  <fo:block>
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','124')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell text-align="right">
                  <xsl:for-each select="Charge[@Id='938']">
                    <fo:block>
                      <xsl:call-template name="number-format">
                        <xsl:with-param name="number" select="@Amount"/>
                      </xsl:call-template>
                      <xsl:text> </xsl:text>
                      <xsl:for-each select="@CurrCode">
                        <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                      </xsl:for-each>
                    </fo:block>
                  </xsl:for-each>
                </fo:table-cell>
              </fo:table-row>
          </xsl:if>
          
          <!-- charge type gross ATM (multiple currency) -->
          <!-- ATM is not available for BOP case and for Prepaid -->
          <xsl:if test="ancestor::Contract[@BOPInd='N'] and @PT='P'">
              <xsl:if test="$pricing = 'G' and not(0 = number(Charge[@Id='838']/@Amount) ) ">
                <fo:table-row line-height="10pt">
                  <fo:table-cell>
                    <fo:block>
                      <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','138')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="right">
                    <xsl:for-each select="Charge[@Id='937']">
                      <fo:block>
                        <xsl:call-template name="number-format">
                          <xsl:with-param name="number" select="@Amount"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                        <xsl:for-each select="@CurrCode">
                          <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                        </xsl:for-each>
                      </fo:block>
                    </xsl:for-each>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>
          </xsl:if>
        </fo:table-body>
      </fo:table>
          
      <!-- sum items -->
      <xsl:if test="SumItem">
        <xsl:if test="$fmt='rtf'">  
          <fo:block text-align="center" font-size="10pt" color="white">
            <xsl:text>-</xsl:text>
          </fo:block>
        </xsl:if>
        <fo:block space-before="3mm">
          <fo:table width="160mm" table-layout="fixed">
            <xsl:choose>
              <!-- subscription charges -->
              <xsl:when test="@CT='S'">
                <fo:table-column column-width="20mm" column-number="1"/>
                <fo:table-column column-width="20mm" column-number="2"/>
                <fo:table-column column-width="20mm" column-number="3"/>
                <fo:table-column column-width="20mm" column-number="4"/>
                <fo:table-column column-width="20mm" column-number="5"/>
                <fo:table-column column-width="20mm" column-number="6"/>
                <fo:table-column column-width="20mm" column-number="7"/>
                <fo:table-column column-width="20mm" column-number="8"/>
              </xsl:when>
              <!-- usage charges -->
              <xsl:when test="@CT='U'">
                <fo:table-column column-width="15mm" column-number="1"/>
                <fo:table-column column-width="25mm" column-number="2"/>
                <fo:table-column column-width="25mm" column-number="3"/>
                <fo:table-column column-width="25mm" column-number="4"/>
                <fo:table-column column-width="25mm" column-number="5"/>
                <fo:table-column column-width="25mm" column-number="6"/>
                <fo:table-column column-width="20mm" column-number="7"/>
              </xsl:when>
              <!-- access charges -->
              <xsl:when test="@CT='A'">
                <fo:table-column column-width="12mm" column-number="1"/>
                <fo:table-column column-width="15mm" column-number="2"/>
                <fo:table-column column-width="19mm" column-number="3"/>
                <fo:table-column column-width="19mm" column-number="4"/>
                <fo:table-column column-width="19mm" column-number="5"/>
                <fo:table-column column-width="19mm" column-number="6"/>
                <fo:table-column column-width="30mm" column-number="7"/>
                <fo:table-column column-width="15mm" column-number="8"/>
                <fo:table-column column-width="12mm" column-number="9"/>
              </xsl:when>
              <!-- other charges or P -->
              <xsl:when test="@CT='O' or @CT='P'">
                <fo:table-column column-width="20mm" column-number="1"/>
                <fo:table-column column-width="20mm" column-number="2"/>
                <fo:table-column column-width="20mm" column-number="3"/>
                <fo:table-column column-width="20mm" column-number="4"/>
                <fo:table-column column-width="20mm" column-number="5"/>
                <fo:table-column column-width="40mm" column-number="6"/> 
                <fo:table-column column-width="20mm" column-number="7"/>
              </xsl:when>
            </xsl:choose>

                    
            <fo:table-header space-after="1mm">
              <fo:table-row>
                <!-- quantity -->
                <fo:table-cell border-bottom-width="0.005pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block font-size="7pt" font-weight="bold"  text-align="center" space-before="3mm">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','125')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
                <!-- active days -->
                <xsl:if test="@CT='A'">
                  <fo:table-cell border-bottom-width="0.005pt" border-bottom-style="solid" border-bottom-color="black">
                    <fo:block font-size="7pt" font-weight="bold"  text-align="center" space-before="3mm">
                      <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','126')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </fo:block>
                  </fo:table-cell>
                </xsl:if>
                <!-- profile -->
                <fo:table-cell border-bottom-width="0.005pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block font-size="7pt" font-weight="bold"  text-align="center" space-before="3mm">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','139')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
                <!-- service -->
                <fo:table-cell border-bottom-width="0.005pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block font-size="7pt" font-weight="bold"  text-align="center" space-before="3mm">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','140')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
                <!-- package -->
                <fo:table-cell border-bottom-width="0.005pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block font-size="7pt" font-weight="bold"  text-align="center" space-before="3mm">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','141')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
                <!-- tariff model -->
                <fo:table-cell border-bottom-width="0.005pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block font-size="7pt" font-weight="bold"  text-align="center" space-before="3mm"> 
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','142')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
                <!-- remark -->
                <xsl:if test="@CT='O' or @CT='P'">
                  <fo:table-cell border-bottom-width="0.005pt" border-bottom-style="solid" border-bottom-color="black">
                    <fo:block font-size="7pt" font-weight="bold"  text-align="center" space-before="3mm">
                      <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','288')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </fo:block>
                  </fo:table-cell>
                </xsl:if>
                <!-- period info -->
                <xsl:if test="@CT='A'">
                  <fo:table-cell border-bottom-width="0.005pt" border-bottom-style="solid" border-bottom-color="black">
                    <fo:block font-size="7pt" font-weight="bold"  text-align="center" space-before="3mm">
                      <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','145')[@xml:lang=$lang]/@Des"/>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="key('txt-index','290')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </fo:block>
                  </fo:table-cell>
                </xsl:if>
                <!-- service parameter info -->
                <xsl:if test="@CT='S'">
                  <fo:table-cell border-bottom-width="0.005pt" border-bottom-style="solid" border-bottom-color="black">
                    <fo:block font-size="7pt" font-weight="bold"  text-align="center" space-before="3mm">
                      <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','289')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </fo:block>
                  </fo:table-cell>
                </xsl:if>
                <!-- price/period -->
                <xsl:if test="@CT='S' or @CT='A'">
                  <fo:table-cell border-bottom-width="0.005pt" border-bottom-style="solid" border-bottom-color="black">
                    <fo:block font-size="7pt" font-weight="bold"  text-align="center" space-before="3mm">
                      <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','144')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </fo:block>
                  </fo:table-cell>
                </xsl:if>
                <!-- content product info -->
                <xsl:choose>
                  <xsl:when test="@CT='U'">
                    <fo:table-cell border-bottom-width="0.005pt" border-bottom-style="solid" border-bottom-color="black">
                      <fo:block font-size="7pt" font-weight="bold"  text-align="center" space-before="3mm">
                        <!-- catalogue -->
                        <xsl:for-each select="$txt">
                          <xsl:value-of select="key('txt-index','418')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                        <xsl:text> / </xsl:text>
                        <!-- element -->
                        <xsl:for-each select="$txt">
                          <xsl:value-of select="key('txt-index','419')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                        <xsl:text> / </xsl:text>
                        <!-- price list -->
                        <xsl:for-each select="$txt">
                          <xsl:value-of select="key('txt-index','420')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                        <xsl:text> / </xsl:text>
                        <!-- usage type -->
                        <xsl:for-each select="$txt">
                          <xsl:value-of select="key('txt-index','444')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                      </fo:block>
                    </fo:table-cell>
                  </xsl:when>
                  <xsl:otherwise/>
                </xsl:choose>
                <!-- charge -->
                <fo:table-cell border-bottom-width="0.005pt" border-bottom-style="solid" border-bottom-color="black">
                  <fo:block font-size="7pt" font-weight="bold"  text-align="center" space-before="3mm">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','143')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </fo:table-header>
            <fo:table-body font-size="7pt">
              <xsl:for-each select="SumItem">
                <xsl:apply-templates select="."/>
              </xsl:for-each>
            </fo:table-body>
          </fo:table>
        </fo:block> 
      </xsl:if>
    </xsl:for-each>
        
    <!-- balance snapshots -->  
    <xsl:if test="$bop-ind='N' or $billed='Y'">

      <xsl:call-template name="contract-balance-snapshots">
        <xsl:with-param name="co-id" select="$co-id"/>
      </xsl:call-template>

    </xsl:if>

    <!-- balance adjustments -->
    <xsl:if test="$bop-ind='N' or $billed='Y'">

      <xsl:call-template name="contract-balance-adjustments">
        <xsl:with-param name="co-id" select="$co-id"/>
      </xsl:call-template>

    </xsl:if>

    <!-- shared accounts -->
    <xsl:if test="$bop-ind='N' or $billed='Y'">

      <xsl:call-template name="contract-shared-accounts">
        <xsl:with-param name="co-id" select="$co-id"/>
      </xsl:call-template>

    </xsl:if>

    <!-- top-up actions -->
    <xsl:call-template name="record-details">

      <xsl:with-param name="co-id" select="$co-id"/>
      <xsl:with-param name="top-up-actions" select="$top-up-action-details[parent::Document/@BillSeqNo = $billseqno]"/>

    </xsl:call-template>

    <!-- free units / price plan info -->  
    <xsl:if test="$bop-ind='N' or ./BOPAlt/AggSet/Att/@Id=$bop-id">

      <xsl:call-template name="contract-free-units-accounts">
        <xsl:with-param name="co-id" select="$co-id"/>
        <xsl:with-param name="bop-id" select="$bop-id"/>
      </xsl:call-template>

      <xsl:call-template name="contract-free-units-statistic">
        <xsl:with-param name="co-id" select="$co-id"/>
        <xsl:with-param name="bop-id" select="$bop-id"/>
      </xsl:call-template>

    </xsl:if>

    <!-- cost control discount info -->
    <xsl:if test="ancestor::CustRef[@PartyType!='C']">

      <xsl:call-template name="contract-cost-control-discounts">
        <xsl:with-param name="co-id" select="$co-id"/>
        <xsl:with-param name="bop-id" select="$bop-id"/>
      </xsl:call-template>

    </xsl:if>

    <!-- external discount info ( e. g. charging system ) -->
    <xsl:call-template name="contract-external-discounts">
      <xsl:with-param name="co-id" select="$co-id"/>
    </xsl:call-template>

    <!-- credits granted to prepaid balance -->
    <xsl:call-template name="contract-promo-credits">
      <xsl:with-param name="co-id" select="$co-id"/>
    </xsl:call-template>

    <!-- bundle products -->
    <xsl:call-template name="contract-bundle-products">
      <xsl:with-param name="co-id" select="$co-id"/>
      <xsl:with-param name="bopind" select="@BOPInd"/>
      <xsl:with-param name="bopseqno" select="BOPAlt/@BOPSeqNo"/>
      <xsl:with-param name="boptype" select="BOPAlt/AggSet/Att/@Ty"/>
    </xsl:call-template>

    <!-- bundle usage -->
    <xsl:call-template name="print-call-details-bundle-usage">
      <xsl:with-param name="co-id" select="$co-id"/>
      <xsl:with-param name="call-details" select="$call-details[parent::Document/@BillSeqNo = $billseqno]"/>
      <xsl:with-param name="bopind" select="@BOPInd"/>
      <xsl:with-param name="bopseqno" select="BOPAlt/@BOPSeqNo"/>
      <xsl:with-param name="boptype" select="BOPAlt/AggSet/Att/@Ty"/>
    </xsl:call-template>

    <!-- recurring charge details info -->
    <xsl:call-template name="print-charge-details">
      <xsl:with-param name="co-id" select="$co-id"/>
      <xsl:with-param name="bopind" select="@BOPInd"/>
      <xsl:with-param name="bopseqno" select="BOPAlt/@BOPSeqNo"/>
      <xsl:with-param name="boptype" select="BOPAlt/AggSet/Att/@Ty"/>
      <xsl:with-param name="charge-details" select="$invoice-charge-details[parent::Document/@BillSeqNo = $billseqno]"/>
      <xsl:with-param name="charge-type" select="'A'"/>
    </xsl:call-template>

    <!-- one-time charge details info -->
    <xsl:call-template name="print-charge-details">
      <xsl:with-param name="co-id" select="$co-id"/>
      <xsl:with-param name="bopind" select="@BOPInd"/>
      <xsl:with-param name="bopseqno" select="BOPAlt/@BOPSeqNo"/>
      <xsl:with-param name="boptype" select="BOPAlt/AggSet/Att/@Ty"/>
      <xsl:with-param name="charge-details" select="$invoice-charge-details[parent::Document/@BillSeqNo = $billseqno]"/>
      <xsl:with-param name="charge-type" select="'S'"/>
    </xsl:call-template>

    <!-- sum udr tap -->
    <xsl:call-template name="print-sum-udr-tap">
      <xsl:with-param name="co-id"        select="$co-id"/>
      <xsl:with-param name="call-details" select="$call-details[parent::Document/@BillSeqNo = $billseqno]"/>
    </xsl:call-template>

    <!-- sum udr rap -->
    <xsl:call-template name="print-sum-udr-rap">
      <xsl:with-param name="co-id"        select="$co-id"/>
      <xsl:with-param name="call-details" select="$call-details[parent::Document/@BillSeqNo = $billseqno]"/>
    </xsl:call-template>

    <!-- not bundled usage -->
    <xsl:call-template name="print-call-details">
      <xsl:with-param name="co-id"        select="$co-id"/>
      <xsl:with-param name="bopind"       select="@BOPInd"/>
      <xsl:with-param name="bopseqno"     select="BOPAlt/@BOPSeqNo"/>
      <xsl:with-param name="boptype"      select="BOPAlt/AggSet/Att/@Ty"/>
      <xsl:with-param name="call-details" select="$call-details[parent::Document/@BillSeqNo = $billseqno]"/>
    </xsl:call-template>
    <!-- call details in case of large volumes -->
    <!--
    <xsl:call-template name="print-call-details-large-volume">
      <xsl:with-param name="co-id"        select="$co-id"/>
      <xsl:with-param name="bopind"       select="@BOPInd"/>
      <xsl:with-param name="bopseqno"     select="BOPAlt/@BOPSeqNo"/>
      <xsl:with-param name="boptype"      select="BOPAlt/AggSet/Att/@Ty"/>
      <xsl:with-param name="call-details" select="$call-details[parent::Document/@BillSeqNo = $billseqno]"/>
    </xsl:call-template>
    -->
  </xsl:template>

  <!-- sum item -->
  <xsl:template match="SumItem">
    <fo:table-row line-height="10pt">
      <!-- quantity -->
      <fo:table-cell text-align="center">
        <fo:block>
          <xsl:value-of select="@NumItems"/>
        </fo:block>
      </fo:table-cell>
      <!-- active days -->
      <xsl:if test="../@CT='A'">
        <fo:table-cell text-align="center">
          <fo:block>
            <xsl:value-of select="@NumDays"/>
          </fo:block>
        </fo:table-cell>
      </xsl:if>
      <!-- profile, service, package, tariff model -->
      <xsl:choose>
        <xsl:when test="AggSet">
          <xsl:apply-templates select="AggSet" mode="sum-item"/>
        </xsl:when>
        <xsl:otherwise>
          <fo:table-cell>
            <fo:block text-align="center">-</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block text-align="center">-</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block text-align="center">-</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block text-align="center">-</fo:block>
          </fo:table-cell>
        </xsl:otherwise>
      </xsl:choose>
      <!-- content catalogue, catalogue element, price list, usage type -->
      <xsl:choose>
        <xsl:when test="AggSet and (../@CT='U')">
          <xsl:apply-templates select="AggSet" mode="content"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
      <!-- remark -->
      <xsl:if test="../@CT='O' or ../@CT='P' or name(..)='CustRef'">
        <fo:table-cell>
          <fo:block>
            <xsl:apply-templates select="Txt"/>
          </fo:block>
        </fo:table-cell>
      </xsl:if>
      <!-- service status -->
      <xsl:if test="../@CT='A'">
        <fo:table-cell text-align="center">
          <fo:block>
            <xsl:for-each select="SrvStatus">
              <xsl:apply-templates select="."/>
            </xsl:for-each>
          </fo:block>
        </fo:table-cell>
      </xsl:if>
      <!-- service parameter -->
      <xsl:if test="../@CT='S'">
        <fo:table-cell text-align="center">
          <fo:block font-size="7pt">
            <xsl:apply-templates select="SrvParams"/>
          </fo:block>
        </fo:table-cell>
      </xsl:if>
      <!-- price -->
      <xsl:if test="../@CT='A' or ../@CT='S'">
        <fo:table-cell text-align="right">
          <fo:block>
            <xsl:if test="Price">
              <xsl:apply-templates select="Price"/>
            </xsl:if>
          </fo:block>
        </fo:table-cell>
      </xsl:if>
      <!-- charge -->
      <fo:table-cell text-align="right">
        <fo:block>
          <xsl:for-each select="Charge">
            <xsl:variable name="number-format">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
            </xsl:variable>
            <!-- print net amount (multiple currency possible) -->
            <xsl:if test="@Id='125'">
              <xsl:choose>
                <xsl:when test="position()=last()">
                  <xsl:value-of select="$number-format"/>
                  <xsl:text> </xsl:text>
                  <xsl:for-each select="@CurrCode">
                    <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="following-sibling::Charge[1]/@Id!='125'">
                      <xsl:value-of select="$number-format"/>
                      <xsl:text> </xsl:text>
                      <xsl:for-each select="@CurrCode">
                        <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                      </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="./@CurrCode!=following-sibling::Charge[1]/@CurrCode">
                        <xsl:value-of select="$number-format"/>
                        <xsl:text> </xsl:text>
                        <xsl:for-each select="@CurrCode">
                          <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                        </xsl:for-each>
                      </xsl:if>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <!-- print gross amount (multiple currency possible) -->
            <xsl:if test="@Id='203'">
              <xsl:choose>
                <xsl:when test="position()=last()">
                  <xsl:value-of select="$number-format"/>
                  <xsl:text> </xsl:text>
                  <xsl:for-each select="@CurrCode">
                    <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="following-sibling::Charge[1]/@Id!='203'">
                      <xsl:value-of select="$number-format"/>
                      <xsl:text> </xsl:text>
                      <xsl:for-each select="@CurrCode">
                        <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                      </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="./@CurrCode!=following-sibling::Charge[1]/@CurrCode">
                        <xsl:value-of select="$number-format"/>
                        <xsl:text> </xsl:text>
                        <xsl:for-each select="@CurrCode">
                          <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                        </xsl:for-each>
                      </xsl:if>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
          </xsl:for-each>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>

    <!-- promotions -->
    <xsl:if test="PromoItem">
      <xsl:choose>
        <!-- promotions for usage -->
        <xsl:when test="../@CT='U'">
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
              <xsl:apply-templates select="." mode="sum-item-usage"/>
            </fo:table-row>
          </xsl:for-each>
        </xsl:when>
        <!-- promotions for other -->
        <xsl:when test="../@CT='O' or ../@CT='P' or name(..)='CustRef'">
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
              <xsl:apply-templates select="." mode="sum-item-occ"/>
            </fo:table-row>
          </xsl:for-each>
        </xsl:when>
        <!-- promotions for subscription -->
        <xsl:when test="../@CT='S'">
          <fo:table-row font-size="7pt" font-weight="bold" text-align="center">
            <xsl:for-each select="$txt">
              <fo:table-cell>
                <fo:block/>
              </fo:table-cell>
              <fo:table-cell number-columns-spanned="2" background-color="gainsboro">
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
              <xsl:apply-templates select="." mode="sum-item-subscription"/>
            </fo:table-row>
          </xsl:for-each>
        </xsl:when>
        <!-- promotions for access -->
        <xsl:when test="../@CT='A'">
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
              <fo:table-cell number-columns-spanned="2" background-color="gainsboro">
                <fo:block>
                  <xsl:value-of select="key('txt-index','313')[@xml:lang=$lang]/@Des"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell number-columns-spanned="2" background-color="gainsboro">
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
              <xsl:apply-templates select="." mode="sum-item-access"/>
            </fo:table-row>
          </xsl:for-each>
        </xsl:when>
      </xsl:choose>
    </xsl:if>

  </xsl:template>

  <!-- free unit account info -->
  <xsl:template match="FUAccInfo">

    <!-- account, package -->
    <xsl:apply-templates select="FUAcc"/>

    <fo:table-cell text-align="center">
      <!-- period -->
      <fo:block>
        <xsl:apply-templates select="Date[@Type='START']"/>
        <xsl:text> - </xsl:text>
        <xsl:apply-templates select="Date[@Type='END']"/>
      </fo:block>
      <!-- expiration date -->
      <fo:block>
        <xsl:apply-templates select="Date[@Type='END_FU_CO']"/>
      </fo:block>
    </fo:table-cell>
    <!-- markup fee -->
    <fo:table-cell text-align="right">
      <fo:block>
        <xsl:if test="Charge[@Id='526']">
          <xsl:call-template name="number-format">
            <xsl:with-param name="number" select="Charge[@Id='526']/@Amount"/>
          </xsl:call-template>
          <xsl:text> </xsl:text>
          <xsl:for-each select="Charge[@Id='526']/@CurrCode">
            <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
          </xsl:for-each>
        </xsl:if>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell text-align="right">
      <!-- currently reduced amount -->
      <fo:block>
        <xsl:if test="Charge[@Id='54']">
          <xsl:call-template name="number-format">
            <xsl:with-param name="number" select="Charge[@Id='54']/@Amount"/>
          </xsl:call-template>
          <xsl:text> </xsl:text>
          <xsl:for-each select="Charge[@Id='54']/@CurrCode">
            <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
          </xsl:for-each>
        </xsl:if>
      </fo:block>
      <!-- totally reduced amount -->
      <fo:block>    
        <xsl:if test="Charge[@Id='55']">
          <xsl:call-template name="number-format">
            <xsl:with-param name="number" select="Charge[@Id='55']/@Amount"/>
          </xsl:call-template>
          <xsl:text> </xsl:text>
          <xsl:for-each select="Charge[@Id='55']/@CurrCode">
            <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
          </xsl:for-each>
        </xsl:if>
      </fo:block>      
    </fo:table-cell>
    
    <!-- Evaluated/granted free units -->
    <xsl:choose>
      
      <!-- Eval UoM is technical -->
      <xsl:when test="FUNum[@UME]">
        <xsl:apply-templates select="FUNum[@UME]"/>
      </xsl:when>
      
      <!-- Eval UoM is monetary -->
      <xsl:otherwise>
        <fo:table-cell text-align="right">
          <!-- original FU amount  -->
          <fo:block>
            <xsl:if test="Charge[@Id='56']">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="Charge[@Id='56']/@Amount"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:for-each select="Charge[@Id='56']/@CurrCode">
                <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
            </xsl:if>      
          </fo:block>
          <!-- granted FU amount net part -->
          <fo:block>
            <xsl:if test="Charge[@Id='57']">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="Charge[@Id='57']/@Amount"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:for-each select="Charge[@Id='57']/@CurrCode">
                <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
            </xsl:if>
          </fo:block>          
        </fo:table-cell>
        <!-- carry over FU amount -->
        <fo:table-cell text-align="right">
          <fo:block>
            <xsl:if test="Charge[@Id='58']">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="Charge[@Id='58']/@Amount"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:for-each select="Charge[@Id='58']/@CurrCode">
                <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
            </xsl:if>
          </fo:block>          
        </fo:table-cell>
        
      </xsl:otherwise>
    </xsl:choose>
    
    <!-- Applied free units -->
    <xsl:choose>
    
      <!-- Appl UoM is technical -->
      <xsl:when test="FUNum[@UMA]">
        <xsl:apply-templates select="FUNum[@UMA]"/>
      </xsl:when>
        
        <!-- Appl UoM is monetary -->
        <xsl:otherwise>
          
          <xsl:choose>
          
            <!-- Price plan free units -->
            <xsl:when test="Charge[@Id='527'] or Charge[@Id='528']">
            
                <fo:table-cell text-align="right">
                  <!-- currently repriced amount -->
                  <fo:block>
                    <xsl:if test="Charge[@Id='527']">
                      <xsl:call-template name="number-format">
                        <xsl:with-param name="number" select="Charge[@Id='527']/@Amount"/>
                      </xsl:call-template>
                      <xsl:text> </xsl:text>
                      <xsl:for-each select="Charge[@Id='527']/@CurrCode">
                        <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                      </xsl:for-each>
                    </xsl:if>
                  </fo:block>
                  <!-- totally repriced amount -->
                  <fo:block>    
                    <xsl:if test="Charge[@Id='528']">
                      <xsl:call-template name="number-format">
                        <xsl:with-param name="number" select="Charge[@Id='528']/@Amount"/>
                      </xsl:call-template>
                      <xsl:text> </xsl:text>
                      <xsl:for-each select="Charge[@Id='528']/@CurrCode">
                        <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                      </xsl:for-each>
                    </xsl:if>
                  </fo:block>      
                </fo:table-cell>
                
            </xsl:when>
            
            <!-- Normal free units -->
            <xsl:otherwise>
            
                <fo:table-cell>
                  <fo:block/>
                </fo:table-cell>
                
            </xsl:otherwise>
            
          </xsl:choose>
          
        </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- free unit account -->
  <xsl:template match="FUAcc">

    <fo:table-cell text-align="center">
      <!-- account -->
      <fo:block font-size="7pt">
        <xsl:value-of select="@Id"/>
        <xsl:text> / </xsl:text>
        <xsl:value-of select="@HistId"/>
      </fo:block>
      <fo:block font-size="7pt">
        <xsl:choose>
          <!-- free units -->
          <xsl:when test="@FUOption='F'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','544')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <!-- scaled price plan -->
          <xsl:when test="@FUOption='S'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','545')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <!-- tiered price plan -->
          <xsl:when test="@FUOption='T'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','546')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>-</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell text-align="center">
      <fo:block font-size="7pt">
        <!-- free unit package -->
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@FUP"/>
          <xsl:with-param name="Type"  select="'FUP'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
        <xsl:text> / </xsl:text>
        <!-- free unit element -->
        <xsl:value-of select="@FUE"/>
        <xsl:text> / </xsl:text>
        <!-- free unit element version -->
        <xsl:value-of select="@FUEV"/>
      </fo:block>
      <fo:block font-size="7pt">
        <!-- charge plan -->
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@ChPlan"/>
          <xsl:with-param name="Type"  select="'CPD'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    
  </xsl:template>

  <!-- granted free units -->
  <xsl:template match="FUNum[@UME]">

    <fo:table-cell text-align="right">
      <!-- original -->
      <fo:block>
        <xsl:if test="@Orig">
          <xsl:call-template name="volume-format">
            <xsl:with-param name="volume" select="@Orig"/>
          </xsl:call-template>
          <xsl:text> </xsl:text>
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="@UME"/>
            <xsl:with-param name="Type"  select="'UM'"/>
            <xsl:with-param name="Desc"  select="'0'"/>
          </xsl:call-template>
        </xsl:if>
      </fo:block>
      
      <!-- granted -->
      <fo:block>
        <xsl:if test="@Granted">
          <xsl:call-template name="volume-format">
            <xsl:with-param name="volume" select="@Granted"/>
          </xsl:call-template>
          <xsl:text> </xsl:text>
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="@UME"/>
            <xsl:with-param name="Type"  select="'UM'"/>
            <xsl:with-param name="Desc"  select="'0'"/>
          </xsl:call-template>
        </xsl:if>
      </fo:block>
      
    </fo:table-cell>
    
    <!-- carry over -->
    
    <fo:table-cell text-align="right">
      <fo:block>
        <xsl:if test="@CarryOver">
          <xsl:call-template name="volume-format">
            <xsl:with-param name="volume" select="@CarryOver"/>
          </xsl:call-template>
          <xsl:text> </xsl:text>
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="@UME"/>
            <xsl:with-param name="Type"  select="'UM'"/>
            <xsl:with-param name="Desc"  select="'0'"/>
          </xsl:call-template>
        </xsl:if>
      </fo:block>
    </fo:table-cell>
    
  </xsl:template>
  
  
  <!-- applied free units -->
  <xsl:template match="FUNum[@UMA]">
    
    <fo:table-cell text-align="right">
      <!-- currently used -->
      <fo:block>
        <xsl:if test="@CurrUsed">
          <xsl:call-template name="volume-format">
            <xsl:with-param name="volume" select="@CurrUsed"/>
          </xsl:call-template>
          <xsl:text> </xsl:text>
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="@UMA"/>
            <xsl:with-param name="Type"  select="'UM'"/>
            <xsl:with-param name="Desc"  select="'0'"/>
          </xsl:call-template>
        </xsl:if>
      </fo:block>
      
      <!-- totally used -->
      <fo:block>
        <xsl:if test="@TotalUsed">
          <xsl:call-template name="volume-format">
            <xsl:with-param name="volume" select="@TotalUsed"/>
          </xsl:call-template>
          <xsl:text> </xsl:text>
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="@UMA"/>
            <xsl:with-param name="Type"  select="'UM'"/>
            <xsl:with-param name="Desc"  select="'0'"/>
          </xsl:call-template>
        </xsl:if>
      </fo:block>
      
    </fo:table-cell>

  </xsl:template>

  <!-- balance snapshot -->
  <xsl:template match="BalSsh">
    <!-- snapshot date -->
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:apply-templates select="Date[@Type='BAL_REF']"/>
      </fo:block>
    </fo:table-cell>
    <xsl:apply-templates select="Bal"/>
    <xsl:apply-templates select="BalVols"/>
  </xsl:template>

  <!-- balance adjustments -->
  <xsl:template match="BalAd">
    <!-- date -->
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:apply-templates select="Date[@Type='BAL_REF']"/>
      </fo:block>
    </fo:table-cell>
    <!-- type -->
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="DataDomainLgnMap">
          <xsl:with-param name="Index"     select="@Type"/>
          <xsl:with-param name="Type"      select="'DD'"/>
          <xsl:with-param name="Desc"      select="'1'"/>
          <xsl:with-param name="ClassId"   select="'BIR_PURPOSE_CLASS'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell text-align="center">
      <!-- period -->
      <fo:block>
        <xsl:apply-templates select="Date[@Type='VALID_FROM']"/>
        <xsl:text> - </xsl:text>
        <xsl:apply-templates select="Date[@Type='VALID_TO']"/>
      </fo:block>
      <!-- adjustment -->
      <fo:block>
        <xsl:call-template name="number-format">
          <xsl:with-param name="number" select="@AdjAmt"/>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:for-each select="Bal/@CurrCode">
          <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
        </xsl:for-each>
      </fo:block>
    </fo:table-cell>
    <!-- reason -->
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:if test="@Reason">
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="@Reason"/>
            <xsl:with-param name="Type"  select="'AR'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
        </xsl:if>
      </fo:block>
    </fo:table-cell>
    <xsl:apply-templates select="Bal"/>
    <xsl:apply-templates select="BalVols"/>
  </xsl:template>

  <!-- discount info ( free units )  -->
  <xsl:template match="FUDiscountInfo">

    <!-- monetary discount info -->
    <xsl:if test="Charge">
      <fo:table-row>
        <!-- package -->
        <fo:table-cell text-align="center">
          <fo:block>
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="@FUP"/>
              <xsl:with-param name="Type"  select="'FUP'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </fo:block>
        </fo:table-cell>
        <!-- eligible amount -->
        <fo:table-cell text-align="right">
          <xsl:for-each select="Charge[@Id='56']">
            <fo:block>
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:for-each select="@CurrCode">
                <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
            </fo:block>
          </xsl:for-each>
        </fo:table-cell>
        <!-- discounted amount -->
        <fo:table-cell text-align="right">
          <xsl:for-each select="Charge[@Id='55']">
            <fo:block>
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:for-each select="@CurrCode">
                <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
            </fo:block>
          </xsl:for-each>
        </fo:table-cell>
      </fo:table-row>
    </xsl:if>
    <!-- non monetary discount info -->
    <xsl:for-each select="DiscountValue">
      <fo:table-row>
        <!-- package -->
        <fo:table-cell text-align="center">
          <fo:block>
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="../@FUP"/>
              <xsl:with-param name="Type"  select="'FUP'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </fo:block>
        </fo:table-cell>
        <!-- non monetary discount info -->
        <xsl:apply-templates select="."/>
      </fo:table-row>
    </xsl:for-each>

  </xsl:template>

  <!-- cost control service / CS discount info -->
  <xsl:template match="CCHDiscountInfo|CSDiscountInfo">

    <!-- monetary discount info -->
    <xsl:if test="Charge">
      <fo:table-row>
        <!-- service -->
        <fo:table-cell text-align="center">
          <fo:block>
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="@SN"/>
              <xsl:with-param name="Type"  select="'SN'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </fo:block>
        </fo:table-cell>
        <!-- eligible amount -->
        <fo:table-cell text-align="right">
          <xsl:for-each select="Charge[@Id='56']">
            <fo:block>
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:for-each select="@CurrCode">
                <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
            </fo:block>
          </xsl:for-each>
        </fo:table-cell>
        <!-- discounted amount -->
        <fo:table-cell text-align="right">
          <xsl:for-each select="Charge[@Id='55']">
            <fo:block>
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:for-each select="@CurrCode">
                <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
            </fo:block>
          </xsl:for-each>
        </fo:table-cell>
      </fo:table-row>
    </xsl:if>
    <!-- non monetary discount info -->
    <xsl:for-each select="DiscountValue">
      <fo:table-row>
        <!-- service -->
        <fo:table-cell text-align="center">
          <fo:block>
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="../@SN"/>
              <xsl:with-param name="Type"  select="'SN'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </fo:block>
        </fo:table-cell>
        <!-- non monetary discount info -->
        <xsl:apply-templates select="."/>
      </fo:table-row>
    </xsl:for-each>

  </xsl:template>

  <!-- granted credits to prepaid balances info -->
  <xsl:template match="PromoCreditPerBal">
    <fo:table-row>
      <!-- balance info -->
      <xsl:apply-templates select="Bal" mode="credit-per-bal"/>
      <!-- total credit amount for Bal -->
      <fo:table-cell text-align="right">
        <fo:block>
          <xsl:for-each select="Charge">
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="@Amount"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>
            <xsl:for-each select="@CurrCode">
              <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
          </xsl:for-each>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>

  <!-- granted credits to prepaid balances info -->
  <xsl:template match="PromoCreditPerBal" mode="promo">
      <!-- balance info -->
      <xsl:apply-templates select="Bal" mode="promo"/>
      <!-- total credit amount for Bal -->
      <fo:table-cell text-align="right">
        <fo:block>
          <xsl:for-each select="Charge">
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="@Amount"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>
            <xsl:for-each select="@CurrCode">
              <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
          </xsl:for-each>
        </fo:block>
      </fo:table-cell>
  </xsl:template>

  <!--  bundle info -->
  <xsl:template name="BundleInfo">

    <xsl:param name="co-id"/>
    <xsl:param name="bopind"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>

    <fo:table-row font-size="7pt">
      <!-- bundle name -->
      <fo:table-cell>
        <fo:block text-align="center">
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="@SN"/>
            <xsl:with-param name="Type"  select="'SN'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
        </fo:block>
      </fo:table-cell>
      <!-- purchase date -->
      <fo:table-cell>
        <fo:block text-align="center">
          <xsl:call-template name="date-format">
            <xsl:with-param name="date" select="Date[@Type='PURCHASE']/@Date"/>
          </xsl:call-template>
        </fo:block>
      </fo:table-cell>
      <!-- consumption period -->
      <fo:table-cell>
        <fo:block text-align="center">
          <xsl:call-template name="date-format">
            <xsl:with-param name="date" select="Date[@Type='START']/@Date"/>
          </xsl:call-template>
          <xsl:text> - </xsl:text>
          <xsl:call-template name="date-format">
            <xsl:with-param name="date" select="Date[@Type='END']/@Date"/>
          </xsl:call-template>
        </fo:block>
      </fo:table-cell>
      <!-- bundle products -->
      <fo:table-cell>
        <xsl:choose>
          <xsl:when test="BundledProd">
            <xsl:for-each select="BundledProd">
              <xsl:apply-templates select="."/>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <fo:block/>
          </xsl:otherwise>
        </xsl:choose>
      </fo:table-cell>
      <!-- bundle price -->
      <fo:table-cell>
        <fo:block text-align="center">
          <xsl:call-template name="print-call-details-bundle-purchase-price">
            <xsl:with-param name="co-id"        select="$co-id"/>
            <xsl:with-param name="service"      select="@SN"/>
            <xsl:with-param name="sequence-no"  select="@SeqNo"/>
            <xsl:with-param name="call-details" select="$call-details"/>
            <xsl:with-param name="bopind"       select="$bopind"/>
            <xsl:with-param name="bopseqno"     select="$bopseqno"/>
            <xsl:with-param name="boptype"      select="$boptype"/>
          </xsl:call-template>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>

  </xsl:template>

  <!--  bundled product info -->
  <xsl:template match="BundledProd">

    <fo:block text-align="center">
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="@BPROD"/>
        <xsl:with-param name="Type"  select="'BPROD'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
    </fo:block>

  </xsl:template>

</xsl:stylesheet>
