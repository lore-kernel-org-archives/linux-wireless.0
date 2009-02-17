Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38553 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbZBQUbb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 15:31:31 -0500
Date: Tue, 17 Feb 2009 14:31:12 -0600
From: Larry Finger <Larry.Finger@gmail.com>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8187: New USB ID's for RTL8187L
Message-ID: <499b1e90.kmugr59uxt2XRg8i%Larry.Finger@gmail.com> (sfid-20090217_213134_521277_0F2891C9)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new USB ID codes. These come from two postings on forums and
mailing lists, and four are derived from the .inf that accompanies
the latest Realtek Windows driver for the RTL8187L.

Thanks to Viktor Ilija=C5=A1i=C4=87 <viktor.ilijasic@gmail.com> and Xos=
e Vazquez
Perez <xose.vazquez@gmail.com> for reporting these new ID's.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

I think these are 2.6.29 material.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -48,6 +48,10 @@ static struct usb_device_id rtl8187_tabl
 	{USB_DEVICE(0x0bda, 0x8189), .driver_info =3D DEVICE_RTL8187B},
 	{USB_DEVICE(0x0bda, 0x8197), .driver_info =3D DEVICE_RTL8187B},
 	{USB_DEVICE(0x0bda, 0x8198), .driver_info =3D DEVICE_RTL8187B},
+	/* Surecom */
+	{USB_DEVICE(0x0769, 0x11F2), .driver_info =3D DEVICE_RTL8187},
+	/* Logitech */
+	{USB_DEVICE(0x0789, 0x010C), .driver_info =3D DEVICE_RTL8187},
 	/* Netgear */
 	{USB_DEVICE(0x0846, 0x6100), .driver_info =3D DEVICE_RTL8187},
 	{USB_DEVICE(0x0846, 0x6a00), .driver_info =3D DEVICE_RTL8187},
@@ -57,8 +61,16 @@ static struct usb_device_id rtl8187_tabl
 	/* Sitecom */
 	{USB_DEVICE(0x0df6, 0x000d), .driver_info =3D DEVICE_RTL8187},
 	{USB_DEVICE(0x0df6, 0x0028), .driver_info =3D DEVICE_RTL8187B},
+	/* Sphairon Access Systems GmbH */
+	{USB_DEVICE(0x114B, 0x0150), .driver_info =3D DEVICE_RTL8187},
+	/* Dick Smith Electronics */
+	{USB_DEVICE(0x1371, 0x9401), .driver_info =3D DEVICE_RTL8187},
 	/* Abocom */
 	{USB_DEVICE(0x13d1, 0xabe6), .driver_info =3D DEVICE_RTL8187},
+	/* Qcom */
+	{USB_DEVICE(0x18E8, 0x6232), .driver_info =3D DEVICE_RTL8187},
+	/* AirLive */
+	{USB_DEVICE(0x1b75, 0x8187), .driver_info =3D DEVICE_RTL8187},
 	{}
 };
=20
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
