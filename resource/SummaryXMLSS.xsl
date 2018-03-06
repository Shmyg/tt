<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2012 Ericsson

  All rights reserved.

  File:    SummaryXMLSS.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> XMLSSL stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms sum sheet documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/SummaryXMLSS.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

  XML Spreadsheet Reference : http://msdn.microsoft.com/en-us/library/aa140066%28office.10%29.aspx

-->

<xsl:stylesheet version="1.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:html="http://www.w3.org/TR/REC-html40" 
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" 
 xmlns:o="urn:schemas-microsoft-com:office:office" 
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 exclude-result-prefixes="xsl">

  <xsl:key name="co-id" match="Contract" use="@Id"/>

  <xsl:variable name="call-details"   select="document(/Bill/Part/@File)/Document/CallDetails"/>
  <xsl:variable name="charge-details" select="document(/Bill/Part/@File)/Document/ChargeDetails"/>

  <!-- sum sheet -->
  <xsl:template match="Summary">

    <!-- customer -->
    <xsl:for-each select="CustRef">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

  </xsl:template>

  <!-- billing account owner -->
  <xsl:template match="CustRef">

    <!-- contract(s) -->
    <xsl:for-each select="Contract[generate-id(.)=generate-id(key('co-id',@Id)[1])]">
      <!-- contract sorting -->
      <xsl:sort select="@Id" data-type="text" order="ascending"/>
      <!-- contract type processing -->
      <xsl:for-each select="key('co-id',@Id)">
        <!-- billed alternative first -->
        <xsl:sort select="BOPAlt/@BILLED" data-type="text" order="descending"/>
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:for-each>

  </xsl:template>

  <!-- contract -->
  <xsl:template match="Contract">

    <xsl:variable name="co-id"   select="@Id"/>
    <xsl:variable name="bop-ind" select="@BOPInd"/>
    <xsl:variable name="billed"  select="BOPAlt/@BILLED"/>
    <xsl:variable name="bop-id"  select="BOPAlt/AggSet/Att/@Id"/>

    <ss:Worksheet ss:Name="{$co-id}">

      <ss:Table ss:ExpandedColumnCount="19" ss:DefaultColumnWidth="144">

        <!-- recurring charges -->
        <xsl:call-template name="print-charge-details">
          <xsl:with-param name="co-id"          select="$co-id"/>
          <xsl:with-param name="bopind"         select="@BOPInd"/>
          <xsl:with-param name="bopseqno"       select="BOPAlt/@BOPSeqNo"/>
          <xsl:with-param name="boptype"        select="BOPAlt/AggSet/Att/@Ty"/>
          <xsl:with-param name="charge-details" select="$charge-details"/>
          <xsl:with-param name="charge-type"    select="'A'"/>
        </xsl:call-template>

        <!-- one-time charges -->
        <xsl:call-template name="print-charge-details">
          <xsl:with-param name="co-id"          select="$co-id"/>
          <xsl:with-param name="bopind"         select="@BOPInd"/>
          <xsl:with-param name="bopseqno"       select="BOPAlt/@BOPSeqNo"/>
          <xsl:with-param name="boptype"        select="BOPAlt/AggSet/Att/@Ty"/>
          <xsl:with-param name="charge-details" select="$charge-details"/>
          <xsl:with-param name="charge-type"    select="'S'"/>
        </xsl:call-template>

        <!-- usage charges -->
        <xsl:call-template name="print-call-details">
          <xsl:with-param name="co-id"          select="$co-id"/>
          <xsl:with-param name="bopind"         select="@BOPInd"/>
          <xsl:with-param name="bopseqno"       select="BOPAlt/@BOPSeqNo"/>
          <xsl:with-param name="boptype"        select="BOPAlt/AggSet/Att/@Ty"/>
          <xsl:with-param name="call-details"   select="$call-details"/>
        </xsl:call-template>

      </ss:Table>

    </ss:Worksheet>

  </xsl:template>

</xsl:stylesheet>