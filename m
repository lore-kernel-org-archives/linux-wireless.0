Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54767 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbXHWQtX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 12:49:23 -0400
Received: from [131.234.79.133]
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1IOFrx-0000zc-7D
	for linux-wireless@vger.kernel.org; Thu, 23 Aug 2007 17:49:17 +0100
Message-Id: <20070823164523.034503000@sipsolutions.net>
References: <20070823164500.998912000@sipsolutions.net>
Date: Thu, 23 Aug 2007 18:45:06 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 05/11] mac80211: remove tx info sw_retry_attempt member
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is unused.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/mac80211.h |    3 ---
 1 file changed, 3 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-23 18:38:41.511897709 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-23 18:38:42.511897709 +0200
@@ -288,9 +288,6 @@ struct ieee80211_tx_control {
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

