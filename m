Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50301 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab1LCOqx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Dec 2011 09:46:53 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/6] compat-wireless: remove some modules from Makefile
Date: Sat,  3 Dec 2011 15:46:21 +0100
Message-Id: <1322923585-13966-2-git-send-email-hauke@hauke-m.de> (sfid-20111203_154656_822015_0ADA890C)
In-Reply-To: <1322923585-13966-1-git-send-email-hauke@hauke-m.de>
References: <1322923585-13966-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The removed build targets are not shipped with compat-wireless.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/99-change-makefiles.patch |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/patches/99-change-makefiles.patch b/patches/99-change-makefiles.patch
index 4767d7d..a7ddb51 100644
--- a/patches/99-change-makefiles.patch
+++ b/patches/99-change-makefiles.patch
@@ -5,14 +5,14 @@ only the wireless stuff.
 
 --- a/drivers/misc/eeprom/Makefile
 +++ b/drivers/misc/eeprom/Makefile
-@@ -1,7 +1,3 @@
+@@ -1,7 +1 @@
 -obj-$(CONFIG_EEPROM_AT24)	+= at24.o
 -obj-$(CONFIG_EEPROM_AT25)	+= at25.o
 -obj-$(CONFIG_EEPROM_LEGACY)	+= eeprom.o
 -obj-$(CONFIG_EEPROM_MAX6875)	+= max6875.o
  obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
- obj-$(CONFIG_EEPROM_93XX46)	+= eeprom_93xx46.o
- obj-$(CONFIG_EEPROM_DIGSY_MTC_CFG) += digsy_mtc_eeprom.o
+-obj-$(CONFIG_EEPROM_93XX46)	+= eeprom_93xx46.o
+-obj-$(CONFIG_EEPROM_DIGSY_MTC_CFG) += digsy_mtc_eeprom.o
 --- a/drivers/net/usb/Makefile
 +++ b/drivers/net/usb/Makefile
 @@ -2,31 +2,7 @@
-- 
1.7.5.4

