Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12096 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898Ab1GHQUk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 12:20:40 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/21] iwlagn: declare static
Date: Fri,  8 Jul 2011 08:46:24 -0700
Message-Id: <1310139989-27661-17-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110708_182059_595205_ECC05954)
In-Reply-To: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Declare iwl_mac_rssi_callback as "static"

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index cbd8d10..3f2b9d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3342,7 +3342,7 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 	kfree(priv->beacon_cmd);
 }
 
-void iwl_mac_rssi_callback(struct ieee80211_hw *hw,
+static void iwl_mac_rssi_callback(struct ieee80211_hw *hw,
 			   enum ieee80211_rssi_event rssi_event)
 {
 	struct iwl_priv *priv = hw->priv;
-- 
1.7.0.4

