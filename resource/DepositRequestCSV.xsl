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

  File:    DepositRequestCSV.xsl

  Owners:  Matthias Fehrenbacher
           Natalie Kather

  @(#) ABSTRACT : XML -> CSV stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms deposit requests.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/DepositRequestCSV.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bgh="http://www.lhsgroup.com/BSCS/BGH" xmlns:cur="http://www.unece.org/etrades/unedocs" exclude-result-prefixes="xsl cur bgh">

  <!-- deposit request -->
  <xsl:template match="DepositRequest">

    <xsl:variable name="inv-date-format">
      <xsl:call-template name="date-time-format">
        <xsl:with-param name="date" select="Date[@Type='INV']/@Date"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="due-date-format">
      <xsl:call-template name="date-time-format">
        <xsl:with-param name="date" select="Date[@Type='DUE_DATE']/@Date"/>
      </xsl:call-template>
    </xsl:variable>
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
            <xsl:for-each select="$txt"><!-- deposit request date -->
                <xsl:value-of select="key('txt-index','219')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
            <xsl:value-of select="$inv-date-format"/>
        </bgh:cell>
    </bgh:row>
      

    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
              <xsl:for-each select="$txt"><!-- payment due date -->
                <xsl:value-of select="key('txt-index','240')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
            <xsl:value-of select="$due-date-format"/>
        </bgh:cell>
    </bgh:row>
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
            <!-- contract -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','220')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
            <xsl:value-of select="@CoId"/>
        </bgh:cell>
    </bgh:row>
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
                <xsl:for-each select="$txt"><!-- amount to pay -->
                  <xsl:value-of select="key('txt-index','226')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
            <xsl:for-each select="Charge">
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
    <bgh:row/>


    <xsl:if test="ChargePerCS">

        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                <xsl:for-each select="$txt"><!-- Service -->
                  <xsl:value-of select="key('txt-index','221')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <xsl:for-each select="$txt"><!-- Package -->
                  <xsl:value-of select="key('txt-index','222')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <xsl:for-each select="$txt"><!-- Tariff Model -->
                  <xsl:value-of select="key('txt-index','223')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <xsl:for-each select="$txt"><!-- Profile -->
                  <xsl:value-of select="key('txt-index','224')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <xsl:for-each select="$txt"><!-- Amount to pay -->
                  <xsl:value-of select="key('txt-index','225')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
        </bgh:row>
        
        
          <xsl:for-each select="ChargePerCS">
            
              <xsl:apply-templates select="."/>
            
          </xsl:for-each>
        
        <bgh:row/>
    </xsl:if>

  </xsl:template>

  <!-- charge per contracted service -->
  <xsl:template match="ChargePerCS">

    <bgh:row>
        <bgh:cell/>
    
        <xsl:apply-templates select="CS"/>
    
        <bgh:cell>
            <xsl:for-each select="Charge">
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

  <!-- contracted service -->
  <xsl:template match="CS">

    <bgh:cell>  
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@SN"/>
          <xsl:with-param name="Type"  select="'SN'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
    </bgh:cell>
    <bgh:cell>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@SP"/>
          <xsl:with-param name="Type"  select="'SP'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
    </bgh:cell>
    <bgh:cell>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@TM"/>
          <xsl:with-param name="Type"  select="'TM'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
    </bgh:cell>
    <bgh:cell>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@PRO"/>
          <xsl:with-param name="Type"  select="'PRO'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
    </bgh:cell>
    
  </xsl:template>

</xsl:stylesheet>
