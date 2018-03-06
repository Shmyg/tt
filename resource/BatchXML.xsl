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

  File:    BatchXML.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> XML stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet generates batches of XML documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/BatchXML.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">

  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <!-- input parameter -->
  <xsl:param name="SeqNo"/>

  <xsl:template match="/">

    <xsl:element name="Batch">

      <xsl:attribute name="SeqNo">
        <xsl:value-of select="$SeqNo"/>
      </xsl:attribute>

      <!-- copy all document nodes -->
      <xsl:for-each select="document(/Batch/Part/@File,/*)/node()">
        <xsl:copy-of select="."/>
      </xsl:for-each>
      
    </xsl:element>

  </xsl:template>

</xsl:stylesheet>
