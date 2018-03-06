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
  
  File:    BalancePage.xsl

  Owners:  Matthias Fehrenbacher
           Natalie Kather

  @(#) ABSTRACT : XML -> HTML stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms balance documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/BalancePage.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015
  
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" exclude-result-prefixes="xsl cur">

    <xsl:key name="legend-by-type" match="TypeDesc" use="@Type"/>
    
    <xsl:key name="FTA-key" match="FTA" use="@Type"/>
    <xsl:key name="FSI-key" match="FSI" use="@Type"/>
    <xsl:key name="FTX-key" match="FTX" use="@Type"/>

  <xsl:template match="BalancePage">
  
    <hr/>
    <center><h2>
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','177')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
    </h2></center>

    <p align="right">
      <xsl:apply-templates select="Date"/>
    </p>
    
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
            <h4><center>
              <xsl:value-of select="$longdes"/>
            </center></h4>
            
            <table border="1" width="30%" cellspacing="0" cellpadding="0">
              
              <!-- total amount (multiple currency) -->
              <tr>
                <td width="60%" valign="top"><font size="-1">
                  <xsl:for-each select="$txt"><!-- Total amount -->
                    <xsl:value-of select="key('txt-index','537')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </font></td>
                <td width="40%" valign="top" align="right"><font size="-1">
                
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
              </tr>
              
            </table>
            
            <br/>
            
            <!-- Print FSI (if available) -->
            <xsl:if test="count(key('FSI-key', $type)) > 0">
                
                
              <table border="1" width="70%" cellspacing="0" cellpadding="0">
                <thead>
                  <tr>
                    <td colspan="6"><font size="-1"><b>
                      <xsl:for-each select="$txt"><!-- Set-offs -->
                        <xsl:value-of select="key('txt-index','195')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </b></font></td>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <xsl:for-each select="$txt">
                      <th width="20%"><font size="-1"><!-- Date -->
                        <xsl:value-of select="key('txt-index','200')[@xml:lang=$lang]/@Des"/>
                      </font></th>
                      <th width="40%"><font size="-1"><!-- Reference Number -->
                        <xsl:value-of select="key('txt-index','202')[@xml:lang=$lang]/@Des"/>
                      </font></th>
                      <th width="20%"><font size="-1"><!-- Transaction amount -->
                        <xsl:value-of select="key('txt-index','203')[@xml:lang=$lang]/@Des"/>
                      </font></th>
                      <th width="20%"><font size="-1"><!-- Set-off amount -->
                        <xsl:value-of select="key('txt-index','204')[@xml:lang=$lang]/@Des"/>
                      </font></th>
                    </xsl:for-each>
                  </tr>
                  
                  <xsl:for-each select="key('FSI-key', $type)">
                      
                      <xsl:apply-templates select="."/>
                      
                  </xsl:for-each>
                  
                </tbody>
              </table>
              
              <br/>
              
            </xsl:if>
            
            
            <!-- Print FTX (if available) -->
            <xsl:if test="count(key('FTX-key', $type)) > 0">
                
                
              <table border="1" width="70%" cellspacing="0" cellpadding="0">
                <thead>
                  <tr>
                    <td colspan="6"><font size="-1"><b>
                      <xsl:for-each select="$txt"><!-- Transactions -->
                        <xsl:value-of select="key('txt-index','330')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                    </b></font></td>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <xsl:for-each select="$txt">
                      <th width="20%"><font size="-1"><!-- Date -->
                        <xsl:value-of select="key('txt-index','200')[@xml:lang=$lang]/@Des"/>
                      </font></th>
                      <th width="40%"><font size="-1"><!-- Reference Number -->
                        <xsl:value-of select="key('txt-index','202')[@xml:lang=$lang]/@Des"/>
                      </font></th>
                      <th width="20%"><font size="-1"><!-- Payment method -->
                        <xsl:value-of select="key('txt-index','512')[@xml:lang=$lang]/@Des"/>
                      </font></th>
                      <th width="20%"><font size="-1"><!-- Amount -->
                        <xsl:value-of select="key('txt-index','203')[@xml:lang=$lang]/@Des"/>
                      </font></th>
                    </xsl:for-each>
                  </tr>
                  
                  <xsl:for-each select="key('FTX-key', $type)">
                    <tr>
                      <xsl:apply-templates select="."/>
                    </tr>
                  </xsl:for-each>
                  
                </tbody>
              </table>
              
              <br/>
              
            </xsl:if>
            
            
           </xsl:for-each> <!-- <xsl:for-each select="key('FTA-key', $type)"> -->
        </xsl:for-each><!-- <xsl:for-each select="$balance-page"> -->
        
      </xsl:for-each><!-- <xsl:for-each select="key('legend-by-type', 'FTX')[@xml:lang=$lang]"> -->
    
    </xsl:for-each><!-- <xsl:for-each select="$legend"> -->
    

  </xsl:template>
  
  <!-- Setoff items -->
  <xsl:template match="FSI">
    
    <tr>
        <!-- transaction date -->
        <td align="center"><font size="-1">
          <xsl:apply-templates select="Date"/>
        </font></td>
        
        <!-- Reference number -->
        <td align="center"><font size="-1">
          <xsl:value-of select="@RefNum"/>
        </font></td>
        
        <!-- transaction amount (multiple currency) -->
        <td align="right"><font size="-1">      
          <xsl:for-each select="Charge">
            <!-- sort the charges -->
            <xsl:sort select="@Id"   data-type="number" order="ascending"/>
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
                    <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="following-sibling::Charge[1]/@Id!='960'">
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
        
        <!-- setoff amount (multiple currency) -->
        <td align="right"><font size="-1">      
          <xsl:for-each select="Charge">
            <!-- sort the charges -->
            <xsl:sort select="@Id"   data-type="number" order="ascending"/>
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
                    <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="following-sibling::Charge[1]/@Id!='970'">
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
    
  </xsl:template>
  
  
  <!-- balance transaction -->
  <xsl:template match="FTX">

    <!-- transaction date -->
    <xsl:apply-templates select="Date"/>
    
    <td align="center"><font size="-1">
      <xsl:value-of select="@RefNum"/>
    </font></td>
    
     <!-- payment method -->
     <td align="center"><font size="-1">
       
       <xsl:choose>
        <xsl:when test="@PayMeth">
           <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="@PayMeth"/>
            <xsl:with-param name="Type"  select="'PMT'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>-</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
       

    </font></td>
    
    <!-- print transaction amount (multiple currency) -->
    <td align="right"><font size="-1">      
      <xsl:for-each select="Charge">
        <!-- sort the charges -->
        <xsl:sort select="@Id"   data-type="number" order="ascending"/>
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
                <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="following-sibling::Charge[1]/@Id!='960'">
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
    
    
  </xsl:template>

</xsl:stylesheet>
