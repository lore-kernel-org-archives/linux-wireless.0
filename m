Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50112 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753292AbdBTNYo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 08:24:44 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>
Subject: [PATCH 5/6] mac80211: fix typo in debug print
Date: Mon, 20 Feb 2017 14:24:38 +0100
Message-Id: <20170220132439.16064-5-johannes@sipsolutions.net> (sfid-20170220_142500_971786_F764DE95)
In-Reply-To: <20170220132439.16064-1-johannes@sipsolutions.net>
References: <20170220132439.16064-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 3b5fd4188f2a..4463c61d068e 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -85,7 +85,7 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 	ht_dbg(sta->sdata,
 	       "Rx BA session stop requested for %pM tid %u %s reason: %d\n",
 	       sta->sta.addr, tid,
-	       initiator == WLAN_BACK_RECIPIENT ? "recipient" : "inititator",
+	       initiator == WLAN_BACK_RECIPIENT ? "recipient" : "initiator",
 	       (int)reason);
 
 	if (drv_ampdu_action(local, sta->sdata, &params))
-- 
2.9.3
