Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:38275 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757870Ab0HJUVi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 16:21:38 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: backport SDIO_CLASS_BT_AMP
Date: Tue, 10 Aug 2010 22:21:26 +0200
Message-Id: <1281471686-16882-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed by drivers/bluetooth/btsdio.c

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.37.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.37.h b/include/linux/compat-2.6.37.h
index a33c9a2..cf0279e 100644
--- a/include/linux/compat-2.6.37.h
+++ b/include/linux/compat-2.6.37.h
@@ -22,6 +22,8 @@
 #define br_port_exists(dev)	(dev->br_port)
 #endif
 
+#define SDIO_CLASS_BT_AMP	0x09	/* Type-A Bluetooth AMP interface */
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37)) */
 
 #endif /* LINUX_26_37_COMPAT_H */
-- 
1.7.0.4

