Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:49803 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751854AbZCSLsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 07:48:13 -0400
Message-Id: <20090319114756.833749085@atheros.com> (sfid-20090319_124817_815763_EC2E1FF5)
References: <20090319113918.555693846@atheros.com>
Date: Thu, 19 Mar 2009 13:39:19 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 1/4] mac80211: Fix a typo in assoc vs. reassoc check
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- uml.orig/net/mac80211/mlme.c	2009-03-19 00:18:40.000000000 +0200
+++ uml/net/mac80211/mlme.c	2009-03-19 00:18:57.000000000 +0200
@@ -103,7 +103,7 @@ static void ieee80211_send_assoc(struct 
 	u32 rates = 0;
 	size_t e_ies_len;
 
-	if (ifmgd->flags & IEEE80211_IBSS_PREV_BSSID_SET) {
+	if (ifmgd->flags & IEEE80211_STA_PREV_BSSID_SET) {
 		e_ies = sdata->u.mgd.ie_reassocreq;
 		e_ies_len = sdata->u.mgd.ie_reassocreq_len;
 	} else {

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
