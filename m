Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:63651 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbZKQMtd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 07:49:33 -0500
Received: by fxm21 with SMTP id 21so3910087fxm.21
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2009 04:49:38 -0800 (PST)
Message-ID: <4B029A64.2050701@gmail.com>
Date: Tue, 17 Nov 2009 13:43:16 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: IvDoorn@gmail.com, "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] rt2x00: more ids to rt2800usb.c
Content-Type: multipart/mixed;
 boundary="------------000405040506060808000109"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000405040506060808000109
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

taken from windows inf file (09/15/2009, 1.04.07.0000)

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>


--------------000405040506060808000109
Content-Type: text/plain;
 name="new_id-2800usb-v3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="new_id-2800usb-v3.diff"

--- o/drivers/net/wireless/rt2x00/rt2800usb.c	2009-11-17 11:48:42.583530963 +0100
+++ n/drivers/net/wireless/rt2x00/rt2800usb.c	2009-11-17 12:05:43.445532977 +0100
@@ -823,17 +823,23 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x0e0b, 0x9041), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Amit */
 	{ USB_DEVICE(0x15c5, 0x0008), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* Askey */
+	{ USB_DEVICE(0x1690, 0x0740), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x1690, 0x0744), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0930, 0x0a07), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* ASUS */
 	{ USB_DEVICE(0x0b05, 0x1731), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0b05, 0x1732), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0b05, 0x1742), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0b05, 0x1760), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0b05, 0x1761), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0b05, 0x1784), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* AzureWave */
 	{ USB_DEVICE(0x13d3, 0x3247), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x13d3, 0x3262), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x13d3, 0x3273), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x13d3, 0x3284), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x13d3, 0x3305), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Belkin */
 	{ USB_DEVICE(0x050d, 0x8053), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x050d, 0x805c), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -842,6 +848,8 @@ static struct usb_device_id rt2800usb_de
 	/* Buffalo */
 	{ USB_DEVICE(0x0411, 0x00e8), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0411, 0x012e), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* Cisco */
+	{ USB_DEVICE(0x167b, 0x4001), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Conceptronic */
 	{ USB_DEVICE(0x14b2, 0x3c06), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x14b2, 0x3c07), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -857,6 +865,8 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x07aa, 0x002f), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07aa, 0x003c), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07aa, 0x003f), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x07aa, 0x0041), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x07aa, 0x0042), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x18c5, 0x0008), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x18c5, 0x0012), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* D-Link */
@@ -868,18 +878,24 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x07d1, 0x3c0f), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c11), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c13), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x07d1, 0x3c15), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Edimax */
 	{ USB_DEVICE(0x7392, 0x7711), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x7392, 0x7717), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x7392, 0x7718), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Encore */
 	{ USB_DEVICE(0x203d, 0x1480), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x203d, 0x14a1), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x203d, 0x14a9), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* EnGenius */
 	{ USB_DEVICE(0X1740, 0x9701), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1740, 0x9702), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1740, 0x9703), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1740, 0x9705), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1740, 0x9706), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x1740, 0x9707), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x1740, 0x9708), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x1740, 0x9709), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1740, 0x9801), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Gemtek */
 	{ USB_DEVICE(0x15a9, 0x0010), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -893,7 +909,10 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x0e66, 0x0009), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0e66, 0x000b), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* I-O DATA */
+	{ USB_DEVICE(0x04bb, 0x0944), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x04bb, 0x0945), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x04bb, 0x0947), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x04bb, 0x0948), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* LevelOne */
 	{ USB_DEVICE(0x1740, 0x0605), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1740, 0x0615), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -908,8 +927,18 @@ static struct usb_device_id rt2800usb_de
 	/* Motorola */
 	{ USB_DEVICE(0x100d, 0x9031), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x100d, 0x9032), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* MSI */
+	{ USB_DEVICE(0x0db0, 0x3820), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0db0, 0x3821), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0db0, 0x3870), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0db0, 0x6899), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0db0, 0x821a), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0db0, 0x870a), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0db0, 0x899a), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Ovislink */
 	{ USB_DEVICE(0x1b75, 0x3072), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* Para */
+	{ USB_DEVICE(0x20b8, 0x8888), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Pegatron */
 	{ USB_DEVICE(0x1d4d, 0x0002), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1d4d, 0x000c), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -925,8 +954,6 @@ static struct usb_device_id rt2800usb_de
 	/* Quanta */
 	{ USB_DEVICE(0x1a32, 0x0304), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Ralink */
-	{ USB_DEVICE(0x0db0, 0x3820), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0db0, 0x6899), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2070), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2770), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2870), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -950,7 +977,12 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x0df6, 0x003e), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x003f), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x0040), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x0041), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x0042), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x0047), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x0048), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x004a), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x004d), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* SMC */
 	{ USB_DEVICE(0x083a, 0x6618), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x083a, 0x7511), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -959,6 +991,8 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x083a, 0x8522), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x083a, 0xa512), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x083a, 0xa618), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x083a, 0xa701), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x083a, 0xa702), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x083a, 0xb522), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x083a, 0xc522), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Sparklan */
@@ -976,6 +1010,7 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x5a57, 0x0280), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x5a57, 0x0282), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x5a57, 0x0283), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x5a57, 0x0284), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x5a57, 0x5257), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Zyxel */
 	{ USB_DEVICE(0x0586, 0x3416), USB_DEVICE_DATA(&rt2800usb_ops) },



--------------000405040506060808000109--
