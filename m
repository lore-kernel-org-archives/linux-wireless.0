Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43689 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab0DRNiI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Apr 2010 09:38:08 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat: Add definitions needed for libertas sdio driver.
Date: Sun, 18 Apr 2010 15:37:56 +0200
Message-Id: <1271597877-4878-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1271597877-4878-1-git-send-email-hauke@hauke-m.de>
References: <1271597877-4878-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.35.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.35.h b/include/linux/compat-2.6.35.h
index 7387c46..964e8dc 100644
--- a/include/linux/compat-2.6.35.h
+++ b/include/linux/compat-2.6.35.h
@@ -8,6 +8,9 @@
 #define IW_HANDLER(id, func)			\
 	[IW_IOCTL_IDX(id)] = func
 
+#define  SDIO_BUS_ECSI		0x20	/* Enable continuous SPI interrupt */
+#define  SDIO_BUS_SCSI		0x40	/* Support continuous SPI interrupt */
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)) */
 
 #endif /* LINUX_26_35_COMPAT_H */
-- 
1.6.3.3

