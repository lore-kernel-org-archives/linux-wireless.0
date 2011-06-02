Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51490 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab1FBQbZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 12:31:25 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/4] compat: add KEY_WPS_BUTTON
Date: Thu,  2 Jun 2011 18:31:04 +0200
Message-Id: <1307032264-14663-5-git-send-email-hauke@hauke-m.de> (sfid-20110602_183128_286038_FD39DFD8)
In-Reply-To: <1307032264-14663-1-git-send-email-hauke@hauke-m.de>
References: <1307032264-14663-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed for carl9170.

Add to compat-3.0-stable

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.34.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index 663a67e..9743d6c 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -251,6 +251,8 @@ static inline int usb_disable_autosuspend(struct usb_device *udev)
 
 #define rcu_dereference_raw(p)	rcu_dereference(p)
 
+#define KEY_WPS_BUTTON		0x211	/* WiFi Protected Setup key */
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,34)) */
 
 #endif /* LINUX_26_34_COMPAT_H */
-- 
1.7.4.1

