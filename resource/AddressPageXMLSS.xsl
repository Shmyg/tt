<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2012 Ericsson
 
  All rights reserved.

  File:    AddressPageXMLSS.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> XMLSS stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms address documents.
  VERSION = %VI%

  XML Spreadsheet Reference : http://msdn.microsoft.com/en-us/library/aa140066%28office.10%29.aspx

-->

<xsl:stylesheet version="1.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:html="http://www.w3.org/TR/REC-html40" 
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" 
 xmlns:o="urn:schemas-microsoft-com:office:office" 
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 exclude-result-prefixes="xsl">

  <!-- billing account -->
  <xsl:template match="BillAcc">

      <ss:Row>
        <ss:Cell ss:StyleID="s10">
          <!-- sender address -->
          <ss:Data ss:Type="String"><xsl:value-of select="normalize-space(concat(../InvParty/Addr/@Name ,' ',
                                                                                 ../InvParty/Addr/@Line1,' ',../InvParty/Addr/@Line2,' ',
                                                                                 ../InvParty/Addr/@Line3,' ',../InvParty/Addr/@Line4,' ',
                                                                                 ../InvParty/Addr/@Line5,' ',../InvParty/Addr/@Line6,' ',
                                                                                 ../InvParty/Addr/@Zip  ,' ',../InvParty/Addr/@City ,' ',
                                                                                 ../InvParty/Addr/@Country))"/> 
          </ss:Data>
        </ss:Cell>
      </ss:Row>
      <ss:Row/>
      <ss:Row>
        <!-- receiver address -->
        <ss:Cell>
          <ss:Data ss:Type="String">
            <xsl:value-of select="normalize-space(concat(Addr/@Name,' ',Addr/@Line1))"/>
          </ss:Data>
        </ss:Cell>
        <ss:Cell ss:MergeAcross="5"/>
         <ss:Cell  ss:StyleID="s10">
          <!-- document reference number -->
          <ss:Data ss:Type="String">
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','327')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
          </ss:Data>
        </ss:Cell>
        <ss:Cell ss:StyleID="Right">
          <ss:Data ss:Type="String">
                <xsl:value-of select="$drn"/>
          </ss:Data>
        </ss:Cell>
      </ss:Row>
      <ss:Row>
        <!-- receiver address -->
        <ss:Cell>
          <ss:Data ss:Type="String">
            <xsl:value-of select="normalize-space(concat(Addr/@Line2,' ',Addr/@Line3))"/>
          </ss:Data>
        </ss:Cell>
        <ss:Cell ss:MergeAcross="5"/>
        <ss:Cell ss:StyleID="s10">
          <!-- billing account -->
          <ss:Data ss:Type="String">               
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','306')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
          </ss:Data>
        </ss:Cell>
        <ss:Cell ss:StyleID="Right">
          <ss:Data ss:Type="String">
                <xsl:value-of select="@Desc"/>
          </ss:Data>
        </ss:Cell>
      </ss:Row>
      <ss:Row>
        <!-- receiver address -->
        <ss:Cell>
          <ss:Data ss:Type="String">
            <xsl:value-of select="normalize-space(concat(Addr/@Line4,' ',Addr/@Line5))"/>
          </ss:Data>
        </ss:Cell>
        <ss:Cell ss:MergeAcross="5"/>
        <ss:Cell/>
        <ss:Cell ss:StyleID="Right">
          <!-- pkey -->                          
          <ss:Data ss:Type="String">
                <xsl:value-of select="../../@BAId"/>
          </ss:Data>
        </ss:Cell>
      </ss:Row>
      <ss:Row>
        <!-- receiver address -->
        <ss:Cell>
          <ss:Data ss:Type="String">
            <xsl:value-of select="Addr/@Line6"/>
          </ss:Data>
        </ss:Cell>
        <ss:Cell ss:MergeAcross="5"/>
        <ss:Cell ss:StyleID="s10">
          <!-- customer code -->
          <ss:Data ss:Type="String">               
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','15')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
          </ss:Data>
        </ss:Cell>
        <ss:Cell ss:StyleID="Right">
          <ss:Data ss:Type="String">
                <xsl:value-of select="Customer/@Id"/>
          </ss:Data>
        </ss:Cell>
      </ss:Row>
      <ss:Row>
        <!-- receiver address -->
        <ss:Cell>
          <ss:Data ss:Type="String">
            <xsl:value-of select="Addr/@Zip"/>
            <xsl:choose>
              <xsl:when test="@City">
                <xsl:value-of select="concat(' ',Addr/@City)"/>
              </xsl:when>
              <xsl:otherwise/>
            </xsl:choose>
          </ss:Data>
        </ss:Cell>
      </ss:Row>
      <ss:Row>
        <ss:Cell>
          <ss:Data ss:Type="String">
            <xsl:value-of select="Addr/@Country"/>
          </ss:Data>
        </ss:Cell>
    </ss:Row>
           
  </xsl:template>

</xsl:stylesheet>