Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42809 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbXIFNqB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 09:46:01 -0400
Message-Id: <20070905234627.193670000@sipsolutions.net>
References: <20070905234209.108005000@sipsolutions.net>
Date: Thu, 06 Sep 2007 01:42:21 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 12/21] mac80211: remove tx info sw_retry_attempt member
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is unused.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/mac80211.h |    3 ---
 1 file changed, 3 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-09-06 01:35:19.614453431 +0200
+++ wireless-dev/include/net/mac80211.h	2007-09-06 01:35:21.044453431 +0200
@@ -282,9 +282,6 @@ struct ieee80211_tx_control {
 	u8 iv_len;		/* length of the IV field in octets */
 	u8 queue;		/* hardware queue to use for this frame;
 				 * 0 = highest, hw->queues-1 = lowest */
-	u8 sw_retry_attempt;	/* number of times hw has tried to
-				 * transmit frame (not incl. hw retries) */
-
 	struct ieee80211_rate *rate;		/* internal 80211.o rate */
 	struct ieee80211_rate *rts_rate;	/* internal 80211.o rate
 						 * for RTS/CTS */

-- 

