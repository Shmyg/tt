<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    InvoiceInfoFO.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> XSL-FO stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms invoice info documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/InvoiceInfoFO.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" exclude-result-prefixes="xsl cur">

  <!-- invoice info -->
  <xsl:template match="InvoiceInfo">

    <!-- currency conversion infos -->
    <xsl:if test="ConvRate">

      <fo:block>
          <fo:block space-before="6mm" font-size="9pt" font-weight="bold" text-align="center">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','21')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </fo:block>
        <fo:table table-layout="fixed" width="160mm">
          <fo:table-column column-width="22mm" column-number="1"/>
          <fo:table-column column-width="28mm" column-number="2"/>
          <fo:table-column column-width="22mm" column-number="3"/>
          <fo:table-column column-width="22mm" column-number="4"/>
          <fo:table-column column-width="22mm" column-number="5"/>
          <fo:table-column column-width="22mm" column-number="6"/>
          <fo:table-column column-width="22mm" column-number="7"/>
          <fo:table-header space-after="3mm">
            <fo:table-row>
              <!-- exchange rate -->
              <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
                <fo:block space-before="2mm" font-size="8pt" font-weight="bold" text-align="center">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','22')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <!-- conversion details -->
              <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
                <fo:block space-before="2mm" font-size="8pt" font-weight="bold" text-align="center">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','24')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <!-- conversion date -->
              <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
                <fo:block space-before="2mm" font-size="8pt" font-weight="bold" text-align="center">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','25')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <!-- currency type -->
              <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
                <fo:block space-before="2mm" font-size="8pt" font-weight="bold" text-align="center">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','26')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <!-- currency -->
              <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
                <fo:block space-before="2mm" font-size="8pt" font-weight="bold" text-align="center">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','27')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <!-- target currency type -->
              <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
                <fo:block space-before="2mm" font-size="8pt" font-weight="bold" text-align="center">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','527')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <!-- target currency -->
              <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
                <fo:block space-before="2mm" font-size="8pt" font-weight="bold" text-align="center">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','528')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-header>
          <fo:table-body>
            <!-- conversion rates and currency infos for primary and
               secondary (if applicable) invoice currency -->
            <xsl:for-each select="ConvRate">
              <fo:table-row>
                <xsl:apply-templates select="."/>
              </fo:table-row>
            </xsl:for-each>
          </fo:table-body>
        </fo:table>
      </fo:block>
    </xsl:if>

  </xsl:template>

  <!-- conversion info -->
  <xsl:template match="ConvRate">

    <!-- conversion rate -->
    <fo:table-cell>
      <fo:block font-size="7pt" text-align="center">
        <xsl:value-of select="@Rate"/>
      </fo:block>
    </fo:table-cell>
    <!-- conversion details -->
    <fo:table-cell>
      <fo:block font-size="7pt" text-align="center">
        <xsl:choose>
          <xsl:when test="@Details">
            <xsl:value-of select="@Details"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>-</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:table-cell>
    <!-- conversion date -->
    <fo:table-cell>
      <fo:block font-size="7pt" text-align="center">
        <xsl:apply-templates select="Date"/>
      </fo:block>
    </fo:table-cell>
    <!-- source currency info -->
    <xsl:call-template name="currency-type">
      <xsl:with-param name="type"  select="Currency[1]/@Type"/>
    </xsl:call-template>
    <fo:table-cell>
      <fo:block font-size="7pt" text-align="center">
        <xsl:for-each select="Currency[1]/@CurrCode">
          <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
        </xsl:for-each>
        <xsl:text> - </xsl:text>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="Currency[1]/@CurrCode"/>
          <xsl:with-param name="Type"  select="'CURR'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <!-- destination currency info -->
    <xsl:call-template name="currency-type">
      <xsl:with-param name="type"  select="Currency[2]/@Type"/>
    </xsl:call-template>
    <fo:table-cell>
      <fo:block font-size="7pt" text-align="center">
        <xsl:for-each select="Currency[2]/@CurrCode">
          <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
        </xsl:for-each>
        <xsl:text> - </xsl:text>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="Currency[2]/@CurrCode"/>
          <xsl:with-param name="Type"  select="'CURR'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>

  </xsl:template>

  <!-- currency type -->
  <xsl:template name="currency-type">

    <xsl:param name="type"/>

    <fo:table-cell>
      <fo:block font-size="7pt" text-align="center">
        <xsl:choose>
          <!-- home currency -->
          <xsl:when test="$type='1'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','29')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <!-- invoice currency -->
          <xsl:when test="$type='2'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','30')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <!-- secondary invoice currency -->
          <xsl:when test="$type='3'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','31')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <!-- transaction currency -->
          <xsl:when test="$type='4'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','32')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </fo:block>
    </fo:table-cell>

  </xsl:template>

  <!-- bonus points statistic -->
  <xsl:template name="BPStat">

    <xsl:param name="bpstat"/>

    <fo:block>
      <fo:block space-before="6mm" font-size="9pt" font-weight="bold"
        text-align="center">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','34')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </fo:block>
      <fo:table width="160mm" table-layout="fixed">
        <fo:table-column column-width="30mm"/>
        <fo:table-column column-width="80mm"/>
        <fo:table-column column-width="20mm"/>
        <fo:table-column column-width="30mm"/>
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <fo:table-cell padding-top="2pt" border-top-style="solid" border-top-width="0.01pt" border-top-color="black">
              <fo:block font-size="8pt" text-align="left">
                <!-- granted bonus points -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','35')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell padding-top="2pt" border-top-style="solid" border-top-width="0.01pt" border-top-color="black">
              <fo:block font-size="8pt" text-align="right">
                <xsl:if test="$bpstat/@New">
                  <xsl:call-template name="volume-format">
                    <xsl:with-param name="volume" select="$bpstat/@New"/>
                  </xsl:call-template>
                </xsl:if>
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
                <!-- actual bonus points -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','36')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block font-size="8pt" text-align="right">
                <xsl:if test="$bpstat/@Sum">
                  <xsl:call-template name="volume-format">
                    <xsl:with-param name="volume" select="$bpstat/@Sum"/>
                  </xsl:call-template>
                </xsl:if>
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
                <!-- maximum bonus points -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','37')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block font-size="8pt" text-align="right">
                <xsl:if test="$bpstat/@Max">
                  <xsl:call-template name="volume-format">
                    <xsl:with-param name="volume" select="$bpstat/@Max"/>
                  </xsl:call-template>
                </xsl:if>
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
                <!-- expired bonus points -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','38')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block font-size="8pt" text-align="right">
                <xsl:if test="$bpstat/@Exp">
                  <xsl:call-template name="volume-format">
                    <xsl:with-param name="volume" select="$bpstat/@Exp"/>
                  </xsl:call-template>
                </xsl:if>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </fo:block>

  </xsl:template>

  <!-- promo details -->
  <xsl:template match="PromoDetails">

    <xsl:if test="PromoResult">
      <xsl:if test="$fmt != 'rtf'">
    <fo:block break-before="page" space-after="2mm" text-align="center" font-weight="bold" font-size="12pt">
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','339')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
    </fo:block>
      </xsl:if>
      <xsl:if test="$fmt = 'rtf'">
        <fo:block space-before="6mm" space-after="2mm" text-align="center" font-weight="bold" font-size="12pt">
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','339')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
    </fo:block>
      </xsl:if>
    </xsl:if>

    <xsl:for-each select="PromoResult">
      <xsl:sort select="./PromoElemRef/CustId" data-type="text" order="ascending"/>
      <xsl:apply-templates select="."/>
    </xsl:for-each>

  </xsl:template>

  <!-- promo result -->
  <xsl:template match="PromoResult">

    <xsl:if test="BOPAlt">
      <xsl:apply-templates select="BOPAlt" mode="promo"/>
    </xsl:if>
    <xsl:apply-templates select="PromoElemRef" mode="sum"/>
    <xsl:if test="PromoEvalResult">
      <fo:block>
        <fo:block space-before="2mm" font-size="8pt" font-weight="bold" text-align="center">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','317')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </fo:block>
        <fo:table width="160mm" table-layout="fixed">
          <fo:table-column column-width="30.05mm"/>
          <fo:table-column column-width="33.3mm"/>
          <fo:table-column column-width="33.3mm"/>
          <fo:table-column column-width="33.3mm"/>
          <fo:table-column column-width="30.05mm"/>
          <fo:table-header space-after="2pt">
            <fo:table-row>
          <fo:table-cell>
            <fo:block/>
          </fo:table-cell>
              <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
                <fo:block font-size="8pt" text-align="center">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','318')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
                <fo:block font-size="8pt" text-align="center">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','320')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
                <fo:block font-size="8pt" text-align="center">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','319')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block/>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-header>
          <fo:table-body>
            <xsl:for-each select="PromoEvalResult">
              <fo:table-row>
                <xsl:apply-templates select="."/>
              </fo:table-row>
            </xsl:for-each>
          </fo:table-body>
        </fo:table>
      </fo:block>
    </xsl:if>
    <xsl:if test="PromoApplResult">
      <xsl:for-each select="PromoApplResult">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:if>

  </xsl:template>

  <!-- promo evaluation -->
  <xsl:template match="PromoEvalResult">
    <fo:table-cell>
      <fo:block/>
    </fo:table-cell>
    <!-- evaluation mechanism -->
    <fo:table-cell>
      <fo:block font-size="8pt" text-align="center">
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode" select="'0'"/>
          <xsl:with-param name="Index" select="@MechId"/>
          <xsl:with-param name="Type" select="'PMC'"/>
          <xsl:with-param name="Desc" select="'1'"/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
    <!-- evaluation status -->
    <fo:table-cell>
      <fo:block font-size="8pt" text-align="center">
        <xsl:choose>
          <xsl:when test="@Finished='YES'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','391')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','392')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:table-cell>
    <!-- evaluation result -->
    <fo:table-cell>
      <fo:block font-size="8pt" text-align="right">
        <xsl:choose>
          <xsl:when test="@CurrCode">
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="@Result"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>
            <xsl:for-each select="@CurrCode">
              <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="@UoM">
            <xsl:call-template name="number-unit-format">
              <xsl:with-param name="number" select="@Result"/>
              <xsl:with-param name="unit" select="@UoM"/>
            </xsl:call-template>
          </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="@Result"/>
	  </xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell>
      <fo:block/>
    </fo:table-cell>

  </xsl:template>

  <!-- promo application result -->
  <xsl:template match="PromoApplResult">

    <fo:block>
      <fo:block space-before="2mm" font-size="8pt" font-weight="bold" text-align="center">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','321')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </fo:block>

      <fo:table width="160mm" table-layout="fixed">
        <fo:table-column column-width="30mm"/>
        <fo:table-column column-width="50mm"/>
        <fo:table-column column-width="50mm"/>
        <fo:table-column column-width="30mm"/>
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <fo:table-cell padding-top="2pt" border-top-style="solid" border-top-width="0.01pt" border-top-color="black">
              <fo:block font-size="8pt" text-align="left">
                <!-- application mechanism -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','322')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell padding-top="2pt" border-top-style="solid" border-top-width="0.01pt" border-top-color="black">
              <fo:block font-size="8pt" text-align="right">
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode" select="'0'"/>
                  <xsl:with-param name="Index" select="@MechId"/>
                  <xsl:with-param name="Type" select="'PMC'"/>
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
                <!-- application status -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','325')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block font-size="8pt" text-align="right">
                <xsl:choose>
                  <xsl:when test="@Finished='YES'">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','391')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','392')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </xsl:otherwise>
                </xsl:choose>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
          <fo:table-row>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block font-size="8pt" text-align="left">
                <!-- application type -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','324')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block font-size="8pt" text-align="right">
                <xsl:choose>
                  <xsl:when test="@ApplType='ABS'">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','389')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','390')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </xsl:otherwise>
                </xsl:choose>
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
                <!-- application value (charge, bonus points, etc. )-->
                <xsl:choose>
                  <xsl:when test="Charge">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','393')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:when test="BonPnt">
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','39')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','323')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                  </xsl:otherwise>
                </xsl:choose>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block font-size="8pt" text-align="right">
                <xsl:value-of select="@ApplValue"/>
                <xsl:if test="@ApplType='ABS' and Charge">
                  <xsl:text> </xsl:text>
                  <xsl:for-each select="Charge/@CurrCode">
                    <xsl:value-of select="document('CommonFO.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                  </xsl:for-each>
                </xsl:if>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>
          <!-- it is not necessary to show the bonus points or applied amounts here
               because they are given in the application value attribute -->
          <!-- applied amount -->
          <xsl:if test="Charge">
            <fo:table-row>
              <fo:table-cell>
                <fo:block/>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block font-size="8pt" text-align="left">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','394')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell font-size="8pt">
                <xsl:apply-templates select="Charge"/>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          <!-- bonus points -->
          <!--
          <xsl:if test="BonPnt">
            <xsl:apply-templates select="BonPnt"/>
          </xsl:if>
          -->
        </fo:table-body>
      </fo:table>
    </fo:block>

    <!-- rewards -->
    <xsl:if test="Reward">

      <fo:block>
        <fo:block space-before="2mm" font-size="8pt" font-weight="bold" text-align="center">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','42')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </fo:block>
        <fo:table width="160mm" table-layout="fixed">
          <fo:table-column column-width="20mm" column-number="1"/>
          <fo:table-column column-width="30mm" column-number="2"/>
          <fo:table-column column-width="15mm" column-number="3"/>
          <fo:table-column column-width="45mm" column-number="4"/>
          <fo:table-column column-width="40mm" column-number="5"/>
          <fo:table-column column-width="10mm" column-number="6"/>
          <fo:table-header space-after="2pt">
            <fo:table-row>
              <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
                <fo:block font-size="8pt" text-align="center">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','43')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
                <fo:block font-size="8pt" text-align="center">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','46')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
                <fo:block font-size="8pt" text-align="center">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','47')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
                <fo:block font-size="8pt" text-align="center">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','48')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
                <fo:block font-size="8pt" text-align="center">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','49')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
                <fo:block font-size="8pt" text-align="center">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','50')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-header>
          <fo:table-body>
            <xsl:for-each select="Reward">
              <fo:table-row>
                <xsl:apply-templates select="."/>
              </fo:table-row>
            </xsl:for-each>
          </fo:table-body>
        </fo:table>
      </fo:block>
    </xsl:if>

    <!--  granted credit to prepaid balance  -->
    <xsl:if test="PromoCreditsPerCo">
      
      <fo:block>
        <fo:block space-before="2mm" font-size="8pt" font-weight="bold" text-align="center">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','430')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </fo:block>
        <fo:table width="160mm" table-layout="fixed">

          <fo:table-column column-width="20mm"/>
          <fo:table-column column-width="30mm"/>
          <fo:table-column column-width="35mm"/>
          <fo:table-column column-width="30mm"/>
          <fo:table-column column-width="10mm"/>
          <fo:table-column column-width="15mm"/>
          <fo:table-column column-width="20mm"/>


          <fo:table-header space-after="2pt">
            <fo:table-row>
              <xsl:for-each select="$txt">
                <fo:table-cell>
                  <fo:block/>
                </fo:table-cell>
                <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
                  <fo:block font-size="8pt" text-align="center">
                    <xsl:value-of select="key('txt-index','388')[@xml:lang=$lang]/@Des"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
                  <fo:block font-size="8pt" text-align="center">
                    <xsl:value-of select="key('txt-index','249')[@xml:lang=$lang]/@Des"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
                  <fo:block font-size="8pt" text-align="center">
                    <xsl:value-of select="key('txt-index','139')[@xml:lang=$lang]/@Des"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
                  <fo:block font-size="8pt" text-align="center">
                    <xsl:value-of select="key('txt-index','253')[@xml:lang=$lang]/@Des"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border-bottom-style="solid" border-bottom-width="0.01pt" border-bottom-color="black">
                  <fo:block font-size="8pt" text-align="center">
                    <xsl:value-of select="key('txt-index','431')[@xml:lang=$lang]/@Des"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell>
                  <fo:block/>
                </fo:table-cell>
              </xsl:for-each>
            </fo:table-row>
          </fo:table-header>
          <fo:table-body  font-size="8pt">
            <xsl:for-each select="PromoCreditsPerCo">
              <xsl:for-each select="PromoCreditPerBal">
                <fo:table-row>
                  <xsl:if test="position()='1'">
                    <fo:table-cell>
                      <xsl:attribute name="number-rows-spanned">
                        <xsl:value-of select="count(../PromoCreditPerBal)"/>
                      </xsl:attribute>
                      <fo:block/>
                    </fo:table-cell>
                    <fo:table-cell text-align="center" display-align="center">
                      <xsl:attribute name="number-rows-spanned">
                        <xsl:value-of select="count(../PromoCreditPerBal)"/>
                      </xsl:attribute>
                      <fo:block>
                        <xsl:value-of select="../@CoId"/>
                      </fo:block>
                    </fo:table-cell>
                  </xsl:if>
                  <xsl:apply-templates select="." mode="promo"/>
                <fo:table-cell>
                  <fo:block/>
                </fo:table-cell>
                </fo:table-row>
                <xsl:if test="position()=last()">
                  <fo:table-row>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
                    <fo:table-cell padding-after="1pt" border-top-style="solid" border-top-width="0.01pt" border-top-color="black" number-columns-spanned="5">
                      <fo:block/>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>
              </xsl:for-each>
            </xsl:for-each>
          </fo:table-body>
        </fo:table>
      </fo:block>
    </xsl:if>

  </xsl:template>

  <!-- rewards -->
  <xsl:template match="Reward">

    <xsl:choose>
      <xsl:when test="Charge">
        <!-- bonus points -->
        <fo:table-cell>
          <fo:block font-size="8pt" text-align="center">
            <xsl:if test="@BonPnt">
              <xsl:call-template name="volume-format">
                <xsl:with-param name="volume" select="@BonPnt"/>
              </xsl:call-template>
            </xsl:if>
          </fo:block>
        </fo:table-cell>
        <fo:table-cell number-columns-spanned="4">
          <fo:block/>
        </fo:table-cell>
        <!-- discount amount -->
        <fo:table-cell font-size="8pt" text-align="right">
          <xsl:apply-templates select="Charge"/>
        </fo:table-cell>
      </xsl:when>
      <xsl:when test="RewAction">
        <!-- bonus points -->
        <fo:table-cell>
          <fo:block font-size="8pt" text-align="center">
            <xsl:if test="@BonPnt">
              <xsl:call-template name="volume-format">
                <xsl:with-param name="volume" select="@BonPnt"/>
              </xsl:call-template>
            </xsl:if>
          </fo:block>
        </fo:table-cell>
        <!-- reward action -->
        <xsl:apply-templates select="RewAction"/>
      </xsl:when>
      <xsl:when test="AdvTxt">
        <!-- bonus points -->
        <fo:table-cell>
          <fo:block font-size="8pt" text-align="center">
            <xsl:if test="@BonPnt">
              <xsl:call-template name="volume-format">
                <xsl:with-param name="volume" select="@BonPnt"/>
              </xsl:call-template>
            </xsl:if>
          </fo:block>
        </fo:table-cell>
        <fo:table-cell number-columns-spanned="3">
          <fo:block/>
        </fo:table-cell>
        <!-- advertisement text -->
        <xsl:apply-templates select="AdvTxt"/>
        <fo:table-cell>
          <fo:block/>
        </fo:table-cell>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>

  </xsl:template>

  <!-- reward action -->
  <xsl:template match="RewAction">

    <fo:table-cell>
      <fo:block font-size="8pt" text-align="center">
        <xsl:choose>
          <xsl:when test="@Entity='TM'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','331')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="@Entity='FUP'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','332')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="@Entity='PP'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','333')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell>
      <fo:block font-size="8pt" text-align="center">
        <xsl:choose>
          <xsl:when test="@Action='ADD'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','334')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="@Action='DEL'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','335')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="@Action='CH'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','336')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="@Action='ACT'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','337')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="@Action='DEA'">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','338')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell>
      <fo:block font-size="8pt" text-align="center">
        <xsl:if test="@Old">
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode" select="'0'"/>
            <xsl:with-param name="Index" select="@Old"/>
            <xsl:with-param name="Type" select="@Entity"/>
            <xsl:with-param name="Desc" select="'1'"/>
          </xsl:call-template>
          <xsl:text> -&gt; </xsl:text>
        </xsl:if>
        <xsl:if test="@New">
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode" select="'0'"/>
            <xsl:with-param name="Index" select="@New"/>
            <xsl:with-param name="Type" select="@Entity"/>
            <xsl:with-param name="Desc" select="'1'"/>
          </xsl:call-template>
        </xsl:if>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell number-columns-spanned="2">
      <fo:block/>
    </fo:table-cell>

  </xsl:template>

  <!-- bonus points -->
  <xsl:template match="BonPnt">

    <fo:table-row>
      <fo:table-cell>
      	<fo:block/>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block font-size="8pt" text-align="left">
          <!-- granted bonus points -->
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','40')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
          <xsl:text> (</xsl:text>
          <!-- grant date -->
          <xsl:apply-templates select="Date"/>
          <xsl:text>)</xsl:text>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block font-size="8pt" text-align="right">
          <xsl:value-of select="@Num"/>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
      	<fo:block/>
      </fo:table-cell>
    </fo:table-row>

  </xsl:template>

  <!-- advertisement text -->
  <xsl:template match="AdvTxt">
    <xsl:choose>
      <xsl:when test="name(..)='Reward'">
        <fo:table-cell>
          <fo:block font-size="8pt" text-align="center">
            <xsl:value-of select="."/>
          </fo:block>
        </fo:table-cell>
      </xsl:when>
      <xsl:when test="name(..)='InvoiceInfo'">
        <fo:block width="160mm" border-style="solid" border-width="0.01pt" border-color="black"
          padding="0.5mm" space-before="2mm" space-after="2mm" text-align="center"
          font-family="Times" font-size="12pt" font-weight="bold" wrap-option="wrap">
          <xsl:value-of select="."/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
