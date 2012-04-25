Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31159 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab2DYPPg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 11:15:36 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3.4] iwlwifi: use 6000G2B for 6030 device series
Date: Wed, 25 Apr 2012 08:10:08 -0700
Message-Id: <1335366608-23300-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120425_171542_663603_CB09BA34)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"iwlwifi: use correct released ucode version" change
the ucode api ok from 6000G2 to 6000G2B, but it shall belong
to 6030 device series, not the 6005 device series. Fix it

Cc: stable@vger.kernel.org #3.3+
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
this patch will be also available from wireless branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-6000.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index b1b6951..f0c9150 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -336,7 +336,7 @@ static const struct iwl_bt_params iwl6000_bt_params = {
 #define IWL_DEVICE_6005						\
 	.fw_name_pre = IWL6005_FW_PRE,				\
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
-	.ucode_api_ok = IWL6000G2B_UCODE_API_OK,		\
+	.ucode_api_ok = IWL6000G2_UCODE_API_OK,			\
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
@@ -390,7 +390,7 @@ const struct iwl_cfg iwl6005_2agn_mow2_cfg = {
 #define IWL_DEVICE_6030						\
 	.fw_name_pre = IWL6030_FW_PRE,				\
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
-	.ucode_api_ok = IWL6000G2_UCODE_API_OK,			\
+	.ucode_api_ok = IWL6000G2B_UCODE_API_OK,		\
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
-- 
1.7.0.4

