Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:52544 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199AbZJMLsV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 07:48:21 -0400
Received: by fxm27 with SMTP id 27so10077518fxm.17
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2009 04:47:44 -0700 (PDT)
Message-ID: <4AD468DB.4050700@gmail.com>
Date: Tue, 13 Oct 2009 13:47:39 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com, IvDoorn@gmail.com
Subject: [PATCH] rt73usb.c : more ids
Content-Type: multipart/mixed;
 boundary="------------060301040600020500070008"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060301040600020500070008
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

hi,

stolen from windows inf file(07/17/2009, 1.03.05.0000)
Ovislink 0x1b75, 0x7318
MSI 0x0db0, 0x4600
WideTell 0x7167, 0x3840


-thanks-

regards,
-- 
«Allá muevan feroz guerra, ciegos reyes por un palmo más de tierra;
que yo aquí tengo por mío cuanto abarca el mar bravío, a quien nadie
impuso leyes. Y no hay playa, sea cualquiera, ni bandera de esplendor,
que no sienta mi derecho y dé pecho a mi valor.»


--------------060301040600020500070008
Content-Type: text/plain;
 name="new_id-73usb.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="new_id-73usb.diff"

--- o/drivers/net/wireless/rt73usb.c	2009-10-13 12:58:32.042380351 +0200
+++ n/drivers/net/wireless/rt73usb.c	2009-10-13 13:01:01.073379225 +0200
@@ -2389,10 +2389,13 @@
 	{ USB_DEVICE(0x13b1, 0x0023), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x13b1, 0x0028), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* MSI */
+	{ USB_DEVICE(0x0db0, 0x4600), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x0db0, 0x6877), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x0db0, 0x6874), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x0db0, 0xa861), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x0db0, 0xa874), USB_DEVICE_DATA(&rt73usb_ops) },
+	/* Ovislink */
+	{ USB_DEVICE(0x1b75, 0x7318), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Ralink */
 	{ USB_DEVICE(0x04bb, 0x093d), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt73usb_ops) },
@@ -2420,6 +2423,8 @@
 	/* Planex */
 	{ USB_DEVICE(0x2019, 0xab01), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x2019, 0xab50), USB_DEVICE_DATA(&rt73usb_ops) },
+	/* WideTell */
+	{ USB_DEVICE(0x7167, 0x3840), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Zcom */
 	{ USB_DEVICE(0x0cde, 0x001c), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* ZyXEL */

--------------060301040600020500070008--
