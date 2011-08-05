Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from richmond.toniob.net ([88.191.116.29]:55367 "EHLO
	mail.toniob.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334Ab1HEFqh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2011 01:46:37 -0400
Subject: [PATCH] rt2x00: Add rt2870 device id for Dvico usb key
From: Anthony Bourguignon <contact+kernel@toniob.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Date: Fri, 05 Aug 2011 07:46:32 +0200
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1312523195.1413.8.camel@moss> (sfid-20110805_074640_799105_3355F77F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add a device id for the wifi usb keys shiped by DVICO with some of their tvix hardware.
Signed-off-by: Anthony Bourguignon <contact+kernel@toniob.net>

---

--- linux-3.0/drivers/net/wireless/rt2x00/rt2800usb.c.orig	2011-08-05 07:33:06.358681019 +0200
+++ linux-3.0/drivers/net/wireless/rt2x00/rt2800usb.c	2011-08-05 07:35:35.544225182 +0200
@@ -839,6 +839,8 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x07d1, 0x3c16) },
 	/* Draytek */
 	{ USB_DEVICE(0x07fa, 0x7712) },
+	/* DVICO */
+	{ USB_DEVICE(0x0fe9, 0xb307) },
 	/* Edimax */
 	{ USB_DEVICE(0x7392, 0x7711) },
 	{ USB_DEVICE(0x7392, 0x7717) },

