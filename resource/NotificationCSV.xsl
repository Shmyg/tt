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

  File:    NotificationFO.xsl

  Owner:   Matthias Fehrenbacher
           Natalie Kather

  @(#) ABSTRACT : XML -> CSV stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms charge notification messages.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/NotificationCSV.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bgh="http://www.lhsgroup.com/BSCS/BGH" xmlns:cur="http://www.unece.org/etrades/unedocs" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="xsl cur set bgh">

  <xsl:variable name="charge-details" select="document(/Bill/Part/@File)/Document/ChargeNotification"/>

  
  <!-- charge notification -->
  <xsl:template match="ChargeNotification">

    <xsl:variable name="co-id" select="@CoId"/>

    <!-- receiver address header -->
    <xsl:apply-templates select="Addr" />
      
    
      <!-- MSISDN -->
      <xsl:if test="Addr/@MSISDN and string-length(Addr/@MSISDN) > 0">
        <bgh:row>
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','485')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <xsl:value-of select="Addr/@MSISDN"/>
            </bgh:cell>
        </bgh:row>
      </xsl:if>
    
    
      <!-- email -->
      <xsl:if test="Addr/@Email and string-length(Addr/@Email) > 0">
        <bgh:row>
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','486')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
        <xsl:value-of select="Addr/@Email"/>
            </bgh:cell>
        </bgh:row>
      </xsl:if>

    <bgh:row/>
    
    <bgh:row>
        <bgh:cell>
              <!-- kind of message -->
              <xsl:choose>
                <!-- advance notification -->
                <xsl:when test="@Type='NOTADV'">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','468')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </xsl:when>
                <!-- insufficient credit -->
                <xsl:when test="@Type='NOTICR'">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','469')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </xsl:when>
                <!-- charge booked -->
                <xsl:when test="@Type='NOTCHB'">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','470')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </xsl:when>
                <!-- overdraft clearance -->
                <xsl:when test="@Type='NOTOCP'">
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','471')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </xsl:when>
                <!-- unknown short message -->
                <xsl:otherwise>
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','472')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
        </bgh:cell>
    </bgh:row>     
    
    <!-- contract -->
    <xsl:if test="@CoId">
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','109')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <xsl:value-of select="@CoId"/>
            </bgh:cell>
        </bgh:row>      
    </xsl:if>
    
    <!-- remaining credit -->
    <xsl:if test="Charge">
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','175')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <xsl:variable name="number-format">
                  <xsl:call-template name="number-format">
                    <xsl:with-param name="number" select="Charge/@Amount"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$number-format"/>
                <xsl:text> </xsl:text>
                <xsl:call-template name="currency">
                    <xsl:with-param name="CurrCode" select="Charge/@CurrCode"/>
                </xsl:call-template>
            </bgh:cell>
        </bgh:row>
    </xsl:if>
    
    <bgh:row/>
    
    <!-- balance snapshots -->
    <xsl:if test="BalSsh">
      
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                  <xsl:for-each select="$txt"><!-- Balance Snapshots -->
                    <xsl:value-of select="key('txt-index','167')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
        </bgh:row>
      
        <bgh:row>
            <bgh:cell/>
            <bgh:cell/>
            <xsl:for-each select="$txt">
                <bgh:cell>
                    <!-- snapshot date -->
                    <xsl:value-of select="key('txt-index','168')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- service -->
                    <xsl:value-of select="key('txt-index','170')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- bundle product -->
                    <xsl:value-of select="key('txt-index','445')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- used volume -->
                    <xsl:value-of select="key('txt-index','173')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- used credit -->
                    <xsl:value-of select="key('txt-index','174')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- remaining credit -->
                    <xsl:value-of select="key('txt-index','175')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
            </xsl:for-each>
              
        </bgh:row>

        <xsl:for-each select="BalSsh">
            <xsl:apply-templates select="."/>
        </xsl:for-each>
        
        <bgh:row/>
          
    </xsl:if>
    
    <!-- action -->
    <xsl:if test="Action">
     
        <bgh:row>
            <bgh:cell/>
            <bgh:cell>
                  <xsl:for-each select="$txt"><!-- Actions -->
                    <xsl:value-of select="key('txt-index','473')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
            </bgh:cell>
        </bgh:row>
                
        <bgh:row>
            <bgh:cell/>
            <bgh:cell/>
            <xsl:for-each select="$txt">
                <bgh:cell>
                    <!-- event -->
                    <xsl:value-of select="key('txt-index','474')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- service -->
                    <xsl:value-of select="key('txt-index','475')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- profile -->
                    <xsl:value-of select="key('txt-index','476')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
                <bgh:cell>
                    <!-- type -->
                    <xsl:value-of select="key('txt-index','477')[@xml:lang=$lang]/@Des"/>
                </bgh:cell>
            </xsl:for-each>
              
        </bgh:row>
        
            <xsl:for-each select="Action">
                <xsl:apply-templates select="."/>
            </xsl:for-each>
        
        <bgh:row />
      
    </xsl:if>

    <!-- charge details (the BOP info is not given here !) -->
    <xsl:if test="ChDet">
    
      <!-- recurring charge details info -->
      <xsl:call-template name="print-charge-details">
        <xsl:with-param name="co-id" select="$co-id"/>
        <xsl:with-param name="bopind" select="'N'"/>
        <xsl:with-param name="bopseqno" select="''"/>
        <xsl:with-param name="boptype" select="''"/>
        <xsl:with-param name="charge-details" select="$charge-details"/>
        <xsl:with-param name="charge-type" select="'A'"/>
      </xsl:call-template>
      
      <!-- one-time charge details info -->
      <xsl:call-template name="print-charge-details">
        <xsl:with-param name="co-id" select="$co-id"/>
        <xsl:with-param name="bopind" select="'N'"/>
        <xsl:with-param name="bopseqno" select="''"/>
        <xsl:with-param name="boptype" select="''"/>
        <xsl:with-param name="charge-details" select="$charge-details"/>
        <xsl:with-param name="charge-type" select="'S'"/>
      </xsl:call-template>
      
    </xsl:if>

  </xsl:template>


  <!-- action -->
  <xsl:template match="Action">

    <bgh:row>
        <bgh:cell/>
        <bgh:cell/>
        <bgh:cell>
            <!-- event -->
            <xsl:choose>
              <!-- gmd action id (only one)-->
              <xsl:when test="@Id='8'">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','481')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>-</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
        </bgh:cell>
        <bgh:cell>
            <!-- service -->
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
              <xsl:with-param name="Index" select="@PRO"/>
              <xsl:with-param name="Type"  select="'PRO'"/>
              <xsl:with-param name="Desc"  select="'1'"/>
            </xsl:call-template>
        </bgh:cell>
        <bgh:cell>
            <!-- type -->
            <!-- kind of message -->
            <xsl:choose>
              <!-- activation -->
              <xsl:when test="@Action='A'">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','478')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </xsl:when>
              <!-- deactivation -->
              <xsl:when test="@Action='D'">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','479')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </xsl:when>
              <!-- suspension -->
              <xsl:when test="@Action='S'">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','480')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
              </xsl:when>
              <!-- unknown action -->
              <xsl:otherwise>
                <xsl:value-of select="@Action"/>
              </xsl:otherwise>
            </xsl:choose>
        </bgh:cell>
    </bgh:row>

  </xsl:template>

</xsl:stylesheet>
