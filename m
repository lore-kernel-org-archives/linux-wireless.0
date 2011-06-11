Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45464 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758586Ab1FKOzl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 10:55:41 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/18] iwlagn: add coex debug flag
Date: Sat, 11 Jun 2011 07:25:43 -0700
Message-Id: <1307802352-16398-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110611_165722_552993_9912BD65)
In-Reply-To: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace IWL_DEBUG_AP with IWL_DEBUG_COEX for debug COEX related stuffs

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 2824ccb..fd68ce8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -131,7 +131,7 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
 #define IWL_DL_ASSOC		(1 << 12)
 #define IWL_DL_DROP		(1 << 13)
 #define IWL_DL_TXPOWER		(1 << 14)
-#define IWL_DL_AP		(1 << 15)
+#define IWL_DL_COEX		(1 << 15)
 /* 0x000F0000 - 0x00010000 */
 #define IWL_DL_FW		(1 << 16)
 #define IWL_DL_RF_KILL		(1 << 17)
@@ -171,7 +171,7 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
 #define IWL_DEBUG_DROP(p, f, a...)	IWL_DEBUG(p, IWL_DL_DROP, f, ## a)
 #define IWL_DEBUG_DROP_LIMIT(p, f, a...)	\
 		IWL_DEBUG_LIMIT(p, IWL_DL_DROP, f, ## a)
-#define IWL_DEBUG_AP(p, f, a...)	IWL_DEBUG(p, IWL_DL_AP, f, ## a)
+#define IWL_DEBUG_COEX(p, f, a...)	IWL_DEBUG(p, IWL_DL_COEX, f, ## a)
 #define IWL_DEBUG_TXPOWER(p, f, a...)	IWL_DEBUG(p, IWL_DL_TXPOWER, f, ## a)
 #define IWL_DEBUG_RATE(p, f, a...)	IWL_DEBUG(p, IWL_DL_RATE, f, ## a)
 #define IWL_DEBUG_RATE_LIMIT(p, f, a...)	\
-- 
1.7.0.4

