Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46273 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbYHKEfA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 00:35:00 -0400
Date: Sun, 10 Aug 2008 23:34:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>, bonsouere@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH V2] rtl8187: Add USB ID for Netgear WG111V3
Message-ID: <489fc173.uGMXQB7YL3CVYfZ2%Larry.Finger@lwfinger.net> (sfid-20080811_063510_719213_BA158286)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=46rom: matthieu Barth=C3=A9lemy <bonsouere@gmail.com>

Add the USB ID for a Netgear WG111v3.

Signed-off-by: matthieu Barth=C3=A9lemy <bonsouere@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

V1 had the new ID line in the wrong place.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtl8187_dev.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-testing.orig/drivers/net/wireless/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl8187_dev.c
@@ -40,6 +40,7 @@ static struct usb_device_id rtl8187_tabl
 	/* Netgear */
 	{USB_DEVICE(0x0846, 0x6100), .driver_info =3D DEVICE_RTL8187},
 	{USB_DEVICE(0x0846, 0x6a00), .driver_info =3D DEVICE_RTL8187},
+	{USB_DEVICE(0x0846, 0x4260), .driver_info =3D DEVICE_RTL8187B},
 	/* HP */
 	{USB_DEVICE(0x03f0, 0xca02), .driver_info =3D DEVICE_RTL8187},
 	/* Sitecom */
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
