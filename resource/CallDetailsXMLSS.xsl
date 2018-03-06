<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2012 Ericsson

  All rights reserved.

  File:    CallDetailsXMLSS.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> XMLSS stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms call details.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/CallDetailsXMLSS.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

  XML Spreadsheet Reference : http://msdn.microsoft.com/en-us/library/aa140066%28office.10%29.aspx

-->

<xsl:stylesheet version="1.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:html="http://www.w3.org/TR/REC-html40" 
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" 
 xmlns:o="urn:schemas-microsoft-com:office:office" 
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:set="http://exslt.org/sets" 
 exclude-result-prefixes="xsl set">

  <!--  call details  -->
  <xsl:template name="print-call-details">

    <xsl:param name="co-id"/>
    <xsl:param name="bopind"/>
    <xsl:param name="bopseqno"/>
    <xsl:param name="boptype"/>
    <xsl:param name="call-details"/>
    <xsl:param name="period-start"/>
    <xsl:param name="period-end"/>

    <xsl:choose>

      <xsl:when test="$call-details/ContrCalls">

        <xsl:variable name="call-details-local" select="$call-details/ContrCalls[@Id=$co-id]/ServCalls/Call[XCD[@CO=$co-id
                                                        and (@BOPSeqNoRP=$bopseqno or @BOPSeqNoSP=$bopseqno or not(@BOPSeqNoRP or @BOPSeqNoSP))]]"/>
        <xsl:variable name="list-of-unique-services" select="set:distinct($call-details-local/XCD/@SN)" />

        <xsl:if test="count($list-of-unique-services) != 0">

          <ss:Row>
            <ss:Cell ss:StyleID="s12" ss:MergeAcross="18">
              <ss:Data ss:Type="String">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','459')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </ss:Data>
            </ss:Cell>
          </ss:Row>
          <ss:Row/>

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

        </xsl:if>

      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="call-details-local" select="$call-details/Call[XCD[@CO=$co-id
                                                        and (@BOPSeqNoRP=$bopseqno or @BOPSeqNoSP=$bopseqno or not(@BOPSeqNoRP or @BOPSeqNoSP))]]"/>
        <xsl:variable name="list-of-unique-services" select="set:distinct($call-details-local/XCD/@SN)" />

          <xsl:if test="count($list-of-unique-services) != 0">

            <ss:Row>
              <ss:Cell ss:StyleID="s12" ss:MergeAcross="18">
                <ss:Data ss:Type="String">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','459')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </ss:Data>
              </ss:Cell>
            </ss:Row>
            <ss:Row/>

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

        </xsl:if>
      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>

  <!-- call details grouped by services -->
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

        <xsl:variable name="current-service" select="."/>

        <ss:Row>
          <ss:Cell ss:StyleID="s11" ss:MergeAcross="18">
            <ss:Data ss:Type="String">
              <xsl:call-template name="LgnMap">
                <xsl:with-param name="Mode"  select="'0'"/>
                <xsl:with-param name="Index" select="$current-service"/>
                <xsl:with-param name="Type"  select="'SN'"/>
                <xsl:with-param name="Desc"  select="'1'"/>
              </xsl:call-template>
            </ss:Data>
          </ss:Cell>
        </ss:Row>

        <xsl:call-template name="call-item-header"/>
          
        <xsl:variable name="call-details-local" select="$call-details/XCD"/>
          
        <xsl:choose>
              
          <!-- no BOP -->
          <xsl:when test="$bopind='N'">
                
            <xsl:for-each select="$call-details-local[@SN=$current-service and @CO=$co-id]">
              <!--
              <xsl:sort select="@CTs"/>
              <xsl:sort select="@Id"/>
              <xsl:sort select="@SubId"/>
              -->
              <xsl:apply-templates select="parent::Call"/>
            </xsl:for-each>
                  
          </xsl:when>
                
          <!-- BOP -->
          <xsl:otherwise>
                  
            <!-- print call details -->
            <xsl:choose>
                  
              <xsl:when test="$boptype='TM'">

                <xsl:for-each select="$call-details-local[@SN=$current-service and @CO=$co-id
                 and (@BOPSeqNoRP=$bopseqno or not(@BOPSeqNoRP))]">
                  <!--
                  <xsl:sort select="@CTs"/>
                  <xsl:sort select="@Id"/>
                  <xsl:sort select="@SubId"/>
                  -->
                  <xsl:apply-templates select="parent::Call"/>
                </xsl:for-each>
                     
              </xsl:when>
                    
              <xsl:when test="$boptype='SP'">
                    
                <xsl:for-each select="$call-details-local[@SN=$current-service and @CO=$co-id
                 and (@BOPSeqNoSP=$bopseqno or not(@BOPSeqNoSP))]">
                  <!--
                  <xsl:sort select="@CTs"/>
                  <xsl:sort select="@Id"/>
                  <xsl:sort select="@SubId"/>
                  -->
                  <xsl:apply-templates select="parent::Call"/>
                </xsl:for-each>
                      
              </xsl:when>
                    
            </xsl:choose>
                  
          </xsl:otherwise>
                
        </xsl:choose>
      
    </xsl:for-each>
    
  </xsl:template>
  
  <xsl:template name="call-item-header">

      <ss:Row>
        <xsl:for-each select="$xcd">
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="substring(key('xcd-index','CTs')[@xml:lang=$lang]/@Des,1,4)"/>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="substring(key('xcd-index','CTs')[@xml:lang=$lang]/@Des,8,4)"/>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','PrInd')[@xml:lang=$lang]/@Des"/>  
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','CT')[@xml:lang=$lang]/@Des"/>  
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','RT')[@xml:lang=$lang]/@Des"/>    
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','RRT')[@xml:lang=$lang]/@Des"/>  
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','DRV')[@xml:lang=$lang]/@Des"/>  
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','TIDPA')[@xml:lang=$lang]/@Des"/>  
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','NI')[@xml:lang=$lang]/@Des"/>  
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','NN')[@xml:lang=$lang]/@Des"/>  
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','DES')[@xml:lang=$lang]/@Des"/>  
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','DZP')[@xml:lang=$lang]/@Des"/>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','OPN')[@xml:lang=$lang]/@Des"/>  
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','APN')[@xml:lang=$lang]/@Des"/>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','TT')[@xml:lang=$lang]/@Des"/>  
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','TZ')[@xml:lang=$lang]/@Des"/>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
               <xsl:value-of select="key('xcd-index','TM')[@xml:lang=$lang]/@Des"/>  
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
               <xsl:value-of select="key('xcd-index','SP')[@xml:lang=$lang]/@Des"/>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','DAmt')[@xml:lang=$lang]/@Des"/>  
            </ss:Data>
          </ss:Cell>
        </xsl:for-each>
      </ss:Row>

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
    
    <xsl:choose>

      <xsl:when test="$charge-details/ContrCalls">
      
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

          <ss:Row>
            <ss:Cell ss:StyleID="s12" ss:MergeAcross="18">
              <ss:Data ss:Type="String">
                <xsl:for-each select="$txt">
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
                </xsl:for-each>
              </ss:Data>
            </ss:Cell>
          </ss:Row>
                
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

          <ss:Row>
            <ss:Cell ss:StyleID="s12" ss:MergeAcross="18">
              <ss:Data ss:Type="String">
                <xsl:for-each select="$txt">
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
                </xsl:for-each>
              </ss:Data>
            </ss:Cell>
          </ss:Row>
          <ss:Row/>
        
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

  <!-- charge details grouped by services -->
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

      <ss:Row>
        <ss:Cell ss:StyleID="s11" ss:MergeAcross="18">
          <ss:Data ss:Type="String">
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="$next-service"/>
              <xsl:with-param name="Type"  select="'SN'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </ss:Data>
        </ss:Cell>
      </ss:Row>

      <xsl:call-template name="charge-item-header"/>
          
      <xsl:choose>
        <xsl:when test="$charge-details/ContrCalls">                
          <xsl:for-each select="$charge-details/ContrCalls[@Id=$co-id]/ServCalls/ChDet/XCD[@SN=$next-service and @SrvChType=$charge-type and @CO=$co-id]">
            <xsl:call-template name="ChDet">
              <xsl:with-param name="node" select="parent::ChDet"/>
              <xsl:with-param name="charge-type" select="$charge-type"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="$charge-details/ChDet">
          <xsl:for-each select="$charge-details/ChDet/XCD[@SN=$next-service and @SrvChType=$charge-type and @CO=$co-id]">
            <xsl:call-template name="ChDet">
              <xsl:with-param name="node" select="parent::ChDet"/>
              <xsl:with-param name="charge-type" select="$charge-type"/>
            </xsl:call-template>
          </xsl:for-each>            
        </xsl:when>            
        <xsl:otherwise/>            
      </xsl:choose>                    

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

  <xsl:template name="charge-item-header">

      <ss:Row>
        <xsl:for-each select="$xcd">
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="substring(key('xcd-index','CTs')[@xml:lang=$lang]/@Des,1,4)"/>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="substring(key('xcd-index','CTs')[@xml:lang=$lang]/@Des,8,4)"/>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','PrInd')[@xml:lang=$lang]/@Des"/>  
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','TM')[@xml:lang=$lang]/@Des"/>  
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','SP')[@xml:lang=$lang]/@Des"/>    
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','Numit')[@xml:lang=$lang]/@Des"/>  
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','NumDays')[@xml:lang=$lang]/@Des"/>  
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','SrvChSType')[@xml:lang=$lang]/@Des"/>  
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b" ss:MergeAcross="3">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','ChrgStartTime')[@xml:lang=$lang]/@Des"/>  
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','SrvSt')[@xml:lang=$lang]/@Des"/>  
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','MKT')[@xml:lang=$lang]/@Des"/>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','Price')[@xml:lang=$lang]/@Des"/>  
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','PRO')[@xml:lang=$lang]/@Des"/>
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b" ss:MergeAcross="1">
            <ss:Data ss:Type="String">
               <xsl:value-of select="key('xcd-index','BU')[@xml:lang=$lang]/@Des"/>  
            </ss:Data>
          </ss:Cell>
          <ss:Cell ss:StyleID="s10b">
            <ss:Data ss:Type="String">
              <xsl:value-of select="key('xcd-index','OAmt')[@xml:lang=$lang]/@Des"/>  
            </ss:Data>
          </ss:Cell>
        </xsl:for-each>
      </ss:Row>

  </xsl:template>

  <!-- charge details -->
  <xsl:template name="ChDet">

    <xsl:param name="node"/>
    <xsl:param name="charge-type"/>

    <xsl:call-template name="charge-details">
      <xsl:with-param name="node" select="$node/XCD"/>
      <xsl:with-param name="charge-type" select="$charge-type"/>
    </xsl:call-template>

  </xsl:template>

  <!-- call details -->
  <xsl:template match="Call">

    <ss:Row>
      <xsl:apply-templates select="XCD"/>
    </ss:Row>

  </xsl:template>

  <!-- attributes (see table charge_detail_info) -->
  <xsl:template match="XCD">

        <ss:Cell ss:StyleID="longDate">
          <ss:Data ss:Type="DateTime">
            <xsl:call-template name="date-time-format">
              <xsl:with-param name="date" select="@CTs"/>
            </xsl:call-template>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="longTime">
          <ss:Data ss:Type="DateTime">
            <xsl:call-template name="date-time-format">
              <xsl:with-param name="date" select="@CTs"/>
            </xsl:call-template>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Center">
          <ss:Data ss:Type="String">
            <xsl:call-template name="DataDomainLgnMap">
              <xsl:with-param name="Index"     select="@PrInd"/>
              <xsl:with-param name="Type"      select="'DD'"/>
              <xsl:with-param name="Desc"      select="'1'"/>
              <xsl:with-param name="ClassId"   select="'YES/NO_BOOLEAN_INDICATOR'"/>
            </xsl:call-template>            
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Center">
          <ss:Data ss:Type="String">
          <xsl:call-template name="DataDomainLgnMap">
            <xsl:with-param name="Index"     select="@CT"/>
            <xsl:with-param name="Type"      select="'DD'"/>
            <xsl:with-param name="Desc"      select="'1'"/>
            <xsl:with-param name="ClassId"   select="'CALL_TYPE_CLASS'"/>
          </xsl:call-template>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Center">
          <ss:Data ss:Type="String">
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="@RT"/>
              <xsl:with-param name="Type"  select="'RT'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Center">
          <ss:Data ss:Type="String">
            <xsl:call-template name="DataDomainLgnMap">
              <xsl:with-param name="Index"     select="@RRT"/>
              <xsl:with-param name="Type"      select="'DD'"/>
              <xsl:with-param name="Desc"      select="'1'"/>
              <xsl:with-param name="ClassId"   select="'RERATE_RECORD_TYPE_CLASS'"/>
            </xsl:call-template>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Right">
          <ss:Data ss:Type="String">
            <xsl:call-template name="number-unit-format">
              <xsl:with-param name="number" select="@ORV"/>
              <xsl:with-param name="unit" select="@UM"/>
            </xsl:call-template>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Center">
          <ss:Data ss:Type="String">
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="@TIDPA"/>
            <xsl:with-param name="Type"  select="'PA'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Center">
          <ss:Data ss:Type="String">
          <xsl:call-template name="DataDomainLgnMap">
            <xsl:with-param name="Index"     select="@NI"/>
            <xsl:with-param name="Type"      select="'DD'"/>
            <xsl:with-param name="Desc"      select="'1'"/>
            <xsl:with-param name="ClassId"   select="'XFILE_IND_CLASS'"/>
          </xsl:call-template>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Center">
          <ss:Data ss:Type="String">
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="@NN"/>
              <xsl:with-param name="Type"  select="'PL'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Center">
          <ss:Data ss:Type="String">
            <xsl:call-template name="DataDomainLgnMap">
              <xsl:with-param name="Index"     select="@DES"/>
              <xsl:with-param name="Type"      select="'DD'"/>
              <xsl:with-param name="Desc"      select="'1'"/>
              <xsl:with-param name="ClassId"   select="'CALL_DEST_CLASS'"/>
            </xsl:call-template>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Center">
          <ss:Data ss:Type="String">
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="@DZP"/>
              <xsl:with-param name="Type"  select="'ZD'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Center">
          <ss:Data ss:Type="String">
            <xsl:value-of select="@OPN"/>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Center">
          <ss:Data ss:Type="String">
            <xsl:value-of select="@APN"/>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Center">
          <ss:Data ss:Type="String">
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="@TT"/>
            <xsl:with-param name="Type"  select="'TT'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>           
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Center">
          <ss:Data ss:Type="String">
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="@TZ"/>
            <xsl:with-param name="Type"  select="'TZ'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>           
          </ss:Data>
        </ss:Cell>

        <xsl:choose>
          <xsl:when test="@BOPTM or @BOPSP">
            <ss:Cell ss:StyleID="Center">
              <ss:Data ss:Type="String">
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="@BOPTM"/>
                  <xsl:with-param name="Type"  select="'TM'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </ss:Data>
            </ss:Cell>
            <ss:Cell ss:StyleID="Center">
              <ss:Data ss:Type="String">
                <!-- service package -->
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="@BOPSP"/>
                  <xsl:with-param name="Type"  select="'SP'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </ss:Data>
            </ss:Cell>
          </xsl:when>
          <xsl:otherwise>
            <ss:Cell ss:StyleID="Center">
              <ss:Data ss:Type="String">
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="@TM"/>
                  <xsl:with-param name="Type"  select="'TM'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </ss:Data>
            </ss:Cell>
            <ss:Cell ss:StyleID="Center">
              <ss:Data ss:Type="String">
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="@SP"/>
                  <xsl:with-param name="Type"  select="'SP'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </ss:Data>
            </ss:Cell>
          </xsl:otherwise>
        </xsl:choose>

        <ss:Cell ss:StyleID="Right">
          <ss:Data ss:Type="String">
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="@DAmt"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>            
            <xsl:value-of select="@CC"/>
          </ss:Data>
        </ss:Cell>            

  </xsl:template>

  <!-- attributes (see table charge_detail_info) -->
  <xsl:template name="charge-details">

    <xsl:param name="node"/>
    <xsl:param name="charge-type"/>

      <ss:Row>

        <ss:Cell ss:StyleID="longDate">
          <ss:Data ss:Type="DateTime">
            <xsl:call-template name="date-time-format">
              <xsl:with-param name="date" select="$node/@CTs"/>
            </xsl:call-template>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="longTime">
          <ss:Data ss:Type="DateTime">
            <xsl:call-template name="date-time-format">
              <xsl:with-param name="date" select="$node/@CTs"/>
            </xsl:call-template>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Center">
          <ss:Data ss:Type="String">
            <xsl:call-template name="DataDomainLgnMap">
              <xsl:with-param name="Index"     select="$node/@PrInd"/>
              <xsl:with-param name="Type"      select="'DD'"/>
              <xsl:with-param name="Desc"      select="'1'"/>
              <xsl:with-param name="ClassId"   select="'YES/NO_BOOLEAN_INDICATOR'"/>
            </xsl:call-template>            
          </ss:Data>
        </ss:Cell>

        <xsl:choose>
          <xsl:when test="$node/@BOPTM or $node/@BOPSP">
            <ss:Cell ss:StyleID="Center">
              <ss:Data ss:Type="String">
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="$node/@BOPTM"/>
                  <xsl:with-param name="Type"  select="'TM'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </ss:Data>
            </ss:Cell>
            <ss:Cell ss:StyleID="Center">
              <ss:Data ss:Type="String">
                <!-- service package -->
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="$node/@BOPSP"/>
                  <xsl:with-param name="Type"  select="'SP'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </ss:Data>
            </ss:Cell>
          </xsl:when>
          <xsl:otherwise>
            <ss:Cell ss:StyleID="Center">
              <ss:Data ss:Type="String">
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="$node/@TM"/>
                  <xsl:with-param name="Type"  select="'TM'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </ss:Data>
            </ss:Cell>
            <ss:Cell ss:StyleID="Center">
              <ss:Data ss:Type="String">
                <xsl:call-template name="LgnMap">
                  <xsl:with-param name="Mode"  select="'0'"/>
                  <xsl:with-param name="Index" select="$node/@SP"/>
                  <xsl:with-param name="Type"  select="'SP'"/>
                  <xsl:with-param name="Desc"  select="'1'"/>
                </xsl:call-template>
              </ss:Data>
            </ss:Cell>
          </xsl:otherwise>
        </xsl:choose>

        <ss:Cell ss:StyleID="Center">
          <ss:Data ss:Type="String">
            <xsl:value-of select="$node/@Numit"/> 
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Center">
          <ss:Data ss:Type="String">
            <xsl:value-of select="$node/@NumDays"/> 
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Center">
          <ss:Data ss:Type="String">
            <xsl:call-template name="DataDomainLgnMap">
              <xsl:with-param name="Index"     select="$node/@SrvChSType"/>
              <xsl:with-param name="Type"      select="'DD'"/>
              <xsl:with-param name="Desc"      select="'1'"/>
              <xsl:with-param name="ClassId"   select="'CHARGE_SUBTYPE_CLASS'"/>
            </xsl:call-template>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="longDate">
          <ss:Data ss:Type="DateTime">
            <xsl:call-template name="date-time-format">
              <xsl:with-param name="date" select="$node/@ChrgStartTime"/>
            </xsl:call-template>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="longTime">
          <ss:Data ss:Type="DateTime">
            <xsl:call-template name="date-time-format">
              <xsl:with-param name="date" select="$node/@ChrgStartTime"/>
            </xsl:call-template>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="longDate">
          <ss:Data ss:Type="DateTime">
            <xsl:call-template name="date-time-format">
              <xsl:with-param name="date" select="$node/@ChrgEndTime"/>
            </xsl:call-template>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="longTime">
          <ss:Data ss:Type="DateTime">
            <xsl:call-template name="date-time-format">
              <xsl:with-param name="date" select="$node/@ChrgEndTime"/>
            </xsl:call-template>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Center">
          <ss:Data ss:Type="String">
            <xsl:value-of select="$node/@SrvSt"/>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Center">
          <ss:Data ss:Type="String">
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="$node/@MKT"/>
              <xsl:with-param name="Type"  select="'MRKT'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Center">
          <ss:Data ss:Type="String">
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="$node/@Price"/>
            </xsl:call-template>        
            <xsl:text> </xsl:text>
            <xsl:value-of select="$node/@PriceCurr"/>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Center">
          <ss:Data ss:Type="String">
            <xsl:call-template name="LgnMap">
              <xsl:with-param name="Mode"  select="'0'"/>
              <xsl:with-param name="Index" select="$node/@PRO"/>
              <xsl:with-param name="Type"  select="'PRO'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Center" ss:MergeAcross="1">
          <ss:Data ss:Type="String">
          <xsl:call-template name="LgnMap">
            <xsl:with-param name="Mode"  select="'0'"/>
            <xsl:with-param name="Index" select="$node/@BU"/>
            <xsl:with-param name="Type"  select="'BU'"/>
            <xsl:with-param name="Desc"  select="'1'"/>
          </xsl:call-template>           
          </ss:Data>
        </ss:Cell>

        <ss:Cell ss:StyleID="Right">
          <ss:Data ss:Type="String">
            <xsl:call-template name="number-format">
              <xsl:with-param name="number" select="$node/@OAmt"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>            
            <xsl:value-of select="@CC"/>
          </ss:Data>
        </ss:Cell>

      </ss:Row>

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
