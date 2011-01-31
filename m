Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:60551 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab1AaVxU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 16:53:20 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/11] iwlagn: use 2030 macro for 2030 devices
Date: Mon, 31 Jan 2011 13:40:45 -0800
Message-Id: <1296510047-24576-10-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1296510047-24576-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1296510047-24576-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For 2030 series of devices, 2030 macro need to be used.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 8d637e7..3c5dd36 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -462,13 +462,13 @@ struct iwl_cfg iwl2000_2bg_cfg = {
 
 struct iwl_cfg iwl2030_2bgn_cfg = {
 	.name = "2000 Series 2x2 BGN/BT",
-	IWL_DEVICE_2000,
+	IWL_DEVICE_2030,
 	.ht_params = &iwl2000_ht_params,
 };
 
 struct iwl_cfg iwl2030_2bg_cfg = {
 	.name = "2000 Series 2x2 BG/BT",
-	IWL_DEVICE_2000,
+	IWL_DEVICE_2030,
 };
 
 #define IWL_DEVICE_6035						\
-- 
1.7.0.4

