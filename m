Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:33497 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751844Ab2DKJiT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:38:19 -0400
Received: by lagy4 with SMTP id y4so617893lag.36
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 02:38:16 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, linville@tuxdriver.com, coelho@ti.com
Subject: [PATCH 02/16] wl12xx/wlcore: rename wl12xx to wlcore
Date: Wed, 11 Apr 2012 12:37:49 +0300
Message-Id: <1334137083-13490-3-git-send-email-coelho@ti.com> (sfid-20120411_113825_508042_6DC27A63)
In-Reply-To: <1334137083-13490-1-git-send-email-coelho@ti.com>
References: <1334137083-13490-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename the wl12xx driver directory to wlcore as an initial step
towards the split of the driver into wlcore and wl12xx.  We just
rename the directory first to keep git blame happy.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/Kconfig                    |    2 +-
 drivers/net/wireless/ti/Makefile                   |    4 ++--
 drivers/net/wireless/ti/{wl12xx => wlcore}/Kconfig |    0
 .../net/wireless/ti/{wl12xx => wlcore}/Makefile    |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/acx.c   |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/acx.h   |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/boot.c  |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/boot.h  |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/cmd.c   |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/cmd.h   |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/conf.h  |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/debug.h |    0
 .../net/wireless/ti/{wl12xx => wlcore}/debugfs.c   |    0
 .../net/wireless/ti/{wl12xx => wlcore}/debugfs.h   |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/event.c |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/event.h |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/ini.h   |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/init.c  |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/init.h  |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/io.c    |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/io.h    |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/main.c  |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/ps.c    |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/ps.h    |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/reg.h   |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/rx.c    |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/rx.h    |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/scan.c  |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/scan.h  |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/sdio.c  |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/spi.c   |    0
 .../net/wireless/ti/{wl12xx => wlcore}/testmode.c  |    0
 .../net/wireless/ti/{wl12xx => wlcore}/testmode.h  |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/tx.c    |    0
 drivers/net/wireless/ti/{wl12xx => wlcore}/tx.h    |    0
 .../net/wireless/ti/{wl12xx => wlcore}/wl12xx.h    |    0
 .../wireless/ti/{wl12xx => wlcore}/wl12xx_80211.h  |    0
 .../ti/{wl12xx => wlcore}/wl12xx_platform_data.c   |    0
 38 files changed, 3 insertions(+), 3 deletions(-)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/Kconfig (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/Makefile (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/acx.c (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/acx.h (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/boot.c (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/boot.h (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/cmd.c (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/cmd.h (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/conf.h (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/debug.h (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/debugfs.c (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/debugfs.h (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/event.c (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/event.h (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/ini.h (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/init.c (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/init.h (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/io.c (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/io.h (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/main.c (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/ps.c (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/ps.h (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/reg.h (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/rx.c (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/rx.h (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/scan.c (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/scan.h (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/sdio.c (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/spi.c (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/testmode.c (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/testmode.h (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/tx.c (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/tx.h (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/wl12xx.h (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/wl12xx_80211.h (100%)
 rename drivers/net/wireless/ti/{wl12xx => wlcore}/wl12xx_platform_data.c (100%)

diff --git a/drivers/net/wireless/ti/Kconfig b/drivers/net/wireless/ti/Kconfig
index 75722d8..1e8d04b 100644
--- a/drivers/net/wireless/ti/Kconfig
+++ b/drivers/net/wireless/ti/Kconfig
@@ -7,5 +7,5 @@ menuconfig WL_TI
 
 if WL_TI
 source "drivers/net/wireless/ti/wl1251/Kconfig"
-source "drivers/net/wireless/ti/wl12xx/Kconfig"
+source "drivers/net/wireless/ti/wlcore/Kconfig"
 endif # WL_TI
diff --git a/drivers/net/wireless/ti/Makefile b/drivers/net/wireless/ti/Makefile
index db2cb03..10919db 100644
--- a/drivers/net/wireless/ti/Makefile
+++ b/drivers/net/wireless/ti/Makefile
@@ -1,3 +1,3 @@
-obj-$(CONFIG_WL12XX)			+= wl12xx/
-obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wl12xx/
+obj-$(CONFIG_WL12XX)			+= wlcore/
+obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wlcore/
 obj-$(CONFIG_WL1251)			+= wl1251/
diff --git a/drivers/net/wireless/ti/wl12xx/Kconfig b/drivers/net/wireless/ti/wlcore/Kconfig
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/Kconfig
rename to drivers/net/wireless/ti/wlcore/Kconfig
diff --git a/drivers/net/wireless/ti/wl12xx/Makefile b/drivers/net/wireless/ti/wlcore/Makefile
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/Makefile
rename to drivers/net/wireless/ti/wlcore/Makefile
diff --git a/drivers/net/wireless/ti/wl12xx/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/acx.c
rename to drivers/net/wireless/ti/wlcore/acx.c
diff --git a/drivers/net/wireless/ti/wl12xx/acx.h b/drivers/net/wireless/ti/wlcore/acx.h
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/acx.h
rename to drivers/net/wireless/ti/wlcore/acx.h
diff --git a/drivers/net/wireless/ti/wl12xx/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/boot.c
rename to drivers/net/wireless/ti/wlcore/boot.c
diff --git a/drivers/net/wireless/ti/wl12xx/boot.h b/drivers/net/wireless/ti/wlcore/boot.h
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/boot.h
rename to drivers/net/wireless/ti/wlcore/boot.h
diff --git a/drivers/net/wireless/ti/wl12xx/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/cmd.c
rename to drivers/net/wireless/ti/wlcore/cmd.c
diff --git a/drivers/net/wireless/ti/wl12xx/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/cmd.h
rename to drivers/net/wireless/ti/wlcore/cmd.h
diff --git a/drivers/net/wireless/ti/wl12xx/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/conf.h
rename to drivers/net/wireless/ti/wlcore/conf.h
diff --git a/drivers/net/wireless/ti/wl12xx/debug.h b/drivers/net/wireless/ti/wlcore/debug.h
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/debug.h
rename to drivers/net/wireless/ti/wlcore/debug.h
diff --git a/drivers/net/wireless/ti/wl12xx/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/debugfs.c
rename to drivers/net/wireless/ti/wlcore/debugfs.c
diff --git a/drivers/net/wireless/ti/wl12xx/debugfs.h b/drivers/net/wireless/ti/wlcore/debugfs.h
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/debugfs.h
rename to drivers/net/wireless/ti/wlcore/debugfs.h
diff --git a/drivers/net/wireless/ti/wl12xx/event.c b/drivers/net/wireless/ti/wlcore/event.c
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/event.c
rename to drivers/net/wireless/ti/wlcore/event.c
diff --git a/drivers/net/wireless/ti/wl12xx/event.h b/drivers/net/wireless/ti/wlcore/event.h
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/event.h
rename to drivers/net/wireless/ti/wlcore/event.h
diff --git a/drivers/net/wireless/ti/wl12xx/ini.h b/drivers/net/wireless/ti/wlcore/ini.h
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/ini.h
rename to drivers/net/wireless/ti/wlcore/ini.h
diff --git a/drivers/net/wireless/ti/wl12xx/init.c b/drivers/net/wireless/ti/wlcore/init.c
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/init.c
rename to drivers/net/wireless/ti/wlcore/init.c
diff --git a/drivers/net/wireless/ti/wl12xx/init.h b/drivers/net/wireless/ti/wlcore/init.h
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/init.h
rename to drivers/net/wireless/ti/wlcore/init.h
diff --git a/drivers/net/wireless/ti/wl12xx/io.c b/drivers/net/wireless/ti/wlcore/io.c
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/io.c
rename to drivers/net/wireless/ti/wlcore/io.c
diff --git a/drivers/net/wireless/ti/wl12xx/io.h b/drivers/net/wireless/ti/wlcore/io.h
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/io.h
rename to drivers/net/wireless/ti/wlcore/io.h
diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wlcore/main.c
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/main.c
rename to drivers/net/wireless/ti/wlcore/main.c
diff --git a/drivers/net/wireless/ti/wl12xx/ps.c b/drivers/net/wireless/ti/wlcore/ps.c
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/ps.c
rename to drivers/net/wireless/ti/wlcore/ps.c
diff --git a/drivers/net/wireless/ti/wl12xx/ps.h b/drivers/net/wireless/ti/wlcore/ps.h
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/ps.h
rename to drivers/net/wireless/ti/wlcore/ps.h
diff --git a/drivers/net/wireless/ti/wl12xx/reg.h b/drivers/net/wireless/ti/wlcore/reg.h
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/reg.h
rename to drivers/net/wireless/ti/wlcore/reg.h
diff --git a/drivers/net/wireless/ti/wl12xx/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/rx.c
rename to drivers/net/wireless/ti/wlcore/rx.c
diff --git a/drivers/net/wireless/ti/wl12xx/rx.h b/drivers/net/wireless/ti/wlcore/rx.h
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/rx.h
rename to drivers/net/wireless/ti/wlcore/rx.h
diff --git a/drivers/net/wireless/ti/wl12xx/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/scan.c
rename to drivers/net/wireless/ti/wlcore/scan.c
diff --git a/drivers/net/wireless/ti/wl12xx/scan.h b/drivers/net/wireless/ti/wlcore/scan.h
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/scan.h
rename to drivers/net/wireless/ti/wlcore/scan.h
diff --git a/drivers/net/wireless/ti/wl12xx/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/sdio.c
rename to drivers/net/wireless/ti/wlcore/sdio.c
diff --git a/drivers/net/wireless/ti/wl12xx/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/spi.c
rename to drivers/net/wireless/ti/wlcore/spi.c
diff --git a/drivers/net/wireless/ti/wl12xx/testmode.c b/drivers/net/wireless/ti/wlcore/testmode.c
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/testmode.c
rename to drivers/net/wireless/ti/wlcore/testmode.c
diff --git a/drivers/net/wireless/ti/wl12xx/testmode.h b/drivers/net/wireless/ti/wlcore/testmode.h
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/testmode.h
rename to drivers/net/wireless/ti/wlcore/testmode.h
diff --git a/drivers/net/wireless/ti/wl12xx/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/tx.c
rename to drivers/net/wireless/ti/wlcore/tx.c
diff --git a/drivers/net/wireless/ti/wl12xx/tx.h b/drivers/net/wireless/ti/wlcore/tx.h
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/tx.h
rename to drivers/net/wireless/ti/wlcore/tx.h
diff --git a/drivers/net/wireless/ti/wl12xx/wl12xx.h b/drivers/net/wireless/ti/wlcore/wl12xx.h
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/wl12xx.h
rename to drivers/net/wireless/ti/wlcore/wl12xx.h
diff --git a/drivers/net/wireless/ti/wl12xx/wl12xx_80211.h b/drivers/net/wireless/ti/wlcore/wl12xx_80211.h
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/wl12xx_80211.h
rename to drivers/net/wireless/ti/wlcore/wl12xx_80211.h
diff --git a/drivers/net/wireless/ti/wl12xx/wl12xx_platform_data.c b/drivers/net/wireless/ti/wlcore/wl12xx_platform_data.c
similarity index 100%
rename from drivers/net/wireless/ti/wl12xx/wl12xx_platform_data.c
rename to drivers/net/wireless/ti/wlcore/wl12xx_platform_data.c
-- 
1.7.5.4

