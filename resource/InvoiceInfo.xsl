<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2011 Ericsson Telekommunikation GmbH & Co. KG
                     Solution Area Billing & Customer Care

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

  File:    InvoiceInfo.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> HTML stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms invoice info documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/InvoiceInfo.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" exclude-result-prefixes="xsl cur">

  <!-- invoice info -->
  <xsl:template match="InvoiceInfo">

    <!-- currency conversion infos -->
    <xsl:if test="ConvRate">
      <br/>
      <table border="1" width="100%" cellspacing="0" cellpadding="0">
        <thead>
          <tr>
            <td colspan="7"><font size="-1"><b>
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','21')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </b></font></td>
          </tr>
        </thead>
        <tbody>
          <tr >
            <xsl:for-each select="$txt">
              <!-- exchange rate -->
              <th nowrap="nowrap"><font size="-1">
                <xsl:value-of select="key('txt-index','22')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!-- conversion details -->
              <th nowrap="nowrap"><font size="-1">
                <xsl:value-of select="key('txt-index','24')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!-- conversion date -->
              <th nowrap="nowrap"><font size="-1">
                <xsl:value-of select="key('txt-index','25')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!-- currency type -->
              <th nowrap="nowrap"><font size="-1">
                <xsl:value-of select="key('txt-index','26')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!-- currency -->
              <th nowrap="nowrap"><font size="-1">
                <xsl:value-of select="key('txt-index','27')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!-- target currency type -->
              <th nowrap="nowrap"><font size="-1">
                <xsl:value-of select="key('txt-index','527')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!-- target currency -->
              <th nowrap="nowrap"><font size="-1">
                <xsl:value-of select="key('txt-index','528')[@xml:lang=$lang]/@Des"/>
              </font></th>
            </xsl:for-each>
          </tr>
          <!-- conversion rates and currency infos for primary and
               secondary (if applicable) invoice currency -->
          <xsl:for-each select="ConvRate">
            <tr><xsl:apply-templates select="."/></tr>
          </xsl:for-each>
        </tbody>
      </table>
    </xsl:if>

  </xsl:template>

  <!-- conversion info -->
  <xsl:template match="ConvRate">

    <!-- conversion rate -->
    <td align="center"><font size="-1">
      <xsl:value-of select="@Rate"/>
    </font></td>
    <!-- conversion details -->
    <td align="center"><font size="-1">
      <xsl:choose>
        <xsl:when test="@Details">
          <xsl:value-of select="@Details"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>-</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </font></td>
    <!-- conversion date -->
    <td align="center"><font size="-1">
      <xsl:apply-templates select="Date"/>
    </font></td>
    <!-- source currency info -->
    <xsl:call-template name="currency-type">
      <xsl:with-param name="type"  select="Currency[1]/@Type"/>
    </xsl:call-template>
    <td nowrap="nowrap" align="center"><font size="-1">
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
    </font></td>
    <!-- destination currency info -->
    <xsl:call-template name="currency-type">
      <xsl:with-param name="type"  select="Currency[2]/@Type"/>
    </xsl:call-template>
    <td nowrap="nowrap" align="center"><font size="-1">
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
    </font></td>

  </xsl:template>

  <!-- currency type -->
  <xsl:template name="currency-type">

    <xsl:param name="type"/>

    <td nowrap="nowrap" align="center"><font size="-1">
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
    </font></td>

  </xsl:template>

  <!-- bonus points statistic -->
  <xsl:template name="BPStat">

    <xsl:param name="bpstat"/>

    <table border="1" width="40%" cellspacing="0" cellpadding="0">
      <thead>
        <tr>
          <td colspan="2"><font size="-1"><b>
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','34')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </b></font></td>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><font size="-1">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','35')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </font></td>
          <td align="right"><font size="-1">
            <xsl:if test="$bpstat/@New">
              <xsl:call-template name="volume-format">
                <xsl:with-param name="volume" select="$bpstat/@New"/>
              </xsl:call-template>
            </xsl:if>
          </font></td>
        </tr>
        <tr>
          <td><font size="-1">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','36')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </font></td>
          <td align="right"><font size="-1">
            <xsl:if test="$bpstat/@Sum">
              <xsl:call-template name="volume-format">
                <xsl:with-param name="volume" select="$bpstat/@Sum"/>
              </xsl:call-template>
            </xsl:if>
          </font></td>
        </tr>
        <tr>
          <td><font size="-1">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','37')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </font></td>
          <td align="right"><font size="-1">
            <xsl:if test="$bpstat/@Max">
              <xsl:call-template name="volume-format">
                <xsl:with-param name="volume" select="$bpstat/@Max"/>
              </xsl:call-template>
            </xsl:if>
          </font></td>
        </tr>
        <tr>
          <td><font size="-1">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','38')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </font></td>
          <td align="right"><font size="-1">
            <xsl:if test="$bpstat/@Exp">
              <xsl:call-template name="volume-format">
                <xsl:with-param name="volume" select="$bpstat/@Exp"/>
              </xsl:call-template>
            </xsl:if>
          </font></td>
        </tr>
      </tbody>
    </table>

  </xsl:template>

  <!-- bonus points -->
  <xsl:template match="BonPnt">

    <br/>
    <table border="1" width="40%" cellspacing="0" cellpadding="0">
      <thead>
        <tr>
          <td colspan="2"><font size="-1"><b>
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','39')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </b></font></td>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><font size="-1">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','40')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </font></td>
          <td><font size="-1">
            <xsl:value-of select="@Num"/>
          </font></td>
        </tr>
        <tr>
          <td><font size="-1">
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','41')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </font></td>
          <xsl:apply-templates select="Date"/>
        </tr>
      </tbody>
    </table>

  </xsl:template>

  <!-- rewards -->
  <xsl:template match="Reward">

    <xsl:choose>
      <xsl:when test="Charge">
        <td align="right"><font size="-1">
          <xsl:if test="@BonPnt">
            <xsl:call-template name="volume-format">
              <xsl:with-param name="volume" select="@BonPnt"/>
            </xsl:call-template>
          </xsl:if>
        </font></td>
        <td align="center">-</td>
        <td align="center">-</td>
        <td align="center">-</td>
        <td align="center">-</td>
        <td align="right"><font size="-1">
          <xsl:apply-templates select="Charge"/>
        </font></td>
      </xsl:when>
      <xsl:when test="RewAction">
        <td align="right"><font size="-1">
          <xsl:if test="@BonPnt">
            <xsl:call-template name="volume-format">
              <xsl:with-param name="volume" select="@BonPnt"/>
            </xsl:call-template>
          </xsl:if>
        </font></td>
        <xsl:apply-templates select="RewAction"/>
        <td align="center">-</td>
        <td align="center">-</td>
      </xsl:when>
      <xsl:when test="AdvTxt">
        <td align="right"><font size="-1">
          <xsl:if test="@BonPnt">
            <xsl:call-template name="volume-format">
              <xsl:with-param name="volume" select="@BonPnt"/>
            </xsl:call-template>
          </xsl:if>
        </font></td>
        <td align="center">-</td>
        <td align="center">-</td>
        <td align="center">-</td>
        <xsl:apply-templates select="AdvTxt"/>
        <td align="center">-</td>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- reward action -->
  <xsl:template match="RewAction">

    <td><font size="-1">
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
    </font></td>
    <td><font size="-1">
      <xsl:value-of select="@Action"/>
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
    </font></td>
    <td align="center"><font size="-1">
      <xsl:if test="@Old">
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@Old"/>
          <xsl:with-param name="Type"  select="@Entity"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
        <xsl:text> - </xsl:text>
      </xsl:if>
      <xsl:if test="@New">
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@New"/>
          <xsl:with-param name="Type"  select="@Entity"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
      </xsl:if>
    </font></td>
    <td align="center">-</td>
    <td align="center">-</td>

  </xsl:template>

  <!-- promo details -->
  <xsl:template match="PromoDetails">

    <xsl:if test="PromoResult">
      <h3><center>
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','339')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </center></h3>
    </xsl:if>
    <xsl:for-each select="PromoResult">
      <xsl:if test="position()!= '1'">
        <hr/>
      </xsl:if>
      <xsl:apply-templates select="."/>
    </xsl:for-each>

  </xsl:template>

  <!-- ************************* -->
  <!--     promo result          -->
  <!-- ************************* -->
  <xsl:template match="PromoResult">

    <table border="1" width="50%" cellspacing="0" cellpadding="0">
      <xsl:if test="BOPAlt">
        <xsl:apply-templates select="BOPAlt" mode="promo"/>
      </xsl:if>
      <xsl:apply-templates select="PromoElemRef" mode="sum"/>
    </table>
    <xsl:if test="PromoEvalResult">
      <br/>
      <table border="1" width="50%" cellspacing="0" cellpadding="0">
        <thead>
          <tr>
            <td colspan="3"><font size="-1"><b>
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','317')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </b></font></td>
          </tr>
        </thead>
        <tbody>
          <tr>
            <xsl:for-each select="$txt">
              <th><font size="-1">
                <xsl:value-of select="key('txt-index','318')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <th><font size="-1">
                <xsl:value-of select="key('txt-index','319')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <th><font size="-1">
                <xsl:value-of select="key('txt-index','320')[@xml:lang=$lang]/@Des"/>
              </font></th>
            </xsl:for-each>
          </tr>
          <xsl:for-each select="PromoEvalResult">
            <tr>
              <xsl:apply-templates select="."/>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </xsl:if>
    <xsl:if test="PromoApplResult">
      <xsl:for-each select="PromoApplResult">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <!-- ***************************** -->
  <!--    promo evaluation result    -->
  <!-- ***************************** -->
  <xsl:template match="PromoEvalResult">

    <td align="center"><font size="-1">
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="@MechId"/>
        <xsl:with-param name="Type"  select="'PMC'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
    </font></td>
    <td align="right"><font size="-1">
      <xsl:choose>
        <xsl:when test="@CurrCode">
          <xsl:call-template name="number-format">
            <xsl:with-param name="number" select="@Result"/>
          </xsl:call-template>
          <xsl:text> </xsl:text>
          <xsl:for-each select="@CurrCode">
            <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
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
    </font></td>
    <td align="center"><font size="-1">
      <xsl:value-of select="@Finished"/>
    </font></td>

  </xsl:template>

  <!-- ***************************** -->
  <!--    promo application result   -->
  <!-- ***************************** -->
  <xsl:template match="PromoApplResult">

    <br/>
    <table border="1" width="30%" cellspacing="0" cellpadding="0">
      <thead>
        <tr>
          <td colspan="2"><font size="-1"><b>
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','321')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
          </b></font></td>
        </tr>
      </thead>
      <tr>
        <xsl:for-each select="$txt">
          <td><font size="-1">
            <xsl:value-of select="key('txt-index','322')[@xml:lang=$lang]/@Des"/>
          </font></td>
        </xsl:for-each>
        <td><font size="-1">
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="@MechId"/>
            <xsl:with-param name="Type"  select="'PMC'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
        </font></td>
      </tr>
      <tr>
        <xsl:for-each select="$txt">
          <td><font size="-1">
            <xsl:value-of select="key('txt-index','323')[@xml:lang=$lang]/@Des"/>
          </font></td>
        </xsl:for-each>
        <td><font size="-1">
          <xsl:value-of select="@ApplValue"/>
          <xsl:if test="@ApplType='ABS'">
            <xsl:text> </xsl:text>
            <xsl:for-each select="Charge/@CurrCode">
              <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
          </xsl:if>
        </font></td>
      </tr>
      <tr>
        <xsl:for-each select="$txt">
          <td><font size="-1">
            <xsl:value-of select="key('txt-index','324')[@xml:lang=$lang]/@Des"/>
          </font></td>
        </xsl:for-each>
        <td><font size="-1">
          <xsl:value-of select="@ApplType"/>
        </font></td>
      </tr>
      <tr>
        <xsl:for-each select="$txt">
          <td><font size="-1">
            <xsl:value-of select="key('txt-index','325')[@xml:lang=$lang]/@Des"/>
          </font></td>
        </xsl:for-each>
        <td><font size="-1">
          <xsl:value-of select="@Finished"/>
        </font></td>
      </tr>
    </table>
    <!-- rewards -->
    <xsl:if test="Reward">
      <br/>
      <table border="1" width="100%" cellspacing="0" cellpadding="0">
        <thead>
          <tr>
            <td colspan="6"><font size="-1"><b>
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','42')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </b></font></td>
          </tr>
        </thead>
        <tbody>
          <tr>
            <xsl:for-each select="$txt">
              <th><font size="-1">
                <xsl:value-of select="key('txt-index','43')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <th><font size="-1">
                <xsl:value-of select="key('txt-index','46')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <th><font size="-1">
                <xsl:value-of select="key('txt-index','47')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <th><font size="-1">
                <xsl:value-of select="key('txt-index','48')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <th><font size="-1">
                <xsl:value-of select="key('txt-index','49')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <th><font size="-1">
                <xsl:value-of select="key('txt-index','50')[@xml:lang=$lang]/@Des"/>
              </font></th>
            </xsl:for-each>
          </tr>
          <xsl:for-each select="Reward">
            <tr>
              <xsl:apply-templates select="."/>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </xsl:if>

    <!--  granted credit to prepaid balance  -->
    <xsl:if test="PromoCreditsPerCo">
      <br/>
      <table border="1" width="100%" cellspacing="0" cellpadding="0">
        <thead>
          <tr>
            <td colspan="5" align="center"><font size="-1"><b>
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','430')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </b></font></td>
          </tr>
        </thead>
        <tbody>
          <tr>
            <xsl:for-each select="$txt">
              <!-- contract no. -->
              <th><font size="-1">
                <xsl:value-of select="key('txt-index','388')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!--  service -->
              <th><font size="-1">
                <xsl:value-of select="key('txt-index','249')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!--  profile -->
              <th><font size="-1">
                  <xsl:value-of select="key('txt-index','139')[@xml:lang=$lang]/@Des" />
              </font></th>
              <!--  pricing type -->
              <th><font size="-1">
                <xsl:value-of select="key('txt-index','253')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!--  credit amount -->
              <th><font size="-1">
                <xsl:value-of select="key('txt-index','431')[@xml:lang=$lang]/@Des"/>
              </font></th>
            </xsl:for-each>
          </tr>
          <xsl:for-each select="PromoCreditsPerCo">
            <xsl:for-each select="PromoCreditPerBal">
              <tr>
                <xsl:if test="position()='1'">
                  <td align="center" nowrap="nowrap">
                    <xsl:attribute name="rowspan">
                      <xsl:value-of select="count(../PromoCreditPerBal)"/>
                    </xsl:attribute>
                    <font size="-1">
                      <xsl:value-of select="../@CoId"/>
                    </font>
                  </td>
                </xsl:if>
                <xsl:apply-templates select="." mode="promo"/>
              </tr>
            </xsl:for-each>
          </xsl:for-each>
        </tbody>
      </table>
    </xsl:if>
    <!-- bonus points -->
    <!--xsl:if test="BonPnt">
      <xsl:apply-templates select="BonPnt"/>
    </xsl:if-->
    <!-- applied amount -->
    <!--xsl:if test="Charge">
      <br/>
      <table border="1" cellspacing="0" cellpadding="0">
        <thead>
          <tr>
            <td><font size="-1"><b>
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','44')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </b></font></td>
          </tr>
        </thead>
        <tbody>
          <tr><td align="right"><font size="-1">
            <xsl:apply-templates select="Charge"/>
          </font></td></tr>
        </tbody>
      </table>
    </xsl:if-->

  </xsl:template>

  <!-- advertisement text -->
  <xsl:template match="AdvTxt">

    <xsl:choose>
      <xsl:when test="name(..)='Reward'">
        <td><font size="-1">
          <xsl:value-of select="."/>
        </font></td>
      </xsl:when>
      <xsl:when test="name(..)='InvoiceInfo'">
        <p align="center"><b>
          <xsl:value-of select="."/>
        </b></p>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- mailing item -->
  <xsl:template match="MailIt">

    <h4>
      <xsl:value-of select="."/>
    </h4>

  </xsl:template>

</xsl:stylesheet>
