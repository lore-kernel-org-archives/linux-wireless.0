Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50477 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756778Ab0BKSmN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2010 13:42:13 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/12] iwlwifi: remove unused op-code in PHY Calibration command
Date: Thu, 11 Feb 2010 10:41:58 -0800
Message-Id: <1265913725-4279-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1265913725-4279-1-git-send-email-reinette.chatre@intel.com>
References: <1265913725-4279-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Number of calibration op-code are not used by driver, remove those from
iwl-commands.h

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index c2f31eb..ab3c77b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3470,11 +3470,7 @@ enum {
 	IWL_PHY_CALIBRATE_DIFF_GAIN_CMD		= 7,
 	IWL_PHY_CALIBRATE_DC_CMD		= 8,
 	IWL_PHY_CALIBRATE_LO_CMD		= 9,
-	IWL_PHY_CALIBRATE_RX_BB_CMD		= 10,
 	IWL_PHY_CALIBRATE_TX_IQ_CMD		= 11,
-	IWL_PHY_CALIBRATE_RX_IQ_CMD		= 12,
-	IWL_PHY_CALIBRATION_NOISE_CMD		= 13,
-	IWL_PHY_CALIBRATE_AGC_TABLE_CMD		= 14,
 	IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD	= 15,
 	IWL_PHY_CALIBRATE_BASE_BAND_CMD		= 16,
 	IWL_PHY_CALIBRATE_TX_IQ_PERD_CMD	= 17,
-- 
1.6.3.3

