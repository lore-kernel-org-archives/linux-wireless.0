Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:55781 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754547Ab2FUA7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 20:59:16 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH mac80211-next] ieee80211: more OUI type definitions for WLAN_OUI_MICROSOFT
Date: Wed, 20 Jun 2012 17:59:01 -0700
Message-Id: <1340240341-3803-1-git-send-email-bzhao@marvell.com> (sfid-20120621_025919_968203_235D8E5F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

WMM and WPS

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 include/linux/ieee80211.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 7013513..d551b51 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1591,6 +1591,8 @@ enum ieee80211_sa_query_action {
 #define WLAN_OUI_TYPE_WFA_P2P		9
 #define WLAN_OUI_MICROSOFT		0x0050f2
 #define WLAN_OUI_TYPE_MICROSOFT_WPA	1
+#define WLAN_OUI_TYPE_MICROSOFT_WMM	2
+#define WLAN_OUI_TYPE_MICROSOFT_WPS	4
 
 /*
  * WMM/802.11e Tspec Element
-- 
1.7.0.2

