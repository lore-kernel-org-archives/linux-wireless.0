Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36634 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752337AbdI2QqW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 12:46:22 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 29 Sep 2017 19:44:20 +0300
Message-Id: <20170929164423.23666-16-luca@coelho.fi> (sfid-20170929_200836_117911_26B912A6)
In-Reply-To: <20170929164423.23666-1-luca@coelho.fi>
References: <20170929164423.23666-1-luca@coelho.fi>
Subject: [PATCH 15/18] iwlwifi: fix indentation in a000 family configuration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Fix the double indentation in the configuration structs
for a000 family devices.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c | 100 +++++++++++++-------------
 1 file changed, 50 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/a000.c b/drivers/net/wireless/intel/iwlwifi/cfg/a000.c
index ed8bccd228f8..076f8d6d1124 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/a000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/a000.c
@@ -138,74 +138,74 @@ static const struct iwl_ht_params iwl_a000_ht_params = {
 	.tx_cmd_queue_size = 32
 
 const struct iwl_cfg iwla000_2ac_cfg_hr = {
-		.name = "Intel(R) Dual Band Wireless AC a000",
-		.fw_name_pre = IWL_A000_HR_FW_PRE,
-		IWL_DEVICE_A000,
-		.ht_params = &iwl_a000_ht_params,
-		.nvm_ver = IWL_A000_NVM_VERSION,
-		.nvm_calib_ver = IWL_A000_TX_POWER_VERSION,
-		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+	.name = "Intel(R) Dual Band Wireless AC a000",
+	.fw_name_pre = IWL_A000_HR_FW_PRE,
+	IWL_DEVICE_A000,
+	.ht_params = &iwl_a000_ht_params,
+	.nvm_ver = IWL_A000_NVM_VERSION,
+	.nvm_calib_ver = IWL_A000_TX_POWER_VERSION,
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
 const struct iwl_cfg iwla000_2ac_cfg_hr_cdb = {
-		.name = "Intel(R) Dual Band Wireless AC a000",
-		.fw_name_pre = IWL_A000_HR_CDB_FW_PRE,
-		IWL_DEVICE_A000,
-		.ht_params = &iwl_a000_ht_params,
-		.nvm_ver = IWL_A000_NVM_VERSION,
-		.nvm_calib_ver = IWL_A000_TX_POWER_VERSION,
-		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
-		.cdb = true,
+	.name = "Intel(R) Dual Band Wireless AC a000",
+	.fw_name_pre = IWL_A000_HR_CDB_FW_PRE,
+	IWL_DEVICE_A000,
+	.ht_params = &iwl_a000_ht_params,
+	.nvm_ver = IWL_A000_NVM_VERSION,
+	.nvm_calib_ver = IWL_A000_TX_POWER_VERSION,
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+	.cdb = true,
 };
 
 const struct iwl_cfg iwla000_2ac_cfg_jf = {
-		.name = "Intel(R) Dual Band Wireless AC a000",
-		.fw_name_pre = IWL_A000_JF_FW_PRE,
-		IWL_DEVICE_A000,
-		.ht_params = &iwl_a000_ht_params,
-		.nvm_ver = IWL_A000_NVM_VERSION,
-		.nvm_calib_ver = IWL_A000_TX_POWER_VERSION,
-		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+	.name = "Intel(R) Dual Band Wireless AC a000",
+	.fw_name_pre = IWL_A000_JF_FW_PRE,
+	IWL_DEVICE_A000,
+	.ht_params = &iwl_a000_ht_params,
+	.nvm_ver = IWL_A000_NVM_VERSION,
+	.nvm_calib_ver = IWL_A000_TX_POWER_VERSION,
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
 const struct iwl_cfg iwla000_2ax_cfg_hr = {
-		.name = "Intel(R) Dual Band Wireless AX a000",
-		.fw_name_pre = IWL_A000_HR_FW_PRE,
-		IWL_DEVICE_A000,
-		.ht_params = &iwl_a000_ht_params,
-		.nvm_ver = IWL_A000_NVM_VERSION,
-		.nvm_calib_ver = IWL_A000_TX_POWER_VERSION,
-		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+	.name = "Intel(R) Dual Band Wireless AX a000",
+	.fw_name_pre = IWL_A000_HR_FW_PRE,
+	IWL_DEVICE_A000,
+	.ht_params = &iwl_a000_ht_params,
+	.nvm_ver = IWL_A000_NVM_VERSION,
+	.nvm_calib_ver = IWL_A000_TX_POWER_VERSION,
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
 const struct iwl_cfg iwla000_2ax_cfg_qnj_hr_f0 = {
-		.name = "Intel(R) Dual Band Wireless AX a000",
-		.fw_name_pre = IWL_A000_HR_F0_FW_PRE,
-		IWL_DEVICE_A000,
-		.ht_params = &iwl_a000_ht_params,
-		.nvm_ver = IWL_A000_NVM_VERSION,
-		.nvm_calib_ver = IWL_A000_TX_POWER_VERSION,
-		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+	.name = "Intel(R) Dual Band Wireless AX a000",
+	.fw_name_pre = IWL_A000_HR_F0_FW_PRE,
+	IWL_DEVICE_A000,
+	.ht_params = &iwl_a000_ht_params,
+	.nvm_ver = IWL_A000_NVM_VERSION,
+	.nvm_calib_ver = IWL_A000_TX_POWER_VERSION,
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
 const struct iwl_cfg iwla000_2ax_cfg_qnj_jf_b0 = {
-		.name = "Intel(R) Dual Band Wireless AX a000",
-		.fw_name_pre = IWL_A000_JF_B0_FW_PRE,
-		IWL_DEVICE_A000,
-		.ht_params = &iwl_a000_ht_params,
-		.nvm_ver = IWL_A000_NVM_VERSION,
-		.nvm_calib_ver = IWL_A000_TX_POWER_VERSION,
-		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+	.name = "Intel(R) Dual Band Wireless AX a000",
+	.fw_name_pre = IWL_A000_JF_B0_FW_PRE,
+	IWL_DEVICE_A000,
+	.ht_params = &iwl_a000_ht_params,
+	.nvm_ver = IWL_A000_NVM_VERSION,
+	.nvm_calib_ver = IWL_A000_TX_POWER_VERSION,
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
 const struct iwl_cfg iwla000_2ax_cfg_qnj_hr_a0 = {
-		.name = "Intel(R) Dual Band Wireless AX a000",
-		.fw_name_pre = IWL_A000_HR_A0_FW_PRE,
-		IWL_DEVICE_A000,
-		.ht_params = &iwl_a000_ht_params,
-		.nvm_ver = IWL_A000_NVM_VERSION,
-		.nvm_calib_ver = IWL_A000_TX_POWER_VERSION,
-		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+	.name = "Intel(R) Dual Band Wireless AX a000",
+	.fw_name_pre = IWL_A000_HR_A0_FW_PRE,
+	IWL_DEVICE_A000,
+	.ht_params = &iwl_a000_ht_params,
+	.nvm_ver = IWL_A000_NVM_VERSION,
+	.nvm_calib_ver = IWL_A000_TX_POWER_VERSION,
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
 MODULE_FIRMWARE(IWL_A000_HR_MODULE_FIRMWARE(IWL_A000_UCODE_API_MAX));
-- 
2.14.1
