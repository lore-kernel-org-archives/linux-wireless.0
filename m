Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:35157 "HELO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753158Ab2FLBOa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 21:14:30 -0400
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
Subject: [PATCH] ieee80211: definitions for Microsoft Vendor OUI and WPA OUI type
Date: Mon, 11 Jun 2012 18:14:16 -0700
Message-Id: <1339463656-10709-1-git-send-email-bzhao@marvell.com> (sfid-20120612_031446_328016_7EEE1F0F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Reference: http://standards.ieee.org/develop/regauth/oui/oui.txt

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 include/linux/ieee80211.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index ce9af89..7013513 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1589,6 +1589,8 @@ enum ieee80211_sa_query_action {
 
 #define WLAN_OUI_WFA			0x506f9a
 #define WLAN_OUI_TYPE_WFA_P2P		9
+#define WLAN_OUI_MICROSOFT		0x0050f2
+#define WLAN_OUI_TYPE_MICROSOFT_WPA	1
 
 /*
  * WMM/802.11e Tspec Element
-- 
1.7.0.2

