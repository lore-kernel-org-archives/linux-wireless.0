Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13247 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757617Ab0LBQ5x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 11:57:53 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/5] iwlagn: remove structure name reference to gen2
Date: Thu,  2 Dec 2010 08:51:22 -0800
Message-Id: <1291308684-3279-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1291308684-3279-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1291308684-3279-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Give the corresponding name for .cfg data structure

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   20 +++++-----
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   58 +++++++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-agn.h  |   20 +++++-----
 3 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index ec41f27..8018f38 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -552,7 +552,7 @@ static struct iwl_bt_params iwl6000_bt_params = {
 	.bt_sco_disable = true,
 };
 
-struct iwl_cfg iwl6000g2a_2agn_cfg = {
+struct iwl_cfg iwl6005_2agn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6205 AGN",
 	.fw_name_pre = IWL6000G2A_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
@@ -568,7 +568,7 @@ struct iwl_cfg iwl6000g2a_2agn_cfg = {
 	.led_mode = IWL_LED_RF_STATE,
 };
 
-struct iwl_cfg iwl6000g2a_2abg_cfg = {
+struct iwl_cfg iwl6005_2abg_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6205 ABG",
 	.fw_name_pre = IWL6000G2A_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
@@ -583,7 +583,7 @@ struct iwl_cfg iwl6000g2a_2abg_cfg = {
 	.led_mode = IWL_LED_RF_STATE,
 };
 
-struct iwl_cfg iwl6000g2a_2bg_cfg = {
+struct iwl_cfg iwl6005_2bg_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6205 BG",
 	.fw_name_pre = IWL6000G2A_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
@@ -598,7 +598,7 @@ struct iwl_cfg iwl6000g2a_2bg_cfg = {
 	.led_mode = IWL_LED_RF_STATE,
 };
 
-struct iwl_cfg iwl6000g2b_2agn_cfg = {
+struct iwl_cfg iwl6030_2agn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6230 AGN",
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
@@ -618,7 +618,7 @@ struct iwl_cfg iwl6000g2b_2agn_cfg = {
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
 
-struct iwl_cfg iwl6000g2b_2abg_cfg = {
+struct iwl_cfg iwl6030_2abg_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6230 ABG",
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
@@ -637,7 +637,7 @@ struct iwl_cfg iwl6000g2b_2abg_cfg = {
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
 
-struct iwl_cfg iwl6000g2b_2bgn_cfg = {
+struct iwl_cfg iwl6030_2bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6230 BGN",
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
@@ -657,7 +657,7 @@ struct iwl_cfg iwl6000g2b_2bgn_cfg = {
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
 
-struct iwl_cfg iwl6000g2b_2bg_cfg = {
+struct iwl_cfg iwl6030_2bg_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6230 BG",
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
@@ -676,7 +676,7 @@ struct iwl_cfg iwl6000g2b_2bg_cfg = {
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
 
-struct iwl_cfg iwl6000g2b_bgn_cfg = {
+struct iwl_cfg iwl1030_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 1030 BGN",
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
@@ -696,7 +696,7 @@ struct iwl_cfg iwl6000g2b_bgn_cfg = {
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
 
-struct iwl_cfg iwl6000g2b_bg_cfg = {
+struct iwl_cfg iwl1030_bg_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 1030 BG",
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
@@ -782,7 +782,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.led_mode = IWL_LED_BLINK,
 };
 
-struct iwl_cfg iwl6050g2_bgn_cfg = {
+struct iwl_cfg iwl6150_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N + WiMAX 6150 BGN",
 	.fw_name_pre = IWL6050_FW_PRE,
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 50cee2b..9a6f7a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4419,31 +4419,31 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x4239, 0x1316, iwl6000i_2abg_cfg)},
 
 /* 6x00 Series Gen2a */
-	{IWL_PCI_DEVICE(0x0082, 0x1301, iwl6000g2a_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0082, 0x1306, iwl6000g2a_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x0082, 0x1307, iwl6000g2a_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x0082, 0x1321, iwl6000g2a_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0082, 0x1326, iwl6000g2a_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x0085, 0x1311, iwl6000g2a_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0085, 0x1316, iwl6000g2a_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1301, iwl6005_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1306, iwl6005_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1307, iwl6005_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1321, iwl6005_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1326, iwl6005_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0085, 0x1311, iwl6005_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0085, 0x1316, iwl6005_2abg_cfg)},
 
 /* 6x00 Series Gen2b */
-	{IWL_PCI_DEVICE(0x008A, 0x5305, iwl6000g2b_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x008A, 0x5307, iwl6000g2b_bg_cfg)},
-	{IWL_PCI_DEVICE(0x008A, 0x5325, iwl6000g2b_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x008A, 0x5327, iwl6000g2b_bg_cfg)},
-	{IWL_PCI_DEVICE(0x008B, 0x5315, iwl6000g2b_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x008B, 0x5317, iwl6000g2b_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0090, 0x5211, iwl6000g2b_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0090, 0x5215, iwl6000g2b_2bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0090, 0x5216, iwl6000g2b_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x0091, 0x5201, iwl6000g2b_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0091, 0x5205, iwl6000g2b_2bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0091, 0x5206, iwl6000g2b_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x0091, 0x5207, iwl6000g2b_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x0091, 0x5221, iwl6000g2b_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0091, 0x5225, iwl6000g2b_2bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0091, 0x5226, iwl6000g2b_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x008A, 0x5305, iwl1030_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x008A, 0x5307, iwl1030_bg_cfg)},
+	{IWL_PCI_DEVICE(0x008A, 0x5325, iwl1030_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x008A, 0x5327, iwl1030_bg_cfg)},
+	{IWL_PCI_DEVICE(0x008B, 0x5315, iwl1030_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x008B, 0x5317, iwl1030_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0090, 0x5211, iwl6030_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0090, 0x5215, iwl6030_2bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0090, 0x5216, iwl6030_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0091, 0x5201, iwl6030_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0091, 0x5205, iwl6030_2bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0091, 0x5206, iwl6030_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0091, 0x5207, iwl6030_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x0091, 0x5221, iwl6030_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0091, 0x5225, iwl6030_2bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0091, 0x5226, iwl6030_2abg_cfg)},
 
 /* 6x50 WiFi/WiMax Series */
 	{IWL_PCI_DEVICE(0x0087, 0x1301, iwl6050_2agn_cfg)},
@@ -4454,12 +4454,12 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x0089, 0x1316, iwl6050_2abg_cfg)},
 
 /* 6x50 WiFi/WiMax Series Gen2 */
-	{IWL_PCI_DEVICE(0x0885, 0x1305, iwl6050g2_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0885, 0x1306, iwl6050g2_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0885, 0x1325, iwl6050g2_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0885, 0x1326, iwl6050g2_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0886, 0x1315, iwl6050g2_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0886, 0x1316, iwl6050g2_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0885, 0x1305, iwl6150_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0885, 0x1306, iwl6150_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0885, 0x1325, iwl6150_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0885, 0x1326, iwl6150_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0886, 0x1315, iwl6150_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0886, 0x1316, iwl6150_bgn_cfg)},
 
 /* 1000 Series WiFi */
 	{IWL_PCI_DEVICE(0x0083, 0x1205, iwl1000_bgn_cfg)},
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 28837a1..da30358 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -74,22 +74,22 @@ extern struct iwl_cfg iwl5100_bgn_cfg;
 extern struct iwl_cfg iwl5100_abg_cfg;
 extern struct iwl_cfg iwl5150_agn_cfg;
 extern struct iwl_cfg iwl5150_abg_cfg;
-extern struct iwl_cfg iwl6000g2a_2agn_cfg;
-extern struct iwl_cfg iwl6000g2a_2abg_cfg;
-extern struct iwl_cfg iwl6000g2a_2bg_cfg;
-extern struct iwl_cfg iwl6000g2b_bgn_cfg;
-extern struct iwl_cfg iwl6000g2b_bg_cfg;
-extern struct iwl_cfg iwl6000g2b_2agn_cfg;
-extern struct iwl_cfg iwl6000g2b_2abg_cfg;
-extern struct iwl_cfg iwl6000g2b_2bgn_cfg;
-extern struct iwl_cfg iwl6000g2b_2bg_cfg;
+extern struct iwl_cfg iwl6005_2agn_cfg;
+extern struct iwl_cfg iwl6005_2abg_cfg;
+extern struct iwl_cfg iwl6005_2bg_cfg;
+extern struct iwl_cfg iwl1030_bgn_cfg;
+extern struct iwl_cfg iwl1030_bg_cfg;
+extern struct iwl_cfg iwl6030_2agn_cfg;
+extern struct iwl_cfg iwl6030_2abg_cfg;
+extern struct iwl_cfg iwl6030_2bgn_cfg;
+extern struct iwl_cfg iwl6030_2bg_cfg;
 extern struct iwl_cfg iwl6000i_2agn_cfg;
 extern struct iwl_cfg iwl6000i_2abg_cfg;
 extern struct iwl_cfg iwl6000i_2bg_cfg;
 extern struct iwl_cfg iwl6000_3agn_cfg;
 extern struct iwl_cfg iwl6050_2agn_cfg;
 extern struct iwl_cfg iwl6050_2abg_cfg;
-extern struct iwl_cfg iwl6050g2_bgn_cfg;
+extern struct iwl_cfg iwl6150_bgn_cfg;
 extern struct iwl_cfg iwl1000_bgn_cfg;
 extern struct iwl_cfg iwl1000_bg_cfg;
 extern struct iwl_cfg iwl100_bgn_cfg;
-- 
1.7.0.4

