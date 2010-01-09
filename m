Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1024 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab0AIGdj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jan 2010 01:33:39 -0500
Subject: [PATCH] net/mac80211/mlme.c: Remove unnecessary semicolons
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 22:33:38 -0800
Message-ID: <1263018818.20926.6.camel@Joe-Laptop.home>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 72920ee..d0cc701 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1774,7 +1774,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	if (!wk)
 		return -ENOMEM;
 
-	memcpy(wk->filter_ta, req->bss->bssid, ETH_ALEN);;
+	memcpy(wk->filter_ta, req->bss->bssid, ETH_ALEN);
 
 	if (req->ie && req->ie_len) {
 		memcpy(wk->ie, req->ie, req->ie_len);


