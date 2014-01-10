Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47665 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751513AbaAJTJI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 14:09:08 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Avinash Patil <patila@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v3] ieee80211: add definition for SMS4 key len
Date: Fri, 10 Jan 2014 11:08:55 -0800
Message-ID: <1389380935-22929-1-git-send-email-bzhao@marvell.com> (sfid-20140110_200912_791809_7394E354)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Add SMS4 key length definition to ieee80211_key_len enum.
It's used by WAPI.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v2: correct patch author
v3: rename WLAN_KEY_LEN_WAPI to WLAN_KEY_LEN_SMS4 (Johannes Berg)

 include/linux/ieee80211.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index b382c7c..6a2cbf5 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1857,6 +1857,7 @@ enum ieee80211_key_len {
 	WLAN_KEY_LEN_CCMP = 16,
 	WLAN_KEY_LEN_TKIP = 32,
 	WLAN_KEY_LEN_AES_CMAC = 16,
+	WLAN_KEY_LEN_SMS4 = 32,
 };
 
 #define IEEE80211_WEP_IV_LEN		4
-- 
1.8.2.3

