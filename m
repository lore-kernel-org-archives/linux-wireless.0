Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:46839 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab0LJCYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 21:24:44 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] ieee80211: add Parameter Set Count bitmask
Date: Thu,  9 Dec 2010 18:24:41 -0800
Message-Id: <1291947882-9124-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WMM IE QoS Info field lower 4 bits: Parameter Set Count

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 include/linux/ieee80211.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 351c0ab..7f23545 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -122,6 +122,7 @@
 
 /* U-APSD queue for WMM IEs sent by AP */
 #define IEEE80211_WMM_IE_AP_QOSINFO_UAPSD	(1<<7)
+#define IEEE80211_WMM_IE_AP_QOSINFO_PARAM_SET_CNT_MASK	0x0f
 
 /* U-APSD queues for WMM IEs sent by STA */
 #define IEEE80211_WMM_IE_STA_QOSINFO_AC_VO	(1<<0)
-- 
1.7.0.2

