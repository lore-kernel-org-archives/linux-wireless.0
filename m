Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:32945 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab0LGVnL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 16:43:11 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] cfg80211: add some element IDs in enum ieee80211_eid
Date: Tue,  7 Dec 2010 13:43:03 -0800
Message-Id: <1291758184-649-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

1)WLAN_EID_BSS_COEX_2040
2)WLAN_EID_OVERLAP_BSS_SCAN_PARAM
3)WLAN_EID_EXT_CAPABILITY

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 include/linux/ieee80211.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index ed5a03c..351c0ab 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1223,6 +1223,9 @@ enum ieee80211_eid {
 	WLAN_EID_BSS_AC_ACCESS_DELAY = 68,
 	WLAN_EID_RRM_ENABLED_CAPABILITIES = 70,
 	WLAN_EID_MULTIPLE_BSSID = 71,
+	WLAN_EID_BSS_COEX_2040 = 72,
+	WLAN_EID_OVERLAP_BSS_SCAN_PARAM = 74,
+	WLAN_EID_EXT_CAPABILITY = 127,
 
 	WLAN_EID_MOBILITY_DOMAIN = 54,
 	WLAN_EID_FAST_BSS_TRANSITION = 55,
-- 
1.7.0.2

