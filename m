Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:1450 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610Ab0JNSEU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 14:04:20 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 5/9] iwlagn: 6050 ops should be used;
Date: Thu, 14 Oct 2010 11:02:46 -0700
Message-Id: <1287079370-20587-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1287079370-20587-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1287079370-20587-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For 6050 series of devices, 6050 ops should be used;
One of the 6050 config still use 6000 ops, fix it.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 3eaea6f..11e6532 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -780,7 +780,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
-	.ops = &iwl6000_ops,
+	.ops = &iwl6050_ops,
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,
 	.mod_params = &iwlagn_mod_params,
-- 
1.7.0.4

