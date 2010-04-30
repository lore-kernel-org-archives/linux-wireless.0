Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19515 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757359Ab0D3XAf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 19:00:35 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/8] iwlwifi: remove outdated comments
Date: Fri, 30 Apr 2010 16:00:19 -0700
Message-Id: <1272668425-3753-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1272668425-3753-1-git-send-email-reinette.chatre@intel.com>
References: <1272668425-3753-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

IEEE80211_CONF_SHORT_SLOT_TIME is no longer a possible setting in
ieee80211_conf->flags

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 457dc19..1cbc22a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2116,10 +2116,6 @@ EXPORT_SYMBOL(iwl_mac_remove_interface);
 
 /**
  * iwl_mac_config - mac80211 config callback
- *
- * We ignore conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME since it seems to
- * be set inappropriately and the driver currently sets the hardware up to
- * use it whenever needed.
  */
 int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 {
-- 
1.6.3.3

