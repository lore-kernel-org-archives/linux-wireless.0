Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47893 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637Ab2DWVw4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:56 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/29] iwlwifi: remove bt_siso_mode declaration
Date: Mon, 23 Apr 2012 14:47:24 -0700
Message-Id: <1335217660-21950-14-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235336_098364_EDC1BADB)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

That variable doesn't exist anywhere.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 199a0c0..6e5fb78 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -125,9 +125,4 @@ static inline void iwl_update_stats(struct iwl_priv *priv, bool is_tx,
 #define IWL_TRAFFIC_ENTRIES	(256)
 #define IWL_TRAFFIC_ENTRY_SIZE  (64)
 
-/*****************************************************
- *   S e n d i n g     H o s t     C o m m a n d s   *
- *****************************************************/
-extern bool bt_siso_mode;
-
 #endif /* __iwl_core_h__ */
-- 
1.7.0.4

