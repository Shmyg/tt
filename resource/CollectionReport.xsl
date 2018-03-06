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
  
  File:    CollectionReport.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> HTML stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms collection reports.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/CollectionReport.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" exclude-result-prefixes="xsl cur">

  <!-- collection report -->
  <xsl:template match="CollectionReport">

    <center><h2>
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','432')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
    </h2></center>

    <table width="40%" border="1" cellspacing="0" cellpadding="0">
      <tr>
        <!-- total period -->
        <td><font size="-1"><b>
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','433')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </b></font></td>
        <td align="right"><font size="-1"><b>
          <!-- period start -->
          <xsl:if test="Date[@Type='START']">
            <xsl:call-template name="date-format">
              <xsl:with-param name="date" select="Date[@Type='START']/@Date"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="Date[@Type='END']">
            <xsl:text> - </xsl:text>
            <!-- period end -->
            <xsl:call-template name="date-format">
              <xsl:with-param name="date" select="Date[@Type='END']/@Date"/>
            </xsl:call-template>
          </xsl:if>
        </b></font></td>          
      </tr>    
    </table>
    <!-- BSCS iX R3, R4 -->
    <xsl:for-each select="CollectionDataPerBu">
      <xsl:apply-templates select="."/>
    </xsl:for-each>    
    <!-- BSCS iX R2 -->
    <xsl:for-each select="CollectionDataPerCo">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:template>

  <!-- collected data per business unit -->
  <xsl:template match="CollectionDataPerBu">
    <br/>    
    <table width="40%" border="1" cellspacing="0" cellpadding="0">
      <!-- business unit -->
      <tr>      
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','495')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="@BuShdes"/>
            <xsl:with-param name="Type"  select="'BU'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>          
        </font></td>
      </tr>
    </table>
    <xsl:for-each select="CollectionDataPerCo">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:template>

  <!-- collected data per contract -->
  <xsl:template match="CollectionDataPerCo">
    <br/>    
    <table width="40%" border="1" cellspacing="0" cellpadding="0">
      <!-- customer id -->
      <tr>      
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','434')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:value-of select="@CustId"/>
        </font></td>
      </tr>
      <!-- contract id -->
      <tr>      
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','435')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:value-of select="@CoId"/>
        </font></td>
      </tr>
      <!-- billed amount -->
      <tr>
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','436')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:variable name="number-format-705">      
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="Charge[@Id='705']/@Amount"/>
            </xsl:call-template> 
          </xsl:variable> 
          <xsl:value-of select="$number-format-705"/>
          <xsl:text> </xsl:text>
          <xsl:for-each select="Charge[@Id='705']/@CurrCode">
            <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
          </xsl:for-each>
        </font></td>
      </tr>
      <!-- paid amount -->
      <tr>
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','437')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:variable name="number-format-706">      
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="Charge[@Id='706']/@Amount"/>
            </xsl:call-template> 
          </xsl:variable> 
          <xsl:value-of select="$number-format-706"/>
          <xsl:text> </xsl:text>
          <xsl:for-each select="Charge[@Id='706']/@CurrCode">
            <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
          </xsl:for-each>
        </font></td>
      </tr>
      <!-- open amount -->
      <tr>
        <td><font size="-1">
          <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','438')[@xml:lang=$lang]/@Des"/>
          </xsl:for-each>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:variable name="number-format-707">      
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="Charge[@Id='707']/@Amount"/>
            </xsl:call-template> 
          </xsl:variable> 
          <xsl:value-of select="$number-format-707"/>
          <xsl:text> </xsl:text>
          <xsl:for-each select="Charge[@Id='707']/@CurrCode">
            <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
          </xsl:for-each>          
        </font></td>
      </tr>
    </table>
    <xsl:if test="CollectionDataPerSN">
      <br/>
      <table width="100%" border="1" cellspacing="0" cellpadding="0">
        <tr>          
          <xsl:for-each select="$txt">
            <!-- article -->
            <th nowrap="nowrap"><font size="-1">
              <xsl:value-of select="key('txt-index','439')[@xml:lang=$lang]/@Des"/>
            </font></th>
            <!-- service -->
            <th nowrap="nowrap"><font size="-1">
              <xsl:value-of select="key('txt-index','440')[@xml:lang=$lang]/@Des"/>
            </font></th>
            <!-- billed amount -->
            <th nowrap="nowrap"><font size="-1">
              <xsl:value-of select="key('txt-index','436')[@xml:lang=$lang]/@Des"/>
            </font></th>
            <!-- paid amount -->
            <th nowrap="nowrap"><font size="-1">
              <xsl:value-of select="key('txt-index','437')[@xml:lang=$lang]/@Des"/>
            </font></th>
            <!-- open amount -->
            <th nowrap="nowrap"><font size="-1">
              <xsl:value-of select="key('txt-index','438')[@xml:lang=$lang]/@Des"/>
            </font></th>
          </xsl:for-each>                                             
        </tr>      
        <xsl:for-each select="CollectionDataPerSN">
          <tr>
            <xsl:apply-templates select="."/>
          </tr>
        </xsl:for-each>
      </table>
    </xsl:if>
  </xsl:template>

  <!-- collected data per service -->
  <xsl:template match="CollectionDataPerSN">
    <!-- article -->
    <td align="center"><font size="-1">
      <xsl:value-of select="@AS"/>
    </font></td>
    <!-- service -->
    <td align="center"><font size="-1">
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="@SN"/>
        <xsl:with-param name="Type"  select="'SN'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
    </font></td>
    <!-- billed amount -->
    <td align="right"><font size="-1">
      <xsl:variable name="number-format-705">      
        <xsl:call-template name="number-format">
          <xsl:with-param name="number" select="Charge[@Id='705']/@Amount"/>
        </xsl:call-template> 
      </xsl:variable> 
      <xsl:value-of select="$number-format-705"/>
      <xsl:text> </xsl:text>
      <xsl:for-each select="Charge[@Id='705']/@CurrCode">
        <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
      </xsl:for-each>
    </font></td>
    <!-- paid amount -->
    <td align="right"><font size="-1">
      <xsl:variable name="number-format-706">      
        <xsl:call-template name="number-format">
          <xsl:with-param name="number" select="Charge[@Id='706']/@Amount"/>
        </xsl:call-template> 
      </xsl:variable> 
      <xsl:value-of select="$number-format-706"/>
      <xsl:text> </xsl:text>
      <xsl:for-each select="Charge[@Id='706']/@CurrCode">
        <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
      </xsl:for-each>
    </font></td>
    <!-- open amount -->
    <td align="right"><font size="-1">
      <xsl:variable name="number-format-707">      
        <xsl:call-template name="number-format">
          <xsl:with-param name="number" select="Charge[@Id='707']/@Amount"/>
        </xsl:call-template> 
      </xsl:variable> 
      <xsl:value-of select="$number-format-707"/>
      <xsl:text> </xsl:text>
      <xsl:for-each select="Charge[@Id='707']/@CurrCode">
        <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
      </xsl:for-each>
    </font></td>

  </xsl:template>

</xsl:stylesheet>