Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56138 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3BUTq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 14:46:26 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wireless: remove unused VHT MCS defines
Date: Thu, 21 Feb 2013 20:46:21 +0100
Message-Id: <1361475981-19517-1-git-send-email-johannes@sipsolutions.net> (sfid-20130221_204628_512495_789D773F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's an enum with the same values (but slightly
different names except for NOT_SUPPORTED) that is
actually used, so remove the defines.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 226a5f4..bfc72fd 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1330,11 +1330,6 @@ struct ieee80211_vht_operation {
 } __packed;
 
 
-#define IEEE80211_VHT_MCS_ZERO_TO_SEVEN_SUPPORT 0
-#define IEEE80211_VHT_MCS_ZERO_TO_EIGHT_SUPPORT 1
-#define IEEE80211_VHT_MCS_ZERO_TO_NINE_SUPPORT  2
-#define IEEE80211_VHT_MCS_NOT_SUPPORTED 3
-
 /* 802.11ac VHT Capabilities */
 #define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895			0x00000000
 #define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991			0x00000001
-- 
1.8.0

