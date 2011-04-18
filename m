Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37034 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026Ab1DRRFm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 13:05:42 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/10] iwlagn: remove led_ops
Date: Mon, 18 Apr 2011 09:44:17 -0700
Message-Id: <1303145057-6545-11-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No longer use, remove it

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 99a91bd..32a990f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -186,10 +186,6 @@ struct iwl_lib_ops {
 	struct iwl_debugfs_ops debugfs_ops;
 };
 
-struct iwl_led_ops {
-	int (*cmd)(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd);
-};
-
 /* NIC specific ops */
 struct iwl_nic_ops {
 	void (*additional_nic_config)(struct iwl_priv *priv);
-- 
1.7.0.4

