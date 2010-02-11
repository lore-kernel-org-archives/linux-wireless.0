Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54526 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756365Ab0BKU0J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2010 15:26:09 -0500
Subject: RE: [ipw3945-devel] [PATCH 05/12] iwlwifi: remove unused op-code
 in PHY	Calibration command
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "Cahill, Ben M" <ben.m.cahill@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <02B3067C068D0549A8CCFCB17D4D318B626D0610@orsmsx502.amr.corp.intel.com>
References: <1265913725-4279-1-git-send-email-reinette.chatre@intel.com>
	 <1265913725-4279-6-git-send-email-reinette.chatre@intel.com>
	 <02B3067C068D0549A8CCFCB17D4D318B626D0610@orsmsx502.amr.corp.intel.com>
Content-Type: text/plain
Date: Thu, 11 Feb 2010 12:22:42 -0800
Message-Id: <1265919762.3119.1.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

this is per Giora's request to remove unused calibration command. so we
will not alarm external to play with those commands.

we can add those back in if we are going to use it.

Wey

On Thu, 2010-02-11 at 12:17 -0800, Cahill, Ben M wrote:
> NACK.  Keep them around; we may use in the future.
> 
> -- Ben -- 
> 
> >-----Original Message-----
> >From: Reinette Chatre [mailto:reinette.chatre@intel.com] 
> >Sent: Thursday, February 11, 2010 1:42 PM
> >To: linville@tuxdriver.com
> >Cc: Chatre, Reinette; linux-wireless@vger.kernel.org; 
> >ipw3945-devel@lists.sourceforge.net
> >Subject: [ipw3945-devel] [PATCH 05/12] iwlwifi: remove unused 
> >op-code in PHY Calibration command
> >
> >From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> >
> >Number of calibration op-code are not used by driver, remove those from
> >iwl-commands.h
> >
> >Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> >Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> >---
> > drivers/net/wireless/iwlwifi/iwl-commands.h |    4 ----
> > 1 files changed, 0 insertions(+), 4 deletions(-)
> >
> >diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h 
> >b/drivers/net/wireless/iwlwifi/iwl-commands.h
> >index c2f31eb..ab3c77b 100644
> >--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
> >+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
> >@@ -3470,11 +3470,7 @@ enum {
> > 	IWL_PHY_CALIBRATE_DIFF_GAIN_CMD		= 7,
> > 	IWL_PHY_CALIBRATE_DC_CMD		= 8,
> > 	IWL_PHY_CALIBRATE_LO_CMD		= 9,
> >-	IWL_PHY_CALIBRATE_RX_BB_CMD		= 10,
> > 	IWL_PHY_CALIBRATE_TX_IQ_CMD		= 11,
> >-	IWL_PHY_CALIBRATE_RX_IQ_CMD		= 12,
> >-	IWL_PHY_CALIBRATION_NOISE_CMD		= 13,
> >-	IWL_PHY_CALIBRATE_AGC_TABLE_CMD		= 14,
> > 	IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD	= 15,
> > 	IWL_PHY_CALIBRATE_BASE_BAND_CMD		= 16,
> > 	IWL_PHY_CALIBRATE_TX_IQ_PERD_CMD	= 17,
> >-- 
> >1.6.3.3
> >
> >
> >---------------------------------------------------------------
> >---------------
> >SOLARIS 10 is the OS for Data Centers - provides features such 
> >as DTrace,
> >Predictive Self Healing and Award Winning ZFS. Get Solaris 10 NOW
> >http://p.sf.net/sfu/solaris-dev2dev
> >_______________________________________________
> >Ipw3945-devel mailing list
> >Ipw3945-devel@lists.sourceforge.net
> >https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
> >--
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

