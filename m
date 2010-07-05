Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:48963 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab0GEONM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jul 2010 10:13:12 -0400
From: Ameya Palande <ameya.palande@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: kalle.valo@iki.fi, luciano.coelho@nokia.com,
	juuso.oikarinen@nokia.com
Subject: [PATCH] wl1251: Use MODULE_ALIAS macro at correct postion for SPI bus
Date: Mon,  5 Jul 2010 17:12:38 +0300
Message-Id: <1278339158-10414-1-git-send-email-ameya.palande@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ameya Palande <ameya.palande@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_main.c |    1 -
 drivers/net/wireless/wl12xx/wl1251_spi.c  |    1 +
 drivers/net/wireless/wl12xx/wl1271_spi.c  |    1 +
 3 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 00b2428..35fdf88 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1419,5 +1419,4 @@ EXPORT_SYMBOL_GPL(wl1251_free_hw);
 MODULE_DESCRIPTION("TI wl1251 Wireles LAN Driver Core");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kalle Valo <kalle.valo@nokia.com>");
-MODULE_ALIAS("spi:wl1251");
 MODULE_FIRMWARE(WL1251_FW_NAME);
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.c b/drivers/net/wireless/wl12xx/wl1251_spi.c
index e814742..27fdfaa 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
@@ -345,3 +345,4 @@ module_exit(wl1251_spi_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kalle Valo <kalle.valo@nokia.com>");
+MODULE_ALIAS("spi:wl1251");
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index 5189b81..96d25fb 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -461,3 +461,4 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
 MODULE_FIRMWARE(WL1271_FW_NAME);
+MODULE_ALIAS("spi:wl1271");
-- 
1.7.0.4

