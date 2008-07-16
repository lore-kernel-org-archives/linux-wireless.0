Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:16274 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658AbYGPBob (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 21:44:31 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1738137yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2008 18:44:30 -0700 (PDT)
Subject: [PATCH 12/12] mac80211: remove WLAN_FC_DATA_PRESENT
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 18:44:15 -0700
Message-Id: <1216172655.6610.60.camel@brick> (sfid-20080716_034542_996649_60F17F23)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All users are gone now.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/ieee80211_i.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 47e0979..03c0901 100644
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
1.5.6.3.499.geae9

