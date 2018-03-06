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
  
  File:    BalancePageCSV.xsl

  Owners:  Matthias Fehrenbacher
           Natalie Kather

  @(#) ABSTRACT : XML -> CSV stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms balance documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/BalancePageCSV.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015
  
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" xmlns:bgh="http://www.lhsgroup.com/BSCS/BGH" exclude-result-prefixes="xsl cur bgh ">
  
    <xsl:key name="legend-by-type" match="TypeDesc" use="@Type"/>
    
    <xsl:key name="FTA-key" match="FTA" use="@Type"/>
    <xsl:key name="FSI-key" match="FSI" use="@Type"/>
    <xsl:key name="FTX-key" match="FTX" use="@Type"/>
    
  
  <!-- balance page -->
  <xsl:template match="BalancePage">
    
    <bgh:row>
      <bgh:cell>
          <xsl:for-each select="$txt"><!-- Balance -->
            <xsl:value-of select="key('txt-index','177')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
      </bgh:cell>
    </bgh:row>
    
    <bgh:row>
      <bgh:cell/>
      <bgh:cell>
          <xsl:for-each select="$txt"><!-- Transactions considered until -->
            <xsl:value-of select="key('txt-index','178')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
          <xsl:text> </xsl:text>
          <xsl:apply-templates select="Date"/>
      </bgh:cell>
    </bgh:row>
    
    <bgh:row/>
    
    
    <xsl:variable name="balance-page" select="."/>
    
    <xsl:variable name="list-FTX" select="FTX"/>
    
    
    
    <!-- Alphabetical list of transaction types (sorted by their text description) -->
    <xsl:for-each select="$legend">
      <xsl:for-each select="key('legend-by-type', 'FTX')[@xml:lang=$lang]">
        <xsl:sort select="@LongDes"/>
        
        <xsl:variable name="type" select="@ShDes"/>
        <xsl:variable name="longdes" select="@LongDes"/>
        
        <xsl:for-each select="$balance-page">
          <xsl:for-each select="key('FTA-key', $type)">
            
            <!-- Long description -->
            <bgh:row>
                <bgh:cell/>
                <bgh:cell>
                    <xsl:value-of select="$longdes"/>
                </bgh:cell>
            </bgh:row>
            
            <!-- total amount (multiple currency) -->
            <bgh:row>
                <bgh:cell/>
                <bgh:cell/>
                <bgh:cell>
                      <xsl:for-each select="$txt"><!-- Total amount -->
                        <xsl:value-of select="key('txt-index','537')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                </bgh:cell>
                <bgh:cell>
                
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
            
            
            <bgh:row/>
            
            <!-- Print FSI (if available) -->
            <xsl:if test="count(key('FSI-key', $type)) > 0">
            
                <bgh:row>
                    <bgh:cell/>
                    <bgh:cell/>
                    <bgh:cell>
                      <xsl:for-each select="$txt"><!-- Set-offs -->
                        <xsl:value-of select="key('txt-index','195')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </bgh:cell>
                </bgh:row>
                
                <bgh:row>
                    <bgh:cell/>
                    <bgh:cell/>
                    <bgh:cell>
                      <xsl:for-each select="$txt"><!-- Date -->
                        <xsl:value-of select="key('txt-index','200')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </bgh:cell>
                    <bgh:cell>
                      <xsl:for-each select="$txt"><!-- Reference Number -->
                        <xsl:value-of select="key('txt-index','202')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </bgh:cell>
                    <bgh:cell>
                      <xsl:for-each select="$txt"><!-- Transaction amount -->
                        <xsl:value-of select="key('txt-index','203')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </bgh:cell>
                    <bgh:cell>
                      <xsl:for-each select="$txt"><!-- Set-off Amount -->
                        <xsl:value-of select="key('txt-index','204')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </bgh:cell>
                </bgh:row>
                
                
                <xsl:for-each select="key('FSI-key', $type)">
                    
                    <xsl:apply-templates select="."/>
                    
                </xsl:for-each>
                
                <bgh:row/>
            
            </xsl:if><!-- <xsl:if test="count(key('FSI-key', $type)) > 0"> -->
            
            
            <!-- Print FTX (if available) -->
            <xsl:if test="count(key('FTX-key', $type)) > 0">
            
                <bgh:row>
                    <bgh:cell/>
                    <bgh:cell/>
                    <bgh:cell>
                      <xsl:for-each select="$txt"><!-- Transactions -->
                        <xsl:value-of select="key('txt-index','179')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </bgh:cell>
                </bgh:row>
                
                <bgh:row>
                    <bgh:cell/>
                    <bgh:cell/>
                    <bgh:cell>
                      <xsl:for-each select="$txt"><!-- Date -->
                        <xsl:value-of select="key('txt-index','200')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </bgh:cell>
                    <bgh:cell>
                      <xsl:for-each select="$txt"><!-- Reference Number -->
                        <xsl:value-of select="key('txt-index','202')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </bgh:cell>
                    <bgh:cell>
                      <xsl:for-each select="$txt"><!-- Payment method -->
                        <xsl:value-of select="key('txt-index','512')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </bgh:cell>
                    <bgh:cell>
                      <xsl:for-each select="$txt"><!-- Amount -->
                        <xsl:value-of select="key('txt-index','203')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </bgh:cell>
                </bgh:row>
                
                
                <xsl:for-each select="key('FTX-key', $type)">
                    
                    <xsl:apply-templates select="."/>
                    
                </xsl:for-each>
                
                
                <bgh:row/>
            
            </xsl:if><!-- <xsl:if test="count(key('FTX-key', $type)) > 0"> -->
            
            
           </xsl:for-each> <!-- <xsl:for-each select="key('FTA-key', $type)"> -->
        </xsl:for-each><!-- <xsl:for-each select="$balance-page"> -->
        
      </xsl:for-each><!-- <xsl:for-each select="key('legend-by-type', 'FTX')[@xml:lang=$lang]"> -->
    
    </xsl:for-each><!-- <xsl:for-each select="$legend"> -->
    
    
  </xsl:template>


  <!-- setoff items -->
  <xsl:template match="FSI">
  
    <bgh:row>
        <bgh:cell/>
        <bgh:cell/>
        <bgh:cell>
            <!-- reference date -->
            <xsl:apply-templates select="Date"/>
        </bgh:cell>
        <bgh:cell>
            <!-- reference number -->
            <xsl:value-of select="@RefNum"/>
        </bgh:cell>
        
        <bgh:cell>
            <!-- transaction amount (multiple currency) -->
            <xsl:for-each select="Charge[@Id='960']">
              <!-- sort the charges -->
              <!--<xsl:sort select="@Id"   data-type="number" order="ascending"/>-->
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
        
        <bgh:cell>
            <!-- set-off amount (multiple currency) -->
            <xsl:for-each select="Charge[@Id='970']">
              <!-- sort the charges -->
              <!--<xsl:sort select="@Id"   data-type="number" order="ascending"/>-->
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

  
  <!-- balance transaction -->
  <xsl:template match="FTX">
  
    <bgh:row>
        <bgh:cell/>
        <bgh:cell/>
        <bgh:cell>
            <!-- reference date -->
            <xsl:apply-templates select="Date"/>
        </bgh:cell>
        <bgh:cell>
            <!-- reference number -->
            <xsl:value-of select="@RefNum"/>
        </bgh:cell>
        
        <bgh:cell>
            <!-- payment method -->
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="@PayMeth"/>
              <xsl:with-param name="Type"  select="'PMT'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
        </bgh:cell>
        
        <bgh:cell>
            <!-- transaction amount (multiple currency) -->
            <xsl:for-each select="Charge[@Id='960']">
              <!-- sort the charges -->
              <!--<xsl:sort select="@Id"   data-type="number" order="ascending"/>-->
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
    
</xsl:stylesheet>

