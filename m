Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43414 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759257AbZCaCai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 22:30:38 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 7/9] atheros: put atheros wireless drivers into ath/
Date: Mon, 30 Mar 2009 22:30:33 -0400
Message-Id: <1238466635-23280-8-git-send-email-lrodriguez@atheros.com> (sfid-20090331_043052_227212_8B8E0DED)
In-Reply-To: <1238466635-23280-1-git-send-email-lrodriguez@atheros.com>
References: <1238466635-23280-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig                    |    3 ---
 drivers/net/wireless/Makefile                   |    3 ---
 drivers/net/wireless/ath/Kconfig                |    6 +++++-
 drivers/net/wireless/ath/Makefile               |    4 ++++
 drivers/net/wireless/{ => ath}/ar9170/Kconfig   |    0
 drivers/net/wireless/{ => ath}/ar9170/Makefile  |    0
 drivers/net/wireless/{ => ath}/ar9170/ar9170.h  |    2 +-
 drivers/net/wireless/{ => ath}/ar9170/cmd.c     |    0
 drivers/net/wireless/{ => ath}/ar9170/cmd.h     |    0
 drivers/net/wireless/{ => ath}/ar9170/eeprom.h  |    0
 drivers/net/wireless/{ => ath}/ar9170/hw.h      |    0
 drivers/net/wireless/{ => ath}/ar9170/led.c     |    0
 drivers/net/wireless/{ => ath}/ar9170/mac.c     |    0
 drivers/net/wireless/{ => ath}/ar9170/main.c    |    0
 drivers/net/wireless/{ => ath}/ar9170/phy.c     |    0
 drivers/net/wireless/{ => ath}/ar9170/usb.c     |    0
 drivers/net/wireless/{ => ath}/ar9170/usb.h     |    0
 drivers/net/wireless/{ => ath}/ath5k/Kconfig    |    0
 drivers/net/wireless/{ => ath}/ath5k/Makefile   |    0
 drivers/net/wireless/{ => ath}/ath5k/ath5k.h    |    2 +-
 drivers/net/wireless/{ => ath}/ath5k/attach.c   |    0
 drivers/net/wireless/{ => ath}/ath5k/base.c     |    0
 drivers/net/wireless/{ => ath}/ath5k/base.h     |    0
 drivers/net/wireless/{ => ath}/ath5k/caps.c     |    0
 drivers/net/wireless/{ => ath}/ath5k/debug.c    |    0
 drivers/net/wireless/{ => ath}/ath5k/debug.h    |    0
 drivers/net/wireless/{ => ath}/ath5k/desc.c     |    0
 drivers/net/wireless/{ => ath}/ath5k/desc.h     |    0
 drivers/net/wireless/{ => ath}/ath5k/dma.c      |    0
 drivers/net/wireless/{ => ath}/ath5k/eeprom.c   |    0
 drivers/net/wireless/{ => ath}/ath5k/eeprom.h   |    0
 drivers/net/wireless/{ => ath}/ath5k/gpio.c     |    0
 drivers/net/wireless/{ => ath}/ath5k/initvals.c |    0
 drivers/net/wireless/{ => ath}/ath5k/led.c      |    0
 drivers/net/wireless/{ => ath}/ath5k/pcu.c      |    0
 drivers/net/wireless/{ => ath}/ath5k/phy.c      |    0
 drivers/net/wireless/{ => ath}/ath5k/qcu.c      |    0
 drivers/net/wireless/{ => ath}/ath5k/reg.h      |    0
 drivers/net/wireless/{ => ath}/ath5k/reset.c    |    0
 drivers/net/wireless/{ => ath}/ath5k/rfbuffer.h |    0
 drivers/net/wireless/{ => ath}/ath5k/rfgain.h   |    0
 drivers/net/wireless/{ => ath}/ath9k/Kconfig    |    0
 drivers/net/wireless/{ => ath}/ath9k/Makefile   |    0
 drivers/net/wireless/{ => ath}/ath9k/ahb.c      |    0
 drivers/net/wireless/{ => ath}/ath9k/ani.c      |    0
 drivers/net/wireless/{ => ath}/ath9k/ani.h      |    0
 drivers/net/wireless/{ => ath}/ath9k/ath9k.h    |    0
 drivers/net/wireless/{ => ath}/ath9k/beacon.c   |    0
 drivers/net/wireless/{ => ath}/ath9k/calib.c    |    0
 drivers/net/wireless/{ => ath}/ath9k/calib.h    |    0
 drivers/net/wireless/{ => ath}/ath9k/debug.c    |    0
 drivers/net/wireless/{ => ath}/ath9k/debug.h    |    0
 drivers/net/wireless/{ => ath}/ath9k/eeprom.c   |    0
 drivers/net/wireless/{ => ath}/ath9k/eeprom.h   |    0
 drivers/net/wireless/{ => ath}/ath9k/hw.c       |    0
 drivers/net/wireless/{ => ath}/ath9k/hw.h       |    2 +-
 drivers/net/wireless/{ => ath}/ath9k/initvals.h |    0
 drivers/net/wireless/{ => ath}/ath9k/mac.c      |    0
 drivers/net/wireless/{ => ath}/ath9k/mac.h      |    0
 drivers/net/wireless/{ => ath}/ath9k/main.c     |    0
 drivers/net/wireless/{ => ath}/ath9k/pci.c      |    0
 drivers/net/wireless/{ => ath}/ath9k/phy.c      |    0
 drivers/net/wireless/{ => ath}/ath9k/phy.h      |    0
 drivers/net/wireless/{ => ath}/ath9k/rc.c       |    0
 drivers/net/wireless/{ => ath}/ath9k/rc.h       |    0
 drivers/net/wireless/{ => ath}/ath9k/recv.c     |    0
 drivers/net/wireless/{ => ath}/ath9k/reg.h      |    0
 drivers/net/wireless/{ => ath}/ath9k/virtual.c  |    0
 drivers/net/wireless/{ => ath}/ath9k/xmit.c     |    0
 69 files changed, 12 insertions(+), 10 deletions(-)
 rename drivers/net/wireless/{ => ath}/ar9170/Kconfig (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/Makefile (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/ar9170.h (99%)
 rename drivers/net/wireless/{ => ath}/ar9170/cmd.c (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/cmd.h (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/eeprom.h (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/hw.h (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/led.c (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/mac.c (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/main.c (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/phy.c (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/usb.c (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/usb.h (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/Kconfig (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/Makefile (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/ath5k.h (99%)
 rename drivers/net/wireless/{ => ath}/ath5k/attach.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/base.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/base.h (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/caps.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/debug.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/debug.h (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/desc.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/desc.h (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/dma.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/eeprom.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/eeprom.h (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/gpio.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/initvals.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/led.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/pcu.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/phy.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/qcu.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/reg.h (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/reset.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/rfbuffer.h (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/rfgain.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/Kconfig (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/Makefile (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/ahb.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/ani.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/ani.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/ath9k.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/beacon.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/calib.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/calib.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/debug.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/debug.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/eeprom.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/eeprom.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/hw.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/hw.h (99%)
 rename drivers/net/wireless/{ => ath}/ath9k/initvals.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/mac.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/mac.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/main.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/pci.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/phy.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/phy.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/rc.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/rc.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/recv.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/reg.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/virtual.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/xmit.c (100%)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 9e2c7e2..8f279e7 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -484,9 +484,6 @@ config MWL8K
 
 source "drivers/net/wireless/p54/Kconfig"
 source "drivers/net/wireless/ath/Kconfig"
-source "drivers/net/wireless/ath5k/Kconfig"
-source "drivers/net/wireless/ath9k/Kconfig"
-source "drivers/net/wireless/ar9170/Kconfig"
 source "drivers/net/wireless/ipw2x00/Kconfig"
 source "drivers/net/wireless/iwlwifi/Kconfig"
 source "drivers/net/wireless/hostap/Kconfig"
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 104639e..0625e91 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -56,8 +56,5 @@ obj-$(CONFIG_RT2X00)	+= rt2x00/
 obj-$(CONFIG_P54_COMMON)	+= p54/
 
 obj-$(CONFIG_ATH_COMMON)	+= ath/
-obj-$(CONFIG_ATH5K)	+= ath5k/
-obj-$(CONFIG_ATH9K)	+= ath9k/
-obj-$(CONFIG_AR9170_USB)	+= ar9170/
 
 obj-$(CONFIG_MAC80211_HWSIM)	+= mac80211_hwsim.o
diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index 76517a4..d26e7b4 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -1,4 +1,8 @@
 config ATH_COMMON
-	tristate "Atheros Wireless Cards Shared Support"
+	tristate "Atheros Wireless Cards"
 	depends on ATH5K || ATH9K || AR9170_USB
 
+source "drivers/net/wireless/ath/ath5k/Kconfig"
+source "drivers/net/wireless/ath/ath9k/Kconfig"
+source "drivers/net/wireless/ath/ar9170/Kconfig"
+
diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
index bc77646..a005b91 100644
--- a/drivers/net/wireless/ath/Makefile
+++ b/drivers/net/wireless/ath/Makefile
@@ -1,3 +1,7 @@
+obj-$(CONFIG_ATH5K)		+= ath5k/
+obj-$(CONFIG_ATH9K)		+= ath9k/
+obj-$(CONFIG_AR9170_USB)        += ar9170/
+
 obj-$(CONFIG_ATH_COMMON)	+= ath.o
 ath-objs 		:= regd.o
 
diff --git a/drivers/net/wireless/ar9170/Kconfig b/drivers/net/wireless/ath/ar9170/Kconfig
similarity index 100%
rename from drivers/net/wireless/ar9170/Kconfig
rename to drivers/net/wireless/ath/ar9170/Kconfig
diff --git a/drivers/net/wireless/ar9170/Makefile b/drivers/net/wireless/ath/ar9170/Makefile
similarity index 100%
rename from drivers/net/wireless/ar9170/Makefile
rename to drivers/net/wireless/ath/ar9170/Makefile
diff --git a/drivers/net/wireless/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
similarity index 99%
rename from drivers/net/wireless/ar9170/ar9170.h
rename to drivers/net/wireless/ath/ar9170/ar9170.h
index 87c1985..f797495 100644
--- a/drivers/net/wireless/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -48,7 +48,7 @@
 #include "eeprom.h"
 #include "hw.h"
 
-#include "../ath/regd.h"
+#include "../regd.h"
 
 #define PAYLOAD_MAX	(AR9170_MAX_CMD_LEN/4 - 1)
 
diff --git a/drivers/net/wireless/ar9170/cmd.c b/drivers/net/wireless/ath/ar9170/cmd.c
similarity index 100%
rename from drivers/net/wireless/ar9170/cmd.c
rename to drivers/net/wireless/ath/ar9170/cmd.c
diff --git a/drivers/net/wireless/ar9170/cmd.h b/drivers/net/wireless/ath/ar9170/cmd.h
similarity index 100%
rename from drivers/net/wireless/ar9170/cmd.h
rename to drivers/net/wireless/ath/ar9170/cmd.h
diff --git a/drivers/net/wireless/ar9170/eeprom.h b/drivers/net/wireless/ath/ar9170/eeprom.h
similarity index 100%
rename from drivers/net/wireless/ar9170/eeprom.h
rename to drivers/net/wireless/ath/ar9170/eeprom.h
diff --git a/drivers/net/wireless/ar9170/hw.h b/drivers/net/wireless/ath/ar9170/hw.h
similarity index 100%
rename from drivers/net/wireless/ar9170/hw.h
rename to drivers/net/wireless/ath/ar9170/hw.h
diff --git a/drivers/net/wireless/ar9170/led.c b/drivers/net/wireless/ath/ar9170/led.c
similarity index 100%
rename from drivers/net/wireless/ar9170/led.c
rename to drivers/net/wireless/ath/ar9170/led.c
diff --git a/drivers/net/wireless/ar9170/mac.c b/drivers/net/wireless/ath/ar9170/mac.c
similarity index 100%
rename from drivers/net/wireless/ar9170/mac.c
rename to drivers/net/wireless/ath/ar9170/mac.c
diff --git a/drivers/net/wireless/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
similarity index 100%
rename from drivers/net/wireless/ar9170/main.c
rename to drivers/net/wireless/ath/ar9170/main.c
diff --git a/drivers/net/wireless/ar9170/phy.c b/drivers/net/wireless/ath/ar9170/phy.c
similarity index 100%
rename from drivers/net/wireless/ar9170/phy.c
rename to drivers/net/wireless/ath/ar9170/phy.c
diff --git a/drivers/net/wireless/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
similarity index 100%
rename from drivers/net/wireless/ar9170/usb.c
rename to drivers/net/wireless/ath/ar9170/usb.c
diff --git a/drivers/net/wireless/ar9170/usb.h b/drivers/net/wireless/ath/ar9170/usb.h
similarity index 100%
rename from drivers/net/wireless/ar9170/usb.h
rename to drivers/net/wireless/ath/ar9170/usb.h
diff --git a/drivers/net/wireless/ath5k/Kconfig b/drivers/net/wireless/ath/ath5k/Kconfig
similarity index 100%
rename from drivers/net/wireless/ath5k/Kconfig
rename to drivers/net/wireless/ath/ath5k/Kconfig
diff --git a/drivers/net/wireless/ath5k/Makefile b/drivers/net/wireless/ath/ath5k/Makefile
similarity index 100%
rename from drivers/net/wireless/ath5k/Makefile
rename to drivers/net/wireless/ath/ath5k/Makefile
diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
similarity index 99%
rename from drivers/net/wireless/ath5k/ath5k.h
rename to drivers/net/wireless/ath/ath5k/ath5k.h
index 48c18d1..60c6d2e 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -27,7 +27,7 @@
 #include <linux/types.h>
 #include <net/mac80211.h>
 
-#include "../ath/regd.h"
+#include "../regd.h"
 
 /* RX/TX descriptor hw structs
  * TODO: Driver part should only see sw structs */
diff --git a/drivers/net/wireless/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
similarity index 100%
rename from drivers/net/wireless/ath5k/attach.c
rename to drivers/net/wireless/ath/ath5k/attach.c
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
similarity index 100%
rename from drivers/net/wireless/ath5k/base.c
rename to drivers/net/wireless/ath/ath5k/base.c
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
similarity index 100%
rename from drivers/net/wireless/ath5k/base.h
rename to drivers/net/wireless/ath/ath5k/base.h
diff --git a/drivers/net/wireless/ath5k/caps.c b/drivers/net/wireless/ath/ath5k/caps.c
similarity index 100%
rename from drivers/net/wireless/ath5k/caps.c
rename to drivers/net/wireless/ath/ath5k/caps.c
diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
similarity index 100%
rename from drivers/net/wireless/ath5k/debug.c
rename to drivers/net/wireless/ath/ath5k/debug.c
diff --git a/drivers/net/wireless/ath5k/debug.h b/drivers/net/wireless/ath/ath5k/debug.h
similarity index 100%
rename from drivers/net/wireless/ath5k/debug.h
rename to drivers/net/wireless/ath/ath5k/debug.h
diff --git a/drivers/net/wireless/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
similarity index 100%
rename from drivers/net/wireless/ath5k/desc.c
rename to drivers/net/wireless/ath/ath5k/desc.c
diff --git a/drivers/net/wireless/ath5k/desc.h b/drivers/net/wireless/ath/ath5k/desc.h
similarity index 100%
rename from drivers/net/wireless/ath5k/desc.h
rename to drivers/net/wireless/ath/ath5k/desc.h
diff --git a/drivers/net/wireless/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
similarity index 100%
rename from drivers/net/wireless/ath5k/dma.c
rename to drivers/net/wireless/ath/ath5k/dma.c
diff --git a/drivers/net/wireless/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
similarity index 100%
rename from drivers/net/wireless/ath5k/eeprom.c
rename to drivers/net/wireless/ath/ath5k/eeprom.c
diff --git a/drivers/net/wireless/ath5k/eeprom.h b/drivers/net/wireless/ath/ath5k/eeprom.h
similarity index 100%
rename from drivers/net/wireless/ath5k/eeprom.h
rename to drivers/net/wireless/ath/ath5k/eeprom.h
diff --git a/drivers/net/wireless/ath5k/gpio.c b/drivers/net/wireless/ath/ath5k/gpio.c
similarity index 100%
rename from drivers/net/wireless/ath5k/gpio.c
rename to drivers/net/wireless/ath/ath5k/gpio.c
diff --git a/drivers/net/wireless/ath5k/initvals.c b/drivers/net/wireless/ath/ath5k/initvals.c
similarity index 100%
rename from drivers/net/wireless/ath5k/initvals.c
rename to drivers/net/wireless/ath/ath5k/initvals.c
diff --git a/drivers/net/wireless/ath5k/led.c b/drivers/net/wireless/ath/ath5k/led.c
similarity index 100%
rename from drivers/net/wireless/ath5k/led.c
rename to drivers/net/wireless/ath/ath5k/led.c
diff --git a/drivers/net/wireless/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
similarity index 100%
rename from drivers/net/wireless/ath5k/pcu.c
rename to drivers/net/wireless/ath/ath5k/pcu.c
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
similarity index 100%
rename from drivers/net/wireless/ath5k/phy.c
rename to drivers/net/wireless/ath/ath5k/phy.c
diff --git a/drivers/net/wireless/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
similarity index 100%
rename from drivers/net/wireless/ath5k/qcu.c
rename to drivers/net/wireless/ath/ath5k/qcu.c
diff --git a/drivers/net/wireless/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
similarity index 100%
rename from drivers/net/wireless/ath5k/reg.h
rename to drivers/net/wireless/ath/ath5k/reg.h
diff --git a/drivers/net/wireless/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
similarity index 100%
rename from drivers/net/wireless/ath5k/reset.c
rename to drivers/net/wireless/ath/ath5k/reset.c
diff --git a/drivers/net/wireless/ath5k/rfbuffer.h b/drivers/net/wireless/ath/ath5k/rfbuffer.h
similarity index 100%
rename from drivers/net/wireless/ath5k/rfbuffer.h
rename to drivers/net/wireless/ath/ath5k/rfbuffer.h
diff --git a/drivers/net/wireless/ath5k/rfgain.h b/drivers/net/wireless/ath/ath5k/rfgain.h
similarity index 100%
rename from drivers/net/wireless/ath5k/rfgain.h
rename to drivers/net/wireless/ath/ath5k/rfgain.h
diff --git a/drivers/net/wireless/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
similarity index 100%
rename from drivers/net/wireless/ath9k/Kconfig
rename to drivers/net/wireless/ath/ath9k/Kconfig
diff --git a/drivers/net/wireless/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
similarity index 100%
rename from drivers/net/wireless/ath9k/Makefile
rename to drivers/net/wireless/ath/ath9k/Makefile
diff --git a/drivers/net/wireless/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
similarity index 100%
rename from drivers/net/wireless/ath9k/ahb.c
rename to drivers/net/wireless/ath/ath9k/ahb.c
diff --git a/drivers/net/wireless/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
similarity index 100%
rename from drivers/net/wireless/ath9k/ani.c
rename to drivers/net/wireless/ath/ath9k/ani.c
diff --git a/drivers/net/wireless/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
similarity index 100%
rename from drivers/net/wireless/ath9k/ani.h
rename to drivers/net/wireless/ath/ath9k/ani.h
diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
similarity index 100%
rename from drivers/net/wireless/ath9k/ath9k.h
rename to drivers/net/wireless/ath/ath9k/ath9k.h
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
similarity index 100%
rename from drivers/net/wireless/ath9k/beacon.c
rename to drivers/net/wireless/ath/ath9k/beacon.c
diff --git a/drivers/net/wireless/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
similarity index 100%
rename from drivers/net/wireless/ath9k/calib.c
rename to drivers/net/wireless/ath/ath9k/calib.c
diff --git a/drivers/net/wireless/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
similarity index 100%
rename from drivers/net/wireless/ath9k/calib.h
rename to drivers/net/wireless/ath/ath9k/calib.h
diff --git a/drivers/net/wireless/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
similarity index 100%
rename from drivers/net/wireless/ath9k/debug.c
rename to drivers/net/wireless/ath/ath9k/debug.c
diff --git a/drivers/net/wireless/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
similarity index 100%
rename from drivers/net/wireless/ath9k/debug.h
rename to drivers/net/wireless/ath/ath9k/debug.h
diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
similarity index 100%
rename from drivers/net/wireless/ath9k/eeprom.c
rename to drivers/net/wireless/ath/ath9k/eeprom.c
diff --git a/drivers/net/wireless/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
similarity index 100%
rename from drivers/net/wireless/ath9k/eeprom.h
rename to drivers/net/wireless/ath/ath9k/eeprom.h
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
similarity index 100%
rename from drivers/net/wireless/ath9k/hw.c
rename to drivers/net/wireless/ath/ath9k/hw.c
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
similarity index 99%
rename from drivers/net/wireless/ath9k/hw.h
rename to drivers/net/wireless/ath/ath9k/hw.h
index 984ac7d..5c4127e 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -28,7 +28,7 @@
 #include "reg.h"
 #include "phy.h"
 
-#include "../ath/regd.h"
+#include "../regd.h"
 
 #define ATHEROS_VENDOR_ID	0x168c
 #define AR5416_DEVID_PCI	0x0023
diff --git a/drivers/net/wireless/ath9k/initvals.h b/drivers/net/wireless/ath/ath9k/initvals.h
similarity index 100%
rename from drivers/net/wireless/ath9k/initvals.h
rename to drivers/net/wireless/ath/ath9k/initvals.h
diff --git a/drivers/net/wireless/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
similarity index 100%
rename from drivers/net/wireless/ath9k/mac.c
rename to drivers/net/wireless/ath/ath9k/mac.c
diff --git a/drivers/net/wireless/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
similarity index 100%
rename from drivers/net/wireless/ath9k/mac.h
rename to drivers/net/wireless/ath/ath9k/mac.h
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
similarity index 100%
rename from drivers/net/wireless/ath9k/main.c
rename to drivers/net/wireless/ath/ath9k/main.c
diff --git a/drivers/net/wireless/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
similarity index 100%
rename from drivers/net/wireless/ath9k/pci.c
rename to drivers/net/wireless/ath/ath9k/pci.c
diff --git a/drivers/net/wireless/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
similarity index 100%
rename from drivers/net/wireless/ath9k/phy.c
rename to drivers/net/wireless/ath/ath9k/phy.c
diff --git a/drivers/net/wireless/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
similarity index 100%
rename from drivers/net/wireless/ath9k/phy.h
rename to drivers/net/wireless/ath/ath9k/phy.h
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
similarity index 100%
rename from drivers/net/wireless/ath9k/rc.c
rename to drivers/net/wireless/ath/ath9k/rc.c
diff --git a/drivers/net/wireless/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
similarity index 100%
rename from drivers/net/wireless/ath9k/rc.h
rename to drivers/net/wireless/ath/ath9k/rc.h
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
similarity index 100%
rename from drivers/net/wireless/ath9k/recv.c
rename to drivers/net/wireless/ath/ath9k/recv.c
diff --git a/drivers/net/wireless/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
similarity index 100%
rename from drivers/net/wireless/ath9k/reg.h
rename to drivers/net/wireless/ath/ath9k/reg.h
diff --git a/drivers/net/wireless/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
similarity index 100%
rename from drivers/net/wireless/ath9k/virtual.c
rename to drivers/net/wireless/ath/ath9k/virtual.c
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
similarity index 100%
rename from drivers/net/wireless/ath9k/xmit.c
rename to drivers/net/wireless/ath/ath9k/xmit.c
-- 
1.6.0.6

