Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39458 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab0DSJDP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 05:03:15 -0400
Subject: [PATCH] mac80211: add missing newline
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 11:03:13 +0200
Message-ID: <1271667793.3873.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One HT debugging printk is missing a newline,
add it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/agg-tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2010-04-19 10:53:23.000000000 +0200
+++ wireless-testing/net/mac80211/agg-tx.c	2010-04-19 10:53:52.000000000 +0200
@@ -185,7 +185,7 @@ static void sta_addba_resp_timer_expired
 		spin_unlock_bh(&sta->lock);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "timer expired on tid %d but we are not "
-				"(or no longer) expecting addBA response there",
+				"(or no longer) expecting addBA response there\n",
 			tid);
 #endif
 		return;


