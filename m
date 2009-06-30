Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36341 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbZF3JJI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 05:09:08 -0400
Subject: [PATCH] mac80211: remove an unused function declaration
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 11:09:05 +0200
Message-Id: <1246352945.16643.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ieee80211_scan_results function hasn't existed for a
long time now, so its declaration should be removed as
well.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    3 ---
 1 file changed, 3 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-06-30 11:06:42.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-06-30 11:07:35.000000000 +0200
@@ -979,9 +979,6 @@ int ieee80211_request_internal_scan(stru
 				    const u8 *ssid, u8 ssid_len);
 int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
 			   struct cfg80211_scan_request *req);
-int ieee80211_scan_results(struct ieee80211_local *local,
-			   struct iw_request_info *info,
-			   char *buf, size_t len);
 void ieee80211_scan_cancel(struct ieee80211_local *local);
 ieee80211_rx_result
 ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);


