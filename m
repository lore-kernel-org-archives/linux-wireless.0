Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43439 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab1KQVXj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 16:23:39 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat: backport netdev_features_t
Date: Thu, 17 Nov 2011 22:23:11 +0100
Message-Id: <1321564991-7249-3-git-send-email-hauke@hauke-m.de> (sfid-20111117_222343_083904_B98DE956)
In-Reply-To: <1321564991-7249-1-git-send-email-hauke@hauke-m.de>
References: <1321564991-7249-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-3.3.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-3.3.h b/include/linux/compat-3.3.h
index 4e96ddc..9383a6e 100644
--- a/include/linux/compat-3.3.h
+++ b/include/linux/compat-3.3.h
@@ -31,6 +31,8 @@ static inline void skb_complete_wifi_ack(struct sk_buff *skb, bool acked)
 }
 #define NL80211_FEATURE_SK_TX_STATUS 0
 
+typedef u32 netdev_features_t;
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0)) */
 
 #endif /* LINUX_3_3_COMPAT_H */
-- 
1.7.4.1

