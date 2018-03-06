<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2012 Ericsson

  All rights reserved.

  File:    BillTXT.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> TXT stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms master documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/BillTXT.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

  Additional available functions !

  Namespace:  xmlns:external="http://ExternalFunction.xalan-c++.xml.apache.org"
  Functions:  external:asctime()
              external:square-root(number)
              external:cube(number)
              external:sin(number)
              external:cos(number)
              external:tan(number)
              external:exp(number)
              external:log(number)
              external:log10(number)
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">

  <xsl:output method="text" encoding="UTF-8" indent="no"/>
  <xsl:strip-space elements="*"/>

  <xsl:include href="BillingDocumentTXT.xsl"/>

  <!-- at the moment EN and DE are supported -->
  <xsl:param name="lang"/>
  <!-- legend file -->
  <xsl:param name="lgn"/>
  <!-- bill type -->
  <xsl:param name="bit"/>
  <!-- document format -->
  <xsl:param name="fmt"/>

  <!-- configuration files -->
  <xsl:variable name="legend" select="document($lgn)"/>
  <xsl:variable name="txt"    select="document(concat('Fixtext_',$lang,'.xml'))"/>
  <xsl:variable name="xcd"    select="document(concat('XCD_',$lang,'.xml'))"/>
  <xsl:variable name="fup"    select="document(concat('FUP_',$lang,'.xml'))"/>

  <xsl:variable name="line-feed">
    <xsl:text>
</xsl:text>
  </xsl:variable>

  <!-- mapping keys (legend, fixtext, udr-attributes) -->
  <xsl:key name="id-index"   match="TypeDesc" use="@Id"/>
  <xsl:key name="txt-index"  match="Text"     use="@Id"/>
  <xsl:key name="xcd-index"  match="XCD"      use="@Id"/>
  <xsl:key name="fup-index"  match="FUP"      use="@Id"/>
  <xsl:key name="pkey-index" match="TypeDesc" use="@PKey"/>

  <!-- root -->
  <xsl:template match="/">
    <!-- process the documents -->
    <xsl:apply-templates select="Bill"/>
  </xsl:template>

</xsl:stylesheet>
