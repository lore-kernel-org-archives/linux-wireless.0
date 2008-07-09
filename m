Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:23812 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbYGIToc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 15:44:32 -0400
Received: by yx-out-2324.google.com with SMTP id 8so898157yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 12:44:31 -0700 (PDT)
Subject: [PATCH 1/4] mac80211: remove WLAN_FC_DATA_PRESENT
From: Harvey Harrison <harvey.harrison@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 09 Jul 2008 12:44:31 -0700
Message-Id: <1215632672.476.84.camel@brick> (sfid-20080709_214435_406932_8F620A3A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All users are gone now.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
These apply on top of the three-patch series from yesterday.

 net/mac80211/ieee80211_i.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 44e81cb..136b53f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -35,8 +35,6 @@
 #define ETH_P_PAE 0x888E /* Port Access Entity (IEEE 802.1X) */
 #endif /* ETH_P_PAE */
 
-#define WLAN_FC_DATA_PRESENT(fc) (((fc) & 0x4c) == 0x08)
-
 struct ieee80211_local;
 
 /* Maximum number of broadcast/multicast frames to buffer when some of the
-- 
1.5.6.1.322.ge904b


