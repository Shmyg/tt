<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2012 Ericsson

  All rights reserved.

  File:    BillingDocumentXMLSS.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> XMLSS stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms billing documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/BillingDocumentXMLSS.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

  XML Spreadsheet Reference : http://msdn.microsoft.com/en-us/library/aa140066%28office.10%29.aspx

-->

<xsl:stylesheet version="1.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:html="http://www.w3.org/TR/REC-html40" 
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" 
 xmlns:o="urn:schemas-microsoft-com:office:office" 
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 exclude-result-prefixes="xsl">

  <xsl:include href="AddressPageXMLSS.xsl"/>
  <xsl:include href="CommonXMLSS.xsl"/>
  <xsl:include href="InvoiceXMLSS.xsl"/>
  <xsl:include href="SummaryXMLSS.xsl"/>
  <xsl:include href="CallDetailsXMLSS.xsl"/>

  <xsl:template match="Bill">

    <xsl:variable name="name" select="concat($bit,$drn)"/>

    <ss:Worksheet ss:Name="{$name}">

      <ss:Table ss:ExpandedColumnCount="9" ss:DefaultColumnWidth="144">

        <!-- header/billing account -->
        <xsl:for-each select="document(/Bill/Part/@File)/Document/AddressPage/BillAcc">
          <xsl:apply-templates select="."/>
        </xsl:for-each>

        <ss:Row/>
        <ss:Row/>

        <!-- advertisement -->
        <xsl:for-each select="document(/Bill/Part/@File)/Document/InvoiceInfo/AdvTxt">
          <ss:Row>
            <ss:Cell ss:MergeAcross="3"/>
            <ss:Cell ss:StyleID="s11">
              <ss:Data ss:Type="String">               
                <xsl:value-of select="."/>
              </ss:Data>
            </ss:Cell>
            <ss:Cell ss:MergeAcross="3"/>
          </ss:Row>
        </xsl:for-each>

        <!-- invoice/reconciliation/partner credit memo -->
        <xsl:for-each select="document(/Bill/Part/@File)/Document/Invoice">
      
          <ss:Row>
            <ss:Cell ss:MergeAcross="3"/>
            <ss:Cell ss:StyleID="s14">
              <ss:Data ss:Type="String">
                <xsl:choose>
                  <xsl:when test="$bit='INV'">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','52')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:when test="$bit='REC'">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','396')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:when test="$bit='PCM'">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','441')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </xsl:when>
                  <!-- debit note -->
                  <xsl:when test="$bit='DN'">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','529')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise/>
                </xsl:choose>
                <!-- mark bill as copy -->
                <xsl:if test="$cflag = 'X'">
                  <xsl:text> - </xsl:text>
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','525')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>          
                </xsl:if>        
              </ss:Data>
            </ss:Cell>
            <ss:Cell ss:MergeAcross="3"/>
          </ss:Row>
          <ss:Row/>
          <xsl:apply-templates select="."/>

        </xsl:for-each>

      </ss:Table>

    </ss:Worksheet>

    <!-- contracts -->
    <xsl:if test="($bit='INV' or $bit='REC' or $bit='PCM')">
      <xsl:for-each select="document(/Bill/Part/@File)/Document/Summary">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:if>

  </xsl:template>

</xsl:stylesheet>