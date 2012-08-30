Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:4270 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246Ab2H3Tkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 15:40:40 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <users@rt2x00.serialmonkey.com>, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Maximilian Engelhardt <maxi@daemonizer.de>,
	<stable@vger.kernel.org>
Subject: [PATCH 01/14] rt2x00: Identify ASUS USB-N53 device.
Date: Thu, 30 Aug 2012 21:34:00 +0200
Message-Id: <1346355248-5331-2-git-send-email-gwingerde@gmail.com> (sfid-20120830_214053_356080_20B3952F)
In-Reply-To: <1346355248-5331-1-git-send-email-gwingerde@gmail.com>
References: <1346355248-5331-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an RT3572 based device.

Signed-off-by: Maximilian Engelhardt <maxi@daemonizer.de>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: <stable@vger.kernel.org>

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 6cf3365..6681bfc 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1157,6 +1157,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x1690, 0x0744) },
 	{ USB_DEVICE(0x1690, 0x0761) },
 	{ USB_DEVICE(0x1690, 0x0764) },
+	/* ASUS */
+	{ USB_DEVICE(0x0b05, 0x179d) },
 	/* Cisco */
 	{ USB_DEVICE(0x167b, 0x4001) },
 	/* EnGenius */
@@ -1222,7 +1224,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0b05, 0x1760) },
 	{ USB_DEVICE(0x0b05, 0x1761) },
 	{ USB_DEVICE(0x0b05, 0x1790) },
-	{ USB_DEVICE(0x0b05, 0x179d) },
 	/* AzureWave */
 	{ USB_DEVICE(0x13d3, 0x3262) },
 	{ USB_DEVICE(0x13d3, 0x3284) },
-- 
1.7.11.1

