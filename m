Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:46002 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757424AbZHGKfk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 06:35:40 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 21/23] wl1251: remove Luciano as maintainer
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Aug 2009 13:35:19 +0300
Message-ID: <20090807103518.31717.48612.stgit@tikku>
In-Reply-To: <20090807102732.31717.84006.stgit@tikku>
References: <20090807102732.31717.84006.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Luciano is maintaining wl1271 part.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_main.c |    3 +--
 drivers/net/wireless/wl12xx/wl1251_sdio.c |    3 +--
 drivers/net/wireless/wl12xx/wl1251_spi.c  |    3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 3fe8b65..7148934 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1427,5 +1427,4 @@ EXPORT_SYMBOL_GPL(wl1251_free_hw);
 
 MODULE_DESCRIPTION("TI wl1251 Wireles LAN Driver Core");
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>");
-MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
+MODULE_AUTHOR("Kalle Valo <kalle.valo@nokia.com>");
diff --git a/drivers/net/wireless/wl12xx/wl1251_sdio.c b/drivers/net/wireless/wl12xx/wl1251_sdio.c
index 9577ed6..9423f22 100644
--- a/drivers/net/wireless/wl12xx/wl1251_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1251_sdio.c
@@ -202,5 +202,4 @@ module_init(wl1251_sdio_init);
 module_exit(wl1251_sdio_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>");
-MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
+MODULE_AUTHOR("Kalle Valo <kalle.valo@nokia.com>");
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.c b/drivers/net/wireless/wl12xx/wl1251_spi.c
index 612d565..14eff2b 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
@@ -341,5 +341,4 @@ module_init(wl1251_spi_init);
 module_exit(wl1251_spi_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>");
-MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
+MODULE_AUTHOR("Kalle Valo <kalle.valo@nokia.com>");

