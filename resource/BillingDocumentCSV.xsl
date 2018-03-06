<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    BillingDocumentCSV.xsl

  Owners:  M. Fehrenbacher
           N. Kather

  @(#) ABSTRACT : XML -> CSV stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms billing documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/BillingDocumentCSV.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" xmlns:bgh="http://www.lhsgroup.com/BSCS/BGH" exclude-result-prefixes="xsl cur bgh">

  <xsl:include href="AddressPageCSV.xsl"/>
  <xsl:include href="CommonCSV.xsl"/>
  <xsl:include href="InvoiceInfoCSV.xsl"/>
  <xsl:include href="InvoiceCSV.xsl"/>
  <xsl:include href="SummaryCSV.xsl"/>
  <xsl:include href="BalancePageCSV.xsl"/>
  <xsl:include href="CallDetailsCSV.xsl"/>
  <xsl:include href="DepositRequestCSV.xsl"/>
  <xsl:include href="CallDetailStatementCSV.xsl"/>
  <xsl:include href="CollectionReportCSV.xsl"/>
  <xsl:include href="NotificationCSV.xsl"/>
  <xsl:include href="CollectionPageCSV.xsl"/>
  <xsl:include href="LetterCSV.xsl"/>
  <xsl:include href="RecordDetailCSV.xsl"/>
  <xsl:include href="ContractBalanceSnapshotsCSV.xsl"/>
  <xsl:include href="ContractBalanceAdjustmentsCSV.xsl"/>
  <xsl:include href="ContractFreeUnitsAccountsCSV.xsl"/> 
  <xsl:include href="ContractFreeUnitsStatisticCSV.xsl"/>
  <xsl:include href="ContractCostControlDiscountsCSV.xsl"/>
  <xsl:include href="ContractExternalDiscountsCSV.xsl"/>
  <xsl:include href="ContractPromotionCreditsCSV.xsl"/>
  <xsl:include href="ContractBundleProductsCSV.xsl"/>
  <xsl:include href="ContractSharedAccountsCSV.xsl"/>
  
  <xsl:template match="/Bill">
  
    <bgh:rows>
  
    <!-- Document header/billing account -->
    <xsl:for-each select="document(/Bill/Part/@File)/Document/AddressPage[BillAcc]">
        <xsl:apply-templates select="."/>
        <bgh:row/>
    </xsl:for-each>
	<xsl:choose>
	  <xsl:when test="document(/Bill/Part/@File)/Document/AddressPage/BillAcc/@BOF"/>
	  <xsl:otherwise>
	  
				<!-- Document header/addressee -->
				<xsl:for-each select="document(/Bill/Part/@File)/Document/AddressPage[Addressee]">
					<xsl:apply-templates select="."/>
					<bgh:row/>
				  
					<xsl:choose>
						<!-- Print "call detail statement" -->
						<xsl:when test="$bit = 'CDS'">
							<bgh:row>
							<bgh:cell>
								<xsl:for-each select="$txt">
									<xsl:value-of select="key('txt-index','402')[@xml:lang=$lang]/@Des"/>
								</xsl:for-each>
							</bgh:cell>
							</bgh:row>
							<bgh:row/>
						</xsl:when>
						<xsl:otherwise/>
					</xsl:choose>
				</xsl:for-each>
				
				
				<!-- advertisement -->
				<xsl:for-each select="document(/Bill/Part/@File)/Document/InvoiceInfo/AdvTxt">
					<xsl:apply-templates select="."/>
				</xsl:for-each>
				
				
				<!-- invoice/reconciliation/partner credit memo -->
				<xsl:for-each select="document(/Bill/Part/@File)/Document/Invoice">
				
					<bgh:row>
					<!-- Write headline to the 1st column -->
				  
						<bgh:cell>
							<xsl:choose>
							  <xsl:when test="$bit='INV'">
								<xsl:for-each select="$txt">
								  <xsl:value-of select="key('txt-index','52')[@xml:lang=$lang]/@Des"/>
								</xsl:for-each>
							  </xsl:when>
							  <xsl:when test="$bit='REC'">
								<xsl:for-each select="$txt">
								  <xsl:value-of select="key('txt-index','396')[@xml:lang=$lang]/@Des"/>
								</xsl:for-each>
							  </xsl:when>
							  <xsl:when test="$bit='PCM'">
								<xsl:for-each select="$txt">
								  <xsl:value-of select="key('txt-index','441')[@xml:lang=$lang]/@Des"/>
								</xsl:for-each>
							  </xsl:when>
							  <xsl:when test="$bit='DN'">
								<xsl:for-each select="$txt">
								  <xsl:value-of select="key('txt-index','529')[@xml:lang=$lang]/@Des"/>
								</xsl:for-each>
							  </xsl:when>
							  <xsl:otherwise/>
							</xsl:choose>
							<!-- mark bill as copy -->
							<xsl:if test="$cflag = 'X'">
							  <xsl:text> - </xsl:text>
							  <xsl:for-each select="$txt">
								<xsl:value-of select="key('txt-index','525')[@xml:lang=$lang]/@Des"/>
							  </xsl:for-each>          
							</xsl:if>
						</bgh:cell>
					
					</bgh:row>
					<bgh:row/><!-- empty row -->
				  
					<xsl:apply-templates select="."/>
				  
				</xsl:for-each>
				
				<xsl:if test="$bit='INV' or $bit='REC' or $bit='PCM'">
				  <!-- sum sheet -->
				  <xsl:for-each select="document(/Bill/Part/@File)/Document/Summary">
					<xsl:apply-templates select="."/>
				  </xsl:for-each>
				</xsl:if>

				<!-- contract balance snapshots not available in the contract part of the sum sheet -->
				<xsl:call-template name="balance-snapshots"/>
				<!-- contract balance adjustments not available in the contract part of the sum sheet -->
				<xsl:call-template name="balance-adjustments"/>
				<!-- contract top-up actions not available in the contract part of the sum sheet -->
				<xsl:call-template name="top-up-actions"/>
				<!-- contract free units accounts not available in the contract part of the sum sheet -->
				<xsl:call-template name="free-units-accounts"/>
				<!-- contract free units statistic not available in the contract part of the sum sheet -->
				<xsl:call-template name="free-units-statistic"/>
				<!-- contract cost control discounts not available in the contract part of the sum sheet -->
				<xsl:call-template name="cost-control-discounts"/>
				<!-- contract external discounts not available in the contract part of the sum sheet -->
				<xsl:call-template name="external-discounts"/> 
				<!-- contract promotion credits not available in the contract part of the sum sheet -->
				<xsl:call-template name="promo-credits"/>
				<!-- contract bundle products not available in the contract part of the sum sheet -->
				<xsl:call-template name="bundle-products"/>
				<!-- contract shared accounts not available in the contract part of the sum sheet -->
				<xsl:call-template name="shared-accounts"/>
				
				<!-- call detail statement -->
				<xsl:call-template name="CallDetailStatement"/>
				<!-- deposit request -->
				<xsl:for-each select="document(/Bill/Part/@File)/Document/DepositRequest">
					<bgh:row>
						<bgh:cell>
							<xsl:for-each select="$txt"><!-- Deposit Request -->
							  <xsl:value-of select="key('txt-index','368')[@xml:lang=$lang]/@Des"/>
							</xsl:for-each>
						</bgh:cell>
					</bgh:row>
				  <xsl:apply-templates select="."/>
				</xsl:for-each>
				<!-- collection report -->
				<xsl:for-each select="document(/Bill/Part/@File)/Document/CollectionReport">
				  <xsl:apply-templates select="."/>
				</xsl:for-each>
				<!-- charge notification -->
				<xsl:for-each select="document(/Bill/Part/@File)/Document/ChargeNotification">
				  <xsl:apply-templates select="."/>
				</xsl:for-each>
				<!-- collection page -->
				<xsl:for-each select="document(/Bill/Part/@File)/Document/CollectionPage">
				  <xsl:apply-templates select="."/>
				</xsl:for-each>
				<!-- order management letter -->
				<xsl:for-each select="document(/Bill/Part/@File)/Document/Letter">
				  <xsl:apply-templates select="."/>
				</xsl:for-each>
				<xsl:if test="($bit='INV' or $bit='REC' or $bit='PCM')">
				  <!-- balance page -->
				  <xsl:for-each select="document(/Bill/Part/@File)/Document/BalancePage">
					<xsl:apply-templates select="."/>
				  </xsl:for-each>
				  <!-- bonus points statistic -->
				  <xsl:call-template name="BPStat">
					<xsl:with-param name="bpstat" select="document(/Bill/Part/@File)/Document/InvoiceInfo[position()=last()]/BPStat"/>
				  </xsl:call-template>
				  <!-- promotion details -->
				  <xsl:for-each select="document(/Bill/Part/@File)/Document/InvoiceInfo/PromoDetails">
					<xsl:apply-templates select="."/>
				  </xsl:for-each>
				  <!-- currency conversion info -->
				  <xsl:for-each select="document(/Bill/Part/@File)/Document/InvoiceInfo">
					<xsl:if test="position()=last()">
					  <xsl:apply-templates select="."/>
					</xsl:if>
				  </xsl:for-each>
				</xsl:if>	  
	  </xsl:otherwise>
	</xsl:choose>
	
    </bgh:rows>
    
  </xsl:template>

</xsl:stylesheet>
