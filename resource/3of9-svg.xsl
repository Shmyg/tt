<?xml version="1.0"?>

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
  
  File:    3of9-svg.xsl
  
  Owner:  M. Fehrenbacher
  
  @(#) ABSTRACT : XML -> SVG stylesheet
  @(#) BSCS iX R4, Bill Formatting Server
  
  This stylesheet draws type 3of9 / 3of9 extended barcodes.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/3of9-svg.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015
  
  Author: Alexander Peshkov <peshkov@renderx.com> (c) 2003, RenderX
  
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:svg="http://www.w3.org/2000/svg">

<!-- ========================================================= -->
<!-- This stylesheet exports a named template used to draw     -->
<!-- a 3 of 9 barcode (also known as code 39) as an SVG image. -->
<!-- When used stand-alone, it creates SVG from a code         -->
<!-- sequence passed in a parameter                            -->
<!--                                                           -->
<!-- Template "draw-barcode" can take a number of parameters,  -->
<!-- of which only the first one is mandatory:                 -->
<!--                                                           -->
<!--                     Mandatory parameters are:             -->
<!--                                                           -->
<!--  "sequence"        - sequence of barcode states           -->
<!--                      to be drawn.                         -->
<!--                                                           -->
<!--                      Optional parameters are:             -->
<!--                                                           -->
<!--  "string"          - a human readable string;             -->
<!--                      represents data encoded in           -->
<!--                      the barcode in a human-readable form -->
<!--                      Default is empty string.             -->
<!--  "print-text"      - boolean, defines if a human          -->
<!--                      readable label should be printed.    -->
<!--  "module"          - width of the elementary unit         -->
<!--                      bar/space;                           -->
<!--                      Default is 0.012in                   -->
<!--  "wide-to-narrow"  - width ratio for bars/spaces;         -->
<!--                      Default is 3.0                       -->
<!--  "height"          - pattern height (= bar length).       -->
<!--                      Default is 0.5in                     -->
<!--  "quiet-horizontal" - quiet zone horizontal margin width  -->
<!--                      Default is 0.24in                    -->
<!--  "quiet-vertical"   - quiet zone vertical margin width    -->
<!--                      Default is 0.12in                    -->
<!--  "font-family"     - a font family used to print textual  -->
<!--                      representation of a barcode.         -->
<!--                      Default is 'Courier'                 -->
<!--  "font-height"     - a height of the font used to print   -->
<!--                      textual representation of a barcode. -->
<!--                      Default is 10pt                      -->
<!-- ========================================================= -->
    
    <!-- Main template. -->
    <!-- Normalizes all lengths and calculates all widths/heights -->
    <!-- Creates SVG element, prints numerical barcode representation and recursevely draws all bars -->
    <xsl:template name="draw-barcode">
      <!-- Bar states code sequence -->
      <xsl:param name="sequence" select="''"/>
      <!-- Information encoded by given barcode states -->
      <xsl:param name="string" select="''"/>
      <!-- Is human readable string printed under barcode? -->
      <xsl:param name="print-text" select="'true'"/>
      <!-- Optional parameters for drawing -->
      <xsl:param name="module" select="'0.012in'"/>
      <xsl:param name="wide-to-narrow" select="3.0"/>
      <xsl:param name="height" select="'0.5in'"/>
      <xsl:param name="quiet-horizontal" select="'0.24in'"/>
      <xsl:param name="quiet-vertical" select="'0.12in'"/>
      <xsl:param name="font-family" select="'Courier'"/>
      <xsl:param name="font-height" select="'10pt'"/>
      
      <!-- Parse narrow bar/space width specifier -->
      <xsl:variable name="narrow-real">
        <xsl:call-template name="convert-to-basic-units">
          <xsl:with-param name="length" select="$module"/>
        </xsl:call-template>      
      </xsl:variable>

      <!-- Calculate wide bar/space width -->
      <xsl:variable name="wide-real" select="round($narrow-real * $wide-to-narrow)"/>

      <!-- Parse bar height specifier -->
      <xsl:variable name="height-real">
        <xsl:call-template name="convert-to-basic-units">
          <xsl:with-param name="length" select="$height"/>
        </xsl:call-template>      
      </xsl:variable>

      <!-- Parse quiet zone vertical/horizontal margins specifiers -->
      <xsl:variable name="quiet-horizontal-real">
        <xsl:call-template name="convert-to-basic-units">
          <xsl:with-param name="length" select="$quiet-horizontal"/>
        </xsl:call-template>      
      </xsl:variable>
      <xsl:variable name="quiet-vertical-real">
        <xsl:call-template name="convert-to-basic-units">
          <xsl:with-param name="length" select="$quiet-vertical"/>
        </xsl:call-template>      
      </xsl:variable>

      <!-- Calculate font height and line-height-->
      <xsl:variable name="font-height-real">
        <xsl:call-template name="convert-to-basic-units">
          <xsl:with-param name="length" select="$font-height"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="line-height-real" select="round($font-height-real*1.2)*number($print-text='true')"/>

      <!-- Useful variable - number of characters in code string -->
      <xsl:variable name="length">
        <xsl:value-of select="string-length($sequence) div 9"/>
      </xsl:variable>

      <!-- Calculate codesequence length -->
      <xsl:variable name="code-width-real" select="$wide-real*(3*$length) + $narrow-real*(6*$length + $length - 1)"/>
      
      <!-- Calculate drawing area dimensions -->
      <xsl:variable name="area-width-real" select="$code-width-real + 2*$quiet-horizontal-real"/>
      <xsl:variable name="area-height-real" select="$height-real + $line-height-real + 2*$quiet-vertical-real"/>
      
      <!-- Establish SVG drawing area -->
      <!-- Drawing unit is equal to 1/360mm -->
      <svg:svg width="{concat($area-width-real div 360, 'mm')}"
               height="{concat($area-height-real div 360, 'mm')}"
               viewBox="{concat('0 0 ', $area-width-real, ' ', $area-height-real)}">

        <!-- Prepare actual path-->
        <xsl:variable name="path">
          <!-- Call template to reqursively draw all bars -->
          <xsl:call-template name="recursive-draw">
            <xsl:with-param name="sequence" select="$sequence"/>
            <xsl:with-param name="narrow-real" select="$narrow-real"/>
            <xsl:with-param name="wide-real" select="$wide-real"/>
            <xsl:with-param name="height-real" select="$height-real"/>
          </xsl:call-template>
        </xsl:variable>
        
        <!-- Position a pen at the beggining of the barcode and make the actual drawing -->
        <xsl:variable name="full-path" select="concat('M ', $quiet-horizontal-real, ' ' , $quiet-vertical-real, $path)"/>
        <svg:path d="{$full-path}" fill="black"/>
        <xsl:if test="$print-text='true'">
          <svg:text x="{$area-width-real div 2}" y="{$quiet-vertical-real*2 + $height-real + $font-height-real}" text-anchor="middle" font-family="{$font-family}" font-size="{$font-height-real}" fill="black"><xsl:value-of select="$string"/></svg:text>
        </xsl:if>
      </svg:svg>
    </xsl:template>

    <!-- Draws single bar and calls itself if there are more bars to be drawn -->
    <xsl:template name="recursive-draw">
      <xsl:param name="sequence"/>
      <xsl:param name="narrow-real"/>
      <xsl:param name="wide-real"/>
      <xsl:param name="height-real"/>
      <xsl:param name="position" select="1"/>
              
      <xsl:variable name="barstate" select="substring($sequence, 1, 1)"/>

      <!-- Select bar width -->
      <xsl:variable name="width">
        <xsl:choose>
          <xsl:when test="$barstate=1"><xsl:value-of select="$wide-real"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="$narrow-real"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- Draw black or white bar -->
      <xsl:choose>
        <xsl:when test="$position mod 9 = 0 or (($position mod 9) mod 2) = 1">
          <!-- Create appropriate path segment -->  
          <xsl:value-of select="concat(' l 0 ', $height-real, ' ', $width, ' 0 0 -', $height-real, ' z m ', $width, ' 0')"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- Create appropriate path segment -->  
          <xsl:value-of select="concat(' m ', $width, ' 0')"/>
        </xsl:otherwise>
      </xsl:choose>
      
      <!-- Add intercharacter space -->
      <xsl:if test="($position mod 9) = 0 and string-length($sequence) &gt; 1">
          <!-- Create appropriate path segment -->  
          <xsl:value-of select="concat(' m ', $narrow-real, ' 0')"/>        
      </xsl:if>

      <xsl:if test="string-length($sequence) &gt; 1">
        <xsl:call-template name="recursive-draw">
            <xsl:with-param name="sequence" select="substring($sequence,2)"/>
            <xsl:with-param name="narrow-real" select="$narrow-real"/>
            <xsl:with-param name="wide-real" select="$wide-real"/>
            <xsl:with-param name="height-real" select="$height-real"/>
            <xsl:with-param name="position" select="$position + 1"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:template>


    <!-- Utility templates -->

    <!-- Convert any lengths to the basic units.                   -->

    <xsl:template name="convert-to-basic-units">
      <xsl:param name="length"/>

      <xsl:variable name="length-numeric-value" select="translate ($length, 'ptxcinme ', '')"/>
      <xsl:variable name="length-unit" select="translate ($length, '-0123456789. ', '')"/>

      <xsl:variable name="length-scale-factor">
        <xsl:call-template name="get-unit-scaling-factor">
          <xsl:with-param name="unit" select="$length-unit"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="round($length-numeric-value * $length-scale-factor)"/>
    </xsl:template>


    <!-- This template expresses all length units in 1/360s of mm. -->
    <!-- This is the largest unit in which both 1pt and 1 mm get   -->
    <!-- integer values. Also spellchecks length units.            -->

    <xsl:template name="get-unit-scaling-factor">
      <xsl:param name="unit"/>
    
      <xsl:choose>
        <xsl:when test="$unit = 'cm'">3600</xsl:when>
        <xsl:when test="$unit = 'mm'">360</xsl:when>
        <xsl:when test="$unit = 'in'">9144</xsl:when>
        <xsl:when test="$unit = 'pt'">127</xsl:when>
        <xsl:when test="$unit = 'pc'">1524</xsl:when>
        <xsl:when test="$unit = 'em'">
          <xsl:text>1524</xsl:text> <!-- defaulting to 12pt -->
          <xsl:message>
            [BARCODE GENERATOR] Units of 'em' should not be mixed with other units;
            assuming 1 em = 1 pica.
          </xsl:message>
        </xsl:when>
        <xsl:when test="$unit = 'ex'">
          <xsl:text>700</xsl:text>  <!-- defaulting to 12pt x 0.46 -->
          <xsl:message>
            [BARCODE GENERATOR] Units of 'ex' should not be mixed with other units;
            assuming 1 ex = 0.46 pica.
              </xsl:message>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>360</xsl:text>  <!-- defaulting to 1mm -->
          <xsl:message>
            [BARCODE GENERATOR] Unknown unit '<xsl:value-of select="$unit"/>' should not be mixed with other units;
            assuming 1 <xsl:value-of select="$unit"/> = 1 mm.
          </xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>

</xsl:stylesheet>