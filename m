Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:42339 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab0HVTqY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 15:46:24 -0400
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh05-2.mail.saunalahti.fi (Postfix) with SMTP id C75D78C26B
	for <linux-wireless@vger.kernel.org>; Sun, 22 Aug 2010 22:46:22 +0300 (EEST)
Received: from potku.valot.fi (a85-156-250-252.elisa-laajakaista.fi [85.156.250.252])
	by emh05.mail.saunalahti.fi (Postfix) with ESMTP id 6D1F327D88
	for <linux-wireless@vger.kernel.org>; Sun, 22 Aug 2010 22:46:19 +0300 (EEST)
Subject: [PATCH 1/4] wl1251: update my email address
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 22 Aug 2010 22:46:15 +0300
Message-ID: <20100822194615.16660.21195.stgit@potku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I use now my adurom.com address.

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 MAINTAINERS                               |    2 +-
 drivers/net/wireless/wl12xx/wl1251_main.c |    2 +-
 drivers/net/wireless/wl12xx/wl1251_sdio.c |    2 +-
 drivers/net/wireless/wl12xx/wl1251_spi.c  |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b5b8baa..0ce4e53 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6369,7 +6369,7 @@ S:	Maintained
 F:	drivers/input/misc/wistron_btns.c
 
 WL1251 WIRELESS DRIVER
-M:	Kalle Valo <kalle.valo@iki.fi>
+M:	Kalle Valo <kvalo@adurom.com>
 L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index c81e95b..c7cffba 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1437,5 +1437,5 @@ EXPORT_SYMBOL_GPL(wl1251_free_hw);
 
 MODULE_DESCRIPTION("TI wl1251 Wireles LAN Driver Core");
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Kalle Valo <kalle.valo@nokia.com>");
+MODULE_AUTHOR("Kalle Valo <kvalo@adurom.com>");
 MODULE_FIRMWARE(WL1251_FW_NAME);
diff --git a/drivers/net/wireless/wl12xx/wl1251_sdio.c b/drivers/net/wireless/wl12xx/wl1251_sdio.c
index b901b61..c0b68b0 100644
--- a/drivers/net/wireless/wl12xx/wl1251_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1251_sdio.c
@@ -339,4 +339,4 @@ module_init(wl1251_sdio_init);
 module_exit(wl1251_sdio_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Kalle Valo <kalle.valo@nokia.com>");
+MODULE_AUTHOR("Kalle Valo <kvalo@adurom.com>");
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.c b/drivers/net/wireless/wl12xx/wl1251_spi.c
index 27fdfaa..a6435fb 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
@@ -344,5 +344,5 @@ module_init(wl1251_spi_init);
 module_exit(wl1251_spi_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Kalle Valo <kalle.valo@nokia.com>");
+MODULE_AUTHOR("Kalle Valo <kvalo@adurom.com>");
 MODULE_ALIAS("spi:wl1251");

