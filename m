Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58450 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbbH1Mbw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2015 08:31:52 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wireless: mark element IDs 8 and 9 reserved
Date: Fri, 28 Aug 2015 14:31:48 +0200
Message-Id: <1440765108-24932-1-git-send-email-johannes@sipsolutions.net> (sfid-20150828_143155_930145_7A4C52DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

These were never used in the tree, and are marked as reserved
in the IEEE 802.11 documentation (ANA).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index cfa906f28b7a..b9882efb3dfb 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1745,8 +1745,7 @@ enum ieee80211_eid {
 	WLAN_EID_TIM = 5,
 	WLAN_EID_IBSS_PARAMS = 6,
 	WLAN_EID_COUNTRY = 7,
-	WLAN_EID_HP_PARAMS = 8,
-	WLAN_EID_HP_TABLE = 9,
+	/* 8, 9 reserved */
 	WLAN_EID_REQUEST = 10,
 	WLAN_EID_QBSS_LOAD = 11,
 	WLAN_EID_EDCA_PARAM_SET = 12,
-- 
2.1.4

