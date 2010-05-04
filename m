Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43185 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934342Ab0EDWk6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 18:40:58 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: backport orinoco updates
Date: Wed,  5 May 2010 00:40:37 +0200
Message-Id: <1273012837-8325-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.29.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.29.h b/include/linux/compat-2.6.29.h
index c3572a2..2709953 100644
--- a/include/linux/compat-2.6.29.h
+++ b/include/linux/compat-2.6.29.h
@@ -61,6 +61,8 @@ extern void usb_unpoison_anchored_urbs(struct usb_anchor *anchor);
 
 extern int eth_mac_addr(struct net_device *dev, void *p);
 
+#define orinoco_if_add(priv, base_addr, irq, ops) orinoco_if_add(priv, base_addr, irq)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)) */
 
 #endif /*  LINUX_26_29_COMPAT_H */
-- 
1.7.0.4

