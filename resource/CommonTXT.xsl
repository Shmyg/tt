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

  File:    CommonTXT.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> TXT stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms common elements.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/CommonTXT.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">

  <!-- number formatting -->
  <xsl:decimal-format name="f1" decimal-separator="," grouping-separator="."/>
  <xsl:decimal-format name="f2" decimal-separator="." grouping-separator=","/>

  <xsl:template name="number-format">

    <xsl:param name="number"/>
    <xsl:choose>
      <xsl:when test="$lang='DE'">
        <xsl:value-of select="format-number(number($number),'#.##0,00;-#.##0,00','f1')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="format-number(number($number),'#,##0.00;-#,##0.00','f2')"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- volume formatting -->
  <xsl:template name="volume-format">

    <xsl:param name="volume"/>
    <xsl:choose>
      <xsl:when test="$lang='DE'">
        <xsl:value-of select="format-number(number($volume),'#.##0;-#.##0','f1')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="format-number(number($volume),'#,##0;-#,##0','f2')"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- date formatting -->
  <xsl:template name="date-format">

    <xsl:param name="date"/>
    <xsl:value-of select="substring($date,9,2)"/>
    <xsl:text>.</xsl:text>
    <xsl:value-of select="substring($date,6,2)"/>
    <xsl:text>.</xsl:text>
    <xsl:value-of select="substring($date,1,4)"/>

  </xsl:template>

  <!-- date/time formatting -->
  <xsl:template name="date-time-format">

    <xsl:param name="date"/>
    <xsl:value-of select="substring($date,9,2)"/>
    <xsl:text>.</xsl:text>
    <xsl:value-of select="substring($date,6,2)"/>
    <xsl:text>.</xsl:text>
    <xsl:value-of select="substring($date,1,4)"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="substring($date,12,8)"/>

  </xsl:template>

  <!-- number/unit formatting -->
  <xsl:template name="number-unit-format">

    <xsl:param name="number"/>
    <xsl:param name="unit"/>

    <xsl:choose>
      <!-- duration -->
      <xsl:when test="$unit='Sec'">
        <!-- hours -->
        <xsl:if test="floor($number div 3600) != 0">
          <xsl:value-of select="floor($number div 3600)"/>
          <xsl:text> </xsl:text>
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="'H'"/>
            <xsl:with-param name="Type"  select="'UM'"/>
            <xsl:with-param name="Desc"  select="'0'"/>
          </xsl:call-template>
        </xsl:if>
        <!-- minutes -->
        <xsl:variable name="rest">
          <xsl:value-of select="$number mod 3600"/>
        </xsl:variable>
        <xsl:if test="floor($rest div 60) != 0">
          <xsl:text> </xsl:text>
          <xsl:value-of select="floor($rest div 60)"/>
          <xsl:text> </xsl:text>
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="'Min'"/>
            <xsl:with-param name="Type"  select="'UM'"/>
            <xsl:with-param name="Desc"  select="'0'"/>
          </xsl:call-template>
        </xsl:if>
        <!-- seconds -->
        <xsl:text> </xsl:text>
        <xsl:value-of select="$rest mod 60"/>
        <xsl:text> </xsl:text>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="'Sec'"/>
          <xsl:with-param name="Type"  select="'UM'"/>
          <xsl:with-param name="Desc"  select="'0'"/>
        </xsl:call-template>
      </xsl:when>
      <!-- data volume -->
      <xsl:when test="$unit='Byte'">
        <xsl:choose>
          <!-- byte ( 1024 byte = 1 KByte ) -->
          <xsl:when test="$number &lt; 1024">
            <xsl:value-of select="$number"/>
            <xsl:text> </xsl:text>
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="'Byte'"/>
              <xsl:with-param name="Type"  select="'UM'"/>
              <xsl:with-param name="Desc"  select="'0'"/>
            </xsl:call-template>
          </xsl:when>
          <!-- Kbyte ( 1048576 byte = 1 MByte ) -->
          <xsl:when test="$number &lt; 1048576">
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="$number div 1024"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="'Kbyte'"/>
              <xsl:with-param name="Type"  select="'UM'"/>
              <xsl:with-param name="Desc"  select="'0'"/>
            </xsl:call-template>
          </xsl:when>
          <!-- Mbyte  ( 1073741824 byte = 1 GByte ) -->
          <xsl:when test="$number &lt; 1073741824">
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="$number div 1048576"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="'Mbyte'"/>
              <xsl:with-param name="Type"  select="'UM'"/>
              <xsl:with-param name="Desc"  select="'0'"/>
            </xsl:call-template>
          </xsl:when>
          <!-- GByte  ( 1 GByte = 1073741824 bytes ) -->
          <xsl:otherwise>
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="$number div 1073741824"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="'Gbyte'"/>
              <xsl:with-param name="Type"  select="'UM'"/>
              <xsl:with-param name="Desc"  select="'0'"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- msg, event, click etc. -->
      <xsl:otherwise>
        <xsl:call-template name="volume-format">
          <xsl:with-param name="volume" select="$number"/>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="$unit"/>
          <xsl:with-param name="Type"  select="'UM'"/>
          <xsl:with-param name="Desc"  select="'0'"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- legend mapping -->
  <xsl:template name="LgnMap">

    <!-- mapping according to index, type, and language
         Mode is the mapping index type (0 = pkey-index, 1 = id-index)
         Desc is the description type (0 = ShDes, 1 = LongDes) -->

    <xsl:param name="Mode"/>
    <xsl:param name="Index"/>
    <xsl:param name="Type"/>
    <xsl:param name="Desc"/>

    <xsl:choose>

      <xsl:when test="$Mode='0'">
        <!-- PKey mapping -->
        <xsl:choose>
          <!-- extract short description -->
          <xsl:when test="$Desc='0'">
            <!-- key mapping is faster -->
            <xsl:for-each select="$legend">
              <xsl:value-of select="key('pkey-index',$Index)[@Type=$Type][@xml:lang=$lang]/@ShDes"/>
            </xsl:for-each>
            <!--
            <xsl:value-of select="$legend/Document/Legend/TypeDesc[@PKey=$Index and @Type=$Type and @xml:lang=$lang]/@ShDes"/>
            -->
          </xsl:when>
          <!-- extract long description -->
          <xsl:otherwise>
            <!-- key mapping is faster -->
            <xsl:for-each select="$legend">
              <xsl:value-of select="key('pkey-index',$Index)[@Type=$Type][@xml:lang=$lang]/@LongDes"/>
            </xsl:for-each>
            <!--
            <xsl:value-of select="$legend/Document/Legend/TypeDesc[@PKey=$Index and @Type=$Type and @xml:lang=$lang]/@LongDes"/>
            -->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- Id mapping -->
        <xsl:choose>
          <!-- extract short description -->
          <xsl:when test="$Desc='0'">
            <xsl:for-each select="$legend">
              <xsl:value-of select="key('id-index',$Index)[@Type=$Type][@xml:lang=$lang]/@ShDes"/>
            </xsl:for-each>
          </xsl:when>
          <!-- extract long description -->
          <xsl:otherwise>
            <xsl:for-each select="$legend">
              <xsl:value-of select="key('id-index',$Index)[@Type=$Type][@xml:lang=$lang]/@LongDes"/>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- legend mapping -->
  <xsl:template name="DataDomainLgnMap">
    <!-- mapping according to index, type, data class id, and language
         Desc is the description type (0 = ShDes, 1 = LongDes) -->

    <xsl:param name="Index"/>
    <xsl:param name="Type"/>
    <xsl:param name="Desc"/>
    <xsl:param name="ClassId"/>

    <!-- PKey mapping -->
    <xsl:choose>
      <!-- extract short description -->
      <xsl:when test="$Desc='0'">
        <!-- key mapping is faster -->
        <xsl:for-each select="$legend">
          <xsl:value-of select="key('pkey-index',$Index)[@Type=$Type][@Id=$ClassId][@xml:lang=$lang]/@ShDes"/>
        </xsl:for-each>
        <!--
        <xsl:value-of select="$legend/Document/Legend/TypeDesc[@PKey=$Index and @Type=$Type and @Id=$ClassId and @xml:lang=$lang]/@ShDes"/>
        -->
      </xsl:when>
      <!-- extract long description -->
      <xsl:otherwise>
        <!-- key mapping is faster -->
        <xsl:for-each select="$legend">
          <xsl:value-of select="key('pkey-index',$Index)[@Type=$Type][@Id=$ClassId][@xml:lang=$lang]/@LongDes"/>
        </xsl:for-each>
        <!--
        <xsl:value-of select="$legend/Document/Legend/TypeDesc[@PKey=$Index and @Type=$Type and @Id=$ClassId and @xml:lang=$lang]/@LongDes"/>
        -->
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- balance snapshot -->
  <xsl:template match="BalSsh">

    <!-- snapshot date -->
    <xsl:for-each select="$txt">
      <xsl:value-of select="key('txt-index','168')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text>: </xsl:text>
    <xsl:call-template name="date-time-format">
      <xsl:with-param name="date" select="Date[@Type='BAL_REF']/@Date"/>
    </xsl:call-template>
    <xsl:value-of select="$line-feed"/>
    <xsl:apply-templates select="Bal"/>
    <xsl:value-of select="$line-feed"/>
    <xsl:apply-templates select="BalVols"/>

  </xsl:template>

  <!-- balance infos -->
  <xsl:template match="Bal">

    <!-- service -->
    <xsl:for-each select="$txt">
      <xsl:value-of select="key('txt-index','170')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text>: </xsl:text>
    <xsl:call-template name="LgnMap">
      <xsl:with-param name="Mode"  select="'0'"/>
      <xsl:with-param name="Index" select="@SN"/>
      <xsl:with-param name="Type"  select="'SN'"/>
      <xsl:with-param name="Desc"  select="'1'"/>
    </xsl:call-template>

  </xsl:template>

  <!-- balance snapshot volumes -->
  <xsl:template match="BalVols">

    <!-- used volume -->
    <xsl:for-each select="$txt">
      <xsl:value-of select="key('txt-index','173')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text>: </xsl:text>
    <xsl:choose>
      <xsl:when test="../Bal/@UM">
        <xsl:call-template name="number-unit-format">
          <xsl:with-param name="number" select="@AccUsage"/>
          <xsl:with-param name="unit" select="../Bal/@UM"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="number-format">
          <xsl:with-param name="number" select="@AccUsage"/>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:value-of select="../Bal/@CurrCode"/>
      </xsl:otherwise>
    </xsl:choose>
    <!-- available credit -->
    <xsl:if test="@AccCredit">
      <xsl:value-of select="$line-feed"/>
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','174')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
      <xsl:text>: </xsl:text>
      <xsl:choose>
        <xsl:when test="../Bal/@UM">
          <xsl:call-template name="number-unit-format">
            <xsl:with-param name="number" select="@AccCredit"/>
            <xsl:with-param name="unit" select="../Bal/@UM"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="number-format">
            <xsl:with-param name="number" select="@AccCredit"/>
          </xsl:call-template>
          <xsl:text> </xsl:text>
          <xsl:value-of select="../Bal/@CurrCode"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <!-- remaining credit -->
    <xsl:if test="@RemCredit">
      <xsl:value-of select="$line-feed"/>
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','175')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
      <xsl:text>: </xsl:text>
      <xsl:choose>
        <xsl:when test="../Bal/@UM">
          <xsl:call-template name="number-unit-format">
            <xsl:with-param name="number" select="@RemCredit"/>
            <xsl:with-param name="unit" select="../Bal/@UM"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="number-format">
            <xsl:with-param name="number" select="@RemCredit"/>
          </xsl:call-template>
          <xsl:text> </xsl:text>
          <xsl:value-of select="../Bal/@CurrCode"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="$line-feed"/>
    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
