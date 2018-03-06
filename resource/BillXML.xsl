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

  File:    BillXML.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> XML stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet assemblies XML documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/BillXML.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">

  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <!-- input parameter -->
  <xsl:param name="lang"/>
  <xsl:param name="drn"/>
  <xsl:param name="bit"/>
  <xsl:param name="fmt"/>
  <xsl:param name="rst"/>
  <xsl:param name="ind"/>
  <xsl:param name="bu"/>
  <xsl:param name="ppm"/>

  <xsl:template match="/">

    <xsl:element name="Bill">

      <xsl:element name="Header">

        <!-- document reference number -->
        <xsl:attribute name="RefNum">
          <xsl:value-of select="$drn"/>
        </xsl:attribute>
        <!-- business unit -->
        <xsl:attribute name="BU">
          <xsl:value-of select="$bu"/>
        </xsl:attribute>
        <!-- document format -->
        <xsl:attribute name="Format">
          <xsl:value-of select="$fmt"/>
        </xsl:attribute>
        <!-- language -->
        <xsl:attribute name="xml:lang">
          <xsl:if test="$bit != 'LEG'">
            <xsl:value-of select="$lang"/>
          </xsl:if>
        </xsl:attribute>
        <!-- retrieval status -->
        <xsl:attribute name="RetStat">
          <xsl:value-of select="$rst"/>
        </xsl:attribute>
        <!-- indicator -->
        <xsl:attribute name="Ind">
          <xsl:value-of select="$ind"/>
        </xsl:attribute>
        <!-- document type -->
        <xsl:attribute name="Type">
          <xsl:value-of select="$bit"/>
        </xsl:attribute>
        <!-- postprocessing method (Letter,Email,SMS) -->
        <xsl:attribute name="PostprocMethod">
          <xsl:if test="$bit != 'LEG'">
            <xsl:value-of select="$ppm"/>
          </xsl:if>
        </xsl:attribute>        
      </xsl:element>

      <!-- copy all document nodes -->
      <xsl:for-each select="document(/Bill/Part/@File,/*)/node()">
        <xsl:copy-of select="."/>
      </xsl:for-each>

    </xsl:element>

  </xsl:template>

</xsl:stylesheet>
