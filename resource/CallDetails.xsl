<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    CallDetails.xsl

  Owner:   Matthias Fehrenbacher

  @(#) ABSTRACT : XML -> HTML stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms call details.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/CallDetails.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="xsl cur set">

  <xsl:key name="co-id" match="Contract" use="@Id"/>

  <xsl:variable name="start-date">
    <xsl:value-of select="document(/Bill/Part/@File)/Document/Invoice/Date[@Type='START']/@Date"/>
  </xsl:variable>



  <!--  sum udr tap (no bop, no bundle) -->
  <xsl:template name="print-sum-udr-tap">

    <xsl:param name="co-id"/>
    <xsl:param name="call-details"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>

    <xsl:variable name="call-details-local" select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call[XCD[@CO=$co-id]]" />

    <!-- using a exslt set template to eliminate the duplicated data ( avoid recursion ) -->
    <xsl:variable name="list-of-unique-services" select="set:distinct($call-details-local/XCD/@TapSeqNo)" />

    <xsl:if test="count($list-of-unique-services) != 0 ">

      <h3><center>
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','463')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </center></h3>

      <xsl:call-template name="group-by-tap">
        <xsl:with-param name="co-id"        select="$co-id"/>
        <xsl:with-param name="call-details" select="$call-details-local"/>
        <xsl:with-param name="list-of-unique-services" select="$list-of-unique-services"/>
        <xsl:with-param name="period-start"            select="$period-start"/>
        <xsl:with-param name="period-end"              select="$period-end"/>
      </xsl:call-template>

    </xsl:if>

  </xsl:template>

  <!-- group by TapSeqNo -->
  <xsl:template name="group-by-tap">

    <xsl:param name="co-id" select="''"/>
    <xsl:param name="call-details"/>
    <xsl:param name="list-of-unique-services"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>

    <xsl:for-each select="$list-of-unique-services">

      <xsl:sort select="." />
      <xsl:variable name="current-service">
        <xsl:value-of select="."/>
      </xsl:variable>

      <br/>
      <table border="1" width="100%" cellspacing="0" cellpadding="0">
        <thead>
          <tr>
            <td align="center" colspan="8"><font size="2"><b>
              <xsl:for-each select="$xcd">
                <xsl:value-of select="key('xcd-index','TapSeqNo')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$current-service"/>
            </b></font></td>
          </tr>
        </thead>
        <tbody>
          <tr>
            <xsl:for-each select="$xcd">
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('xcd-index','CRTs')[@xml:lang=$lang]/@Des"/><br/>
              </font></th>
            </xsl:for-each>
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','464')[@xml:lang=$lang]/@Des"/><br/>
                </xsl:for-each>
                <xsl:for-each select="$xcd">
                  <xsl:value-of select="key('xcd-index','SN')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </font></th>
            <xsl:for-each select="$xcd">
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('xcd-index','DRV')[@xml:lang=$lang]/@Des"/><!--<br/>
                          <xsl:value-of select="key('xcd-index','FileName')[@xml:lang=$lang]/@Des"/>-->
              </font></th>
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('xcd-index','NI')[@xml:lang=$lang]/@Des"/><br/>
                <!-- rerate type -->
                <!--
                <xsl:value-of select="key('xcd-index','RRT')[@xml:lang=$lang]/@Des"/>
                -->
              </font></th>
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('xcd-index','TT')[@xml:lang=$lang]/@Des"/><br/>
                <xsl:value-of select="key('xcd-index','TZ')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('xcd-index','TM')[@xml:lang=$lang]/@Des"/><br/>
                <xsl:value-of select="key('xcd-index','SP')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('xcd-index','OAmt')[@xml:lang=$lang]/@Des"/><br/>
                <xsl:value-of select="key('xcd-index','DAmt')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!-- external amount/tax -->
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('xcd-index','ExtAmt')[@xml:lang=$lang]/@Des"/><br/>
                <xsl:value-of select="key('xcd-index','ExtTax')[@xml:lang=$lang]/@Des"/>
              </font></th>
            </xsl:for-each>
          </tr>
          <xsl:for-each select="$call-details/XCD[@TapSeqNo=$current-service and @CO=$co-id]">
            <xsl:sort select="@CTs"/>
            <xsl:apply-templates select="parent::Call"/>
          </xsl:for-each>
        </tbody>
      </table>
    </xsl:for-each>

  </xsl:template>

  <!--  sum udr rap (no bop, no bundle) -->
  <xsl:template name="print-sum-udr-rap">

    <xsl:param name="co-id"/>
    <xsl:param name="call-details"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>

    <xsl:variable name="call-details-local" select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call[XCD[@CO=$co-id]]" />

    <!-- using a exslt set template to eliminate the duplicated data ( avoid recursion ) -->
    <xsl:variable name="list-of-unique-services" select="set:distinct($call-details-local/XCD/@RapSeqNo)" />

    <xsl:if test="count($list-of-unique-services) != 0 ">

      <h3><center>
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','465')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </center></h3>

      <xsl:call-template name="group-by-rap">
        <xsl:with-param name="co-id"        select="$co-id"/>
        <xsl:with-param name="call-details" select="$call-details-local"/>
        <xsl:with-param name="list-of-unique-services" select="$list-of-unique-services"/>
        <xsl:with-param name="period-start"            select="$period-start"/>
        <xsl:with-param name="period-end"              select="$period-end"/>
      </xsl:call-template>

    </xsl:if>

  </xsl:template>

  <!-- group by RapSeqNo -->
  <xsl:template name="group-by-rap">

    <xsl:param name="co-id" select="''"/>
    <xsl:param name="call-details"/>
    <xsl:param name="list-of-unique-services"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>    

    <xsl:for-each select="$list-of-unique-services">

      <xsl:sort select="." />
      <xsl:variable name="current-service">
        <xsl:value-of select="."/>
      </xsl:variable>

      <br/>
      <table border="1" width="100%" cellspacing="0" cellpadding="0">
        <thead>
          <tr>
            <td align="center" colspan="8"><font size="2"><b>
              <xsl:for-each select="$xcd">
                <xsl:value-of select="key('xcd-index','RapSeqNo')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$current-service"/>
            </b></font></td>
          </tr>
        </thead>
        <tbody>
          <tr>
            <xsl:for-each select="$xcd">
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('xcd-index','CRTs')[@xml:lang=$lang]/@Des"/><br/>
              </font></th>
            </xsl:for-each>
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','464')[@xml:lang=$lang]/@Des"/><br/>
                </xsl:for-each>
                <xsl:for-each select="$xcd">
                  <xsl:value-of select="key('xcd-index','SN')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </font></th>
            <xsl:for-each select="$xcd">
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('xcd-index','DRV')[@xml:lang=$lang]/@Des"/><!--<br/>
                          <xsl:value-of select="key('xcd-index','FileName')[@xml:lang=$lang]/@Des"/>-->
              </font></th>
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('xcd-index','NI')[@xml:lang=$lang]/@Des"/><br/>
                <!-- rerate type -->
                <!--
                <xsl:value-of select="key('xcd-index','RRT')[@xml:lang=$lang]/@Des"/>
                -->
              </font></th>
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('xcd-index','TT')[@xml:lang=$lang]/@Des"/><br/>
                <xsl:value-of select="key('xcd-index','TZ')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('xcd-index','TM')[@xml:lang=$lang]/@Des"/><br/>
                <xsl:value-of select="key('xcd-index','SP')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('xcd-index','OAmt')[@xml:lang=$lang]/@Des"/><br/>
                <xsl:value-of select="key('xcd-index','DAmt')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!-- external amount/tax -->
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('xcd-index','ExtAmt')[@xml:lang=$lang]/@Des"/><br/>
                <xsl:value-of select="key('xcd-index','ExtTax')[@xml:lang=$lang]/@Des"/>
              </font></th>
            </xsl:for-each>
          </tr>
          <xsl:for-each select="$call-details/XCD[@RapSeqNo=$current-service and @CO=$co-id]">
            <xsl:sort select="@CTs"/>
            <xsl:apply-templates select="parent::Call"/>
          </xsl:for-each>
        </tbody>
      </table>
    </xsl:for-each>

  </xsl:template>

  <!--  call details  -->
  <xsl:template name="print-call-details">

    <xsl:param name="co-id"/>
    <xsl:param name="bopind"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>
    <xsl:param name="call-details"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>

    <xsl:variable name="call-details-local" select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call[XCD[@CO=$co-id and not(@TapSeqNo) and not(@RapSeqNo)
       and not(@BundPurInd) and not(@BundUsgInd) and (@BOPSeqNoRP=$bopseqno or @BOPSeqNoSP=$bopseqno
       or not(@BOPSeqNoRP or @BOPSeqNoSP) or (@CTs &lt; $start-date))]]"/>

    <xsl:variable name="list-of-unique-services" select="set:distinct($call-details-local/XCD/@SN)" />

    <xsl:if test="count($list-of-unique-services) != 0">

      <h3><center>
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','459')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </center></h3>

      <xsl:call-template name="group-by-services">
        <xsl:with-param name="co-id"        select="$co-id"/>
        <xsl:with-param name="bopind"       select="$bopind"/>
        <xsl:with-param name="bopseqno"     select="$bopseqno"/>
        <xsl:with-param name="boptype"      select="$boptype"/>
        <xsl:with-param name="call-details" select="$call-details-local"/>
        <xsl:with-param name="list-of-unique-services" select="$list-of-unique-services"/>
        <xsl:with-param name="period-start" select="$period-start"/>
        <xsl:with-param name="period-end" select="$period-end"/>
      </xsl:call-template>

    </xsl:if>

  </xsl:template>

  <!--  bundle purchase  -->
  <xsl:template name="print-call-details-bundle-purchase-price">

    <xsl:param name="co-id"/>
    <xsl:param name="service"/>
    <xsl:param name="sequence-no"/>
    <xsl:param name="call-details"/>
    <xsl:param name="bopind"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>

    <xsl:if test="$bopind='N'">
      <xsl:for-each select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call/XCD[@CO=$co-id and @SN=$service and @PurSeqNo=$sequence-no and @BundPurInd]">
        <xsl:call-template name="number-format">
          <xsl:with-param name="number" select="@DAmt"/>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:for-each select="@CC">
          <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="$bopind='Y'">
      <xsl:for-each select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call/XCD[@CO=$co-id and @SN=$service and @PurSeqNo=$sequence-no and @BundPurInd and (@BOPSeqNoRP=$bopseqno or $bopseqno=@BOPSeqNoSP)]">
        <xsl:call-template name="number-format">
          <xsl:with-param name="number" select="@DAmt"/>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:for-each select="@CC">
          <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:if>

  </xsl:template>

  <!--  bundle usage  -->
  <xsl:template name="print-call-details-bundle-usage">

    <xsl:param name="co-id"/>
    <xsl:param name="call-details"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>
    <xsl:param name="bopind" select="'N'"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>

    <xsl:variable name="call-details-local" select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call[XCD[@CO=$co-id and @BundUsgInd and (($bopind='Y' and ($bopseqno=@BOPSeqNoRP or $bopseqno=@BOPSeqNoSP)) or $bopind='N')]]" />

    <xsl:variable name="list-of-unique-services" select="set:distinct($call-details-local/XCD/@SN)" />

    <xsl:if test="count($list-of-unique-services) != 0">

      <h5><center>
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','461')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </center></h5>

      <xsl:call-template name="group-by-services-bundle-usage">
        <xsl:with-param name="co-id" select="$co-id"/>
        <xsl:with-param name="bopind" select="$bopind"/>
        <xsl:with-param name="bopseqno" select="$bopseqno"/>
        <xsl:with-param name="boptype" select="$boptype"/>
        <xsl:with-param name="call-details" select="$call-details-local"/>
        <xsl:with-param name="list-of-unique-services" select="$list-of-unique-services"/>
        <xsl:with-param name="period-start" select="$period-start"/>
        <xsl:with-param name="period-end" select="$period-end"/>
      </xsl:call-template>

    </xsl:if>

  </xsl:template>

  <!-- call details (no contract specified) -->
  <xsl:template name="print-call-details-only">

    <xsl:param name="call-details"/>

    <xsl:variable name="call-details-local" select="$call-details/ContrCalls/ServCalls/Call" />
    
    <xsl:variable name="list-of-unique-services" select="set:distinct($call-details-local/XCD/@SN)" />

    <xsl:if test="count($list-of-unique-services)!=0">
      <hr/>
      <center><h2>
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','395')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </h2></center>

      <xsl:call-template name="group-by-services">
        <xsl:with-param name="call-details" select="$call-details-local"/>
        <xsl:with-param name="list-of-unique-services" select="$list-of-unique-services"/>
      </xsl:call-template>
    </xsl:if>

  </xsl:template>

  <!-- not bundled call details group by services -->
  <xsl:template name="group-by-services">

    <xsl:param name="co-id" select="''"/>
    <xsl:param name="bopind"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>
    <xsl:param name="call-details"/>
    <xsl:param name="list-of-unique-services"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>

    <xsl:for-each select="$list-of-unique-services">

      <xsl:sort select="." />
      <xsl:variable name="current-service">
        <xsl:value-of select="."/>
      </xsl:variable>

      <br/>
      <table border="1" width="100%" cellspacing="0" cellpadding="0">
        <thead>
          <tr>
            <td align="center" colspan="9"><font size="2"><b>
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="$current-service"/>
                <xsl:with-param name="Type"  select="'SN'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
            </b></font></td>
          </tr>
        </thead>
        <tbody>
          <tr>
            <xsl:for-each select="$xcd">
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('xcd-index','CTs')[@xml:lang=$lang]/@Des"/><br/>
                <xsl:value-of select="key('xcd-index','PrInd')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('xcd-index','CT')[@xml:lang=$lang]/@Des"/><br/>
                <xsl:value-of select="key('xcd-index','RT')[@xml:lang=$lang]/@Des"/>
                <xsl:text> / </xsl:text>
                <xsl:value-of select="key('xcd-index','RRT')[@xml:lang=$lang]/@Des"/>
              </font></th>
            </xsl:for-each>
            <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
              <xsl:for-each select="$xcd">
                <xsl:value-of select="key('xcd-index','DRV')[@xml:lang=$lang]/@Des"/><br/>
                <xsl:value-of select="key('xcd-index','BOPSeqNoRP')[@xml:lang=$lang]/@Des"/>
                <xsl:text> / </xsl:text>
                <!-- pricing alternative -->
                <xsl:value-of select="key('xcd-index','TIDPA')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </font></th>
            <xsl:for-each select="$xcd">
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('xcd-index','NI')[@xml:lang=$lang]/@Des"/><br/>
                <xsl:value-of select="key('xcd-index','NN')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('xcd-index','DES')[@xml:lang=$lang]/@Des"/><br/>
                <xsl:value-of select="key('xcd-index','DZP')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('xcd-index','OPN')[@xml:lang=$lang]/@Des"/><br/>
                <xsl:value-of select="key('xcd-index','APN')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('xcd-index','TT')[@xml:lang=$lang]/@Des"/><br/>
                <xsl:value-of select="key('xcd-index','TZ')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('xcd-index','TM')[@xml:lang=$lang]/@Des"/><br/>
                <xsl:value-of select="key('xcd-index','SP')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('xcd-index','OAmt')[@xml:lang=$lang]/@Des"/><br/>
                <xsl:value-of select="key('xcd-index','DAmt')[@xml:lang=$lang]/@Des"/>
              </font></th>
            </xsl:for-each>
          </tr>
          
          <!-- Filter out mark-up fee charge parts because we print them separately -->
          <xsl:variable name="call-details-local" select="$call-details/XCD[@ChType!='M']"/>
          
          <xsl:choose>
            <!-- contract given ? -->
            <xsl:when test="$co-id!=''">

              <xsl:choose>
              
                <!-- contract has no BOP -->
                <xsl:when test="$bopind='N'">
                
                  <xsl:for-each select="$call-details-local[@SN=$current-service and @CO=$co-id
                   and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd)]">
                    <xsl:sort select="@CTs"/>
                    <xsl:sort select="@Id"/>
                    <xsl:sort select="@SubId"/>
                    <xsl:apply-templates select="parent::Call"/>
                  </xsl:for-each>
                  
                </xsl:when>
                
                <!-- contract has BOP -->
                <xsl:otherwise>
                
                  <!-- print late calls first -->
                  <xsl:for-each select="$call-details-local[@SN=$current-service and @CO=$co-id
                   and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd)
                   and (@CTs &lt; $start-date) and not(@BOPAltInd)]">
                    <xsl:sort select="@CTs"/>
                    <xsl:sort select="@Id"/>
                    <xsl:sort select="@SubId"/>
                    <xsl:apply-templates select="parent::Call"/>
                  </xsl:for-each>
                  
                  <!-- print call details -->
                  <xsl:choose>
                  
                    <xsl:when test="$boptype='TM'">
                    
                      <xsl:for-each select="$call-details-local[@SN=$current-service and @CO=$co-id
                       and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd)
                       and not(@BundUsgInd) and (@CTs &gt;= $start-date)
                       and (@BOPSeqNoRP=$bopseqno or not(@BOPSeqNoRP))]">
                        <xsl:sort select="@CTs"/>
                        <xsl:sort select="@Id"/>
                        <xsl:sort select="@SubId"/>
                        <xsl:apply-templates select="parent::Call"/>
                     </xsl:for-each>
                     
                    </xsl:when>
                    
                    <xsl:when test="$boptype='SP'">
                    
                      <xsl:for-each select="$call-details-local[@SN=$current-service and @CO=$co-id
                       and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd)
                       and (@CTs &gt;= $start-date) and (@BOPSeqNoSP=$bopseqno or not(@BOPSeqNoSP))]">
                        <xsl:sort select="@CTs"/>
                        <xsl:sort select="@Id"/>
                        <xsl:sort select="@SubId"/>
                        <xsl:apply-templates select="parent::Call"/>
                      </xsl:for-each>
                      
                    </xsl:when>
                    
                  </xsl:choose>
                  
                </xsl:otherwise>
                
              </xsl:choose>
              
            </xsl:when>
            
            <!-- no contract available (not CDS relevant) -->
            <xsl:otherwise>
            
              <!-- print call details  -->
              <xsl:for-each select="$call-details-local[@SN=$current-service
               and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd)]">
                 <xsl:if test="position()='1' or @CO != preceding::XCD[1]/@CO">
                  <!-- print contract id header -->
                   <tr>
                    <td colspan="9"><font size="-1"><b>
                      <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','375')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                      <xsl:text>: </xsl:text>
                      <xsl:value-of select="@CO"/>
                    </b></font></td>
                  </tr>
                </xsl:if>
                <xsl:apply-templates select="parent::Call"/>
              </xsl:for-each>
              
            </xsl:otherwise>
            
          </xsl:choose>
        </tbody>
      </table>
      
      
        <!-- Print mark-up fees -->
        
        <xsl:choose>
          <!-- contract available ? -->
          <xsl:when test="$co-id!=''">
        
            <xsl:choose>
              <!-- if contract has no BOP -->
              <xsl:when test="$bopind='N'">
                
                <xsl:call-template name="print-markup-fees">
                    <xsl:with-param name="markup-fees" select="$call-details/XCD[@ChType='M' and @SN=$current-service and @CO=$co-id
                         and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd)]"/>
                </xsl:call-template>
        
              </xsl:when>
              
              <!-- if contract has BOP -->
              <xsl:otherwise>
              
                <!-- print late calls first -->

                <xsl:choose>
                
                  <xsl:when test="$boptype='TM'">
                  
                  
                    <xsl:call-template name="print-markup-fees">
                        <xsl:with-param name="markup-fees" select="$call-details/XCD[@ChType='M' and 
                        (
                            ( @SN=$current-service and @CO=$co-id and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd) 
                                and (@CTs &lt; $start-date) and not(@BOPAltInd) ) 
                            or 
                            ( @SN=$current-service and @CO=$co-id and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd) 
                                and (@CTs &gt;= $start-date) and (@BOPSeqNoRP=$bopseqno or not(@BOPSeqNoRP)) )
                        )]"/>
                    </xsl:call-template>
                    
                    
                  </xsl:when>
                  
                  <xsl:when test="$boptype='SP'">
                  
                  
                    <xsl:call-template name="print-markup-fees">
                        <xsl:with-param name="markup-fees" select="$call-details/XCD[@ChType='M' and 
                        (
                            ( @SN=$current-service and @CO=$co-id and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd) 
                                and (@CTs &lt; $start-date) and not(@BOPAltInd) ) 
                            or 
                            ( @SN=$current-service and @CO=$co-id and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd)
                                and (@CTs &gt;= $start-date) and (@BOPSeqNoSP=$bopseqno or not(@BOPSeqNoSP)) )
                        )]"/>
                    </xsl:call-template>
                  
                  </xsl:when>
                  
                </xsl:choose>
                
              </xsl:otherwise>
              
            </xsl:choose>
          </xsl:when>
          
          <!-- no contracts (not CDS relevant) -->
          <xsl:otherwise>
          
                <!-- print call details  -->
                
                <xsl:call-template name="print-markup-fees">
                    <xsl:with-param name="markup-fees" select="$call-details/XCD[@ChType='M' and @SN=$current-service
                         and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd) ]"/>
                    <xsl:with-param name="print-contract-id-header" select="'1'"/>
                </xsl:call-template>
                
          </xsl:otherwise>
          
        </xsl:choose>
      
      
    </xsl:for-each>
    
    
  </xsl:template>
  
  
  
  <!-- Print mark-up fees (to be called per service)
       Param markup-fees: list of XCD elements with ChType='M' -->
  <xsl:template name="print-markup-fees">
    
    <xsl:param name="markup-fees"/>
    <xsl:param name="print-contract-id-header"/>
    
    <xsl:if test="$markup-fees">
      
      
      <br/>
      <table border="1" width="100%" cellspacing="0" cellpadding="0">
        <thead>
          <tr>
            <td align="center" colspan="9"><font size="2"><b>
                    <!-- Mark-up fees -->
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','549')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
            </b></font></td>
          </tr>
        </thead>
        
        <tbody>
          <tr>

              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <!-- date -->
                <xsl:for-each select="$xcd">
                  <xsl:value-of select="key('xcd-index','CTs')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </font></th>
              
            <xsl:for-each select="$fup">
            
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                  <!-- Account -->
                  <xsl:value-of select="key('fup-index','FUAccId')[@xml:lang=$lang]/@Des"/>
              </font></th>
              
            <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <!-- Package/element/version -->
                <xsl:value-of select="key('fup-index','FUP')[@xml:lang=$lang]/@Des"/>
                <xsl:text> / </xsl:text>
                <xsl:value-of select="key('fup-index','FUE')[@xml:lang=$lang]/@Des"/>
                <xsl:text> / </xsl:text>
                <xsl:value-of select="key('fup-index','FUEV')[@xml:lang=$lang]/@Des"/>
            </font></th>
            
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <!-- Charge plan -->
                <xsl:value-of select="key('fup-index','ChPlan')[@xml:lang=$lang]/@Des"/>
              </font></th>
              
            </xsl:for-each>
              
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <!-- Amount -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','50')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </font></th>
              
          </tr>
          
          
            <xsl:choose>
                <xsl:when test="$print-contract-id-header">
                    <!-- Print contract id header, don't change sorting -->
                    
                    <xsl:for-each select="$markup-fees">
                        
                        <xsl:if test="position()='1' or @CO != preceding::XCD[1]/@CO">
                            <!-- print contract id header -->
                            
                            <tr>
                                <td colspan="5"><font size="2"><b>
                                  <xsl:for-each select="$txt"><!-- Contract -->
                                    <xsl:value-of select="key('txt-index','375')[@xml:lang=$lang]/@Des"/>
                                  </xsl:for-each>
                                  <xsl:text>: </xsl:text>
                                  <xsl:value-of select="@CO"/>
                                </b></font></td>
                            </tr>
                            
                        </xsl:if>
                        
                        <xsl:call-template name="print-markup-fee">
                          <xsl:with-param name="markup-fee" select="."/>
                        </xsl:call-template>
                        
                    </xsl:for-each>
                    
                    
                </xsl:when>
                
                <xsl:otherwise>
                    <!-- Default: sort records -->
                    
                    <xsl:for-each select="$markup-fees">
                        <xsl:sort select="@CTs"/>
                        <xsl:sort select="@Id"/>
                        <xsl:sort select="@SubId"/>
                                  
                        <xsl:call-template name="print-markup-fee">
                          <xsl:with-param name="markup-fee" select="."/>
                        </xsl:call-template>
                        
                    </xsl:for-each>
                    
                    
                </xsl:otherwise>
            </xsl:choose>         
          
        </tbody>
      </table>                                    
                
    </xsl:if>
        
  </xsl:template>
  
  
  <!-- Prints a single mark-up fee -->
  <xsl:template name="print-markup-fee">
  
    <xsl:param name="markup-fee"/>
    
    <xsl:variable name="fu-part" select="$markup-fee/following-sibling::FUP"/>
    
    <tr>
    
        <td align="center"><font face="Arial Narrow" size="-1">
              <!-- timestamp -->
              <xsl:call-template name="date-time-format">
                <xsl:with-param name="date" select="$markup-fee/@CTs"/>
              </xsl:call-template>
        </font></td>
        
        <td align="center"><font face="Arial Narrow" size="-1">
                <!-- free unit account id -->
                <xsl:value-of select="$fu-part/@FUAccId"/>          
                <xsl:text> / </xsl:text>
                <!-- free unit account history id -->
                <xsl:value-of select="$fu-part/@FUAccHistId"/>
        </font></td>
        
        <td align="center"><font face="Arial Narrow" size="-1">
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="$fu-part/@FUP"/>
                  <xsl:with-param name="Type"  select="'FUP'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
                <!-- free unit element -->
                <xsl:if test="$fu-part/@FUE">
                  <xsl:text> / </xsl:text>
                  <xsl:value-of select="$fu-part/@FUE"/>
                </xsl:if>
                <!-- free unit version -->
                <xsl:if test="$fu-part/@FUEV">
                  <xsl:text> / </xsl:text>
                  <xsl:value-of select="$fu-part/@FUEV"/>
                </xsl:if>
        </font></td>
       
        <td align="center"><font face="Arial Narrow" size="-1">
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="$fu-part/@ChPlan"/>
                  <xsl:with-param name="Type"  select="'CPD'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
        </font></td>
        
        <td align="right"><font face="Arial Narrow" size="-1">
                <!-- discounted amount -->
                <xsl:if test="$markup-fee/@DAmt">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="$markup-fee/@DAmt"/>
                  </xsl:call-template>
                  <xsl:text> </xsl:text>
                  <xsl:for-each select="$markup-fee/@CC">
                    <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
                  </xsl:for-each>
                </xsl:if>
        </font></td>
        
    </tr>
    
  </xsl:template>
  
  

  <!-- bundle usage group by services (not TAP/RAP relevant) -->
  <xsl:template name="group-by-services-bundle-usage">

    <xsl:param name="co-id" select="''"/>
    <xsl:param name="bopind" select="'N'"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>
    <xsl:param name="call-details"/>
    <xsl:param name="list-of-unique-services"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>

    <xsl:for-each select="$list-of-unique-services">

      <xsl:sort select="." />
      <xsl:variable name="current-service">
        <xsl:value-of select="."/>
      </xsl:variable>

      <br/>
      <table border="1" width="100%" cellspacing="0" cellpadding="0">
        <thead>
          <tr>
            <!-- service title -->
            <td align="center" colspan="4"><font size="2"><b>
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="$current-service"/>
                <xsl:with-param name="Type"  select="'SN'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
            </b></font></td>
          </tr>
        </thead>
        <tbody>
          <tr>
            <!-- date / time -->
            <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
              <xsl:for-each select="$xcd">
                <xsl:value-of select="key('xcd-index','CTs')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </font></th>
            <!-- bundle name -->
            <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','455')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </font></th>
            <!-- bundle product -->
            <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
              <xsl:for-each select="$fup">
                <xsl:value-of select="key('fup-index','BPROD')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </font></th>
            <!-- quantity -->
            <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
              <xsl:for-each select="$xcd">
                <xsl:value-of select="key('xcd-index','ORV')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </font></th>
          </tr>

          <xsl:choose>
            <!-- contract given ? -->
            <xsl:when test="$co-id!=''">

              <xsl:choose>
                <!-- contract has no BOP -->
                <xsl:when test="$bopind='N'">
                  <xsl:for-each select="$call-details/XCD[@SN=$current-service and @CO=$co-id and @BundUsgInd]">
                    <xsl:sort select="@CTs"/>
                    <xsl:sort select="@Id"/>
                    <xsl:sort select="@SubId"/>
                    <xsl:apply-templates select="parent::Call"/>
                  </xsl:for-each>
                </xsl:when>
                <!-- contract has BOP -->
                <xsl:otherwise>
                  <!-- print late calls first -->
                  <xsl:for-each select="$call-details/XCD[@SN=$current-service and @CO=$co-id and @BundUsgInd and (@CTs &lt; $start-date) and not(@BOPAltInd)]">
                    <xsl:sort select="@CTs"/>
                    <xsl:sort select="@Id"/>
                    <xsl:sort select="@SubId"/>
                    <xsl:apply-templates select="parent::Call"/>
                  </xsl:for-each>
                  <!-- print call details -->
                  <xsl:choose>
                    <xsl:when test="$boptype='TM'">
                      <xsl:for-each select="$call-details/XCD[@SN=$current-service and @CO=$co-id and @BundUsgInd and (@CTs &gt;= $start-date) and (@BOPSeqNoRP=$bopseqno or not(@BOPSeqNoRP))]">
                        <xsl:sort select="@CTs"/>
                        <xsl:sort select="@Id"/>
                        <xsl:sort select="@SubId"/>
                        <xsl:apply-templates select="parent::Call"/>
                     </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="$boptype='SP'">
                      <xsl:for-each select="$call-details/XCD[@SN=$current-service and @CO=$co-id and @BundUsgInd and (@CTs &gt;= $start-date) and (@BOPSeqNoSP=$bopseqno or not(@BOPSeqNoSP))]">
                        <xsl:sort select="@CTs"/>
                        <xsl:sort select="@Id"/>
                        <xsl:sort select="@SubId"/>
                        <xsl:apply-templates select="parent::Call"/>
                      </xsl:for-each>
                    </xsl:when>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <!-- no contract available (not CDS relevant) -->
            <xsl:otherwise>
              <!-- print call details  -->
              <xsl:for-each select="$call-details/XCD[@SN=$current-service and @BundUsgInd]">
                 <xsl:if test="position()='1' or @CO != preceding::XCD[1]/@CO">
                  <!-- print contract id header -->
                   <tr>
                    <td colspan="9"><font size="-1"><b>
                      <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','375')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>
                      <xsl:text>: </xsl:text>
                      <xsl:value-of select="@CO"/>
                    </b></font></td>
                  </tr>
                </xsl:if>
                <xsl:apply-templates select="parent::Call"/>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </tbody>
      </table>
    </xsl:for-each>

  </xsl:template>

  <xsl:template name="remove-duplicates">

    <xsl:param name="list-of-services"/>
    <xsl:param name="last-service" select="''"/>
    <xsl:variable name="next-service">
      <xsl:value-of select="substring-before($list-of-services, ' ')"/>
    </xsl:variable>
    <xsl:variable name="remaining-services">
      <xsl:value-of select="substring-after($list-of-services, ' ')"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="not(string-length(normalize-space($list-of-services)))">
        <!-- empty list, do nothing -->
      </xsl:when>
      <xsl:when test="not($last-service=$next-service)">
        <xsl:value-of select="$next-service"/>
        <xsl:text> </xsl:text>
        <xsl:call-template name="remove-duplicates">
          <xsl:with-param name="list-of-services" select="$remaining-services"/>
          <xsl:with-param name="last-service" select="$next-service"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$last-service=$next-service">
        <xsl:call-template name="remove-duplicates">
          <xsl:with-param name="list-of-services" select="$remaining-services"/>
          <xsl:with-param name="last-service" select="$next-service"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>

  </xsl:template>

  <!--  call details large volume -->
  <xsl:template name="print-call-details-large-volume">

    <xsl:param name="co-id"/>
    <xsl:param name="bopind"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>
    <xsl:param name="call-details"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>

    <h3><center>
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','260')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
    </center></h3>

    <table border="1" width="100%" cellspacing="0" cellpadding="0">
      <tbody>
        <tr>
          <xsl:for-each select="$xcd">
            <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
              <xsl:value-of select="key('xcd-index','CTs')[@xml:lang=$lang]/@Des"/><br/>
              <xsl:value-of select="key('xcd-index','PrInd')[@xml:lang=$lang]/@Des"/>
            </font></th>
            <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
              <xsl:value-of select="key('xcd-index','CT')[@xml:lang=$lang]/@Des"/><br/>
              <xsl:value-of select="key('xcd-index','RT')[@xml:lang=$lang]/@Des"/>
              <xsl:text> / </xsl:text>
              <xsl:value-of select="key('xcd-index','RRT')[@xml:lang=$lang]/@Des"/>
            </font></th>
            <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
              <xsl:for-each select="$xcd">
                <xsl:value-of select="key('xcd-index','ORV')[@xml:lang=$lang]/@Des"/><br/>
                <xsl:value-of select="key('xcd-index','DRV')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </font></th>
            <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
              <xsl:value-of select="key('xcd-index','NI')[@xml:lang=$lang]/@Des"/><br/>
              <xsl:value-of select="key('xcd-index','NN')[@xml:lang=$lang]/@Des"/>
            </font></th>
            <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
              <xsl:value-of select="key('xcd-index','DES')[@xml:lang=$lang]/@Des"/><br/>
              <xsl:value-of select="key('xcd-index','DZP')[@xml:lang=$lang]/@Des"/>
            </font></th>
            <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
              <xsl:value-of select="key('xcd-index','OPN')[@xml:lang=$lang]/@Des"/><br/>
              <xsl:value-of select="key('xcd-index','APN')[@xml:lang=$lang]/@Des"/>
            </font></th>
            <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
              <xsl:value-of select="key('xcd-index','TT')[@xml:lang=$lang]/@Des"/><br/>
              <xsl:value-of select="key('xcd-index','TZ')[@xml:lang=$lang]/@Des"/>
            </font></th>
            <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
              <xsl:value-of select="key('xcd-index','TM')[@xml:lang=$lang]/@Des"/><br/>
              <xsl:value-of select="key('xcd-index','SP')[@xml:lang=$lang]/@Des"/>
            </font></th>
            <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
              <xsl:value-of select="key('xcd-index','OAmt')[@xml:lang=$lang]/@Des"/><br/>
              <xsl:value-of select="key('xcd-index','DAmt')[@xml:lang=$lang]/@Des"/>
            </font></th>
          </xsl:for-each>
        </tr>
        <xsl:choose>
          <!-- contract given ? -->
          <xsl:when test="$co-id!=''">

            <xsl:choose>
              <!-- contract has no BOP -->
              <xsl:when test="$bopind='N'">
                <xsl:for-each select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call/XCD[@CO=$co-id]">
                  <xsl:apply-templates select="parent::Call"/>
                </xsl:for-each>
              </xsl:when>
              <!-- contract has BOP -->
              <xsl:otherwise>
                <!-- print late calls first -->
                <xsl:for-each select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call/XCD[@CO=$co-id and (@CTs &lt; $start-date) and not(@BOPAltInd)]">
                  <xsl:apply-templates select="parent::Call"/>
                </xsl:for-each>
                <!-- print call details -->
                <xsl:choose>
                  <xsl:when test="$boptype='TM'">
                    <xsl:for-each select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call/XCD[@CO=$co-id and (@CTs &gt;= $start-date) and (@BOPSeqNoRP=$bopseqno or not(@BOPSeqNoRP))]">
                      <xsl:apply-templates select="parent::Call"/>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:when test="$boptype='SP'">
                    <xsl:for-each select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call/XCD[@CO=$co-id and (@CTs &gt;= $start-date) and (@BOPSeqNoSP=$bopseqno or not(@BOPSeqNoSP))]">
                      <xsl:apply-templates select="parent::Call"/>
                    </xsl:for-each>
                  </xsl:when>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <!-- no contract available (not CDS relevant) -->
          <xsl:otherwise>
            <!-- print call details  -->
            <xsl:for-each select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call/XCD">
               <xsl:if test="position()='1' or @CO != preceding::XCD[1]/@CO">
                <!-- print contract id header -->
                 <tr>
                  <td colspan="10"><font size="-1"><b>
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','375')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="@CO"/>
                  </b></font></td>
                </tr>
              </xsl:if>
              <xsl:apply-templates select="parent::Call"/>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </tbody>
    </table>

  </xsl:template>

  <!--  charge details  -->
  <xsl:template name="print-charge-details">

    <xsl:param name="co-id"/>
    <xsl:param name="bopind"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>
    <xsl:param name="charge-details"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>
    <xsl:param name="charge-type"/>
    
     <!-- This template is used both for pre-grouped charge details (charge details of an invoice) and ungrouped charge details
    (of a charge notification) . -->
    
    <xsl:choose>
        <xsl:when test="$charge-details/ContrCalls">
        
            <!-- pregrouped -->
            <xsl:variable name="list-of-services">
              <xsl:for-each select="$charge-details/ContrCalls[@Id=$co-id]/ServCalls/ChDet/XCD[@SrvChType=$charge-type and @CO=$co-id]/@SN">
                <xsl:sort select="."/>
                  <xsl:value-of select="."/>
                  <xsl:text> </xsl:text>
              </xsl:for-each>
            </xsl:variable>
            
            <xsl:variable name="list-of-unique-services">
              <xsl:call-template name="remove-duplicates">
                <xsl:with-param name="list-of-services" select="$list-of-services"/>
                <xsl:with-param name="last-service" select="'$charge-type'"/>
              </xsl:call-template>
            </xsl:variable>
                    
            <xsl:if test="normalize-space($list-of-unique-services)!=''">
        
              <h3><center>
                <!-- recurring charges -->
                <xsl:if test="$charge-type='A'">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','482')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </xsl:if>
                <!-- one-time charges -->
                <xsl:if test="$charge-type='S'">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','483')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </xsl:if>
              </center></h3>
                
                <xsl:call-template name="group-charges-by-services">
                    <xsl:with-param name="co-id" select="$co-id"/>
                    <xsl:with-param name="bopind" select="$bopind"/>
                    <xsl:with-param name="bopseqno" select="$bopseqno"/>
                    <xsl:with-param name="boptype" select="$boptype"/>
                    <xsl:with-param name="charge-details" select="$charge-details"/>
                    <xsl:with-param name="list-of-unique-services" select="$list-of-unique-services"/>
                    <xsl:with-param name="period-start" select="$period-start"/>
                    <xsl:with-param name="period-end" select="$period-end"/>
                    <xsl:with-param name="charge-type" select="$charge-type"/>
                </xsl:call-template>
                
                
            </xsl:if>
            
        </xsl:when>
        <xsl:when test="$charge-details/ChDet">
        
            <!-- ungrouped -->
            <xsl:variable name="list-of-services">
              <xsl:for-each select="$charge-details/ChDet/XCD[@SrvChType=$charge-type and @CO=$co-id]/@SN">
                <xsl:sort select="."/>
                  <xsl:value-of select="."/>
                  <xsl:text> </xsl:text>
              </xsl:for-each>
            </xsl:variable>
            
            <xsl:variable name="list-of-unique-services">
              <xsl:call-template name="remove-duplicates">
                <xsl:with-param name="list-of-services" select="$list-of-services"/>
                <xsl:with-param name="last-service" select="'$charge-type'"/>
              </xsl:call-template>
            </xsl:variable>
            
            <xsl:if test="normalize-space($list-of-unique-services)!=''">
        
              <h3><center>
                <!-- recurring charges -->
                <xsl:if test="$charge-type='A'">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','482')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </xsl:if>
                <!-- one-time charges -->
                <xsl:if test="$charge-type='S'">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','483')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </xsl:if>
              </center></h3>
                
                <xsl:call-template name="group-charges-by-services">
                    <xsl:with-param name="co-id" select="$co-id"/>
                    <xsl:with-param name="bopind" select="$bopind"/>
                    <xsl:with-param name="bopseqno" select="$bopseqno"/>
                    <xsl:with-param name="boptype" select="$boptype"/>
                    <xsl:with-param name="charge-details" select="$charge-details"/>
                    <xsl:with-param name="list-of-unique-services" select="$list-of-unique-services"/>
                    <xsl:with-param name="period-start" select="$period-start"/>
                    <xsl:with-param name="period-end" select="$period-end"/>
                    <xsl:with-param name="charge-type" select="$charge-type"/>
                </xsl:call-template>
                
            </xsl:if>
            
        </xsl:when>
        <xsl:otherwise/>
    </xsl:choose>
    
  </xsl:template>

  <!-- charge details group by services -->
  <xsl:template name="group-charges-by-services">

    <xsl:param name="co-id" select="''"/>
    <xsl:param name="bopind"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>
    <xsl:param name="charge-details"/>
    <xsl:param name="list-of-unique-services"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>
    <xsl:param name="charge-type"/>

    <xsl:if test="normalize-space($list-of-unique-services)!=''">

      <xsl:variable name="next-service">
        <xsl:value-of select="substring-before($list-of-unique-services, ' ')"/>
      </xsl:variable>

      <xsl:variable name="remaining-services">
        <xsl:value-of select="substring-after($list-of-unique-services, ' ')"/>
      </xsl:variable>
      <br/>
      <table border="1" width="100%" cellspacing="0" cellpadding="0">
        <thead>
          <tr>
            <td align="center" colspan="7"><font size="2"><b>
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="$next-service"/>
                <xsl:with-param name="Type"  select="'SN'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>                
            </b></font></td>
          </tr>
        </thead>
        <tbody>
          <tr>
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <!-- date -->
                <xsl:for-each select="$xcd">
                  <xsl:value-of select="key('xcd-index','CTs')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each><br/>
                <!-- prepaid indicator -->
                <xsl:for-each select="$xcd">
                  <xsl:value-of select="key('xcd-index','PrInd')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each><br/>
              </font></th>
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <!-- tariff model -->
                <xsl:for-each select="$xcd">
                  <xsl:value-of select="key('xcd-index','TM')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each><br/>
                <!-- service package -->
                <xsl:for-each select="$xcd">
                  <xsl:value-of select="key('xcd-index','SP')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each><br/>
              </font></th>
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <!-- quantity -->
                <xsl:for-each select="$xcd">                
                  <xsl:value-of select="key('xcd-index','Numit')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each><br/>
                <!-- active days -->
                <xsl:for-each select="$xcd">                
                  <xsl:value-of select="key('xcd-index','NumDays')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>                
              </font></th>
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <!-- service charge subtype -->
                <xsl:for-each select="$xcd">                
                  <xsl:value-of select="key('xcd-index','SrvChSType')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each><br/>
              </font></th>              
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <!-- period, status info -->
                <xsl:for-each select="$xcd">              
                  <xsl:value-of select="key('xcd-index','ChrgStartTime')[@xml:lang=$lang]/@Des"/>
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="key('xcd-index','SrvSt')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each><br/>
                <!-- market -->
                <xsl:for-each select="$xcd">
                  <xsl:value-of select="key('xcd-index','MKT')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>                
              </font></th>              
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <!-- price -->
                <xsl:for-each select="$xcd">              
                  <xsl:value-of select="key('xcd-index','Price')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each><br/>
                <!-- profile -->
                <xsl:for-each select="$xcd">
                  <xsl:value-of select="key('xcd-index','PRO')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </font></th>
              <th nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <!-- amount -->
                <xsl:for-each select="$xcd">              
                  <xsl:value-of select="key('xcd-index','OAmt')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each><br/>
              </font></th>              
          </tr>
          
          <xsl:choose>
            <xsl:when test="$charge-details/ContrCalls">
                <!-- Pregrouped charge details -->
                
              <xsl:for-each select="$charge-details/ContrCalls[@Id=$co-id]/ServCalls/ChDet/XCD[@SN=$next-service and @SrvChType=$charge-type and @CO=$co-id]">
                <xsl:call-template name="ChDet">
                  <xsl:with-param name="node" select="parent::ChDet"/>
                  <xsl:with-param name="charge-type" select="$charge-type"/>
                </xsl:call-template>
              </xsl:for-each>
                
            </xsl:when>
            
            <xsl:when test="$charge-details/ChDet">
                <!-- Pregrouped charge details -->
            
          <xsl:for-each select="$charge-details/ChDet/XCD[@SN=$next-service and @SrvChType=$charge-type and @CO=$co-id]">
            <xsl:call-template name="ChDet">
              <xsl:with-param name="node" select="parent::ChDet"/>
              <xsl:with-param name="charge-type" select="$charge-type"/>
            </xsl:call-template>
          </xsl:for-each>
            
            </xsl:when>
            
            <xsl:otherwise/>
            
          </xsl:choose>
          
          
        </tbody>
      </table>
      <xsl:if test="normalize-space($remaining-services)!=''">
        <xsl:call-template name="group-charges-by-services">
          <xsl:with-param name="co-id" select="$co-id"/>
          <xsl:with-param name="bopind" select="$bopind"/>
          <xsl:with-param name="bopseqno" select="$bopseqno"/>
          <xsl:with-param name="boptype" select="$boptype"/>
          <xsl:with-param name="charge-details" select="$charge-details"/>
          <xsl:with-param name="list-of-unique-services" select="$remaining-services"/>
          <xsl:with-param name="period-start" select="$period-start"/>
          <xsl:with-param name="period-end" select="$period-end"/>
          <xsl:with-param name="charge-type" select="$charge-type"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>

  </xsl:template>

  <!-- charge details -->
  <xsl:template name="ChDet">

    <xsl:param name="node"/>
    <xsl:param name="charge-type"/>

    <xsl:call-template name="charge-details">
      <xsl:with-param name="node" select="$node/XCD"/>
      <xsl:with-param name="charge-type" select="$charge-type"/>
    </xsl:call-template>

    <xsl:if test="$node/FUP[(not(FUP/@FUPrepayInd) or (FUP/@FUPrepayInd != 1))]">
      <tr>          
        <xsl:for-each select="$fup">
          <th/>
          <th bgcolor="#DCDCDC" colspan="2" nowrap="nowrap" align="center"><font face="Arial Narrow" size="-1">
            <xsl:value-of select="key('fup-index','SN')[@xml:lang=$lang]/@Des"/>
          </font></th>
          <th bgcolor="#DCDCDC" colspan="2" nowrap="nowrap" align="center"><font face="Arial Narrow" size="-1">
            <xsl:value-of select="key('fup-index','Profile')[@xml:lang=$lang]/@Des"/>
          </font></th>          
          <th bgcolor="#DCDCDC" colspan="2" nowrap="nowrap" align="center"><font face="Arial Narrow" size="-1">
            <xsl:value-of select="key('fup-index','Amt')[@xml:lang=$lang]/@Des"/>
          </font></th>
        </xsl:for-each>
      </tr>
      <xsl:for-each select="$node/FUP[(not(FUP/@FUPrepayInd) or (FUP/@FUPrepayInd != 1))]">
        <tr bgcolor="#DCDCDC">
          <xsl:if test="position()='1'">
            <td nowrap="nowrap" bgcolor="#DCDCDC">
              <xsl:attribute name="rowspan">
                <xsl:value-of select="count(../FUP[(not(FUP/@FUPrepayInd) or (FUP/@FUPrepayInd != 1))])"/>
              </xsl:attribute>
              <xsl:for-each select="$txt">
                <b><font face="Arial Narrow" size="-1">
                  <xsl:value-of select="key('txt-index','280')[@xml:lang=$lang]/@Des"/>
                </font></b>
              </xsl:for-each>
            </td>
          </xsl:if>
          <xsl:apply-templates select="." mode="charge-details"/>
        </tr>
      </xsl:for-each>
    </xsl:if>

  </xsl:template>

  <!-- call details -->
  <xsl:template match="Call">

    <tr>
      <xsl:apply-templates select="XCD"/>
    </tr>

    <xsl:if test="FUP and not(FUP/@BPROD) and (not(FUP/@FUPrepayInd) or (FUP/@FUPrepayInd != 1))">
        
        <xsl:if test="not(XCD/@TapSeqNo or XCD/@RapSeqNo)">
          <tr>
            <xsl:for-each select="$fup">
              <th/>
              <!-- cost control contract id -->
              <th bgcolor="#DCDCDC" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('fup-index','CoId')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!-- account -->
              <th bgcolor="#DCDCDC" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('fup-index','FUAccId')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!-- free unit part type -->
              <th bgcolor="#DCDCDC" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('fup-index','FUOption')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!-- free unit package / element / version -->
              <th colspan="2" bgcolor="#DCDCDC" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('fup-index','FUP')[@xml:lang=$lang]/@Des"/>
                <xsl:text> / </xsl:text>
                <xsl:value-of select="key('fup-index','FUE')[@xml:lang=$lang]/@Des"/>
                <xsl:text> / </xsl:text>
                <xsl:value-of select="key('fup-index','FUEV')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!-- charge plan -->
              <th bgcolor="#DCDCDC" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('fup-index','ChPlan')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!-- cost control service -->
              <th bgcolor="#DCDCDC" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('fup-index','SN')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!-- discount amount -->
              <th bgcolor="#DCDCDC" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('fup-index','Amt')[@xml:lang=$lang]/@Des"/>
              </font></th>
            </xsl:for-each>
          </tr>
          <xsl:for-each select="FUP[(not(FUP/@FUPrepayInd) or (FUP/@FUPrepayInd != 1))]">
            <tr bgcolor="#DCDCDC">
              <xsl:if test="position()='1'">
                <td nowrap="nowrap" bgcolor="#DCDCDC">
                  <xsl:attribute name="rowspan">
                    <xsl:value-of select="count(../FUP[(not(FUP/@FUPrepayInd) or (FUP/@FUPrepayInd != 1))])"/>
                  </xsl:attribute>
                  <xsl:for-each select="$txt">
                    <b><font face="Arial Narrow" size="-1">
                      <xsl:value-of select="key('txt-index','301')[@xml:lang=$lang]/@Des"/>
                    </font></b>
                  </xsl:for-each>
                </td>
              </xsl:if>
              <xsl:apply-templates select="." mode="normal"/>
            </tr>
          </xsl:for-each>
        </xsl:if>
        <xsl:if test="XCD/@TapSeqNo or XCD/@RapSeqNo">
          <tr>
            <xsl:for-each select="$fup">
              <th/>
              <!-- cost control contract -->
              <th bgcolor="#DCDCDC" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('fup-index','CoId')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <th bgcolor="#DCDCDC" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <!-- account -->
                <xsl:value-of select="key('fup-index','FUAccId')[@xml:lang=$lang]/@Des"/><br/>
                <!-- free unit part type -->
                <xsl:value-of select="key('fup-index','FUOption')[@xml:lang=$lang]/@Des"/>
              </font></th>              
              <th colspan="2" bgcolor="#DCDCDC" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <!-- package / element / version -->
                <xsl:value-of select="key('fup-index','FUP')[@xml:lang=$lang]/@Des"/>
                <xsl:text> / </xsl:text>
                <xsl:value-of select="key('fup-index','FUE')[@xml:lang=$lang]/@Des"/>
                <xsl:text> / </xsl:text>
                <xsl:value-of select="key('fup-index','FUEV')[@xml:lang=$lang]/@Des"/><br/>
                <!-- charge plan -->
                <xsl:value-of select="key('fup-index','ChPlan')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!-- cost control service -->
              <th bgcolor="#DCDCDC" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('fup-index','SN')[@xml:lang=$lang]/@Des"/>
              </font></th>
              <!-- discount amount -->
              <th bgcolor="#DCDCDC" nowrap="nowrap"><font face="Arial Narrow" size="-1">
                <xsl:value-of select="key('fup-index','Amt')[@xml:lang=$lang]/@Des"/>
              </font></th>
            </xsl:for-each>
          </tr>
          <xsl:for-each select="FUP[(not(FUP/@FUPrepayInd) or (FUP/@FUPrepayInd != 1))]">
            <tr bgcolor="#DCDCDC">
              <xsl:if test="position()='1'">
                <td nowrap="nowrap" bgcolor="#DCDCDC">
                  <xsl:attribute name="rowspan">
                    <xsl:value-of select="count(../FUP[(not(FUP/@FUPrepayInd) or (FUP/@FUPrepayInd != 1))])"/>
                  </xsl:attribute>
                  <xsl:for-each select="$txt">
                    <b><font face="Arial Narrow" size="-1">
                      <xsl:value-of select="key('txt-index','301')[@xml:lang=$lang]/@Des"/>
                    </font></b>
                  </xsl:for-each>
                </td>
              </xsl:if>
              <xsl:apply-templates select="." mode="external"/>
            </tr>
          </xsl:for-each>
        </xsl:if>
        
    </xsl:if>

  </xsl:template>

  <!-- (some) flexible call attributes (see table charge_detail_info) -->
  <xsl:template match="XCD">

    <xsl:choose>
      <xsl:when test="not(@BundPurInd) and not(@BundUsgInd)">
        <td align="center" nowrap="nowrap"><font face="Arial Narrow" size="-1">
          <xsl:if test="not(@TapSeqNo or @RapSeqNo)">
            <!-- timestamp -->
            <xsl:call-template name="date-time-format">
              <xsl:with-param name="date" select="@CTs"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="@TapSeqNo or @RapSeqNo">
            <!-- sum udr foh generation date -->
            <xsl:call-template name="date-time-format">
              <xsl:with-param name="date" select="@CTs"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="not(@TapSeqNo or @RapSeqNo)">
            <br/>
            <!-- prepaid indicator -->
            <xsl:call-template name="DataDomainLgnMap">
              <xsl:with-param name="Index"     select="@PrInd"/>
              <xsl:with-param name="Type"      select="'DD'"/>
              <xsl:with-param name="Desc"      select="'1'"/>
              <xsl:with-param name="ClassId"   select="'YES/NO_BOOLEAN_INDICATOR'"/>
            </xsl:call-template>
          </xsl:if>
        </font></td>
        <td align="center"><font face="Arial Narrow" size="-1">
          <!-- call type -->
          <xsl:call-template name="DataDomainLgnMap">
            <xsl:with-param name="Index"     select="@CT"/>
            <xsl:with-param name="Type"      select="'DD'"/>
            <xsl:with-param name="Desc"      select="'1'"/>
            <xsl:with-param name="ClassId"   select="'CALL_TYPE_CLASS'"/>
          </xsl:call-template>
          <xsl:if test="not(@TapSeqNo) and not(@RapSeqNo)">
            <br/>
            <!-- rate type -->
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="@RT"/>
              <xsl:with-param name="Type"  select="'RT'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
            <xsl:text> / </xsl:text>
            <!-- rerate type -->
            <xsl:call-template name="DataDomainLgnMap">
              <xsl:with-param name="Index"     select="@RRT"/>
              <xsl:with-param name="Type"      select="'DD'"/>
              <xsl:with-param name="Desc"      select="'1'"/>
              <xsl:with-param name="ClassId"   select="'RERATE_RECORD_TYPE_CLASS'"/>
            </xsl:call-template>
          </xsl:if>
          <!-- TAP / RAP -->
          <xsl:if test="@TapSeqNo or @RapSeqNo">
            <br/>
            <!-- service -->
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="@SN"/>
              <xsl:with-param name="Type"  select="'SN'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </xsl:if>
        </font></td>
        <td align="right"><font size="-1">
          <xsl:choose>
            <xsl:when test="@ORV">
              <!-- original rated volume -->
              <xsl:call-template name="number-unit-format">
                <xsl:with-param name="number" select="@ORV"/>
                <xsl:with-param name="unit" select="@UM"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <!-- discounted rated volume -->
              <xsl:call-template name="number-unit-format">
                <xsl:with-param name="number" select="@DRV"/>
                <xsl:with-param name="unit" select="@UM"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
          <br/>
          <xsl:choose>
            <xsl:when test="@BOPSeqNoRP">
              <!-- best option plan tariff model sequence number -->
              <xsl:value-of select="@BOPSeqNoRP"/>
            </xsl:when>
            <xsl:when test="@BOPSeqNoSP">
              <!-- best option plan service package sequence number -->
              <xsl:value-of select="@BOPSeqNoSP"/>
            </xsl:when>
            <!-- TAP / RAP are not BOP relevant -->
            <xsl:when test="@TapSeqNo or @RapSeqNo">
              <!--
                      <xsl:value-of select="@FileName"/>
                      -->
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>-</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="not(@TapSeqNo or @RapSeqNo)">
            <xsl:text> / </xsl:text>
            <!-- pricing alternative -->
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="@TIDPA"/>
              <xsl:with-param name="Type"  select="'PA'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </xsl:if>
        </font></td>
        <!-- network indicator and name -->
        <td align="center" ><font face="Arial Narrow" size="-1">
          <!-- network indicator -->
          <xsl:call-template name="DataDomainLgnMap">
            <xsl:with-param name="Index"     select="@NI"/>
            <xsl:with-param name="Type"      select="'DD'"/>
            <xsl:with-param name="Desc"      select="'1'"/>
            <xsl:with-param name="ClassId"   select="'XFILE_IND_CLASS'"/>
          </xsl:call-template>
          <xsl:if test="not(@TapSeqNo or @RapSeqNo)">
            <br/>
            <!-- network name -->
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="@NN"/>
              <xsl:with-param name="Type"  select="'PL'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </xsl:if>
          <!-- rerate type -->
          <!--
          <xsl:if test="@TapSeqNo or @RapSeqNo">
            <br/>            
            <xsl:call-template name="DataDomainLgnMap">
              <xsl:with-param name="Index"     select="@RRT"/>
              <xsl:with-param name="Type"      select="'DD'"/>
              <xsl:with-param name="Desc"      select="'1'"/>
              <xsl:with-param name="ClassId"   select="'RERATE_RECORD_TYPE_CLASS'"/>
            </xsl:call-template>
          </xsl:if>
          -->
        </font></td>
        <xsl:if test="not(@TapSeqNo or @RapSeqNo)">
          <td align="center" nowrap="nowrap"><font face="Arial Narrow" size="-1">
            <!-- destination -->
            <xsl:call-template name="DataDomainLgnMap">
              <xsl:with-param name="Index"     select="@DES"/>
              <xsl:with-param name="Type"      select="'DD'"/>
              <xsl:with-param name="Desc"      select="'1'"/>
              <xsl:with-param name="ClassId"   select="'CALL_DEST_CLASS'"/>
            </xsl:call-template>
            <br/>
            <!-- destination zone point -->
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="@DZP"/>
              <xsl:with-param name="Type"  select="'ZD'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </font></td>
        </xsl:if>
        <xsl:if test="not(@TapSeqNo or @RapSeqNo)">
          <td><font size="-1">
            <!-- other party number -->
            <xsl:choose>
              <xsl:when test="@CpName!=''">
                <!-- content provider name -->
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="@CpName"/>
                  <xsl:with-param name="Type"  select="'CP'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <!-- dialled digits or connected APN -->
                <xsl:value-of select="@OPN"/>
              </xsl:otherwise>
            </xsl:choose>
            <br/>
            <!-- A-party number -->
            <xsl:value-of select="@APN"/>
          </font></td>
        </xsl:if>
        <td align="center" nowrap="nowrap"><font face="Arial Narrow" size="-1">
          <!-- tariff time -->
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="@TT"/>
            <xsl:with-param name="Type"  select="'TT'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
          <br/>
          <!-- tariff zone -->
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="@TZ"/>
            <xsl:with-param name="Type"  select="'TZ'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
        </font></td>
        <td align="center" nowrap="nowrap"><font face="Arial Narrow" size="-1">
          <xsl:choose>
            <xsl:when test="@BOPTM or @BOPSP">
              <!-- tariff model -->
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="@BOPTM"/>
                <xsl:with-param name="Type"  select="'TM'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
              <br/>
              <!-- service package -->
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                 <xsl:with-param name="Index" select="@BOPSP"/>
                 <xsl:with-param name="Type"  select="'SP'"/>
                 <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <!-- tariff model -->
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="@TM"/>
                <xsl:with-param name="Type"  select="'TM'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
              <br/>
              <!-- service package -->
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                 <xsl:with-param name="Index" select="@SP"/>
                 <xsl:with-param name="Type"  select="'SP'"/>
                 <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </font></td>
        <td align="right"><font size="-1">
          <!-- original amount (in case of TAP TAP net rate and amount currency) -->
          <xsl:if test="@OAmt">
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="@OAmt"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>
            <xsl:for-each select="@CC">
              <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
          </xsl:if>
          <br/>
          <!-- discounted amount -->
          <xsl:if test="@DAmt">
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="@DAmt"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>
            <xsl:for-each select="@CC">
              <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
          </xsl:if>
        </font></td>
        <!--  add external amount/tax for TAP/RAP -->
        <xsl:if test="(@TapSeqNo or @RapSeqNo)">
          <td align="right"><font size="-1">
            <!-- external amount  -->
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="@ExtAmt"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>
            <!-- normally @ExtCurrCode must be used, but this attribute is missing in the samples -->
            <xsl:for-each select="@CC">
              <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
            </xsl:for-each>
            <br/>
            <!-- external tax -->
            <xsl:if test="@ExtTax">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@ExtTax"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <!-- normally @ExtCurrCode must be used, but this attribute is missing in the samples -->
              <xsl:for-each select="@CC">
                <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
              </xsl:for-each>
            </xsl:if>
          </font></td>
        </xsl:if>
      </xsl:when>
      <xsl:when test="@BundUsgInd">
        <!-- date / time -->
        <td align="center"><font size="-1">
          <xsl:call-template name="date-time-format">
            <xsl:with-param name="date" select="@CTs"/>
          </xsl:call-template>
        </font></td>
        <!-- bundle name -->
        <td align="center"><font size="-1">
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="../FUP/@SN"/>
            <xsl:with-param name="Type"  select="'SN'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
        </font></td>
        <!-- bundle product -->
        <td align="center"><font size="-1">
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="../FUP/@BPROD"/>
            <xsl:with-param name="Type"  select="'BPROD'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
        </font></td>
        <!-- quantity -->
        <td align="center"><font size="-1">
          <xsl:call-template name="number-unit-format">
            <xsl:with-param name="number" select="@ORV"/>
            <xsl:with-param name="unit" select="@UM"/>
          </xsl:call-template>
        </font></td>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>

  </xsl:template>

  <!-- free unit package -->
  <xsl:template match="FUP" mode="normal">

    <!-- cost control contract -->
    <td align="center"><font size="-1">
      <xsl:value-of select="@CoId"/>
    </font></td>

    <!-- free unit account -->
    <td align="center"><font size="-1">
      <!-- free unit account id -->
      <xsl:value-of select="@FUAccId"/>
      <xsl:if test="@FUAccHistId">
        <xsl:text> / </xsl:text>
      </xsl:if>
      <!-- free unit account history id -->
      <xsl:value-of select="@FUAccHistId"/>
    </font></td>

    <!-- free unit part type -->
    <td align="center"><font size="-1">
      <xsl:call-template name="DataDomainLgnMap">
        <xsl:with-param name="Index"     select="@FUOption"/>
        <xsl:with-param name="Type"      select="'DD'"/>
        <xsl:with-param name="Desc"      select="'1'"/>
        <xsl:with-param name="ClassId"   select="'FREE_UNIT_OPTION_CLASS'"/>
      </xsl:call-template>
    </font></td>

    <td align="center" colspan="2" nowrap="nowrap"><font face="Arial Narrow" size="-1">
      <!-- free unit package -->
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="@FUP"/>
        <xsl:with-param name="Type"  select="'FUP'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
      <!-- free unit element -->
      <xsl:if test="@FUE">
        <xsl:text> / </xsl:text>
        <xsl:value-of select="@FUE"/>
      </xsl:if>
      <!-- free unit version -->
      <xsl:if test="@FUEV">
        <xsl:text> / </xsl:text>
        <xsl:value-of select="@FUEV"/>
      </xsl:if>
    </font></td>

    <!-- charge plan -->
    <td align="center" nowrap="nowrap"><font face="Arial Narrow" size="-1">
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="@ChPlan"/>
        <xsl:with-param name="Type"  select="'CPD'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
    </font></td>    

    <!-- cost control service -->
    <td align="center" nowrap="nowrap"><font face="Arial Narrow" size="-1">
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="@SN"/>
        <xsl:with-param name="Type"  select="'SN'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
    </font></td>

    <!-- discount amount -->
    <td nowrap="nowrap" align="right"><font size="-1">
      <xsl:if test="@Amt">
        <xsl:call-template name="number-format">
          <xsl:with-param name="number" select="@Amt"/>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:for-each select="@AmtCurrCode">
          <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
        </xsl:for-each>
      </xsl:if>
    </font></td>

  </xsl:template>

  <!-- free unit package -->
  <xsl:template match="FUP" mode="external">

    <!-- cost control contract -->
    <td align="center"><font size="-1">
      <xsl:value-of select="@CoId"/>
    </font></td>

    <td align="center"><font size="-1">
      <!-- free unit account id -->
      <xsl:value-of select="@FUAccId"/>
      <xsl:if test="@FUAccHistId">
        <xsl:text> / </xsl:text>
      </xsl:if>
      <!-- free unit account history id -->
      <xsl:value-of select="@FUAccHistId"/><br/>
      <!-- free unit part type -->
      <xsl:call-template name="DataDomainLgnMap">
        <xsl:with-param name="Index"     select="@FUOption"/>
        <xsl:with-param name="Type"      select="'DD'"/>
        <xsl:with-param name="Desc"      select="'1'"/>
        <xsl:with-param name="ClassId"   select="'FREE_UNIT_OPTION_CLASS'"/>
      </xsl:call-template>
    </font></td>

    <td align="center" colspan="2" nowrap="nowrap"><font face="Arial Narrow" size="-1">
      <!-- free unit package -->
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="@FUP"/>
        <xsl:with-param name="Type"  select="'FUP'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
      <!-- free unit element -->
      <xsl:if test="@FUE">
        <xsl:text> / </xsl:text>
        <xsl:value-of select="@FUE"/>
      </xsl:if>
      <!-- free unit version -->
      <xsl:if test="@FUEV">
        <xsl:text> / </xsl:text>
        <xsl:value-of select="@FUEV"/>
      </xsl:if>
      <br/>
      <!-- charge plan -->
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="@ChPlan"/>
        <xsl:with-param name="Type"  select="'CPD'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
    </font></td>

    <!-- cost control service -->
    <td align="center" nowrap="nowrap"><font face="Arial Narrow" size="-1">
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="@SN"/>
        <xsl:with-param name="Type"  select="'SN'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
    </font></td>

    <!-- discount amount -->
    <td nowrap="nowrap" align="right"><font size="-1">
      <xsl:if test="@Amt">
        <xsl:call-template name="number-format">
          <xsl:with-param name="number" select="@Amt"/>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:for-each select="@AmtCurrCode">
          <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
        </xsl:for-each>
      </xsl:if>
    </font></td>

  </xsl:template>

  <!-- (some) flexible charge attributes (see table charge_detail_info) -->
  <xsl:template name="charge-details">

    <xsl:param name="node"/>
    <xsl:param name="charge-type"/>

    <tr>
      <td align="center"><font size="-1">
        <!-- timestamp -->
        <xsl:call-template name="date-time-format">
          <xsl:with-param name="date" select="$node/@CTs"/>
        </xsl:call-template><br/>
        <!-- prepaid indicator -->
        <xsl:call-template name="DataDomainLgnMap">
          <xsl:with-param name="Index"     select="$node/@PrInd"/>
          <xsl:with-param name="Type"      select="'DD'"/>
          <xsl:with-param name="Desc"      select="'1'"/>
          <xsl:with-param name="ClassId"   select="'YES/NO_BOOLEAN_INDICATOR'"/>
        </xsl:call-template>
      </font></td>
      <td align="center"><font size="-1">
        <xsl:choose>
            <xsl:when test="$node/@BOPTM or $node/@BOPSP">
              <!-- tariff model / version -->
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="$node/@BOPTM"/>
                <xsl:with-param name="Type"  select="'TM'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$node/@TMV"/><br/>
              <!-- service package -->
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="$node/@BOPSP"/>
                <xsl:with-param name="Type"  select="'SP'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <!-- tariff model -->
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="$node/@TM"/>
              <xsl:with-param name="Type"  select="'TM'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$node/@TMV"/><br/>
            <!-- service package -->
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="$node/@SP"/>
              <xsl:with-param name="Type"  select="'SP'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </font></td>
      <td align="center"><font size="-1">
        <!-- quantity -->
        <xsl:choose>
          <xsl:when test="$node/@Numit">
            <xsl:value-of select="$node/@Numit"/> 
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>-</xsl:text>
          </xsl:otherwise>
        </xsl:choose>        
        <br/>
        <!-- active days -->
        <xsl:choose>
          <xsl:when test="$node/@NumDays">
            <xsl:value-of select="$node/@NumDays"/> 
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>-</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </font></td>       
      <td align="center"><font size="-1">
        <!-- service charge subtype -->
        <xsl:call-template name="DataDomainLgnMap">
          <xsl:with-param name="Index"     select="$node/@SrvChSType"/>
          <xsl:with-param name="Type"      select="'DD'"/>
          <xsl:with-param name="Desc"      select="'1'"/>
          <xsl:with-param name="ClassId"   select="'CHARGE_SUBTYPE_CLASS'"/>
        </xsl:call-template>
      </font></td>
      <!-- service status -->
      <td nowrap="nowrap" align="center"><font face="Arial Narrow" size="-1">
        <xsl:if test="$node/@ChrgStartTime">
          <xsl:call-template name="date-time-format">
            <xsl:with-param name="date" select="$node/@ChrgStartTime"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="$node/@ChrgEndTime">
          <xsl:text> - </xsl:text>
          <xsl:call-template name="date-time-format">
            <xsl:with-param name="date" select="$node/@ChrgEndTime"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="$node/@SrvSt">
          <xsl:text>, </xsl:text>
          <xsl:value-of select="$node/@SrvSt"/><br/>
        </xsl:if><br/>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="$node/@MKT"/>
          <xsl:with-param name="Type"  select="'MRKT'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>        
      </font></td>
      <!-- service info ( @PrmValueId can be mapped to the description via the respective SumItem ) -->
      <!--
      <xsl:if test="$charge-type='S'">
        <td nowrap="nowrap" align="center"><font face="Arial Narrow" size="-1">
          <xsl:value-of select="$node/@PrmValueId"/>
        </font></td>
      </xsl:if>
      -->
      <!-- price -->
      <td align="right"><font face="Arial Narrow" size="-1">
        <xsl:call-template name="number-format">
          <xsl:with-param name="number" select="$node/@Price"/>
        </xsl:call-template>        
        <xsl:text> </xsl:text>
        <xsl:for-each select="$node/@PriceCurr">
          <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
        </xsl:for-each><br/>
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="$node/@PRO"/>
          <xsl:with-param name="Type"  select="'PRO'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>       
      </font></td>
      <td align="right"><font face="Arial Narrow" size="-1">
        <!-- original amount -->
        <xsl:if test="$node/@OAmt">
          <xsl:call-template name="number-format">
            <xsl:with-param name="number" select="@OAmt"/>
          </xsl:call-template>
          <xsl:text> </xsl:text>
          <xsl:for-each select="$node/@CC">
            <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
          </xsl:for-each>
        </xsl:if>
      </font></td>
    </tr>

  </xsl:template>

  <!-- free unit package -->
  <xsl:template match="FUP" mode="charge-details">

    <!-- cost control service -->
    <td colspan="2" align="center"><font face="Arial Narrow" size="-1">
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="@SN"/>
        <xsl:with-param name="Type"  select="'SN'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
    </font></td>
    <!-- profile -->
    <td colspan="2" align="center"><font face="Arial Narrow" size="-1">
      <xsl:call-template name="LgnMap">
        <xsl:with-param name="Mode"  select="'0'"/>
        <xsl:with-param name="Index" select="@Profile"/>
        <xsl:with-param name="Type"  select="'PRO'"/>
        <xsl:with-param name="Desc"  select="'1'"/>
      </xsl:call-template>
    </font></td>
    <!-- discount amount -->
    <td colspan="2" align="right"><font face="Arial Narrow" size="-1">
      <xsl:if test="@Amt">
        <xsl:call-template name="number-format">
          <xsl:with-param name="number" select="@Amt"/>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:for-each select="@AmtCurrCode">
          <xsl:value-of select="document('Common.xsl')/*/cur:symbol[@CurrCode=current()]"/>
        </xsl:for-each>
      </xsl:if>
    </font></td>

  </xsl:template>

  <xsl:template name="set:distinct">
    <xsl:param name="nodes" select="/.."/>
    <xsl:param name="distinct" select="/.."/>
    <xsl:choose>
      <xsl:when test="$nodes">
        <xsl:call-template name="set:distinct">
        <xsl:with-param name="distinct" select="$distinct | $nodes[1][not(. = $distinct)]"/>
        <xsl:with-param name="nodes" select="$nodes[position() > 1]"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$distinct" mode="set:distinct"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="node()|@*" mode="set:distinct">
     <xsl:copy-of select="." />
  </xsl:template>

</xsl:stylesheet>
