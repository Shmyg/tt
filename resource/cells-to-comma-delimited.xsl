<?xml version='1.0' encoding="UTF-8"?>

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

  File:    cells-to-comma-delimited.xsl

  Owner:   Matthias Fehrenbacher
           Natalie Kather

  @(#) ABSTRACT : XML -> CSV stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms rows / cells to CSV.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/cells-to-comma-delimited.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bgh="http://www.lhsgroup.com/BSCS/BGH" xmlns:exsl="http://exslt.org/common" xmlns:str="http://exslt.org/strings" extension-element-prefixes="exsl str" exclude-result-prefixes="xsl bgh exsl">

    <xsl:output method="text" encoding="UTF-8" />    
    
    <xsl:variable name="dev-mode" select="'off'"/><!-- 'on' to enable development mode -->
    <!--
    "Development mode" means  to print the intermediate XML file instead of the final CSV.
    This may be useful to find errors during development or defect fixing.

    To switch ON the development mode:
    - Set global variable $dev-mode (see above) to 'on'
    - Set output method (see above) to "xml"
    
    To switch OFF the development mode:
    - Set global variable $dev-mode to any value != 'on', e.g. 'off'
    - Set output method to "text"
    -->
    
    <!-- delimiter for csv file -->
    <xsl:variable name="delimiter" select="','"/>
    
    <xsl:variable name="linebreak" select="'&#xa;'"/>
    
    <xsl:variable name="text-qualifier" select="'&quot;'"/>
    <xsl:variable name="text-qualifier-replace" select="'&quot;&quot;'"/>
        
    <!-- root element -->
    <xsl:template match="/">
        
        <xsl:choose>
            <xsl:when test="$dev-mode != 'on'">
                <!-- normal mode for production: print csv -->
                <!-- load intermediate output to variable -->
                <xsl:variable name="rows">
                    <xsl:apply-templates select="*" />
                </xsl:variable>
                <xsl:variable name="rows-nodeset" select="exsl:node-set($rows)/bgh:rows[1]"/>
                <xsl:apply-templates select="$rows-nodeset/bgh:row" />
                               
            </xsl:when>
            <xsl:otherwise>
                <!-- development mode: print intermediate XML -->                
                <xsl:apply-templates select="*" />                
            </xsl:otherwise>
        </xsl:choose>
            
    </xsl:template>
       
    <!-- row -->
    <xsl:template match="bgh:row">
    
        <!-- apply templates for cells -->
        <xsl:apply-templates />

        <!-- insert a line break at the end -->
        <xsl:value-of select="$linebreak"/>
    
    </xsl:template>
        
    <!-- cell -->
    <xsl:template match="bgh:cell">
    
        <xsl:if test="text()">
            <!-- print text node, if there is one -->            
            <xsl:value-of select="$text-qualifier"/>
            <xsl:value-of select="translate(., $text-qualifier, $text-qualifier-replace)" />
            <xsl:value-of select="$text-qualifier"/>
            
            <!--
            <xsl:call-template name="str:replace">
                <xsl:with-param name="string" select="@value" />
                <xsl:with-param name="search" select="$delimiter" />
                <xsl:with-param name="replace" select="$delimiter-replace" />
            </xsl:call-template>
            -->
            
        </xsl:if>
        
        <xsl:if test="position()!=last()">
            <xsl:value-of select="$delimiter" /><xsl:text/>
        </xsl:if>
    
    </xsl:template>
    
</xsl:stylesheet>
