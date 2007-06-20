Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40891 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbXFUKnK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2007 06:43:10 -0400
Subject: [PATCH] mac80211: remove ieee80211_msg_passive_scan
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 21 Jun 2007 00:15:52 +0200
Message-Id: <1182377752.3714.108.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This constant is unused.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211_common.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-dev.orig/net/mac80211/ieee80211_common.h	2007-06-20 01:40:13.217360230 +0200
+++ wireless-dev/net/mac80211/ieee80211_common.h	2007-06-20 01:40:23.577360230 +0200
@@ -47,7 +47,7 @@ enum ieee80211_msg_type {
 	ieee80211_msg_normal = 0,
 	ieee80211_msg_tx_callback_ack = 1,
 	ieee80211_msg_tx_callback_fail = 2,
-	ieee80211_msg_passive_scan = 3,
+	/* hole at 3, was ieee80211_msg_passive_scan but unused */
 	ieee80211_msg_wep_frame_unknown_key = 4,
 	ieee80211_msg_michael_mic_failure = 5,
 	/* hole at 6, was monitor but never sent to userspace */


