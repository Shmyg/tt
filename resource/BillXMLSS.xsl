<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2012 Ericsson

  All rights reserved.

  File:    BillXMLSS.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> XMLSS stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms master documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/BillXMLSS.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

  XML Spreadsheet Reference : http://msdn.microsoft.com/en-us/library/aa140066%28office.10%29.aspx

-->

<xsl:stylesheet version="1.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:html="http://www.w3.org/TR/REC-html40" 
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" 
 xmlns:o="urn:schemas-microsoft-com:office:office" 
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 exclude-result-prefixes="xsl">

  <xsl:output method="xml" encoding="UTF-8" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="no"/>

  <xsl:strip-space elements="*"/>

  <xsl:include href="BillingDocumentXMLSS.xsl"/>

  <!-- at the moment EN and DE are supported -->
  <xsl:param name="lang"/>
  <!-- legend file -->
  <xsl:param name="lgn"/>
  <!-- document reference number -->
  <xsl:param name="drn"/>
  <!-- bill type -->
  <xsl:param name="bit"/>
  <!-- document format -->
  <xsl:param name="fmt"/>
  <!-- copy flag -->
  <xsl:param name="cflag"/>
  <!-- pricing type: N/G -->
  <xsl:param name="pricing"/>
  <!-- pricing type (prepaid): N/G -->
  <xsl:param name="pricing-prepaid"/>

  <!-- configuration files -->
  <xsl:variable name="legend" select="document($lgn)"/>
  <xsl:variable name="txt"    select="document(concat('Fixtext_',$lang,'.xml'))"/>
  <xsl:variable name="xcd"    select="document(concat('XCD_',$lang,'.xml'))"/>
  <xsl:variable name="fup"    select="document(concat('FUP_',$lang,'.xml'))"/>
  <xsl:variable name="rdd"    select="document(concat('RDD_',$lang,'.xml'))"/>
  
  <!-- mapping keys (legend, fixtext, udr-attributes) -->
  <xsl:key name="id-index"   match="TypeDesc" use="@Id"/>
  <xsl:key name="txt-index"  match="Text"     use="@Id"/>
  <xsl:key name="xcd-index"  match="XCD"      use="@Id"/>
  <xsl:key name="rdd-index"  match="RDD"      use="@Id"/>
  <xsl:key name="fup-index"  match="FUP"      use="@Id"/>
  <xsl:key name="pkey-index" match="TypeDesc" use="@PKey"/>

  <xsl:variable name="line-feed">
    <xsl:text>
</xsl:text>
  </xsl:variable>



  <!-- root -->
  <xsl:template match="/">

    <xsl:value-of select="$line-feed"/>
    <xsl:processing-instruction name="mso-application">progid="Excel.Sheet"</xsl:processing-instruction>

    <ss:Workbook>  

      <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
        <Author>M. Fehrenbacher</Author>
        <LastAuthor>M. Fehrenbacher</LastAuthor>
        <Created></Created>
        <Company>Ericsson</Company>
        <Version>1.0</Version>
      </DocumentProperties>

      <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
        <WindowHeight>6795</WindowHeight>
        <WindowWidth>8460</WindowWidth>
        <WindowTopX>120</WindowTopX>
        <WindowTopY>15</WindowTopY>
        <ProtectStructure>False</ProtectStructure>
        <ProtectWindows>False</ProtectWindows>
      </ExcelWorkbook>

      <ss:Styles>  
        <ss:Style ss:ID="Default" ss:Name="Normal">  
          <ss:Alignment ss:Vertical="Bottom" />  
          <ss:Borders />  
          <ss:Font />  
          <ss:Interior />  
          <ss:NumberFormat />  
          <ss:Protection />  
        </ss:Style>
        <ss:Style ss:ID="Right" ss:Name="Right">  
          <ss:Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/> 
          <ss:Borders />
          <ss:Font />
          <ss:Interior />
          <ss:NumberFormat />
          <ss:Protection />
        </ss:Style>
        <ss:Style ss:ID="RightC" ss:Name="RightC">  
          <ss:Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/> 
          <ss:Borders>
            <ss:Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </ss:Borders>
          <ss:Font ss:Color="#FF0000"/>
          <ss:Interior />
          <ss:NumberFormat />
          <ss:Protection />
        </ss:Style>
        <ss:Style ss:ID="Center" ss:Name="Center">  
          <ss:Alignment ss:Horizontal="Center" ss:Vertical="Center"/>  
          <ss:Borders />
          <ss:Font />
          <ss:Interior />
          <ss:NumberFormat />
          <ss:Protection />
        </ss:Style>
        <ss:Style ss:ID="CenterC" ss:Name="CenterC">  
          <ss:Alignment ss:Horizontal="Center" ss:Vertical="Center"/>  
          <ss:Borders>
            <ss:Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </ss:Borders>
          <ss:Font ss:Color="#FF0000"/>
          <ss:Interior />
          <ss:NumberFormat />
          <ss:Protection />
        </ss:Style>
        <ss:Style ss:ID="longTime">
          <ss:NumberFormat ss:Format="Long Time"/>
          <ss:Alignment ss:Horizontal="Right"/>
        </ss:Style>
        <ss:Style ss:ID="longDate">
          <ss:NumberFormat ss:Format="Long Date"/>
          <ss:Alignment ss:Horizontal="Right"/>
        </ss:Style>
        <ss:Style ss:ID="Number">
          <ss:NumberFormat ss:Format="General Number"/>
          <ss:Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
        </ss:Style>
        <ss:Style ss:ID="Percent">
          <ss:NumberFormat ss:Format="Percent"/>
          <ss:Alignment ss:Horizontal="Right" ss:Vertical="Center"/>
        </ss:Style>
        <ss:Style ss:ID="Currency">
          <ss:NumberFormat ss:Format="Currency"/>
          <ss:Alignment ss:Horizontal="Right" ss:Vertical="Center"/>
        </ss:Style>
        <ss:Style ss:ID="s10">  
          <ss:Font ss:Size="10" ss:Bold="1" />  
        </ss:Style>
        <ss:Style ss:ID="s10c">  
          <ss:Font ss:Size="10" ss:Bold="1" />
          <ss:Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
        </ss:Style>
        <ss:Style ss:ID="s10b" ss:Parent="s10">  
          <ss:Borders>
            <ss:Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
          </ss:Borders>
          <ss:Alignment ss:Horizontal="Center"/>  
        </ss:Style>
        <ss:Style ss:ID="s11">  
          <ss:Font ss:Size="11" ss:Bold="1" />
          <ss:Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
        </ss:Style>
        <ss:Style ss:ID="s12">  
          <ss:Font ss:Size="12" ss:Bold="1" />
          <ss:Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
        </ss:Style>
        <ss:Style ss:ID="s14">  
          <ss:Font ss:Size="14" ss:Bold="1" />
          <ss:Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
        </ss:Style>  
      </ss:Styles>  
  
      <!-- process the documents -->        
      <xsl:apply-templates select="Bill"/>
        
    </ss:Workbook>  
  
  </xsl:template>  

</xsl:stylesheet>