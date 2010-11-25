Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32698 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455Ab0KYBib (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 20:38:31 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/12] iwlagn: Offical name for 100/130 device
Date: Wed, 24 Nov 2010 17:32:46 -0800
Message-Id: <1290648768-10075-11-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change to offical name for 100 devices:
   "Intel(R) Centrino(R) Wireless-N 100"

Change to offical name for 130 devices:
   "Intel(R) Centrino(R) Wireless-N 130"

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-6000.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 9170120..fb3e371 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -301,7 +301,7 @@ struct iwl_cfg iwl1000_bg_cfg = {
 };
 
 struct iwl_cfg iwl100_bgn_cfg = {
-	.name = "Intel(R) 100 Series 1x1 BGN",
+	.name = "Intel(R) Centrino(R) Wireless-N 100 BGN",
 	.fw_name_pre = IWL100_FW_PRE,
 	.ucode_api_max = IWL100_UCODE_API_MAX,
 	.ucode_api_min = IWL100_UCODE_API_MIN,
@@ -315,7 +315,7 @@ struct iwl_cfg iwl100_bgn_cfg = {
 };
 
 struct iwl_cfg iwl100_bg_cfg = {
-	.name = "Intel(R) 100 Series 1x1 BG",
+	.name = "Intel(R) Centrino(R) Wireless-N 100 BG",
 	.fw_name_pre = IWL100_FW_PRE,
 	.ucode_api_max = IWL100_UCODE_API_MAX,
 	.ucode_api_min = IWL100_UCODE_API_MIN,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 3591dc8..ec41f27 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -827,7 +827,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 };
 
 struct iwl_cfg iwl130_bgn_cfg = {
-	.name = "Intel(R) 130 Series 1x1 BGN",
+	.name = "Intel(R) Centrino(R) Wireless-N 130 BGN",
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
@@ -846,7 +846,7 @@ struct iwl_cfg iwl130_bgn_cfg = {
 };
 
 struct iwl_cfg iwl130_bg_cfg = {
-	.name = "Intel(R) 130 Series 1x2 BG",
+	.name = "Intel(R) Centrino(R) Wireless-N 130 BG",
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-- 
1.7.0.4

