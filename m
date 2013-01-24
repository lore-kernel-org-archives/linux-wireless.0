Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:38008 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752795Ab3AXElO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 23:41:14 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] ieee80211: define AKM suite selectors type 5 and 6
Date: Wed, 23 Jan 2013 20:33:58 -0800
Message-Id: <1359002038-8308-1-git-send-email-bzhao@marvell.com> (sfid-20130124_054117_939434_CA4D23A2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reference: IEEE P802.11w(TM)/D7.0, December 2008: 7.3.2.25.2

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 include/linux/ieee80211.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index ccf9ee1..2ed19b6 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1898,6 +1898,8 @@ enum ieee80211_sa_query_action {
 /* AKM suite selectors */
 #define WLAN_AKM_SUITE_8021X		0x000FAC01
 #define WLAN_AKM_SUITE_PSK		0x000FAC02
+#define WLAN_AKM_SUITE_8021X_SHA256	0x000FAC05
+#define WLAN_AKM_SUITE_PSK_SHA256	0x000FAC06
 #define WLAN_AKM_SUITE_SAE			0x000FAC08
 #define WLAN_AKM_SUITE_FT_OVER_SAE	0x000FAC09
 
-- 
1.7.0.2

