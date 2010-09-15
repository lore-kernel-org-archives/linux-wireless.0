Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55196 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab0IOUnu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 16:43:50 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat-wireless: make patch apply again.
Date: Wed, 15 Sep 2010 22:43:33 +0200
Message-Id: <1284583415-11506-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/99-change-makefiles.patch |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/patches/99-change-makefiles.patch b/patches/99-change-makefiles.patch
index 47f3b5c..c75f4f2 100644
--- a/patches/99-change-makefiles.patch
+++ b/patches/99-change-makefiles.patch
@@ -13,7 +13,7 @@ only the wireless stuff.
  obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
 --- a/drivers/net/usb/Makefile
 +++ b/drivers/net/usb/Makefile
-@@ -2,27 +2,7 @@
+@@ -2,28 +2,7 @@
  # Makefile for USB Network drivers
  #
  
@@ -40,6 +40,7 @@ only the wireless stuff.
 -obj-$(CONFIG_USB_CDC_PHONET)	+= cdc-phonet.o
 -obj-$(CONFIG_USB_IPHETH)	+= ipheth.o
 -obj-$(CONFIG_USB_SIERRA_NET)	+= sierra_net.o
+-obj-$(CONFIG_USB_NET_CX82310_ETH)	+= cx82310_eth.o
  
 --- a/drivers/net/wireless/Makefile
 +++ b/drivers/net/wireless/Makefile
-- 
1.7.0.4

