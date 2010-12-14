Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57320 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759986Ab0LNUh2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 15:37:28 -0500
Date: Tue, 14 Dec 2010 14:37:59 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>, chunkeey@web.de
Cc: ecosta.tmp@gmail.com, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH] p54usb: New USB ID for Gemtek WUBI-100GW
Message-ID: <4d07d5a7.FnajdVI89jsmLq/B%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eduardo Costa <ecosta.tmp@gmail.com>

This USB ID is for the WUBI-100GW 802.11g Wireless LAN USB Device that
uses p54usb.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Eduardo Costa <ecosta.tmp@gmail.com>
Cc: Stable <stable@kernel.org>
---

John,

2.6.37 material.

Larry
---

Index: wireless-testing/drivers/net/wireless/p54/p54usb.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/p54usb.c
+++ wireless-testing/drivers/net/wireless/p54/p54usb.c
@@ -61,6 +61,7 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x107b, 0x55f2)},	/* Gateway WGU-210 (Gemtek) */
 	{USB_DEVICE(0x124a, 0x4023)},	/* Shuttle PN15, Airvast WM168g, IOGear GWU513 */
 	{USB_DEVICE(0x1435, 0x0210)},	/* Inventel UR054G */
+	{USB_DEVICE(0x15a9, 0x0002)},	/* Gemtek WUBI-100GW 802.11g */
 	{USB_DEVICE(0x1630, 0x0005)},	/* 2Wire 802.11g USB (v1) / Z-Com */
 	{USB_DEVICE(0x182d, 0x096b)},	/* Sitecom WL-107 */
 	{USB_DEVICE(0x1915, 0x2234)},	/* Linksys WUSB54G OEM */
