Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37919 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251AbZKGWCP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 17:02:15 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: John Linville <linville@tuxdriver.com>
Cc: Kalle Valo <kalle.valo@nokia.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Nov 2009 22:02:15 +0000
Message-ID: <1257631335.15927.471.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 55/75] wl12xx: declare MODULE_FIRMWARE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/wl12xx/wl1251_main.c |    1 +
 drivers/net/wireless/wl12xx/wl1271_main.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index da3bf1c..d03a07e 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1431,3 +1431,4 @@ MODULE_DESCRIPTION("TI wl1251 Wireles LAN Driver Core");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kalle Valo <kalle.valo@nokia.com>");
 MODULE_ALIAS("spi:wl1251");
+MODULE_FIRMWARE(WL1251_FW_NAME);
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index d2149fc..00ddcc2 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1979,3 +1979,4 @@ module_exit(wl1271_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
+MODULE_FIRMWARE(WL1271_FW_NAME);
-- 
1.6.5.2



