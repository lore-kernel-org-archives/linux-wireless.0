Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:30517 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751841AbXKPIEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 03:04:04 -0500
From: Bruno Randolf <bruno@thinktube.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bruno Randolf <br1@einfach.org>,
	Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH] add missing space in error message
Date: Fri, 16 Nov 2007 17:04:01 +0900
Message-Id: <1195200241-25742-1-git-send-email-bruno@thinktube.com> (sfid-20071116_080409_645651_143DDD3C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bruno Randolf <br1@einfach.org>


Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---
 net/mac80211/ieee80211_sta.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 2079e98..dad5edb 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2644,7 +2644,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
 	local->sta_scanning = 0;
 
 	if (ieee80211_hw_config(local))
-		printk(KERN_DEBUG "%s: failed to restore operational"
+		printk(KERN_DEBUG "%s: failed to restore operational "
 		       "channel after scan\n", dev->name);
 
 
-- 
1.5.3.4

