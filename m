Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46204 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756237Ab1AaVxU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 16:53:20 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/11] iiwlagn: remove unused parameter
Date: Mon, 31 Jan 2011 13:40:47 -0800
Message-Id: <1296510047-24576-12-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1296510047-24576-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1296510047-24576-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sco_cmd is not being used, remove it

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 600f417..d4ba335 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -2023,7 +2023,6 @@ void iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
 	unsigned long flags;
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_bt_coex_profile_notif *coex = &pkt->u.bt_coex_profile_notif;
-	struct iwlagn_bt_sco_cmd sco_cmd = { .flags = 0 };
 	struct iwl_bt_uart_msg *uart_msg = &coex->last_bt_uart_msg;
 
 	IWL_DEBUG_NOTIF(priv, "BT Coex notification:\n");
-- 
1.7.0.4

