Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53853 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab0KUC0E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Nov 2010 21:26:04 -0500
Date: Sat, 20 Nov 2010 20:25:56 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [RFC PATCH 23/23] rtl8192ce: Introduce new driver
Message-ID: <4ce88334.xoHPgnhpyE2s6KW7%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 7137ad1e1b6c9e1d8ac5a62b0d18ed9f715bc7c3 Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Sat, 20 Nov 2010 19:25:12 -0600
Subject: [PATCH 23/23] rtl8192ce: rtlwifi: Modify Kconfig and Makefile for new driver

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/Kconfig  |    1 +
 drivers/net/wireless/Makefile |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 4de4410..b4338f3 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -279,6 +279,7 @@ source "drivers/net/wireless/libertas/Kconfig"
 source "drivers/net/wireless/orinoco/Kconfig"
 source "drivers/net/wireless/p54/Kconfig"
 source "drivers/net/wireless/rt2x00/Kconfig"
+source "drivers/net/wireless/rtlwifi/Kconfig"
 source "drivers/net/wireless/wl1251/Kconfig"
 source "drivers/net/wireless/wl12xx/Kconfig"
 source "drivers/net/wireless/zd1211rw/Kconfig"
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 06f8ca2..9760561 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_B43LEGACY)		+= b43legacy/
 obj-$(CONFIG_ZD1211RW)		+= zd1211rw/
 obj-$(CONFIG_RTL8180)		+= rtl818x/
 obj-$(CONFIG_RTL8187)		+= rtl818x/
+obj-$(CONFIG_RTL8192CE)		+= rtlwifi/
 
 # 16-bit wireless PCMCIA client drivers
 obj-$(CONFIG_PCMCIA_RAYCS)	+= ray_cs.o
-- 
1.7.1

