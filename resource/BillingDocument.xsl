<?xml version="1.0" encoding="UTF-8"?>

<!--

  Copyright (c) 2013 Ericsson

  All rights reserved.

  File:    BillingDocument.xsl

  Owner:   M. Fehrenbacher

  @(#) ABSTRACT : XML -> HTML stylesheet
  @(#) BSCS iX R4, Bill Formatting Server

  This stylesheet transforms billing documents.
  VERSION = @(#) ./lhsj_main/bscs/batch/src/bgh/LAYOUT/BillingDocument.xsl, , CBIO_PCP1503, CBIO_PCP1503_150728 @@CBIO_PCP1503_150728 28-Jul-2015

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cur="http://www.unece.org/etrades/unedocs" exclude-result-prefixes="xsl cur">

  <xsl:include href="AddressPage.xsl"/>
  <xsl:include href="Common.xsl"/>
  <xsl:include href="InvoiceInfo.xsl"/>
  <xsl:include href="Invoice.xsl"/>
  <xsl:include href="Summary.xsl"/>
  <xsl:include href="BalancePage.xsl"/>
  <xsl:include href="CallDetails.xsl"/>
  <xsl:include href="DepositRequest.xsl"/>
  <xsl:include href="CallDetailStatement.xsl"/>
  <xsl:include href="CollectionReport.xsl"/>
  <xsl:include href="Notification.xsl"/>
  <xsl:include href="CollectionPage.xsl"/>
  <xsl:include href="Letter.xsl"/>
  <xsl:include href="RecordDetail.xsl"/>
  <xsl:include href="ContractBalanceSnapshots.xsl"/>
  <xsl:include href="ContractBalanceAdjustments.xsl"/>
  <xsl:include href="ContractFreeUnitsAccounts.xsl"/>
  <xsl:include href="ContractFreeUnitsStatistic.xsl"/>
  <xsl:include href="ContractCostControlDiscounts.xsl"/>
  <xsl:include href="ContractExternalDiscounts.xsl"/>
  <xsl:include href="ContractPromotionCredits.xsl"/>
  <xsl:include href="ContractBundleProducts.xsl"/>
  <xsl:include href="ContractSharedAccounts.xsl"/>

  <xsl:template match="Bill">

    <!-- header/billing account -->
    <xsl:for-each select="document(/Bill/Part/@File)/Document/AddressPage/BillAcc">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    <xsl:choose>
	  <xsl:when test="document(/Bill/Part/@File)/Document/AddressPage/BillAcc/@BOF">
         <!-- Do nothing -->
	  </xsl:when>
	  <xsl:otherwise>
			<!-- header/addressee -->
			<xsl:for-each select="document(/Bill/Part/@File)/Document/AddressPage/Addressee">
			  <xsl:apply-templates select="."/>
			  <xsl:choose>
				<!-- call detail statement -->
				<xsl:when test="$bit = 'CDS'">
				  <hr/>
				  <center><h2>          
					<xsl:for-each select="$txt">
					  <xsl:value-of select="key('txt-index','402')[@xml:lang=$lang]/@Des"/>
					</xsl:for-each>
				  </h2></center>
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
			  <hr/>
			  <center><h2>
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
					<xsl:for-each select="$txt"><!-- Debit note -->
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
			  </h2></center>
			  <xsl:apply-templates select="."/>
			</xsl:for-each>
			
			<xsl:if test="($bit='INV' or $bit='REC' or $bit='PCM') and ($fmt!='rtf')">
			<!-- sum sheet -->
			<xsl:for-each select="document(/Bill/Part/@File)/Document/Summary">
			  <xsl:apply-templates select="."/>
			</xsl:for-each>
			</xsl:if>

			<!-- contract balance snapshots not available in the contract part of the sum sheet -->
			<xsl:call-template name="balance-snapshots"/>
			<!-- contract balance adjustments not available in the contract part of the sum sheet -->
			<xsl:call-template name="balance-adjustments"/>
			<!-- top-up actions of contracts not available in the contract part of the sum sheet -->
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
			  <center><h2>
				<xsl:for-each select="$txt">
				  <xsl:value-of select="key('txt-index','368')[@xml:lang=$lang]/@Des"/>
				</xsl:for-each>
			  </h2></center>
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
			<!-- footer/invoicing party -->
			<xsl:for-each select="document(/Bill/Part/@File)/Document/AddressPage/InvParty">
			  <hr/>
			  <xsl:apply-templates select="."/>
			</xsl:for-each>
	  </xsl:otherwise>
	</xsl:choose>	
  </xsl:template>

</xsl:stylesheet>
