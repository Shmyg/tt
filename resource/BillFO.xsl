<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2012 Ericsson

  All rights reserved.

  File:    BillFO.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> XSL-FO stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms master documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/BillFO.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

  Additional available functions !

  Namespace:  xmlns:math="http://exslt.org/math"
              xmlns:external="http://ExternalFunction.xalan-c++.xml.apache.org"
              
  Functions:  math:sin()
              math:cos()
              ...
              external:asctime()
              external:square-root(number)
              external:cube(number)
              external:sin(number)
              external:cos(number)
              external:tan(number)
              external:exp(number)
              external:log(number)
              external:log10(number)
-->

<xsl:stylesheet version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="xsl cur set">

  <xsl:output method="xml" encoding="UTF-8" indent="no"/>
  <xsl:strip-space elements="*"/>
  <!-- at the moment EN and DE are supported -->
  <xsl:param name="lang"/>
  <!-- legend file -->
  <xsl:param name="lgn"/>
  <!-- document reference number -->
  <xsl:param name="drn"/>
  <!-- format -->
  <xsl:param name="fmt"/>
  <!-- bill type -->
  <xsl:param name="bit"/>
  <!-- copy flag -->
  <xsl:param name="cflag"/>
  <!-- pricing type: N/G -->
  <xsl:param name="pricing"/>
  <!-- pricing type (prepaid): N/G -->
  <xsl:param name="pricing-prepaid"/>

  <!-- configuration files -->
  <xsl:variable name="legend" select="document($lgn)"/>
  <xsl:variable name="txt"    select="document(concat('Fixtext_',$lang,'.xml'))"/>
  <xsl:variable name="xcd"    select="document(concat('XCD_',$lang,'.xml'))"/>
  <xsl:variable name="fup"    select="document(concat('FUP_',$lang,'.xml'))"/>
  <xsl:variable name="rdd"    select="document(concat('RDD_',$lang,'.xml'))"/>
  
  <xsl:include href="BillingDocumentFO.xsl"/>

  <!-- barcode -->
  <xsl:include href="code128.xsl"/>
  <xsl:include href="3of9.xsl"/>
  <xsl:include href="upc-ean.xsl"/>

  <!-- mapping keys (legend, fixtext, udr-attributes) -->
  <xsl:key name="id-index" match="TypeDesc" use="@Id"/>
  <xsl:key name="txt-index" match="Text" use="@Id"/>
  <xsl:key name="xcd-index" match="XCD" use="@Id"/>
  <xsl:key name="rdd-index" match="RDD" use="@Id"/>
  <xsl:key name="fup-index" match="FUP" use="@Id"/>
  <xsl:key name="pkey-index" match="TypeDesc" use="@PKey"/>
  
  <!-- root -->
  <xsl:template match="/">
    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
      <xsl:if test="$fmt != 'rtf'">
          <fo:layout-master-set>
            <fo:simple-page-master master-name="first-page" page-height="297mm" page-width="210mm"
              margin-top="10mm" margin-bottom="5mm" margin-left="5mm" margin-right="5mm">
              <fo:region-body margin-top="20mm" region-name="xsl-region-body" margin-bottom="30mm"
                margin-left="20mm" margin-right="20mm"/>
              <fo:region-before extent="15mm" region-name="xsl-region-before-first-page"/>
              <fo:region-after extent="15mm" region-name="xsl-region-after-first-page"/>
              <fo:region-start extent="5mm" region-name="xsl-region-start-first-page"/>
              <fo:region-end extent="5mm" region-name="xsl-region-end-first-page"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="odd-page" page-height="297mm" page-width="210mm"
              margin-top="10mm" margin-bottom="5mm" margin-left="5mm" margin-right="5mm">
              <fo:region-body margin-top="20mm" region-name="xsl-region-body" margin-bottom="30mm"
                margin-left="20mm" margin-right="20mm"/>
              <fo:region-before extent="15mm" region-name="xsl-region-before-odd-page"/>
              <fo:region-after extent="15mm" region-name="xsl-region-after-odd-page"/>
              <fo:region-start extent="5mm" region-name="xsl-region-start-odd-page"/>
              <fo:region-end extent="5mm" region-name="xsl-region-end-odd-page"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="even-page" page-height="297mm" page-width="210mm"
              margin-top="10mm" margin-bottom="5mm" margin-left="5mm" margin-right="5mm">
              <fo:region-body margin-top="20mm" region-name="xsl-region-body" margin-bottom="30mm"
                margin-left="20mm" margin-right="20mm"/>
              <fo:region-before extent="15mm" region-name="xsl-region-before-even-page"/>
              <fo:region-after extent="15mm" region-name="xsl-region-after-even-page"/>
              <fo:region-start extent="5mm" region-name="xsl-region-start-even-page"/>
              <fo:region-end extent="5mm" region-name="xsl-region-end-even-page"/>
            </fo:simple-page-master>
            <fo:page-sequence-master master-name="part">
              <!-- page alternatives -->
              <fo:repeatable-page-master-alternatives>
                <fo:conditional-page-master-reference master-reference="first-page" page-position="first"/>
                <fo:conditional-page-master-reference master-reference="odd-page" odd-or-even="odd"/>
                <fo:conditional-page-master-reference master-reference="even-page" odd-or-even="even"/>
              </fo:repeatable-page-master-alternatives>
            </fo:page-sequence-master>
          </fo:layout-master-set>
          <!-- content -->
          <fo:page-sequence master-reference="part" initial-page-number="1">
            <fo:static-content flow-name="xsl-region-before-first-page">
              <!-- logo  -->
              <fo:block text-align="center">            
                <fo:external-graphic height="12mm" content-height="scale-to-fit" src="logo.jpg" />
              </fo:block>
            </fo:static-content>
            <fo:static-content flow-name="xsl-region-before-odd-page">
              <!-- logo  -->
              <fo:block text-align="center">
                <fo:external-graphic height="12mm" content-height="scale-to-fit" src="logo.jpg" />
              </fo:block>
            </fo:static-content>
            <fo:static-content flow-name="xsl-region-before-even-page">
              <!-- logo  -->
              <fo:block text-align="center">
                <fo:external-graphic height="12mm" content-height="scale-to-fit" src="logo.jpg" />
              </fo:block>
            </fo:static-content>
            <fo:static-content flow-name="xsl-region-after-first-page">
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="proportional-column-width(2)" column-number="1"/>
                <fo:table-column column-width="100mm" column-number="2"/>
                <fo:table-column column-width="proportional-column-width(2)" column-number="3"/>
                <fo:table-body>
                  <fo:table-row>
                    <fo:table-cell padding-top="3pt">
                      <fo:block text-align="left">
                        <!-- drn as barcode -->
                        <xsl:if test="string-length($drn)!=0">
                          <fo:instream-foreign-object>
                            <xsl:call-template name="barcode-code128">
                              <xsl:with-param name="value"  select="$drn"/>
                              <xsl:with-param name="string" select="$drn"/>
                              <xsl:with-param name="subset" select="'B'"/>
                            </xsl:call-template>
                          </fo:instream-foreign-object>
                        </xsl:if>
                        <!--
                        <fo:instream-foreign-object>
                          <xsl:call-template name="barcode-EAN">
                            <xsl:with-param name="value" select="$drn"/>
                          </xsl:call-template>
                        </fo:instream-foreign-object>
                        -->
                      </fo:block>
                      <!--
                      <fo:block font-size="28pt" font-family="Barcode" text-align="left">
                        <xsl:value-of select="$drn"/>
                      </fo:block>
                      -->
                    </fo:table-cell>
                    <fo:table-cell>
                      <!-- footer invoicing party -->
                      <fo:block font-size="6pt" font-family="Times" text-align="center">
                        <xsl:for-each select="document(/Bill/Part/@File)/Document/AddressPage/InvParty">
                          <xsl:apply-templates select="."/>
                        </xsl:for-each>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <!-- page x from y -->
                      <fo:block font-size="6pt" font-family="Times" text-align="right" padding-before="5mm">
                        <xsl:for-each select="$txt">
                          <xsl:value-of select="key('txt-index','385')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                        <xsl:text> </xsl:text>
                        <fo:page-number/>
                        <xsl:if test="$fmt != 'rtf'" >
                      <xsl:text> </xsl:text>
                        <xsl:for-each select="$txt">
                          <xsl:value-of select="key('txt-index','386')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                        <xsl:text> </xsl:text>
                        <fo:page-number-citation ref-id="endofdoc"/>
                     </xsl:if>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </fo:table-body>
              </fo:table>
            </fo:static-content>
            <fo:static-content flow-name="xsl-region-after-odd-page">
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="proportional-column-width(2)" column-number="1"/>
                <fo:table-column column-width="100mm" column-number="2"/>
                <fo:table-column column-width="proportional-column-width(2)" column-number="3"/>
                <fo:table-body>
                  <fo:table-row>
                    <fo:table-cell padding-top="3pt">
                      <fo:block text-align="left">
                        <!-- drn as barcode -->
                        <!--fo:instream-foreign-object>
                          <xsl:call-template name="barcode-code128">
                            <xsl:with-param name="value" select="$drn"/>
                            <xsl:with-param name="string" select="$drn"/>
                          </xsl:call-template>
                        </fo:instream-foreign-object-->
                        <!--
                        <fo:instream-foreign-object>
                          <xsl:call-template name="barcode-EAN">
                            <xsl:with-param name="value" select="$drn"/>
                          </xsl:call-template>
                        </fo:instream-foreign-object>
                        -->
                      </fo:block>
                      <!--
                      <fo:block font-size="9pt" font-family="Barcode" text-align="left">
                        <xsl:value-of select="$drn"/>
                      </fo:block>
                      -->
                    </fo:table-cell>
                    <fo:table-cell>
                      <!-- footer invoicing party -->
                      <fo:block font-size="6pt" font-family="Times" text-align="center">
                        <xsl:for-each select="document(/Bill/Part/@File)/Document/AddressPage/InvParty">
                          <xsl:apply-templates select="."/>
                        </xsl:for-each>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <!-- page x from y -->
                      <fo:block font-size="6pt" font-family="Times" text-align="right" padding-before="5mm">
                        <xsl:for-each select="$txt">
                          <xsl:value-of select="key('txt-index','385')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                        <xsl:text> </xsl:text>
                        <fo:page-number/>
                        <xsl:if test="$fmt != 'rtf'" >
                      <xsl:text> </xsl:text>
                      <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','386')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                      <xsl:text> </xsl:text>
                      <fo:page-number-citation ref-id="endofdoc"/>
                    </xsl:if>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </fo:table-body>
              </fo:table>
            </fo:static-content>
            <fo:static-content flow-name="xsl-region-after-even-page">
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="proportional-column-width(2)" column-number="1"/>
                <fo:table-column column-width="100mm" column-number="2"/>
                <fo:table-column column-width="proportional-column-width(2)" column-number="3"/>
                <fo:table-body>
                  <fo:table-row>
                    <fo:table-cell padding-top="3pt">
                      <fo:block text-align="left">
                        <!-- drn as barcode -->
                        <!--fo:instream-foreign-object>
                          <xsl:call-template name="barcode-code128">
                            <xsl:with-param name="value" select="$drn"/>
                            <xsl:with-param name="string" select="$drn"/>
                          </xsl:call-template>
                        </fo:instream-foreign-object-->
                        <!--
                        <fo:instream-foreign-object>
                          <xsl:call-template name="barcode-EAN">
                            <xsl:with-param name="value" select="$drn"/>
                          </xsl:call-template>
                        </fo:instream-foreign-object>
                        -->
                      </fo:block>
                      <!--
                      <fo:block font-size="9pt" font-family="Barcode" text-align="left">
                        <xsl:value-of select="$drn"/>
                      </fo:block>
                      -->
                    </fo:table-cell>
                    <fo:table-cell>
                      <!-- footer invoicing party -->
                      <fo:block font-size="6pt" font-family="Times" text-align="center">
                        <xsl:for-each select="document(/Bill/Part/@File)/Document/AddressPage/InvParty">
                          <xsl:apply-templates select="."/>
                        </xsl:for-each>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <!-- page x from y -->
                      <fo:block font-size="6pt" font-family="Times" text-align="right" padding-before="5mm">
                        <xsl:for-each select="$txt">
                          <xsl:value-of select="key('txt-index','385')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                        <xsl:text> </xsl:text>
                        <fo:page-number/>
                        <xsl:if test="$fmt != 'rtf'" >
                      <xsl:text> </xsl:text>
                      <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','386')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                      <xsl:text> </xsl:text>
                      <fo:page-number-citation ref-id="endofdoc"/>
                    </xsl:if>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </fo:table-body>
              </fo:table>
            </fo:static-content>
            
            <fo:flow flow-name="xsl-region-body">          
          <xsl:apply-templates select="Bill"/>
            <fo:block id="endofdoc"/>
            </fo:flow>
          </fo:page-sequence>
    </xsl:if>
            
    <xsl:if test="$fmt='rtf'">

        <fo:layout-master-set>
          <fo:simple-page-master master-name="A4" page-height="297mm" page-width="210mm" margin-top="10mm" margin-bottom="5mm" margin-left="5mm" margin-right="5mm">
            <fo:region-body margin-top="20mm" margin-bottom="30mm" region-name="xsl-region-body" margin-left="20mm" margin-right="20mm"/>
            <fo:region-before extent="15mm" region-name="xsl-region-before"/>
            <fo:region-after extent="15mm" region-name="xsl-region-after"/>
            <fo:region-start extent="5mm" region-name="xsl-region-start"/>
            <fo:region-end extent="5mm" region-name="xsl-region-end"/>
          </fo:simple-page-master>
        </fo:layout-master-set>
        
        <xsl:if test="($bit!='INV' and $bit!='REC' and $bit!='PCM')">
            <fo:page-sequence master-reference="A4">
                <fo:static-content flow-name="xsl-region-before">
                <xsl:call-template name="graphic"/>
              </fo:static-content>
              
              <fo:static-content flow-name="xsl-region-after">
                <fo:block>
              <fo:table table-layout="fixed" width="160mm">
                <fo:table-column column-width="30mm" column-number="1"/>
                  <fo:table-column column-width="100mm" column-number="2"/>
                    <fo:table-column column-width="30mm" column-number="3"/>
                        
                  <fo:table-body>
                    <fo:table-row>
                      <fo:table-cell>
                        <fo:block text-align="left">
                          <!-- drn as barcode -->
                          <fo:instream-foreign-object>
                            <xsl:call-template name="barcode-code128">
                              <xsl:with-param name="value" select="$drn"/>
                              <xsl:with-param name="string" select="$drn"/>
                            </xsl:call-template>
                          </fo:instream-foreign-object>
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <!-- footer invoicing party -->
                        <fo:block font-size="6pt" font-family="Times" text-align="center">
                          <xsl:for-each select="document(/Bill/Part/@File)/Document/AddressPage/InvParty">
                            <xsl:apply-templates select="."/>
                          </xsl:for-each>
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <!-- page x from y -->
                          <fo:block font-size="6pt" font-family="Times" text-align="right" padding-before="5mm">
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','385')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                            <xsl:text> </xsl:text>
                            <fo:page-number/>
                          </fo:block>
                        </fo:table-cell>
                      </fo:table-row>
                    </fo:table-body>
                      </fo:table>  
                   </fo:block>    
                </fo:static-content>
              
              <fo:flow flow-name="xsl-region-body"> 
            <fo:block>
              <xsl:apply-templates select="Bill"/>
            </fo:block>       
              </fo:flow>
            </fo:page-sequence>
          </xsl:if>
          
        <xsl:if test="($bit='INV' or $bit='REC' or $bit='PCM')">
            <!-- content -->
            <fo:page-sequence master-name="A4" master-reference="A4">
      
              <fo:static-content flow-name="xsl-region-before">
                <xsl:call-template name="graphic"/>
              </fo:static-content>
      
              <fo:static-content flow-name="xsl-region-after">
                <fo:block>
              <fo:table table-layout="fixed" width="160mm">
                <fo:table-column column-width="30mm" column-number="1"/>
                  <fo:table-column column-width="100mm" column-number="2"/>
                    <fo:table-column column-width="30mm" column-number="3"/>
                        
                  <fo:table-body>
                    <fo:table-row>
                      <fo:table-cell>
                        <fo:block text-align="left">
                          <!-- drn as barcode -->
                          <fo:instream-foreign-object>
                            <xsl:call-template name="barcode-code128">
                              <xsl:with-param name="value" select="$drn"/>
                              <xsl:with-param name="string" select="$drn"/>
                            </xsl:call-template>
                          </fo:instream-foreign-object>
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <!-- footer invoicing party -->
                        <fo:block font-size="6pt" font-family="Times" text-align="center">
                          <xsl:for-each select="document(/Bill/Part/@File)/Document/AddressPage/InvParty">
                            <xsl:apply-templates select="."/>
                          </xsl:for-each>
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <!-- page x from y -->
                        <fo:block font-size="6pt" font-family="Times" text-align="right" padding-before="5mm">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','385')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                          <xsl:text> </xsl:text>
                          <fo:page-number/>
                        </fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                  </fo:table-body>
                    </fo:table>  
                  </fo:block>    
                </fo:static-content>
    
            <fo:flow flow-name="xsl-region-body"> 
              <fo:block>
                    <xsl:apply-templates select="Bill"/>
                  </fo:block>       
                </fo:flow>
              </fo:page-sequence>
    
              <fo:page-sequence master-reference="A4">
            <fo:static-content flow-name="xsl-region-before">
                      <xsl:call-template name="graphic"/>
                  </fo:static-content>
                        
              <fo:static-content flow-name="xsl-region-after">
                    <fo:block>
                  <fo:table table-layout="fixed" width="160mm">
                    <fo:table-column column-width="30mm" column-number="1"/>
                    <fo:table-column column-width="100mm" column-number="2"/>
                    <fo:table-column column-width="30mm" column-number="3"/>
                  <fo:table-body>
                    <fo:table-row>
                      <fo:table-cell>
                        <fo:block/>
                      </fo:table-cell>
                      <fo:table-cell>
                        <!-- footer invoicing party -->
                        <fo:block font-size="6pt" font-family="Times" text-align="center">
                          <xsl:for-each select="document(/Bill/Part/@File)/Document/AddressPage/InvParty">
                            <xsl:apply-templates select="."/>
                          </xsl:for-each>
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <!-- page x from y -->
                        <fo:block font-size="6pt" font-family="Times" text-align="right" padding-before="5mm">
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','385')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                          <xsl:text> </xsl:text>
                          <fo:page-number/>
                        </fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                  </fo:table-body>
                    </fo:table>  
                  </fo:block>    
                </fo:static-content>
                        
            <fo:flow flow-name="xsl-region-body">
              <fo:block>
                <!-- sum sheet -->
                <xsl:for-each select="document(/Bill/Part/@File)/Document/Summary/Sums">
                  <xsl:apply-templates select="."/>
                </xsl:for-each>
              </fo:block>
            </fo:flow>
              </fo:page-sequence>
    
          <xsl:for-each select="document(/Bill/Part/@File)/Document/Summary/CustRef">
            <xsl:sort select="@Id" data-type="text" order="ascending" /> 
            <xsl:sort select="BOPAlt/@BILLED" data-type="text" order="descending" />
            <fo:page-sequence master-reference="A4">    
              <fo:flow flow-name="xsl-region-body">
            <fo:block break-before="page" space-after="5mm">
              <xsl:apply-templates select="."/>
            </fo:block>
              </fo:flow>
            </fo:page-sequence>
         </xsl:for-each>
    
         <fo:page-sequence master-reference="A4">
           <fo:flow flow-name="xsl-region-body">
             <fo:block break-before="page">
               <!-- balance page -->
                   <xsl:for-each select="document(/Bill/Part/@File)/Document/BalancePage">
             <xsl:apply-templates select="."/>
               </xsl:for-each>
               <!-- bonus point statistic -->
               <xsl:for-each select="document(/Bill/Part/@File)/Document/InvoiceInfo/BPStat">
             <xsl:apply-templates select="."/>
               </xsl:for-each>
               <!-- promotion details -->
               <xsl:for-each select="document(/Bill/Part/@File)/Document/InvoiceInfo/PromoDetails">
             <xsl:apply-templates select="."/>
               </xsl:for-each>
               <!-- currency conversion info -->
               <xsl:for-each select="document(/Bill/Part/@File)/Document/InvoiceInfo">
             <xsl:apply-templates select="."/>
               </xsl:for-each>
             </fo:block>
               </fo:flow>
        </fo:page-sequence>
          </xsl:if>
    </xsl:if>
    </fo:root>
  </xsl:template>

  <!-- graphic embedding -->
  <xsl:template name="graphic">
    <fo:block text-align="center">
      <xsl:if test="$fmt='rtf'">
        <fo:external-graphic content-height="14mm" max-height="14mm" max-width="42.82mm" content-width="42.82mm" scaling="uniform" src="logo.jpg"/>
      </xsl:if>
      <xsl:if test="$fmt!='rtf'">
        <fo:external-graphic height="14mm" src="logo.jpg"/>
      </xsl:if>
    </fo:block>
  </xsl:template>

</xsl:stylesheet>
