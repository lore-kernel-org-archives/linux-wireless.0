Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40010 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbZADXWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 18:22:35 -0500
Date: Sun, 04 Jan 2009 17:22:28 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>, chunkeey@web.de
Cc: michiel@ettema.net, linux-wireless@vger.kernel.org
Subject: [PATCH] p54usb: Add USB ID for Thomson Speedtouch 121g
Message-ID: <496144b4.iPUdF4BLnkZPcWDl%Larry.Finger@lwfinger.net> (sfid-20090105_002240_008972_D1D9D89D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michiel <michiel@ettema.net>

Add the USB ID for Thomson Speedtouch 121g to p54usb.

Signed-off-by: Michiel <michiel@ettema.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This should be included in 2.6.29.

Larry
---

Index: wireless-testing/drivers/net/wireless/p54/p54usb.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/p54usb.c
+++ wireless-testing/drivers/net/wireless/p54/p54usb.c
@@ -56,6 +56,7 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x050d, 0x7050)},	/* Belkin F5D7050 ver 1000 */
 	{USB_DEVICE(0x0572, 0x2000)},	/* Cohiba Proto board */
 	{USB_DEVICE(0x0572, 0x2002)},	/* Cohiba Proto board */
+	{USB_DEVICE(0x06b9, 0x0121)},	/* Thomson SpeedTouch 121g */
 	{USB_DEVICE(0x0707, 0xee13)},   /* SMC 2862W-G version 2 */
 	{USB_DEVICE(0x083a, 0x4521)},   /* Siemens Gigaset USB Adapter 54 version 2 */
 	{USB_DEVICE(0x0846, 0x4240)},	/* Netgear WG111 (v2) */
