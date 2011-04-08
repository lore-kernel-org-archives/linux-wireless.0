Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63553 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757693Ab1DHWHr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 18:07:47 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2011 15:07:22 -0700
From: Naveen Singh <nsingh@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vipin.mehta@atheros.com>, <luis.rodriguez@atheros.com>,
	Naveen Singh <nsingh@atheros.com>
Subject: [PATCH] staging:ath6kl:Correcting the typo
Date: Fri, 8 Apr 2011 15:07:43 -0700
Message-ID: <1302300463-1829-1-git-send-email-nsingh@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

1) ATH6K_CONFIG_HIF_VIRTUAL_SCATTER needs to be
   ATH6KL_CONFIG_HIF_VIRTUAL_SCATTER in file ar6000_drv.h
---
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index 666a591..b466e7f 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -222,11 +222,11 @@ typedef enum _AR6K_BIN_FILE {
 #define ENABLEUARTPRINT_DEFAULT    0
 #endif /* ENABLEARTPRINT_SET */
 
-#ifdef ATH6K_CONFIG_HIF_VIRTUAL_SCATTER
+#ifdef ATH6KL_CONFIG_HIF_VIRTUAL_SCATTER
 #define NOHIFSCATTERSUPPORT_DEFAULT    1
-#else /* ATH6K_CONFIG_HIF_VIRTUAL_SCATTER */
+#else /* ATH6KL_CONFIG_HIF_VIRTUAL_SCATTER */
 #define NOHIFSCATTERSUPPORT_DEFAULT    0
-#endif /* ATH6K_CONFIG_HIF_VIRTUAL_SCATTER */
+#endif /* ATH6KL_CONFIG_HIF_VIRTUAL_SCATTER */
 
 
 #if defined(CONFIG_ATH6KL_ENABLE_COEXISTENCE)
-- 
1.7.0.4

