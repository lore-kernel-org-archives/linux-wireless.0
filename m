Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33504 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab1DHOX6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 10:23:58 -0400
Date: Fri, 08 Apr 2011 09:23:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>, IvDoorn@gmail.com,
	gwingerde@gmail.com, helmut.schaa@googlemail.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rt2800usb: Add three new USB IDs
Message-ID: <4d9f1a7c.6indLlUpd9nUfsN8%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are three USB IDs supported by staging/rt2870sta that are not in the
mainline driver rt2800usb.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---

Index: wireless-testing/drivers/net/wireless/rt2x00/rt2800usb.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2800usb.c
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -758,6 +758,8 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x07d1, 0x3c0f), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c11), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c16), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x2001, 0x3c09), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x2001, 0x3c0a), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Draytek */
 	{ USB_DEVICE(0x07fa, 0x7712), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Edimax */
@@ -828,6 +830,7 @@ static struct usb_device_id rt2800usb_de
 	/* Planex */
 	{ USB_DEVICE(0x2019, 0xab25), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x2019, 0xed06), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x2019, 0xed14), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Quanta */
 	{ USB_DEVICE(0x1a32, 0x0304), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Ralink */
