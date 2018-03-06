<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2012 Ericsson

  All rights reserved.

  File:    Bill.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> HTML stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms master documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/Bill.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

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

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" xmlns:svg="http://www.w3.org/2000/svg" xmlns:svgu="http://www.ora.com/XSLTCookbook/ns/svg-utils" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="xsl cur svg svgu set">

  <xsl:output method="html" encoding="UTF-8" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="no"/>

  <xsl:strip-space elements="*"/>

  <xsl:include href="BillingDocument.xsl"/>

  <!-- at the moment EN and DE are supported -->
  <xsl:param name="lang"/>
  <!-- legend file -->
  <xsl:param name="lgn"/>
  <!-- document reference number -->
  <xsl:param name="drn"/>
  <!-- bill type -->
  <xsl:param name="bit"/>
  <!-- document format -->
  <xsl:param name="fmt"/>
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
  
  
  <!-- mapping keys (legend, fixtext, udr-attributes) -->
  <xsl:key name="id-index"   match="TypeDesc" use="@Id"/>
  <xsl:key name="txt-index"  match="Text"     use="@Id"/>
  <xsl:key name="xcd-index"  match="XCD"      use="@Id"/>
  <xsl:key name="rdd-index"  match="RDD"      use="@Id"/>
  <xsl:key name="fup-index"  match="FUP"      use="@Id"/>
  <xsl:key name="pkey-index" match="TypeDesc" use="@PKey"/>

  <!-- root -->
  <xsl:template match="/">
    <html>
      <head>
        <title>
         <xsl:for-each select="$txt">
           <xsl:value-of select="key('txt-index','0')[@xml:lang=$lang]/@Des"/>
         </xsl:for-each>
        </title>
        <!-- to render SVG objects (pie chart's, barcode's) you need IE >= 5.5 and the plugin
             Adobe SVG Viewer, see http://www.adobe.com/svg -->
        <object id="AdobeSVG" classid="clsid:78156a80-c6a1-4bbf-8e6a-3cd390eeb4e2"/>
        <xsl:processing-instruction name="import">
          <xsl:text>namespace="svg" implementation="#AdobeSVG"</xsl:text>
        </xsl:processing-instruction>
      </head>
      <body>
        <font face="verdana" size="-1">
          <!-- logo -->
          <center><h1>
            <img src="http://www.lhsgroup.com/fileadmin/lhsgroup.com/images/cms/lhs_logo.jpg" alt="logo"/>
          </h1></center>
          <!-- process the documents -->
          <xsl:apply-templates select="Bill"/>
        </font>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
