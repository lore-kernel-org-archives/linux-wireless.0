Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:53819 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbbKYJcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 04:32:22 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 4/4] staging: wilc1000: remove unused files
Date: Wed, 25 Nov 2015 18:35:29 +0900
Message-ID: <1448444129-11045-4-git-send-email-glen.lee@atmel.com> (sfid-20151125_103226_651294_6E67A898)
In-Reply-To: <1448444129-11045-1-git-send-email-glen.lee@atmel.com>
References: <1448444129-11045-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes linux_wlan_sdio.[ch] which is not used anymore.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/Makefile          |  2 +-
 drivers/staging/wilc1000/linux_wlan_sdio.c | 10 ----------
 drivers/staging/wilc1000/linux_wlan_sdio.h |  1 -
 3 files changed, 1 insertion(+), 12 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/linux_wlan_sdio.c
 delete mode 100644 drivers/staging/wilc1000/linux_wlan_sdio.h

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index 2076743..09f0ddb 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -14,7 +14,7 @@ wilc1000-objs := wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
 			wilc_wlan.o
 
 obj-$(CONFIG_WILC1000_SDIO) += wilc1000-sdio.o
-wilc1000-sdio-objs += linux_wlan_sdio.o wilc_sdio.o
+wilc1000-sdio-objs += wilc_sdio.o
 
 obj-$(CONFIG_WILC1000_SPI) += wilc1000-spi.o
 wilc1000-spi-objs += linux_wlan_spi.o wilc_spi.o
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
deleted file mode 100644
index 67d99e9..0000000
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ /dev/null
@@ -1,10 +0,0 @@
-#include "wilc_wfi_netdevice.h"
-
-#include <linux/mmc/sdio_func.h>
-#include <linux/mmc/card.h>
-#include <linux/mmc/sdio_ids.h>
-#include <linux/mmc/sdio.h>
-#include <linux/mmc/host.h>
-#include <linux/of_gpio.h>
-
-#include "linux_wlan_sdio.h"
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.h b/drivers/staging/wilc1000/linux_wlan_sdio.h
deleted file mode 100644
index abb2312..0000000
--- a/drivers/staging/wilc1000/linux_wlan_sdio.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <linux/mmc/sdio_func.h>
-- 
1.9.1

