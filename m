Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59561 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084AbZEHTXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 15:23:13 -0400
Subject: [PATCH] mac80211: remove ieee80211_ht_bss_info
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 08 May 2009 21:21:41 +0200
Message-Id: <1241810501.5233.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This struct is no longer used (and hasn't been for a while).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |   16 ----------------
 1 file changed, 16 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-05-08 21:18:20.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-05-08 21:18:28.000000000 +0200
@@ -73,22 +73,6 @@
  */
 
 /**
- * struct ieee80211_ht_bss_info - describing BSS's HT characteristics
- *
- * This structure describes most essential parameters needed
- * to describe 802.11n HT characteristics in a BSS.
- *
- * @primary_channel: channel number of primery channel
- * @bss_cap: 802.11n's general BSS capabilities (e.g. channel width)
- * @bss_op_mode: 802.11n's BSS operation modes (e.g. HT protection)
- */
-struct ieee80211_ht_bss_info {
-	u8 primary_channel;
-	u8 bss_cap;  /* use IEEE80211_HT_IE_CHA_ */
-	u8 bss_op_mode; /* use IEEE80211_HT_IE_ */
-};
-
-/**
  * enum ieee80211_max_queues - maximum number of queues
  *
  * @IEEE80211_MAX_QUEUES: Maximum number of regular device queues.


