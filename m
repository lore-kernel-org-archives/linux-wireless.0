Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54825 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbYHNIJO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 04:09:14 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 14 Aug 2008 01:09:14 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18595.58741.831960.356862@localhost.localdomain> (sfid-20080814_100917_907185_39EE6A37)
Date: Thu, 14 Aug 2008 13:27:41 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 4/6] mac80211: Add an 802.11n definition
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a HT Capability (DSSS/CCK Mode in 40MHz BSS)
definition to ieee80211.h

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 include/linux/ieee80211.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 7f4df7c..be45645 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -714,6 +714,7 @@ struct ieee80211_ht_addt_info {
 #define IEEE80211_HT_CAP_SGI_40			0x0040
 #define IEEE80211_HT_CAP_DELAY_BA		0x0400
 #define IEEE80211_HT_CAP_MAX_AMSDU		0x0800
+#define IEEE80211_HT_CAP_DSSSCCK40		0x1000
 /* 802.11n HT capability AMPDU settings */
 #define IEEE80211_HT_CAP_AMPDU_FACTOR		0x03
 #define IEEE80211_HT_CAP_AMPDU_DENSITY		0x1C
-- 
1.5.6.5

