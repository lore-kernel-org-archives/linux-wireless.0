Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:49952
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbXI0Mpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 08:45:47 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rfkill: Fix documentation typos
Date: Thu, 27 Sep 2007 14:42:42 +0200
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709271442.42808.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/include/linux/rfkill.h
===================================================================
--- wireless-2.6.orig/include/linux/rfkill.h	2007-09-25 21:41:11.000000000 +0200
+++ wireless-2.6/include/linux/rfkill.h	2007-09-27 14:41:31.000000000 +0200
@@ -29,9 +29,9 @@
 
 /**
  * enum rfkill_type - type of rfkill switch.
- * RFKILL_TYPE_WLAN: switch is no a Wireless network devices.
- * RFKILL_TYPE_BlUETOOTH: switch is on a bluetooth device.
- * RFKILL_TYPE_IRDA: switch is on an infrared devices.
+ * RFKILL_TYPE_WLAN: switch is on a 802.11 wireless network device.
+ * RFKILL_TYPE_BLUETOOTH: switch is on a bluetooth device.
+ * RFKILL_TYPE_IRDA: switch is on an infrared device.
  */
 enum rfkill_type {
 	RFKILL_TYPE_WLAN = 0,

-- 
Greetings Michael.
