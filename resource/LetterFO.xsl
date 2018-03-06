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

  File:    LetterFO.xsl

  Owners:  M. Fehrenbacher

  @(#) ABSTRACT : XML -> XSL-FO stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms letters.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/LetterFO.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">

  <!-- order management letter -->

  <xsl:template match="Letter">

      <!-- title -->
      <fo:block font-size="9pt" font-family="Times" font-weight="bold" text-align="center">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','500')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </fo:block>
      <!-- date -->
      <fo:block font-size="8pt" font-family="Times" font-weight="bold">
        <xsl:choose>
          <xsl:when test="$lang = 'EN'">
            <xsl:text>Date </xsl:text>
          </xsl:when>
          <xsl:when test="$lang = 'DE'">
            <xsl:text>Datum</xsl:text>
          </xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
        <xsl:text> </xsl:text>
        <xsl:call-template name="date-format">
          <xsl:with-param name="date" select="Date[@Type='GEN']/@Date"/>
        </xsl:call-template>
      </fo:block>
      <!-- document text -->
      <xsl:for-each select="DocumentText">
        <fo:block font-size="8pt" font-family="Times" text-align="center">
          <xsl:value-of select="@Text"/>
        </fo:block>
      </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>
