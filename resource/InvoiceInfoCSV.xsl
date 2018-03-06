<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2011 Ericsson Telekommunikation GmbH & Co. KG
                     Solution Area Billing & Customer Care

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

  File:    InvoiceInfoFO.xsl

  Owners:  Matthias Fehrenbacher
           Natalie Kather

  @(#) ABSTRACT : XML -> CSV stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms invoice info documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/InvoiceInfoCSV.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" xmlns:bgh="http://www.lhsgroup.com/BSCS/BGH" exclude-result-prefixes="xsl cur bgh">

  <!-- invoice info -->
  <xsl:template match="InvoiceInfo">

    <!-- currency conversion infos -->
    <xsl:if test="ConvRate">

        <bgh:row>
            <bgh:cell>
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','21')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </bgh:cell>
        </bgh:row>
          
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                  <!-- exchange rate -->
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','22')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                  <!-- conversion details -->
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','24')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                  <!-- conversion date -->
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','25')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                  <!-- currency type -->
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','26')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                  <!-- currency -->
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','27')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                  <!-- target currency type -->
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','527')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                  <!-- target currency -->
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','528')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
        </bgh:row>  
          
            <!-- conversion rates and currency infos for primary and
               secondary (if applicable) invoice currency -->
            <xsl:for-each select="ConvRate">

                <xsl:apply-templates select="."/>
              
            </xsl:for-each>
          
        <bgh:row/>
        
    </xsl:if>

  </xsl:template>

  <!-- conversion info -->
  <xsl:template match="ConvRate">
  
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
            <!-- conversion rate -->
            <xsl:value-of select="@Rate"/>
        </bgh:cell>
        <bgh:cell>
            <!-- conversion details -->
            <xsl:choose>
              <xsl:when test="@Details">
                <xsl:value-of select="@Details"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>-</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
        </bgh:cell>
        <bgh:cell>
            <!-- conversion date -->
            <xsl:apply-templates select="Date"/>
        </bgh:cell>
        <bgh:cell>
            <!-- source currency type -->
            <xsl:call-template name="currency-type">
              <xsl:with-param name="type"  select="Currency[1]/@Type"/>
            </xsl:call-template>
        </bgh:cell>
        <bgh:cell>
            <!-- source currency -->
              <xsl:call-template name="currency">
                <xsl:with-param name="CurrCode" select="Currency[1]/@CurrCode"/>
              </xsl:call-template>
            <xsl:text> - </xsl:text>
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="Currency[1]/@CurrCode"/>
              <xsl:with-param name="Type"  select="'CURR'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
        </bgh:cell>
        <bgh:cell>
            <!-- destination currency type -->
            <xsl:call-template name="currency-type">
              <xsl:with-param name="type"  select="Currency[2]/@Type"/>
            </xsl:call-template>
        </bgh:cell>
        <bgh:cell>
            <!-- destination currency -->
              <xsl:call-template name="currency">
                <xsl:with-param name="CurrCode" select="Currency[2]/@CurrCode"/>
              </xsl:call-template>
            <xsl:text> - </xsl:text>
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="Currency[2]/@CurrCode"/>
              <xsl:with-param name="Type"  select="'CURR'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
        </bgh:cell>
    </bgh:row>
    
  </xsl:template>

  <!-- currency type -->
  <xsl:template name="currency-type">

    <xsl:param name="type"/>
      
        <xsl:choose>
          <!-- home currency -->
          <xsl:when test="$type='1'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','29')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <!-- invoice currency -->
          <xsl:when test="$type='2'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','30')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <!-- secondary invoice currency -->
          <xsl:when test="$type='3'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','31')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <!-- transaction currency -->
          <xsl:when test="$type='4'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','32')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      
  </xsl:template>


  <!-- bonus points statistic -->
  <xsl:template name="BPStat">

    <xsl:param name="bpstat"/>
    
    <bgh:row>
        <bgh:cell>
            <xsl:for-each select="$txt"><!-- Bonus Points Statistic -->
              <xsl:value-of select="key('txt-index','34')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        </bgh:cell>
    </bgh:row>

    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
            <!-- granted bonus points -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','35')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
            <xsl:if test="$bpstat/@New">
              <xsl:call-template name="volume-format">
                <xsl:with-param name="volume" select="$bpstat/@New"/>
              </xsl:call-template>
            </xsl:if>
        </bgh:cell>
    </bgh:row>
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
            <!-- actual bonus points -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','36')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
            <xsl:if test="$bpstat/@Sum">
              <xsl:call-template name="volume-format">
                <xsl:with-param name="volume" select="$bpstat/@Sum"/>
              </xsl:call-template>
            </xsl:if>
        </bgh:cell>
    </bgh:row>
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
            <!-- maximum bonus points -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','37')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
            <xsl:if test="$bpstat/@Max">
              <xsl:call-template name="volume-format">
                <xsl:with-param name="volume" select="$bpstat/@Max"/>
              </xsl:call-template>
            </xsl:if>
        </bgh:cell>
    </bgh:row>
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
            <!-- expired bonus points -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','38')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
            <xsl:if test="$bpstat/@Exp">
              <xsl:call-template name="volume-format">
                <xsl:with-param name="volume" select="$bpstat/@Exp"/>
              </xsl:call-template>
            </xsl:if>
        </bgh:cell>
    </bgh:row>
            
    <bgh:row/>

  </xsl:template>
  

  <!-- promo details -->
  <xsl:template match="PromoDetails">

    <xsl:if test="PromoResult">
        <bgh:row>
            <bgh:cell>
                  <xsl:for-each select="$txt"><!-- Promotion Details -->
                    <xsl:value-of select="key('txt-index','339')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
        </bgh:row>
    </xsl:if>

    <xsl:for-each select="PromoResult">
      <xsl:sort select="./PromoElemRef/CustId" data-type="text" order="ascending"/>
      <xsl:apply-templates select="."/>
    </xsl:for-each>

  </xsl:template>



  <!-- promo result -->
  <xsl:template match="PromoResult">

    <xsl:if test="BOPAlt"><!-- TODO -->
      <xsl:apply-templates select="BOPAlt" mode="promo"/>
    </xsl:if>
    
    <xsl:apply-templates select="PromoElemRef" mode="sum"/>
    
    <xsl:if test="PromoEvalResult">
      
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                  <xsl:for-each select="$txt"><!-- Evaluation -->
                    <xsl:value-of select="key('txt-index','317')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
        </bgh:row>
        

        <bgh:row>
            <bgh:cell/>
            <bgh:cell/>
            <bgh:cell>
                  <xsl:for-each select="$txt"><!-- Version -->
                    <xsl:value-of select="key('txt-index','318')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                  <xsl:for-each select="$txt"><!-- Finished -->
                    <xsl:value-of select="key('txt-index','320')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                  <xsl:for-each select="$txt"><!-- Result -->
                    <xsl:value-of select="key('txt-index','319')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
        </bgh:row>
        
        <xsl:for-each select="PromoEvalResult">
            <xsl:apply-templates select="."/>
        </xsl:for-each>
            
        <bgh:row/>
          
    </xsl:if>
    
    
    <xsl:if test="PromoApplResult">
      <xsl:for-each select="PromoApplResult">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:if>

  </xsl:template>

  <!-- promo evaluation -->
  <xsl:template match="PromoEvalResult">
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell/>
        <bgh:cell>
            <!-- evaluation mechanism -->
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode" select="'0'"/>
              <xsl:with-param name="Index" select="@MechId"/>
              <xsl:with-param name="Type" select="'PMC'"/>
              <xsl:with-param name="Desc" select="'1'"/>
            </xsl:call-template>
        </bgh:cell>
        <bgh:cell>
            <!-- evaluation status -->
            <xsl:choose>
              <xsl:when test="@Finished='YES'">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','391')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','392')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
        </bgh:cell>
        <bgh:cell>
            <!-- evaluation result -->
            <xsl:choose>
              <xsl:when test="@CurrCode">
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="@Result"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                  <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="@CurrCode"/>
                  </xsl:call-template>
              </xsl:when>
              <xsl:when test="@UoM">
                <xsl:call-template name="number-unit-format">
                  <xsl:with-param name="number" select="@Result"/>
                  <xsl:with-param name="unit" select="@UoM"/>
                </xsl:call-template>
              </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="@Result"/>
	      </xsl:otherwise>
            </xsl:choose>
        </bgh:cell>
    </bgh:row>
    
  </xsl:template>
  

  <!-- promo application result -->
  <xsl:template match="PromoApplResult">

    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
            <xsl:for-each select="$txt"><!-- Application -->
              <xsl:value-of select="key('txt-index','321')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        </bgh:cell>
    </bgh:row>
      
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell/>
        <bgh:cell>
            <!-- application mechanism -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','322')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode" select="'0'"/>
              <xsl:with-param name="Index" select="@MechId"/>
              <xsl:with-param name="Type" select="'PMC'"/>
              <xsl:with-param name="Desc" select="'1'"/>
            </xsl:call-template>
        </bgh:cell>
    </bgh:row>
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell/>
        <bgh:cell>
            <!-- application status -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','325')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
            <xsl:choose>
              <xsl:when test="@Finished='YES'">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','391')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','392')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
        </bgh:cell>
    </bgh:row>
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell/>
        <bgh:cell>
            <!-- application type -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','324')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
            <xsl:choose>
              <xsl:when test="@ApplType='ABS'">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','389')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','390')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
        </bgh:cell>
    </bgh:row>
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell/>
        <bgh:cell>
            <!-- application value (charge, bonus points, etc. )-->
            <xsl:choose>
              <xsl:when test="Charge">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','393')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </xsl:when>
              <xsl:when test="BonPnt">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','39')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','323')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
        </bgh:cell>
        <bgh:cell>
            <xsl:value-of select="@ApplValue"/>
            <xsl:if test="@ApplType='ABS' and Charge">
              <xsl:text> </xsl:text>
              <xsl:call-template name="currency">
                <xsl:with-param name="CurrCode" select="Charge/@CurrCode"/>
              </xsl:call-template>
            </xsl:if>
        </bgh:cell>
    </bgh:row>
    
    
    <!-- it is not necessary to show the bonus points or applied amounts here
         because they are given in the application value attribute -->
    <!-- applied amount -->
    <xsl:if test="Charge">
            
        <bgh:row>
            <bgh:cell/>
            <bgh:cell/>
            <bgh:cell>
                  <xsl:for-each select="$txt"><!-- Used Value -->
                    <xsl:value-of select="key('txt-index','394')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <xsl:apply-templates select="Charge"/>
                <xsl:if test="position()!=last()"> / </xsl:if>
            </bgh:cell>
        </bgh:row>
              
    </xsl:if>
    
      <!-- bonus points -->
      <!-- <xsl:if test="BonPnt">
        <xsl:apply-templates select="BonPnt"/>
      </xsl:if> -->
        
      
    <!-- rewards -->
    <xsl:if test="Reward">
    
        <bgh:row>
            <bgh:cell/>
            <bgh:cell/>
            <bgh:cell>
                  <xsl:for-each select="$txt"><!-- Rewards -->
                    <xsl:value-of select="key('txt-index','42')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
        </bgh:row>
        
        <bgh:row>
            <bgh:cell/>
            <bgh:cell/>
            <bgh:cell/>

            <bgh:cell>
                  <xsl:for-each select="$txt"><!-- Bonus Points -->
                    <xsl:value-of select="key('txt-index','43')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                  <xsl:for-each select="$txt"><!-- Entity -->
                    <xsl:value-of select="key('txt-index','46')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                  <xsl:for-each select="$txt"><!-- Action -->
                    <xsl:value-of select="key('txt-index','47')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                  <xsl:for-each select="$txt"><!-- old - new Value -->
                    <xsl:value-of select="key('txt-index','48')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                  <xsl:for-each select="$txt"><!-- Advertisement -->
                    <xsl:value-of select="key('txt-index','49')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                  <xsl:for-each select="$txt"><!-- Amount -->
                    <xsl:value-of select="key('txt-index','50')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
        </bgh:row>
          
        <xsl:for-each select="Reward">
            <xsl:apply-templates select="."/>
        </xsl:for-each>
        
    </xsl:if>

    <!--  granted credit to prepaid balance  -->
    <xsl:if test="PromoCreditsPerCo">
      
        <bgh:row>
            <bgh:cell/>
            <bgh:cell/>
            <bgh:cell>
                  <xsl:for-each select="$txt"><!-- Credits Granted to the Prepaid Balance -->
                    <xsl:value-of select="key('txt-index','430')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
        </bgh:row>
        
            
        <xsl:for-each select="$txt">
          <bgh:row>
            <bgh:cell/>
            <bgh:cell/>
            <bgh:cell/>
            <bgh:cell>
                <!-- Contract No. -->
                <xsl:value-of select="key('txt-index','388')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                <!-- Service -->
                <xsl:value-of select="key('txt-index','249')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                <!-- Profile -->
                <xsl:value-of select="key('txt-index','139')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                <!-- Pricing -->
                <xsl:value-of select="key('txt-index','253')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                <!-- Credit -->
                <xsl:value-of select="key('txt-index','431')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
          </bgh:row>
                
        </xsl:for-each>
            
          
        <xsl:for-each select="PromoCreditsPerCo">
            <xsl:for-each select="PromoCreditPerBal">
            
                <bgh:row>
                    <bgh:cell/>
                    <bgh:cell/>
                    <bgh:cell/>
                    <bgh:cell>
                        <xsl:value-of select="../@CoId"/>
                    </bgh:cell>
                    
                    <xsl:apply-templates select="." mode="promo"/>
                    
                </bgh:row>
                
              </xsl:for-each>
            </xsl:for-each>
          
    </xsl:if>
    
    <bgh:row/>

  </xsl:template>
  
  

  <!-- rewards -->
  <xsl:template match="Reward">
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell/>
        <bgh:cell/>
    
    <xsl:choose>
      <xsl:when test="Charge">
      
        <bgh:cell>
            <!-- bonus points -->
            <xsl:if test="@BonPnt">
              <xsl:call-template name="volume-format">
                <xsl:with-param name="volume" select="@BonPnt"/>
              </xsl:call-template>
            </xsl:if>
        </bgh:cell>
        
        <bgh:cell/>
        <bgh:cell/>
        <bgh:cell/>
        <bgh:cell/>
        
        <bgh:cell>
            <!-- discount amount -->
            <xsl:apply-templates select="Charge"/>
        </bgh:cell>
        
      </xsl:when>
      
      <xsl:when test="RewAction">
        <bgh:cell>
            <!-- bonus points -->
            <xsl:if test="@BonPnt">
              <xsl:call-template name="volume-format">
                <xsl:with-param name="volume" select="@BonPnt"/>
              </xsl:call-template>
            </xsl:if>
        </bgh:cell>
        
        <!-- reward action -->
        <xsl:apply-templates select="RewAction"/>
        
      </xsl:when>
      <xsl:when test="AdvTxt">
        <bgh:cell>
            <!-- bonus points -->
            <xsl:if test="@BonPnt">
              <xsl:call-template name="volume-format">
                <xsl:with-param name="volume" select="@BonPnt"/>
              </xsl:call-template>
            </xsl:if>
        </bgh:cell>
        
        <bgh:cell/>
        <bgh:cell/>
        <bgh:cell/>
        
        <!-- advertisement text -->
        <xsl:apply-templates select="AdvTxt"/>
        
        <bgh:cell/>
        
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>

    </bgh:row>

  </xsl:template>
  
  

  <!-- reward action -->
  <xsl:template match="RewAction">

    <bgh:cell>
        <xsl:choose>
          <xsl:when test="@Entity='TM'">
            <!-- Tariff Model -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','331')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="@Entity='FUP'">
            <!-- Free Unit Package -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','332')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="@Entity='PP'">
            <!-- Promotion Package -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','333')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
    </bgh:cell>
    
    <bgh:cell>
        <xsl:choose>
          <xsl:when test="@Action='ADD'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','334')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="@Action='DEL'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','335')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="@Action='CH'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','336')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="@Action='ACT'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','337')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="@Action='DEA'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','338')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
    </bgh:cell>
    
    <bgh:cell>
        <xsl:if test="@Old">
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode" select="'0'"/>
            <xsl:with-param name="Index" select="@Old"/>
            <xsl:with-param name="Type" select="@Entity"/>
            <xsl:with-param name="Desc" select="'1'"/>
          </xsl:call-template>
          <xsl:text> -&gt; </xsl:text>
        </xsl:if>
        <xsl:if test="@New">
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode" select="'0'"/>
            <xsl:with-param name="Index" select="@New"/>
            <xsl:with-param name="Type" select="@Entity"/>
            <xsl:with-param name="Desc" select="'1'"/>
          </xsl:call-template>
        </xsl:if>
    </bgh:cell>
    
  </xsl:template>

  <!-- bonus points --> <!-- currently not used -->
  <xsl:template match="BonPnt">

        
          <!-- granted bonus points -->
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','40')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
          <xsl:text> (</xsl:text>
          <!-- grant date -->
          <xsl:apply-templates select="Date"/>
          <xsl:text>)</xsl:text>

          <xsl:value-of select="@Num"/>

  </xsl:template>

  <!-- advertisement text -->
  <xsl:template match="AdvTxt">
    <xsl:choose>
      <xsl:when test="name(..)='Reward'">
            <bgh:cell>
            <xsl:value-of select="."/>
            </bgh:cell>
      </xsl:when>
      <xsl:when test="name(..)='InvoiceInfo'">
            <bgh:row>
                <bgh:cell>
              <xsl:value-of select="."/>
                </bgh:cell>
            </bgh:row>
            <bgh:row/>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
