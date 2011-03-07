Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:53276 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab1CGMba (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 07:31:30 -0500
Subject: [PATCH] p54spi: Update kconfig help text
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 13:31:24 +0100
Message-ID: <1299501084.5665.13.camel@marge>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This updates the p54spi Kconfig help text.
The driver works well on n8x0, so remove the words "experimental" and "untested".

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Index: wireless-testing/drivers/net/wireless/p54/Kconfig
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/Kconfig	2011-03-07 13:24:24.874403593 +0100
+++ wireless-testing/drivers/net/wireless/p54/Kconfig	2011-03-07 13:25:00.601089969 +0100
@@ -43,9 +43,8 @@ config P54_SPI
 	tristate "Prism54 SPI (stlc45xx) support"
 	depends on P54_COMMON && SPI_MASTER && GENERIC_HARDIRQS
 	---help---
-	  This driver is for stlc4550 or stlc4560 based wireless chips.
-	  This driver is experimental, untested and will probably only work on
-	  Nokia's N800/N810 Portable Internet Tablet.
+	  This driver is for stlc4550 or stlc4560 based wireless chips
+	  such as Nokia's N800/N810 Portable Internet Tablet.
 
 	  If you choose to build a module, it'll be called p54spi.
 

-- 
Greetings, Michael.

