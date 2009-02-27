Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:59514 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbZB0Xjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 18:39:51 -0500
Received: by ewy25 with SMTP id 25so1540722ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 27 Feb 2009 15:39:48 -0800 (PST)
Message-ID: <49A87691.7020004@gmail.com> (sfid-20090228_003956_566729_C249AEAD)
Date: Sat, 28 Feb 2009 00:26:09 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>, IvDoorn@gmail.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2.6.29-rc6 1/1] rt2x00 : more devices to rt2500usb.c
Content-Type: multipart/mixed;
 boundary="------------000108060900040401050700"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000108060900040401050700
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit


add more usb_dev to rt2500usb.c . IDs 'stolen' from the
windows inf file(02/12/2009, 2.01.01.0015).

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---

John please, add it to the wireless tree.

-thanks-

regards,
-- 
Polycommander, Erkowit, Urquiola, Andros Patria, Cason, Aegean Sea, Prestige, ...

--------------000108060900040401050700
Content-Type: text/plain;
 name="more_dev_id_rt2500usb.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="more_dev_id_rt2500usb.diff"

--- linux-2.6/drivers/net/wireless/rt2x00/rt2500usb.c	2009-01-16 02:12:01.000000000 +0100
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c	2009-02-27 22:10:45.000000000 +0100
@@ -1952,6 +1952,8 @@
 	{ USB_DEVICE(0x13b1, 0x000d), USB_DEVICE_DATA(&rt2500usb_ops) },
 	{ USB_DEVICE(0x13b1, 0x0011), USB_DEVICE_DATA(&rt2500usb_ops) },
 	{ USB_DEVICE(0x13b1, 0x001a), USB_DEVICE_DATA(&rt2500usb_ops) },
+	/* CNet */
+	{ USB_DEVICE(0x1371, 0x9022), USB_DEVICE_DATA(&rt2500usb_ops) },
 	/* Conceptronic */
 	{ USB_DEVICE(0x14b2, 0x3c02), USB_DEVICE_DATA(&rt2500usb_ops) },
 	/* D-LINK */
@@ -1976,14 +1978,20 @@
 	{ USB_DEVICE(0x148f, 0x2570), USB_DEVICE_DATA(&rt2500usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt2500usb_ops) },
 	{ USB_DEVICE(0x148f, 0x9020), USB_DEVICE_DATA(&rt2500usb_ops) },
+	/* Sagem */
+	{ USB_DEVICE(0x079b, 0x004b), USB_DEVICE_DATA(&rt2500usb_ops) },
 	/* Siemens */
 	{ USB_DEVICE(0x0681, 0x3c06), USB_DEVICE_DATA(&rt2500usb_ops) },
 	/* SMC */
 	{ USB_DEVICE(0x0707, 0xee13), USB_DEVICE_DATA(&rt2500usb_ops) },
 	/* Spairon */
 	{ USB_DEVICE(0x114b, 0x0110), USB_DEVICE_DATA(&rt2500usb_ops) },
+	/* SURECOM */
+	{ USB_DEVICE(0x0769, 0x11f3), USB_DEVICE_DATA(&rt2500usb_ops) },
 	/* Trust */
 	{ USB_DEVICE(0x0eb0, 0x9020), USB_DEVICE_DATA(&rt2500usb_ops) },
+	/* VTech */
+	{ USB_DEVICE(0x0f88, 0x3012), USB_DEVICE_DATA(&rt2500usb_ops) },
 	/* Zinwell */
 	{ USB_DEVICE(0x5a57, 0x0260), USB_DEVICE_DATA(&rt2500usb_ops) },
 	{ 0, }

--------------000108060900040401050700--

