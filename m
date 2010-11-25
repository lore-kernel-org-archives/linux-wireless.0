Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32698 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab0KYBia (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 20:38:30 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/12] iwlagn: Offical name for 6000g2b device
Date: Wed, 24 Nov 2010 17:32:45 -0800
Message-Id: <1290648768-10075-10-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change to offical name for 6000g2b devices:
   "Intel(R) Centrino(R) Wireless-N 1030"
   "Intel(R) Centrino(R) Advanced-N 6230"

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index d087cb5..3591dc8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -599,7 +599,7 @@ struct iwl_cfg iwl6000g2a_2bg_cfg = {
 };
 
 struct iwl_cfg iwl6000g2b_2agn_cfg = {
-	.name = "6000 Series 2x2 AGN Gen2b",
+	.name = "Intel(R) Centrino(R) Advanced-N 6230 AGN",
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
@@ -619,7 +619,7 @@ struct iwl_cfg iwl6000g2b_2agn_cfg = {
 };
 
 struct iwl_cfg iwl6000g2b_2abg_cfg = {
-	.name = "6000 Series 2x2 ABG Gen2b",
+	.name = "Intel(R) Centrino(R) Advanced-N 6230 ABG",
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
@@ -638,7 +638,7 @@ struct iwl_cfg iwl6000g2b_2abg_cfg = {
 };
 
 struct iwl_cfg iwl6000g2b_2bgn_cfg = {
-	.name = "6000 Series 2x2 BGN Gen2b",
+	.name = "Intel(R) Centrino(R) Advanced-N 6230 BGN",
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
@@ -658,7 +658,7 @@ struct iwl_cfg iwl6000g2b_2bgn_cfg = {
 };
 
 struct iwl_cfg iwl6000g2b_2bg_cfg = {
-	.name = "6000 Series 2x2 BG Gen2b",
+	.name = "Intel(R) Centrino(R) Advanced-N 6230 BG",
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
@@ -677,7 +677,7 @@ struct iwl_cfg iwl6000g2b_2bg_cfg = {
 };
 
 struct iwl_cfg iwl6000g2b_bgn_cfg = {
-	.name = "6000 Series 1x2 BGN Gen2b",
+	.name = "Intel(R) Centrino(R) Wireless-N 1030 BGN",
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
@@ -697,7 +697,7 @@ struct iwl_cfg iwl6000g2b_bgn_cfg = {
 };
 
 struct iwl_cfg iwl6000g2b_bg_cfg = {
-	.name = "6000 Series 1x2 BG Gen2b",
+	.name = "Intel(R) Centrino(R) Wireless-N 1030 BG",
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-- 
1.7.0.4

