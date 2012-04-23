Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32825 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829Ab2DWVw5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:57 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 18/29] iwlwifi: remove duplicate iwlagn_mod_params declaration
Date: Mon, 23 Apr 2012 14:47:29 -0700
Message-Id: <1335217660-21950-19-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235325_500072_F2670847)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We only need one declaration, not multiple.
Keep the one in iwl-shared.h, which will
probably be renamed to iwl-modparams.h at
some point in the future.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 67e3b40..6853fc7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1019,7 +1019,6 @@ struct iwl_priv {
 }; /*iwl_priv */
 
 extern struct kmem_cache *iwl_tx_cmd_pool;
-extern struct iwl_mod_params iwlagn_mod_params;
 
 static inline struct iwl_rxon_context *
 iwl_rxon_ctx_from_vif(struct ieee80211_vif *vif)
-- 
1.7.0.4

