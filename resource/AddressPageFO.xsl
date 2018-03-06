<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson
 
  All rights reserved.

  File:    AddressPageFO.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> XSL-FO stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms address documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/AddressPageFO.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" exclude-result-prefixes="xsl cur">
  
  <!-- address -->
  <xsl:template match="AddressPage"/>

  <!-- invoicing party -->
  <xsl:template match="InvParty">

    <xsl:apply-templates select="FiCont" mode="footage"/>    
    <xsl:if test="@VATRegNo">
      <fo:block font-family="Times" text-align="center">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','10')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@VATRegNo"/>
      </fo:block>
    </xsl:if>
    <fo:block font-family="Times" text-align="center">
      <xsl:apply-templates select="CCContact"/>
    </fo:block>

  </xsl:template>
  <!-- billing account -->
  <xsl:template match="BillAcc">

    <xsl:choose>
        <xsl:when test="((@BOF='S') or (@BOF='F'))">
                <fo:block>
              <fo:table table-layout="fixed" width="160mm">
                <fo:table-column column-width="80mm"/>
                <fo:table-column column-width="80mm"/>
                <fo:table-body>
                  <fo:table-row>
                    <fo:table-cell>
                      <!-- receiver address -->
                      <xsl:apply-templates select="Addr"/>
                    </fo:table-cell>
                 </fo:table-row>
                </fo:table-body>
              </fo:table>
            </fo:block>     
            <fo:block space-before="3mm" text-align="center" font-weight="bold" font-size="9pt">
                <fo:table table-layout="fixed" width="160mm">
                    <fo:table-column column-width="160mm"/>
                    <fo:table-body>
                        <fo:table-row>  
                            <fo:table-cell>                     
                                <fo:block font-family="Helvetica" font-size="8pt" space-after="2mm" text-align="left">
                                  <xsl:for-each select="$txt">
                                    <xsl:value-of select="key('txt-index','556')[@xml:lang=$lang]/@Des"/>
                                  </xsl:for-each>               
                                  <xsl:text> </xsl:text>
                                  <xsl:value-of select="Addr/@Line2"/><xsl:text> ,</xsl:text>            
                                </fo:block>                         
                            </fo:table-cell>
                        </fo:table-row>
                        <!-- -->
                        <fo:table-row>  
                        <fo:table-cell>     
                        <fo:block font-family="Helvetica" font-size="8pt" space-after="2mm" text-align="right">
                            <xsl:for-each select="$txt">
                             <xsl:value-of select="key('txt-index','557')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                            <xsl:text> </xsl:text>                
                            <xsl:value-of select="concat(@ThresholdCurrCode,' ',@ThresholdAmount)"/>
                        </fo:block>
                        </fo:table-cell>
                        </fo:table-row>                     
                        <!-- -->
                        <fo:table-row>  
                        <fo:table-cell>     
                        <fo:block font-family="Helvetica" font-size="8pt" space-after="2mm" text-align="right">
                            <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','558')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>               
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="concat(@ThresholdCurrCode,' ',@InvoiceAmount)"/>
                            <xsl:text> ).</xsl:text>
                        </fo:block>
                        </fo:table-cell>
                        </fo:table-row>                     
                        <!-- -->
                        <xsl:choose>
                          <xsl:when test="@BOF='S'">
                                <fo:table-row>  
                                <fo:table-cell>     
                                <fo:block font-family="Helvetica" font-size="8pt" space-after="2mm" text-align="right">
                                    <xsl:for-each select="$txt">
                                    <xsl:value-of select="key('txt-index','559')[@xml:lang=$lang]/@Des"/>
                                    </xsl:for-each>               
                                </fo:block>
                                </fo:table-cell>
                                </fo:table-row>
                          </xsl:when>
                          <xsl:otherwise>
                                <fo:table-row>  
                                <fo:table-cell>     
                                <fo:block font-family="Helvetica" font-size="8pt" space-after="2mm" text-align="right">
                                    <xsl:for-each select="$txt">
                                    <xsl:value-of select="key('txt-index','560')[@xml:lang=$lang]/@Des"/>
                                    </xsl:for-each>
                                </fo:block>
                                </fo:table-cell>
                                </fo:table-row>
                          </xsl:otherwise>
                        </xsl:choose>            
                        <!-- -->                        
                        <fo:table-row>  
                        <fo:table-cell>     
                        <fo:block font-family="Helvetica" font-size="8pt" space-after="2mm" text-align="right">
                            <xsl:for-each select="$txt">
                                <xsl:value-of select="key('txt-index','561')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>               
                        </fo:block>
                        </fo:table-cell>
                        </fo:table-row>
                        <!-- -->                        
                        <fo:table-row>  
                        <fo:table-cell>     
                        <fo:block font-family="Helvetica" font-size="8pt" space-after="2mm" text-align="right">
                            <xsl:for-each select="$txt">
                                <xsl:value-of select="key('txt-index','562')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>               
                        </fo:block>
                        </fo:table-cell>
                        </fo:table-row>
                        <!-- -->                        
                        <fo:table-row>  
                        <fo:table-cell>     
                        <fo:block font-family="Helvetica" font-size="8pt" space-after="2mm" text-align="right">
                            <xsl:value-of select="../../@Sender"/>
                        </fo:block>
                        </fo:table-cell>
                        </fo:table-row>                     
                    </fo:table-body>
                </fo:table>
            </fo:block>
            </xsl:when>
        <xsl:otherwise>
            <fo:block>
              <fo:table table-layout="fixed" width="160mm">
                <fo:table-column column-width="80mm"/>
                <fo:table-column column-width="80mm"/>
                <fo:table-body>
                  <fo:table-row>
                    <fo:table-cell>
                      <fo:block font-family="Helvetica" font-size="8pt" space-after="2mm">
                        <fo:inline text-decoration="underline">
                          <!-- sender address header -->
                          <xsl:value-of
                            select="concat(../InvParty/Addr/@Name ,' ',
                                           ../InvParty/Addr/@Line1,' ',../InvParty/Addr/@Line2,' ',
                                           ../InvParty/Addr/@Line3,' ',../InvParty/Addr/@Line4,' ',
                                           ../InvParty/Addr/@Line5,' ',../InvParty/Addr/@Line6,' ',
                                           ../InvParty/Addr/@Zip  ,' ',../InvParty/Addr/@City ,' ',
                                           ../InvParty/Addr/@Country)"/>
                        </fo:inline>                
                      </fo:block>
                      <!-- receiver address -->
                      <xsl:apply-templates select="Addr"/>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:table table-layout="fixed" width="80mm">
                        <fo:table-column column-width="35mm"/>
                        <fo:table-column column-width="45mm"/>
                        <fo:table-body>
                          <!-- document reference number -->
                          <fo:table-row>
                            <fo:table-cell>
                              <fo:block font-size="8pt" text-align="right">
                                <xsl:for-each select="$txt">
                                  <xsl:value-of select="key('txt-index','327')[@xml:lang=$lang]/@Des"/>
                                </xsl:for-each>
                              </fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                              <fo:block font-size="8pt" text-align="right">
                                <xsl:value-of select="$drn"/>
                              </fo:block>
                            </fo:table-cell>
                          </fo:table-row>
                          <!-- billing account -->
                          <fo:table-row>
                            <!-- name -->
                            <fo:table-cell>
                              <fo:block font-size="8pt" text-align="right">
                                <xsl:for-each select="$txt">
                                  <xsl:value-of select="key('txt-index','306')[@xml:lang=$lang]/@Des"/>
                                </xsl:for-each>
                              </fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                              <fo:block font-size="8pt" text-align="right">
                                <xsl:value-of select="@Desc"/>
                              </fo:block>
                            </fo:table-cell>
                          </fo:table-row>
                          <fo:table-row>
                            <!-- pkey -->
                            <fo:table-cell>
                              <fo:block/>
                            </fo:table-cell>
                            <fo:table-cell>
                              <fo:block font-size="8pt" text-align="right">
                                <xsl:value-of select="../../@BAId"/>
                              </fo:block>
                            </fo:table-cell>
                          </fo:table-row>
                          <fo:table-row>
                            <!-- customer code -->
                            <xsl:apply-templates select="Customer"/>
                          </fo:table-row>
                        </fo:table-body>
                      </fo:table>
                    </fo:table-cell>
                  </fo:table-row>
                </fo:table-body>
              </fo:table>
            </fo:block>     
        </xsl:otherwise>
    </xsl:choose>
  
  </xsl:template>

  <!-- call detail statement -->
  <xsl:template match="Addressee">
    <fo:block>
      <fo:table table-layout="fixed" width="160mm">
        <fo:table-column column-width="80mm"/>
        <fo:table-column column-width="80mm"/>
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell>
              <fo:block font-family="Helvetica" font-size="8pt" space-after="2mm">
                <fo:inline text-decoration="underline">
                  <!-- sender address header -->
                  <xsl:value-of
                    select="concat(../InvParty/Addr/@Name ,' ',
                                   ../InvParty/Addr/@Line1,' ',../InvParty/Addr/@Line2,' ',
                                   ../InvParty/Addr/@Line3,' ',../InvParty/Addr/@Line4,' ',
                                   ../InvParty/Addr/@Line5,' ',../InvParty/Addr/@Line6,' ', 
                                   ../InvParty/Addr/@Zip  ,' ',../InvParty/Addr/@City ,' ',
                                   ../InvParty/Addr/@Country)"/>
                </fo:inline>                
              </fo:block>
              <!-- receiver address -->
              <xsl:apply-templates select="Addr"/>
            </fo:table-cell>
            <fo:table-cell>
              <fo:table table-layout="fixed" width="160mm">
                <fo:table-column column-width="35mm"/>
                <fo:table-column column-width="45mm"/>
                <fo:table-body>
                  <!-- not for order management letter -->
                  <xsl:if test="$bit != 'LET'">                
                    <!-- document reference number -->
                    <fo:table-row>
                      <fo:table-cell>
                        <fo:block font-size="8pt" text-align="right">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','327')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block font-size="8pt" text-align="right">
                          <xsl:value-of select="$drn"/>
                        </fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                      <!-- contract -->
                      <fo:table-cell>
                        <fo:block font-size="8pt" text-align="right">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','403')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block font-size="8pt" text-align="right">
                          <xsl:value-of select="@CoId"/>
                        </fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                  </xsl:if>
                  <fo:table-row>
                    <!-- customer code -->
                    <xsl:apply-templates select="Customer"/>
                  </fo:table-row>
                </fo:table-body>
              </fo:table>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </fo:block>  
  </xsl:template>

  <!-- customer info -->
  <xsl:template match="Customer">
    <fo:table-cell>
      <fo:block font-size="8pt" text-align="right">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','15')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell>
      <fo:block font-size="8pt" text-align="right">
        <xsl:value-of select="@Id"/>
      </fo:block>
    </fo:table-cell>
  </xsl:template>
  <!-- money transaction info -->
  <xsl:template match="FiCont">
    <xsl:apply-templates select="Account"/>
    <xsl:apply-templates select="Bank"/>
  </xsl:template>
  <!-- money transaction info -->
  <xsl:template match="FiCont" mode="footage">
    <xsl:apply-templates select="Account" mode="footage"/>
    <xsl:apply-templates select="Bank" mode="footage"/>
  </xsl:template>

  <!-- bank account -->
  <xsl:template match="Account">

    <fo:block font-size="8pt">
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','5')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
      <xsl:text> </xsl:text>
      <xsl:value-of select="concat(@HolderName1,' ',@HolderName2)"/>
      <xsl:text> - </xsl:text>
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','6')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
      <xsl:text> </xsl:text>
      <xsl:value-of select="@Num"/>
    </fo:block>

  </xsl:template>

  <!-- bank account -->
  <xsl:template match="Account" mode="footage">
    <!--        
    <xsl:for-each select="$txt">
      <xsl:value-of select="key('txt-index','5')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>        
    <xsl:text> </xsl:text>
    <xsl:value-of select="concat(@HolderName1,' ',@HolderName2)"/>
    <xsl:text>  </xsl:text>
    -->
    <xsl:for-each select="$txt">
      <xsl:value-of select="key('txt-index','6')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text> </xsl:text>
    <xsl:value-of select="@Num"/>
  </xsl:template>

  <!-- bank info -->
  <xsl:template match="Bank">

    <fo:block font-size="8pt">
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','7')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
      <xsl:text> </xsl:text>
      <xsl:value-of select="@Code"/>
      <xsl:text> - </xsl:text>
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','8')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
      <xsl:text> </xsl:text>
      <xsl:value-of select="@Name"/>
      <xsl:text> - </xsl:text>
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','9')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
      <xsl:text> </xsl:text>
      <xsl:value-of select="@Branch"/>
    </fo:block>

  </xsl:template>

  <!-- bank info -->
  <xsl:template match="Bank" mode="footage">
    <xsl:text> </xsl:text>
    <xsl:for-each select="$txt">
      <xsl:value-of select="key('txt-index','7')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text> </xsl:text>
    <xsl:value-of select="@Code"/>
    <xsl:text>  </xsl:text>
    <xsl:for-each select="$txt">
      <xsl:value-of select="key('txt-index','8')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text> </xsl:text>
    <xsl:value-of select="@Name"/>
    <xsl:text>  </xsl:text>
    <!--
    <xsl:for-each select="$txt">
      <xsl:value-of select="key('txt-index','9')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>        
    <xsl:text> </xsl:text>
    <xsl:value-of select="@Branch"/>
    -->
  </xsl:template>
  <!-- customer care contact info -->
  <xsl:template match="CCContact">

      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','11')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
      <xsl:text>  </xsl:text>
      <xsl:value-of select="@Person"/>
      <xsl:text>  </xsl:text>
      <xsl:for-each select="Contact">
        <xsl:apply-templates select="."/>
      </xsl:for-each>

  </xsl:template>
  <!-- contact info -->
  <xsl:template match="Contact">
    <xsl:choose>
      <xsl:when test="@Type='TE'">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','12')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="@Value"/>
        <xsl:text>  </xsl:text>
      </xsl:when>
      <xsl:when test="@Type='TX'">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','13')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="@Value"/>
        <xsl:text>  </xsl:text>
      </xsl:when>
      <xsl:when test="@Type='FX'">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','14')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="@Value"/>
        <xsl:text>  </xsl:text>
      </xsl:when>
      <xsl:when test="@Type='EM'">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','326')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="@Value"/>
        <xsl:text>  </xsl:text>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
