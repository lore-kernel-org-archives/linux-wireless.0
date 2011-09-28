Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45261 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980Ab1I1Sm7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 14:42:59 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: make patches apply again.
Date: Wed, 28 Sep 2011 20:42:46 +0200
Message-Id: <1317235366-14310-1-git-send-email-hauke@hauke-m.de> (sfid-20110928_204304_271514_8EF40795)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/08-rename-config-options.patch |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/patches/08-rename-config-options.patch b/patches/08-rename-config-options.patch
index 5505018..605e477 100644
--- a/patches/08-rename-config-options.patch
+++ b/patches/08-rename-config-options.patch
@@ -122,15 +122,15 @@ CONFIG_BT_HIDP does not build with older kernel versions.
  hidp-objs := core.o sock.o
 --- a/drivers/net/wireless/wl12xx/Makefile
 +++ b/drivers/net/wireless/wl12xx/Makefile
-@@ -8,9 +8,9 @@ wl12xx_sdio_test-objs = sdio_test.o
+@@ -8,9 +8,9 @@ wl12xx_sdio_test-objs	= sdio_test.o
  wl12xx-$(CONFIG_NL80211_TESTMODE)	+= testmode.o
  obj-$(CONFIG_WL12XX)			+= wl12xx.o
  obj-$(CONFIG_WL12XX_SPI)		+= wl12xx_spi.o
 -obj-$(CONFIG_WL12XX_SDIO)		+= wl12xx_sdio.o
 +obj-$(CONFIG_COMPAT_WL12XX_SDIO)		+= wl12xx_sdio.o
  
--obj-$(CONFIG_WL12XX_SDIO_TEST)	+= wl12xx_sdio_test.o
-+obj-$(CONFIG_COMPAT_WL12XX_SDIO_TEST)	+= wl12xx_sdio_test.o
+-obj-$(CONFIG_WL12XX_SDIO_TEST)		+= wl12xx_sdio_test.o
++obj-$(CONFIG_COMPAT_WL12XX_SDIO_TEST)		+= wl12xx_sdio_test.o
  
  # small builtin driver bit
  obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wl12xx_platform_data.o
-- 
1.7.4.1

