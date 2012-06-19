Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40495 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab2FSOvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 10:51:31 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 14/17] mac80211: remove unused function
Date: Tue, 19 Jun 2012 16:50:53 +0200
Message-Id: <1340117456-10154-15-git-send-email-johannes@sipsolutions.net> (sfid-20120619_165138_975530_C409B0FF)
In-Reply-To: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
References: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Remove the unused function is_ieee80211_device().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index af25c4e..6f39beb 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -175,12 +175,6 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 	return cpu_to_le16(dur);
 }
 
-static inline int is_ieee80211_device(struct ieee80211_local *local,
-				      struct net_device *dev)
-{
-	return local == wdev_priv(dev->ieee80211_ptr);
-}
-
 /* tx handlers */
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
-- 
1.7.10

