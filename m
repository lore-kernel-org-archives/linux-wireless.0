Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49315 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932651Ab0EMVuT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 17:50:19 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/17] iwlwifi: modify out-dated comments
Date: Thu, 13 May 2010 14:49:55 -0700
Message-Id: <1273787399-9280-14-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
References: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Some comments in iwl-dev.h still refer to 4965 but used by all the _agn
devices.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8b2d06c..05a7a0d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1096,7 +1096,7 @@ struct iwl_priv {
 	/* force reset */
 	struct iwl_force_reset force_reset[IWL_MAX_FORCE_RESET];
 
-	/* we allocate array of iwl4965_channel_info for NIC's valid channels.
+	/* we allocate array of iwl_channel_info for NIC's valid channels.
 	 *    Access via channel # using indirect index array */
 	struct iwl_channel_info *channel_info;	/* channel info array */
 	u8 channel_count;	/* # of channels */
@@ -1161,7 +1161,7 @@ struct iwl_priv {
 	struct iwl_switch_rxon switch_rxon;
 
 	/* 1st responses from initialize and runtime uCode images.
-	 * 4965's initialize alive response contains some calibration data. */
+	 * _agn's initialize alive response contains some calibration data. */
 	struct iwl_init_alive_resp card_alive_init;
 	struct iwl_alive_resp card_alive;
 
-- 
1.6.3.3

