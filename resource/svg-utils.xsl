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

  File:    svg-utils.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> SVG stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet embeds SVG pie charts.
  VERSION = %VI%

  Either EXSLT functions or additional available functions for Xalan C++ !

  Namespaces: xmlns:math="http://exslt.org/math"
              xmlns:external="http://ExternalFunction.xalan-c++.xml.apache.org"
              
  Functions:  math:sin()
              math:cos()
              ...
              external:asctime()
              external:square-root()
              external:cube()
              external:sin()
              external:cos()
              external:tan()
              external:exp()
              external:log()
              external:log10()
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:svg="http://www.w3.org/2000/svg" xmlns:svgu="http://www.ora.com/XSLTCookbook/ns/svg-utils" xmlns:external="http://ExternalFunction.xalan-c++.xml.apache.org" xmlns:math="http://exslt.org/math" exclude-result-prefixes="xsl svg svgu external math">

  <svgu:color>red</svgu:color>
  <svgu:color>orange</svgu:color>
  <svgu:color>yellow</svgu:color>
  <svgu:color>green</svgu:color>
  <svgu:color>blue</svgu:color>
  <svgu:color>lime</svgu:color>
  <svgu:color>aqua</svgu:color>
  <svgu:color>teal</svgu:color>
  <svgu:color>brown</svgu:color>
  <svgu:color>black</svgu:color>

  <xsl:variable name="svgu:pi" select="3.14159265358979323846"/>

  <xsl:template name="svgu:pie">
    <xsl:param name="data" select="/.."/>  <!-- node set of numbers to chart -->
    <xsl:param name="cx" select="100"/>    <!-- center x -->
    <xsl:param name="cy" select="100"/>    <!-- center y -->
    <xsl:param name="r" select="50"/>      <!-- radius -->
    <xsl:param name="theta" select="-90"/> <!-- beginning angle for first slice in degrees-->
    <xsl:param name="context"/>            <!-- user data to identify this invocation -->

    <xsl:call-template name="svgu:pieImpl">
      <xsl:with-param name="data" select="$data"/>
      <xsl:with-param name="cx" select="$cx"/>
      <xsl:with-param name="cy" select="$cy"/>
      <xsl:with-param name="r" select="$r"/>
      <xsl:with-param name="theta" select="$theta"/>
      <xsl:with-param name="sum" select="sum($data)"/>
      <xsl:with-param name="context" select="$context"/>
    </xsl:call-template>

  </xsl:template>

  <xsl:template name="svgu:pieImpl">
    <xsl:param name="data" />
    <xsl:param name="cx" />
    <xsl:param name="cy" />
    <xsl:param name="r" />
    <xsl:param name="theta"/>
    <xsl:param name="sum"/>
    <xsl:param name="context"/>
    <xsl:param name="i" select="1"/>

    <xsl:if test="count($data) >= $i">
      <xsl:variable name="delta" select="($data[$i] * 360) div $sum"/>

      <!-- draw slice of pie -->
      <xsl:call-template name="svgu:pieSlice">
        <xsl:with-param name="cx" select="$cx"/>
        <xsl:with-param name="cy" select="$cy"/>
        <xsl:with-param name="r" select="$r"/>
        <xsl:with-param name="theta" select="$theta"/>
        <xsl:with-param name="delta" select="$delta"/>
        <xsl:with-param name="style">
          <xsl:call-template name="svgu:pieSliceStyle">
            <xsl:with-param name="i" select="$i"/>
            <xsl:with-param name="context" select="$context"/>
          </xsl:call-template>
        </xsl:with-param>
        <xsl:with-param name="num" select="$i"/>
        <xsl:with-param name="context" select="$context"/>
      </xsl:call-template>

      <!-- recursive call for next slice -->
        <xsl:call-template name="svgu:pieImpl">
          <xsl:with-param name="data" select="$data"/>
          <xsl:with-param name="cx" select="$cx"/>
          <xsl:with-param name="cy" select="$cy"/>
          <xsl:with-param name="r" select="$r"/>
          <xsl:with-param name="theta" select="$theta + $delta"/>
          <xsl:with-param name="sum" select="$sum"/>
          <xsl:with-param name="context" select="$context"/>
          <xsl:with-param name="i" select="$i + 1"/>
        </xsl:call-template>
    </xsl:if>

  </xsl:template>

  <xsl:template name="svgu:pieSlice">
    <xsl:param name="cx" select="100"/>    <!-- center x -->
    <xsl:param name="cy" select="100"/>    <!-- center y -->
    <xsl:param name="r" select="50"/>      <!-- radius -->
    <xsl:param name="theta" select="0"/>   <!-- beginning angle in degrees-->
    <xsl:param name="delta" select="90"/>  <!-- arc extent in degrees -->
    <xsl:param name="phi" select="0"/>     <!-- x-axis rotation angle -->
    <xsl:param name="style" select=" 'fill: red;' "/>
    <xsl:param name="num"/>
    <xsl:param name="context"/>

    <!-- convert angles to radians -->
    <xsl:variable name="theta1" select="$theta * $svgu:pi div 180"/>
    <xsl:variable name="theta2" select="($delta + $theta) * $svgu:pi div 180"/>
    <xsl:variable name="phi_r" select="$phi * $svgu:pi div 180"/>

    <!-- figure out begin and end coordinates -->
    <xsl:variable name="x0">
        <xsl:choose>
            <xsl:when test="function-available('math:sin') and function-available('math:cos')">
                <xsl:value-of select="$cx + math:cos($phi_r) * $r * math:cos($theta1) + math:sin(-$phi_r) * $r * math:sin($theta1)"/>
            </xsl:when>
            <xsl:when test="function-available('external:sin') and function-available('external:cos')">
                <xsl:value-of select="$cx + external:cos($phi_r) * $r * external:cos($theta1) + external:sin(-$phi_r) * $r * external:sin($theta1)"/>
            </xsl:when>            
            <xsl:otherwise>
                <xsl:value-of select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="y0">
        <xsl:choose>
            <xsl:when test="function-available('math:sin') and function-available('math:cos')">
                <xsl:value-of select="$cy + math:sin($phi_r) * $r * math:cos($theta1) + math:cos($phi_r) * $r * math:sin($theta1)"/>
            </xsl:when>
            <xsl:when test="function-available('external:sin') and function-available('external:cos')">
                <xsl:value-of select="$cy + external:sin($phi_r) * $r * external:cos($theta1) + external:cos($phi_r) * $r * external:sin($theta1)"/>
            </xsl:when>            
            <xsl:otherwise>
                <xsl:value-of select="0"/>
            </xsl:otherwise>            
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="x1">
        <xsl:choose>
            <xsl:when test="function-available('math:sin') and function-available('math:cos')">
                <xsl:value-of select="$cx + math:cos($phi_r) * $r * math:cos($theta2) + math:sin(-$phi_r) * $r * math:sin($theta2)"/>
            </xsl:when>
            <xsl:when test="function-available('external:sin') and function-available('external:cos')">
                <xsl:value-of select="$cx + external:cos($phi_r) * $r * external:cos($theta2) + external:sin(-$phi_r) * $r * external:sin($theta2)"/>
            </xsl:when>            
            <xsl:otherwise>
                <xsl:value-of select="0"/>
            </xsl:otherwise>            
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="y1">
        <xsl:choose>
            <xsl:when test="function-available('math:sin') and function-available('math:cos')">
                <xsl:value-of select="$cy + math:sin($phi_r) * $r * math:cos($theta2) + math:cos($phi_r) * $r * math:sin($theta2)"/>
            </xsl:when>
            <xsl:when test="function-available('external:sin') and function-available('external:cos')">
                <xsl:value-of select="$cy + external:sin($phi_r) * $r * external:cos($theta2) + external:cos($phi_r) * $r * external:sin($theta2)"/>
            </xsl:when>            
            <xsl:otherwise>
                <xsl:value-of select="0"/>
            </xsl:otherwise>            
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="large-arc" select="($delta > 180) * 1"/>
    <xsl:variable name="sweep" select="($delta > 0) * 1"/>

    <svg:path style="{$style}" id="{$context}_pieSlice_{$num}">
      <xsl:attribute name="d">
        <xsl:value-of select="concat('M ', $x0,' ',$y0,' A ', $r,' ',$r,',',$phi,',',$large-arc,',',$sweep,',',$x1,' ',$y1,' L ',$cx,' ',$cy,' L ', $x0,' ',$y0)"/>
      </xsl:attribute>
    </svg:path>
  </xsl:template>

  <xsl:template name="svgu:pieSliceLabel">
    <xsl:param name="label" />              <!-- label -->
    <xsl:param name="cx" select="100"/>     <!-- center x -->
    <xsl:param name="cy" select="100"/>     <!-- center y -->
    <xsl:param name="r" select="50"/>       <!-- radius -->
    <xsl:param name="theta" select="0"/>    <!-- beginning angle in degrees-->
    <xsl:param name="delta" select="90"/>   <!-- arc extent in degrees -->
    <xsl:param name="style" select=" 'font-size: 7; font-family: Helvetica' "/>
    <xsl:param name="num"/>
    <xsl:param name="context"/>
    <xsl:param name="sum"/>

    <!-- convert angles to radians -->
    <xsl:variable name="theta2" select="(($delta + $theta) mod 360 + 360) mod 360"/> <!-- normalize angles -->
    <xsl:variable name="theta2_r" select="$theta2 * $svgu:pi div 180"/>

    <xsl:variable name="x">
        <xsl:choose>
            <xsl:when test="function-available('math:cos')">
                <xsl:value-of select="$cx + $r * math:cos($theta2_r)"/>
            </xsl:when>
            <xsl:when test="function-available('external:cos')">
                <xsl:value-of select="$cx + $r * external:cos($theta2_r)"/>
            </xsl:when>            
            <xsl:otherwise>
                <xsl:value-of select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="y">
        <xsl:choose>
            <xsl:when test="function-available('math:sin')">
                <xsl:value-of select="$cy + $r * math:sin($theta2_r)"/>
            </xsl:when>
            <xsl:when test="function-available('external:sin')">
                <xsl:value-of select="$cy + $r * external:sin($theta2_r)"/>
            </xsl:when>            
            <xsl:otherwise>
                <xsl:value-of select="0"/>
            </xsl:otherwise>            
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="anchor">
      <xsl:choose>
        <xsl:when test="contains($style,'text-anchor')"></xsl:when>
        <xsl:when test="$theta2 >= 0 and $theta2 &lt;= 45">start</xsl:when>
        <xsl:when test="$theta2 > 45 and $theta2 &lt;= 135">middle</xsl:when>
        <xsl:when test="$theta2 > 135 and $theta2 &lt;= 225">end</xsl:when>
        <xsl:when test="$theta2 > 225 and $theta2 &lt;= 315">middle</xsl:when>
        <xsl:otherwise>start</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="formatted-label">
      <xsl:call-template name="number-format">
        <xsl:with-param name="number" select="$label"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="percentage">
      <xsl:call-template name="number-format">
        <xsl:with-param name="number" select="$label div $sum * 100"/>
      </xsl:call-template>
    </xsl:variable>
    <svg:text x="{$x}" y="{$y}" style="text-anchor:{$anchor};{$style}" id="{$context}_pieSliceLabel_{$num}">
        <xsl:value-of select="concat( $percentage,'%' )"/>
    </svg:text>
  </xsl:template>

  <xsl:template name="svgu:pieLabels">
    <xsl:param name="data" select="/.."/>      <!-- node set of numbers that determine slices -->
    <xsl:param name="labels" select="$data"/>  <!-- node set of labels to chart. Defaults to data -->
    <xsl:param name="cx" select="100"/>        <!-- center x -->
    <xsl:param name="cy" select="100"/>        <!-- center y -->
    <xsl:param name="r" select="50"/>          <!-- radius -->
    <xsl:param name="theta" select="-90"/>     <!-- beginning angle for first slice in degrees-->
    <xsl:param name="context"/>                <!-- user data to identify this invocation -->

    <xsl:call-template name="svgu:pieLabelsImpl">
      <xsl:with-param name="data" select="$data"/>
      <xsl:with-param name="labels" select="$labels"/>
      <xsl:with-param name="cx" select="$cx"/>
      <xsl:with-param name="cy" select="$cy"/>
      <xsl:with-param name="r" select="$r"/>
      <xsl:with-param name="theta" select="$theta"/>
      <xsl:with-param name="sum" select="sum($data)"/>
      <xsl:with-param name="context" select="$context"/>
    </xsl:call-template>

  </xsl:template>

  <xsl:template name="svgu:pieLabelsImpl">
    <xsl:param name="data" />
    <xsl:param name="labels"/>
    <xsl:param name="cx" />
    <xsl:param name="cy" />
    <xsl:param name="r" />
    <xsl:param name="theta"/>
    <xsl:param name="sum"/>
    <xsl:param name="context"/>
    <xsl:param name="i" select="1"/>

    <xsl:if test="count($data) >= $i">
      <xsl:variable name="delta" select="($data[$i] * 360) div $sum"/>

      <!-- draw slice of pie -->
      <xsl:call-template name="svgu:pieSliceLabel">
        <xsl:with-param name="label" select="$labels[$i]"/>
        <xsl:with-param name="cx" select="$cx"/>
        <xsl:with-param name="cy" select="$cy"/>
        <xsl:with-param name="r" select="$r"/>
        <xsl:with-param name="theta" select="$theta"/>
        <xsl:with-param name="delta" select="$delta div 2"/>
        <xsl:with-param name="style">
          <xsl:call-template name="svgu:pieSliceLabelStyle">
            <xsl:with-param name="i" select="$i"/>
            <xsl:with-param name="value" select="$data[$i]"/>
            <xsl:with-param name="label" select="$labels[$i]"/>
            <xsl:with-param name="context" select="$context"/>
          </xsl:call-template>
        </xsl:with-param>
        <xsl:with-param name="num" select="$i"/>
        <xsl:with-param name="context" select="$context"/>
        <xsl:with-param name="sum" select="$sum"/>
      </xsl:call-template>

      <!-- recursive call for next slice label -->
        <xsl:call-template name="svgu:pieLabelsImpl">
          <xsl:with-param name="data" select="$data"/>
          <xsl:with-param name="labels" select="$labels"/>
          <xsl:with-param name="cx" select="$cx"/>
          <xsl:with-param name="cy" select="$cy"/>
          <xsl:with-param name="r" select="$r"/>
          <xsl:with-param name="theta" select="$theta + $delta"/>
          <xsl:with-param name="sum" select="$sum"/>
          <xsl:with-param name="context" select="$context"/>
          <xsl:with-param name="i" select="$i + 1"/>
        </xsl:call-template>
    </xsl:if>

  </xsl:template>

  <xsl:template name="svgu:pieSliceStyle">
    <xsl:param name="i"/>
    <xsl:param name="context"/>
    <xsl:variable name="colors" select="document('')/*/svgu:color"/>
    <xsl:value-of select="concat('stroke:black;stroke-width:0.5;fill: ',$colors[($i - 1 ) mod count($colors) + 1])"/>
  </xsl:template>

  <xsl:template name="svgu:pieSliceLabelStyle">
    <xsl:param name="i"/>
    <xsl:param name="value"/>
    <xsl:param name="label" />
    <xsl:param name="context"/>
    <xsl:choose>
      <xsl:when test="$fmt='htm'">
        <xsl:text>font-size: 12;font-family: Helvetica</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>font-size: 7;font-family: Helvetica</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
