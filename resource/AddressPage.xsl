<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson
 
  All rights reserved.

  File:    AddressPage.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> HTML stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms address documents.
  VERSION = %VI%

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" exclude-result-prefixes="xsl cur">

  <!-- address -->
  <xsl:template match="AddressPage">           
      
  </xsl:template>

  <!-- invoicing party -->
  <xsl:template match="InvParty">

    <table width="100%" cellspacing="0" cellpadding="0">
      <tr>
        <td valign="bottom"><b><font size="-1">
          <xsl:apply-templates select="Addr"/>
        </font></b></td>        
        <td align="right">
          <table border="0" cellspacing="0" cellpadding="0">                          
            <xsl:apply-templates select="FiCont" mode="sender"/>                
            <xsl:if test="@VATRegNo">
              <tr>
                <td><font size="-1"><br/>
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','10')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
               </font></td>
               <td><font size="-1"><br/>
                 <i><xsl:value-of select="@VATRegNo"/></i>
               </font></td>
              </tr>
            </xsl:if>              
          </table>          
        </td>
      </tr>
    </table>    
    <xsl:apply-templates select="CCContact"/>
    
  </xsl:template>

  <!-- billing account -->
  <xsl:template match="BillAcc">
    
      <xsl:choose>        
          <xsl:when test="((@BOF='S') or (@BOF='F'))">
            <table width="100%" cellspacing="0" cellpadding="0">
              <tr>
                <td valign="bottom"><font size="-1">
                <b>
                    <!-- receiver address -->
                    <xsl:apply-templates select="Addr"/>
                </b></font></td>
              </tr>
            </table>          
            <hr/>   
            <table width="100%" cellspacing="0" cellpadding="0">
             <tr>
              <td>
                <font size="-1"> 
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','556')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>               
                  <xsl:text> </xsl:text>
                  <b><xsl:value-of select="Addr/@Line2"/></b><xsl:text> ,</xsl:text></font>
              </td>
             </tr>
             <tr>
              <td>
                <font size="-1"> 
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','557')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                  <xsl:text> </xsl:text>                  
               <i><xsl:value-of select="concat(@ThresholdCurrCode,'&#160;',@ThresholdAmount)"/></i></font>
              </td>
             </tr>
             <tr>
              <td>
                <font size="-1"> 
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','558')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>                 
                  <xsl:text> </xsl:text>
                  <i><xsl:value-of select="concat(@ThresholdCurrCode,'&#160;',@InvoiceAmount)"/></i><xsl:text> ).</xsl:text></font>
              </td>
             </tr>
            <xsl:choose>
              <xsl:when test="@BOF='S'">
                 <tr>
                  <td>
                    <font size="-1"> 
                      <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','559')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>                 
                    </font>           
                  </td>
                 </tr>
              </xsl:when>
              <xsl:otherwise>
                 <tr>
                  <td>
                    <font size="-1"> 
                      <xsl:for-each select="$txt">
                        <xsl:value-of select="key('txt-index','560')[@xml:lang=$lang]/@Des"/>
                      </xsl:for-each>                 
                    </font>           
                  </td>
                 </tr>        
              </xsl:otherwise>
            </xsl:choose>            
             <tr>
              <td>
                <font size="-1"> 
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','561')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>                 
                </font>               
              </td>
             </tr>           
             <tr>
              <td>
                <font size="-1"> 
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','562')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>                 
                </font>               
              </td>
             </tr>           
             <tr><td><font size="-1"><b><xsl:value-of select="../../@Sender"/></b></font></td></tr>
            </table>
            </xsl:when>
          <xsl:otherwise>
                <table width="100%" cellspacing="0" cellpadding="0">
                  <tr>
                    <td valign="bottom"><font size="-1">
                      <!-- sender address header -->
                      <u><xsl:value-of select="concat(../InvParty/Addr/@Name ,'&#160;',
                                                      ../InvParty/Addr/@Line1,'&#160;',../InvParty/Addr/@Line2,'&#160;',
                                                      ../InvParty/Addr/@Line3,'&#160;',../InvParty/Addr/@Line4,'&#160;',
                                                      ../InvParty/Addr/@Line5,'&#160;',../InvParty/Addr/@Line6,'&#160;',
                                                      ../InvParty/Addr/@Zip  ,'&#160;',../InvParty/Addr/@City ,'&#160;',
                                                      ../InvParty/Addr/@Country)"/>
                      </u><br/><br/><b>
                        <!-- receiver address -->
                        <xsl:apply-templates select="Addr"/>
                    </b></font></td>
                    <td align="right">
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td><font size="-1">                
                            <!-- document reference number -->
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','327')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                            <xsl:text>  </xsl:text>
                          </font></td>
                          <td><font size="-1">
                            <i><xsl:value-of select="$drn"/></i>
                          </font></td>
                        </tr>
                        <!-- billing account -->
                        <tr>
                          <!-- name -->
                          <td><font size="-1">                
                            <xsl:for-each select="$txt">
                              <xsl:value-of select="key('txt-index','306')[@xml:lang=$lang]/@Des"/>
                            </xsl:for-each>
                          </font></td>
                          <td><font size="-1">
                            <i><xsl:value-of select="@Desc"/></i>
                          </font></td>
                        </tr>
                        <tr>
                          <!-- pkey -->
                          <td/>              
                          <td><font size="-1">
                            <i><xsl:value-of select="../../@BAId"/></i>
                          </font></td>
                        </tr>
                        <tr>
                          <!-- customer code -->                
                          <xsl:apply-templates select="Customer"/>
                        </tr>
                      </table>          
                    </td>
                  </tr>
                </table>              
          </xsl:otherwise>
      </xsl:choose>           
  </xsl:template>

  <!-- call detail statement -->
  <xsl:template match="Addressee">

    <table width="100%" cellspacing="0" cellpadding="0">
      <tr>
        <td valign="bottom"><font size="-1">
          <!-- sender address header -->
          <u><xsl:value-of select="concat(../InvParty/Addr/@Name ,'&#160;',
                                          ../InvParty/Addr/@Line1,'&#160;',../InvParty/Addr/@Line2,'&#160;',
                                          ../InvParty/Addr/@Line3,'&#160;',../InvParty/Addr/@Line4,'&#160;',
                                          ../InvParty/Addr/@Line5,'&#160;',../InvParty/Addr/@Line6,'&#160;',
                                          ../InvParty/Addr/@Zip  ,'&#160;',../InvParty/Addr/@City ,'&#160;',
                                          ../InvParty/Addr/@Country)"/>
          </u><br/><br/><b>
            <!-- addressee -->
            <xsl:apply-templates select="Addr"/>
        </b></font></td>
        <td align="right">
          <table border="0" cellspacing="0" cellpadding="0">
            <!-- not for order management letter -->
            <xsl:if test="$bit != 'LET'">
              <tr>
                <td><font size="-1">              
                  <!-- document reference number -->                
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','327')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                  <xsl:text>  </xsl:text>                
                </font></td>
                <td><font size="-1">
                  <i><xsl:value-of select="$drn"/></i>
                </font></td>
              </tr>
              <tr>
                <td><font size="-1">                
                  <!-- contract id -->
                  <xsl:for-each select="$txt">
                    <xsl:value-of select="key('txt-index','403')[@xml:lang=$lang]/@Des"/>
                  </xsl:for-each>
                  <xsl:text>  </xsl:text>
                </font></td>
                <td><font size="-1">
                  <i><xsl:value-of select="@CoId"/></i>
                </font></td>
              </tr>            
            </xsl:if>
            <tr>
              <!-- customer code -->                
              <xsl:apply-templates select="Customer"/>
            </tr>
          </table>          
        </td>
      </tr>
    </table>

  </xsl:template>

  <!-- customer info -->
  <xsl:template match="Customer">

    <td><font size="-1">  
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','15')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
    </font></td>
    <td><font size="-1">
      <i><xsl:value-of select="@Id"/></i>
    </font></td>
      
  </xsl:template>

  <!-- money transaction info -->
  <xsl:template match="FiCont" mode="receiver">
  
    <xsl:apply-templates select="Account" mode="receiver"/>
    <xsl:apply-templates select="Bank" mode="receiver"/>
    
  </xsl:template>

  <!-- money transaction info -->
  <xsl:template match="FiCont" mode="sender">
  
    <xsl:apply-templates select="Account" mode="sender"/>
    <xsl:apply-templates select="Bank" mode="sender"/>
    
  </xsl:template>

  <!-- bank account info -->
  <xsl:template match="Account" mode="receiver">

    <xsl:for-each select="$txt">
      <xsl:value-of select="key('txt-index','5')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    
    <xsl:text> </xsl:text>
    <i><xsl:value-of select="concat(@HolderName1,'&#160;',@HolderName2)"/></i>

    <xsl:text> - </xsl:text>
    <xsl:for-each select="$txt">
      <xsl:value-of select="key('txt-index','6')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>

    <xsl:text> </xsl:text>
    <i><xsl:value-of select="@Num"/></i>
    <br/>
    
  </xsl:template>

  <!-- bank info -->
  <xsl:template match="Bank" mode="receiver">

    <xsl:for-each select="$txt">
      <xsl:value-of select="key('txt-index','7')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text> </xsl:text>
    <i><xsl:value-of select="@Code"/></i>

    <xsl:text> - </xsl:text>
    <xsl:for-each select="$txt">
      <xsl:value-of select="key('txt-index','8')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text> </xsl:text>
    <i><xsl:value-of select="@Name"/></i>
    
    <xsl:text> - </xsl:text>
    <xsl:for-each select="$txt">
      <xsl:value-of select="key('txt-index','9')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text> </xsl:text>
    <i><xsl:value-of select="@Branch"/></i>

  </xsl:template>

  <!-- bank account info -->
  <xsl:template match="Account" mode="sender">

    <tr>
      <td><font size="-1">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','5')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </font></td>
      <td><font size="-1">
        <i><xsl:value-of select="concat(@HolderName1,'&#160;',@HolderName2)"/></i>
      </font></td>
    </tr>
    <tr>
      <td><font size="-1">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','6')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </font></td>
      <td><font size="-1">
        <i><xsl:value-of select="@Num"/></i>
      </font></td>
    </tr>
    
  </xsl:template>

  <!-- bank info -->
  <xsl:template match="Bank" mode="sender">

    <tr>
      <td><font size="-1">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','7')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </font></td>
      <td><font size="-1">
        <i><xsl:value-of select="@Code"/></i>
      </font></td>
    </tr>
    <tr>
      <td><font size="-1">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','8')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </font></td>
      <td><font size="-1">
        <i><xsl:value-of select="@Name"/></i>
      </font></td>
    </tr>
    <tr>
      <td><font size="-1">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','9')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
      </font></td>
      <td><font size="-1">
        <i><xsl:value-of select="@Branch"/></i>
      </font></td>
    </tr>

  </xsl:template>

  <!-- customer care contact info -->
  <xsl:template match="CCContact">
  
    <p align="center">
      <xsl:for-each select="$txt">
        <xsl:value-of select="key('txt-index','11')[@xml:lang=$lang]/@Des"/>
      </xsl:for-each>
      <xsl:text>  </xsl:text>
      <i><xsl:value-of select="@Person"/></i>
      <xsl:text>  </xsl:text>
      <xsl:for-each select="Contact">
        <xsl:apply-templates select="."/>      
      </xsl:for-each>      
    </p>
      
  </xsl:template>

  <!-- contact info -->
  <xsl:template match="Contact">

    <xsl:choose>      
      <xsl:when test="@Type='TE'">
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','12')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:text>  </xsl:text>   
        <i><xsl:value-of select="@Value"/></i>
        <xsl:text>  </xsl:text>
      </xsl:when>
      <xsl:when test="@Type='TX'">           
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','13')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:text>  </xsl:text>       
        <i><xsl:value-of select="@Value"/></i>
        <xsl:text>  </xsl:text>
      </xsl:when>
      <xsl:when test="@Type='FX'">    
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','14')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:text>  </xsl:text>      
        <i><xsl:value-of select="@Value"/></i>
        <xsl:text>  </xsl:text>
      </xsl:when>
      <xsl:when test="@Type='EM'">    
        <xsl:for-each select="$txt">
          <xsl:value-of select="key('txt-index','326')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
        <xsl:text>  </xsl:text>        
        <i><xsl:value-of select="@Value"/></i>
        <xsl:text>  </xsl:text>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  </xsl:stylesheet>
