Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42372 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab0BPR4x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 12:56:53 -0500
Date: Tue, 16 Feb 2010 11:56:50 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>
Subject: [PATCH 5/5] rtl8187se: Modify rtl818x makefile
Message-ID: <4b7adc62.8QA8+PaKuvWOxerG%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modify the wireless Makefile for RTL8187SE.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 Makefile         |    1 +
 rtl818x/Makefile |    2 ++
 2 files changed, 3 insertions(+)

Index: wireless-testing/drivers/net/wireless/Makefile
===================================================================
--- wireless-testing.orig/drivers/net/wireless/Makefile
+++ wireless-testing/drivers/net/wireless/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_B43LEGACY)		+= b43legacy/
 obj-$(CONFIG_ZD1211RW)		+= zd1211rw/
 obj-$(CONFIG_RTL8180)		+= rtl818x/
 obj-$(CONFIG_RTL8187)		+= rtl818x/
+obj-$(CONFIG_RTL8187SE)		+= rtl818x/
 
 # 16-bit wireless PCMCIA client drivers
 obj-$(CONFIG_PCMCIA_RAYCS)	+= ray_cs.o
Index: wireless-testing/drivers/net/wireless/rtl818x/Makefile
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/Makefile
+++ wireless-testing/drivers/net/wireless/rtl818x/Makefile
@@ -1,7 +1,9 @@
 rtl8180-objs		:= rtl8180_dev.o rtl8180_rtl8225.o rtl8180_sa2400.o rtl8180_max2820.o rtl8180_grf5101.o
 rtl8187-objs		:= rtl8187_dev.o rtl8187_rtl8225.o rtl8187_leds.o rtl8187_rfkill.o
+rtl8187se-objs		:= rtl8187se_rfkill.o
 
 obj-$(CONFIG_RTL8180)	+= rtl8180.o
 obj-$(CONFIG_RTL8187)	+= rtl8187.o
+obj-$(CONFIG_RTL8187SE)	+= rtl8187se.o
 
 
