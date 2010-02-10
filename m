Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39251 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab0BJPeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2010 10:34:12 -0500
Date: Wed, 10 Feb 2010 09:34:09 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: jmkok@solutionsradio.com, linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8187: Add new device ID
Message-ID: <4b72d1f1.J9VQrXuO+0LD2CFM%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jelle Martijn Kok <jmkok@solutionsradio.com>

Add new RTL8187B device.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@kernel.org>
---


Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -65,6 +65,7 @@ static struct usb_device_id rtl8187_tabl
 	/* Sitecom */
 	{USB_DEVICE(0x0df6, 0x000d), .driver_info = DEVICE_RTL8187},
 	{USB_DEVICE(0x0df6, 0x0028), .driver_info = DEVICE_RTL8187B},
+	{USB_DEVICE(0x0df6, 0x0029), .driver_info = DEVICE_RTL8187B},
 	/* Sphairon Access Systems GmbH */
 	{USB_DEVICE(0x114B, 0x0150), .driver_info = DEVICE_RTL8187},
 	/* Dick Smith Electronics */
