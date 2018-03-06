<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    CallDetailsCSV.xsl

  Owner:   Matthias Fehrenbacher
           Natalie Kather

  @(#) ABSTRACT : XML -> CSV stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms call-charge details.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/CallDetailsCSV.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" xmlns:set="http://exslt.org/sets" xmlns:bgh="http://www.lhsgroup.com/BSCS/BGH" exclude-result-prefixes="xsl cur set bgh">



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
    
    <!-- using a exslt set template to eliminate the duplicated data ( avoids recursion ) -->
    <xsl:variable name="list-of-unique-services" select="set:distinct($call-details-local/XCD/@TapSeqNo)" />

    <xsl:if test="count($list-of-unique-services) !=0 ">

        <bgh:row>
            <bgh:cell>
                <xsl:for-each select="$txt"><!-- TAP -->
                  <xsl:value-of select="key('txt-index','463')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
        </bgh:row>

      <xsl:call-template name="group-by-tap">
        <xsl:with-param name="co-id"                   select="$co-id"/>
        <xsl:with-param name="call-details"            select="$call-details-local"/>
        <xsl:with-param name="list-of-unique-services" select="$list-of-unique-services"/>
        <xsl:with-param name="period-start"            select="$period-start"/>
        <xsl:with-param name="period-end"              select="$period-end"/>
      </xsl:call-template>
      
      <bgh:row/>

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
      

        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                  <!-- TAP Sequence No. -->
                  <xsl:for-each select="$xcd">
                    <xsl:value-of select="key('xcd-index','TapSeqNo')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$current-service"/>
            </bgh:cell>
        </bgh:row>
              
            
        <bgh:row>
            <bgh:cell/>
            <bgh:cell/>
            <bgh:cell>
              <xsl:for-each select="$xcd">
                  <!-- date -->
                  <xsl:value-of select="key('xcd-index','CRTs')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                  <!-- udr type -->
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','464')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                  <!-- service -->
                  <xsl:for-each select="$xcd">
                    <xsl:value-of select="key('xcd-index','SN')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
                
              <xsl:for-each select="$xcd">
            
            <bgh:cell>
                  <!-- rated volume -->
                  <xsl:value-of select="key('xcd-index','DRV')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <!-- file name -->
            <!--
                   <bgh:cell>                  
                            <xsl:value-of select="key('xcd-index','FileName')[@xml:lang=$lang]/@Des"/>
                   </bgh:cell>
                   -->
            <bgh:cell>
                  <!-- network indicator -->
                  <xsl:value-of select="key('xcd-index','NI')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <!-- rerate type -->
            <!--
                   <bgh:cell>                  
                       <xsl:value-of select="key('xcd-index','RRT')[@xml:lang=$lang]/@Des"/>
                   </bgh:cell>
                   -->
            <bgh:cell>
                <!-- tariff time -->
                  <xsl:value-of select="key('xcd-index','TT')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                    <!-- tariff zone -->
                  <xsl:value-of select="key('xcd-index','TZ')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                <!-- tariff model  -->
                  <xsl:value-of select="key('xcd-index','TM')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                  <!-- service package -->
                  <xsl:value-of select="key('xcd-index','SP')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                  <!-- amounts -->
                  <xsl:value-of select="key('xcd-index','OAmt')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                  <xsl:value-of select="key('xcd-index','DAmt')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
                  <!-- external amount/tax -->
            <bgh:cell>
                  <xsl:value-of select="key('xcd-index','ExtAmt')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                  <xsl:value-of select="key('xcd-index','ExtTax')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            
              </xsl:for-each>
        </bgh:row>
          
          
        <xsl:for-each select="$call-details/XCD[@TapSeqNo=$current-service and @CO=$co-id]">
            <xsl:sort select="@CTs"/>
            
            <!--<bgh:row>
                <bgh:cell/>
                <bgh:cell/>-->
            
                    <xsl:apply-templates select="parent::Call"/>
            
            <!--</bgh:row>-->
            
        </xsl:for-each>
          
        
    </xsl:for-each>

  </xsl:template>
  

  <!--  sum udr rap (no bop, no bundle) -->
  <xsl:template name="print-sum-udr-rap">

    <xsl:param name="co-id"/>
    <xsl:param name="call-details"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>

    <xsl:variable name="call-details-local" select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call[XCD[@CO=$co-id]]" />
    
    <xsl:variable name="list-of-unique-services" select="set:distinct($call-details-local/XCD/@RapSeqNo)" />

    <xsl:if test="count($list-of-unique-services) !=0 ">

      <bgh:row>
        <bgh:cell>
            <xsl:for-each select="$txt"><!-- RAP -->
              <xsl:value-of select="key('txt-index','465')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        </bgh:cell>
      </bgh:row>
      

      <xsl:call-template name="group-by-rap">
        <xsl:with-param name="co-id"                   select="$co-id"/>
        <xsl:with-param name="call-details"            select="$call-details-local"/>
        <xsl:with-param name="list-of-unique-services" select="$list-of-unique-services"/>
        <xsl:with-param name="period-start"            select="$period-start"/>
        <xsl:with-param name="period-end"              select="$period-end"/>
      </xsl:call-template>
      
      <bgh:row/>

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

      
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                  <xsl:for-each select="$xcd">
                    <xsl:value-of select="key('xcd-index','RapSeqNo')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$current-service"/>
            </bgh:cell>
        </bgh:row>
              
        <bgh:row>   
            <bgh:cell/>
            <bgh:cell/>
            <bgh:cell>
              <xsl:for-each select="$xcd">
                  <!-- date -->
                  <xsl:value-of select="key('xcd-index','CRTs')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                  <!-- udr type -->
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','464')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                  <!-- service -->
                  <xsl:for-each select="$xcd">
                    <xsl:value-of select="key('xcd-index','SN')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
                
              <xsl:for-each select="$xcd">
                
            <bgh:cell>
                  <!-- rated volume -->
                  <xsl:value-of select="key('xcd-index','DRV')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <!-- file name -->
            <!--
                   <bgh:cell>                  
                             <xsl:value-of select="key('xcd-index','FileName')[@xml:lang=$lang]/@Des"/>
                   </bgh:cell>
                   -->
            <bgh:cell>            
                  <!-- network indicator -->
                  <xsl:value-of select="key('xcd-index','NI')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <!-- rerate type -->
            <!--
                   <bgh:cell>                  
                   <xsl:value-of select="key('xcd-index','RRT')[@xml:lang=$lang]/@Des"/>
                   </bgh:cell>
                   -->
            <bgh:cell>
                  <!-- tariff time and tariff zone -->
                  <xsl:value-of select="key('xcd-index','TT')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                  <xsl:value-of select="key('xcd-index','TZ')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                <!-- tariff model and service package -->
                  <xsl:value-of select="key('xcd-index','TM')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                  <xsl:value-of select="key('xcd-index','SP')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                  <!-- amounts -->
                  <xsl:value-of select="key('xcd-index','OAmt')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                  <xsl:value-of select="key('xcd-index','DAmt')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                  <!-- external amount/tax -->
                  <xsl:value-of select="key('xcd-index','ExtAmt')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                  <xsl:value-of select="key('xcd-index','ExtTax')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
              </xsl:for-each>
            
        </bgh:row>
        
          
        <xsl:for-each select="$call-details/XCD[@RapSeqNo=$current-service and @CO=$co-id]">
          <xsl:sort select="@CTs"/>
          
          <!--<bgh:row>
            <bgh:cell/>
            <bgh:cell/>
            <bgh:cell>-->
                  <xsl:apply-templates select="parent::Call"/>
            <!--</bgh:cell>
          </bgh:row>-->
          
        </xsl:for-each>
     
      
    </xsl:for-each>

  </xsl:template>
  

  <!-- Call Details -->
  <xsl:template name="print-call-details">

    <xsl:param name="co-id"/>
    <xsl:param name="bopind"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>
    <xsl:param name="call-details"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>

    <!-- get the not-bundled services for which there are calls with respective BOPSeqNo or non BOP related calls or late calls -->
    <xsl:variable name="call-details-local" select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call[XCD[@CO=$co-id and not(@TapSeqNo) and not(@RapSeqNo)
           and not(@BundPurInd) and not(@BundUsgInd) and (@BOPSeqNoRP=$bopseqno or @BOPSeqNoSP=$bopseqno
           or not(@BOPSeqNoRP or @BOPSeqNoSP) or (@CTs &lt; $start-date))]]"/>

    <xsl:variable name="list-of-unique-services" select="set:distinct($call-details-local/XCD/@SN)" />

    <xsl:if test="count($list-of-unique-services) !=0 ">

      <bgh:row>
        <bgh:cell>
            <xsl:for-each select="$txt"><!-- Usage Charges -->
              <xsl:value-of select="key('txt-index','459')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        </bgh:cell>
      </bgh:row>

      <xsl:call-template name="group-by-services">
        <xsl:with-param name="co-id"                   select="$co-id"/>
        <xsl:with-param name="bopind"                  select="$bopind"/>
        <xsl:with-param name="bopseqno"                select="$bopseqno"/>
        <xsl:with-param name="boptype"                 select="$boptype"/>
        <xsl:with-param name="call-details"            select="$call-details-local"/>
        <xsl:with-param name="list-of-unique-services" select="$list-of-unique-services"/>
        <xsl:with-param name="period-start"            select="$period-start"/>
        <xsl:with-param name="period-end"              select="$period-end"/>
      </xsl:call-template>

      <bgh:row/>
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
      <xsl:call-template name="currency">
        <xsl:with-param name="CurrCode" select="@CC"/>
      </xsl:call-template>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="$bopind='Y'">
      <xsl:for-each select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call/XCD[@CO=$co-id and @SN=$service and @PurSeqNo=$sequence-no and @BundPurInd and (@BOPSeqNoRP=$bopseqno or @BOPSeqNoSP=$bopseqno)]">
        <xsl:call-template name="number-format">
          <xsl:with-param name="number" select="@DAmt"/>
        </xsl:call-template>
        <xsl:text> </xsl:text>
              <xsl:call-template name="currency">
                <xsl:with-param name="CurrCode" select="@CC"/>
              </xsl:call-template>
      </xsl:for-each>
    </xsl:if>

  </xsl:template>

  <!--  Bundle usage  -->
  <xsl:template name="print-call-details-bundle-usage">

    <xsl:param name="co-id"/>
    <xsl:param name="call-details"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>
    <xsl:param name="bopind" select="'N'"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>

    <xsl:variable name="call-details-local" select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call[XCD[@CO=$co-id and @BundUsgInd 
                        and ( ($bopind='Y' and ( $bopseqno=@BOPSeqNoRP or $bopseqno=@BOPSeqNoSP ) ) or $bopind='N')]]" />
    
    <xsl:variable name="list-of-unique-services" select="set:distinct($call-details-local/XCD/@SN)" />

    <xsl:if test="count($list-of-unique-services) != 0">

      <bgh:row>
        <bgh:cell/>
        <bgh:cell>
            <xsl:for-each select="$txt"><!-- Usage -->
              <xsl:value-of select="key('txt-index','461')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        </bgh:cell>
      </bgh:row>

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

    <xsl:if test="count($list-of-unique-services) != 0">

        <bgh:row>
            <bgh:cell>
                <xsl:for-each select="$txt"><!-- Call Details -->
                  <xsl:value-of select="key('txt-index','395')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
        </bgh:row>
      

      <xsl:call-template name="group-by-services">
        <xsl:with-param name="call-details" select="$call-details-local"/>
        <xsl:with-param name="list-of-unique-services" select="$list-of-unique-services"/>
      </xsl:call-template>

      <bgh:row/>
      
    </xsl:if>

  </xsl:template>

  
  <!-- not bundled call details grouped by services -->
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


        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                  <!-- service title -->
                  <xsl:call-template name="LgnMap">
                    <xsl:with-param name="Mode"  select="'0'"/>
                    <xsl:with-param name="Index" select="$current-service"/>
                    <xsl:with-param name="Type"  select="'SN'"/>
                    <xsl:with-param name="Desc"  select="'1'"/>
                  </xsl:call-template>
            </bgh:cell>
        </bgh:row>
            
            
        <xsl:for-each select="$xcd">
            <bgh:row>
                <bgh:cell/>
                <bgh:cell/>
                <bgh:cell>
                  <!-- date -->
                  <xsl:value-of select="key('xcd-index','CTs')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- prepaid indicator -->
                  <xsl:value-of select="key('xcd-index','PrInd')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- call type -->
                  <xsl:value-of select="key('xcd-index','CT')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- rate type -->
                    <xsl:value-of select="key('xcd-index','RT')[@xml:lang=$lang]/@Des"/>
                    <xsl:text> / </xsl:text>
                    <!-- rerate type -->
                    <xsl:value-of select="key('xcd-index','RRT')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- rated volume -->
                  <xsl:value-of select="key('xcd-index','DRV')[@xml:lang=$lang]/@Des"/>                
                </bgh:cell>
                <bgh:cell>
                    <!-- bop sequence no. -->
                    <xsl:value-of select="key('xcd-index','BOPSeqNoRP')[@xml:lang=$lang]/@Des"/>
                    <xsl:text> / </xsl:text>
                    <!-- pricing alternative -->
                    <xsl:value-of select="key('xcd-index','TIDPA')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- record type -->
                  <xsl:value-of select="key('xcd-index','NI')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- network name -->
                  <xsl:value-of select="key('xcd-index','NN')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- destination type -->
                  <xsl:value-of select="key('xcd-index','DES')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- zone point -->
                  <xsl:value-of select="key('xcd-index','DZP')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- other party number -->
                  <xsl:value-of select="key('xcd-index','OPN')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- A party -->
                  <xsl:value-of select="key('xcd-index','APN')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- tarif time -->
                  <xsl:value-of select="key('xcd-index','TT')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- tariff zone -->
                  <xsl:value-of select="key('xcd-index','TZ')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- tariff model -->
                  <xsl:value-of select="key('xcd-index','TM')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <!-- service package -->
                  <xsl:value-of select="key('xcd-index','SP')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                  <!-- amounts -->
                <bgh:cell>
                  <xsl:value-of select="key('xcd-index','OAmt')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                  <xsl:value-of select="key('xcd-index','DAmt')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
            </bgh:row>
        </xsl:for-each>
            
        <!-- Filter out mark-up fee charge parts because we print them separately -->
        <xsl:variable name="call-details-local" select="$call-details/XCD[@ChType!='M']"/>

        <xsl:choose>
          <!-- contract available ? -->
          <xsl:when test="$co-id!=''">

            <xsl:choose>
              <!-- if contract has no BOP -->
              <xsl:when test="$bopind='N'">

                <xsl:for-each select="$call-details-local[@SN=$current-service and @CO=$co-id
                 and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd)]">
                  <xsl:sort select="@CTs"/>
                  <xsl:sort select="@Id"/>
                  <xsl:sort select="@SubId"/>
                  <xsl:apply-templates select="parent::Call"/>
                </xsl:for-each>

              </xsl:when>
              <!-- if contract has BOP -->
              <xsl:otherwise>
                <!-- print late calls first -->
                <xsl:for-each select="$call-details-local[@SN=$current-service and @CO=$co-id
                 and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd) and (@CTs &lt; $start-date) and not(@BOPAltInd)]">
                  <xsl:sort select="@CTs"/>
                  <xsl:sort select="@Id"/>
                  <xsl:sort select="@SubId"/>
                  <xsl:apply-templates select="parent::Call"/>
                </xsl:for-each>
                <!-- print call details -->
                <xsl:choose>
                  <xsl:when test="$boptype='TM'">
                    <xsl:for-each select="$call-details-local[@SN=$current-service and @CO=$co-id
                     and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd) and (@CTs &gt;= $start-date) and (@BOPSeqNoRP=$bopseqno or not(@BOPSeqNoRP))]">
                      <xsl:sort select="@CTs"/>
                      <xsl:sort select="@Id"/>
                      <xsl:sort select="@SubId"/>
                      <xsl:apply-templates select="parent::Call"/>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:when test="$boptype='SP'">
                    <xsl:for-each select="$call-details-local[@SN=$current-service and @CO=$co-id
                     and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd) and (@CTs &gt;= $start-date) and (@BOPSeqNoSP=$bopseqno or not(@BOPSeqNoSP))]">
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
          <!-- no contracts (not CDS relevant) -->
          <xsl:otherwise>
            <!-- print call details  -->
            <xsl:for-each select="$call-details-local[@SN=$current-service
             and not(@TapSeqNo) and not(@RapSeqNo) and not(@BundPurInd) and not(@BundUsgInd)]">

              <xsl:if test="position()='1' or @CO != preceding::XCD[1]/@CO">
                <!-- print contract id header -->
                
                <bgh:row>
                    <bgh:cell/>
                    <bgh:cell>
                          <xsl:for-each select="$txt"><!-- Contract -->
                            <xsl:value-of select="key('txt-index','375')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                          <xsl:text>: </xsl:text>
                          <xsl:value-of select="@CO"/>
                    </bgh:cell>
                </bgh:row>
                
              </xsl:if>

              <xsl:apply-templates select="parent::Call"/>

            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
        
        
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
      
        <bgh:row/>
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                    <!-- Mark-up fees -->
                    <xsl:for-each select="$txt">
                      <xsl:value-of select="key('txt-index','549')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
            </bgh:cell>
        </bgh:row>
        
        <bgh:row>
            <bgh:cell/>
            <bgh:cell/>
            <bgh:cell>
                <!-- date -->
                <xsl:for-each select="$xcd">
                  <xsl:value-of select="key('xcd-index','CTs')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
              
            <xsl:for-each select="$fup">
            
              <bgh:cell>
                  <!-- Account -->
                  <xsl:value-of select="key('fup-index','FUAccId')[@xml:lang=$lang]/@Des"/>
              </bgh:cell>
              
              <bgh:cell>
                <!-- Package/element/version -->
                <xsl:value-of select="key('fup-index','FUP')[@xml:lang=$lang]/@Des"/>
                <xsl:text> / </xsl:text>
                <xsl:value-of select="key('fup-index','FUE')[@xml:lang=$lang]/@Des"/>
                <xsl:text> / </xsl:text>
                <xsl:value-of select="key('fup-index','FUEV')[@xml:lang=$lang]/@Des"/>
              </bgh:cell>
              
              <bgh:cell>
                <!-- Charge plan -->
                <xsl:value-of select="key('fup-index','ChPlan')[@xml:lang=$lang]/@Des"/>
              </bgh:cell>
              
            </xsl:for-each>
              
            <bgh:cell>
                <!-- Amount -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','50')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
              
          </bgh:row>
          
          
            <xsl:choose>
                <xsl:when test="$print-contract-id-header">
                    <!-- Print contract id header, don't change sorting -->
                    
                    <xsl:for-each select="$markup-fees">
                        
                        <xsl:if test="position()='1' or @CO != preceding::XCD[1]/@CO">
                            <!-- print contract id header -->
                            
                            <bgh:row>
                                <bgh:cell/>
                                <bgh:cell/>
                                <bgh:cell>
                                
                                  <xsl:for-each select="$txt"><!-- Contract -->
                                    <xsl:value-of select="key('txt-index','375')[@xml:lang=$lang]/@Des"/>
                                  </xsl:for-each>
                                  <xsl:text>: </xsl:text>
                                  <xsl:value-of select="@CO"/>
                                  
                                </bgh:cell>
                            </bgh:row>
                            
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
          
            
    
    </xsl:if>
  
  </xsl:template>
  
  
 <!-- Prints a single mark-up fee -->
  <xsl:template name="print-markup-fee">
  
    <xsl:param name="markup-fee"/>
    
    <xsl:variable name="fu-part" select="$markup-fee/following-sibling::FUP"/>
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell/>
        <bgh:cell>
              <!-- timestamp -->
              <xsl:call-template name="date-time-format">
                <xsl:with-param name="date" select="$markup-fee/@CTs"/>
              </xsl:call-template>
        </bgh:cell>
        
        <bgh:cell>
                <!-- free unit account id -->
                <xsl:value-of select="$fu-part/@FUAccId"/>          
                <xsl:text> / </xsl:text>
                <!-- free unit account history id -->
                <xsl:value-of select="$fu-part/@FUAccHistId"/>
        </bgh:cell>
        
        <bgh:cell>
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
        </bgh:cell>
       
        <bgh:cell>
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="$fu-part/@ChPlan"/>
                  <xsl:with-param name="Type"  select="'CPD'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
        </bgh:cell>
        
        <bgh:cell>
                <!-- discounted amount -->
                <xsl:if test="$markup-fee/@DAmt">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="$markup-fee/@DAmt"/>
                  </xsl:call-template>
                  <xsl:text> </xsl:text>
                  <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="$markup-fee/@CC"/>
                  </xsl:call-template>
                </xsl:if>
        </bgh:cell>
        
    </bgh:row>
    
  </xsl:template>
  
  
  <!-- bundle usage grouped by service (not TAP/RAP relevant) -->
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

        <bgh:row>
            <bgh:cell/>
            <bgh:cell/>
            <bgh:cell>
                  <!-- service title -->
                  <xsl:call-template name="LgnMap">
                    <xsl:with-param name="Mode"  select="'0'"/>
                    <xsl:with-param name="Index" select="$current-service"/>
                    <xsl:with-param name="Type"  select="'SN'"/>
                    <xsl:with-param name="Desc"  select="'1'"/>
                  </xsl:call-template>
            </bgh:cell> 
        </bgh:row>
            
        <bgh:row>
            <bgh:cell/>
            <bgh:cell/>
            <bgh:cell>
                <!-- date / time -->
                <xsl:for-each select="$xcd">
                  <xsl:value-of select="key('xcd-index','CTs')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <!-- bundle name -->
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','455')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <!-- bundle product -->
                <xsl:for-each select="$fup">
                  <xsl:value-of select="key('fup-index','BPROD')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <!-- quantity -->
                <xsl:for-each select="$xcd">
                  <xsl:value-of select="key('xcd-index','ORV')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            </bgh:row>
          
          
            <xsl:choose>
              <!-- contract available ? -->
              <xsl:when test="$co-id!=''">

                <xsl:choose>
                  <!-- if contract has no BOP -->
                  <xsl:when test="$bopind='N'">

                    <xsl:for-each select="$call-details/XCD[@SN=$current-service and @CO=$co-id and @BundUsgInd]">
                      <xsl:sort select="@CTs"/>
                      <xsl:sort select="@Id"/>
                      <xsl:sort select="@SubId"/>
                      <xsl:apply-templates select="parent::Call"/>
                    </xsl:for-each>

                  </xsl:when>
                  <!-- if contract has BOP -->
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
              <!-- no contracts (not CDS relevant) -->
              <xsl:otherwise>
                <!-- print call details  -->
                <xsl:for-each select="$call-details/XCD[@SN=$current-service and @BundUsgInd]">

                  <xsl:if test="position()='1' or @CO != preceding::XCD[1]/@CO">
                    <!-- print contract id header -->

                    <bgh:row>
                        <bgh:cell/>
                        <bgh:cell>
                              <xsl:for-each select="$txt">
                                <xsl:value-of select="key('txt-index','375')[@xml:lang=$lang]/@Des"/>
                              </xsl:for-each>
                              <xsl:text>: </xsl:text>
                              <xsl:value-of select="@CO"/>
                        </bgh:cell>
                    </bgh:row>
                    
                  </xsl:if>

                  <xsl:apply-templates select="parent::Call"/>

                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          
        <bgh:row/>
      
    </xsl:for-each>

  </xsl:template>

  <!-- helper template to remove duplicate strings -->
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

  <!--  call details large volume - currently not used  -->
  <xsl:template name="print-call-details-large-volume">

    <xsl:param name="co-id"/>
    <xsl:param name="bopind"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>
    <xsl:param name="call-details"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>

    
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','260')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
    

    

          
            <xsl:for-each select="$xcd">
              
                <!-- date -->
                <xsl:value-of select="key('xcd-index','CTs')[@xml:lang=$lang]/@Des"/>
                <!-- prepaid indicator -->
                <xsl:value-of select="key('xcd-index','PrInd')[@xml:lang=$lang]/@Des"/>
              
              
                <!-- call type -->
                <xsl:value-of select="key('xcd-index','CT')[@xml:lang=$lang]/@Des"/>                
                
                  <!-- rate type -->
                  <xsl:value-of select="key('xcd-index','RT')[@xml:lang=$lang]/@Des"/>
                  <xsl:text> / </xsl:text>
                  <!-- rerate type -->
                  <xsl:value-of select="key('xcd-index','RRT')[@xml:lang=$lang]/@Des"/>
                
              
              
                <!-- rated volume -->
                <xsl:value-of select="key('xcd-index','DRV')[@xml:lang=$lang]/@Des"/>
                <!-- bop sequence no. -->
                <xsl:value-of select="key('xcd-index','BOPSeqNoRP')[@xml:lang=$lang]/@Des"/>
              
              
                <!-- record type -->
                <xsl:value-of select="key('xcd-index','NI')[@xml:lang=$lang]/@Des"/>
                <!-- network name -->
                <xsl:value-of select="key('xcd-index','NN')[@xml:lang=$lang]/@Des"/>
              
              
                <!-- destination type -->
                <xsl:value-of select="key('xcd-index','DES')[@xml:lang=$lang]/@Des"/>
                <!-- zone point -->
                <xsl:value-of select="key('xcd-index','DZP')[@xml:lang=$lang]/@Des"/>
              
              
                <!-- other party number -->
                <xsl:value-of select="key('xcd-index','OPN')[@xml:lang=$lang]/@Des"/>
                <!-- A party -->
                <xsl:value-of select="key('xcd-index','APN')[@xml:lang=$lang]/@Des"/>
              
              <!-- tarif time and tarif zone -->
              
                <xsl:value-of select="key('xcd-index','TT')[@xml:lang=$lang]/@Des"/>
                <xsl:value-of select="key('xcd-index','TZ')[@xml:lang=$lang]/@Des"/>
              
              <!-- tariff model and service package -->
              
                <xsl:value-of select="key('xcd-index','TM')[@xml:lang=$lang]/@Des"/>
                <xsl:value-of select="key('xcd-index','SP')[@xml:lang=$lang]/@Des"/>
              
              <!-- amounts -->
              
                <xsl:value-of select="key('xcd-index','OAmt')[@xml:lang=$lang]/@Des"/>
                <xsl:value-of select="key('xcd-index','DAmt')[@xml:lang=$lang]/@Des"/>
              
            </xsl:for-each>
          
        
        
          <xsl:choose>
            <!-- contract available ? -->
            <xsl:when test="$co-id!=''">
               <xsl:choose>
                <!-- if contract has no BOP -->
                <xsl:when test="$bopind='N'">
                   <xsl:for-each select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call/XCD[@CO=$co-id]">
                     <xsl:apply-templates select="parent::Call"/>
                   </xsl:for-each>
                </xsl:when>
                <!-- if contract has BOP -->
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
            <!-- no contracts (not CDS relevant) -->
            <xsl:otherwise>
              <!-- print call details  -->
              <xsl:for-each select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call/XCD">
                <xsl:if test="position()='1' or @CO != preceding::XCD[1]/@CO">
                  <!-- print contract id header -->
                  
                      
                        <xsl:for-each select="$txt">
                          <xsl:value-of select="key('txt-index','375')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="@CO"/>
                      
                    
                  
                </xsl:if>
                <xsl:apply-templates select="parent::Call"/>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        
      
    

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
    
    <!-- get the services for which there are one-time and recurring charges -->
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
        
                <xsl:call-template name="print-charge-details-table-head">
                    <xsl:with-param name="charge-type" select="$charge-type"/>
                </xsl:call-template>
                
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
        
            <xsl:if test="normalize-space($list-of-unique-services)=''">
                <bgh:row/>
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
        
                <xsl:call-template name="print-charge-details-table-head">
                    <xsl:with-param name="charge-type" select="$charge-type"/>
                    <xsl:with-param name="col-offset" select="'1'"/>
                </xsl:call-template>
                
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
        
            <xsl:if test="normalize-space($list-of-unique-services)=''">
                <bgh:row/>
            </xsl:if>
            
        </xsl:when>
        <xsl:otherwise/>
    </xsl:choose>
    
    
  </xsl:template>
  
  
  <!-- Prints the charge type (recurring/one-time charges) and the table head -->
  <xsl:template name="print-charge-details-table-head">
    <xsl:param name="charge-type" />
    <xsl:param name="col-offset" select="''" />
  
    <!-- recurring charges -->
    <xsl:if test="$charge-type='A'">
      
        <bgh:row>
            <xsl:if test="$col-offset='1'">
                <bgh:cell/>
            </xsl:if>
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','482')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
        </bgh:row>
        
    </xsl:if>
    
    <!-- one-time charges -->
    <xsl:if test="$charge-type='S'">
        <bgh:row>
            <xsl:if test="$col-offset='1'">
                <bgh:cell/>
            </xsl:if>
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','483')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
        </bgh:row>
    </xsl:if>
    
    <bgh:row>
        <xsl:if test="$col-offset='1'">
            <bgh:cell/>
        </xsl:if>
        <bgh:cell/>
        <bgh:cell>
              <!-- Service -->
              <xsl:for-each select="$xcd">
                <xsl:value-of select="key('xcd-index','SN')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
              <!-- date -->
              <xsl:for-each select="$xcd">
                <xsl:value-of select="key('xcd-index','CTs')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
              <!-- prepaid indicator -->
              <xsl:for-each select="$xcd">
                <xsl:value-of select="key('xcd-index','PrInd')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
              <!-- tariff model -->
              <xsl:for-each select="$xcd">
                <xsl:value-of select="key('xcd-index','TM')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
              <!-- service package -->
              <xsl:for-each select="$xcd">                
                <xsl:value-of select="key('xcd-index','SP')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>                    
        </bgh:cell>
        <bgh:cell>
              <!-- quantity -->
              <xsl:for-each select="$xcd">
                <xsl:value-of select="key('xcd-index','Numit')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>                    
        </bgh:cell>
        <bgh:cell>
              <!-- active days -->
              <xsl:for-each select="$xcd">
                <xsl:value-of select="key('xcd-index','NumDays')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
              <!-- service charge subtype -->
              <xsl:for-each select="$xcd">
                <xsl:value-of select="key('xcd-index','SrvChSType')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>                    
        </bgh:cell>
        <bgh:cell>
              <!-- period, status info -->
              <xsl:for-each select="$xcd">
                <xsl:value-of select="key('xcd-index','ChrgStartTime')[@xml:lang=$lang]/@Des"/>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="key('xcd-index','SrvSt')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
              <!-- market -->
              <xsl:for-each select="$xcd">
                <xsl:value-of select="key('xcd-index','MKT')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
              <!-- price -->
              <xsl:for-each select="$xcd">
                <xsl:value-of select="key('xcd-index','Price')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
              <!-- profile -->
              <xsl:for-each select="$xcd">
                <xsl:value-of select="key('xcd-index','PRO')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell>
              <!-- amount -->
              <xsl:for-each select="$xcd">                
                <xsl:value-of select="key('xcd-index','OAmt')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>                    
        </bgh:cell>   
    </bgh:row>
  
  </xsl:template>
  

  <!-- charge details group by service -->
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

        <xsl:variable name="service">
              <!-- Service -->
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="$next-service"/>
                <xsl:with-param name="Type"  select="'SN'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
        </xsl:variable>
        
        <!-- Pregrouped charges -->
        <xsl:for-each select="$charge-details/ContrCalls[@Id=$co-id]/ServCalls/ChDet/XCD[@SN=$next-service and @SrvChType=$charge-type and @CO=$co-id]">
            <xsl:call-template name="ChDet">
                <xsl:with-param name="node" select="parent::ChDet"/>
                <xsl:with-param name="charge-type" select="$charge-type"/>
                <xsl:with-param name="service-name" select="$service"/>
                <xsl:with-param name="offset" select="'1'" />
            </xsl:call-template>
            
        </xsl:for-each>
        
        <!-- Ungrouped charges (e.g. in a ChargeNotification) -->
        <xsl:for-each select="$charge-details/ChDet/XCD[@SN=$next-service and @SrvChType=$charge-type and @CO=$co-id]">
            
            <xsl:call-template name="ChDet">
                <xsl:with-param name="node" select="parent::ChDet"/>
                <xsl:with-param name="charge-type" select="$charge-type"/>
                <xsl:with-param name="service-name" select="$service"/>
                <xsl:with-param name="offset" select="'2'" />
            </xsl:call-template>
            
        </xsl:for-each>

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

  
  <!-- Charge Details -->
  <xsl:template name="ChDet">

    <xsl:param name="node"/>
    <xsl:param name="charge-type"/>
    <xsl:param name="service-name"/>
    <xsl:param name="offset"/>
    
    <bgh:row>
        
        <xsl:choose>
            <xsl:when test="$offset = '1'">
                <bgh:cell/>
            </xsl:when>
            <xsl:when test="$offset = '2'">
                <bgh:cell/>
                <bgh:cell/>
            </xsl:when>
        </xsl:choose>
        
        <bgh:cell>
            <xsl:value-of select="$service-name" />
        </bgh:cell>
        
        <xsl:call-template name="charge-details">
            
              <xsl:with-param name="node" select="$node/XCD"/>
              <xsl:with-param name="charge-type" select="$charge-type"/>
          
        </xsl:call-template>
        
    </bgh:row>
    
    
    <xsl:if test="$node/FUP[(not(FUP/@FUPrepayInd) or (FUP/@FUPrepayInd != 1))]">
      
        <bgh:row>
        
          <xsl:for-each select="$fup">
          
            <xsl:choose>
                <xsl:when test="$offset = '1'">
                    <bgh:cell/>
                </xsl:when>
                <xsl:when test="$offset = '2'">
                    <bgh:cell/>
                    <bgh:cell/>
                </xsl:when>
            </xsl:choose>
        
            <bgh:cell/>
            
            <bgh:cell>
                <!-- cost control service -->
                <xsl:value-of select="key('fup-index','SN')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                <!-- profile -->
                <xsl:value-of select="key('fup-index','Profile')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
                <!-- discount amount -->
                <xsl:value-of select="key('fup-index','Amt')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
          </xsl:for-each>
          
        </bgh:row>
      
      <xsl:for-each select="$node/FUP[(not(FUP/@FUPrepayInd) or (FUP/@FUPrepayInd != 1))]">
        <bgh:row>
            <bgh:cell/>
            <bgh:cell/>
        
            <bgh:cell>
            
              <xsl:if test="position()='1'">
              <!--<xsl:attribute name="number-rows-spanned">
                <xsl:value-of select="count($node/FUP[(not(FUP/@FUPrepayInd) or (FUP/@FUPrepayInd != 1))])"/>
              </xsl:attribute>-->
                <xsl:for-each select="$txt"><!-- Consumed Amount -->
                  <xsl:value-of select="key('txt-index','280')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </xsl:if>
              
            </bgh:cell>
          
            <xsl:apply-templates select="." mode="charge-details"/>
          
        </bgh:row>
      </xsl:for-each>
      
    </xsl:if>

  </xsl:template>
  

  <!-- Call -->
  <xsl:template match="Call">
    
    <xsl:apply-templates select="XCD"/>

    <xsl:if test="FUP and not(FUP/@BPROD) and (not(FUP/@FUPrepayInd) or (FUP/@FUPrepayInd != 1))">
    
          <xsl:for-each select="$fup">
            <bgh:row>
                <bgh:cell/>
                <bgh:cell/>
                <bgh:cell>
                    <!-- cost control contract id -->
                    <xsl:value-of select="key('fup-index','CoId')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- account -->
                    <xsl:value-of select="key('fup-index','FUAccId')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- free unit part type -->
                    <xsl:value-of select="key('fup-index','FUOption')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>                
                <bgh:cell>
                    <!-- package / element / version -->
                    <xsl:value-of select="key('fup-index','FUP')[@xml:lang=$lang]/@Des"/>
                    <xsl:text> / </xsl:text>
                    <xsl:value-of select="key('fup-index','FUE')[@xml:lang=$lang]/@Des"/>
                    <xsl:text> / </xsl:text>
                    <xsl:value-of select="key('fup-index','FUEV')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- charge plan -->
                    <xsl:value-of select="key('fup-index','ChPlan')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>                   
                <bgh:cell>
                    <!-- cost control service -->
                    <xsl:value-of select="key('fup-index','SN')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- discount amount -->
                    <xsl:value-of select="key('fup-index','Amt')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
            </bgh:row>              
          </xsl:for-each>        
      
          <xsl:for-each select="FUP[(not(FUP/@FUPrepayInd) or (FUP/@FUPrepayInd != 1))]">
    
              <xsl:if test="position()='1'">            
                <bgh:row>
                    <bgh:cell/>
                    <bgh:cell>
                        <!-- discounts -->
                        <xsl:for-each select="$txt">
                          <xsl:value-of select="key('txt-index','301')[@xml:lang=$lang]/@Des"/>
                        </xsl:for-each>
                    </bgh:cell>
                    <xsl:apply-templates select="."/>
                </bgh:row>
              </xsl:if>
            
          </xsl:for-each>
      
    </xsl:if>

  </xsl:template>

  
  <!-- several record attributes (see table charge_detail_info) -->
  <xsl:template match="XCD">
    
    <bgh:row>
    
      <bgh:cell/>
      <bgh:cell/>

      <xsl:choose>
        <xsl:when test="not(@BundPurInd) and not(@BundUsgInd)">

            <!-- date -->
            <xsl:if test="not(@TapSeqNo or @RapSeqNo)">
              <bgh:cell>
                  <!-- timestamp -->
                  <xsl:call-template name="date-time-format">
                    <xsl:with-param name="date" select="@CTs"/>
                  </xsl:call-template>
              </bgh:cell>
            </xsl:if>
            <xsl:if test="@TapSeqNo or @RapSeqNo">
              <bgh:cell>
                  <!-- sum udr foh generation date -->
                  <xsl:call-template name="date-time-format">
                    <xsl:with-param name="date" select="@CTs"/>
                  </xsl:call-template>
              </bgh:cell>
            </xsl:if>          
            <xsl:if test="not(@TapSeqNo or @RapSeqNo)">
              <bgh:cell>
                <!-- prepaid indicator -->
                <xsl:call-template name="DataDomainLgnMap">
                  <xsl:with-param name="Index"     select="@PrInd"/>
                  <xsl:with-param name="Type"      select="'DD'"/>
                  <xsl:with-param name="Desc"      select="'1'"/>
                  <xsl:with-param name="ClassId"   select="'YES/NO_BOOLEAN_INDICATOR'"/>
                </xsl:call-template>
              </bgh:cell>
            </xsl:if>
        
          <!-- record type -->        
          <bgh:cell>
            <xsl:call-template name="DataDomainLgnMap">
              <xsl:with-param name="Index"     select="@CT"/>
              <xsl:with-param name="Type"      select="'DD'"/>
              <xsl:with-param name="Desc"      select="'1'"/>
              <xsl:with-param name="ClassId"   select="'CALL_TYPE_CLASS'"/>
            </xsl:call-template>
          </bgh:cell>
                    
          <xsl:if test="not(@TapSeqNo) and not(@RapSeqNo)">
            <bgh:cell>
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
            </bgh:cell>
          </xsl:if>
          
          <!-- TAP / RAP -->
          <xsl:if test="@TapSeqNo or @RapSeqNo">
            <bgh:cell>  
              <!-- service -->
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="@SN"/>
                <xsl:with-param name="Type"  select="'SN'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
            </bgh:cell>
          </xsl:if>
        
        <!-- rated volume -->        
        <bgh:cell>
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
        </bgh:cell>

        <xsl:if test="not(@TapSeqNo or @RapSeqNo)">
          <bgh:cell>
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
              <xsl:otherwise>
                <xsl:text>-</xsl:text>
              </xsl:otherwise>
            </xsl:choose>            
            <xsl:text> / </xsl:text>
            <!-- pricing alternative -->
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="@TIDPA"/>
              <xsl:with-param name="Type"  select="'PA'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>            
          </bgh:cell>
        </xsl:if>
        
        <bgh:cell>
          <!-- network indicator -->
          <xsl:call-template name="DataDomainLgnMap">
            <xsl:with-param name="Index"     select="@NI"/>
            <xsl:with-param name="Type"      select="'DD'"/>
            <xsl:with-param name="Desc"      select="'1'"/>
            <xsl:with-param name="ClassId"   select="'XFILE_IND_CLASS'"/>
          </xsl:call-template>
        </bgh:cell>

        <xsl:if test="not(@TapSeqNo or @RapSeqNo)">
          <bgh:cell>          
              <!-- network name -->
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="@NN"/>
                <xsl:with-param name="Type"  select="'PL'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>                      
          </bgh:cell>
        </xsl:if>
                
        <xsl:if test="not(@TapSeqNo or @RapSeqNo)">
          <!-- destination -->
          <bgh:cell>
              <xsl:call-template name="DataDomainLgnMap">
                <xsl:with-param name="Index"     select="@DES"/>
                <xsl:with-param name="Type"      select="'DD'"/>
                <xsl:with-param name="Desc"      select="'1'"/>
                <xsl:with-param name="ClassId"   select="'CALL_DEST_CLASS'"/>
              </xsl:call-template>
            </bgh:cell>
            <bgh:cell>
              <!-- destination zone point -->
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="@DZP"/>
                <xsl:with-param name="Type"  select="'ZD'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
            </bgh:cell>
        </xsl:if>
        
        <xsl:if test="not(@TapSeqNo or @RapSeqNo)">
            <bgh:cell>
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
            </bgh:cell>
            <bgh:cell>
              <!-- A-party number -->
              <xsl:value-of select="@APN"/>
            </bgh:cell>
        </xsl:if>

        <bgh:cell>
            <!-- tariff time -->
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="@TT"/>
              <xsl:with-param name="Type"  select="'TT'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
        </bgh:cell>
        
        <bgh:cell>
            <!-- tariff zone -->
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="@TZ"/>
              <xsl:with-param name="Type"  select="'TZ'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
        </bgh:cell>
        
        <!-- tariff -->
        
          <xsl:choose>
            <xsl:when test="@BOPTM or @BOPSP">
              <!-- tariff model -->
              <bgh:cell>
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="@BOPTM"/>
                  <xsl:with-param name="Type"  select="'TM'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </bgh:cell>
              <bgh:cell>
                <!-- service package -->
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="@BOPSP"/>
                  <xsl:with-param name="Type"  select="'SP'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </bgh:cell>
            </xsl:when>
            <xsl:otherwise>
              <bgh:cell>
              <!-- tariff model -->
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="@TM"/>
                  <xsl:with-param name="Type"  select="'TM'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </bgh:cell>
              <bgh:cell>
                <!-- service package -->
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="@SP"/>
                  <xsl:with-param name="Type"  select="'SP'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </bgh:cell>
            </xsl:otherwise>
          </xsl:choose>
        
        <!-- amount -->
        
        <bgh:cell>
          <!-- original amount (in case of TAP TAP net rate and amount currency) -->
            <xsl:if test="@OAmt">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@OAmt"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:call-template name="currency">
                <xsl:with-param name="CurrCode" select="@CC"/>
              </xsl:call-template>
            </xsl:if>
        </bgh:cell>
          
        <bgh:cell>
            <!-- discounted amount -->
            <xsl:if test="@DAmt">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@DAmt"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:call-template name="currency">
                <xsl:with-param name="CurrCode" select="@CC"/>
              </xsl:call-template>
            </xsl:if>
        </bgh:cell>
        
        <!-- TAP / RAP -->
        <xsl:if test="@TapSeqNo or @RapSeqNo">
          <bgh:cell>  
            
              <!-- external amount  -->
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@ExtAmt"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <!-- normally @ExtCurrCode must be used, but this attribute is missing in the samples -->
              <xsl:call-template name="currency">
                <xsl:with-param name="CurrCode" select="@CC"/>
              </xsl:call-template>
            
            
              <xsl:if test="@ExtTax">
                <!-- external tax -->
                <xsl:call-template name="number-format">
                  <xsl:with-param name="number" select="@ExtTax"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <!-- normally @ExtCurrCode must be used, but this attribute is missing in the samples -->
              <xsl:call-template name="currency">
                <xsl:with-param name="CurrCode" select="@CC"/>
              </xsl:call-template>
              </xsl:if>
            
          </bgh:cell>  
        </xsl:if>

      </xsl:when>
      
      <xsl:when test="@BundUsgInd">
        <bgh:cell>
            <!-- date / time -->
            <xsl:call-template name="date-time-format">
              <xsl:with-param name="date" select="@CTs"/>
            </xsl:call-template>
        </bgh:cell>
        <bgh:cell>
            <!-- bundle name -->
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="../FUP/@SN"/>
              <xsl:with-param name="Type"  select="'SN'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
        </bgh:cell>
        <bgh:cell>
            <!-- bundle product -->
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="../FUP/@BPROD"/>
              <xsl:with-param name="Type"  select="'BPROD'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
        </bgh:cell>
        <bgh:cell>
            <!-- quantity -->
            <xsl:call-template name="number-unit-format">
              <xsl:with-param name="number" select="@ORV"/>
              <xsl:with-param name="unit" select="@UM"/>
            </xsl:call-template>
        </bgh:cell>
      </xsl:when>      
      <xsl:otherwise/>

    </xsl:choose>
    
    </bgh:row>

  </xsl:template>
  
  <!-- package -->
  <xsl:template match="FUP">

    <bgh:cell>
        <!-- cost control contract -->
        <xsl:value-of select="@CoId"/>
    </bgh:cell>      
    <bgh:cell>
        <!-- account id -->
        <xsl:value-of select="@FUAccId"/>
        <xsl:if test="@FUAccHistId">
          <xsl:text> / </xsl:text>
        </xsl:if>
        <!-- account history id -->
        <xsl:value-of select="@FUAccHistId"/>
    </bgh:cell>
    <bgh:cell>
        <!-- type -->
        <xsl:call-template name="DataDomainLgnMap">
          <xsl:with-param name="Index"     select="@FUOption"/>
          <xsl:with-param name="Type"      select="'DD'"/>
          <xsl:with-param name="Desc"      select="'1'"/>
          <xsl:with-param name="ClassId"   select="'FREE_UNIT_OPTION_CLASS'"/>
        </xsl:call-template>
    </bgh:cell>            
    <bgh:cell>
        <!-- package -->
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@FUP"/>
          <xsl:with-param name="Type"  select="'FUP'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
        <!-- element -->
        <xsl:if test="@FUE">
          <xsl:text> / </xsl:text>
          <xsl:value-of select="@FUE"/>
        </xsl:if>
        <!-- version -->
        <xsl:if test="@FUEV">
          <xsl:text> / </xsl:text>
          <xsl:value-of select="@FUEV"/>
        </xsl:if>
    </bgh:cell>
      
    <bgh:cell>
        <!-- charge plan -->
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@ChPlan"/>
          <xsl:with-param name="Type"  select="'CPD'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
    </bgh:cell>
    
    <bgh:cell>
        <!-- cost control service -->
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@SN"/>
          <xsl:with-param name="Type"  select="'SN'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
    </bgh:cell>
    
    <!-- discount amount -->     
    <bgh:cell>
        <xsl:if test="@Amt">
          <xsl:call-template name="number-format">
            <xsl:with-param name="number" select="@Amt"/>
          </xsl:call-template>
          <xsl:text> </xsl:text>
            <xsl:call-template name="currency">
              <xsl:with-param name="CurrCode" select="@AmtCurrCode"/>
            </xsl:call-template>
        </xsl:if>
    </bgh:cell>
          
  </xsl:template>

  <!-- several charge attributes (see table charge_detail_info) -->
  <xsl:template name="charge-details">

    <xsl:param name="node"/>
    <xsl:param name="charge-type"/>


    <!--<bgh:row>-->
        <bgh:cell>
            <!-- date -->
            <!-- timestamp -->
            <xsl:call-template name="date-time-format">
              <xsl:with-param name="date" select="$node/@CTs"/>
            </xsl:call-template>
        </bgh:cell>
        <bgh:cell>
            <!-- prepaid indicator -->
            <xsl:call-template name="DataDomainLgnMap">
              <xsl:with-param name="Index"     select="$node/@PrInd"/>
              <xsl:with-param name="Type"      select="'DD'"/>
              <xsl:with-param name="Desc"      select="'1'"/>
              <xsl:with-param name="ClassId"   select="'YES/NO_BOOLEAN_INDICATOR'"/>
            </xsl:call-template>
        </bgh:cell>

          <!-- tariff -->
          <xsl:choose>
            <xsl:when test="$node/@BOPTM or $node/@BOPSP">
              <bgh:cell>
                <!-- tariff model / version -->
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="$node/@BOPTM"/>
                  <xsl:with-param name="Type"  select="'TM'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$node/@TMV"/>
              </bgh:cell>
              <bgh:cell>
                <!-- service package -->
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="$node/@BOPSP"/>
                  <xsl:with-param name="Type"  select="'SP'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </bgh:cell>
            </xsl:when>
            <xsl:otherwise>
              <bgh:cell>
                <!-- tariff model -->
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="$node/@TM"/>
                  <xsl:with-param name="Type"  select="'TM'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$node/@TMV"/>
              </bgh:cell>
              <bgh:cell>
                <!-- service package -->
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="$node/@SP"/>
                  <xsl:with-param name="Type"  select="'SP'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </bgh:cell>
            </xsl:otherwise>
          </xsl:choose>
              
        <bgh:cell>
          <!-- quantity -->
          <xsl:choose>
            <xsl:when test="$node/@Numit">
              
                <xsl:value-of select="$node/@Numit"/>
                            
            </xsl:when>
            <xsl:otherwise>
              
                <xsl:text>-</xsl:text>
              
            </xsl:otherwise>
          </xsl:choose>
        </bgh:cell>
        <bgh:cell>
          <!-- active days -->
          <xsl:choose>
            <xsl:when test="$node/@NumDays">
              
                <xsl:value-of select="$node/@NumDays"/>
                            
            </xsl:when>
            <xsl:otherwise>
              
                <xsl:text>-</xsl:text>
              
            </xsl:otherwise>
          </xsl:choose>
        </bgh:cell>
        <bgh:cell>
            <!-- service charge subtype -->
            <xsl:call-template name="DataDomainLgnMap">
              <xsl:with-param name="Index"     select="$node/@SrvChSType"/>
              <xsl:with-param name="Type"      select="'DD'"/>
              <xsl:with-param name="Desc"      select="'1'"/>
              <xsl:with-param name="ClassId"   select="'CHARGE_SUBTYPE_CLASS'"/>
            </xsl:call-template>
        </bgh:cell> 
        <bgh:cell>
            <!-- period, service status -->
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
              <xsl:value-of select="$node/@SrvSt"/>
            </xsl:if>
        </bgh:cell>
        <bgh:cell>
            <!-- market -->
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="$node/@MKT"/>
              <xsl:with-param name="Type"  select="'MRKT'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
        </bgh:cell>
        
        <!-- service info ( @PrmValueId can be mapped to the description via the respective SumItem ) -->
        <!--
            <xsl:value-of select="$node/@PrmValueId"/>
        -->

        <bgh:cell>
            <!-- price -->
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="$node/@Price"/>
            </xsl:call-template>          
            <xsl:text> </xsl:text>
              <xsl:call-template name="currency">
                <xsl:with-param name="CurrCode" select="$node/@PriceCurr"/>
              </xsl:call-template>
        </bgh:cell>
        <bgh:cell>
            <!-- profile -->
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="$node/@PRO"/>
              <xsl:with-param name="Type"  select="'PRO'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
        </bgh:cell>
        
        <bgh:cell>
            <!-- undisc. amount -->
            <xsl:if test="$node/@OAmt">
              <xsl:call-template name="number-format">
                <xsl:with-param name="number" select="@OAmt"/>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:call-template name="currency">
                <xsl:with-param name="CurrCode" select="$node/@CC"/>
              </xsl:call-template>
            </xsl:if>
        </bgh:cell>
        
    <!--</bgh:row>-->  
    
  </xsl:template>

  <!-- free unit package -->
  <xsl:template match="FUP" mode="charge-details">

    <bgh:cell>
        <!-- cost control service -->
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@SN"/>
          <xsl:with-param name="Type"  select="'SN'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
    </bgh:cell>
    <bgh:cell>
        <!-- profile -->
        <xsl:call-template name="LgnMap">
          <xsl:with-param name="Mode"  select="'0'"/>
          <xsl:with-param name="Index" select="@Profile"/>
          <xsl:with-param name="Type"  select="'PRO'"/>
          <xsl:with-param name="Desc"  select="'1'"/>
        </xsl:call-template>
    </bgh:cell>
    <bgh:cell>
        <!-- discount amount -->
        <xsl:if test="@Amt">
          <xsl:call-template name="number-format">
            <xsl:with-param name="number" select="@Amt"/>
          </xsl:call-template>
          <xsl:text> </xsl:text>
          <xsl:call-template name="currency">
            <xsl:with-param name="CurrCode" select="@AmtCurrCode"/>
          </xsl:call-template>
        </xsl:if>
    </bgh:cell>
      
    
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
