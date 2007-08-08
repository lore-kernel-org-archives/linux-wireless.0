Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758416AbXHHHhg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:37:36 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ian Schram <ischram@telenet.be>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 14/28] iwlwifi: remove redundant quotes
Date: Wed,  8 Aug 2007 15:33:31 +0800
Message-Id: <11865584583336-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584562811-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
 <11865584413292-git-send-email-yi.zhu@intel.com>
 <1186558443548-git-send-email-yi.zhu@intel.com>
 <11865584452614-git-send-email-yi.zhu@intel.com>
 <11865584473732-git-send-email-yi.zhu@intel.com>
 <11865584503648-git-send-email-yi.zhu@intel.com>
 <11865584521358-git-send-email-yi.zhu@intel.com>
 <11865584543903-git-send-email-yi.zhu@intel.com>
 <11865584562811-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Schram <ischram@telenet.be>

Remove some redundant quotes that probably originated
from moving code around.

Signed-of-by: Ian Schram <ischram@telenet.be>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-base.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 8863953..25931f5 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -1326,7 +1326,7 @@ static int iwl_add_sta_sync_callback(struct iwl_priv *priv,
 	struct iwl_rx_packet *res = NULL;
 
 	if (!skb) {
-		IWL_ERROR("Error: Response NULL in " "REPLY_ADD_STA.\n");
+		IWL_ERROR("Error: Response NULL in REPLY_ADD_STA.\n");
 		return 1;
 	}
 
@@ -2589,8 +2589,8 @@ static int iwl_set_mode(struct iwl_priv *priv, int mode)
 	cancel_delayed_work(&priv->scan_check);
 	priv->status &= ~STATUS_SCAN_PENDING;
 	if (iwl_scan_cancel(priv, 100)) {
-		IWL_WARNING("Aborted scan still in progress " "after 100ms\n");
-		IWL_DEBUG_MAC80211("leaving - scan abort " "failed.\n");
+		IWL_WARNING("Aborted scan still in progress after 100ms\n");
+		IWL_DEBUG_MAC80211("leaving - scan abort failed.\n");
 		return -EAGAIN;
 	}
 
@@ -7624,7 +7624,7 @@ static int iwl_mac_config_interface(struct ieee80211_hw *hw, int if_id,
 		if (iwl_scan_cancel(priv, 100)) {
 			IWL_WARNING("Aborted scan still in progress "
 				    "after 100ms\n");
-			IWL_DEBUG_MAC80211("leaving - scan abort " "failed.\n");
+			IWL_DEBUG_MAC80211("leaving - scan abort failed.\n");
 			mutex_unlock(&priv->mutex);
 			return -EAGAIN;
 		}
-- 
1.5.2
