<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    Summary.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> HTML stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms sum sheet documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/Summary.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" exclude-result-prefixes="xsl cur">

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

    <hr/>
    <center><h2>
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','91')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
    </h2></center>
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

    <!-- postpaid summary -->
    <xsl:if test="Charge[@PT = 'P' and 0 != number(@Amount) ]">
        
        <table border="1" width="40%" cellspacing="0" cellpadding="0">
          <thead>
            <tr>
              <td colspan="2"><font size="-1"><b>
                <xsl:for-each select="$txt"><!-- Summary -->
                  <xsl:value-of select="key('txt-index','74')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </b></font></td>
            </tr>
          </thead>
          <tbody>
            
            <!-- net invoice amount postpaid (multiple currency) -->
            <xsl:if test="$pricing = 'N' or not(0 = number(Charge[@Id='177' and @PT='P']/@Amount) )  ">
                <tr>
                  <td><font size="-1">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','94')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </font></td>
                  <td align="right"><font size="-1">
                    <xsl:for-each select="Charge[@Id='177' and @PT='P']">
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
            </xsl:if>
            
            <!-- gross invoice amount postpaid (multiple currency) -->
            <xsl:if test="$pricing = 'G' or not(0 = number(Charge[@Id='277' and @PT='P']/@Amount) )  ">
                <tr>
                  <td><font size="-1">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','95')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </font></td>
                  <td align="right"><font size="-1">
                    <xsl:for-each select="Charge[@Id='277' and @PT='P']">
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
            </xsl:if>
            
            <!-- total net usage charges postpaid (multiple currency) -->
            <xsl:if test="$pricing = 'N' or not(0 = number(Charge[@Id='812' and @PT='P']/@Amount) )  ">
                <tr>
                  <td><font size="-1">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','96')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </font></td>
                  <td align="right"><font size="-1">
                    <xsl:for-each select="Charge[@Id='812' and @PT='P']">
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
            </xsl:if>
            
            <!-- total gross usage charges postpaid (multiple currency) -->
            <xsl:if test="$pricing = 'G' or not(0 = number(Charge[@Id='912' and @PT='P']/@Amount) )  ">
                <tr>
                  <td><font size="-1">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','99')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </font></td>
                  <td align="right"><font size="-1">
                    <xsl:for-each select="Charge[@Id='912' and @PT='P']">
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
            </xsl:if>
            
            <!-- total one-time charges net/gross postpaid (multiple currency) -->
            <tr>
              <td><font size="-1">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','97')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </font></td>
              <td align="right"><font size="-1">
                <xsl:for-each select="Charge[@Id='910' and @PT='P']">
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
            
            <!-- total recurring charges net/gross postpaid (multiple currency) -->
            <tr>
              <td><font size="-1">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','98')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </font></td>
              <td align="right"><font size="-1">
                <xsl:for-each select="Charge[@Id='911' and @PT='P']">
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
            
            <!-- total occ charges net/gross postpaid (multiple currency) -->
            <tr>
              <td><font size="-1">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','100')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </font></td>
              <td align="right"><font size="-1">
                <xsl:for-each select="Charge[@Id='913' and @PT='P']">
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
        
    </xsl:if>
    
    <br/>
    
    <!-- prepaid summary -->
    <xsl:if test="Charge[@PT = 'A' and 0 != number(@Amount) ]">
        
        <table border="1" width="40%" cellspacing="0" cellpadding="0">
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
          
            <!-- net invoice amount prepaid (multiple currency) -->
            <xsl:if test="$pricing-prepaid = 'N' or not(0 = number(Charge[@Id='177' and @PT='A']/@Amount) )  ">
                <tr>
                  <td><font size="-1">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','94')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </font></td>
                  <td align="right"><font size="-1">
                    <xsl:for-each select="Charge[@Id='177' and @PT='A']">
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
            </xsl:if>
            
            <!-- gross invoice amount prepaid (multiple currency) -->
            <xsl:if test="$pricing-prepaid = 'G' or not(0 = number(Charge[@Id='277' and @PT='A']/@Amount) )  ">
            <tr>
              <td><font size="-1">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','95')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </font></td>
              <td align="right"><font size="-1">
                <xsl:for-each select="Charge[@Id='277' and @PT='A']">
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
            </xsl:if>
            
            <!-- total net usage charges prepaid (multiple currency) -->
            <xsl:if test="$pricing-prepaid = 'N' or not(0 = number(Charge[@Id='812' and @PT='A']/@Amount) )  ">
                <tr>
                  <td><font size="-1">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','96')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </font></td>
                  <td align="right"><font size="-1">
                    <xsl:for-each select="Charge[@Id='812' and @PT='A']">
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
            </xsl:if>
            
            <!-- total gross usage charges prepaid (multiple currency) -->
            <xsl:if test="$pricing-prepaid = 'G' or not(0 = number(Charge[@Id='912' and @PT='A']/@Amount) )  ">
            <tr>
              <td><font size="-1">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','99')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </font></td>
              <td align="right"><font size="-1">
                <xsl:for-each select="Charge[@Id='912' and @PT='A']">
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
            </xsl:if>
            
            <!-- total one-time charges net/gross prepaid (multiple currency) -->
            <tr>
              <td><font size="-1">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','97')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </font></td>
              <td align="right"><font size="-1">
                <xsl:for-each select="Charge[@Id='910' and @PT='A']">
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
            
            <!-- total recurring charges net/gross prepaid (multiple currency) -->
            <tr>
              <td><font size="-1">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','98')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </font></td>
              <td align="right"><font size="-1">
                <xsl:for-each select="Charge[@Id='911' and @PT='A']">
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
            
            <!-- total occ charges net/gross prepaid (multiple currency) -->
            <tr>
              <td><font size="-1">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','100')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </font></td>
              <td align="right"><font size="-1">
                <xsl:for-each select="Charge[@Id='913' and @PT='A']">
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
        
    </xsl:if>
    
  </xsl:template>


  <!-- billing account owner -->
  <xsl:template match="CustRef">

    <xsl:variable name="billseqno" select="@BillSeqNo"></xsl:variable>

    <!-- customer address -->
    <p><b><xsl:value-of select="concat(Addr/@Name ,'&#160;',Addr/@Line1,'&#160;',
                                       Addr/@Line2,'&#160;',Addr/@Line3,'&#160;',
                                       Addr/@Line4,'&#160;',Addr/@Line5,'&#160;',
                                       Addr/@Line6,'&#160;',Addr/@Zip  ,'&#160;',
                                       Addr/@City ,'&#160;',Addr/@Country)"/>
    </b></p>
    <table cellspacing="0" cellpadding="0">
      <!-- customder id -->
      <tr>
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','302')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td><font size="-1"><i>
          <xsl:value-of select="@Id"/>
        </i></font></td>
      </tr>
      <!-- customer code -->
      <tr>
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','303')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td><font size="-1"><i>
          <xsl:value-of select="@CustCode"/>
        </i></font></td>
      </tr>
      <!-- billing request -->
      <tr>
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','550')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td><font size="-1"><i>
          <xsl:value-of select="@BillSeqNo"/>
        </i></font></td>
      </tr>
      <!-- billing period -->
      <tr>
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','551')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td><font size="-1"><i>
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
        </i></font></td>
      </tr>      
    </table>
    <br/>
    
    <!-- postpaid charges -->
    <xsl:if test="Charge[@PT='P' and 0 != number(@Amount) ]">
        
        <table border="1" width="40%" cellspacing="0" cellpadding="0">
          <thead>
            <tr>
              <td colspan="2"><font size="-1"><b>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','89')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </b></font></td>
            </tr>
          </thead>
          <tbody>
          
            <!-- customer net amount postpaid (multiple currency) -->
            <xsl:if test="$pricing = 'N' or not(0 = number(Charge[@Id='830' and @PT='P']/@Amount) ) ">
                <tr>
                  <td><font size="-1">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','102')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </font></td>
                  <td align="right"><font size="-1">
                    <xsl:for-each select="Charge[@Id='830' and @PT='P']">
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
            </xsl:if>
            
            <!-- customer gross amount postpaid (multiple currency) -->
            <xsl:if test="$pricing = 'G' or not(0 = number(Charge[@Id='930' and @PT='P']/@Amount) ) ">
                <tr>
                  <td><font size="-1">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','104')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </font></td>
                  <td align="right"><font size="-1">
                    <xsl:for-each select="Charge[@Id='930' and @PT='P']">
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
            </xsl:if>
            
            <!-- customer net usage charges postpaid (multiple currency) -->
            <xsl:if test="$pricing = 'N' or not(0 = number(Charge[@Id='835' and @PT='P']/@Amount) ) ">
                <tr>
                  <td><font size="-1">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','103')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </font></td>
                  <td align="right"><font size="-1">
                    <xsl:for-each select="Charge[@Id='835' and @PT='P']">
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
            </xsl:if>
            
            <!-- customer gross usage charges postpaid (multiple currency) -->
            <xsl:if test="$pricing = 'G' or not(0 = number(Charge[@Id='934' and @PT='P']/@Amount) ) ">
                <tr>
                  <td><font size="-1">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','107')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </font></td>
                  <td align="right"><font size="-1">
                    <xsl:for-each select="Charge[@Id='935' and @PT='P']">
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
            </xsl:if>
            
            <!-- customer one-time charges net/gross postpaid (multiple currency) -->
            <tr>
              <td><font size="-1">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','105')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </font></td>
              <td align="right"><font size="-1">
                <xsl:for-each select="Charge[@Id='933' and @PT='P']">
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
            
            <!-- customer recurring charges net/gross postpaid (multiple currency) -->
            <tr>
              <td><font size="-1">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','106')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </font></td>
              <td align="right"><font size="-1">
                <xsl:for-each select="Charge[@Id='934' and @PT='P']">
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
            
            <!-- customer occ charges net/gross postpaid (multiple currency) -->
            <tr>
              <td><font size="-1">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','108')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </font></td>
              <td align="right"><font size="-1">
                <xsl:for-each select="Charge[@Id='936' and @PT='P']">
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
        
    </xsl:if>
    
    <br/>
    
    <!-- prepaid charges -->
    <xsl:if test="Charge[@PT='A' and 0 != number(@Amount) ]">
        
        <table border="1" width="40%" cellspacing="0" cellpadding="0">
          <thead>
            <tr>
              <td colspan="2"><font size="-1"><b>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','89')[@xml:lang=$lang]/@Des"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="key('txt-index','286')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </b></font></td>
            </tr>
          </thead>
          <tbody>
          
            <!-- customer net amount prepaid (multiple currency) -->
            <xsl:if test="$pricing-prepaid = 'N' or not(0 = number(Charge[@Id='830' and @PT='A']/@Amount) ) ">
                <tr>
                  <td><font size="-1">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','102')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </font></td>
                  <td align="right"><font size="-1">
                    <xsl:for-each select="Charge[@Id='830' and @PT='A']">
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
            </xsl:if>
            
            <!-- customer gross amount prepaid (multiple currency) -->
            <xsl:if test="$pricing-prepaid = 'G' or not(0 = number(Charge[@Id='930' and @PT='A']/@Amount) ) ">
                <tr>
                  <td><font size="-1">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','104')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </font></td>
                  <td align="right"><font size="-1">
                    <xsl:for-each select="Charge[@Id='930' and @PT='A']">
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
            </xsl:if>
            
            <!-- customer net usage charges prepaid (multiple currency) -->
            <xsl:if test="$pricing-prepaid = 'N' or not(0 = number(Charge[@Id='835' and @PT='A']/@Amount) ) ">
                <tr>
                  <td><font size="-1">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','96')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </font></td>
                  <td align="right"><font size="-1">
                    <xsl:for-each select="Charge[@Id='835' and @PT='A']">
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
            </xsl:if>
            
            <!-- customer gross usage charges prepaid (multiple currency) -->
            <xsl:if test="$pricing-prepaid = 'G' or not(0 = number(Charge[@Id='935' and @PT='A']/@Amount) ) ">
                <tr>
                  <td><font size="-1">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','99')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </font></td>
                  <td align="right"><font size="-1">
                    <xsl:for-each select="Charge[@Id='935' and @PT='A']">
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
            </xsl:if>
            
            <!-- customer one-time charges net/gross prepaid (multiple currency) -->
            <tr>
              <td><font size="-1">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','105')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </font></td>
              <td align="right"><font size="-1">
                <xsl:for-each select="Charge[@Id='933' and @PT='A']">
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
            
            <!-- customer recurring charges net/gross prepaid (multiple currency) -->
            <tr>
              <td><font size="-1">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','106')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </font></td>
              <td align="right"><font size="-1">
                <xsl:for-each select="Charge[@Id='934' and @PT='A']">
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
            
            <!-- customer occ charges net/gross prepaid (multiple currency) -->
            <tr>
              <td><font size="-1">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','108')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </font></td>
              <td align="right"><font size="-1">
                <xsl:for-each select="Charge[@Id='936' and @PT='A']">
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
        
    </xsl:if>
    
    <!-- fees -->
    <xsl:if test="SumItem">
      <br/>
      <table width="100%" border="1" cellspacing="0" cellpadding="0">
        <thead>
          <tr>
            <td colspan="8"><font size="-1"><b>
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','119')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </b></font></td>
          </tr>
        </thead>
        <tbody>
          <tr>
            <xsl:for-each select="$txt">
              <!-- quantity -->
              <th nowrap="nowrap"><font size="-1">
                <xsl:value-of select="key('txt-index','125')[@xml:lang=$lang]/@Des"/>
              </font></th>
            </xsl:for-each>
            <xsl:for-each select="$txt">
              <!-- profile -->
              <th nowrap="nowrap"><font size="-1">
                <xsl:value-of select="key('txt-index','139')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!-- service -->
              <th nowrap="nowrap"><font size="-1">
                <xsl:value-of select="key('txt-index','140')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!-- package -->
              <th nowrap="nowrap"><font size="-1">
                <xsl:value-of select="key('txt-index','141')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!-- tariff model -->
              <th nowrap="nowrap"><font size="-1">
                <xsl:value-of select="key('txt-index','142')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!-- remark -->
              <th nowrap="nowrap"><font size="-1">
                <xsl:value-of select="key('txt-index','146')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!-- charge -->
              <th nowrap="nowrap"><font size="-1">
                <xsl:value-of select="key('txt-index','143')[@xml:lang=$lang]/@Des"/>
              </font></th>
            </xsl:for-each>
          </tr>
          <xsl:for-each select="SumItem">
            <xsl:apply-templates select="."/>
          </xsl:for-each>
        </tbody>
      </table>
    </xsl:if>
    <!-- contract(s) -->
    <xsl:for-each select="Contract">

        <!-- contract sorting -->
        <xsl:sort select="@Id" data-type="text" order="ascending"/>

        <!-- billed alternative first -->
        <xsl:sort select="BOPAlt/@BILLED" data-type="text" order="descending"/>

        <hr/>

    <!-- Check removed by PN: 380592.   
     <xsl:if test="position()='1'">
      -->

          <h3 align="center">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','109')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="@Id"/>
          </h3>

          <table border="1" width="40%" cellspacing="0" cellpadding="0">

            <tr>
              <td><font size="-1">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','111')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </font></td>
              <td align="right"><font size="-1">
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="@MRKT"/>
                  <xsl:with-param name="Type"  select="'MRKT'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </font></td>
            </tr>
            <tr>
              <td><font size="-1">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','112')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </font></td>
              <td align="right"><font size="-1">
                <xsl:value-of select="@SM"/>
              </font></td>
            </tr>
            <xsl:choose>
              <!-- DN's -->
              <xsl:when test="DN">
                <xsl:for-each select="DN">
                  <!-- sort the directory numbers -->
                  <xsl:sort select="." data-type="number" order="ascending"/>
                  <tr>
                    <xsl:apply-templates select="."/>
                  </tr>
                </xsl:for-each>
              </xsl:when>
              <!-- DN block(s) -->
              <xsl:when test="DNBlock">
                <xsl:for-each select="DNBlock">
                  <tr>
                    <xsl:apply-templates select="."/>
                  </tr>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise></xsl:otherwise>
            </xsl:choose>

            <!-- BOP package and BOP purpose -->
            <xsl:if test="@BOPInd='Y'">
              <tr>
                <td><font size="-1">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','382')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </font></td>
                <td align="right"><font size="-1">
                   <xsl:call-template name="LgnMap">
                     <xsl:with-param name="Mode"  select="'0'"/>
                     <xsl:with-param name="Index" select="BOPAlt/@BOPPack"/>
                     <xsl:with-param name="Type"  select="'BOP'"/>
                     <xsl:with-param name="Desc"  select="'1'"/>
                   </xsl:call-template>
                </font></td>
              </tr>
              <tr>
                <td><font size="-1">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','383')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </font></td>
                <td align="right"><font size="-1">
                  <xsl:call-template name="LgnMap">
                    <xsl:with-param name="Mode"  select="'0'"/>
                    <xsl:with-param name="Index" select="BOPAlt/@BOPPurp"/>
                    <xsl:with-param name="Type"  select="'BPURP'"/>
                    <xsl:with-param name="Desc"  select="'1'"/>
                  </xsl:call-template>
                </font></td>
              </tr>
            </xsl:if>

            <xsl:variable name="co-alt" select="count(key('co-id',@Id))"/>

            <!-- number of alternatives -->
            <xsl:if test="$co-alt > 1 and @BOPInd='Y'">
              <tr>
                <td><font size="-1">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','384')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </font></td>
                <td align="right"><font size="-1">
                  <xsl:value-of select="count(key('co-id',@Id))"/>
                </font></td>
              </tr>
            </xsl:if>

          </table>

    <!-- Check removed by PN: 380592.
            </xsl:if>
      -->

        <xsl:apply-templates select="."/>

    </xsl:for-each>

    <!-- if no contracts are available, then print call details only -->
    <xsl:if test="not(Contract)">
      <xsl:call-template name="print-call-details-only">
        <xsl:with-param name="call-details" select="$call-details[parent::Document/@BillSeqNo = $billseqno]"/>
      </xsl:call-template>
    </xsl:if>

  </xsl:template>

  <!-- contract -->
  <xsl:template match="Contract">

    <xsl:variable name="co-id"   select="@Id"/>
    <xsl:variable name="bop-ind" select="@BOPInd"/>
    <xsl:variable name="billed"  select="BOPAlt/@BILLED"/>
    <xsl:variable name="bop-id"  select="BOPAlt/AggSet/Att/@Id"/>
    <xsl:variable name="billseqno" select="../@BillSeqNo"/>

    <br/>
    
    <!--  contract sums postpaid  -->
    <xsl:if test="Charge[@PT='P' and 0 != number(@Amount) ]">
        
        <table border="1" width="50%" cellspacing="0" cellpadding="0">
          <!-- header column for contract sums -->
          <thead>
            <tr>
              <td colspan="2"><font size="-1"><b>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','89')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </b></font></td>
            </tr>
            <xsl:if test="@BOPInd='Y'">
              <tr bgcolor="#B0C4DE">
                <td nowrap="nowrap"><font size="-1">
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
                  <xsl:text> ( </xsl:text>
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
                  <xsl:text> ) </xsl:text>
                </font></td>
                <td nowrap="nowrap" align="right"><font size="-1">
                  <xsl:call-template name="LgnMap">
                    <xsl:with-param name="Mode"  select="'0'"/>
                    <xsl:with-param name="Index" select="BOPAlt/AggSet/Att/@Id"/>
                    <xsl:with-param name="Type"  select="BOPAlt/AggSet/Att/@Ty"/>
                    <xsl:with-param name="Desc"  select="'1'"/>
                  </xsl:call-template>
                </font></td>
              </tr>
              <tr>
                <td nowrap="nowrap"><font size="-1">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','381')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </font></td>
                <td align="right" nowrap="nowrap"><font size="-1">
                  <xsl:value-of select="BOPAlt/@BOPSeqNo"/>
                </font></td>
              </tr>
            </xsl:if>
          </thead>
          <tbody>
            
            <!-- contract net amount postpaid (multiple currency) -->
            <xsl:if test="$pricing = 'N' or not(0 = number(Charge[@Id='831' and @PT='P']/@Amount) ) ">
                <tr>
                  <td><font size="-1">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','114')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </font></td>
                  <td align="right"><font size="-1">
                    <xsl:for-each select="Charge[@Id='831' and @PT='P']">
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
            </xsl:if>
            
            <!-- contract gross amount postpaid (multiple currency) -->
            <xsl:if test="$pricing = 'G' or not(0 = number(Charge[@Id='931' and @PT='P']/@Amount) ) ">
                <tr>
                  <td><font size="-1">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','115')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </font></td>
                  <td align="right"><font size="-1">
                    <xsl:for-each select="Charge[@Id='931' and @PT='P']">
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
            </xsl:if>
            
          </tbody>
        </table>
        
    </xsl:if>
    
    <br/>
    
    <!-- show prepaid charges only if contract is not BOP related -->
    <xsl:if test="@BOPInd='N' and Charge[@PT='A' and 0 != number(@Amount) ]">
    
      <!--  contract sums  prepaid  -->
      <table border="1" width="50%" cellspacing="0" cellpadding="0">
        <!-- header column for contract sums -->
        <thead>
          <tr>
            <td colspan="2"><font size="-1"><b>
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','89')[@xml:lang=$lang]/@Des"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="key('txt-index','286')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </b></font></td>
          </tr>
        </thead>
        <tbody>
        
          <!-- contract net amount prepaid (multiple currency) -->
          <xsl:if test="$pricing-prepaid = 'N' or not(0 = number(Charge[@Id='831' and @PT='A']/@Amount) ) ">
              <tr>
                <td><font size="-1">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','102')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </font></td>
                <td align="right"><font size="-1">
                  <xsl:for-each select="Charge[@Id='831' and @PT='A']">
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
          </xsl:if>
          
          <!-- contract gross amount prepaid (multiple currency) -->
          <xsl:if test="$pricing-prepaid = 'G' or not(0 = number(Charge[@Id='931' and @PT='A']/@Amount) ) ">
              <tr>
                <td><font size="-1">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','104')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </font></td>
                <td align="right"><font size="-1">
                  <xsl:for-each select="Charge[@Id='931' and @PT='A']">
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
          </xsl:if>
          
        </tbody>
      </table>
      <br/>
      
    </xsl:if>
    
    <!-- charge types -->
    <xsl:for-each select="PerCTInfo">
      <br/>
      <table border="1" width="30%" cellspacing="0" cellpadding="0">
        <thead>
          <tr>
            <td colspan="2"><font size="-1"><b>
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
            </b></font></td>
          </tr>
        </thead>
        <tbody>
        
          <!-- Charges on PerCTInfo-Level; amounts per contract and charge type  -->
          <!-- charge type net (multiple currency) -->
          <xsl:if test="(($pricing = 'N' and @PT = 'P') or ($pricing-prepaid = 'N' and @PT = 'A') ) or not(0 = number(Charge[@Id='832']/@Amount) ) ">
              <tr>
                <td><font size="-1">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','121')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </font></td>
                <td align="right"><font size="-1">
                  <xsl:for-each select="Charge[@Id='832']">
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
          </xsl:if>
          
          <!-- charge type net undiscounted (multiple currency) -->
          <xsl:if test="(($pricing = 'N' and @PT = 'P') or ($pricing-prepaid = 'N' and @PT = 'A') ) or not(0 = number(Charge[@Id='838']/@Amount) ) ">
              <tr>
                <td><font size="-1">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','122')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </font></td>
                <td align="right"><font size="-1">
                  <xsl:for-each select="Charge[@Id='838']">
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
          </xsl:if>
          
          <!-- charge type net ATM (multiple currency) -->
          <!-- ATM is not available for BOP case and for Prepaid -->
          <xsl:if test="ancestor::Contract[@BOPInd='N'] and @PT='P'">
            <xsl:if test="$pricing = 'N' and not(0 = number(Charge[@Id='837']/@Amount) ) ">
                <tr>
                  <td><font size="-1">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','137')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </font></td>
                  <td align="right"><font size="-1">
                    <xsl:for-each select="Charge[@Id='837']">
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
            </xsl:if>
          </xsl:if>
          
          <!-- charge type gross (multiple currency) -->
          <xsl:if test="(($pricing = 'G' and @PT = 'P') or ($pricing-prepaid = 'G' and @PT = 'A') ) or not(0 = number(Charge[@Id='932']/@Amount) ) ">
              <tr>
                <td><font size="-1">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','123')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </font></td>
                <td align="right"><font size="-1">
                  <xsl:for-each select="Charge[@Id='932']">
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
          </xsl:if>
          
          <!-- charge type gross undiscounted (multiple currency) -->
          <xsl:if test="(($pricing = 'G' and @PT = 'P') or ($pricing-prepaid = 'G' and @PT = 'A') ) or not(0 = number(Charge[@Id='938']/@Amount) ) ">
              <tr>
                <td><font size="-1">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','124')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </font></td>
                <td align="right"><font size="-1">
                  <xsl:for-each select="Charge[@Id='938']">
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
          </xsl:if>
          
          <!-- charge type gross ATM (multiple currency) -->
          <!-- ATM is not available for BOP case and for Prepaid -->
          <xsl:if test="ancestor::Contract[@BOPInd='N'] and @PT='P'">
            <xsl:if test="$pricing = 'G' and not(0 = number(Charge[@Id='937']/@Amount) ) ">
                <tr>
                  <td><font size="-1">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','138')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </font></td>
                  <td align="right"><font size="-1">
                    <xsl:for-each select="Charge[@Id='937']">
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
            </xsl:if>
          </xsl:if>
        </tbody>
      </table>

      <xsl:if test="SumItem">
        <br/>
        <table border="1" width="100%" cellspacing="0" cellpadding="0">
          <tr>
            <!-- quantity -->
            <xsl:for-each select="$txt">
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('txt-index','125')[@xml:lang=$lang]/@Des"/>
              </font></th>
            </xsl:for-each>
            <!-- active days -->
            <xsl:choose>
              <xsl:when test="@CT='A'">
                <xsl:for-each select="$txt">
                  <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                    <xsl:value-of select="key('txt-index','126')[@xml:lang=$lang]/@Des"/>
                  </font></th>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
            <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
              <!-- profile -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','139')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </font></th>
            <!-- service -->
            <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','140')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </font></th>
            <!-- package -->
            <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','141')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </font></th>
            <xsl:for-each select="$txt">
              <!-- tariff model -->
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('txt-index','142')[@xml:lang=$lang]/@Des"/>
              </font></th>
            </xsl:for-each>
            <!-- remark -->
            <xsl:choose>
              <xsl:when test="@CT='O'">
                <xsl:for-each select="$txt">
                  <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                    <xsl:value-of select="key('txt-index','288')[@xml:lang=$lang]/@Des"/>
                  </font></th>
                </xsl:for-each>
              </xsl:when>
              <xsl:when test="@CT='P'">
                <xsl:for-each select="$txt">
                  <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                    <xsl:value-of select="key('txt-index','288')[@xml:lang=$lang]/@Des"/>
                  </font></th>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
            <!-- period info -->
            <xsl:choose>
              <xsl:when test="@CT='A'">
                <xsl:for-each select="$txt">
                  <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                    <xsl:value-of select="key('txt-index','145')[@xml:lang=$lang]/@Des"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="key('txt-index','290')[@xml:lang=$lang]/@Des"/>
                  </font></th>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
            <!-- service parameter info -->
            <xsl:choose>
              <xsl:when test="@CT='S'">
                <xsl:for-each select="$txt">
                  <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                    <xsl:value-of select="key('txt-index','289')[@xml:lang=$lang]/@Des"/>
                  </font></th>
                </xsl:for-each>
              </xsl:when>
              <!--
              <xsl:when test="@CT='A'">
                <xsl:for-each select="$txt">
                  <th nowrap="nowrap">
                    <xsl:value-of select="key('txt-index','289')[@xml:lang=$lang]/@Des"/>
                  </th>
                </xsl:for-each>
              </xsl:when>
              -->
              <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
            <!-- period price -->
            <xsl:choose>
              <xsl:when test="@CT='A'">
                <xsl:for-each select="$txt">
                  <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                    <xsl:value-of select="key('txt-index','144')[@xml:lang=$lang]/@Des"/>
                  </font></th>
                </xsl:for-each>
              </xsl:when>
              <xsl:when test="@CT='S'">
                <xsl:for-each select="$txt">
                  <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                    <xsl:value-of select="key('txt-index','144')[@xml:lang=$lang]/@Des"/>
                  </font></th>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
            <!-- content product info -->
            <xsl:choose>
              <xsl:when test="@CT='U'">
                <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','418')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                  <xsl:text>/</xsl:text>
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','419')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                  <xsl:text>/</xsl:text>
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','420')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                  <xsl:text>/</xsl:text>
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','444')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </font></th>
              </xsl:when>
              <xsl:otherwise/>
            </xsl:choose>
            <!-- charge -->
            <xsl:for-each select="$txt">
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('txt-index','143')[@xml:lang=$lang]/@Des"/>
              </font></th>
            </xsl:for-each>
          </tr>
          <xsl:for-each select="SumItem">
            <xsl:apply-templates select="."/>
          </xsl:for-each>
        </table>
      </xsl:if>

    </xsl:for-each>

    <!-- balance snapshots -->  
    <xsl:if test="$bop-ind='N' or $billed='Y'">

      <xsl:call-template name="contract-balance-snapshots">
        <xsl:with-param name="co-id" select="$co-id"/>
      </xsl:call-template>

    </xsl:if>

    <!-- balance requests -->
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

    <!-- credits granted to the prepaid balance -->
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

    <p>
      <!-- recurring charge details info -->
      <xsl:call-template name="print-charge-details">
        <xsl:with-param name="co-id" select="$co-id"/>
        <xsl:with-param name="bopind" select="@BOPInd"/>
        <xsl:with-param name="bopseqno" select="BOPAlt/@BOPSeqNo"/>
        <xsl:with-param name="boptype" select="BOPAlt/AggSet/Att/@Ty"/>
        <xsl:with-param name="charge-details" select="$invoice-charge-details[parent::Document/@BillSeqNo = $billseqno]"/>
        <xsl:with-param name="charge-type" select="'A'"/>
      </xsl:call-template>
    </p>

    <p>
      <!-- one-time charge details info -->
      <xsl:call-template name="print-charge-details">
        <xsl:with-param name="co-id" select="$co-id"/>
        <xsl:with-param name="bopind" select="@BOPInd"/>
        <xsl:with-param name="bopseqno" select="BOPAlt/@BOPSeqNo"/>
        <xsl:with-param name="boptype" select="BOPAlt/AggSet/Att/@Ty"/>
        <xsl:with-param name="charge-details" select="$invoice-charge-details[parent::Document/@BillSeqNo = $billseqno]"/>
        <xsl:with-param name="charge-type" select="'S'"/>
      </xsl:call-template>
    </p>

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

    <tr>
      <!-- quantity -->
      <td align="center"><font size="-1">
        <xsl:value-of select="@NumItems"/>
      </font></td>
      <!-- active days -->
      <xsl:choose>
        <xsl:when test="../@CT='A'">
          <td align="center"><font size="-1">
            <xsl:value-of select="@NumDays"/>
          </font></td>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
      <!-- profile, service, package, tariff model -->
      <xsl:choose>
        <xsl:when test="AggSet">
          <xsl:apply-templates select="AggSet" mode="sum-item"/>
        </xsl:when>
        <xsl:otherwise>
          <td align="center">-</td>
          <td align="center">-</td>
          <td align="center">-</td>
          <td align="center">-</td>
        </xsl:otherwise>
      </xsl:choose>
      <!-- content catalogue, catalogue element, price list -->
      <xsl:choose>
        <xsl:when test="AggSet and (../@CT='U')">
          <xsl:apply-templates select="AggSet" mode="content"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
      <!-- remark -->
      <xsl:choose>
        <xsl:when test="../@CT='O'">
          <td><font face="Arial Narrow" size="-1">
            <xsl:apply-templates select="Txt"/>
          </font></td>
        </xsl:when>
        <xsl:when test="../@CT='P'">
          <td><font face="Arial Narrow" size="-1">
            <xsl:apply-templates select="Txt"/>
          </font></td>
        </xsl:when>
        <xsl:when test="name(..)='CustRef'">
          <td><font face="Arial Narrow" size="-1">
            <xsl:apply-templates select="Txt"/>
          </font></td>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
      <!-- service status -->
      <xsl:if test="../@CT='A'">
        <xsl:choose>
          <xsl:when test="SrvStatus">
            <td nowrap="nowrap" align="center"><font face="Arial Narrow" size="-1">
              <xsl:for-each select="SrvStatus">
                <xsl:apply-templates select="."/>
                <br/>
              </xsl:for-each>
            </font></td>
          </xsl:when>
          <xsl:otherwise>
            <td align="center">-</td>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <!-- service parameter -->
      <xsl:if test="../@CT='S'">
        <xsl:choose>
          <xsl:when test="SrvParams">
            <xsl:apply-templates select="SrvParams"/>
          </xsl:when>
          <xsl:otherwise>
            <td align="center">-</td>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <!-- price -->
      <xsl:choose>
        <xsl:when test="../@CT='A'">
          <xsl:choose>
            <xsl:when test="Price">
              <td align="right"><font size="-1">
                <xsl:apply-templates select="Price"/>
              </font></td>
            </xsl:when>
            <xsl:otherwise>
              <td/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="../@CT='S'">
          <xsl:choose>
            <xsl:when test="Price">
              <td align="right"><font size="-1">
                <xsl:apply-templates select="Price"/>
              </font></td>
            </xsl:when>
            <xsl:otherwise>
              <td/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
      <!-- charge -->
      <td align="right"><font size="-1">
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
          <!-- print gross amount (multiple currency possible) -->
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
    </tr>

    <!-- promotions -->
    <xsl:if test="PromoItem">
      <xsl:choose>
        <xsl:when test="../@CT='U'">
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
              <xsl:apply-templates select="." mode="sum-item-usage"/>
            </tr>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="../@CT='O' or ../@CT='P' or name(..)='CustRef'">
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
              <xsl:apply-templates select="." mode="sum-item-occ"/>
            </tr>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="../@CT='S'">
          <tr>
            <xsl:for-each select="$txt">
              <th/>
              <th colspan="2" bgcolor="#DCDCDC" nowrap="nowrap"><font face="Arial Narrow" size="-1">
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
              <xsl:apply-templates select="." mode="sum-item-subscription"/>
            </tr>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="../@CT='A'">
          <tr>
            <xsl:for-each select="$txt">
              <th/>
              <th bgcolor="#DCDCDC" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('txt-index','318')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <th colspan="2" bgcolor="#DCDCDC" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('txt-index','313')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <th colspan="2" bgcolor="#DCDCDC" nowrap="nowrap"><font face="Arial Narrow" size="-1">
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
              <xsl:apply-templates select="." mode="sum-item-access"/>
            </tr>
          </xsl:for-each>
        </xsl:when>
      </xsl:choose>
    </xsl:if>

  </xsl:template>

  <!-- account info -->
  <xsl:template match="FUAccInfo">

    <!-- account id, type -->
    <xsl:apply-templates select="FUAcc"/>
    
    <td align="center"><font face="Arial Narrow" size="-1">
      <!-- period -->
      <xsl:apply-templates select="Date[@Type='START']"/>
      <xsl:text> - </xsl:text>
      <xsl:apply-templates select="Date[@Type='END']"/><br/>
      <!-- carry-over expiration date -->
      <xsl:apply-templates select="Date[@Type='END_FU_CO']"/>
    </font></td>
    <td align="center"><font face="Arial Narrow" size="-1">
      <!-- markup fee -->
      <xsl:if test="Charge[@Id='526']">
        <xsl:call-template name="number-format">
          <xsl:with-param name="number" select="Charge[@Id='526']/@Amount"/>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:for-each select="Charge[@Id='526']/@CurrCode">
          <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
        </xsl:for-each>
      </xsl:if>      
    </font></td>    
    <td align="right"><font face="Arial Narrow" size="-1">
      <!-- currently reduced -->
      <xsl:if test="Charge[@Id='54']">
        <xsl:call-template name="number-format">
          <xsl:with-param name="number" select="Charge[@Id='54']/@Amount"/>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:for-each select="Charge[@Id='54']/@CurrCode">
          <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
        </xsl:for-each>
      </xsl:if>
      <br/>
      <!-- totally reduced -->
      <xsl:if test="Charge[@Id='55']">
        <xsl:call-template name="number-format">
          <xsl:with-param name="number" select="Charge[@Id='55']/@Amount"/>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:for-each select="Charge[@Id='55']/@CurrCode">
          <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
        </xsl:for-each>
      </xsl:if>        
    </font></td>
    
    <!-- Evaluated/granted free units -->
    <xsl:choose>
    
      <!-- Eval UoM is technical -->
      <xsl:when test="FUNum[@UME]">
        <xsl:apply-templates select="FUNum[@UME]"/>
      </xsl:when>
      
      <!-- Eval UoM is monetary -->
      <xsl:otherwise>
        <!-- original FU amount  -->
        <td align="right"><font face="Arial Narrow" size="-1">         
          <xsl:if test="Charge[@Id='56']">
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="Charge[@Id='56']/@Amount"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>
            <xsl:for-each select="Charge[@Id='56']/@CurrCode">
              <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
          </xsl:if>      
          <br/>
          <!-- granted FU amount net part -->          
          <xsl:if test="Charge[@Id='57']">
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="Charge[@Id='57']/@Amount"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>
            <xsl:for-each select="Charge[@Id='57']/@CurrCode">
              <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
          </xsl:if>
        </font></td>
        <!-- carry over FU amount -->
        <td align="right"><font face="Arial Narrow" size="-1">
          <xsl:if test="Charge[@Id='58']">
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="Charge[@Id='58']/@Amount"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>
            <xsl:for-each select="Charge[@Id='58']/@CurrCode">
              <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
          </xsl:if>
        </font></td>
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
            
                
                <td align="right"><font face="Arial Narrow" size="-1">
                  <!-- currently repriced amount -->
                  <xsl:if test="Charge[@Id='527']">
                    <xsl:call-template name="number-format">
                      <xsl:with-param name="number" select="Charge[@Id='527']/@Amount"/>
                    </xsl:call-template>
                    <xsl:text> </xsl:text>
                    <xsl:for-each select="Charge[@Id='527']/@CurrCode">
                      <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                    </xsl:for-each>
                  </xsl:if>      
                  <br/>
                  <!-- totally repriced amount -->
                  <xsl:if test="Charge[@Id='528']">
                    <xsl:call-template name="number-format">
                      <xsl:with-param name="number" select="Charge[@Id='528']/@Amount"/>
                    </xsl:call-template>
                    <xsl:text> </xsl:text>
                    <xsl:for-each select="Charge[@Id='528']/@CurrCode">
                      <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                    </xsl:for-each>
                  </xsl:if>
                </font></td>
                
            </xsl:when>
            
            <!-- Normal free units -->
            <xsl:otherwise>
            
                <td/>
                
            </xsl:otherwise>
            
          </xsl:choose>
          
        </xsl:otherwise>
    </xsl:choose>
    
    
    

  </xsl:template>

  <!-- account -->
  <xsl:template match="FUAcc">

    <td align="center"><font face="Arial Narrow" size="-1">
      <!-- account id / hist. id -->
      <xsl:value-of select="@Id"/>
      <xsl:text> / </xsl:text>
      <xsl:value-of select="@HistId"/>
      <br/>
      <!-- account type -->
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
    </font></td>

    <td align="center"><font face="Arial Narrow" size="-1">
      <!-- account package / element / version -->
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="@FUP"/>
        <xsl:with-param name="Type"  select="'FUP'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
      <xsl:text> / </xsl:text>
      <xsl:value-of select="@FUE"/>
      <xsl:text> / </xsl:text>
      <xsl:value-of select="@FUEV"/><br/>
      <!-- charge plan -->
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="@ChPlan"/>
        <xsl:with-param name="Type"  select="'CPD'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
    </font></td>

  </xsl:template>

  <!-- granted free units -->
  <xsl:template match="FUNum[@UME]">

    <td align="right"><font face="Arial Narrow" size="-1">
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
      <br/>
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
    </font></td>
    <td align="right"><font face="Arial Narrow" size="-1">
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
    </font></td>
    
  </xsl:template>
  
  
  <!-- applied free units -->
  <xsl:template match="FUNum[@UMA]">
    
    <td align="right"><font face="Arial Narrow" size="-1">
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
      <br/>
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
    </font></td>

  </xsl:template>

  <!-- balance snapshot -->
  <xsl:template match="BalSsh">

    <!-- snapshot date -->
    <td align="center"><font size="-1">
      <xsl:apply-templates select="Date[@Type='BAL_REF']"/><br/>
    </font></td>
    <xsl:apply-templates select="Bal"/>
    <xsl:apply-templates select="BalVols"/>

  </xsl:template>

  <!-- balance request -->
  <xsl:template match="BalAd">

    <!-- request date -->
    <td align="center"><font size="-1">
      <xsl:apply-templates select="Date[@Type='BAL_REF']"/>
    </font></td>
    <!-- type -->
    <td nowrap="nowrap" align="center"><font face="Arial Narrow" size="-1">
      <xsl:call-template name="DataDomainLgnMap">
        <xsl:with-param name="Index"     select="@Type"/>
        <xsl:with-param name="Type"      select="'DD'"/>
        <xsl:with-param name="Desc"      select="'1'"/>
        <xsl:with-param name="ClassId"   select="'BIR_PURPOSE_CLASS'"/>
      </xsl:call-template>
    </font></td>
    <!-- period -->
    <td align="center"><font size="-1">
      <xsl:apply-templates select="Date[@Type='VALID_FROM']"/>
      <xsl:text> - </xsl:text>
      <xsl:apply-templates select="Date[@Type='VALID_TO']"/>
      <br/>
      <xsl:call-template name="number-format">
        <xsl:with-param name="number" select="@AdjAmt"/>
      </xsl:call-template>
      <xsl:text> </xsl:text>
      <xsl:for-each select="Bal/@CurrCode">
        <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
      </xsl:for-each>
    </font></td>
    <!-- reason -->
    <td nowrap="nowrap" align="center"><font face="Arial Narrow" size="-1">
      <xsl:if test="@Reason">
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@Reason"/>
          <xsl:with-param name="Type"  select="'AR'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </xsl:if>
    </font></td>

    <xsl:apply-templates select="Bal"/>
    <xsl:apply-templates select="BalVols"/>

  </xsl:template>

  <!-- discount info ( free units ) -->
  <xsl:template match="FUDiscountInfo">

    <!-- monetary discount info -->
    <xsl:if test="Charge">
      <tr>
        <!-- package -->
        <td nowrap="nowrap" align="center"><font size="-1">
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="@FUP"/>
            <xsl:with-param name="Type"  select="'FUP'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
        </font></td>
        <!-- eligible amount -->
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
        <!-- discounted amount -->
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
        <!-- package -->
        <td nowrap="nowrap" align="center"><font size="-1">
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="../@FUP"/>
            <xsl:with-param name="Type"  select="'FUP'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
        </font></td>
        <!-- non monetary discount info -->
        <xsl:apply-templates select="."/>
      </tr>
    </xsl:for-each>

  </xsl:template>

  <!--  cost control service / CS discount info -->
  <xsl:template match="CCHDiscountInfo|CSDiscountInfo">

    <!-- monetary discount info -->
    <xsl:if test="Charge">
      <tr>
        <!-- service -->
        <td nowrap="nowrap" align="center"><font size="-1">
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="@SN"/>
            <xsl:with-param name="Type"  select="'SN'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
        </font></td>
        <!-- eligible amount -->
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
        <!-- discounted amount -->
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
        <!-- service -->
        <td nowrap="nowrap" align="center"><font size="-1">
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="../@SN"/>
            <xsl:with-param name="Type"  select="'SN'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
        </font></td>
        <!-- non monetary discount info -->
        <xsl:apply-templates select="."/>
      </tr>
    </xsl:for-each>

  </xsl:template>

  <!--  granted credits to prepaid balances info -->
  <xsl:template match="PromoCreditPerBal">
    <xsl:apply-templates select="Bal" mode="credit-per-bal"/>
    <!-- total credit amount for Bal -->
    <td align="right"><font size="-1">
      <xsl:for-each select="Charge">
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
  </xsl:template>

  <!--  granted credits to prepaid balances info -->
  <xsl:template match="PromoCreditPerBal" mode="promo">
    <xsl:apply-templates select="Bal" mode="promo"/>
    <!-- total credit amount for Bal -->
    <td align="right"><font size="-1">
      <xsl:for-each select="Charge">
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
  </xsl:template>

  <!--  bundle info -->
  <xsl:template name="BundleInfo">

    <xsl:param name="co-id"/>
    <xsl:param name="bopind"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>

    <tr>
      <!-- bundle name -->
      <td align="center" nowrap="nowrap"><font size="-1">
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@SN"/>
          <xsl:with-param name="Type"  select="'SN'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </font></td>
      <!-- purchase date -->
      <td align="center"><font size="-1">
        <xsl:call-template name="date-format">
          <xsl:with-param name="date" select="Date[@Type='PURCHASE']/@Date"/>
        </xsl:call-template>
      </font></td>
      <!-- consumption period -->
      <td align="center" nowrap="nowrap"><font size="-1">
        <xsl:call-template name="date-format">
          <xsl:with-param name="date" select="Date[@Type='START']/@Date"/>
        </xsl:call-template>
        <xsl:text> - </xsl:text>
        <xsl:call-template name="date-format">
          <xsl:with-param name="date" select="Date[@Type='END']/@Date"/>
        </xsl:call-template>
      </font></td>
      <!-- bundle products -->
      <td align="center"><font size="-1">
        <xsl:for-each select="BundledProd">
          <xsl:apply-templates select="."/><br/>
        </xsl:for-each>
      </font></td>
      <!-- bundle price -->
      <td align="center"><font size="-1">
        <xsl:call-template name="print-call-details-bundle-purchase-price">
          <xsl:with-param name="co-id" select="$co-id"/>
          <xsl:with-param name="service" select="@SN"/>
          <xsl:with-param name="sequence-no" select="@SeqNo"/>
          <xsl:with-param name="call-details" select="$call-details"/>
          <xsl:with-param name="bopind" select="$bopind"/>
          <xsl:with-param name="bopseqno" select="$bopseqno"/>
          <xsl:with-param name="boptype" select="$boptype"/>
        </xsl:call-template>
      </font></td>
    </tr>

  </xsl:template>

  <!--  bundled product info -->
  <xsl:template match="BundledProd">

    <xsl:call-template name="LgnMap">
      <xsl:with-param name="Mode"  select="'0'"/>
      <xsl:with-param name="Index" select="@BPROD"/>
      <xsl:with-param name="Type"  select="'BPROD'"/>
      <xsl:with-param name="Desc"  select="'1'"/>
    </xsl:call-template>

  </xsl:template>

</xsl:stylesheet>
