Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23370 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764164AbZDAV1s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2009 17:27:48 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/3] iwlwifi: adding triple stream rate support for MIMO3
Date: Wed,  1 Apr 2009 14:33:23 -0700
Message-Id: <1238621605-14846-2-git-send-email-reinette.chatre@intel.com> (sfid-20090401_232755_420653_26D25384)
In-Reply-To: <1238621605-14846-1-git-send-email-reinette.chatre@intel.com>
References: <1238621605-14846-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Adding ht triple_stream_basic_rates for MIMO3 supports

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 02fa5c7..0e290ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1117,6 +1117,7 @@ void iwl_connection_init_rx_config(struct iwl_priv *priv, int mode)
 	memcpy(priv->staging_rxon.wlap_bssid_addr, priv->mac_addr, ETH_ALEN);
 	priv->staging_rxon.ofdm_ht_single_stream_basic_rates = 0xff;
 	priv->staging_rxon.ofdm_ht_dual_stream_basic_rates = 0xff;
+	priv->staging_rxon.ofdm_ht_triple_stream_basic_rates = 0xff;
 }
 EXPORT_SYMBOL(iwl_connection_init_rx_config);
 
-- 
1.5.6.3

