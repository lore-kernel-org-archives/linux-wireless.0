Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26773 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbYFLRIY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 13:08:24 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] mac80211: add missing new line in debug print HT_DEBUG
Date: Thu, 12 Jun 2008 20:08:19 +0300
Message-Id: <1213290499-4358-1-git-send-email-tomas.winkler@intel.com> (sfid-20080612_190827_454669_7DD0A299)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds '\n' in debug printk (wme.c HT DEBUG)

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/wme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 14a9ff1..fb764f2 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -645,7 +645,7 @@ int ieee80211_ht_agg_queue_add(struct ieee80211_local *local,
 #ifdef CONFIG_MAC80211_HT_DEBUG
 			if (net_ratelimit())
 				printk(KERN_DEBUG "allocated aggregation queue"
-					" %d tid %d addr %s pool=0x%lX",
+					" %d tid %d addr %s pool=0x%lX\n",
 					i, tid, print_mac(mac, sta->addr),
 					q->qdisc_pool[0]);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

