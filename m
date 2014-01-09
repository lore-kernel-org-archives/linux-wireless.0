Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22883 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526AbaAIXXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 18:23:16 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Avinash Patil <patila@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] ieee80211: add definition for TDLS wide band extended capability
Date: Thu, 9 Jan 2014 15:22:57 -0800
Message-ID: <1389309777-19113-2-git-send-email-bzhao@marvell.com> (sfid-20140110_002320_564162_95A0A8FA)
In-Reply-To: <1389309777-19113-1-git-send-email-bzhao@marvell.com>
References: <1389309777-19113-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Seventh bit of 8th byte of extended capabilities specifies wide
bandwidth support for TDLS links. Add this definition to ieee80211.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 include/linux/ieee80211.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 5c0b4b0..6a2cbf5 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1903,6 +1903,7 @@ enum ieee80211_tdls_actioncode {
 #define WLAN_EXT_CAPA5_TDLS_PROHIBITED	BIT(6)
 
 #define WLAN_EXT_CAPA8_OPMODE_NOTIF	BIT(6)
+#define WLAN_EXT_CAPA8_TDLS_WIDE_BW_ENABLED	BIT(7)
 
 /* TDLS specific payload type in the LLC/SNAP header */
 #define WLAN_TDLS_SNAP_RFTYPE	0x2
-- 
1.8.2.3

