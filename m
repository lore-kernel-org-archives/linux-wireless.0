Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2615 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbaINSwL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2014 14:52:11 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Liad Kaufman <liad.kaufman@intel.com>
Subject: [PATCH] mac80211: fix warning on htmldocs for last_tdls_pkt_time
Date: Sun, 14 Sep 2014 21:48:28 +0300
Message-Id: <1410720508-19989-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140914_205215_752176_1AE22B7F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Forgot to add an entry to the struct description of sta_info.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/sta_info.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 7412716..8352e06 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -361,6 +361,7 @@ struct ieee80211_tx_latency_stat {
  * @known_smps_mode: the smps_mode the client thinks we are in. Relevant for
  *	AP only.
  * @cipher_scheme: optional cipher scheme for this station
+ * @last_tdls_pkt_time: holds the time in jiffies of last TDLS pkt ACKed
  */
 struct sta_info {
 	/* General information, mostly static */
-- 
1.9.1

