<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    SummaryCSV.xsl

  Owner:   Matthias Fehrenbacher
               Natalie Kather

  @(#) ABSTRACT : XML -> CSV stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms sum sheet documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/SummaryCSV.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bgh="http://www.lhsgroup.com/BSCS/BGH" exclude-result-prefixes="xsl bgh">

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
  
  <xsl:variable name="xsl-common" select="document('CommonCSV.xsl')"/>
  
  <!-- sum sheet -->
  <xsl:template match="Summary">


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
    
    <bgh:row>
        <bgh:cell>
          <!-- "Sum Sheet" -->
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','91')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </bgh:cell>
    </bgh:row>
    
    <!-- Print POSTPAID sums only if they are != 0 -->
    <!-- postpaid sums -->
    <xsl:if test="Charge[@PT = 'P' and 0 != number(@Amount) ]">
        
        <bgh:row>
            <bgh:cell/>
            <xsl:for-each select="$txt">
                <bgh:cell>
                  <!-- Charges -->
                  <xsl:value-of select="key('txt-index','329')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- Amount -->
                  <xsl:value-of select="key('txt-index','50')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
            </xsl:for-each>
        </bgh:row>
        
        <xsl:if test="$pricing = 'N' or not(0 = number(Charge[@Id='177' and @PT='P']/@Amount) )  ">
          <bgh:row>
            <!-- net invoice amount postpaid (multiple currency) -->
            <bgh:cell/>
            <bgh:cell>
            
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','94')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
                
            </bgh:cell>
            <bgh:cell>
            
              <xsl:for-each select="Charge[@Id='177' and @PT='P']">
                
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
        </xsl:if>
        
        <xsl:if test="$pricing = 'G' or not(0 = number(Charge[@Id='277' and @PT='P']/@Amount) )  ">
          <bgh:row>
            <bgh:cell/>
            <bgh:cell>
              
              <!-- gross invoice amount postpaid (multiple currency) -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','95')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
                  
            </bgh:cell>
            <bgh:cell>
                
              <xsl:for-each select="Charge[@Id='277' and @PT='P']">
                
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
        </xsl:if>
        
        <xsl:if test="$pricing = 'N' or not(0 = number(Charge[@Id='812' and @PT='P']/@Amount) )  ">
          <bgh:row>
            <bgh:cell/>
            <bgh:cell>
            
                <!-- total net usage postpaid (multiple currency) -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','96')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
                  
            </bgh:cell>
            <bgh:cell>
                
              <xsl:for-each select="Charge[@Id='812' and @PT='P']">
                
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
        </xsl:if>
        
        <xsl:if test="$pricing = 'G' or not(0 = number(Charge[@Id='912' and @PT='P']/@Amount) )  ">
          <bgh:row>
            <bgh:cell/>
            <bgh:cell>
            
              <!-- total gross usage postpaid (multiple currency) -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','99')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
                  
            </bgh:cell>
            <bgh:cell>
                
              <xsl:for-each select="Charge[@Id='912' and @PT='P']">
                
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
        </xsl:if>
                  
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
              
                <!-- total one-time charges net/gross postpaid (multiple currency) -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','97')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
                  
            </bgh:cell>
            <bgh:cell>
                
              <xsl:for-each select="Charge[@Id='910' and @PT='P']">
                
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
                  
                  
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
              
              <!-- total recurring charges net/gross postpaid (multiple currency) -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','98')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
                  
            </bgh:cell>
            <bgh:cell>
                
              <xsl:for-each select="Charge[@Id='911' and @PT='P']">
                
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
               
               
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
              
                <!-- total occ charges net/gross postpaid (multiple currency) -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','100')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
                  
            </bgh:cell>
            <bgh:cell>
                
              <xsl:for-each select="Charge[@Id='913' and @PT='P']">
                
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
                  
        <bgh:row/>
        
    </xsl:if>
    
    <!-- prepaid sums -->
    
    <xsl:if test="Charge[@PT = 'A' and 0 != number(@Amount) ]">
        
        <bgh:row>
    
            <bgh:cell/>
              
            <xsl:for-each select="$txt">
              
                <bgh:cell>
                
                  <xsl:value-of select="key('txt-index','329')[@xml:lang=$lang]/@Des"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="key('txt-index','286')[@xml:lang=$lang]/@Des"/>
                
                </bgh:cell>
                <bgh:cell>
                
                  <xsl:value-of select="key('txt-index','50')[@xml:lang=$lang]/@Des"/>
                
                </bgh:cell>
    
            </xsl:for-each>
                
        </bgh:row>
              
        <xsl:if test="$pricing-prepaid = 'N' or not(0 = number(Charge[@Id='177' and @PT='A']/@Amount) )  ">
          <bgh:row>
            <bgh:cell/>
            <bgh:cell>
            
                <!-- net invoice amount prepaid (multiple currency) -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','94')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              
            </bgh:cell>
            <bgh:cell>
                    
              <xsl:for-each select="Charge[@Id='177' and @PT='A']">
                
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
        </xsl:if>
        
        <xsl:if test="$pricing-prepaid = 'G' or not(0 = number(Charge[@Id='277' and @PT='A']/@Amount) )  ">
          <bgh:row>
            <bgh:cell/>
            <bgh:cell>
    
                <!-- gross invoice amount prepaid (multiple currency) -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','95')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
                  
            </bgh:cell>
            <bgh:cell>
                
              <xsl:for-each select="Charge[@Id='277' and @PT='A']">
                
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
        </xsl:if>
        
        <xsl:if test="$pricing-prepaid = 'N' or not(0 = number(Charge[@Id='812' and @PT='A']/@Amount) )  ">
          <bgh:row>
            <bgh:cell/>
            <bgh:cell>
    
                <!-- total net usage prepaid (multiple currency) -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','96')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
                  
            </bgh:cell>
            <bgh:cell>
                
              <xsl:for-each select="Charge[@Id='812' and @PT='A']">
                
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
        </xsl:if>
        
        <xsl:if test="$pricing-prepaid = 'G' or not(0 = number(Charge[@Id='912' and @PT='A']/@Amount) )  ">
          <bgh:row>
            <bgh:cell/>
            <bgh:cell>
    
                <!-- total gross usage prepaid (multiple currency) -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','99')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
                  
            </bgh:cell>
            <bgh:cell>
                
              <xsl:for-each select="Charge[@Id='912' and @PT='A']">
                
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
        </xsl:if>
           
        <!-- total one-time charges net/gross prepaid (multiple currency) -->
        <xsl:if test="Charge[@Id='910' and @PT='A']"> 
           
            <bgh:row>
                <bgh:cell/>
                <bgh:cell>
    
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','97')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                        
                </bgh:cell>
                <bgh:cell>
                      
                    <xsl:for-each select="Charge[@Id='910' and @PT='A']">
                      
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
                          
        </xsl:if>
              
              
              
        <!-- total recurring charges net/gross prepaid (multiple currency) -->
        <xsl:if test="Charge[@Id='911' and @PT='A']">          
                
            <bgh:row>
                <bgh:cell/>
                <bgh:cell>
                    
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','98')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                    
                </bgh:cell>
                <bgh:cell>
                  
                    <xsl:for-each select="Charge[@Id='911' and @PT='A']">
                      
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
                
        </xsl:if>
                
                
                
        <!-- total occ charges net/gross prepaid (multiple currency) -->
        <xsl:if test="Charge[@Id='913' and @PT='A']">
                
            <bgh:row>
                <bgh:cell/>
                <bgh:cell>
                    
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','100')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                    
                </bgh:cell>
                <bgh:cell>
                  
                    <xsl:for-each select="Charge[@Id='913' and @PT='A']">
                      
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
                
        </xsl:if>
            
        <bgh:row/>
        
    </xsl:if>
    
  </xsl:template>
  

  <!-- billing account owner -->
  <xsl:template match="CustRef">

    <xsl:variable name="billseqno" select="@BillSeqNo"/>

    <!-- fees -->
    <xsl:if test="SumItem">

    <bgh:row>
        <bgh:cell>
            <!--   Other Credits and Charges            -->
            <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','119')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        </bgh:cell>
    </bgh:row>
    
    <bgh:row>
        
        <xsl:for-each select="$txt">
            <bgh:cell>
                <!-- quantity -->
                <xsl:value-of select="key('txt-index','125')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                <!-- profile -->
                <xsl:value-of select="key('txt-index','139')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                <!-- service -->
                <xsl:value-of select="key('txt-index','140')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                <!-- package -->
                <xsl:value-of select="key('txt-index','141')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                <!-- tariff model -->
                <xsl:value-of select="key('txt-index','142')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                <!-- remark -->
                <xsl:value-of select="key('txt-index','146')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                <!-- charge -->
                <xsl:value-of select="key('txt-index','143')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
        </xsl:for-each>
          
    </bgh:row>
        
    <xsl:for-each select="SumItem">
        <xsl:apply-templates select="."/>
    </xsl:for-each>
        
    </xsl:if>
    

    <!-- contract(s) -->
        
    <xsl:for-each select="Contract">

        <!-- contract sorting -->
        <xsl:sort select="@Id" data-type="text" order="ascending"/>
      
        <!-- billed alternative first -->
        <xsl:sort select="BOPAlt/@BILLED" data-type="text" order="descending"/>

        <!-- customer address -->
        <xsl:apply-templates select="../Addr" mode="col"/>

         
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                <!-- customer number -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','302')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <xsl:value-of select="../@Id"/>
            </bgh:cell>
        </bgh:row>
          
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                <!-- customer code -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','303')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <xsl:value-of select="../@CustCode"/>
            </bgh:cell>
        </bgh:row>
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                <!-- billing request -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','550')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <xsl:value-of select="../@BillSeqNo"/>
            </bgh:cell>
        </bgh:row>

        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                <!-- billing period -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','551')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
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
            </bgh:cell>
        </bgh:row>
            
        <bgh:row/>
        
        
        <xsl:if test="../Charge[@PT='P' and 0 != number(@Amount) ]">
        
            <bgh:row>
                <bgh:cell>
                    <!-- POSTPAID charges of customer -->
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','387')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                </bgh:cell>
            </bgh:row>
              
            <xsl:if test="$pricing = 'N' or not(0 = number(../Charge[@Id='830' and @PT='P']/@Amount) )  ">
              <bgh:row>
                <bgh:cell/>
                <bgh:cell> 
                          
                    <!-- customer net amount postpaid (multiple currency) -->
                    <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','102')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                    
                </bgh:cell>
                              
                <xsl:for-each select="../Charge[@Id='830' and @PT='P']">
                    <bgh:cell>
                        <xsl:call-template name="number-format">
                          <xsl:with-param name="number" select="@Amount"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                        
                          <xsl:call-template name="currency">
                            <xsl:with-param name="CurrCode" select="@CurrCode"/>
                          </xsl:call-template>
                    </bgh:cell>
                </xsl:for-each>
              </bgh:row>
            </xsl:if>
            
            <xsl:if test="$pricing = 'G' or not(0 = number(../Charge[@Id='930' and @PT='P']/@Amount) )  ">
              <bgh:row>
                <bgh:cell/>
                <bgh:cell> 
                    <!-- customer gross amount postpaid (multiple currency) -->
                    <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','104')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each> 
                </bgh:cell>
                
                <xsl:for-each select="../Charge[@Id='930' and @PT='P']">
                    <bgh:cell>
                        <xsl:call-template name="number-format">
                          <xsl:with-param name="number" select="@Amount"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                          <xsl:call-template name="currency">
                            <xsl:with-param name="CurrCode" select="@CurrCode"/>
                          </xsl:call-template>
                    </bgh:cell>
                </xsl:for-each>
              </bgh:row>
            </xsl:if>
            
            <xsl:if test="$pricing = 'N' or not(0 = number(../Charge[@Id='835' and @PT='P']/@Amount) )  ">
              <bgh:row>
                <bgh:cell/>
                <bgh:cell>
                    <!-- Usage charges (net) -->
                    <!-- customer net usage postpaid (multiple currency) -->
                    <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','103')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                </bgh:cell>
                
                <xsl:for-each select="../Charge[@Id='835' and @PT='P']">
                    <bgh:cell>
                        <xsl:call-template name="number-format">
                          <xsl:with-param name="number" select="@Amount"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                      <xsl:call-template name="currency">
                        <xsl:with-param name="CurrCode" select="@CurrCode"/>
                      </xsl:call-template> 
                    </bgh:cell>
                </xsl:for-each>
              </bgh:row>
            </xsl:if>
            
            <xsl:if test="$pricing = 'G' or not(0 = number(../Charge[@Id='935' and @PT='P']/@Amount) )  ">
              <bgh:row>
                <bgh:cell/>
                <bgh:cell>
                    <!-- Usage charges (gross) -->
                    <!-- customer gross usage postpaid (multiple currency) -->
                    <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','107')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                </bgh:cell>
                
                <xsl:for-each select="../Charge[@Id='935' and @PT='P']">
                    <bgh:cell>
                        <xsl:call-template name="number-format">
                          <xsl:with-param name="number" select="@Amount"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                      <xsl:call-template name="currency">
                        <xsl:with-param name="CurrCode" select="@CurrCode"/>
                      </xsl:call-template>
                    </bgh:cell> 
                </xsl:for-each>
              </bgh:row>
            </xsl:if>
            
            <bgh:row>
                <bgh:cell/>
                <bgh:cell>
                    <!-- customer one-time charges net/gross postpaid (multiple currency) -->
                    <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','105')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                </bgh:cell>
                
                <xsl:for-each select="../Charge[@Id='933' and @PT='P']">
                    <bgh:cell>
                        <xsl:call-template name="number-format">
                          <xsl:with-param name="number" select="@Amount"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                          <xsl:call-template name="currency">
                            <xsl:with-param name="CurrCode" select="@CurrCode"/>
                          </xsl:call-template>
                    </bgh:cell>
                </xsl:for-each>
            </bgh:row>
                            
            <bgh:row>
                <bgh:cell/>
                <bgh:cell>
                    <!-- customer recurring charges net/gross postpaid (multiple currency) -->    
                    <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','106')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                </bgh:cell>
                
                <xsl:for-each select="../Charge[@Id='934'and @PT='P']">
                    <bgh:cell>
                        <xsl:call-template name="number-format">
                          <xsl:with-param name="number" select="@Amount"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                          <xsl:call-template name="currency">
                            <xsl:with-param name="CurrCode" select="@CurrCode"/>
                          </xsl:call-template>
                    </bgh:cell>
                </xsl:for-each>
            </bgh:row>
            
            <bgh:row>
                <bgh:cell/>
                <bgh:cell>
                    <!-- customer occ charges net/gross postpaid (multiple currency) -->
                    <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','108')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                </bgh:cell>
                
                <xsl:for-each select="../Charge[@Id='936' and @PT='P']">
                    <bgh:cell>
                        <xsl:call-template name="number-format">
                          <xsl:with-param name="number" select="@Amount"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                      <xsl:call-template name="currency">
                        <xsl:with-param name="CurrCode" select="@CurrCode"/>
                      </xsl:call-template>
                    </bgh:cell>
                </xsl:for-each>
            </bgh:row>
                     
            <bgh:row/>
        
        </xsl:if>
        
        
        <xsl:if test="../Charge[@PT='A' and 0 != number(@Amount) ]">
        
            <bgh:row>
                <bgh:cell>
                    <!-- PREPAID charges of customer -->
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','387')[@xml:lang=$lang]/@Des"/>
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="key('txt-index','286')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                </bgh:cell>
            </bgh:row>
            
            <xsl:if test="$pricing-prepaid = 'N' or not(0 = number(../Charge[@Id='830' and @PT='A']/@Amount) )  ">
              <bgh:row>
                <bgh:cell/>
                <bgh:cell>
                    <!-- customer net amount prepaid (multiple currency) -->  
                    <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','102')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                </bgh:cell>
                
                <xsl:for-each select="../Charge[@Id='830' and @PT='A']">
                    <bgh:cell>
                        <xsl:call-template name="number-format">
                          <xsl:with-param name="number" select="@Amount"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                  <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="@CurrCode"/>
                  </xsl:call-template>
                     </bgh:cell>
                </xsl:for-each>
              </bgh:row>
            </xsl:if>
            
            <xsl:if test="$pricing-prepaid = 'G' or not(0 = number(../Charge[@Id='930' and @PT='A']/@Amount) )  ">
              <bgh:row>
                <bgh:cell/>
                <bgh:cell> 
                    <!-- customer gross amount prepaid (multiple currency) -->
                    <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','104')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                </bgh:cell>
                
                <xsl:for-each select="../Charge[@Id='930' and @PT='A']">
                    <bgh:cell>
                        <xsl:call-template name="number-format">
                          <xsl:with-param name="number" select="@Amount"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                          <xsl:call-template name="currency">
                            <xsl:with-param name="CurrCode" select="@CurrCode"/>
                          </xsl:call-template>
                    </bgh:cell>
                </xsl:for-each>
              </bgh:row>
            </xsl:if>
            
            <xsl:if test="$pricing-prepaid = 'N' or not(0 = number(../Charge[@Id='835' and @PT='A']/@Amount) )  ">
              <bgh:row>
                <bgh:cell/>
                <bgh:cell>
                    <!-- customer net usage PREPAID (multiple currency) -->
                    <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','96')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                </bgh:cell>
                
                <xsl:for-each select="../Charge[@Id='835' and @PT='A']">
                    <bgh:cell>
                        <xsl:call-template name="number-format">
                          <xsl:with-param name="number" select="@Amount"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                          <xsl:call-template name="currency">
                            <xsl:with-param name="CurrCode" select="@CurrCode"/>
                          </xsl:call-template>
                    </bgh:cell>
                </xsl:for-each>
              </bgh:row>
            </xsl:if>
            
            <xsl:if test="$pricing-prepaid = 'G' or not(0 = number(../Charge[@Id='935' and @PT='A']/@Amount) )  ">
              <bgh:row>
                <bgh:cell/>
                <bgh:cell>
                    <!-- customer gross usage prepaid (multiple currency) -->
                    <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','99')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                </bgh:cell>
                
                <xsl:for-each select="../Charge[@Id='935' and @PT='A']">
                    <bgh:cell>
                        <xsl:call-template name="number-format">
                          <xsl:with-param name="number" select="@Amount"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                          <xsl:call-template name="currency">
                            <xsl:with-param name="CurrCode" select="@CurrCode"/>
                          </xsl:call-template>
                    </bgh:cell>
                </xsl:for-each>
              </bgh:row>
            </xsl:if>
            
            
            <!-- customer one-time charges net/gross prepaid (multiple currency) -->
            <xsl:if test="Charge[@Id='933' and @PT='A']">
                <bgh:row>
                    <bgh:cell/>
                    <bgh:cell>
                        <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','105')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                    </bgh:cell>
                    
                    <xsl:for-each select="../Charge[@Id='933' and @PT='A']">
                        <bgh:cell>
                            <xsl:call-template name="number-format">
                              <xsl:with-param name="number" select="@Amount"/>
                            </xsl:call-template>
                            <xsl:text> </xsl:text>
                              <xsl:call-template name="currency">
                                <xsl:with-param name="CurrCode" select="@CurrCode"/>
                              </xsl:call-template>
                        </bgh:cell>
                    </xsl:for-each>
                </bgh:row>
            </xsl:if>
                            
      
            <!-- customer recurring charges net/gross prepaid (multiple currency) -->
            <xsl:if test="Charge[@Id='934' and @PT='A']">
                <bgh:row>
                    <bgh:cell/>
                    <bgh:cell>
                        <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','106')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                    </bgh:cell>
                              
                    <xsl:for-each select="../Charge[@Id='934'and @PT='A']">
                        <bgh:cell>
                            <xsl:call-template name="number-format">
                              <xsl:with-param name="number" select="@Amount"/>
                            </xsl:call-template>
                            <xsl:text> </xsl:text>
                              <xsl:call-template name="currency">
                                <xsl:with-param name="CurrCode" select="@CurrCode"/>
                              </xsl:call-template>
                        </bgh:cell>
                    </xsl:for-each>
                </bgh:row>
            </xsl:if>
                            
                            
            <!-- customer occ charges net/gross prepaid (multiple currency) -->
            <xsl:if test="Charge[@Id='936' and @PT='A']">
                            
                <bgh:row>
                    <bgh:cell/>
                    <bgh:cell>
                        <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','108')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                    </bgh:cell>
                              
                    <xsl:for-each select="../Charge[@Id='936' and @PT='A']">
                        <bgh:cell>
                            <xsl:call-template name="number-format">
                              <xsl:with-param name="number" select="@Amount"/>
                            </xsl:call-template>
                            <xsl:text> </xsl:text>
                              <xsl:call-template name="currency">
                                <xsl:with-param name="CurrCode" select="@CurrCode"/>
                              </xsl:call-template>
                        </bgh:cell>
                    </xsl:for-each>
                </bgh:row>
            </xsl:if>
                          
            <!-- End prepaid charges of customer -->
                      
            <bgh:row/>
        
        </xsl:if>
        
        
        <!-- CONTRACT -->
        
        <bgh:row>
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','109')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
        </bgh:row>
        
        
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                <!-- contract number -->
                <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','388')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <xsl:value-of select="@Id"/>
            </bgh:cell>
        </bgh:row>
        
          
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                <!-- market -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','111')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="@MRKT"/>
                  <xsl:with-param name="Type"  select="'MRKT'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
            </bgh:cell>
        </bgh:row>
        
        
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                <!-- SIM number -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','112')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <xsl:value-of select="@SM"/>
            </bgh:cell>
        </bgh:row>

          
        <xsl:choose>
            <!-- DNs -->
            <xsl:when test="DN">
            
              <xsl:for-each select="DN">
                <!-- sort the directory numbers -->
                <xsl:sort select="." data-type="number" order="ascending"/>
                    <bgh:row>
                        <bgh:cell/>
                        <xsl:apply-templates select="."/>
                    </bgh:row>
              </xsl:for-each>
              
            </xsl:when>
            
            <!-- DN block(s) -->
            <xsl:when test="DNBlock">
            
              <xsl:for-each select="DNBlock">
                  <bgh:row/>
                  <xsl:apply-templates select="."/>
              </xsl:for-each>
              
            </xsl:when>
            
            <xsl:otherwise/>
        </xsl:choose><!-- End DN -->
      
        <bgh:row/>
      
        <!-- BOP Stuff-->
        <xsl:if test="@BOPInd='Y'">
                
            <bgh:row>
                <bgh:cell/>
                <bgh:cell>
                    <!-- BOP package -->
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','382')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                </bgh:cell>
                <bgh:cell>
                    <xsl:call-template name="LgnMap">
                      <xsl:with-param name="Mode"  select="'0'"/>
                      <xsl:with-param name="Index" select="BOPAlt/@BOPPack"/>
                      <xsl:with-param name="Type"  select="'BOP'"/>
                      <xsl:with-param name="Desc"  select="'1'"/>
                    </xsl:call-template>
                </bgh:cell>
            </bgh:row>
            
            <bgh:row>
                <bgh:cell/>
                <bgh:cell>
                    <!-- BOP purpose -->
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','383')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                </bgh:cell>
                <bgh:cell>
                    <xsl:call-template name="LgnMap">
                      <xsl:with-param name="Mode"  select="'0'"/>
                      <xsl:with-param name="Index" select="BOPAlt/@BOPPurp"/>
                      <xsl:with-param name="Type"  select="'BPURP'"/>
                      <xsl:with-param name="Desc"  select="'1'"/>
                    </xsl:call-template>
                </bgh:cell>
            </bgh:row>
            
            <bgh:row>
                <bgh:cell/>
                <bgh:cell>
                    <!-- BOP tariff model or service package -->
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
                </bgh:cell>
                
                <bgh:cell>
                    <xsl:call-template name="LgnMap">
                      <xsl:with-param name="Mode"  select="'0'"/>
                      <xsl:with-param name="Index" select="BOPAlt/AggSet/Att/@Id"/>
                      <xsl:with-param name="Type"  select="BOPAlt/AggSet/Att/@Ty"/>
                      <xsl:with-param name="Desc"  select="'1'"/>
                    </xsl:call-template>
                </bgh:cell>
            </bgh:row>
                
            <bgh:row>
                <bgh:cell/>
                <bgh:cell>
                  <!-- Bop Seq. No. -->
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','381')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </bgh:cell>
                
                <bgh:cell>
                  <xsl:value-of select="BOPAlt/@BOPSeqNo"/>
                </bgh:cell>
            </bgh:row>
            
            <!-- number of alternatives -->
            <xsl:variable name="co-alt" select="count(key('co-id',@Id))"/>
            <xsl:if test="$co-alt > 1 and @BOPInd='Y'">
            
                <bgh:row>
                    <bgh:cell/>
                    <bgh:cell>
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','384')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                    </bgh:cell>
                    
                    <bgh:cell>
                      <xsl:value-of select="count(key('co-id',@Id))"/>
                    </bgh:cell>
                </bgh:row>
            
            </xsl:if>   
            
            <bgh:row/>
            
        </xsl:if> <!-- End BOP stuff -->
 

        <!-- print contract(s) -->
        <xsl:apply-templates select="."/>

        <!-- End contract -->

    </xsl:for-each>   <!-- End for-each contract -->
  
        
      <!-- if no contracts are available, then print call details only -->
      <xsl:if test="not(Contract)">
        <xsl:call-template name="print-call-details-only">
          <xsl:with-param name="call-details" select="$call-details[parent::Document/@BillSeqNo = $billseqno]"/>
        </xsl:call-template>
      </xsl:if>

  </xsl:template>

  <!-- contract -->
  <xsl:template match="Contract">

    <xsl:variable name="co-id"     select="@Id"/>
    <xsl:variable name="bop-ind"   select="@BOPInd"/>
    <xsl:variable name="billed"    select="BOPAlt/@BILLED"/>
    <xsl:variable name="bop-id"    select="BOPAlt/AggSet/Att/@Id"/>
    <xsl:variable name="billseqno" select="../@BillSeqNo"/>
    
    <xsl:if test="Charge[@PT='P' and 0 != number(@Amount) ]">
    
        <!-- contract sums  (POSTPAID)  -->
        <bgh:row>
            <bgh:cell>
              <!-- Charges -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','329')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </bgh:cell>
        </bgh:row>
        
        <xsl:if test="$pricing = 'N' or not(0 = number(Charge[@Id='831' and @PT='P']/@Amount) ) ">
          <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                  <!-- contract net amount postpaid (multiple currency) -->
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','114')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                
            </bgh:cell>
    
            <xsl:for-each select="Charge[@Id='831' and @PT='P']">
                <bgh:cell>
                    <xsl:call-template name="number-format">
                      <xsl:with-param name="number" select="@Amount"/>
                    </xsl:call-template>
                    <xsl:text> </xsl:text>
                  <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="@CurrCode"/>
                  </xsl:call-template>
                </bgh:cell>
            </xsl:for-each>
                
          </bgh:row>
        </xsl:if>
        
        <xsl:if test="$pricing = 'G' or not(0 = number(Charge[@Id='931' and @PT='P']/@Amount) ) ">
          <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                <!-- contract gross amount postpaid (multiple currency) -->
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','115')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
    
            <xsl:for-each select="Charge[@Id='931' and @PT='P']">
                <bgh:cell>
                    <xsl:call-template name="number-format">
                      <xsl:with-param name="number" select="@Amount"/>
                    </xsl:call-template>
                    <xsl:text> </xsl:text>
                  <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="@CurrCode"/>
                  </xsl:call-template>
                </bgh:cell>
            </xsl:for-each>
                
          </bgh:row>
        </xsl:if>
        
        <bgh:row/>
    
    </xsl:if>
    

    <!-- show prepaid charges only if contract is not BOP related and if they are != 0 -->
    <xsl:if test="@BOPInd='N' and Charge[@PT='A' and 0 != number(@Amount) ]">
        
        <bgh:row>
            <bgh:cell>
                <!-- contract sums  (PREPAID)  -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','329')[@xml:lang=$lang]/@Des"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="key('txt-index','286')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
        </bgh:row>
        
        <xsl:if test="$pricing-prepaid = 'N' or not(0 = number(Charge[@Id='831' and @PT='A']/@Amount) ) ">
          <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                <!-- contract net amount prepaid (multiple currency) -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','102')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
    
            <xsl:for-each select="Charge[@Id='831' and @PT='A']">
                <bgh:cell>
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="@Amount"/>
                  </xsl:call-template>
                  <xsl:text> </xsl:text>
                  <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="@CurrCode"/>
                  </xsl:call-template>
                </bgh:cell>
            </xsl:for-each>
                
          </bgh:row>
        </xsl:if>
        
        <xsl:if test="$pricing-prepaid = 'G' or not(0 = number(Charge[@Id='931' and @PT='A']/@Amount) ) ">
          <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                <!-- contract gross amount prepaid (multiple currency) -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','104')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
    
                <xsl:for-each select="Charge[@Id='931' and @PT='A']">
                <bgh:cell>
                      <xsl:call-template name="number-format">
                        <xsl:with-param name="number" select="@Amount"/>
                      </xsl:call-template>
                      <xsl:text> </xsl:text>
                  <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="@CurrCode"/>
                  </xsl:call-template>
                </bgh:cell>
            </xsl:for-each>
                
          </bgh:row>
        </xsl:if>
        
        <bgh:row/>
        
    </xsl:if><!-- End prepaid charges -->

    
    <!-- charge types -->
    <xsl:for-each select="PerCTInfo">
        
    <bgh:row>
        <bgh:cell>
    
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
      
        </bgh:cell>
    </bgh:row>
        
        

    <!-- Charges on PerCTInfo-Level; amounts per contract and charge type  -->
    <xsl:if test="(($pricing = 'N' and @PT = 'P') or ($pricing-prepaid = 'N' and @PT = 'A') ) or not(0 = number(Charge[@Id='832']/@Amount) ) ">
      <bgh:row>
        <bgh:cell/>
        <bgh:cell>
        
            <!-- charge type net (multiple currency) -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','121')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        
        </bgh:cell>
        
        <xsl:for-each select="Charge[@Id='832']">
        
            <bgh:cell>

              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:call-template name="currency">
                <xsl:with-param name="CurrCode" select="@CurrCode"/>
              </xsl:call-template>
        
            </bgh:cell>
        
        </xsl:for-each>
        
      </bgh:row>
    </xsl:if>
    
    <xsl:if test="(($pricing = 'N' and @PT = 'P') or ($pricing-prepaid = 'N' and @PT = 'A') ) or not(0 = number(Charge[@Id='838']/@Amount) ) ">
      <bgh:row>
        <bgh:cell/>
        <bgh:cell>
        
            <!-- charge type net undiscounted (multiple currency) -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','122')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        
        </bgh:cell>
        
        <xsl:for-each select="Charge[@Id='838']">
        
            <bgh:cell>
        
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:call-template name="currency">
                <xsl:with-param name="CurrCode" select="@CurrCode"/>
              </xsl:call-template>
        
            </bgh:cell>
        
        </xsl:for-each>
        
      </bgh:row>
    </xsl:if>
    
        
    <!-- charge type net ATM (multiple currency) -->
    <!-- ATM is not available for BOP case and for Prepaid -->
    <xsl:if test="ancestor::Contract[@BOPInd='N'] and @PT='P'">
      <xsl:if test="$pricing = 'N' and not(0 = number(Charge[@Id='837']/@Amount) ) ">
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
            
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','137')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            
            </bgh:cell>
            
            <xsl:for-each select="Charge[@Id='837']">
            
                <bgh:cell>
           
                    <xsl:call-template name="number-format">
                      <xsl:with-param name="number" select="@Amount"/>
                    </xsl:call-template>
                    <xsl:text> </xsl:text>
                  <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="@CurrCode"/>
                  </xsl:call-template>
            
                </bgh:cell>
            
            </xsl:for-each>
            
        </bgh:row>
      </xsl:if>
    </xsl:if>
    
    <xsl:if test="(($pricing = 'G' and @PT = 'P') or ($pricing-prepaid = 'G' and @PT = 'A') ) or not(0 = number(Charge[@Id='932']/@Amount) ) ">
      <bgh:row>
        <bgh:cell/>
        <bgh:cell>
        
            <!-- charge type gross (multiple currency) -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','123')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        
        </bgh:cell>
        
        <xsl:for-each select="Charge[@Id='932']">
        
            <bgh:cell>
        
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:call-template name="currency">
                <xsl:with-param name="CurrCode" select="@CurrCode"/>
              </xsl:call-template>
        
            </bgh:cell>
        
        </xsl:for-each>
        
      </bgh:row>
    </xsl:if>
    
    <xsl:if test="(($pricing = 'G' and @PT = 'P') or ($pricing-prepaid = 'G' and @PT = 'A') ) or not(0 = number(Charge[@Id='938']/@Amount) ) ">
      <bgh:row>
        <bgh:cell/>
        <bgh:cell>
        
            <!-- charge type gross undiscounted (multiple currency) -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','124')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        
        </bgh:cell>
        
        <xsl:for-each select="Charge[@Id='938']">
        
            <bgh:cell>
        
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@Amount"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:call-template name="currency">
                <xsl:with-param name="CurrCode" select="@CurrCode"/>
              </xsl:call-template>
        
            </bgh:cell>
        
        </xsl:for-each>
        
      </bgh:row>
    </xsl:if>
          
    <!-- charge type gross ATM (multiple currency) -->
    <!-- ATM is not available for BOP case and for Prepaid -->
    <xsl:if test="ancestor::Contract[@BOPInd='N'] and @PT='P'">
      <xsl:if test="$pricing = 'G' and not(0 = number(Charge[@Id='937']/@Amount) ) ">
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
            
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','138')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            
            </bgh:cell>
            
            <xsl:for-each select="Charge[@Id='937']">
            
                <bgh:cell>
            
                    <xsl:call-template name="number-format">
                      <xsl:with-param name="number" select="@Amount"/>
                    </xsl:call-template>
                    <xsl:text> </xsl:text>
                  <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="@CurrCode"/>
                  </xsl:call-template>
            
                </bgh:cell>
            
            </xsl:for-each>
            
        </bgh:row>
      </xsl:if>
    </xsl:if>
    
    <bgh:row/>

    <!-- Sum Items -->
    <xsl:if test="SumItem">

    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
        
            <!-- quantity -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','125')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        
        </bgh:cell>
        
        <!-- active days -->
        <xsl:if test="@CT='A'">
        
            <bgh:cell>
            
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','126')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            
            </bgh:cell>
        
        </xsl:if>
        
        <bgh:cell>
        
            <!-- profile -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','139')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        
        </bgh:cell>
        <bgh:cell>
        
            <!-- service -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','140')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        
        </bgh:cell>
        <bgh:cell>
        
            <!-- package -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','141')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        
        </bgh:cell>
        <bgh:cell>
        
            <!-- tariff model -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','142')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        
        </bgh:cell>
        
        <!-- remark -->
        <xsl:if test="@CT='O' or @CT='P'">
        
            <bgh:cell>
            
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','288')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            
            </bgh:cell>
        
        </xsl:if>
        
        <!-- period info -->
        <xsl:if test="@CT='A'">
        
            <bgh:cell>
            
              <xsl:for-each select="$txt"><!-- Period, Status -->
                <xsl:value-of select="key('txt-index','145')[@xml:lang=$lang]/@Des"/>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="key('txt-index','290')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            
            </bgh:cell>
        
        </xsl:if>
        
        <!-- service parameter info -->
        <xsl:if test="@CT='S'">
        
            <bgh:cell>
            
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','289')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            
            </bgh:cell>
        
        </xsl:if>
        
        <!-- price/period -->
        <xsl:if test="@CT='S' or @CT='A'">
        
            <bgh:cell>
            
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','144')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            
            </bgh:cell>
            
        </xsl:if>
        
        <!-- content product info -->
        <xsl:choose>
          <xsl:when test="@CT='U'">
            <bgh:cell>
            
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
            </bgh:cell>
            
          </xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
        
        <bgh:cell>
        
            <!-- charge -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','143')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        
        </bgh:cell>
    </bgh:row>

      <xsl:for-each select="SumItem">
        <xsl:apply-templates select="."/>
      </xsl:for-each>

    <bgh:row/>
        
    </xsl:if><!-- End if SumItem -->
    </xsl:for-each><!-- End for-each PerCTInfo -->
        
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
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
        
            <!-- quantity -->
            <xsl:value-of select="@NumItems"/>
        
        </bgh:cell>

        <!-- active days -->
        <xsl:if test="../@CT='A'">
        
            <bgh:cell>
          
                <xsl:value-of select="@NumDays"/>
          
            </bgh:cell>
        
        </xsl:if>

      <!-- profile, service, package, tariff model -->
      <xsl:choose>
        <xsl:when test="AggSet">
          <xsl:apply-templates select="AggSet" mode="sum-item"/>
        </xsl:when>
        <xsl:otherwise>
        
            <bgh:cell>-</bgh:cell>
            <bgh:cell>-</bgh:cell>
            <bgh:cell>-</bgh:cell>
            <bgh:cell>-</bgh:cell>

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
        
        <bgh:cell>
            <xsl:apply-templates select="Txt"/>
        </bgh:cell>
        
      </xsl:if>
      
      <!-- service status -->
      <xsl:if test="../@CT='A'">
        
        <bgh:cell>
            <xsl:for-each select="SrvStatus">
              <xsl:apply-templates select="."/>
            </xsl:for-each>
        </bgh:cell>
        
      </xsl:if>
      
      
      <!-- service parameter -->
      <xsl:if test="../@CT='S'">
        
        <bgh:cell>
            <xsl:apply-templates select="SrvParams"/>
        </bgh:cell>
        
      </xsl:if>
      
      <!-- price -->
      <xsl:if test="../@CT='A' or ../@CT='S'">
        
        <bgh:cell>
            <xsl:if test="Price">
              <xsl:apply-templates select="Price"/>
            </xsl:if>
        </bgh:cell>
        
      </xsl:if>
      
      
    <!-- charge -->
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
              <bgh:cell>
                  <xsl:value-of select="$number-format"/>
                  <xsl:text> </xsl:text>
              <xsl:call-template name="currency">
                <xsl:with-param name="CurrCode" select="@CurrCode"/>
              </xsl:call-template>
              </bgh:cell>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="following-sibling::Charge[1]/@Id!='125'">
                  <bgh:cell>
                      <xsl:value-of select="$number-format"/>
                      <xsl:text> </xsl:text>
                      <xsl:call-template name="currency">
                        <xsl:with-param name="CurrCode" select="@CurrCode"/>
                      </xsl:call-template>
                  </bgh:cell>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="./@CurrCode!=following-sibling::Charge[1]/@CurrCode">
                    <bgh:cell>
                        <xsl:value-of select="$number-format"/>
                        <xsl:text> </xsl:text>
                          <xsl:call-template name="currency">
                            <xsl:with-param name="CurrCode" select="@CurrCode"/>
                          </xsl:call-template>
                    </bgh:cell>
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
              <bgh:cell>
                  <xsl:value-of select="$number-format"/>
                  <xsl:text> </xsl:text>
                      <xsl:call-template name="currency">
                        <xsl:with-param name="CurrCode" select="@CurrCode"/>
                      </xsl:call-template>
              </bgh:cell>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="following-sibling::Charge[1]/@Id!='203'">
                  <bgh:cell>  
                      <xsl:value-of select="$number-format"/>
                      <xsl:text> </xsl:text>
                      <xsl:call-template name="currency">
                        <xsl:with-param name="CurrCode" select="@CurrCode"/>
                      </xsl:call-template>
                  </bgh:cell>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="./@CurrCode!=following-sibling::Charge[1]/@CurrCode">
                    <bgh:cell>
                        <xsl:value-of select="$number-format"/>
                        <xsl:text> </xsl:text>
                          <xsl:call-template name="currency">
                            <xsl:with-param name="CurrCode" select="@CurrCode"/>
                          </xsl:call-template>
                    </bgh:cell>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
          

        </xsl:if>
        
        
    </xsl:for-each>
        
    </bgh:row>

    <!-- Promotions -->
    <xsl:if test="PromoItem">
      <xsl:choose>
        <!-- promotions for usage -->
        <xsl:when test="../@CT='U'">
        

          <xsl:for-each select="PromoItem">
            
              <xsl:if test="position()='1'">
              
                <bgh:row>
                  <bgh:cell/>
                  <bgh:cell>
                    <xsl:for-each select="$txt">
                      <!-- Discount -->
                      <xsl:value-of select="key('txt-index','309')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </bgh:cell>
                </bgh:row>
                
            <bgh:row>
                <bgh:cell/>
                <bgh:cell/>
          
            <xsl:for-each select="$txt">
              
                <bgh:cell>
                  <!-- Mechanism -->
                  <xsl:value-of select="key('txt-index','318')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- Package -->
                  <xsl:value-of select="key('txt-index','313')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- Model -->
                  <xsl:value-of select="key('txt-index','314')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- Element -->
                  <xsl:value-of select="key('txt-index','315')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- Version -->
                  <xsl:value-of select="key('txt-index','316')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- Discount -->
                  <xsl:value-of select="key('txt-index','148')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
            </xsl:for-each>
            
            </bgh:row>
                
              </xsl:if>
              
              <!-- Print actual promo item -->
              <xsl:apply-templates select="." mode="sum-item-usage"/>
            
          </xsl:for-each>
        </xsl:when>
        
        <!-- promotions for other -->
        <xsl:when test="../@CT='O' or ../@CT='P' or name(..)='CustRef'">
          
          
          <xsl:for-each select="PromoItem">

              <xsl:if test="position()='1'">
                <bgh:row>
                    <bgh:cell/>
                    <bgh:cell>
                        <xsl:for-each select="$txt"><!-- Discount -->
                          <xsl:value-of select="key('txt-index','309')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                    </bgh:cell>
                </bgh:row>
                
            <bgh:row>
                <bgh:cell/>
                <bgh:cell/>
          
            <xsl:for-each select="$txt">
              
                <bgh:cell>
                  <!-- Mechanism -->
                  <xsl:value-of select="key('txt-index','318')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- Package -->
                  <xsl:value-of select="key('txt-index','313')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- Model -->
                  <xsl:value-of select="key('txt-index','314')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- Element -->
                  <xsl:value-of select="key('txt-index','315')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- Version -->
                  <xsl:value-of select="key('txt-index','316')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- Discount -->
                  <xsl:value-of select="key('txt-index','148')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
              
            </xsl:for-each>
            
            </bgh:row>
                
              </xsl:if>
              <xsl:apply-templates select="." mode="sum-item-occ"/>
            
          </xsl:for-each>
        </xsl:when>
        
        <!-- promotions for subscription -->
        <xsl:when test="../@CT='S'">
          
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
                      <xsl:value-of select="key('txt-index','318')[@xml:lang=$lang]/@Des"/>
                    </bgh:cell>
                    <bgh:cell>
                      <xsl:value-of select="key('txt-index','313')[@xml:lang=$lang]/@Des"/>
                    </bgh:cell>
                    <bgh:cell>
                      <xsl:value-of select="key('txt-index','314')[@xml:lang=$lang]/@Des"/>
                    </bgh:cell>
                    <bgh:cell>
                      <xsl:value-of select="key('txt-index','315')[@xml:lang=$lang]/@Des"/>
                    </bgh:cell>
                    <bgh:cell>
                      <xsl:value-of select="key('txt-index','316')[@xml:lang=$lang]/@Des"/>
                    </bgh:cell>
                    <bgh:cell>
                      <xsl:value-of select="key('txt-index','148')[@xml:lang=$lang]/@Des"/>
                    </bgh:cell>
                  
                </xsl:for-each>
                
              </bgh:row>
                
              </xsl:if>
              <xsl:apply-templates select="." mode="sum-item-subscription"/>
            
          </xsl:for-each>
        </xsl:when>
        <!-- promotions for access -->
        <xsl:when test="../@CT='A'">
          
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
                      <xsl:value-of select="key('txt-index','318')[@xml:lang=$lang]/@Des"/>
                    </bgh:cell>
                    <bgh:cell>
                      <xsl:value-of select="key('txt-index','313')[@xml:lang=$lang]/@Des"/>
                    </bgh:cell>
                    <bgh:cell>
                      <xsl:value-of select="key('txt-index','314')[@xml:lang=$lang]/@Des"/>
                    </bgh:cell>
                    <bgh:cell>
                      <xsl:value-of select="key('txt-index','315')[@xml:lang=$lang]/@Des"/>
                    </bgh:cell>
                    <bgh:cell>
                      <xsl:value-of select="key('txt-index','316')[@xml:lang=$lang]/@Des"/>
                    </bgh:cell>
                    <bgh:cell>
                      <xsl:value-of select="key('txt-index','148')[@xml:lang=$lang]/@Des"/>
                    </bgh:cell>
                  
                </xsl:for-each>
                
              </bgh:row>
            
              </xsl:if>
            
              <xsl:apply-templates select="." mode="sum-item-access"/>
            
          </xsl:for-each>
        </xsl:when>
      </xsl:choose>
    </xsl:if>

  </xsl:template>
  

  <!-- free unit account info -->
  <xsl:template match="FUAccInfo">
  
    <bgh:row>
        <bgh:cell/>
        <bgh:cell/>
        <!-- account info -->
        <xsl:apply-templates select="FUAcc"/>
        <!-- period -->
        <bgh:cell>            
            <xsl:apply-templates select="Date[@Type='START']"/>
            <xsl:text> - </xsl:text>
            <xsl:apply-templates select="Date[@Type='END']"/>
        </bgh:cell>
        <!-- carry over expiration date -->
        <bgh:cell>            
            <xsl:apply-templates select="Date[@Type='END_FU_CO']"/>
        </bgh:cell>
        <bgh:cell>
            <!-- markup fee -->
            <xsl:if test="Charge[@Id='526']">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="Charge[@Id='526']/@Amount"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
                  <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="Charge[@Id='526']/@CurrCode"/>
                  </xsl:call-template>
            </xsl:if>
        </bgh:cell>        
        <bgh:cell>
            <!-- currently reduced -->
            <xsl:if test="Charge[@Id='54']">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="Charge[@Id='54']/@Amount"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
                  <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="Charge[@Id='54']/@CurrCode"/>
                  </xsl:call-template>
            </xsl:if>
        </bgh:cell>
        <bgh:cell>
            <!-- totally reduced -->
            <xsl:if test="Charge[@Id='55']">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="Charge[@Id='55']/@Amount"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
                  <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="Charge[@Id='55']/@CurrCode"/>
                  </xsl:call-template>
            </xsl:if>
        </bgh:cell>        

        <!-- Evaluated/granted free units -->
        <xsl:choose>
          
          <!-- Eval UoM is technical -->
          <xsl:when test="FUNum[@UME]">
            <xsl:apply-templates select="FUNum[@UME]"/>
          </xsl:when>
          
          <!-- Eval UoM is monetary -->
          <xsl:otherwise>
            <bgh:cell>
                  <!-- original FU amount  -->
                  <xsl:if test="Charge[@Id='56']">
                    <xsl:call-template name="number-format">
                      <xsl:with-param name="number" select="Charge[@Id='56']/@Amount"/>
                    </xsl:call-template>
                    <xsl:text> </xsl:text>
                      <xsl:call-template name="currency">
                        <xsl:with-param name="CurrCode" select="Charge[@Id='56']/@CurrCode"/>
                      </xsl:call-template>
                  </xsl:if>      
            </bgh:cell>
            <bgh:cell>
                  <!-- granted FU amount net part -->
                  <xsl:if test="Charge[@Id='57']">
                    <xsl:call-template name="number-format">
                      <xsl:with-param name="number" select="Charge[@Id='57']/@Amount"/>
                    </xsl:call-template>
                    <xsl:text> </xsl:text>
                      <xsl:call-template name="currency">
                        <xsl:with-param name="CurrCode" select="Charge[@Id='57']/@CurrCode"/>
                      </xsl:call-template>
                  </xsl:if>  
            </bgh:cell>
            <bgh:cell>
                  <!-- carry over FU amount -->
                  <xsl:if test="Charge[@Id='58']">
                    <xsl:call-template name="number-format">
                      <xsl:with-param name="number" select="Charge[@Id='58']/@Amount"/>
                    </xsl:call-template>
                    <xsl:text> </xsl:text>
                      <xsl:call-template name="currency">
                        <xsl:with-param name="CurrCode" select="Charge[@Id='58']/@CurrCode"/>
                      </xsl:call-template>
                  </xsl:if>  
            </bgh:cell>
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
            
            
                <bgh:cell>
                      <!-- granted FU amount net part -->
                      <xsl:if test="Charge[@Id='527']">
                        <xsl:call-template name="number-format">
                          <xsl:with-param name="number" select="Charge[@Id='527']/@Amount"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                          <xsl:call-template name="currency">
                            <xsl:with-param name="CurrCode" select="Charge[@Id='527']/@CurrCode"/>
                          </xsl:call-template>
                      </xsl:if>  
                </bgh:cell>
                <bgh:cell>
                      <!-- carry over FU amount -->
                      <xsl:if test="Charge[@Id='528']">
                        <xsl:call-template name="number-format">
                          <xsl:with-param name="number" select="Charge[@Id='528']/@Amount"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                          <xsl:call-template name="currency">
                            <xsl:with-param name="CurrCode" select="Charge[@Id='528']/@CurrCode"/>
                          </xsl:call-template>
                      </xsl:if>  
                </bgh:cell>
                
            </xsl:when>
            
            <!-- Normal free units -->
            <xsl:otherwise>
            
                <bgh:cell/>
                <bgh:cell/>
                
            </xsl:otherwise>
            
          </xsl:choose>
          
        </xsl:otherwise>
    </xsl:choose>
        
    </bgh:row>

  </xsl:template>

  
  <!-- account -->
  <xsl:template match="FUAcc">
    
    <!-- account -->
    <bgh:cell>
        <xsl:value-of select="@Id"/>
        <xsl:text> / </xsl:text>
        <xsl:value-of select="@HistId"/>
    </bgh:cell>
    <!-- account type -->
    <bgh:cell>
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
    </bgh:cell>
    <!-- account package / element / version -->
    <bgh:cell>
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="@FUP"/>
        <xsl:with-param name="Type"  select="'FUP'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
      <xsl:text> / </xsl:text>
      <xsl:value-of select="@FUE"/>
      <xsl:text> / </xsl:text>
      <xsl:value-of select="@FUEV"/>
    </bgh:cell>
    <!-- charge plan -->
    <bgh:cell>
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="@ChPlan"/>
        <xsl:with-param name="Type"  select="'CPD'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
    </bgh:cell>
    
  </xsl:template>

  <!-- granted free units -->
  <xsl:template match="FUNum[@UME]">
  
    <bgh:cell>
        <!-- original -->
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
    </bgh:cell>
    <bgh:cell>
        <!-- granted -->
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
    </bgh:cell>
    <bgh:cell>
        <!-- carry over -->
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
    </bgh:cell>
    
  </xsl:template>
  
  
  <!-- applied free units -->
  <xsl:template match="FUNum[@UMA]">
    
    <bgh:cell>
        <!-- currently used -->
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
    </bgh:cell>
    <bgh:cell>
        <!-- totally used -->
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
    </bgh:cell>
    
  </xsl:template>

  
  <!-- Balance Snapshot -->
  <xsl:template match="BalSsh">
  
    <bgh:row>
        <bgh:cell/>
        <bgh:cell/>
        <bgh:cell>
            <!-- snapshot date -->
            <xsl:apply-templates select="Date[@Type='BAL_REF']"/>
        </bgh:cell>
    
        <xsl:apply-templates select="Bal"/>
        
        <xsl:apply-templates select="BalVols"/>
        
    </bgh:row>
    
  </xsl:template>

  
  <!-- Balance Adjustment -->
  <xsl:template match="BalAd">
        
    <bgh:row>
        <bgh:cell/>
        <bgh:cell/>
        
        <bgh:cell>
            <!-- date -->
            <xsl:apply-templates select="Date[@Type='BAL_REF']"/>
        </bgh:cell>
    
        <bgh:cell>
            <!-- type -->
            <xsl:call-template name="DataDomainLgnMap">
              <xsl:with-param name="Index"     select="@Type"/>
              <xsl:with-param name="Type"      select="'DD'"/>
              <xsl:with-param name="Desc"      select="'1'"/>
              <xsl:with-param name="ClassId"   select="'BIR_PURPOSE_CLASS'"/>
            </xsl:call-template>
        </bgh:cell>
        <bgh:cell>
            <!-- period -->        
            <xsl:apply-templates select="Date[@Type='VALID_FROM']"/>
            <xsl:text> - </xsl:text>
            <xsl:apply-templates select="Date[@Type='VALID_TO']"/>
        </bgh:cell>
        <bgh:cell>        
            <!-- adjustment -->        
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="@AdjAmt"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>
            <xsl:value-of select="Bal/@CurrCode"/>
        </bgh:cell>
        <bgh:cell>
            <!-- reason -->
            <xsl:if test="@Reason">
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="@Reason"/>
                <xsl:with-param name="Type"  select="'AR'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
            </xsl:if>
        </bgh:cell>
    
        <xsl:apply-templates select="Bal"/>
        
        <xsl:apply-templates select="BalVols"/>
    
    </bgh:row>
    
  </xsl:template>

  
  <!-- free unit discount info   -->
  <xsl:template match="FUDiscountInfo">
    <!-- monetary discount info -->
    <xsl:if test="Charge">
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                <!-- Package -->
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="@FUP"/>
                  <xsl:with-param name="Type"  select="'FUP'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
            </bgh:cell>
            
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
    </xsl:if>
    <!-- non monetary discount info -->
    <xsl:for-each select="DiscountValue">
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                <!-- Package -->
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="../@FUP"/>
                  <xsl:with-param name="Type"  select="'FUP'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
            </bgh:cell>
            
            <!-- non monetary discount info -->
            <xsl:apply-templates select="."/>
        
        </bgh:row>
    </xsl:for-each>

  </xsl:template>

  <!-- cost control service / CS discount info -->
  <xsl:template match="CCHDiscountInfo|CSDiscountInfo">
    <!-- monetary discount info -->
    <xsl:if test="Charge">
      
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                <!-- Package -->
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="@SN"/>
                  <xsl:with-param name="Type"  select="'SN'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
            </bgh:cell>
        
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
      
    </xsl:if>
    <!-- non monetary discount info -->
    <xsl:for-each select="DiscountValue">
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                <!-- Package -->
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="../@SN"/>
                  <xsl:with-param name="Type"  select="'SN'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
            </bgh:cell>
        
                <!-- non monetary discount info -->
                <xsl:apply-templates select="."/>

        </bgh:row>
    </xsl:for-each>

  </xsl:template>
  

  <!-- granted credits to prepaid balances info -->
  <xsl:template match="PromoCreditPerBal">
    
    <bgh:row>
        <bgh:cell/>

        <!-- balance info -->
        <xsl:apply-templates select="Bal" mode="credit-per-bal"/>
          
        <bgh:cell>
            <!-- total credit amount for Bal -->
              <xsl:for-each select="Charge">
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
    
  </xsl:template>

  <!-- granted credits to prepaid balances info -->
  <xsl:template match="PromoCreditPerBal" mode="promo">
  
    <!-- balance info -->
    <xsl:apply-templates select="Bal" mode="promo"/>
      
    <bgh:cell>
      <!-- total credit amount for Bal -->
      <xsl:for-each select="Charge">
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
      
  </xsl:template>

  <!--  bundle info -->
  <xsl:template name="BundleInfo">

    <xsl:param name="co-id"/>
    <xsl:param name="bopind"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>

    <bgh:row>
        <bgh:cell/>
        <bgh:cell/>
        <bgh:cell>
          <!-- bundle name -->
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="@SN"/>
            <xsl:with-param name="Type"  select="'SN'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
        </bgh:cell>
        <bgh:cell>
          <!-- purchase date -->
          <xsl:call-template name="date-format">
            <xsl:with-param name="date" select="Date[@Type='PURCHASE']/@Date"/>
          </xsl:call-template>
        </bgh:cell>
        <bgh:cell>
          <!-- consumption period -->
          <xsl:call-template name="date-format">
            <xsl:with-param name="date" select="Date[@Type='START']/@Date"/>
          </xsl:call-template>
          <xsl:text> - </xsl:text>
          <xsl:call-template name="date-format">
            <xsl:with-param name="date" select="Date[@Type='END']/@Date"/>
          </xsl:call-template>
        </bgh:cell>
        <bgh:cell>
          <!-- bundle products -->
          <xsl:for-each select="BundledProd">
            <xsl:apply-templates select="."/>
            <xsl:if test="position()!=last()">, </xsl:if>
          </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
            <!-- bundle price -->
            <xsl:call-template name="print-call-details-bundle-purchase-price">
              <xsl:with-param name="co-id"        select="$co-id"/>
              <xsl:with-param name="service"      select="@SN"/>
              <xsl:with-param name="sequence-no"  select="@SeqNo"/>
              <xsl:with-param name="call-details" select="$call-details"/>
              <xsl:with-param name="bopind"       select="$bopind"/>
              <xsl:with-param name="bopseqno"     select="$bopseqno"/>
              <xsl:with-param name="boptype"      select="$boptype"/>
            </xsl:call-template>
        </bgh:cell>
    </bgh:row>

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
