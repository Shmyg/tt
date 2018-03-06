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

  File:    CollectionReportCSV.xsl

  Owners:  Matthias Fehrenbacher
           Natalie Kather

  @(#) ABSTRACT : XML -> CSV stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms collection reports.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/CollectionReportCSV.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bgh="http://www.lhsgroup.com/BSCS/BGH" xmlns:cur="http://www.unece.org/etrades/unedocs" exclude-result-prefixes="xsl cur bgh">

  <!-- collection report -->
  <xsl:template match="CollectionReport">
    
    <bgh:row>
        <bgh:cell>
          <xsl:for-each select="$txt"><!-- Collection Report -->
            <xsl:value-of select="key('txt-index','432')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </bgh:cell>
    </bgh:row>

    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
            <!-- total period -->
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','433')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
              <!-- period start -->
              <xsl:if test="Date[@Type='START']">
                <xsl:call-template name="date-format">
                  <xsl:with-param name="date" select="Date[@Type='START']/@Date"/>
                </xsl:call-template>
              </xsl:if>
              <xsl:if test="Date[@Type='END']">
                <xsl:text> - </xsl:text>
                <!-- period end -->
                <xsl:call-template name="date-format">
                  <xsl:with-param name="date" select="Date[@Type='END']/@Date"/>
                </xsl:call-template>
              </xsl:if>
        </bgh:cell>
    </bgh:row>
    <bgh:row/>
    

    <!-- BSCS iX R3, R4 -->
    <xsl:for-each select="CollectionDataPerBu">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    
    <!-- BSCS iX R2 -->
    <xsl:for-each select="CollectionDataPerCo">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    
  </xsl:template>
  

  <!-- collected data per business unit -->
  <xsl:template match="CollectionDataPerBu">
    
    <bgh:row>
        <bgh:cell>
              <!-- business unit -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','495')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="@BuShdes"/>
                <xsl:with-param name="Type"  select="'BU'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>  
        </bgh:cell>
    </bgh:row>
    <bgh:row/>

    <xsl:for-each select="CollectionDataPerCo">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    

  </xsl:template>
  

  <!-- collected data per contract -->
  <xsl:template match="CollectionDataPerCo">
    
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
              <!-- customer id -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','434')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
            <xsl:value-of select="@CustId"/>
        </bgh:cell>
    </bgh:row>
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
            <!-- contract id -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','435')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
            <xsl:value-of select="@CoId"/>
        </bgh:cell>
    </bgh:row>
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
            <!-- billed amount -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','436')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
              <xsl:variable name="number-format-705">
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="Charge[@Id='705']/@Amount"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:value-of select="$number-format-705"/>
              <xsl:text> </xsl:text>
              <xsl:call-template name="currency">
                <xsl:with-param name="CurrCode" select="Charge[@Id='705']/@CurrCode"/>
              </xsl:call-template>
        </bgh:cell>
    </bgh:row>
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
            <!-- paid amount -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','437')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
              <xsl:variable name="number-format-706">
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="Charge[@Id='706']/@Amount"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:value-of select="$number-format-706"/>
              <xsl:text> </xsl:text>
              <xsl:call-template name="currency">
                <xsl:with-param name="CurrCode" select="Charge[@Id='706']/@CurrCode"/>
              </xsl:call-template>
        </bgh:cell>
    </bgh:row>
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
            <!-- open amount -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','438')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
              <xsl:variable name="number-format-707">
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="Charge[@Id='706']/@Amount"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:value-of select="$number-format-707"/>
              <xsl:text> </xsl:text>
              <xsl:call-template name="currency">
                <xsl:with-param name="CurrCode" select="Charge[@Id='707']/@CurrCode"/>
              </xsl:call-template>
        </bgh:cell>
    </bgh:row>
    
    <xsl:if test="CollectionDataPerSN">
      
        <bgh:row/>
        <bgh:row>
        <bgh:cell/>
            <bgh:cell/>
            <bgh:cell>
                <!-- article -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','439')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <!-- service -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','440')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <!-- billed amount -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','436')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <!-- paid amount -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','437')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <!-- open amount -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','438')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
        </bgh:row>
        
          <xsl:for-each select="CollectionDataPerSN">
              <xsl:apply-templates select="."/>
          </xsl:for-each>
      
    </xsl:if>
    
    <bgh:row/>
    
  </xsl:template>

  <!-- collected data per service -->
  <xsl:template match="CollectionDataPerSN">
  
    <bgh:row>
        <bgh:cell/>
        <bgh:cell/>
        <bgh:cell>
            <!-- article -->
            <xsl:value-of select="@AS"/>
        </bgh:cell>
        <bgh:cell>
            <!-- service -->
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="@SN"/>
              <xsl:with-param name="Type"  select="'SN'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
        </bgh:cell>
        <bgh:cell>
            <!-- billed amount -->
            <xsl:variable name="number-format-705">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="Charge[@Id='705']/@Amount"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$number-format-705"/>
            <xsl:text> </xsl:text>
              <xsl:call-template name="currency">
                <xsl:with-param name="CurrCode" select="Charge[@Id='705']/@CurrCode"/>
              </xsl:call-template>
        </bgh:cell>
        <bgh:cell>
            <!-- paid amount -->
            <xsl:variable name="number-format-706">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="Charge[@Id='706']/@Amount"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$number-format-706"/>
            <xsl:text> </xsl:text>
              <xsl:call-template name="currency">
                <xsl:with-param name="CurrCode" select="Charge[@Id='706']/@CurrCode"/>
              </xsl:call-template>
        </bgh:cell>
        <bgh:cell>
            <!-- open amount -->
            <xsl:variable name="number-format-707">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="Charge[@Id='707']/@Amount"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$number-format-707"/>
            <xsl:text> </xsl:text>
              <xsl:call-template name="currency">
                <xsl:with-param name="CurrCode" select="Charge[@Id='707']/@CurrCode"/>
              </xsl:call-template>
        </bgh:cell>
    </bgh:row>
    
  </xsl:template>

</xsl:stylesheet>