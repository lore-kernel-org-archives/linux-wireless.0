Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:44165 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759957AbZJMRnX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 13:43:23 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH] wl1251: rename spi device to wl1251
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 Oct 2009 20:41:20 +0300
Message-ID: <20091013174119.15796.81021.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

During rename of the driver from wl12xx to wl1251 the spi device name
was accidentally left as wl12xx. Rename it to wl1251 which is the proper
name of the driver.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_main.c |    2 +-
 drivers/net/wireless/wl12xx/wl1251_spi.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 1103256..23ac503 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1426,4 +1426,4 @@ EXPORT_SYMBOL_GPL(wl1251_free_hw);
 MODULE_DESCRIPTION("TI wl1251 Wireles LAN Driver Core");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kalle Valo <kalle.valo@nokia.com>");
-MODULE_ALIAS("spi:wl12xx");
+MODULE_ALIAS("spi:wl1251");
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.c b/drivers/net/wireless/wl12xx/wl1251_spi.c
index 14eff2b..2cf8a21 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
@@ -307,7 +307,7 @@ static int __devexit wl1251_spi_remove(struct spi_device *spi)
 
 static struct spi_driver wl1251_spi_driver = {
 	.driver = {
-		.name		= "wl12xx",
+		.name		= "wl1251",
 		.bus		= &spi_bus_type,
 		.owner		= THIS_MODULE,
 	},

