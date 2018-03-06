<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    RecordDetailCSV.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> CSV stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms top-up actions.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/RecordDetailCSV.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bgh="http://www.lhsgroup.com/BSCS/BGH" exclude-result-prefixes="xsl bgh">

  <xsl:variable name="top-up-actions" select="document(/Bill/Part/@File)/Document/RecordDetail/RDD"/>

  <!-- top-up actions -->
  <xsl:template name="record-details">

    <xsl:param name="co-id" select="''"/>
    <xsl:param name="top-up-actions"/>

    <xsl:if test="$top-up-actions/RDD[$co-id = @TUACO or $co-id = @TURCO]">

      <xsl:call-template name="top-up-actions-by-stand-alone-contracts">
        <xsl:with-param name="list-of-unique-top-up-action-contracts" select="concat($co-id,' ')"/>    
        <xsl:with-param name="header" select="'Y'"/>
        <xsl:with-param name="sum-sheet-contract" select="'Y'"/>
      </xsl:call-template>

    </xsl:if>

  </xsl:template>

  <!-- stand-alone top-up actions -->
  <xsl:template name="top-up-actions">

    <!-- build a unique list of top-up action contracts -->
    <xsl:variable name="list-of-top-up-action-contracts">
      <xsl:for-each select="$top-up-actions/@TUACO">
        <xsl:sort select="." data-type="text"/>
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="list-of-unique-top-up-action-contracts">
      <xsl:call-template name="remove-duplicates">
        <xsl:with-param name="list-of-services" select="$list-of-top-up-action-contracts"/>
        <xsl:with-param name="last-service" select="''"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="normalize-space($list-of-unique-top-up-action-contracts)!=''">

      <xsl:call-template name="top-up-actions-by-stand-alone-contracts">
        <xsl:with-param name="list-of-unique-top-up-action-contracts" select="$list-of-unique-top-up-action-contracts"/>
        <xsl:with-param name="header" select="'Y'"/>
        <xsl:with-param name="sum-sheet-contract" select="'N'"/>
      </xsl:call-template>

    </xsl:if>  

  </xsl:template>

  <!-- stand-alone top-up actions -->
  <xsl:template name="top-up-actions-by-stand-alone-contracts">

    <xsl:param name="list-of-unique-top-up-action-contracts" select="''"/>
    <xsl:param name="header" select="'N'"/>
    <xsl:param name="sum-sheet-contract" select="'N'"/>

    <xsl:if test="normalize-space($list-of-unique-top-up-action-contracts)!=''">

      <xsl:variable name="next-top-up-action-contract">
        <xsl:value-of select="substring-before($list-of-unique-top-up-action-contracts, ' ')"/>
      </xsl:variable>

      <xsl:variable name="remaining-top-up-action-contracts">
        <xsl:value-of select="substring-after($list-of-unique-top-up-action-contracts, ' ')"/>
      </xsl:variable>

      <xsl:if test="(not(contains($list-of-unique-sum-sheet-contracts,$next-top-up-action-contract)) and $sum-sheet-contract = 'N') or
                        (contains($list-of-unique-sum-sheet-contracts,$next-top-up-action-contract)  and $sum-sheet-contract = 'Y')">

        <xsl:if test="$header = 'Y'">
            <bgh:row>
                <bgh:cell>
                    <xsl:for-each select="$txt"><!-- Top-Up Requests -->
                      <xsl:value-of select="key('txt-index','513')[@xml:lang=$lang]/@Des"/>
                    </xsl:for-each>
                </bgh:cell>
            </bgh:row>
        </xsl:if>

        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                  <xsl:for-each select="$txt"><!-- Contract -->
                    <xsl:value-of select="key('txt-index','110')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$next-top-up-action-contract"/>
            </bgh:cell>
        </bgh:row>
      
      
        <xsl:call-template name="top-up-action-header"/>
    
    
        <!-- build a unique list of requests per contract -->
        <xsl:variable name="list-of-requests-per-contract">
          <xsl:for-each select="$top-up-actions[$next-top-up-action-contract = @TUACO or $next-top-up-action-contract = @TURCO]/@TURid">
            <xsl:sort select="." data-type="number"/>
            <xsl:value-of select="."/>
            <xsl:text> </xsl:text>
          </xsl:for-each>
        </xsl:variable>
    
        <xsl:variable name="list-of-unique-requests-per-contract">
          <xsl:call-template name="remove-duplicates">
            <xsl:with-param name="list-of-services" select="$list-of-requests-per-contract"/>
            <xsl:with-param name="last-service" select="''"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:if test="normalize-space($list-of-unique-requests-per-contract)!=''">            
          <xsl:call-template name="top-up-actions-by-stand-alone-contracts-per-request">
            <xsl:with-param name="next-top-up-action-contract" select="$next-top-up-action-contract"/>
            <xsl:with-param name="list-of-unique-requests-per-contract" select="$list-of-unique-requests-per-contract"/>
          </xsl:call-template>            
        </xsl:if> 

    
        <bgh:row/>
        
      </xsl:if>

      <xsl:if test="normalize-space($remaining-top-up-action-contracts) != ''">
        <xsl:call-template name="top-up-actions-by-stand-alone-contracts">
          <xsl:with-param name="list-of-unique-top-up-action-contracts" select="$remaining-top-up-action-contracts"/>
          <xsl:with-param name="header" select="'N'"/>
          <xsl:with-param name="sum-sheet-contract" select="$sum-sheet-contract"/>
        </xsl:call-template>
      </xsl:if>

    </xsl:if>

  </xsl:template>
  

  <!-- stand-alone top-up actions per contract and request -->
  <xsl:template name="top-up-actions-by-stand-alone-contracts-per-request">

    <xsl:param name="next-top-up-action-contract" select="''"/>
    <xsl:param name="list-of-unique-requests-per-contract" select="''"/>

    <xsl:if test="normalize-space($list-of-unique-requests-per-contract)!='' and normalize-space($next-top-up-action-contract)!='' ">

      <xsl:variable name="next-top-up-action-contract-request">
        <xsl:value-of select="substring-before($list-of-unique-requests-per-contract, ' ')"/>
      </xsl:variable>

      <xsl:variable name="remaining-top-up-action-contract-requests">
        <xsl:value-of select="substring-after($list-of-unique-requests-per-contract, ' ')"/>
      </xsl:variable>


      <!-- build a unique list of request sub id's per contract and request -->
      <xsl:variable name="list-of-subids-per-request-and-contract">
        <xsl:for-each select="$top-up-actions[($next-top-up-action-contract = @TUACO or $next-top-up-action-contract = @TURCO)
                              and $next-top-up-action-contract-request = @TURid]/@TURSubId">
          <xsl:sort select="." data-type="number"/>
          <xsl:value-of select="."/>
          <xsl:text> </xsl:text>
        </xsl:for-each>
      </xsl:variable>
            
      <xsl:variable name="list-of-unique-subids-per-request-and-contract">
        <xsl:call-template name="remove-duplicates">
          <xsl:with-param name="list-of-services" select="$list-of-subids-per-request-and-contract"/>
          <xsl:with-param name="last-service" select="''"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:call-template name="top-up-action-per-contract-request-subid">
        <xsl:with-param name="list-of-unique-subids-per-request-and-contract" select="$list-of-unique-subids-per-request-and-contract"/>
        <xsl:with-param name="next-top-up-action-contract" select="$next-top-up-action-contract"/>
        <xsl:with-param name="next-top-up-action-contract-request" select="$next-top-up-action-contract-request"/>
      </xsl:call-template>

      <xsl:if test="normalize-space($remaining-top-up-action-contract-requests) != ''">
        <xsl:call-template name="top-up-actions-by-stand-alone-contracts-per-request">
          <xsl:with-param name="next-top-up-action-contract" select="$next-top-up-action-contract"/>
          <xsl:with-param name="list-of-unique-requests-per-contract" select="$remaining-top-up-action-contract-requests"/>
        </xsl:call-template>
      </xsl:if>

    </xsl:if>

  </xsl:template>
  

  <!-- stand-alone top-up actions per contract and request and request subid -->
  <xsl:template name="top-up-action-per-contract-request-subid">

    <xsl:param name="list-of-unique-subids-per-request-and-contract" select="''"/>
    <xsl:param name="next-top-up-action-contract" select="''"/>
    <xsl:param name="next-top-up-action-contract-request" select="''"/>

    <xsl:if test="normalize-space($list-of-unique-subids-per-request-and-contract)!='' and normalize-space($next-top-up-action-contract)!=''
                  and normalize-space($next-top-up-action-contract-request)!=''">

      <xsl:variable name="next-top-up-action-contract-request-subid">
        <xsl:value-of select="substring-before($list-of-unique-subids-per-request-and-contract, ' ')"/>
      </xsl:variable>

      <xsl:variable name="remaining-top-up-action-contract-request-subids">
        <xsl:value-of select="substring-after($list-of-unique-subids-per-request-and-contract, ' ')"/>
      </xsl:variable>

      <xsl:choose>
        <!-- only the request itself is available -->
        <xsl:when test="count ( $top-up-actions[$next-top-up-action-contract-request = @TURid and
                        $next-top-up-action-contract-request-subid = @TURSubId and
                        ( $next-top-up-action-contract = @TUACO or $next-top-up-action-contract = @TURCO )] ) = 1">
          <xsl:call-template name="top-up-action-item">
            <xsl:with-param name="top-up-action-contract" select="$next-top-up-action-contract"/>
            <xsl:with-param name="top-up-action-request" select="$next-top-up-action-contract-request"/>
            <xsl:with-param name="top-up-action-status" select="'1'"/>
            <xsl:with-param name="top-up-action-request-subid" select="$next-top-up-action-contract-request-subid"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <!-- print status completed -->
            <xsl:when test="$top-up-actions[$next-top-up-action-contract-request = @TURid and
                            $next-top-up-action-contract-request-subid = @TURSubId and
                            ( $next-top-up-action-contract = @TUACO or $next-top-up-action-contract = @TURCO )]/@TUAS = '2'">
              <xsl:call-template name="top-up-action-item">
                <xsl:with-param name="top-up-action-contract" select="$next-top-up-action-contract"/>
                <xsl:with-param name="top-up-action-request" select="$next-top-up-action-contract-request"/>
                <xsl:with-param name="top-up-action-status" select="'2'"/>
                <xsl:with-param name="top-up-action-request-subid" select="$next-top-up-action-contract-request-subid"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <!-- print status failed -->
              <xsl:call-template name="top-up-action-item">
                <xsl:with-param name="top-up-action-contract" select="$next-top-up-action-contract"/>
                <xsl:with-param name="top-up-action-request" select="$next-top-up-action-contract-request"/>
                <xsl:with-param name="top-up-action-status" select="'3'"/>
                <xsl:with-param name="top-up-action-request-subid" select="$next-top-up-action-contract-request-subid"/>
              </xsl:call-template>                        
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:if test="normalize-space($remaining-top-up-action-contract-request-subids) != ''">
        <xsl:call-template name="top-up-action-per-contract-request-subid">
          <xsl:with-param name="list-of-unique-subids-per-request-and-contract" select="$remaining-top-up-action-contract-request-subids"/>
          <xsl:with-param name="next-top-up-action-contract" select="$next-top-up-action-contract"/>
          <xsl:with-param name="next-top-up-action-contract-request" select="$next-top-up-action-contract-request"/>
        </xsl:call-template>
      </xsl:if>

    </xsl:if>

  </xsl:template>

  <!-- top-up action header -->
  <xsl:template name="top-up-action-header">
              
    <xsl:for-each select="$rdd">
        
        <bgh:row>
            <bgh:cell/>
            <bgh:cell/>
        
            <bgh:cell>
              <!-- top-up request voucher type -->
              <xsl:value-of select="key('rdd-index','TURVOT')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
              <!-- top-up request voucher amount -->
              <xsl:value-of select="key('rdd-index','TURVOAmt')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
              <!-- top-up request active / passive voucher period -->
              <xsl:value-of select="key('rdd-index','TURAEP')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
              <!-- top-up action package -->
              <xsl:value-of select="key('rdd-index','TUAPCK')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
              <!-- top-up action model -->
              <xsl:value-of select="key('rdd-index','TUAMOD')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
              <!-- top-up action element -->
              <xsl:value-of select="key('rdd-index','TUAELEM')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
              <!-- top-up action mechanism -->
              <xsl:value-of select="key('rdd-index','TUAMECH')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
              <!-- top-up action type / discount relevant -->
              <xsl:value-of select="key('rdd-index','TUAT')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
              <!-- top-up action status -->
              <xsl:value-of select="key('rdd-index','TUAS')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
              <!-- top-up action service -->
              <xsl:value-of select="key('rdd-index','TUASN')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
              <!-- life cycle triggering -->
              <xsl:value-of select="key('rdd-index','TURTLCF')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
              <!-- top-up action tariff model -->
              <xsl:value-of select="key('rdd-index','TUATM')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
              <!-- top-up action pricing alternative -->
              <xsl:value-of select="key('rdd-index','TUAPA')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
              <!-- top-up action period -->
              <xsl:value-of select="key('rdd-index','TUAFROM')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
              <!-- top-up action active / passive period -->
              <xsl:value-of select="key('rdd-index','TUAAEP')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
            <bgh:cell>
              <!-- top-up action amount -->
              <xsl:value-of select="key('rdd-index','TUAAmt')[@xml:lang=$lang]/@Des"/>
            </bgh:cell>
        </bgh:row>
        
    </xsl:for-each>
  
  </xsl:template>

  
  <!-- top-up action item -->
  <xsl:template name="top-up-action-item">

    <xsl:param name="top-up-action-contract" select="''"/>
    <xsl:param name="top-up-action-request" select="''"/>
    <xsl:param name="top-up-action-status" select="''"/>
    <xsl:param name="top-up-action-request-subid" select="''"/>

    <bgh:row>
        <bgh:cell/>
        <bgh:cell/>
    
    <bgh:cell>
        <!-- voucher type -->
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
             $top-up-action-request-subid = @TURSubId and
             ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TURVOT"/>
            <xsl:with-param name="Type"  select="'VT'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
    </bgh:cell>
    
    <bgh:cell>
        <!-- voucher amount -->
          <xsl:call-template name="number-format">
            <xsl:with-param name="number" select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                                  $top-up-action-request-subid = @TURSubId and
                                                  ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TURVOAmt"/>
          </xsl:call-template>
          <xsl:text> </xsl:text>
          <xsl:call-template name="currency">
            <xsl:with-param name="CurrCode" select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
        $top-up-action-request-subid = @TURSubId and
        ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TURVOCurr"/>
          </xsl:call-template>
    </bgh:cell>
    
    <bgh:cell>
        <!-- voucher active / passive period -->
        
          <!-- active -->
          <xsl:if test="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                        $top-up-action-request-subid = @TURSubId and
                                        ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TURAEP">
            <xsl:value-of select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                        $top-up-action-request-subid = @TURSubId and
                                        ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TURAEP"/>
            <xsl:text> </xsl:text>
            <!-- duration unit -->
            <xsl:call-template name="DataDomainLgnMap">
              <xsl:with-param name="Index"     select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                                       $top-up-action-request-subid = @TURSubId and
                                                      ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TURAEPT"/>
              <xsl:with-param name="Type"      select="'DD'"/>
              <xsl:with-param name="Desc"      select="'1'"/>
              <xsl:with-param name="ClassId"   select="'PERIOD_TYPE_CLASS'"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:text> / </xsl:text>
          <!-- passive -->
          <xsl:if test="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                        $top-up-action-request-subid = @TURSubId and
                                        ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TURPEP">
            <xsl:value-of select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                        $top-up-action-request-subid = @TURSubId and
                                        ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TURPEP"/>
            <xsl:text> </xsl:text>
            <!-- duration unit -->
            <xsl:call-template name="DataDomainLgnMap">
               <xsl:with-param name="Index"     select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                                        $top-up-action-request-subid = @TURSubId and
                                                        ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TURPEPT"/>
              <xsl:with-param name="Type"      select="'DD'"/>
              <xsl:with-param name="Desc"      select="'1'"/>
              <xsl:with-param name="ClassId"   select="'PERIOD_TYPE_CLASS'"/>
            </xsl:call-template>
          </xsl:if>   
    </bgh:cell>
    
    <bgh:cell>
        <!-- top-up package -->
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                                 $top-up-action-request-subid = @TURSubId and
                                                 ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUAPCK"/>
            <xsl:with-param name="Type"  select="'PP'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
    </bgh:cell>
    
    <bgh:cell>
        <!-- top-up model -->
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                                 $top-up-action-request-subid = @TURSubId and
                                                 ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUAMOD"/>
            <xsl:with-param name="Type"  select="'PM'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
    </bgh:cell>
    
    <bgh:cell>
        <!-- top-up element -->
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                                 $top-up-action-request-subid = @TURSubId and
                                                 ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUAELEM"/>
            <xsl:with-param name="Type"  select="'PME'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
    </bgh:cell>
    
    <bgh:cell>
        <!-- top-up mechanism -->
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                                 $top-up-action-request-subid = @TURSubId and
                                                 ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUAMECH"/>
            <xsl:with-param name="Type"  select="'PMC'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
    </bgh:cell>
    
    <bgh:cell>
        <!-- action type -->
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                                 $top-up-action-request-subid = @TURSubId and
                                                 ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUAT"/>
            <xsl:with-param name="Type"  select="'TUAT'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
          <xsl:text> / </xsl:text>
          <xsl:if test="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                        $top-up-action-request-subid = @TURSubId and
                        ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUAPIND = 'Y'">
            <xsl:text> X </xsl:text>
          </xsl:if>
    </bgh:cell>
    
    <bgh:cell>
        <!-- action status -->
        <xsl:call-template name="DataDomainLgnMap">
          <xsl:with-param name="Index"     select="$top-up-action-status"/>
          <xsl:with-param name="Type"      select="'DD'"/>
          <xsl:with-param name="Desc"      select="'1'"/>
          <xsl:with-param name="ClassId"   select="'TOPUP_ACTION_ITEM STATUS_CLASS'"/>
        </xsl:call-template>
    </bgh:cell>
    
    <bgh:cell>
        <!-- top-up action service -->
          <xsl:choose>
            <xsl:when test="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                            $top-up-action-request-subid = @TURSubId and
                            ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUASN">
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                                     $top-up-action-request-subid = @TURSubId and
                                                     ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUASN"/>
                <xsl:with-param name="Type"  select="'SN'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>-</xsl:otherwise>
          </xsl:choose>
    </bgh:cell>
    
    <bgh:cell>
        <!-- top-up action life cycle -->
        <xsl:call-template name="DataDomainLgnMap">
          <xsl:with-param name="Index"     select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                                   $top-up-action-request-subid = @TURSubId and
                                                   ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TURTLCF"/>
          <xsl:with-param name="Type"      select="'DD'"/>
          <xsl:with-param name="Desc"      select="'1'"/>
          <xsl:with-param name="ClassId"   select="'TRIGGER_LC_FLAG_CLASS'"/>
        </xsl:call-template>
    </bgh:cell>
    
    <bgh:cell>
        <!-- top-up action tariff model -->
          <xsl:choose>
            <xsl:when test="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                            $top-up-action-request-subid = @TURSubId and
                            ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUATM">
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                                     $top-up-action-request-subid = @TURSubId and
                                                     ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUATM"/>
                <xsl:with-param name="Type"  select="'TM'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>-</xsl:otherwise>
          </xsl:choose>
    </bgh:cell>
    
    <bgh:cell>
        <!-- top-up action pricing alternative -->
          <xsl:choose>
            <xsl:when test="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                            $top-up-action-request-subid = @TURSubId and
                            ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUAPA">
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                                     $top-up-action-request-subid = @TURSubId and
                                                     ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUAPA"/>
                <xsl:with-param name="Type"  select="'PA'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>-</xsl:otherwise>
          </xsl:choose>
    </bgh:cell>
    
    <bgh:cell>
        <!-- top-up action period -->
          <xsl:if test="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                        $top-up-action-request-subid = @TURSubId and
                                        ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUAFROM">
            <xsl:call-template name="date-time-format">
              <xsl:with-param name="date" select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                                  $top-up-action-request-subid = @TURSubId and
                                                  ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUAFROM"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:text> - </xsl:text>
          <xsl:if test="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                        $top-up-action-request-subid = @TURSubId and
                                        ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUATO">
            <xsl:call-template name="date-time-format">
              <xsl:with-param name="date" select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                                  $top-up-action-request-subid = @TURSubId and
                                                  ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUATO"/>
            </xsl:call-template>
          </xsl:if>
    </bgh:cell>
    
    <bgh:cell>
        <!-- top-up action active / passive period -->
          <!-- active -->
          <xsl:if test="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                        $top-up-action-request-subid = @TURSubId and
                                        ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUAAEP">
            <xsl:value-of select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                        $top-up-action-request-subid = @TURSubId and
                                        ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUAAEP"/>
            <xsl:text> </xsl:text>
            <!-- duration unit -->
            <xsl:call-template name="DataDomainLgnMap">
              <xsl:with-param name="Index"     select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                                       $top-up-action-request-subid = @TURSubId and
                                                       ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUAAEPT"/>
              <xsl:with-param name="Type"      select="'DD'"/>
              <xsl:with-param name="Desc"      select="'1'"/>
              <xsl:with-param name="ClassId"   select="'PERIOD_TYPE_CLASS'"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:text> / </xsl:text>
          <!-- passive -->
          <xsl:if test="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                        $top-up-action-request-subid = @TURSubId and
                                        ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUAPEP">
            <xsl:value-of select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                        $top-up-action-request-subid = @TURSubId and
                                        ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUAPEP"/>
            <xsl:text> </xsl:text>
            <!-- duration unit -->
            <xsl:call-template name="DataDomainLgnMap">
              <xsl:with-param name="Index"     select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                                       $top-up-action-request-subid = @TURSubId and
                                                       ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUAPEPT"/>
              <xsl:with-param name="Type"      select="'DD'"/>
              <xsl:with-param name="Desc"      select="'1'"/>
              <xsl:with-param name="ClassId"   select="'PERIOD_TYPE_CLASS'"/>
            </xsl:call-template>
          </xsl:if>
    </bgh:cell>
    
    <bgh:cell>
        <!-- top-up action amount or volume -->
          <xsl:if test="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                        $top-up-action-request-subid = @TURSubId and
                        ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUAAmt">
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                                    $top-up-action-request-subid = @TURSubId and
                                                    ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUAAmt"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>
            
            <xsl:call-template name="currency">
              <xsl:with-param name="CurrCode" select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                            $top-up-action-request-subid = @TURSubId and
                                            ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUACurr"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                        $top-up-action-request-subid = @TURSubId and
                        ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUAVOL">
            <xsl:call-template name="number-unit-format">
              <xsl:with-param name="number" select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                                    $top-up-action-request-subid = @TURSubId and
                                                    ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUAVOL"/>
              <xsl:with-param name="unit" select="$top-up-actions[$top-up-action-request = @TURid and $top-up-action-status = @TUAS and
                                                  $top-up-action-request-subid = @TURSubId and
                                                  ( $top-up-action-contract = @TUACO or $top-up-action-contract = @TURCO )]/@TUAUOM"/>
            </xsl:call-template>
          </xsl:if>
      </bgh:cell>

    </bgh:row>
    
  </xsl:template>

</xsl:stylesheet>
