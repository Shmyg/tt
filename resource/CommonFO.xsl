<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    CommonFO.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> XSL-FO stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms common elements.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/CommonFO.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" xmlns:date="http://exslt.org/dates-and-times" exclude-result-prefixes="xsl cur date">

  <!-- currency symbol mapping according to several ISO 4217 currency codes;
       symbol presentation: UTF-8 encoding and correct font must be set -->
  <cur:symbol CurrCode="ADP">&#x20A7;</cur:symbol> <!-- peseta -->
  <cur:symbol CurrCode="BRL">&#x20A2;</cur:symbol> <!-- cruzeiro -->
  <cur:symbol CurrCode="CHN">&#x00A5;</cur:symbol> <!-- yuan -->
  <cur:symbol CurrCode="CRC">&#x20A1;</cur:symbol> <!-- colon -->
  <cur:symbol CurrCode="EUR">&#x20AC;</cur:symbol> <!-- euro -->
  <cur:symbol CurrCode="FRF">&#x20A3;</cur:symbol> <!-- franc -->
  <cur:symbol CurrCode="GBP">&#x00A3;</cur:symbol> <!-- pound -->
  <cur:symbol CurrCode="INR">&#x20A8;</cur:symbol> <!-- rupee -->
  <cur:symbol CurrCode="ITL">&#x00A3;</cur:symbol> <!-- lira -->
  <cur:symbol CurrCode="ILS">&#x20AA;</cur:symbol> <!-- new shekel -->
  <cur:symbol CurrCode="JPY">&#x00A5;</cur:symbol> <!-- yen -->
  <cur:symbol CurrCode="KPW">&#x20A9;</cur:symbol> <!-- won -->
  <cur:symbol CurrCode="KRW">&#x20A9;</cur:symbol> <!-- won -->
  <cur:symbol CurrCode="NGN">&#x20A6;</cur:symbol> <!-- naira -->
  <cur:symbol CurrCode="THB">&#x0E3F;</cur:symbol> <!-- baht -->
  <cur:symbol CurrCode="USD">&#x0024;</cur:symbol> <!-- dollar -->
  <cur:symbol CurrCode="VND">&#x20AB;</cur:symbol> <!-- dong -->
  <cur:symbol CurrCode="XEU">&#x20A0;</cur:symbol> <!-- ecu (no longer ISO 4217) -->

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

  <!-- date info -->
  <xsl:template match="Date">
    <xsl:call-template name="date-format">
      <xsl:with-param name="date" select="@Date"/>
    </xsl:call-template>
  </xsl:template>

  <!-- address -->
  <xsl:template match="Addr">
    <fo:block font-size="8pt">
      <xsl:value-of select="concat(@Name,' ',@Line1)"/>
    </fo:block>
    <xsl:if test="@Line2">
      <fo:block font-size="8pt">
        <xsl:value-of select="concat(@Line2,' ',@Line3)"/>
      </fo:block>
    </xsl:if>
    <xsl:if test="@Line4">
      <fo:block font-size="8pt">
        <xsl:value-of select="concat(@Line4,' ',@Line5)"/>
      </fo:block>
    </xsl:if>
    <xsl:if test="@Line6">
      <fo:block font-size="8pt">
        <xsl:value-of select="@Line6"/>
      </fo:block>
    </xsl:if>
    <xsl:if test="@Zip">
      <fo:block font-size="8pt">
        <xsl:value-of select="@Zip"/>
      </fo:block>
      <xsl:choose>
        <xsl:when test="@City">
          <fo:block font-size="8pt">
            <xsl:value-of select="concat(' ',@City)"/>
          </fo:block>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:if>
    <xsl:if test="@Country">
      <fo:block font-size="8pt">
        <xsl:value-of select="@Country"/>
      </fo:block>
    </xsl:if>
  </xsl:template>

  <!-- address line -->
  <xsl:template match="Addr" mode="line">
    <fo:block>
      <xsl:value-of select="concat(@Name,' ',@Line1)"/>
      <xsl:text>, </xsl:text>
      <xsl:if test="@Line2">
        <xsl:value-of select="concat(@Line2,' ',@Line3)"/>
      </xsl:if>
      <xsl:text>, </xsl:text>
      <xsl:if test="@Line4">
        <xsl:value-of select="concat(@Line4,' ',@Line5)"/>
      </xsl:if>
      <xsl:text>, </xsl:text>
      <xsl:if test="@Line6">
        <xsl:value-of select="@Line6"/>
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:if test="@Zip">
        <xsl:value-of select="@Zip"/>
        <xsl:choose>
          <xsl:when test="@City">
            <xsl:value-of select="concat(' ',@City)"/>
          </xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </xsl:if>
      <xsl:text>, </xsl:text>
      <xsl:if test="@Country">
        <xsl:value-of select="@Country"/>
      </xsl:if>
    </fo:block>
  </xsl:template>

  <!-- discount charges -->
  <xsl:template match="Charge">
    <!-- For the business entity currency a symbol mapping is used at the moment.
         However, you can also use the public key, the short description or the long description.
         If you want to use a description, legend mapping is necessary. -->
    <xsl:variable name="number-format">
      <xsl:call-template name="number-format">
        <xsl:with-param name="number" select="@Amount"/>
      </xsl:call-template>
    </xsl:variable>

    <fo:block text-align="right">
      <xsl:value-of select="$number-format"/>
      <xsl:text> </xsl:text>
      <xsl:for-each select="@CurrCode">
        <xsl:value-of select="document('')/*/cur:symbol[@CurrCode=current()]"/>
      </xsl:for-each>
    </fo:block>

  </xsl:template>

  <!-- price -->
  <xsl:template match="Price">
    <xsl:call-template name="number-format">
      <xsl:with-param name="number" select="@Price"/>
    </xsl:call-template>
    <xsl:text> </xsl:text>
    <xsl:for-each select="@CurrCode">
      <xsl:value-of select="document('')/*/cur:symbol[@CurrCode=current()]"/>
    </xsl:for-each>
  </xsl:template>

  <!-- service parameter -->
  <xsl:template match="SrvParams">

      <xsl:value-of select="@ParamDesc"/><xsl:text> / </xsl:text>
      <xsl:value-of select="@FlexParamDesc"/><xsl:text> / </xsl:text>
      <xsl:value-of select="@ParamVal"/><xsl:text> / </xsl:text>
      <xsl:apply-templates select="Date"/>

  </xsl:template>

  <!-- service status -->
  <xsl:template match="SrvStatus">

    <fo:block>
      <xsl:for-each select="Date">
        <xsl:apply-templates select="."/>
        <xsl:if test="position()='1'">
          <xsl:text>-</xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:text>,</xsl:text>
      <xsl:value-of select="@Status"/>
    </fo:block>
    <!--
    <xsl:text>, </xsl:text>
    <xsl:apply-templates select="Charge"/>
    -->

  </xsl:template>

  <!-- promo -->
  <xsl:template match="PromoItem" mode="invoice-item">
    <!--
    <xsl:call-template name="LgnMap">
      <xsl:with-param name="Mode"  select="'0'"/>
      <xsl:with-param name="Index" select="@Mech"/>
      <xsl:with-param name="Type"  select="'PMC'"/>
      <xsl:with-param name="Desc"  select="'0'"/>
    </xsl:call-template>
    <xsl:apply-templates select="PromoElemRef" mode="invoice-item"/>
    <xsl:text>, </xsl:text>
    -->
    <xsl:apply-templates select="Charge"/>
  </xsl:template>

  <!-- promo -->
  <xsl:template match="PromoItem" mode="sum-item-usage">
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@Mech"/>
          <xsl:with-param name="Type"  select="'PMC'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <xsl:apply-templates select="PromoElemRef" mode="sum-item-usage"/>
    <fo:table-cell>
      <xsl:apply-templates select="Charge"/>
    </fo:table-cell>
  </xsl:template>

  <!-- promo -->
  <xsl:template match="PromoItem" mode="sum-item-occ">
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@Mech"/>
          <xsl:with-param name="Type"  select="'PMC'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <xsl:apply-templates select="PromoElemRef" mode="sum-item-occ"/>
    <fo:table-cell>
      <xsl:apply-templates select="Charge"/>
    </fo:table-cell>
  </xsl:template>

  <!-- promo -->
  <xsl:template match="PromoItem" mode="sum-item-subscription">
    <fo:table-cell text-align="center" number-columns-spanned="2">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@Mech"/>
          <xsl:with-param name="Type"  select="'PMC'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <xsl:apply-templates select="PromoElemRef" mode="sum-item-subscription"/>
    <fo:table-cell>
      <xsl:apply-templates select="Charge"/>
    </fo:table-cell>
  </xsl:template>

  <!-- promo -->
  <xsl:template match="PromoItem" mode="sum-item-access">
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@Mech"/>
          <xsl:with-param name="Type"  select="'PMC'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <xsl:apply-templates select="PromoElemRef" mode="sum-item-access"/>
    <fo:table-cell>
      <xsl:apply-templates select="Charge"/>
    </fo:table-cell>
  </xsl:template>

  <!-- promo -->
  <xsl:template match="PromoItem" mode="credit-per-bal">
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@Mech"/>
          <xsl:with-param name="Type"  select="'PMC'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <xsl:apply-templates select="PromoElemRef" mode="credit-per-bal"/>
    <fo:table-cell>
      <xsl:apply-templates select="Charge"/>
    </fo:table-cell>
  </xsl:template>

  <!-- promo infos -->
  <xsl:template match="PromoElemRef" mode="invoice-item">
    <xsl:text>/</xsl:text>
    <xsl:call-template name="LgnMap">
      <xsl:with-param name="Mode"  select="'0'"/>
      <xsl:with-param name="Index" select="@PackId"/>
      <xsl:with-param name="Type"  select="'PP'"/>
      <xsl:with-param name="Desc"  select="'0'"/>
    </xsl:call-template>
    <xsl:text>/</xsl:text>
    <xsl:call-template name="LgnMap">
      <xsl:with-param name="Mode"  select="'0'"/>
      <xsl:with-param name="Index" select="@ModelId"/>
      <xsl:with-param name="Type"  select="'PM'"/>
      <xsl:with-param name="Desc"  select="'0'"/>
    </xsl:call-template>
    <xsl:text>/</xsl:text>
    <xsl:call-template name="LgnMap">
      <xsl:with-param name="Mode"  select="'0'"/>
      <xsl:with-param name="Index" select="@ElemId"/>
      <xsl:with-param name="Type"  select="'PME'"/>
      <xsl:with-param name="Desc"  select="'0'"/>
    </xsl:call-template>
    <xsl:text>/</xsl:text>
    <xsl:value-of select="@ElemVers"/>
  </xsl:template>

  <!-- promo infos -->
  <xsl:template match="PromoElemRef" mode="sum-item-usage">
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@PackId"/>
          <xsl:with-param name="Type"  select="'PP'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@ModelId"/>
          <xsl:with-param name="Type"  select="'PM'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@ElemId"/>
          <xsl:with-param name="Type"  select="'PME'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:value-of select="@ElemVers"/>
      </fo:block>
    </fo:table-cell>

  </xsl:template>

  <!-- promo infos -->
  <xsl:template match="PromoElemRef" mode="sum-item-occ">
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@PackId"/>
          <xsl:with-param name="Type"  select="'PP'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@ModelId"/>
          <xsl:with-param name="Type"  select="'PM'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@ElemId"/>
          <xsl:with-param name="Type"  select="'PME'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:value-of select="@ElemVers"/>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <!-- promo infos -->
  <xsl:template match="PromoElemRef" mode="sum-item-subscription">
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@PackId"/>
          <xsl:with-param name="Type"  select="'PP'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
        </fo:block>
    </fo:table-cell>
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@ModelId"/>
          <xsl:with-param name="Type"  select="'PM'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@ElemId"/>
          <xsl:with-param name="Type"  select="'PME'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:value-of select="@ElemVers"/>
      </fo:block>
    </fo:table-cell>

  </xsl:template>

  <!-- promo infos -->
  <xsl:template match="PromoElemRef" mode="sum-item-access">
    <fo:table-cell text-align="center" number-columns-spanned="2">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@PackId"/>
          <xsl:with-param name="Type"  select="'PP'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell text-align="center" number-columns-spanned="2">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@ModelId"/>
          <xsl:with-param name="Type"  select="'PM'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@ElemId"/>
          <xsl:with-param name="Type"  select="'PME'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:value-of select="@ElemVers"/>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <!-- promo infos -->
  <xsl:template match="PromoElemRef" mode="credit-per-bal">

    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@PackId"/>
          <xsl:with-param name="Type"  select="'PP'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@ModelId"/>
          <xsl:with-param name="Type"  select="'PM'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@ElemId"/>
          <xsl:with-param name="Type"  select="'PME'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:value-of select="@ElemVers"/>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <!-- promo infos -->
  <xsl:template match="PromoElemRef" mode="sum">

    <fo:table space-before="10pt" width="160mm" table-layout="fixed">
      <fo:table-column column-width="20mm"/>
      <fo:table-column column-width="60mm"/>
      <fo:table-column column-width="60mm"/>
      <fo:table-column column-width="20mm"/>
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell>
          	<fo:block/>
          </fo:table-cell>
          <fo:table-cell padding-top="2pt">
            <fo:block font-size="8pt" text-align="left">
              <!-- customer -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','310')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell padding-top="2pt">
            <fo:block font-size="8pt" text-align="right">
              <xsl:value-of select="@CustId"/>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
          	<fo:block/>
          </fo:table-cell>
        </fo:table-row>
        <fo:table-row>
          <fo:table-cell>
          	<fo:block/>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="left">
              <!-- sequence number -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','311')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="right">
              <xsl:value-of select="@AssSeqNo"/>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
          	<fo:block/>
          </fo:table-cell>
        </fo:table-row>
        <fo:table-row>
          <fo:table-cell>
          	<fo:block/>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="left">
              <!-- contract -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','312')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="right">
              <xsl:value-of select="@CoId"/>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
          	<fo:block/>
          </fo:table-cell>
        </fo:table-row>
        <fo:table-row>
          <fo:table-cell>
          	<fo:block/>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="left">
              <!-- promo package -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','313')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="right">
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode" select="'0'"/>
                <xsl:with-param name="Index" select="@PackId"/>
                <xsl:with-param name="Type" select="'PP'"/>
                <xsl:with-param name="Desc" select="'1'"/>
              </xsl:call-template>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
          	<fo:block/>
          </fo:table-cell>
        </fo:table-row>
        <fo:table-row>
          <fo:table-cell>
          	<fo:block/>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="left">
              <!-- promo model -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','314')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="right">
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode" select="'0'"/>
                <xsl:with-param name="Index" select="@ModelId"/>
                <xsl:with-param name="Type" select="'PM'"/>
                <xsl:with-param name="Desc" select="'1'"/>
              </xsl:call-template>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
          	<fo:block/>
          </fo:table-cell>
        </fo:table-row>
        <fo:table-row>
          <fo:table-cell>
          	<fo:block/>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="left">
              <!-- promo element -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','315')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="right">
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode" select="'0'"/>
                <xsl:with-param name="Index" select="@ElemId"/>
                <xsl:with-param name="Type" select="'PME'"/>
                <xsl:with-param name="Desc" select="'1'"/>
              </xsl:call-template>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
          	<fo:block/>
          </fo:table-cell>
        </fo:table-row>
        <fo:table-row>
          <fo:table-cell>
          	<fo:block/>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="left">
              <!-- promo element version -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','316')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-size="8pt" text-align="right">
              <xsl:value-of select="@ElemVers"/>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
          	<fo:block/>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>

  </xsl:template>

  <!-- aggregation set -->
  <xsl:template match="AggSet" mode="invoice-item">
    <xsl:choose>
      <xsl:when test="Att">
        <xsl:for-each select="Att">
          <!-- sort the attributes -->
          <xsl:sort select="@Ty" data-type="text" order="ascending"/>
          <xsl:choose>
            <!-- service -->
            <xsl:when test="@Ty='SN'">
              <fo:table-cell>
                <xsl:choose>
                  <xsl:when test="$fmt='pdf'">
                    <fo:block font-size="8pt" text-align="center">
                      <xsl:call-template name="LgnMap">
                        <xsl:with-param name="Mode" select="'0'"/>
                        <xsl:with-param name="Index" select="@Id"/>
                        <xsl:with-param name="Type" select="@Ty"/>
                        <xsl:with-param name="Desc" select="'1'"/>
                      </xsl:call-template>
                    </fo:block>
                  </xsl:when>
                  <xsl:otherwise>
                    <fo:block font-size="8pt" text-align="center">
                      <xsl:call-template name="LgnMap">
                        <xsl:with-param name="Mode" select="'0'"/>
                        <xsl:with-param name="Index" select="@Id"/>
                        <xsl:with-param name="Type" select="@Ty"/>
                        <xsl:with-param name="Desc" select="'1'"/>
                      </xsl:call-template>
                    </fo:block>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="../../@PrepaidTransaction='Y'">
                  <fo:block font-size="8pt" text-align="center">
                    <xsl:call-template name="LgnMap">
                      <xsl:with-param name="Mode" select="'0'"/>
                      <xsl:with-param name="Index" select="substring-after(../../@ArticleString,'.B.')"/>
                      <xsl:with-param name="Type" select="'PTT'"/>
                      <xsl:with-param name="Desc" select="'1'"/>
                    </xsl:call-template>                  
                  </fo:block>
                </xsl:if>
              </fo:table-cell>
            </xsl:when>
            <!-- package -->
            <xsl:when test="@Ty='SP'">
              <fo:table-cell>
                <xsl:choose>
                  <xsl:when test="$fmt='pdf'">
                    <fo:block font-size="8pt" text-align="center">
                      <xsl:call-template name="LgnMap">
                        <xsl:with-param name="Mode" select="'0'"/>
                        <xsl:with-param name="Index" select="@Id"/>
                        <xsl:with-param name="Type" select="@Ty"/>
                        <xsl:with-param name="Desc" select="'1'"/>
                      </xsl:call-template>
                    </fo:block>
                  </xsl:when>
                  <xsl:otherwise>
                    <fo:block font-size="8pt" text-align="center">
                      <xsl:call-template name="LgnMap">
                        <xsl:with-param name="Mode" select="'0'"/>
                        <xsl:with-param name="Index" select="@Id"/>
                        <xsl:with-param name="Type" select="@Ty"/>
                        <xsl:with-param name="Desc" select="'1'"/>
                      </xsl:call-template>
                    </fo:block>
                  </xsl:otherwise>
                </xsl:choose>
              </fo:table-cell>
            </xsl:when>
            <!-- tariff model -->
            <xsl:when test="@Ty='TM'">
              <fo:table-cell>
                <xsl:choose>
                  <xsl:when test="$fmt='pdf'">
                    <fo:block font-size="8pt" text-align="center">
                      <xsl:call-template name="LgnMap">
                        <xsl:with-param name="Mode" select="'0'"/>
                        <xsl:with-param name="Index" select="@Id"/>
                        <xsl:with-param name="Type" select="@Ty"/>
                        <xsl:with-param name="Desc" select="'1'"/>
                      </xsl:call-template>
                    </fo:block>
                  </xsl:when>
                  <xsl:otherwise>
                    <fo:block font-size="8pt" text-align="center">
                      <xsl:call-template name="LgnMap">
                        <xsl:with-param name="Mode" select="'0'"/>
                        <xsl:with-param name="Index" select="@Id"/>
                        <xsl:with-param name="Type" select="@Ty"/>
                        <xsl:with-param name="Desc" select="'1'"/>
                      </xsl:call-template>
                    </fo:block>
                  </xsl:otherwise>
                </xsl:choose>
              </fo:table-cell>
            </xsl:when>
            <xsl:otherwise>
              <!-- do nothing -->
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <!-- do nothing -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- aggregation set -->
  <xsl:template match="AggSet" mode="sum-item">

    <xsl:choose>
      <xsl:when test="Att">
        <xsl:for-each select="Att">
          <!-- sort the attributes -->
          <xsl:sort select="@Ty" data-type="text" order="ascending"/>
          <xsl:choose>
            <!-- profile -->
            <xsl:when test="@Ty='PRO'">
              <xsl:choose>
                <xsl:when test="@Id != ''">
                  <fo:table-cell text-align="center">
                    <xsl:choose>
                      <xsl:when test="$fmt='pdf'">
                        <fo:block>
                          <xsl:call-template name="LgnMap">
                            <xsl:with-param name="Mode"  select="'0'"/>
                            <xsl:with-param name="Index" select="@Id"/>
                            <xsl:with-param name="Type"  select="@Ty"/>
                            <xsl:with-param name="Desc"  select="'1'"/>
                          </xsl:call-template>
                        </fo:block>
                      </xsl:when>
                      <xsl:otherwise>
                        <fo:block>
                          <xsl:call-template name="LgnMap">
                            <xsl:with-param name="Mode" select="'0'"/>
                            <xsl:with-param name="Index" select="@Id"/>
                            <xsl:with-param name="Type" select="@Ty"/>
                            <xsl:with-param name="Desc" select="'1'"/>
                          </xsl:call-template>
                        </fo:block>
                      </xsl:otherwise>
                    </xsl:choose>
                  </fo:table-cell>
                </xsl:when>
                <xsl:otherwise>
                  <fo:table-cell text-align="center"><fo:block>-</fo:block></fo:table-cell>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <!-- service -->
            <xsl:when test="@Ty='SN'">
              <xsl:choose>
                <xsl:when test="@Id != ''">
                  <fo:table-cell text-align="center">
                    <xsl:choose>
                      <xsl:when test="$fmt='pdf'">
                        <fo:block>
                          <xsl:call-template name="LgnMap">
                            <xsl:with-param name="Mode"  select="'0'"/>
                            <xsl:with-param name="Index" select="@Id"/>
                            <xsl:with-param name="Type"  select="@Ty"/>
                            <xsl:with-param name="Desc"  select="'1'"/>
                          </xsl:call-template>
                        </fo:block>
                      </xsl:when>
                      <xsl:otherwise>
                        <fo:block>
                          <xsl:call-template name="LgnMap">
                            <xsl:with-param name="Mode" select="'0'"/>
                            <xsl:with-param name="Index" select="@Id"/>
                            <xsl:with-param name="Type" select="@Ty"/>
                            <xsl:with-param name="Desc" select="'1'"/>
                          </xsl:call-template>
                        </fo:block>
                      </xsl:otherwise>
                    </xsl:choose>
                  </fo:table-cell>
                </xsl:when>
                <xsl:otherwise>
                  <fo:table-cell text-align="center"><fo:block>-</fo:block></fo:table-cell>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <!-- package -->
            <xsl:when test="@Ty='SP'">
              <xsl:choose>
                <xsl:when test="@Id != ''">
                  <fo:table-cell text-align="center">
                    <xsl:choose>
                      <xsl:when test="$fmt='pdf'">
                        <fo:block>
                          <xsl:call-template name="LgnMap">
                            <xsl:with-param name="Mode"  select="'0'"/>
                            <xsl:with-param name="Index" select="@Id"/>
                            <xsl:with-param name="Type"  select="@Ty"/>
                            <xsl:with-param name="Desc"  select="'1'"/>
                          </xsl:call-template>
                        </fo:block>
                      </xsl:when>
                      <xsl:otherwise>
                        <fo:block>
                          <xsl:call-template name="LgnMap">
                            <xsl:with-param name="Mode" select="'0'"/>
                            <xsl:with-param name="Index" select="@Id"/>
                            <xsl:with-param name="Type" select="@Ty"/>
                            <xsl:with-param name="Desc" select="'1'"/>
                          </xsl:call-template>
                        </fo:block>
                      </xsl:otherwise>
                    </xsl:choose>
                  </fo:table-cell>
                </xsl:when>
                <xsl:otherwise>
                  <fo:table-cell text-align="center"><fo:block>-</fo:block></fo:table-cell>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <!-- tariff model -->
            <xsl:when test="@Ty='TM'">
              <xsl:choose>
                <xsl:when test="@Id != ''">
                  <fo:table-cell text-align="center">
                    <xsl:choose>
                      <xsl:when test="$fmt='pdf'">
                        <fo:block>
                          <xsl:call-template name="LgnMap">
                            <xsl:with-param name="Mode"  select="'0'"/>
                            <xsl:with-param name="Index" select="@Id"/>
                            <xsl:with-param name="Type"  select="@Ty"/>
                            <xsl:with-param name="Desc"  select="'1'"/>
                          </xsl:call-template>
                        </fo:block>
                      </xsl:when>
                      <xsl:otherwise>
                        <fo:block>
                          <xsl:call-template name="LgnMap">
                            <xsl:with-param name="Mode" select="'0'"/>
                            <xsl:with-param name="Index" select="@Id"/>
                            <xsl:with-param name="Type" select="@Ty"/>
                            <xsl:with-param name="Desc" select="'1'"/>
                          </xsl:call-template>
                        </fo:block>
                      </xsl:otherwise>
                    </xsl:choose>
                  </fo:table-cell>
                </xsl:when>
                <xsl:otherwise>
                  <fo:table-cell text-align="center"><fo:block>-</fo:block></fo:table-cell>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
            <!-- do nothing -->
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <!-- do nothing -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- aggregation set -->
  <xsl:template match="AggSet" mode="content">

    <xsl:choose>
      <xsl:when test="Att/@Ty='CC' or Att/@Ty='CCE' or Att/@Ty='CPL' or Att/@Ty='UT'">
        <fo:table-cell text-align="center">
          <xsl:choose>
            <xsl:when test="$fmt='pdf'">
              <fo:block>
                <xsl:for-each select="Att">
                  <!-- sort the attributes -->
                  <xsl:sort select="@Ty" data-type="text" order="ascending"/>
                  <xsl:if test="@Ty='CC'">
                    <!-- catalogue -->
                    <xsl:call-template name="LgnMap">
                      <xsl:with-param name="Mode"  select="'0'"/>
                      <xsl:with-param name="Index" select="@Id"/>
                      <xsl:with-param name="Type"  select="@Ty"/>
                      <xsl:with-param name="Desc"  select="'1'"/>
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@Ty='CCE'">
                    <!-- catalogue element -->
                    <xsl:text> / </xsl:text>
                    <xsl:call-template name="LgnMap">
                      <xsl:with-param name="Mode"  select="'0'"/>
                      <xsl:with-param name="Index" select="@Id"/>
                      <xsl:with-param name="Type"  select="@Ty"/>
                      <xsl:with-param name="Desc"  select="'1'"/>
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@Ty='CPL'">
                    <!-- price list -->
                    <xsl:text> / </xsl:text>
                    <xsl:call-template name="LgnMap">
                      <xsl:with-param name="Mode"  select="'0'"/>
                      <xsl:with-param name="Index" select="@Id"/>
                      <xsl:with-param name="Type"  select="@Ty"/>
                      <xsl:with-param name="Desc"  select="'1'"/>
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@Ty='UT'">
                    <!-- usage type -->
                    <xsl:text> / </xsl:text>
                    <xsl:call-template name="LgnMap">
                      <xsl:with-param name="Mode"  select="'0'"/>
                      <xsl:with-param name="Index" select="@Id"/>
                      <xsl:with-param name="Type"  select="@Ty"/>
                      <xsl:with-param name="Desc"  select="'1'"/>
                    </xsl:call-template>
                  </xsl:if>
                </xsl:for-each>
              </fo:block>
            </xsl:when>
            <xsl:otherwise>
              <fo:block>
                <xsl:for-each select="Att">
                  <!-- sort the attributes -->
                  <xsl:sort select="@Ty" data-type="text" order="ascending"/>
                  <xsl:if test="@Ty='CC'">
                    <!-- catalogue -->
                    <xsl:call-template name="LgnMap">
                      <xsl:with-param name="Mode"  select="'0'"/>
                      <xsl:with-param name="Index" select="@Id"/>
                      <xsl:with-param name="Type"  select="@Ty"/>
                      <xsl:with-param name="Desc"  select="'1'"/>
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@Ty='CCE'">
                    <!-- catalogue element -->
                    <xsl:text> / </xsl:text>
                    <xsl:call-template name="LgnMap">
                      <xsl:with-param name="Mode"  select="'0'"/>
                      <xsl:with-param name="Index" select="@Id"/>
                      <xsl:with-param name="Type"  select="@Ty"/>
                      <xsl:with-param name="Desc"  select="'1'"/>
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@Ty='CPL'">
                    <!-- price list -->
                    <xsl:text> / </xsl:text>
                    <xsl:call-template name="LgnMap">
                      <xsl:with-param name="Mode"  select="'0'"/>
                      <xsl:with-param name="Index" select="@Id"/>
                      <xsl:with-param name="Type"  select="@Ty"/>
                      <xsl:with-param name="Desc"  select="'1'"/>
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@Ty='UT'">
                    <!-- usage type -->
                    <xsl:text> / </xsl:text>
                    <xsl:call-template name="LgnMap">
                      <xsl:with-param name="Mode"  select="'0'"/>
                      <xsl:with-param name="Index" select="@Id"/>
                      <xsl:with-param name="Type"  select="@Ty"/>
                      <xsl:with-param name="Desc"  select="'1'"/>
                    </xsl:call-template>
                  </xsl:if>
                </xsl:for-each>
              </fo:block>
            </xsl:otherwise>
          </xsl:choose>
        </fo:table-cell>
      </xsl:when>
      <xsl:otherwise>
        <fo:table-cell text-align="center"><fo:block>-</fo:block></fo:table-cell>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- promo aggregation set -->
  <xsl:template match="AggSet" mode="bop">

    <xsl:choose>
      <xsl:when test="Att">
        <xsl:for-each select="Att">
          <!-- sort the attributes -->
          <xsl:sort select="@Ty" data-type="text" order="ascending"/>
          <xsl:if test="@Ty='SP'">
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="@Id"/>
              <xsl:with-param name="Type"  select="@Ty"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
            <xsl:text>/</xsl:text>
          </xsl:if>
          <xsl:if test="@Ty='TM'">
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="@Id"/>
              <xsl:with-param name="Type"  select="@Ty"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
            <xsl:text>/</xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <!-- do nothing -->
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

  <!-- free text -->
  <xsl:template match="Txt">
    <xsl:value-of select="."/>
  </xsl:template>

  <!-- balance infos -->
  <xsl:template match="Bal">
    <fo:table-cell text-align="center">
      <!-- service -->
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@SN"/>
          <xsl:with-param name="Type"  select="'SN'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
      <!-- shared account-->
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@SAP"/>
          <xsl:with-param name="Type"  select="'SAP'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>      
    </fo:table-cell>
    <fo:table-cell text-align="center">
      <!-- bundle product -->
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@BPROD"/>
          <xsl:with-param name="Type"  select="'BPROD'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>

  </xsl:template>

  <!-- balance infos for prepaid credit -->
  <xsl:template match="Bal" mode="credit-per-bal">
    <fo:table-cell text-align="center" number-columns-spanned="2">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@SN"/>
          <xsl:with-param name="Type"  select="'SN'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell text-align="center" number-columns-spanned="2">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@PRO"/>
          <xsl:with-param name="Type"  select="'PRO'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell text-align="center" number-columns-spanned="2">
      <fo:block>
        <xsl:choose>
          <xsl:when test="@PrType='N'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','230')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="@PrType='G'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','231')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <!-- balance infos for prepaid credit -->
  <xsl:template match="Bal" mode="promo">
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@SN"/>
          <xsl:with-param name="Type"  select="'SN'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@PRO"/>
          <xsl:with-param name="Type"  select="'PRO'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell text-align="center">
      <fo:block>
        <xsl:choose>
          <xsl:when test="@PrType='N'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','230')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="@PrType='G'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','231')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <!-- balance volumes -->
  <xsl:template match="BalVols">

    <!-- accumulated volume -->
    <fo:table-cell text-align="right">
      <fo:block>
        <xsl:choose>
          <xsl:when test="../Bal/@UM">
            <xsl:if test="@AccUsage">
              <xsl:call-template name="number-unit-format">
                <xsl:with-param name="number" select="@AccUsage"/>
                <xsl:with-param name="unit" select="../Bal/@UM"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="@AccUsage">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@AccUsage"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:for-each select="../Bal/@CurrCode">
                <xsl:value-of select="document('')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:table-cell>
    <!-- accumulated credit -->
    <fo:table-cell text-align="right">
      <fo:block>
        <xsl:choose>
          <xsl:when test="../Bal/@UM">
            <xsl:if test="@AccCredit">
              <xsl:call-template name="number-unit-format">
                <xsl:with-param name="number" select="@AccCredit"/>
                <xsl:with-param name="unit" select="../Bal/@UM"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="@AccCredit">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@AccCredit"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:for-each select="../Bal/@CurrCode">
                <xsl:value-of select="document('')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:table-cell>
    <!-- remaining credit -->
    <fo:table-cell text-align="right">
      <fo:block>
        <xsl:choose>
          <xsl:when test="../Bal/@UM">
            <xsl:if test="@RemCredit">
              <xsl:call-template name="number-unit-format">
                <xsl:with-param name="number" select="@RemCredit"/>
                <xsl:with-param name="unit" select="../Bal/@UM"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="@RemCredit">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@RemCredit"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:for-each select="../Bal/@CurrCode">
                <xsl:value-of select="document('')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:table-cell>

  </xsl:template>

  <!-- discount value -->
  <xsl:template match="DiscountValue">
    <!-- original value -->
    <fo:table-cell text-align="right">
      <fo:block>
        <xsl:call-template name="number-unit-format">
          <xsl:with-param name="number" select="@OrigVal"/>
          <xsl:with-param name="unit" select="@UM"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <!-- discount value -->
    <fo:table-cell text-align="right">
      <fo:block>
        <xsl:call-template name="number-unit-format">
          <xsl:with-param name="number" select="@DiscVal"/>
          <xsl:with-param name="unit" select="@UM"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>

  </xsl:template>

  <!-- best option plan -->
  <xsl:template match="BOPAlt" mode="promo">

    <fo:table space-before="20pt" width="160mm" table-layout="fixed">
      <fo:table-column column-width="20mm"/>
      <fo:table-column column-width="60mm"/>
      <fo:table-column column-width="60mm"/>
      <fo:table-column column-width="20mm"/>
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell>
            <fo:block/>
          </fo:table-cell>
          <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
            <fo:block font-size="8pt" text-align="left">
              <xsl:for-each select="AggSet/Att">
                <xsl:if test="@Ty='TM'">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','369')[@xml:lang=$lang]/@Des"/>
                    <xsl:text>/</xsl:text>
                  </xsl:for-each>
                </xsl:if>
                <xsl:if test="@Ty='SP'">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','370')[@xml:lang=$lang]/@Des"/>
                    <xsl:text>/</xsl:text>
                  </xsl:for-each>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','371')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
              <xsl:text>/</xsl:text>
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','372')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
            <fo:block font-size="8pt" text-align="right">
              <xsl:apply-templates select="AggSet" mode="bop"/>
              <xsl:choose>
                <xsl:when test="@CONTR='Y'">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','373')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','374')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text>/</xsl:text>
              <xsl:choose>
                <xsl:when test="@BILLED='Y'">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','373')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','374')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block/>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>

  </xsl:template>

  <!-- directory numbers -->
  <xsl:template match="DN">
    <fo:table-cell>
      <fo:block font-size="7pt" text-align="left">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','113')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell font-size="7pt" text-align="right">
      <fo:block>
        <xsl:value-of select="@Num"/>
        <xsl:if test="@Main='Y'">
          <xsl:text> (M)</xsl:text>
        </xsl:if>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <!-- DN block(s) -->
  <xsl:template match="DNBlock">
    <fo:table-cell>
      <xsl:for-each select="$txt">
        <fo:block font-size="7pt" text-align="left">
          <xsl:value-of select="key('txt-index','284')[@xml:lang=$lang]/@Des"/>
        </fo:block>
        <fo:block font-size="7pt" text-align="left">
          <xsl:value-of select="key('txt-index','285')[@xml:lang=$lang]/@Des"/>
        </fo:block>
      </xsl:for-each>
    </fo:table-cell>
    <fo:table-cell>
      <fo:block font-size="7pt" text-align="right">
        <xsl:value-of select="@NumStart"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="@NumEnd"/>
        <!-- print main indicator for block numbers too -->
        <xsl:if test="@Main='Y'">
          <xsl:text> (M)</xsl:text>
        </xsl:if>
      </fo:block>
      <fo:block font-size="7pt" text-align="right">
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@SN"/>
          <xsl:with-param name="Type"  select="'SN'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
        <xsl:text>/</xsl:text>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@PRO"/>
          <xsl:with-param name="Type"  select="'PRO'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <!-- date difference -->
  <date:month-lengths>
   <date:month>31</date:month>
   <date:month>28</date:month>
   <date:month>31</date:month>
   <date:month>30</date:month>
   <date:month>31</date:month>
   <date:month>30</date:month>
   <date:month>31</date:month>
   <date:month>31</date:month>
   <date:month>30</date:month>
   <date:month>31</date:month>
   <date:month>30</date:month>
   <date:month>31</date:month>
  </date:month-lengths>

  <xsl:template name="date:difference">
   <xsl:param name="start" />
   <xsl:param name="end" />

   <xsl:variable name="start-neg" select="starts-with($start, '-')" />
   <xsl:variable name="start-no-neg">
      <xsl:choose>
         <xsl:when test="$start-neg or starts-with($start, '+')">
            <xsl:value-of select="substring($start, 2)" />
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$start" />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   <xsl:variable name="start-no-neg-length" select="string-length($start-no-neg)" />
   <xsl:variable name="start-timezone">
      <xsl:choose>
         <xsl:when test="substring($start-no-neg, $start-no-neg-length) = 'Z'">Z</xsl:when>
         <xsl:otherwise>
            <xsl:variable name="tz" select="substring($start-no-neg, $start-no-neg-length - 5)" />
            <xsl:if test="(substring($tz, 1, 1) = '-' or 
                           substring($tz, 1, 1) = '+') and
                          substring($tz, 4, 1) = ':'">
               <xsl:value-of select="$tz" />
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   <xsl:variable name="end-neg" select="starts-with($end, '-')" />
   <xsl:variable name="end-no-neg">
      <xsl:choose>
         <xsl:when test="$end-neg or starts-with($end, '+')">
            <xsl:value-of select="substring($end, 2)" />
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$end" />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   <xsl:variable name="end-no-neg-length" select="string-length($end-no-neg)" />
   <xsl:variable name="end-timezone">
      <xsl:choose>
         <xsl:when test="substring($end-no-neg, $end-no-neg-length) = 'Z'">Z</xsl:when>
         <xsl:otherwise>
            <xsl:variable name="tz" select="substring($end-no-neg, $end-no-neg-length - 5)" />
            <xsl:if test="(substring($tz, 1, 1) = '-' or 
                           substring($tz, 1, 1) = '+') and
                          substring($tz, 4, 1) = ':'">
               <xsl:value-of select="$tz" />
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>

   <xsl:variable name="difference">
      <xsl:if test="(not(string($start-timezone)) or
                     $start-timezone = 'Z' or 
                     (substring($start-timezone, 2, 2) &lt;= 23 and
                      substring($start-timezone, 5, 2) &lt;= 59)) and
                    (not(string($end-timezone)) or
                     $end-timezone = 'Z' or 
                     (substring($end-timezone, 2, 2) &lt;= 23 and
                      substring($end-timezone, 5, 2) &lt;= 59))">
         <xsl:variable name="start-dt" select="substring($start-no-neg, 1, $start-no-neg-length - string-length($start-timezone))" />
         <xsl:variable name="start-dt-length" select="string-length($start-dt)" />
         <xsl:variable name="end-dt" select="substring($end-no-neg, 1, $end-no-neg-length - string-length($end-timezone))" />
         <xsl:variable name="end-dt-length" select="string-length($end-dt)" />

         <xsl:variable name="start-year" select="substring($start-dt, 1, 4) * (($start-neg * -2) + 1)" />
         <xsl:variable name="end-year" select="substring($end-dt, 1, 4) * (($end-neg * -2) + 1)" />
         <xsl:variable name="diff-year" select="$end-year - $start-year" />
         <xsl:choose>
            <xsl:when test="not(number($start-year) and number($end-year))" />
            <xsl:when test="$start-dt-length = 4 or $end-dt-length = 4">
               <xsl:choose>
                  <xsl:when test="$diff-year &lt; 0">-P<xsl:value-of select="$diff-year * -1" />Y</xsl:when>
                  <xsl:otherwise>P<xsl:value-of select="$diff-year" />Y</xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <xsl:when test="substring($start-dt, 5, 1) = '-' and 
                            substring($end-dt, 5, 1) = '-'">
               <xsl:variable name="start-month" select="substring($start-dt, 6, 2)" />
               <xsl:variable name="end-month" select="substring($end-dt, 6, 2)" />
               <xsl:variable name="diff-month" select="$end-month - $start-month" />
               <xsl:choose>
                  <xsl:when test="not($start-month &lt;= 12 and $end-month &lt;= 12)" />
                  <xsl:when test="$start-dt-length = 7 or $end-dt-length = 7">
                     <xsl:variable name="months" select="$diff-month + ($diff-year * 12)" />
                     <xsl:variable name="abs-months" select="$months * ((($months >= 0) * 2) - 1)" />
                     <xsl:variable name="y" select="floor($abs-months div 12)" />
                     <xsl:variable name="m" select="$abs-months mod 12" />
                     <xsl:if test="$months &lt; 0">-</xsl:if>
                     <xsl:text>P</xsl:text>
                     <xsl:if test="$y"><xsl:value-of select="$y" />Y</xsl:if>
                     <xsl:if test="$m"><xsl:value-of select="$m" />M</xsl:if>
                  </xsl:when>
                  <xsl:when test="substring($start-dt, 8, 1) = '-' and
                                  substring($end-dt, 8, 1) = '-'">
                     <xsl:variable name="start-day" select="substring($start-dt, 9, 2)" />
                     <xsl:variable name="end-day" select="substring($end-dt, 9, 2)" />
                     <xsl:if test="$start-day &lt;= 31 and $end-day &lt;= 31">
                        <xsl:variable name="month-lengths" select="document('')/*/date:month-lengths/date:month" />
                        <xsl:variable name="start-y-1" select="$start-year - 1" />
                        <xsl:variable name="start-leaps" 
                                      select="floor($start-y-1 div 4) -
                                              floor($start-y-1 div 100) +
                                              floor($start-y-1 div 400)" />
                        <xsl:variable name="start-leap" select="(not($start-year mod 4) and $start-year mod 100) or not($start-year mod 400)" />
                        <xsl:variable name="start-month-days" 
                                      select="sum($month-lengths[position() &lt; $start-month])" />
                        <xsl:variable name="start-days">
                           <xsl:variable name="days" 
                                         select="($start-year * 365) + $start-leaps +
                                                 $start-month-days + $start-day" />
                           <xsl:choose>
                              <xsl:when test="$start-leap">
                                 <xsl:value-of select="$days + 1" />
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="$days" />
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="end-y-1" select="$end-year - 1" />
                        <xsl:variable name="end-leaps" 
                                      select="floor($end-y-1 div 4) -
                                              floor($end-y-1 div 100) +
                                              floor($end-y-1 div 400)" />
                        <xsl:variable name="end-leap" select="(not($end-year mod 4) and $end-year mod 100) or not($end-year mod 400)" />
                        <xsl:variable name="end-month-days" 
                                      select="sum($month-lengths[position() &lt; $end-month])" />
                        <xsl:variable name="end-days">
                           <xsl:variable name="days" 
                                         select="($end-year * 365) + $end-leaps +
                                                 $end-month-days + $end-day" />
                           <xsl:choose>
                              <xsl:when test="$end-leap">
                                 <xsl:value-of select="$days + 1" />
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="$days" />
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="diff-days" select="$end-days - $start-days" />
                        <xsl:choose>
                           <xsl:when test="$start-dt-length = 10 or $end-dt-length = 10">
                              <xsl:choose>
                                 <xsl:when test="$diff-days &lt; 0">-P<xsl:value-of select="$diff-days * -1" />D</xsl:when>
                                 <xsl:otherwise>P<xsl:value-of select="$diff-days" />D</xsl:otherwise>
                              </xsl:choose>
                           </xsl:when>
                           <xsl:when test="substring($start-dt, 11, 1) = 'T' and
                                           substring($end-dt, 11, 1) = 'T' and
                                           substring($start-dt, 14, 1) = ':' and
                                           substring($start-dt, 17, 1) = ':' and
                                           substring($end-dt, 14, 1) = ':' and
                                           substring($end-dt, 17, 1) = ':'">
                              <xsl:variable name="start-hour" select="substring($start-dt, 12, 2)" />
                              <xsl:variable name="start-min" select="substring($start-dt, 15, 2)" />
                              <xsl:variable name="start-sec" select="substring($start-dt, 18)" />
                              <xsl:variable name="end-hour" select="substring($end-dt, 12, 2)" />
                              <xsl:variable name="end-min" select="substring($end-dt, 15, 2)" />
                              <xsl:variable name="end-sec" select="substring($end-dt, 18)" />
                              <xsl:if test="$start-hour &lt;= 23 and $end-hour &lt;= 23 and
                                            $start-min &lt;= 59 and $end-min &lt;= 59 and
                                            $start-sec &lt;= 60 and $end-sec &lt;= 60">
                                 <xsl:variable name="min-s" select="60" />
                                 <xsl:variable name="hour-s" select="60 * 60" />
                                 <xsl:variable name="day-s" select="60 * 60 * 24" />

                                 <xsl:variable name="start-tz-adj">
                                    <xsl:variable name="tz" 
                                                  select="(substring($start-timezone, 2, 2) * $hour-s) + 
                                                          (substring($start-timezone, 5, 2) * $min-s)" />
                                    <xsl:choose>
                                       <xsl:when test="starts-with($start-timezone, '-')">
                                          <xsl:value-of select="$tz" />
                                       </xsl:when>
                                       <xsl:when test="starts-with($start-timezone, '+')">
                                          <xsl:value-of select="$tz * -1" />
                                       </xsl:when>
                                       <xsl:otherwise>0</xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:variable>
                                 <xsl:variable name="end-tz-adj">
                                    <xsl:variable name="tz" 
                                                  select="(substring($end-timezone, 2, 2) * $hour-s) + 
                                                          (substring($end-timezone, 5, 2) * $min-s)" />
                                    <xsl:choose>
                                       <xsl:when test="starts-with($end-timezone, '-')">
                                          <xsl:value-of select="$tz" />
                                       </xsl:when>
                                       <xsl:when test="starts-with($end-timezone, '+')">
                                          <xsl:value-of select="$tz * -1" />
                                       </xsl:when>
                                       <xsl:otherwise>0</xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:variable>

                                 <xsl:variable name="start-secs" select="$start-sec + ($start-min * $min-s) + ($start-hour * $hour-s) + ($start-days * $day-s) + $start-tz-adj" />
                                 <xsl:variable name="end-secs" select="$end-sec + ($end-min * $min-s) + ($end-hour * $hour-s) + ($end-days * $day-s) + $end-tz-adj" />
                                 <xsl:variable name="diff-secs" select="$end-secs - $start-secs" />
                                 <xsl:variable name="s" select="$diff-secs * ((($diff-secs &lt; 0) * -2) + 1)" />
                                 <xsl:variable name="days" select="floor($s div $day-s)" />
                                 <xsl:variable name="hours" select="floor(($s - ($days * $day-s)) div $hour-s)" />
                                 <xsl:variable name="mins" select="floor(($s - ($days * $day-s) - ($hours * $hour-s)) div $min-s)" />
                                 <xsl:variable name="secs" select="$s - ($days * $day-s) - ($hours * $hour-s) - ($mins * $min-s)" />
                                 <xsl:if test="$diff-secs &lt; 0">-</xsl:if>
                                 <xsl:text>P</xsl:text>
                                 <xsl:if test="$days">
                                    <xsl:value-of select="$days" />
                                    <xsl:text>D</xsl:text>
                                 </xsl:if>
                                 <xsl:if test="$hours or $mins or $secs">T</xsl:if>
                                 <xsl:if test="$hours">
                                    <xsl:value-of select="$hours" />
                                    <xsl:text>H</xsl:text>
                                 </xsl:if>
                                 <xsl:if test="$mins">
                                    <xsl:value-of select="$mins" />
                                    <xsl:text>M</xsl:text>
                                 </xsl:if>
                                 <xsl:if test="$secs">
                                    <xsl:value-of select="$secs" />
                                    <xsl:text>S</xsl:text>
                                 </xsl:if>
                              </xsl:if>
                           </xsl:when>
                        </xsl:choose>
                     </xsl:if>
                  </xsl:when>
               </xsl:choose>
            </xsl:when>
         </xsl:choose>
      </xsl:if>
   </xsl:variable>
   <xsl:value-of select="$difference" />   

  </xsl:template>

</xsl:stylesheet>
