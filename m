Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52695 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab1DGOkU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 10:40:20 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: make patches apply again
Date: Thu,  7 Apr 2011 16:39:46 +0200
Message-Id: <1302187186-15327-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1302187186-15327-1-git-send-email-hauke@hauke-m.de>
References: <1302187186-15327-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/99-change-makefiles.patch |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/patches/99-change-makefiles.patch b/patches/99-change-makefiles.patch
index dcdad19..be62e28 100644
--- a/patches/99-change-makefiles.patch
+++ b/patches/99-change-makefiles.patch
@@ -13,7 +13,7 @@ only the wireless stuff.
  obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
 --- a/drivers/net/usb/Makefile
 +++ b/drivers/net/usb/Makefile
-@@ -2,29 +2,7 @@
+@@ -2,30 +2,7 @@
  # Makefile for USB Network drivers
  #
  
@@ -42,6 +42,7 @@ only the wireless stuff.
 -obj-$(CONFIG_USB_SIERRA_NET)	+= sierra_net.o
 -obj-$(CONFIG_USB_NET_CX82310_ETH)	+= cx82310_eth.o
 -obj-$(CONFIG_USB_NET_CDC_NCM)	+= cdc_ncm.o
+-obj-$(CONFIG_USB_VL600)		+= lg-vl600.o
  
 --- a/drivers/net/wireless/Makefile
 +++ b/drivers/net/wireless/Makefile
-- 
1.7.1

