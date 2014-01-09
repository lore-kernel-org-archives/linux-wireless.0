Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61744 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330AbaAIXXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 18:23:16 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Avinash Patil <patila@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] ieee80211: add definition for WAPI key len
Date: Thu, 9 Jan 2014 15:22:56 -0800
Message-ID: <1389309777-19113-1-git-send-email-bzhao@marvell.com> (sfid-20140110_002319_454895_C46BC823)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add WAPI key length definition to ieee80211_key_len enum.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 include/linux/ieee80211.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 776cbb8..5c0b4b0 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1857,6 +1857,7 @@ enum ieee80211_key_len {
 	WLAN_KEY_LEN_CCMP = 16,
 	WLAN_KEY_LEN_TKIP = 32,
 	WLAN_KEY_LEN_AES_CMAC = 16,
+	WLAN_KEY_LEN_WAPI = 32,
 };
 
 #define IEEE80211_WEP_IV_LEN		4
-- 
1.8.2.3

