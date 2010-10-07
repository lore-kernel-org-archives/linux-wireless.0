Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:65013 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934Ab0JGABo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 20:01:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/2] iwlagn: fix module firmware name for 130 series device
Date: Wed,  6 Oct 2010 17:00:54 -0700
Message-Id: <1286409655-32679-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286409655-32679-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286409655-32679-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

130 series device should use firmware name with 130 in it.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 43ec898..b448b03 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -78,8 +78,8 @@
 #define IWL6000G2B_MODULE_FIRMWARE(api) _IWL6000G2B_MODULE_FIRMWARE(api)
 
 #define IWL130_FW_PRE "iwlwifi-130-"
-#define _IWL100_MODULE_FIRMWARE(api) IWL130_FW_PRE #api ".ucode"
-#define IWL100_MODULE_FIRMWARE(api) _IWL130_MODULE_FIRMWARE(api)
+#define _IWL130_MODULE_FIRMWARE(api) IWL130_FW_PRE #api ".ucode"
+#define IWL130_MODULE_FIRMWARE(api) _IWL130_MODULE_FIRMWARE(api)
 
 static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
 {
-- 
1.7.0.4

