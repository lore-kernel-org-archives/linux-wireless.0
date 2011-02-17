Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:27047 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab1BQWiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 17:38:24 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000022266.msg
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 00:37:46 +0200
Subject: Re: [RFC] AI support (12/14 ssb mips74k core defs)
From: George Kashperko <george@znau.edu.ua>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297980093.13554.5.camel@maggie>
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>
Content-Type: text/plain
Date: Fri, 18 Feb 2011 00:29:33 +0200
Message-Id: <1297981773.23381.35.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bernhard Loos <bernhardloos@googlemail.com>

Add MIPS74K device id defines.
Signed-off-by: George Kashperko <george@znau.edu.ua>
---
 drivers/ssb/scan.c      |    8 ++++++++
 include/linux/ssb/ssb.h |    4 ++++
 2 files changed, 12 insertions(+)
--- linux-wireless-testing.orig/drivers/ssb/scan.c	2011-02-17 14:53:03.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/scan.c	2011-02-17 14:53:28.000000000 +0200
@@ -90,6 +90,14 @@ const char *ssb_core_name(u16 coreid)
 		return "ARM 1176";
 	case SSB_DEV_ARM_7TDMI:
 		return "ARM 7TDMI";
+	case SSB_DEV_ETHERNET_GMAC:
+		return "Gigabit MAC";
+	case SSB_DEV_MIPS_74K:
+		return "MIPS 74K";
+	case SSB_DEV_DDR_CTRLR:
+		return "DDR1/2 memory controller";
+	case SSB_DEV_I2S:
+		return "I2S";
 	}
 	return "UNKNOWN";
 }
--- linux-wireless-testing.orig/include/linux/ssb/ssb.h	2011-02-17 14:28:49.000000000 +0200
+++ linux-wireless-testing/include/linux/ssb/ssb.h	2011-02-17 14:53:28.000000000 +0200
@@ -166,6 +166,10 @@ struct ssb_bus_helpers {
 #define SSB_DEV_MINI_MACPHY	0x823
 #define SSB_DEV_ARM_1176	0x824
 #define SSB_DEV_ARM_7TDMI	0x825
+#define SSB_DEV_ETHERNET_GMAC	0x82D
+#define SSB_DEV_MIPS_74K	0x82C
+#define SSB_DEV_DDR_CTRLR	0x82E
+#define SSB_DEV_I2S		0x834
 
 /* Vendor-ID values */
 #define SSB_VENDOR_BROADCOM	0x4243



