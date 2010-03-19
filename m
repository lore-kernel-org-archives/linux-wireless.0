Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41167 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab0CSVOP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 17:14:15 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/9] iwlwifi: clean up driver names for 1000/5000/6000
Date: Fri, 19 Mar 2010 14:14:07 -0700
Message-Id: <1269033251-17545-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269033251-17545-1-git-send-email-reinette.chatre@intel.com>
References: <1269033251-17545-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

Align the driver names with official product names for 1000/5000/6000
series. This change mainly affects the debug messages show up in system
log. No functional changes.

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c |   14 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-6000.c |   12 ++++++------
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    2 +-
 5 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 59b092e..e31e8a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -223,7 +223,7 @@ static const struct iwl_ops iwl1000_ops = {
 };
 
 struct iwl_cfg iwl1000_bgn_cfg = {
-	.name = "1000 Series BGN",
+	.name = "Intel(R) Centrino(R) Wireless-N 1000 BGN",
 	.fw_name_pre = IWL1000_FW_PRE,
 	.ucode_api_max = IWL1000_UCODE_API_MAX,
 	.ucode_api_min = IWL1000_UCODE_API_MIN,
@@ -252,7 +252,7 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 };
 
 struct iwl_cfg iwl1000_bg_cfg = {
-	.name = "1000 Series BG",
+	.name = "Intel(R) Centrino(R) Wireless-N 1000 BG",
 	.fw_name_pre = IWL1000_FW_PRE,
 	.ucode_api_max = IWL1000_UCODE_API_MAX,
 	.ucode_api_min = IWL1000_UCODE_API_MIN,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 271576a..7f9e448 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2232,7 +2232,7 @@ static const struct iwl_ops iwl4965_ops = {
 };
 
 struct iwl_cfg iwl4965_agn_cfg = {
-	.name = "4965AGN",
+	.name = "Intel(R) Wireless WiFi Link 4965AGN",
 	.fw_name_pre = IWL4965_FW_PRE,
 	.ucode_api_max = IWL4965_UCODE_API_MAX,
 	.ucode_api_min = IWL4965_UCODE_API_MIN,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 046bdd9..8ab28a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1579,7 +1579,7 @@ struct iwl_mod_params iwl50_mod_params = {
 
 
 struct iwl_cfg iwl5300_agn_cfg = {
-	.name = "5300AGN",
+	.name = "Intel(R) Ultimate N WiFi Link 5300 AGN",
 	.fw_name_pre = IWL5000_FW_PRE,
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
@@ -1605,7 +1605,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 };
 
 struct iwl_cfg iwl5100_bgn_cfg = {
-	.name = "5100BGN",
+	.name = "Intel(R) WiFi Link 5100 BGN",
 	.fw_name_pre = IWL5000_FW_PRE,
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
@@ -1631,7 +1631,7 @@ struct iwl_cfg iwl5100_bgn_cfg = {
 };
 
 struct iwl_cfg iwl5100_abg_cfg = {
-	.name = "5100ABG",
+	.name = "Intel(R) WiFi Link 5100 ABG",
 	.fw_name_pre = IWL5000_FW_PRE,
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
@@ -1655,7 +1655,7 @@ struct iwl_cfg iwl5100_abg_cfg = {
 };
 
 struct iwl_cfg iwl5100_agn_cfg = {
-	.name = "5100AGN",
+	.name = "Intel(R) WiFi Link 5100 AGN",
 	.fw_name_pre = IWL5000_FW_PRE,
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
@@ -1681,7 +1681,7 @@ struct iwl_cfg iwl5100_agn_cfg = {
 };
 
 struct iwl_cfg iwl5350_agn_cfg = {
-	.name = "5350AGN",
+	.name = "Intel(R) WiMAX/WiFi Link 5350 AGN",
 	.fw_name_pre = IWL5000_FW_PRE,
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
@@ -1707,7 +1707,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 };
 
 struct iwl_cfg iwl5150_agn_cfg = {
-	.name = "5150AGN",
+	.name = "Intel(R) WiMAX/WiFi Link 5150 AGN",
 	.fw_name_pre = IWL5150_FW_PRE,
 	.ucode_api_max = IWL5150_UCODE_API_MAX,
 	.ucode_api_min = IWL5150_UCODE_API_MIN,
@@ -1733,7 +1733,7 @@ struct iwl_cfg iwl5150_agn_cfg = {
 };
 
 struct iwl_cfg iwl5150_abg_cfg = {
-	.name = "5150ABG",
+	.name = "Intel(R) WiMAX/WiFi Link 5150 ABG",
 	.fw_name_pre = IWL5150_FW_PRE,
 	.ucode_api_max = IWL5150_UCODE_API_MAX,
 	.ucode_api_min = IWL5150_UCODE_API_MIN,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 4b7bc00..fb70122 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -357,7 +357,7 @@ static const struct iwl_ops iwl6050_ops = {
  * "i": Internal configuration, use internal Power Amplifier
  */
 struct iwl_cfg iwl6000i_2agn_cfg = {
-	.name = "6000 Series 2x2 AGN",
+	.name = "Intel(R) Centrino(R) Advanced-N 6200 AGN",
 	.fw_name_pre = IWL6000_FW_PRE,
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
@@ -389,7 +389,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 };
 
 struct iwl_cfg iwl6000i_2abg_cfg = {
-	.name = "6000 Series 2x2 ABG",
+	.name = "Intel(R) Centrino(R) Advanced-N 6200 ABG",
 	.fw_name_pre = IWL6000_FW_PRE,
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
@@ -420,7 +420,7 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 };
 
 struct iwl_cfg iwl6000i_2bg_cfg = {
-	.name = "6000 Series 2x2 BG",
+	.name = "Intel(R) Centrino(R) Advanced-N 6200 BG",
 	.fw_name_pre = IWL6000_FW_PRE,
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
@@ -451,7 +451,7 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
-	.name = "6050 Series 2x2 AGN",
+	.name = "Intel(R) Centrino(R) Advanced-N + WiMAX 6250 AGN",
 	.fw_name_pre = IWL6050_FW_PRE,
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
@@ -483,7 +483,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 };
 
 struct iwl_cfg iwl6050_2abg_cfg = {
-	.name = "6050 Series 2x2 ABG",
+	.name = "Intel(R) Centrino(R) Advanced-N + WiMAX 6250 ABG",
 	.fw_name_pre = IWL6050_FW_PRE,
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
@@ -514,7 +514,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
-	.name = "6000 Series 3x3 AGN",
+	.name = "Intel(R) Centrino(R) Ultimate-N 6300 AGN",
 	.fw_name_pre = IWL6000_FW_PRE,
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4b4b476..93931b6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3477,7 +3477,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
 	iwl_hw_detect(priv);
-	IWL_INFO(priv, "Detected Intel Wireless WiFi Link %s REV=0x%X\n",
+	IWL_INFO(priv, "Detected %s, REV=0x%X\n",
 		priv->cfg->name, priv->hw_rev);
 
 	/* We disable the RETRY_TIMEOUT register (0x41) to keep
-- 
1.6.3.3

