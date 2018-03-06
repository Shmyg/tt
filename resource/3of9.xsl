<?xml version="1.0" encoding="iso-8859-1"?>

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
  
  File:    3of9.xsl
  
  Owner:  M. Fehrenbacher
  
  @(#) ABSTRACT : XML -> SVG stylesheet
  @(#) BSCS iX R4, Bill Formatting Server
  
  This stylesheet draws type 3of9 / 3of9 extended barcodes.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/3of9.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

  Author: Alexander Peshkov <peshkov@renderx.com> (c) 2003, RenderX

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:my="http://www.39-data.org">

<!-- ========================================================= -->
<!-- This stylesheet contains two named templates:             --> 
<!-- barcode-3of9 and barcode-3of9-extended aimed to encode    -->
<!-- sequence of character using 3-of-9 barcode scheme (also   -->
<!-- known as code 39). Both templates have the same set of    -->
<!-- parameters (described below) and can generate optional    -->
<!-- checksum character. However second template produce       -->
<!-- extended Barcode 39 (full-ASCII) and thus treats supplied -->
<!-- data in a different way.                                  -->
<!--                                                           -->
<!--                     Mandatory parameters are:             -->
<!--                                                           -->
<!--  "value"           - a string of characters to encode;    -->
<!--                      details on 'value' data treatment    -->
<!--                      are presented below.                 -->
<!--                                                           -->
<!--                      Optional parameters are:             -->
<!--                                                           -->
<!--  "string"          - a human readable string;             -->
<!--                      represents data encoded in           -->
<!--                      the barcode in a human-readable form -->
<!--                      Optional parameter.                  -->
<!--                      Default is: 'value' with start/stop  -->
<!--                      and checksum added when necessary.   -->
<!--  "print-text"      - boolean, defines if a human          -->
<!--                      readable label should be printed.    -->
<!--                      Default is: 'true'.                  -->
<!--  "addchecksum"     - boolean, defines if checksum should  -->
<!--                      be added by the barcode generator;   -->
<!--                      Default is 'false'                   -->
<!--  "module"          - width of the elementary unit         -->
<!--                      bar/space;                           -->
<!--                      Default is 0.012in                   -->
<!--  "wide-to-narrow"  - width ratio for bars/spaces;         -->
<!--                      Default is 3.0                       -->
<!--  "height"          - pattern height (= bar length).       -->
<!--                      Default is 0.5in                     -->
<!--  "quiet-horizontal" - quiet zone horizontal margin width  -->
<!--                      Default is 0.24in                    -->
<!--  "quiet-vertical"   - quiet zone vertical margin width    -->
<!--                      Default is 0.12in                    -->
<!--  "font-family"     - a font family used to print textual  -->
<!--                      representation of a barcode.         -->
<!--                      Default is 'Courier'                 -->
<!--  "font-height"     - a height of the font used to print   -->
<!--                      textual representation of a barcode. -->
<!--                      Default is 10pt                      -->
<!-- Alphabet of standart Barcode 3 of 9  includes only        -->
<!-- capital latin letters, digits and several punctuation     -->
<!-- symbols. When 'barcode-39' template  is used only those   -->
<!-- characters considered as a valid input.                   -->
<!-- Extended code 3 of 9 can encode full ASCII table.         -->
<!-- When 'barcode-3of9-extended' template is used, data found -->
<!-- in the 'value' field is treated as follows:               -->
<!-- whole standard code 39 character set can be used as it is -->
<!-- except for percent sign. All other ASCII characters       -->
<!-- including '%' should be encoded using URL encoding:       -->
<!-- percent sign followed be two hexadecimal digits.          -->
<!-- Examples:                                                 -->
<!-- %0A - Line Feed;                                          -->
<!-- %78 - lowercase 'x';                                      -->
<!-- %25 - percent sign.                                       -->
<!--                                                           -->
<!-- Notes:                                                    -->  
<!-- 1. It's an error if '%' is not followed by two hex digits.-->
<!--    In this case warning will be issued, percent sign will -->
<!--    be treated as itself and following data will be        -->
<!--    encoded as if there was no '%'.                        -->
<!-- 2. You can pass any characters present in standard code 39-->
<!--    charset in a URL-encoded form, they will be decoded    -->
<!--    in the same way as if passed be itselfs.               -->
<!-- 3. In standard code 3 of 9 asterisks are reserved for     -->
<!--    start/stop signals and thus cannot be present in a     -->
<!--    'value' data.                                          -->
<!-- ========================================================= -->

    <xsl:import href="3of9-svg.xsl"/>
    
    <xsl:variable name="alphabet" select="'0123456789QWERTYUIOPASDFGHJKLZXCVBNM-.$/%+'"/>

    <!-- Code tables defined in the standard -->
    <my:char2bar>
      <entry char="1">100100001</entry>
      <entry char="2">001100001</entry>
      <entry char="3">101100000</entry>
      <entry char="4">000110001</entry>
      <entry char="5">100110000</entry>
      <entry char="6">001110000</entry>
      <entry char="7">000100101</entry>
      <entry char="8">100100100</entry>
      <entry char="9">001100100</entry>
      <entry char="0">000110100</entry>
      <entry char="A">100001001</entry>
      <entry char="B">001001001</entry>
      <entry char="C">101001000</entry>
      <entry char="D">000011001</entry>
      <entry char="E">100011000</entry>
      <entry char="F">001011000</entry>
      <entry char="G">000001101</entry>
      <entry char="H">100001100</entry>
      <entry char="I">001001100</entry>
      <entry char="J">000011100</entry>
      <entry char="K">100000011</entry>
      <entry char="L">001000011</entry>
      <entry char="M">101000010</entry>
      <entry char="N">000010011</entry>
      <entry char="O">100010010</entry>
      <entry char="P">001010010</entry>
      <entry char="Q">000000111</entry>
      <entry char="R">100000110</entry>
      <entry char="S">001000110</entry>
      <entry char="T">000010110</entry>
      <entry char="U">110000001</entry>
      <entry char="V">011000001</entry>
      <entry char="W">111000000</entry>
      <entry char="X">010010001</entry>
      <entry char="Y">110010000</entry>
      <entry char="Z">011010000</entry>
      <entry char="-">010000101</entry>
      <entry char="&#183;">110000100</entry>
      <entry char=" ">011000100</entry>
      <entry char="*">010010100</entry>
      <entry char="$">010101000</entry>
      <entry char="/">010100010</entry>
      <entry char="+">010001010</entry>
      <entry char="%">000101010</entry>
    </my:char2bar>  
  
    <my:char2num>
      <entry char="0">0</entry>
      <entry char="1">1</entry>
      <entry char="2">2</entry>
      <entry char="3">3</entry>
      <entry char="4">4</entry>
      <entry char="5">5</entry>
      <entry char="6">6</entry>
      <entry char="7">7</entry>
      <entry char="8">8</entry>
      <entry char="9">9</entry>
      <entry char="A">10</entry>
      <entry char="B">11</entry>
      <entry char="C">12</entry>
      <entry char="D">13</entry>
      <entry char="E">14</entry>
      <entry char="F">15</entry>
      <entry char="G">16</entry>
      <entry char="H">17</entry>
      <entry char="I">18</entry>
      <entry char="J">19</entry>
      <entry char="K">20</entry>
      <entry char="L">21</entry>
      <entry char="M">22</entry>
      <entry char="N">23</entry>
      <entry char="O">24</entry>
      <entry char="P">25</entry>
      <entry char="Q">26</entry>
      <entry char="R">27</entry>
      <entry char="S">28</entry>
      <entry char="T">29</entry>
      <entry char="U">30</entry>
      <entry char="V">31</entry>
      <entry char="W">32</entry>
      <entry char="X">33</entry>
      <entry char="Y">34</entry>
      <entry char="Z">35</entry>
      <entry char="-">36</entry>
      <entry char="&#183;">37</entry>
      <entry char=" ">38</entry>
      <entry char="$">39</entry>
      <entry char="/">40</entry>
      <entry char="+">41</entry>
      <entry char="%">42</entry>
    </my:char2num>
  
    <my:num2char>
      <entry num="0">0</entry>
      <entry num="1">1</entry>
      <entry num="2">2</entry>
      <entry num="3">3</entry>
      <entry num="4">4</entry>
      <entry num="5">5</entry>
      <entry num="6">6</entry>
      <entry num="7">7</entry>
      <entry num="8">8</entry>
      <entry num="9">9</entry>
      <entry num="10">A</entry>
      <entry num="11">B</entry>
      <entry num="12">C</entry>
      <entry num="13">D</entry>
      <entry num="14">E</entry>
      <entry num="15">F</entry>
      <entry num="16">G</entry>
      <entry num="17">H</entry>
      <entry num="18">I</entry>
      <entry num="19">J</entry>
      <entry num="20">K</entry>
      <entry num="21">L</entry>
      <entry num="22">M</entry>
      <entry num="23">N</entry>
      <entry num="24">O</entry>
      <entry num="25">P</entry>
      <entry num="26">Q</entry>
      <entry num="27">R</entry>
      <entry num="28">S</entry>
      <entry num="29">T</entry>
      <entry num="30">U</entry>
      <entry num="31">V</entry>
      <entry num="32">W</entry>
      <entry num="33">X</entry>
      <entry num="34">Y</entry>
      <entry num="35">Z</entry>
      <entry num="36">-</entry>
      <entry num="37">&#183;</entry>
      <entry num="38"> </entry>
      <entry num="39">$</entry>
      <entry num="40">/</entry>
      <entry num="41">+</entry>
      <entry num="42">%</entry>
    </my:num2char>
  
    <my:code2char>
      <entry code="00">%U</entry>
      <entry code="01">$A</entry>
      <entry code="02">$B</entry>
      <entry code="03">$C</entry>
      <entry code="04">$D</entry>
      <entry code="05">$E</entry>
      <entry code="06">$F</entry>
      <entry code="07">$G</entry>
      <entry code="08">$H</entry>
      <entry code="09">$I</entry>
      <entry code="0A">$J</entry>
      <entry code="0B">$K</entry>
      <entry code="0C">$L</entry>
      <entry code="0D">$M</entry>
      <entry code="0E">$N</entry>
      <entry code="0F">$O</entry>
      <entry code="10">$P</entry>
      <entry code="11">$Q</entry>
      <entry code="12">$R</entry>
      <entry code="13">$S</entry>
      <entry code="06">$T</entry>
      <entry code="15">$U</entry>
      <entry code="16">$V</entry>
      <entry code="17">$W</entry>
      <entry code="18">$X</entry>
      <entry code="19">$Y</entry>
      <entry code="1A">$Z</entry>
      <entry code="1B">%A</entry>
      <entry code="1C">%B</entry>
      <entry code="1D">%C</entry>
      <entry code="1E">%D</entry>
      <entry code="1F">%E</entry>
      <entry code="20"> </entry>
      <entry code="21">/A</entry>
      <entry code="22">/B</entry>
      <entry code="23">/C</entry>
      <entry code="24">/D</entry>
      <entry code="25">/E</entry>
      <entry code="26">/F</entry>
      <entry code="27">/G</entry>
      <entry code="28">/H</entry>
      <entry code="29">/I</entry>
      <entry code="2A">/J</entry>
      <entry code="2B">/K</entry>
      <entry code="2C">/L</entry>
      <entry code="2D">-</entry>
      <entry code="2E">.</entry>
      <entry code="2F">/O</entry>
      <entry code="30">0</entry>
      <entry code="31">1</entry>
      <entry code="32">2</entry>
      <entry code="33">3</entry>
      <entry code="34">4</entry>
      <entry code="35">5</entry>
      <entry code="36">6</entry>
      <entry code="37">7</entry>
      <entry code="38">8</entry>
      <entry code="39">9</entry>
      <entry code="3A">/Z</entry>
      <entry code="3B">%F</entry>
      <entry code="3C">%G</entry>
      <entry code="3D">%H</entry>
      <entry code="3E">%I</entry>
      <entry code="3F">%J</entry>
      <entry code="40">%V</entry>
      <entry code="41">A</entry>
      <entry code="42">B</entry>
      <entry code="43">C</entry>
      <entry code="44">D</entry>
      <entry code="45">E</entry>
      <entry code="46">F</entry>
      <entry code="47">G</entry>
      <entry code="48">H</entry>
      <entry code="49">I</entry>
      <entry code="4A">J</entry>
      <entry code="4B">K</entry>
      <entry code="4C">L</entry>
      <entry code="4D">M</entry>
      <entry code="4E">N</entry>
      <entry code="4F">O</entry>
      <entry code="50">P</entry>
      <entry code="51">Q</entry>
      <entry code="52">R</entry>
      <entry code="53">S</entry>
      <entry code="54">T</entry>
      <entry code="55">U</entry>
      <entry code="56">V</entry>
      <entry code="57">W</entry>
      <entry code="58">X</entry>
      <entry code="59">Y</entry>
      <entry code="5A">Z</entry>
      <entry code="5B">%K</entry>
      <entry code="5C">%L</entry>
      <entry code="5D">%M</entry>
      <entry code="5E">%N</entry>
      <entry code="5F">%O</entry>
      <entry code="60">%W</entry>
      <entry code="61">+A</entry>
      <entry code="62">+B</entry>
      <entry code="63">+C</entry>
      <entry code="64">+D</entry>
      <entry code="65">+E</entry>
      <entry code="66">+F</entry>
      <entry code="67">+G</entry>
      <entry code="68">+H</entry>
      <entry code="69">+I</entry>
      <entry code="6A">+J</entry>
      <entry code="6B">+K</entry>
      <entry code="6C">+L</entry>
      <entry code="6D">+M</entry>
      <entry code="6E">+N</entry>
      <entry code="6F">+O</entry>
      <entry code="70">+P</entry>
      <entry code="71">+Q</entry>
      <entry code="72">+R</entry>
      <entry code="73">+S</entry>
      <entry code="74">+T</entry>
      <entry code="75">+U</entry>
      <entry code="76">+V</entry>
      <entry code="77">+W</entry>
      <entry code="78">+X</entry>
      <entry code="79">+Y</entry>
      <entry code="7A">+Z</entry>
      <entry code="7B">%P</entry>
      <entry code="7C">%Q</entry>
      <entry code="7D">%R</entry>
      <entry code="7E">%S</entry>
      <entry code="7F">%T</entry>
    </my:code2char>

    <!-- Main template used to create a standard barcode 3 of 9 -->
    <xsl:template name="barcode-3of9">
      <xsl:param name="value"/>
      <xsl:param name="string"/>
      <xsl:param name="print-text" select="'true'"/>
      <xsl:param name="addchecksum" select="'false'"/>
      <xsl:param name="module" select="'0.0075in'"/>
      <xsl:param name="wide-to-narrow" select="3.0"/>
      <xsl:param name="height" select="'0.25in'"/>
      <xsl:param name="quiet-horizontal" select="'0.075in'"/>
      <xsl:param name="quiet-vertical" select="'0.075in'"/>
      <xsl:param name="font-family" select="'Courier'"/>
      <xsl:param name="font-height" select="'6pt'"/>

      <!-- Check data consistency -->
      <xsl:if test="string-length($value)=0">
        <xsl:message terminate="yes">Error: 'value' is not specified.</xsl:message>
      </xsl:if>
      <xsl:if test="string-length(translate($value,$alphabet,''))!=0">
        <xsl:message terminate="yes">Error: unexpected characters in 'value'.</xsl:message>
      </xsl:if>

      <!-- Add checksum character to the value if necessary -->
      <!-- Add start/stop character ('*') -->
      <xsl:variable name="value-real">
        <xsl:text>*</xsl:text>
        <xsl:value-of select="$value"/>
        <xsl:if test="$addchecksum='true'">
          <xsl:call-template name="checksum">
            <xsl:with-param name="string" select="$value"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:text>*</xsl:text>
      </xsl:variable>
      
      <!-- Encode string in bars -->
      <xsl:variable name="value-encoded">
        <xsl:call-template name="char2bar_codec">
          <xsl:with-param name="string" select="$value-real"/>
        </xsl:call-template>
      </xsl:variable>

      <!-- Call backend to generate SVG image of the barcode -->
      <xsl:call-template name="draw-barcode">
        <xsl:with-param name="sequence" select="$value-encoded"/>
        <xsl:with-param name="string">
          <xsl:choose>
            <xsl:when test="string-length($string)=0">
              <xsl:value-of select="$value-real"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$string"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="print-text" select="$print-text"/>
        <xsl:with-param name="module" select="$module"/>
        <xsl:with-param name="wide-to-narrow" select="$wide-to-narrow"/>
        <xsl:with-param name="height" select="$height"/>
        <xsl:with-param name="quiet-horizontal" select="$quiet-horizontal"/>
        <xsl:with-param name="quiet-vertical" select="$quiet-vertical"/>        
        <xsl:with-param name="font-family" select="$font-family"/>
        <xsl:with-param name="font-height" select="$font-height"/>
      </xsl:call-template>
    </xsl:template>

    <!-- Template used to create an extended barcode 3 of 9 -->
    <xsl:template name="barcode-3of9-extended">
      <xsl:param name="value"/>
      <xsl:param name="string"/>
      <xsl:param name="print-text" select="'true'"/>
      <xsl:param name="addchecksum" select="'false'"/>
      <xsl:param name="module" select="'0.012in'"/>
      <xsl:param name="wide-to-narrow" select="3.0"/>
      <xsl:param name="height" select="'0.5in'"/>
      <xsl:param name="quiet-horizontal" select="'0.24in'"/>
      <xsl:param name="quiet-vertical" select="'0.12in'"/>
      <xsl:param name="font-family" select="'Courier'"/>
      <xsl:param name="font-height" select="'10pt'"/>
    
      <!-- Transcode data from URL-encoding to 3 of 9 extended code -->
      <xsl:variable name="value-transcoded">
        <xsl:call-template name="ascii2extended">
          <xsl:with-param name="value" select="$value"/>
        </xsl:call-template>
      </xsl:variable>
      
      <!-- Call main template to produce barcode 3 of 9 -->
      <xsl:call-template name="barcode-3of9">
        <xsl:with-param name="value" select="$value-transcoded"/>
        <xsl:with-param name="string" select="$string"/>
        <xsl:with-param name="print-text" select="$print-text"/>
        <xsl:with-param name="addchecksum" select="$addchecksum"/>
        <xsl:with-param name="module" select="$module"/>
        <xsl:with-param name="wide-to-narrow" select="$wide-to-narrow"/>
        <xsl:with-param name="height" select="$height"/>
        <xsl:with-param name="quiet-horizontal" select="$quiet-horizontal"/>
        <xsl:with-param name="quiet-vertical" select="$quiet-vertical"/>
        <xsl:with-param name="font-family" select="$font-family"/>
        <xsl:with-param name="font-height" select="$font-height"/>
      </xsl:call-template>

    </xsl:template>


    <!-- Helper templates -->

    <!-- Creates checksum character -->
    <!-- Recursively convert characters to their codes, sum them up,       -->
    <!-- devide sum by 43 and return devision reminder coded as character -->
    <xsl:template name="checksum">
      <xsl:param name="string"/>
      <xsl:param name="sum" select="0"/>
      <xsl:variable name="num" select="document('')//my:char2num/entry[@char=substring($string, 1, 1)]/text()"/>
      <xsl:choose>
        <xsl:when test="string-length($string) &gt; 1">
          <xsl:call-template name="checksum">
            <xsl:with-param name="string" select="substring($string, 2)"/>
            <xsl:with-param name="sum" select="$sum+$num"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="document('')//my:num2char/entry[@num=(($sum+$num) mod 43)]/text()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>

    <!-- Codes alpha-numerical string into bar states using appropriate table -->
    <xsl:template name="char2bar_codec">
      <xsl:param name="string"/>
      <xsl:value-of select="document('')//my:char2bar/entry[@char=substring($string, 1, 1)]/text()"/>
      <xsl:if test="string-length($string) &gt; 1">
        <xsl:call-template name="char2bar_codec">
          <xsl:with-param name="string" select="substring($string, 2)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:template>

    <!-- Codes URL-encoded data into a sequence of code 39 characters -->
    <xsl:template name="ascii2extended">
      <xsl:param name="value"/>
      <xsl:variable name="charlen">
        <xsl:choose>
          <xsl:when test="starts-with($value, '%') and document('')//my:code2char/entry[@code=substring($value, 2,2)]">
            <xsl:text>3</xsl:text>
          </xsl:when>
          <xsl:otherwise><xsl:text>1</xsl:text></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$charlen &gt; 1">
          <xsl:value-of select="document('')//my:code2char/entry[@code=substring($value, 2,2)]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="substring($value, 1,1)"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="string-length($value) &gt; $charlen">
        <xsl:call-template name="ascii2extended">
          <xsl:with-param name="value" select="substring($value, $charlen+1)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:template>

</xsl:stylesheet>