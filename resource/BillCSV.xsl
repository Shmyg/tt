<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2012 Ericsson

  All rights reserved.

  File:    BillCSV.xsl

  Owners:  Matthias Fehrenbacher
           Natalie Kather

  @(#) ABSTRACT : XML -> CSV stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms master documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/BillCSV.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

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
              
  The stylesheets first generate an intermediate document of the following structure:

  <bgh:rows>
    <bgh:row>
        <bgh:cell>Text 1</bgh:cell>
        <bgh:cell>Text 2</bgh:cell>
        ...
    </bgh:row>
    <bgh:row>
        ...
    </bgh:row>
    ...
  </bgh:rows>

  In the second step, this intermediate document is tranformed into the final format, CSV.

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" xmlns:set="http://exslt.org/sets" xmlns:bgh="http://www.lhsgroup.com/BSCS/BGH" xmlns:date="http://exslt.org/dates-and-times" exclude-result-prefixes="xsl cur set bgh date">

  <!--<xsl:output method="xml" encoding="UTF-8" indent="no"/>-->
  <xsl:strip-space elements="*"/>
  <!-- at the moment EN and DE are supported -->
  <xsl:param name="lang"/>
  <!-- legend file -->
  <xsl:param name="lgn"/>
  <!-- document reference number -->
  <xsl:param name="drn"/>
  <!-- document reference number -->
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
  
  <xsl:include href="BillingDocumentCSV.xsl"/>

  <!-- mapping keys (legend, fixtext, udr-attributes) -->
  <xsl:key name="id-index" match="TypeDesc" use="@Id"/>
  <xsl:key name="txt-index" match="Text" use="@Id"/>
  <xsl:key name="xcd-index" match="XCD" use="@Id"/>
  <xsl:key name="rdd-index" match="RDD" use="@Id"/>
  <xsl:key name="fup-index" match="FUP" use="@Id"/>
  <xsl:key name="pkey-index" match="TypeDesc" use="@PKey"/>
  
  <!-- '1' : prints currency symbols such as '€'
       '0' : prints currency acronyms such as 'EUR'   -->
  <xsl:variable name="use-currency-symbols" select="'0'" />
  
    <xsl:include href="cells-to-comma-delimited.xsl" />
    
    <!-- temporary root element -->
    <!--<xsl:template match="/">
        <xsl:apply-templates select="./*" />
    </xsl:template>-->
  
  
  
  
  
    <!-- "Bill" template is in BillingDocumentCSV.xsl -->


</xsl:stylesheet>
