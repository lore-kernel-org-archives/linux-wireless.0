Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50484 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531Ab0KUUss (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Nov 2010 15:48:48 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: update wireless.h with new version from linux-next
Date: Sun, 21 Nov 2010 21:48:37 +0100
Message-Id: <1290372517-6777-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1290372517-6777-1-git-send-email-hauke@hauke-m.de>
References: <1290372517-6777-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/wireless.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/wireless.h b/include/linux/wireless.h
index e6827ee..4395b28 100644
--- a/include/linux/wireless.h
+++ b/include/linux/wireless.h
@@ -1157,6 +1157,6 @@ struct __compat_iw_event {
 #define IW_EV_PARAM_PK_LEN	(IW_EV_LCP_PK_LEN + sizeof(struct iw_param))
 #define IW_EV_ADDR_PK_LEN	(IW_EV_LCP_PK_LEN + sizeof(struct sockaddr))
 #define IW_EV_QUAL_PK_LEN	(IW_EV_LCP_PK_LEN + sizeof(struct iw_quality))
-#define IW_EV_POINT_PK_LEN	(IW_EV_LCP_LEN + 4)
+#define IW_EV_POINT_PK_LEN	(IW_EV_LCP_PK_LEN + 4)
 
 #endif	/* _LINUX_WIRELESS_H */
-- 
1.7.1

