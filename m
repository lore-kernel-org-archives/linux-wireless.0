Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:46878 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750846AbZEFReT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2009 13:34:19 -0400
Date: Wed, 6 May 2009 20:34:10 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Update SA Query transaction id length
Message-ID: <20090506173410.GA2960@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IEEE 802.11w/D8.0 changed the length of the SA Query transaction
identifier from 16 to 2 octets.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 include/linux/ieee80211.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- uml.orig/include/linux/ieee80211.h	2009-05-06 18:44:19.000000000 +0300
+++ uml/include/linux/ieee80211.h	2009-05-06 18:44:31.000000000 +0300
@@ -543,7 +543,7 @@ struct ieee80211_tim_ie {
 	u8 virtual_map[1];
 } __attribute__ ((packed));
 
-#define WLAN_SA_QUERY_TR_ID_LEN 16
+#define WLAN_SA_QUERY_TR_ID_LEN 2
 
 struct ieee80211_mgmt {
 	__le16 frame_control;

-- 
Jouni Malinen                                            PGP id EFC895FA
