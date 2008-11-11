Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46387 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbYKKBj2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 20:39:28 -0500
Date: Mon, 10 Nov 2008 19:39:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: ivan.kuten@promwad.com, linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8187: Add Abocom USB ID
Message-ID: <4918e24d.2qvmminMsK9sq80H%Larry.Finger@lwfinger.net> (sfid-20081111_023932_808622_4DA47A39)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivan Kuten <ivan.kuten@promwad.com>

rtl8187: Add Abocom usb id

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

I have reworked the patch to account for the moving of the rtl8187 files, and
fixed the whitespace problems.

Larry
---

--- linux-2.6.28-rc3/drivers/net/wireless/rtl818x/rtl8187_dev.c 2008-11-10 18:53:50.000000000 +0200
+++ linux-2.6.28-rc3.new/drivers/net/wireless/rtl818x/rtl8187_dev.c     2008-11-10 19:02:34.000000000 +0200
@@ -48,6 +48,8 @@
 	{USB_DEVICE(0x03f0, 0xca02), .driver_info = DEVICE_RTL8187},
 	/* Sitecom */
 	{USB_DEVICE(0x0df6, 0x000d), .driver_info = DEVICE_RTL8187},
+	/* Abocom */
+	{USB_DEVICE(0x13d1, 0xabe6), .driver_info = DEVICE_RTL8187},
 	{}
 };

