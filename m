Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:54747 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab0LHRUu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 12:20:50 -0500
Received: by pxi20 with SMTP id 20so424476pxi.10
        for <linux-wireless@vger.kernel.org>; Wed, 08 Dec 2010 09:20:50 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, chaoming_li@realsil.com.cn,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 22/22] rtl8192ce: Part 22: Update drivers/net/wireless/Kconfig and Makefile
Date: Wed,  8 Dec 2010 11:12:52 -0600
Message-Id: <1291828372-25159-23-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1291828372-25159-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1291828372-25159-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix rtlwifi/Makefile

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/Kconfig          |    1 +
 drivers/net/wireless/Makefile         |    1 +
 drivers/net/wireless/rtlwifi/Makefile |    2 +-
 3 files changed, 3 insertions(+), 1 deletions(-)

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
diff --git a/drivers/net/wireless/rtlwifi/Makefile b/drivers/net/wireless/rtlwifi/Makefile
index cd2fb60..2a7a438 100644
--- a/drivers/net/wireless/rtlwifi/Makefile
+++ b/drivers/net/wireless/rtlwifi/Makefile
@@ -10,4 +10,4 @@ rtlwifi-objs	:=		\
 		rc.o		\
 		regd.o
 
-obj-$(CONFIG_RTL8192CE)		+= rtl8192c/
+obj-$(CONFIG_RTL8192CE)		+= rtl8192ce/
-- 
1.7.1

