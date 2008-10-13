Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:47650 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755346AbYJMXe2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 19:34:28 -0400
Message-ID: <48F3DB02.3060002@lwfinger.net> (sfid-20081014_013432_151579_B5872823)
Date: Mon, 13 Oct 2008 16:34:26 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Florent Fourcot <florent.fourcot@enst-bretagne.fr>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] rtl8187: Add USB ID for Belkin F5D7050 with RTL8187B chip
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Florent Fourcot <florent.fourcot@enst-bretagne.fr>

The Belkin F5D7050rev5000de (id 050d:705e) has the Realtek RTL8187B chip
and works with the 2.6.27 driver.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.28 material.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl8187_dev.c
@@ -33,6 +33,8 @@ MODULE_LICENSE("GPL");
 static struct usb_device_id rtl8187_table[] __devinitdata = {
 	/* Asus */
 	{USB_DEVICE(0x0b05, 0x171d), .driver_info = DEVICE_RTL8187},
+	/* Belkin */
+	{USB_DEVICE(0x050d, 0x705e), .driver_info = DEVICE_RTL8187B},
 	/* Realtek */
 	{USB_DEVICE(0x0bda, 0x8187), .driver_info = DEVICE_RTL8187},
 	{USB_DEVICE(0x0bda, 0x8189), .driver_info = DEVICE_RTL8187B},

