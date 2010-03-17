Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54225 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab0CQU6W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 16:58:22 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: refresh patch to apply again
Date: Wed, 17 Mar 2010 21:58:14 +0100
Message-Id: <1268859494-12019-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1268859494-12019-1-git-send-email-hauke@hauke-m.de>
References: <1268859494-12019-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/18-rename-usb-net-symbols.patch |    5 +++--
 patches/99-change-makefiles.patch       |    3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/patches/18-rename-usb-net-symbols.patch b/patches/18-rename-usb-net-symbols.patch
index 5ac90e2..7369817 100644
--- a/patches/18-rename-usb-net-symbols.patch
+++ b/patches/18-rename-usb-net-symbols.patch
@@ -6,7 +6,7 @@ Remove this patch if these symbols are backported.
 
 --- a/drivers/net/usb/Makefile
 +++ b/drivers/net/usb/Makefile
-@@ -8,18 +8,18 @@ obj-$(CONFIG_USB_PEGASUS)	+= pegasus.o
+@@ -8,7 +8,7 @@ obj-$(CONFIG_USB_PEGASUS)	+= pegasus.o
  obj-$(CONFIG_USB_RTL8150)	+= rtl8150.o
  obj-$(CONFIG_USB_HSO)		+= hso.o
  obj-$(CONFIG_USB_NET_AX8817X)	+= asix.o
@@ -14,7 +14,8 @@ Remove this patch if these symbols are backported.
 +obj-$(CONFIG_USB_NET_COMPAT_CDCETHER)	+= cdc_ether.o
  obj-$(CONFIG_USB_NET_CDC_EEM)	+= cdc_eem.o
  obj-$(CONFIG_USB_NET_DM9601)	+= dm9601.o
- obj-$(CONFIG_USB_NET_SMSC95XX)	+= smsc95xx.o
+ obj-$(CONFIG_USB_NET_SMSC75XX)	+= smsc75xx.o
+@@ -16,11 +16,11 @@ obj-$(CONFIG_USB_NET_SMSC95XX)	+= smsc95
  obj-$(CONFIG_USB_NET_GL620A)	+= gl620a.o
  obj-$(CONFIG_USB_NET_NET1080)	+= net1080.o
  obj-$(CONFIG_USB_NET_PLUSB)	+= plusb.o
diff --git a/patches/99-change-makefiles.patch b/patches/99-change-makefiles.patch
index 7d59537..8a60060 100644
--- a/patches/99-change-makefiles.patch
+++ b/patches/99-change-makefiles.patch
@@ -13,7 +13,7 @@ only the wireless stuff.
  obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
 --- a/drivers/net/usb/Makefile
 +++ b/drivers/net/usb/Makefile
-@@ -2,24 +2,7 @@
+@@ -2,25 +2,7 @@
  # Makefile for USB Network drivers
  #
  
@@ -26,6 +26,7 @@ only the wireless stuff.
  obj-$(CONFIG_USB_NET_COMPAT_CDCETHER)	+= cdc_ether.o
 -obj-$(CONFIG_USB_NET_CDC_EEM)	+= cdc_eem.o
 -obj-$(CONFIG_USB_NET_DM9601)	+= dm9601.o
+-obj-$(CONFIG_USB_NET_SMSC75XX)	+= smsc75xx.o
 -obj-$(CONFIG_USB_NET_SMSC95XX)	+= smsc95xx.o
 -obj-$(CONFIG_USB_NET_GL620A)	+= gl620a.o
 -obj-$(CONFIG_USB_NET_NET1080)	+= net1080.o
-- 
1.6.3.3

