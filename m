Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32698 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab0KYBi3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 20:38:29 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/12] iwlagn: Offical name for 6000g2a device
Date: Wed, 24 Nov 2010 17:32:44 -0800
Message-Id: <1290648768-10075-9-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change to offical name for 6000g2a devices:
   "Intel(R) Centrino(R) Advanced-N 6205"

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 43eb99b..d087cb5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -553,7 +553,7 @@ static struct iwl_bt_params iwl6000_bt_params = {
 };
 
 struct iwl_cfg iwl6000g2a_2agn_cfg = {
-	.name = "6000 Series 2x2 AGN Gen2a",
+	.name = "Intel(R) Centrino(R) Advanced-N 6205 AGN",
 	.fw_name_pre = IWL6000G2A_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
@@ -569,7 +569,7 @@ struct iwl_cfg iwl6000g2a_2agn_cfg = {
 };
 
 struct iwl_cfg iwl6000g2a_2abg_cfg = {
-	.name = "6000 Series 2x2 ABG Gen2a",
+	.name = "Intel(R) Centrino(R) Advanced-N 6205 ABG",
 	.fw_name_pre = IWL6000G2A_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
@@ -584,7 +584,7 @@ struct iwl_cfg iwl6000g2a_2abg_cfg = {
 };
 
 struct iwl_cfg iwl6000g2a_2bg_cfg = {
-	.name = "6000 Series 2x2 BG Gen2a",
+	.name = "Intel(R) Centrino(R) Advanced-N 6205 BG",
 	.fw_name_pre = IWL6000G2A_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-- 
1.7.0.4

