Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:55203 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754815Ab1C3SbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2011 14:31:18 -0400
Received: by mail-ey0-f180.google.com with SMTP id 24so645424eyg.39
        for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2011 11:31:16 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: fix module author's email address in the spi and sdio modules
Date: Wed, 30 Mar 2011 21:31:39 +0300
Message-Id: <1301509899-6444-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The MODULE_AUTHOR() macro in the main module (wl12xx) has been updated
to reflect one of the author's new email address, but the wl12xx_spi
and wl12xx_sdio modules haven't been updated.  This patches updates
them.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/sdio.c |    2 +-
 drivers/net/wireless/wl12xx/spi.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 26dcd44..2ade222 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -360,7 +360,7 @@ module_init(wl1271_init);
 module_exit(wl1271_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
+MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
 MODULE_FIRMWARE(WL1271_FW_NAME);
 MODULE_FIRMWARE(WL128X_FW_NAME);
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 3b862a2..7b82b5f 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -489,7 +489,7 @@ module_init(wl1271_init);
 module_exit(wl1271_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
+MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
 MODULE_FIRMWARE(WL1271_FW_NAME);
 MODULE_FIRMWARE(WL128X_FW_NAME);
-- 
1.7.1

