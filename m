Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9689 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189AbZIQRny (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 13:43:54 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/13] iwlwifi: EEPROM version for 1000 and 6000 series
Date: Thu, 17 Sep 2009 10:43:46 -0700
Message-Id: <1253209436-2309-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
References: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Update EEPROM version requirement for 1000 and 6000 series of NIC
for EEPROM version verification.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c   |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    6 ++++++
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 486b144..4da99d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -153,7 +153,7 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.sku = IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl1000_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
-	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
+	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_A,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index c4ae99f..92faac0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -246,7 +246,7 @@ struct iwl_cfg iwl6000h_2agn_cfg = {
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl6000_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
-	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
+	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_AB,
@@ -271,7 +271,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl6000_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
-	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
+	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_BC,
@@ -293,7 +293,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl6000_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
-	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
+	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_AB,
@@ -315,7 +315,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl6000_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
-	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
+	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_ABC,
@@ -337,7 +337,7 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl6000_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
-	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
+	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_ABC,
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 61794eb..75fe022 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -256,6 +256,12 @@ struct iwl_eeprom_enhanced_txpwr {
 #define EEPROM_5050_TX_POWER_VERSION    (4)
 #define EEPROM_5050_EEPROM_VERSION	(0x21E)
 
+/* 1000 Specific */
+#define EEPROM_1000_EEPROM_VERSION	(0x15D)
+
+/* 60x0 Specific */
+#define EEPROM_6000_EEPROM_VERSION	(0x434)
+
 /* OTP */
 /* lower blocks contain EEPROM image and calibration data */
 #define OTP_LOW_IMAGE_SIZE		(2 * 512 * sizeof(u16)) /* 2 KB */
-- 
1.5.6.3

