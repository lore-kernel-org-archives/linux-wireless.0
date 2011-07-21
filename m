Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53534 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab1GUP0u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:50 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 18/25] iwlagn: remove forgotten debugfs function
Date: Thu, 21 Jul 2011 07:50:21 -0700
Message-Id: <1311259828-8415-19-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172715_357236_E53E1E98)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It seems that due to merge issues between different
trees or so this function prototype wasn't removed
when it should have been, do it now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 4529e2d..f9a407e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -78,8 +78,6 @@ static inline void iwl_print_hex_dump(struct iwl_priv *priv, int level,
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 int iwl_dbgfs_register(struct iwl_priv *priv, const char *name);
 void iwl_dbgfs_unregister(struct iwl_priv *priv);
-extern int iwl_dbgfs_statistics_flag(struct iwl_priv *priv, char *buf,
-				     int bufsz);
 #else
 static inline int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 {
-- 
1.7.0.4

