Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36981 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbYHKE1k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 00:27:40 -0400
Date: Sun, 10 Aug 2008 23:27:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>, bonsouere@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8187: Add USB ID for Netgear WG111V3
Message-ID: <489fbfb9.IY+WzjnFwKATbnw0%Larry.Finger@lwfinger.net> (sfid-20080811_062745_278168_5D53D76E)
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

Technically, this is 2.6.28 material, but is it possible to push
it for 2.6.27?

Larry
---

Index: wireless-testing/drivers/net/wireless/rtl8187_dev.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-testing.orig/drivers/net/wireless/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl8187_dev.c
@@ -37,6 +37,7 @@ static struct usb_device_id rtl8187_tabl
 	{USB_DEVICE(0x0bda, 0x8187), .driver_info =3D DEVICE_RTL8187},
 	{USB_DEVICE(0x0bda, 0x8189), .driver_info =3D DEVICE_RTL8187B},
 	{USB_DEVICE(0x0bda, 0x8197), .driver_info =3D DEVICE_RTL8187B},
+	{USB_DEVICE(0x0846, 0x4260), .driver_info =3D DEVICE_RTL8187B},
 	/* Netgear */
 	{USB_DEVICE(0x0846, 0x6100), .driver_info =3D DEVICE_RTL8187},
 	{USB_DEVICE(0x0846, 0x6a00), .driver_info =3D DEVICE_RTL8187},
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
