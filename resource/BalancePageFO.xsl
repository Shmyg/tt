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
  
  File:    BalancePageFO.xsl

  Owners:  Matthias Fehrenbacher
           Natalie Kather

  @(#) ABSTRACT : XML -> XSL-FO stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms balance documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/BalancePageFO.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015
  
-->

<xsl:stylesheet version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" exclude-result-prefixes="xsl cur">

    <xsl:key name="legend-by-type" match="TypeDesc" use="@Type"/>
    
    <xsl:key name="FTA-key" match="FTA" use="@Type"/>
    <xsl:key name="FSI-key" match="FSI" use="@Type"/>
    <xsl:key name="FTX-key" match="FTX" use="@Type"/>
    
  
  <!-- balance page -->
  <xsl:template match="BalancePage">
    <fo:block break-before="page" margin-top="6mm" text-align="center" font-weight="bold" font-size="12pt">
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','177')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
    </fo:block>
    <fo:block font-size="9pt" font-family="Times" text-align="right">
      <xsl:for-each select="$txt"><!-- Transactions considered until -->
        <xsl:value-of select="key('txt-index','178')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
      <xsl:text> </xsl:text>
      <fo:inline font-style="italic">
        <xsl:apply-templates select="Date"/>
      </fo:inline>
    </fo:block>
    
    <xsl:variable name="balance-page" select="."/>
    
    <xsl:variable name="list-FTX" select="FTX"/>
    <!--
    <xsl:variable name="list-FTA" select="FTA"/>
    <xsl:variable name="list-FSI" select="FSI"/>
    -->
    
    <!-- Alphabetical list of transaction types (sorted by their text description) -->
    <xsl:for-each select="$legend">
      <xsl:for-each select="key('legend-by-type', 'FTX')[@xml:lang=$lang]">
        <xsl:sort select="@LongDes"/>
        
        <xsl:variable name="type" select="@ShDes"/>
        <xsl:variable name="longdes" select="@LongDes"/>
        
        <xsl:for-each select="$balance-page">
          <xsl:for-each select="key('FTA-key', $type)">
            
            <!-- Long description -->
            <fo:block space-before="10mm" font-size="9pt" font-weight="bold" text-align="center">
                <xsl:value-of select="$longdes"/>
            </fo:block>
            
            <fo:block>
            <fo:table table-layout="fixed" width="160mm">
              <fo:table-column column-width="35mm"/>
              <fo:table-column column-width="55mm"/>
              <fo:table-column column-width="35mm"/>
              <fo:table-column column-width="35mm"/>
                
              <fo:table-body font-size="8pt" space-before="2mm">
              
                <!-- total amount (multiple currency) -->
                <fo:table-row line-height="10pt">
                  <fo:table-cell>
                    <fo:block/>
                  </fo:table-cell>
                  <fo:table-cell border-top-width="0.2pt" border-top-style="solid" border-top-color="black">
                    <fo:block font-size="8pt">
                      <xsl:for-each select="$txt"><!-- Total amount -->
                        <xsl:value-of select="key('txt-index','537')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </fo:block>
                  </fo:table-cell>
                  
                  <fo:table-cell text-align="right" border-top-width="0.2pt" border-top-style="solid" border-top-color="black">
                    
                    <xsl:for-each select="Charge">
                    
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
            </fo:block>
                
                <!-- Set-off item (if available) -->
                <xsl:if test="count( key('FSI-key', $type) ) > 0">
                  
                    <fo:block space-before="2mm" font-size="8pt" font-weight="bold" text-align="center">
                      <xsl:for-each select="$txt"><!-- Set-Offs -->
                        <xsl:value-of select="key('txt-index','195')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </fo:block>
                  
                  
                      <fo:block space-before="2mm" space-after="5mm">
                        <fo:table table-layout="fixed" width="160mm">
                          <fo:table-column column-width="0mm" column-number="1"/><!-- empty -->
                          <fo:table-column column-width="35mm" column-number="2"/>
                          <fo:table-column column-width="45mm" column-number="3"/>
                          <fo:table-column column-width="40mm" column-number="4"/>
                          <fo:table-column column-width="40mm" column-number="5"/>
                          <fo:table-column column-width="0mm" column-number="6"/><!-- empty -->
                          <fo:table-header space-after="2pt">
                            <fo:table-row>
                              <fo:table-cell>
                                <fo:block/>
                              </fo:table-cell>
                              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                                <fo:block font-size="8pt" font-weight="bold" text-align="center">
                                  <xsl:for-each select="$txt"><!-- Date -->
                                    <xsl:value-of select="key('txt-index','200')[@xml:lang=$lang]/@Des"/>
                                  </xsl:for-each>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                                <fo:block font-size="8pt" font-weight="bold" text-align="center">
                                  <xsl:for-each select="$txt"><!-- Reference Number -->
                                    <xsl:value-of select="key('txt-index','202')[@xml:lang=$lang]/@Des"/>
                                  </xsl:for-each>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                                <fo:block font-size="8pt" font-weight="bold" text-align="center">
                                  <xsl:for-each select="$txt"><!-- Transaction amount -->
                                    <xsl:value-of select="key('txt-index','203')[@xml:lang=$lang]/@Des"/>
                                  </xsl:for-each>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                                <fo:block font-size="8pt" font-weight="bold" text-align="center">
                                  <xsl:for-each select="$txt"><!-- Set-off amount -->
                                    <xsl:value-of select="key('txt-index','204')[@xml:lang=$lang]/@Des"/>
                                  </xsl:for-each>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                <fo:block/>
                              </fo:table-cell>
                            </fo:table-row>
                          </fo:table-header>
                          
                          <fo:table-body>
                          
                            <xsl:for-each select="key('FSI-key', $type)">
                                
                                <xsl:apply-templates select="."/>
                                
                            </xsl:for-each>
                            
                          </fo:table-body>
                          
                        </fo:table>
                      </fo:block>
                  
                </xsl:if>
            
            
            <!-- Print FTX (if available) -->
            <xsl:if test="count(key('FTX-key', $type)) > 0">
            
                <fo:block space-before="2mm" font-size="8pt" font-weight="bold" text-align="center">
                  <xsl:for-each select="$txt"><!-- Transactions -->
                    <xsl:value-of select="key('txt-index','179')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
                
              <fo:block space-before="2mm" space-after="5mm">
                <fo:table table-layout="fixed" width="160mm">
                  <fo:table-column column-width="0mm" column-number="1"/><!-- empty -->
                  <fo:table-column column-width="35mm" column-number="2"/>
                  <fo:table-column column-width="45mm" column-number="3"/>
                  <fo:table-column column-width="40mm" column-number="4"/>
                  <fo:table-column column-width="40mm" column-number="5"/>
                  <fo:table-column column-width="0mm" column-number="6"/><!-- empty -->
                  <fo:table-header space-after="2pt">
                    <fo:table-row>
                      <fo:table-cell>
                        <fo:block/>
                      </fo:table-cell>
                      <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                        <fo:block font-size="8pt" font-weight="bold" text-align="center">
                          <xsl:for-each select="$txt"><!-- Date -->
                            <xsl:value-of select="key('txt-index','200')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                        <fo:block font-size="8pt" font-weight="bold" text-align="center">
                          <xsl:for-each select="$txt"><!-- Reference Number -->
                            <xsl:value-of select="key('txt-index','202')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                        <fo:block font-size="8pt" font-weight="bold" text-align="center">
                          <xsl:for-each select="$txt"><!-- Payment method -->
                            <xsl:value-of select="key('txt-index','512')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell border-bottom-width="0.01pt" border-bottom-style="solid" border-bottom-color="black">
                        <fo:block font-size="8pt" font-weight="bold" text-align="center">
                          <xsl:for-each select="$txt"><!-- Amount -->
                            <xsl:value-of select="key('txt-index','203')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block/>
                      </fo:table-cell>
                    </fo:table-row>
                  </fo:table-header>
                  
                  <fo:table-body>
                  
                    <xsl:for-each select="key('FTX-key', $type)">
                      <fo:table-row>
                        <xsl:apply-templates select="."/>
                      </fo:table-row>
                    </xsl:for-each>
                    
                  </fo:table-body>
                  
                </fo:table>
              </fo:block>
            
            </xsl:if>
            
            
           </xsl:for-each> <!-- <xsl:for-each select="key('FTA-key', $type)"> -->
        </xsl:for-each><!-- <xsl:for-each select="$balance-page"> -->
        
      </xsl:for-each><!-- <xsl:for-each select="key('legend-by-type', 'FTX')[@xml:lang=$lang]"> -->
    
    </xsl:for-each><!-- <xsl:for-each select="$legend"> -->
    
    
  </xsl:template>
  
  
  
  <xsl:template match="FSI">
    
    <fo:table-row>
    
    <fo:table-cell>
      <fo:block/>
    </fo:table-cell>

    <!-- reference date -->
    <fo:table-cell text-align="center">
      <fo:block font-size="8pt">
        <xsl:apply-templates select="Date"/>  
      </fo:block>
    </fo:table-cell>
    
    <!-- reference number -->
    <fo:table-cell>
      <fo:block font-size="8pt" text-align="center">
        <xsl:value-of select="@RefNum"/>    
      </fo:block>
    </fo:table-cell>
    
    <!-- transaction amount (multiple currency) -->
    <fo:table-cell>
      
      <xsl:for-each select="Charge">
        <xsl:sort select="@Id"   data-type="number" order="ascending"/>
      
        <fo:block font-size="8pt" text-align="right">
        
          <!-- sort the charges -->
          <xsl:variable name="number-format">      
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="@Amount"/>
            </xsl:call-template> 
          </xsl:variable>
          <xsl:if test="@Id='960'">
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
                  <xsl:when test="following-sibling::Charge[1]/@Id!='960'">
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
          
        </fo:block>
        
      </xsl:for-each>
      
    </fo:table-cell>
    
    
    <!-- set-off amount (multiple currency) -->
    <fo:table-cell>
      
      <xsl:for-each select="Charge">
        <xsl:sort select="@Id"   data-type="number" order="ascending"/>
      
        <fo:block font-size="8pt" text-align="right">
        
          <!-- sort the charges -->
          <xsl:variable name="number-format">      
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="@Amount"/>
            </xsl:call-template> 
          </xsl:variable>
          <xsl:if test="@Id='970'">
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
                  <xsl:when test="following-sibling::Charge[1]/@Id!='970'">
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
          
        </fo:block>
        
      </xsl:for-each>
      
    </fo:table-cell>
    
    <fo:table-cell>
      <fo:block/>
    </fo:table-cell>
    
    </fo:table-row>
    
  </xsl:template>
  
  
  <!-- balance transaction -->
  <xsl:template match="FTX">
  
    <fo:table-cell>
      <fo:block/>
    </fo:table-cell>

    <!-- reference date -->
    <fo:table-cell text-align="center">
      <fo:block font-size="8pt">
        <xsl:apply-templates select="Date"/>  
      </fo:block>
    </fo:table-cell>
    
    <!-- reference number -->
    <fo:table-cell>
      <fo:block font-size="8pt" text-align="center">
        <xsl:value-of select="@RefNum"/>    
      </fo:block>
    </fo:table-cell>
    
    <!-- payment method -->
    <fo:table-cell>
      <fo:block font-size="8pt" text-align="center">
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@PayMeth"/>
          <xsl:with-param name="Type"  select="'PMT'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    
    
    <!-- transaction amount (multiple currency) -->
    <fo:table-cell>
      
      <xsl:for-each select="Charge">
        <xsl:sort select="@Id"   data-type="number" order="ascending"/>
      
        <fo:block font-size="8pt" text-align="right">
        
          <!-- sort the charges -->
          <xsl:variable name="number-format">      
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="@Amount"/>
            </xsl:call-template> 
          </xsl:variable>
          <xsl:if test="@Id='960'">
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
                  <xsl:when test="following-sibling::Charge[1]/@Id!='960'">
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
          
        </fo:block>
        
      </xsl:for-each>
      
    </fo:table-cell>
    
    <fo:table-cell>
      <fo:block/>
    </fo:table-cell>
    
  </xsl:template>
    
</xsl:stylesheet>