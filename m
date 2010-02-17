Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62659 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab0BQQ7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 11:59:34 -0500
Date: Wed, 17 Feb 2010 10:59:31 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: moinejf@free.fr, linux-wireless@vger.kernel.org
Subject: [PATCH] p54usb: Add the USB ID for Belkin (Accton) FD7050E ver
 1010ec
Message-ID: <4b7c2073.h47OtAV0+/xBdqy0%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jean-François Moine <moinejf@free.fr>

Yet another USB ID.

Signed-off-by: Jean-François Moine <moinejf@free.fr>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@kernel.org>
---

--- linux-2.6.32.3/drivers/net/wireless/p54/p54usb.c.orig	2010-01-07 00:07:45.000000000 +0100
+++ linux-2.6.32.3/drivers/net/wireless/p54/p54usb.c	2010-02-16 20:31:33.000000000 +0100
@@ -60,6 +60,7 @@
 	{USB_DEVICE(0x06b9, 0x0121)},	/* Thomson SpeedTouch 121g */
 	{USB_DEVICE(0x0707, 0xee13)},   /* SMC 2862W-G version 2 */
 	{USB_DEVICE(0x083a, 0x4521)},   /* Siemens Gigaset USB Adapter 54 version 2 */
+	{USB_DEVICE(0x083a, 0xf503)},	/* Accton FD7050E ver 1010ec  */
 	{USB_DEVICE(0x0846, 0x4240)},	/* Netgear WG111 (v2) */
 	{USB_DEVICE(0x0915, 0x2000)},	/* Cohiba Proto board */
 	{USB_DEVICE(0x0915, 0x2002)},	/* Cohiba Proto board */
