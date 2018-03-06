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

  File:    AddressPageCSV.xsl

  Owners:  M. Fehrenbacher
           N. Kather

  @(#) ABSTRACT : XML -> CSV stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms address documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/AddressPageCSV.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" xmlns:bgh="http://www.lhsgroup.com/BSCS/BGH" exclude-result-prefixes="xsl cur bgh">
  
  <!-- Document heading, if the AddressPage has a BillAcc element-->
  <xsl:template match="AddressPage[BillAcc]">

    <xsl:choose>
		<xsl:when test="((BillAcc/@BOF='S') or (BillAcc/@BOF='F'))">
<xsl:variable name="cust-addr" select="BillAcc/Addr" />
				
				<bgh:row>
					<bgh:cell><xsl:value-of select="$cust-addr/@Name"/></bgh:cell>
				</bgh:row>
				
				<bgh:row>
					<bgh:cell><xsl:value-of select="$cust-addr/@Line1"/></bgh:cell>
				</bgh:row>
				
				<bgh:row>
					<bgh:cell><xsl:value-of select="$cust-addr/@Line2"/></bgh:cell>
				</bgh:row>
				
				<bgh:row>
					<bgh:cell><xsl:value-of select="$cust-addr/@Line3"/></bgh:cell>
				</bgh:row>
				
				<bgh:row>
					<bgh:cell><xsl:value-of select="$cust-addr/@Line4"/></bgh:cell>
				</bgh:row>
				
				<bgh:row>
					<bgh:cell><xsl:value-of select="$cust-addr/@Line5"/></bgh:cell>
				</bgh:row>
				
				<bgh:row>
					<bgh:cell><xsl:value-of select="$cust-addr/@Line6"/></bgh:cell>
				</bgh:row>
				
				<bgh:row>
					<bgh:cell><xsl:value-of select="$cust-addr/@Zip"/></bgh:cell>
				</bgh:row>
				
				<bgh:row>
					<bgh:cell><xsl:value-of select="$cust-addr/@City"/></bgh:cell>
				</bgh:row>
				
				<bgh:row>
					<bgh:cell><xsl:value-of select="$cust-addr/@Country"/></bgh:cell>
				</bgh:row>	

				<bgh:row/>
				<bgh:row/>
				<bgh:row/>				

				<bgh:row>
					<bgh:cell>
					  <xsl:for-each select="$txt">
						<xsl:value-of select="key('txt-index','556')[@xml:lang=$lang]/@Des"/>
					  </xsl:for-each>
					  <xsl:text> </xsl:text>
					  <xsl:value-of select="BillAcc/Addr/@Line2"/><xsl:text> ,</xsl:text>
					</bgh:cell>
				</bgh:row>

				<bgh:row>
					<bgh:cell>
					  <xsl:for-each select="$txt">
						<xsl:value-of select="key('txt-index','557')[@xml:lang=$lang]/@Des"/>
					  </xsl:for-each>
					  <xsl:text> </xsl:text>
					  <xsl:value-of select="concat(BillAcc/@ThresholdCurrCode,' ',BillAcc/@ThresholdAmount)"/>
					</bgh:cell>
				</bgh:row>

				<bgh:row>
					<bgh:cell>
					  <xsl:for-each select="$txt">
						<xsl:value-of select="key('txt-index','558')[@xml:lang=$lang]/@Des"/>
					  </xsl:for-each>
					  <xsl:text> </xsl:text>
					  <xsl:value-of select="concat(BillAcc/@ThresholdCurrCode,' ',BillAcc/@InvoiceAmount)"/><xsl:text> ).</xsl:text>
					</bgh:cell>
				</bgh:row>

				<xsl:choose>
					<xsl:when test="BillAcc/@BOF='S'">
						<bgh:row>
							<bgh:cell>
							  <xsl:for-each select="$txt">
								<xsl:value-of select="key('txt-index','559')[@xml:lang=$lang]/@Des"/>
							  </xsl:for-each>
							</bgh:cell>
						</bgh:row>
					</xsl:when>
					<xsl:otherwise>
						<bgh:row>
							<bgh:cell>
							  <xsl:for-each select="$txt">
								<xsl:value-of select="key('txt-index','560')[@xml:lang=$lang]/@Des"/>
							  </xsl:for-each>
							</bgh:cell>
						</bgh:row>
					</xsl:otherwise>
				</xsl:choose>

				<bgh:row>
					<bgh:cell>
					  <xsl:for-each select="$txt">
						<xsl:value-of select="key('txt-index','561')[@xml:lang=$lang]/@Des"/>
					  </xsl:for-each>
					</bgh:cell>
				</bgh:row>

				<bgh:row>
					<bgh:cell>
					  <xsl:for-each select="$txt">
						<xsl:value-of select="key('txt-index','562')[@xml:lang=$lang]/@Des"/>
					  </xsl:for-each>
					</bgh:cell>
				</bgh:row>

				<bgh:row>
					<bgh:cell>
					  <xsl:value-of select="../@Sender"/>
					</bgh:cell>
				</bgh:row>		
			</xsl:when>	  
		<xsl:otherwise>	
				<!-- Invoicing party address -->
				<bgh:row>
					<bgh:cell><xsl:value-of select="InvParty/Addr/@Name" /></bgh:cell>
				</bgh:row>
				
				<xsl:if test="InvParty/Addr/@Line1">
					<bgh:row>
						<bgh:cell>
							<xsl:value-of select="InvParty/Addr/@Line1" />
						</bgh:cell>
					</bgh:row>
				</xsl:if>
				
				<xsl:if test="InvParty/Addr/@Line2">
					<bgh:row>
						<bgh:cell><xsl:value-of select="InvParty/Addr/@Line2" /></bgh:cell>
					</bgh:row>
				</xsl:if>
				
				<xsl:if test="InvParty/Addr/@Line3">
					<bgh:row>
						<bgh:cell><xsl:value-of select="InvParty/Addr/@Line3" /></bgh:cell>
					</bgh:row>
				</xsl:if>
				
				<xsl:if test="InvParty/Addr/@Line4">
					<bgh:row>
						<bgh:cell><xsl:value-of select="InvParty/Addr/@Line4" /></bgh:cell>
					</bgh:row>
				</xsl:if>
				
				<xsl:if test="InvParty/Addr/@Line5">
					<bgh:row>
						<bgh:cell><xsl:value-of select="InvParty/Addr/@Line5" /></bgh:cell>
					</bgh:row>
				</xsl:if>
				
				<xsl:if test="InvParty/Addr/@Line6">
					<bgh:row>
						<bgh:cell><xsl:value-of select="InvParty/Addr/@Line6" /></bgh:cell>
					</bgh:row>
				</xsl:if>
				
				<xsl:if test="InvParty/Addr/@Zip">
					<bgh:row>
						<bgh:cell><xsl:value-of select="InvParty/Addr/@Zip" /></bgh:cell>
					</bgh:row>
				</xsl:if>
				
				<xsl:if test="InvParty/Addr/@City">
					<bgh:row>
						<bgh:cell><xsl:value-of select="InvParty/Addr/@City" /></bgh:cell>
					</bgh:row>
				</xsl:if>
				
				<xsl:if test="InvParty/Addr/@Country">
					<bgh:row>
						<bgh:cell><xsl:value-of select="InvParty/Addr/@Country" /></bgh:cell>
					</bgh:row>
				</xsl:if>
				
				<bgh:row />
				
				<!-- Recipient address in the 1st column -->
				<!-- Texts in the 3rd column -->
				<!-- Document number, billing acocunt, bank account data in the 4th column -->
				
				<xsl:variable name="cust-addr" select="BillAcc/Addr" />
				
				<bgh:row>
					<bgh:cell><xsl:value-of select="$cust-addr/@Name"/></bgh:cell>
					<bgh:cell/>
					<bgh:cell>
						<!-- Document No. -->
						<xsl:for-each select="$txt">
							<xsl:value-of select="key('txt-index','327')[@xml:lang=$lang]/@Des"/>
						</xsl:for-each>          
					</bgh:cell>
					<bgh:cell><xsl:value-of select="$drn"/></bgh:cell>
				</bgh:row>
				
				<bgh:row>
					<bgh:cell><xsl:value-of select="$cust-addr/@Line1"/></bgh:cell>
					<bgh:cell/>
					<bgh:cell>
						<!-- Billing Account Name -->
						<xsl:for-each select="$txt">
							<xsl:value-of select="key('txt-index','306')[@xml:lang=$lang]/@Des"/>
						</xsl:for-each>
					</bgh:cell>
					<bgh:cell><xsl:value-of select="BillAcc/@Desc"/></bgh:cell>
				</bgh:row>
				
				<bgh:row>
					<bgh:cell><xsl:value-of select="$cust-addr/@Line2"/></bgh:cell>
					<bgh:cell/>
					<bgh:cell>
						<!-- Billing Account Id -->
					</bgh:cell>
					<bgh:cell><xsl:value-of select="../@BAId"/></bgh:cell>
				</bgh:row>
				
				<bgh:row>
					<bgh:cell><xsl:value-of select="$cust-addr/@Line3"/></bgh:cell>
					<bgh:cell/>
					<bgh:cell>
						<!-- Customer code -->
						<xsl:for-each select="$txt">
							<xsl:value-of select="key('txt-index','15')[@xml:lang=$lang]/@Des"/>
						</xsl:for-each>
					</bgh:cell>
					<bgh:cell><xsl:value-of select="BillAcc/Customer/@Id"/></bgh:cell>
				</bgh:row>
				
				<bgh:row>
					<bgh:cell><xsl:value-of select="$cust-addr/@Line4"/></bgh:cell>
					<bgh:cell/>
					<bgh:cell>
						<!-- Payment method -->
						<xsl:if test="BillAcc/@PayMeth">
						  <xsl:for-each select="$txt">
							<xsl:value-of select="key('txt-index','128')[@xml:lang=$lang]/@Des"/>
						  </xsl:for-each>  
						</xsl:if>
					</bgh:cell>
					<bgh:cell>
						<xsl:if test="BillAcc/@PayMeth">
						  <xsl:call-template name="LgnMap">
							<xsl:with-param name="Mode"  select="'0'"/>
							<xsl:with-param name="Index" select="BillAcc/@PayMeth"/>
							<xsl:with-param name="Type"  select="'PMT'"/>
							<xsl:with-param name="Desc"  select="'1'"/>
						  </xsl:call-template>
						</xsl:if>
					</bgh:cell>
				</bgh:row>
				
				<bgh:row>
					<bgh:cell><xsl:value-of select="$cust-addr/@Line5"/></bgh:cell>
				</bgh:row>
				
				<bgh:row>
					<bgh:cell><xsl:value-of select="$cust-addr/@Line6"/></bgh:cell>
				</bgh:row>
				
				<bgh:row>
					<bgh:cell><xsl:value-of select="$cust-addr/@Zip"/></bgh:cell>
				</bgh:row>
				
				<bgh:row>
					<bgh:cell><xsl:value-of select="$cust-addr/@City"/></bgh:cell>
				</bgh:row>
				
				<bgh:row>
					<bgh:cell><xsl:value-of select="$cust-addr/@Country"/></bgh:cell>
				</bgh:row>		
		</xsl:otherwise>
	</xsl:choose>    
    <bgh:row />  
  </xsl:template>
  
  
  <!-- Document heading for call detail statement (the AddressPage has an Addressee element) -->
  <xsl:template match="AddressPage[Addressee]">
    
    <!-- Invoicing party address line -->
    <bgh:row>
    <bgh:cell>
    
    <xsl:value-of   select="concat(InvParty/Addr/@Name ,' ',
                                   InvParty/Addr/@Line1,' ',InvParty/Addr/@Line2,' ',
                                   InvParty/Addr/@Line3,' ',InvParty/Addr/@Line4,' ',
                                   InvParty/Addr/@Line5,' ',InvParty/Addr/@Line6,' ',
                                   InvParty/Addr/@Zip  ,' ',InvParty/Addr/@City ,' ',
                                   InvParty/Addr/@Country)"/>
                                   
    </bgh:cell>
    </bgh:row>
    
    <bgh:row />
    
    <!-- Recipient address in the 1st column -->
    <!-- Texts in the 5th column -->
    <!-- Document number, contract and customer code in the 7th column -->
    
    <xsl:variable name="cust-addr" select="Addressee/Addr" />
    
    <bgh:row>
    <bgh:cell><xsl:value-of select="concat($cust-addr/@Name,' ',$cust-addr/@Line1)"/></bgh:cell>
    <bgh:cell/>
    <bgh:cell/>
    <bgh:cell/>
    <bgh:cell>
        <!-- Document No. -->
        <xsl:if test="$bit != 'LET'">
            <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','327')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        </xsl:if>
    </bgh:cell>
    <bgh:cell/>
    <bgh:cell>
        <xsl:if test="$bit != 'LET'"><xsl:value-of select="$drn"/></xsl:if>
    </bgh:cell>
    </bgh:row>
    
    <bgh:row>
    <bgh:cell><xsl:value-of select="concat($cust-addr/@Line2,' ',$cust-addr/@Line3)"/></bgh:cell>
    <bgh:cell/>
    <bgh:cell/>
    <bgh:cell/>
    <bgh:cell>
        <!-- Contract id -->
        <xsl:if test="$bit != 'LET'">
            <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','403')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        </xsl:if>
    </bgh:cell>
    <bgh:cell/>
    <bgh:cell>
        <xsl:if test="$bit != 'LET'"><xsl:value-of select="Addressee/@CoId"/></xsl:if>
    </bgh:cell>
    </bgh:row>
    
    <bgh:row>
    <bgh:cell><xsl:value-of select="concat($cust-addr/@Line4,' ',$cust-addr/@Line5)"/></bgh:cell>
    <bgh:cell/>
    <bgh:cell/>
    <bgh:cell/>
    <bgh:cell>
        <!-- Customer code -->
        <xsl:for-each select="$txt">
            <xsl:value-of select="key('txt-index','15')[@xml:lang=$lang]/@Des"/>
        </xsl:for-each>
    </bgh:cell>
    <bgh:cell/>
    <bgh:cell><xsl:value-of select="Addressee/Customer/@Id"/></bgh:cell>
    </bgh:row>
    
    <bgh:row>
    <bgh:cell><xsl:value-of select="$cust-addr/@Line6"/></bgh:cell>
    <bgh:cell/>
    <bgh:cell/>
    <bgh:cell/>
    <bgh:cell/>
    <bgh:cell/>
    <bgh:cell/>
    </bgh:row>
    
    <bgh:row>
    <bgh:cell><xsl:value-of select="$cust-addr/@Zip"/></bgh:cell>
    <bgh:cell/>
    <bgh:cell/>
    <bgh:cell/>
    <bgh:cell/>
    <bgh:cell/>
    <bgh:cell/>
    </bgh:row>
    
    <bgh:row>
    <bgh:cell>
        <xsl:if  test="$cust-addr/@City"><xsl:value-of select="concat(' ',$cust-addr/@City)"/></xsl:if>
    </bgh:cell>
    <bgh:cell/>
    <bgh:cell/>
    <bgh:cell/>
    <bgh:cell/>
    <bgh:cell/>
    <bgh:cell/>
    </bgh:row>
    
    <bgh:row>
    <bgh:cell><xsl:value-of select="$cust-addr/@Country"/></bgh:cell>
    <bgh:cell/>
    <bgh:cell/>
    <bgh:cell/>
    <bgh:cell/>
    <bgh:cell/>
    <bgh:cell/>
    </bgh:row>

  
  </xsl:template>
  
  
  <!-- Bank account of the recipient (is called in Invoice stylesheet) -->
  <xsl:template match="BillAcc/FiCont">
  
    <bgh:row>
        <bgh:cell>
            <!-- Headline: "Your bank account" -->
            <xsl:for-each select="$txt">
              <xsl:value-of select="key('txt-index','526')[@xml:lang=$lang]/@Des"/>
            </xsl:for-each>
        </bgh:cell>
    </bgh:row>
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
            <!-- Account holder -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','5')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell><xsl:value-of select="concat(Account/@HolderName1,' ',Account/@HolderName2)"/></bgh:cell>
    </bgh:row>
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
            <!-- Account number -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','6')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell><xsl:value-of select="Account/@Num"/></bgh:cell>
    </bgh:row>
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
            <!-- Bank code -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','7')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell><xsl:value-of select="Bank/@Code"/></bgh:cell>
    </bgh:row>
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
            <!-- Bank name -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','8')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell><xsl:value-of select="Bank/@Name"/></bgh:cell>
    </bgh:row>
    
    <bgh:row>
        <bgh:cell/>
        <bgh:cell>
            <!-- Bank branch -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','9')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell><xsl:value-of select="Bank/@Branch"/></bgh:cell>
    </bgh:row>
    
    <bgh:row />
  
  </xsl:template>
  
  
  

  <!-- invoicing party -->
  <xsl:template match="InvParty">
    
    <bgh:row>
        <bgh:cell>
            <!-- Account number -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','6')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell><xsl:value-of select="FiCont/Account/@Num"/></bgh:cell>
    </bgh:row>
    
    <bgh:row>
        <bgh:cell>
            <!-- Bank code -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','7')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell><xsl:value-of select="FiCont/Bank/@Code"/></bgh:cell>
    </bgh:row>
    
    <bgh:row>
        <bgh:cell>
            <!-- Bank name -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','8')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell><xsl:value-of select="FiCont/Bank/@Name"/></bgh:cell>
    </bgh:row>

    <xsl:if test="@VATRegNo">
        <bgh:row>
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','10')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <xsl:value-of select="@VATRegNo"/>
            </bgh:cell>
        </bgh:row>
    </xsl:if>
    
    <bgh:row>
        <bgh:cell>
            <!-- Contact Person -->
              <xsl:for-each select="$txt">
                <xsl:value-of select="key('txt-index','11')[@xml:lang=$lang]/@Des"/>
              </xsl:for-each>
        </bgh:cell>
        <bgh:cell><xsl:value-of select="CCContact/@Person"/></bgh:cell>
    </bgh:row>
    
    <xsl:for-each select="Contact">
        <xsl:apply-templates select="."/>
    </xsl:for-each>
    
    <bgh:row/>
    
  </xsl:template>
  
  

  <!-- call detail statement -->
  <xsl:template match="Addressee">
                
                  <!-- sender address header -->
                  <xsl:value-of
                    select="concat(../InvParty/Addr/@Name ,' ',
                                   ../InvParty/Addr/@Line1,' ',../InvParty/Addr/@Line2,' ',
                                   ../InvParty/Addr/@Line3,' ',../InvParty/Addr/@Line4,' ',
                                   ../InvParty/Addr/@Line5,' ',../InvParty/Addr/@Line6,' ', 
                                   ../InvParty/Addr/@Zip  ,' ',../InvParty/Addr/@City ,' ',
                                   ../InvParty/Addr/@Country)"/>
                                
              
              <!-- receiver address -->
              <xsl:apply-templates select="Addr"/>
            
            
              
                
                
                
                  <!-- not for order management letter -->
                  <xsl:if test="$bit != 'LET'">                
                    <!-- document reference number -->
                    
                      
                        
                          <xsl:for-each select="$txt">
                            <xsl:value-of select="key('txt-index','327')[@xml:lang=$lang]/@Des"/>
                          </xsl:for-each>
                        
                      
                      
                        
                          <xsl:value-of select="$drn"/>
                        
                      
                    
                    
                      <!-- contract -->
                      
                        

                        
                      
                      
                        
                          <xsl:value-of select="@CoId"/>
                        
                      
                    
                  </xsl:if>
                  
                    <!-- customer code -->
                    <xsl:apply-templates select="Customer"/>
                  
                
              
            
          
        
      
      
  </xsl:template>

  <!-- customer info -->
  <xsl:template match="Customer">
    
      

      
    
  </xsl:template>
  
  <!-- money transaction info -->
  <xsl:template match="FiCont">
    <xsl:apply-templates select="Account"/>
    <xsl:apply-templates select="Bank"/>
  </xsl:template>
  
  <!-- money transaction info -->
  <xsl:template match="FiCont" mode="footage">
    <xsl:apply-templates select="Account" mode="footage"/>
    <xsl:apply-templates select="Bank" mode="footage"/>
  </xsl:template>
  
  <!-- bank account -->
  <xsl:template match="Account">
    
      
        

        
      
    
  </xsl:template>
  
  <!-- bank account -->
  <xsl:template match="Account" mode="footage">
    <!--        
    <xsl:for-each select="$txt">
      <xsl:value-of select="key('txt-index','5')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>        
    <xsl:text> </xsl:text>
    <xsl:value-of select="concat(@HolderName1,' ',@HolderName2)"/>
    <xsl:text>  </xsl:text>
    -->
    <xsl:for-each select="$txt">
      <xsl:value-of select="key('txt-index','6')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text> </xsl:text>
    <xsl:value-of select="@Num"/>
  </xsl:template>
  
  <!-- bank info -->
  <xsl:template match="Bank">

        


    
  </xsl:template>
  
  
  <!-- bank info -->
  <xsl:template match="Bank" mode="footage">
    <xsl:text> </xsl:text>
    <xsl:for-each select="$txt">
      <xsl:value-of select="key('txt-index','7')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text> </xsl:text>
    <xsl:value-of select="@Code"/>
    <xsl:text>  </xsl:text>
    <xsl:for-each select="$txt">
      <xsl:value-of select="key('txt-index','8')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>
    <xsl:text> </xsl:text>
    <xsl:value-of select="@Name"/>
    <xsl:text>  </xsl:text>
    <!--
    <xsl:for-each select="$txt">
      <xsl:value-of select="key('txt-index','9')[@xml:lang=$lang]/@Des"/>
    </xsl:for-each>        
    <xsl:text> </xsl:text>
    <xsl:value-of select="@Branch"/>
    -->
  </xsl:template>
  

  
  <!-- contact info -->
  <xsl:template match="Contact">
    <xsl:choose>
      <xsl:when test="@Type='TE'">
        <bgh:row>
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','12')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <xsl:value-of select="@Value"/>
            </bgh:cell>
        </bgh:row>
      </xsl:when>
      <xsl:when test="@Type='TX'">
        <bgh:row>
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','13')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <xsl:value-of select="@Value"/>
            </bgh:cell>
        </bgh:row>
      </xsl:when>
      <xsl:when test="@Type='FX'">
        <bgh:row>
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','14')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <xsl:value-of select="@Value"/>
            </bgh:cell>
        </bgh:row>
      </xsl:when>
      <xsl:when test="@Type='EM'">
        <bgh:row>
            <bgh:cell>
                <xsl:for-each select="$txt">
                  <xsl:value-of select="key('txt-index','326')[@xml:lang=$lang]/@Des"/>
                </xsl:for-each>
            </bgh:cell>
            <bgh:cell>
                <xsl:value-of select="@Value"/>
            </bgh:cell>
        </bgh:row>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
