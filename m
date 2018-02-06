Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37418 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750990AbeBFOUd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Feb 2018 09:20:33 -0500
From: Srinivas Dasari <dasaris@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: Srinivas Dasari <dasaris@codeaurora.org>
Subject: [PATCH] ieee80211: Increase PMK maximum length to 64 bytes
Date: Tue,  6 Feb 2018 19:49:35 +0530
Message-Id: <1517926775-21351-1-git-send-email-dasaris@codeaurora.org> (sfid-20180206_152036_888720_6396B9D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Increase the PMK maximum length to 64 bytes to accommodate
the key length used in DPP with the NIST P-521 and
Brainpool 512 curves.

Signed-off-by: Srinivas Dasari <dasaris@codeaurora.org>
---
 include/linux/ieee80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index ee6657a..e4cba33 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2111,7 +2111,7 @@ enum ieee80211_key_len {
 #define FILS_ERP_MAX_REALM_LEN		253
 #define FILS_ERP_MAX_RRK_LEN		64
 
-#define PMK_MAX_LEN			48
+#define PMK_MAX_LEN			64
 
 /* Public action codes (IEEE Std 802.11-2016, 9.6.8.1, Table 9-307) */
 enum ieee80211_pub_actioncode {
-- 
1.9.1
