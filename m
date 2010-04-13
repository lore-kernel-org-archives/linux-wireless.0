Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:62733 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab0DMQKe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 12:10:34 -0400
Received: by ewy20 with SMTP id 20so2636066ewy.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Apr 2010 09:10:33 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ar9170usb: add a couple more USB IDs
Date: Tue, 13 Apr 2010 18:10:26 +0200
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201004131810.26894.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the following 5 entries to the usbid device table:

 * Netgear WNA1000
 * Proxim ORiNOCO Dual Band 802.11n USB Adapter
 * 3Com Dual Band 802.11n USB Adapter
 * H3C Dual Band 802.11n USB Adapter
 * WNC Generic 11n USB dongle

CC: <stable@kernel.org>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
IDs found by scanning .inf files from TP-Link's windows 7 driver
( TL-WN821N_v2_win7.zip, Published Date: 10 Feb 2010 )
---
diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index 6b1cb70..0259bb4 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -66,18 +66,28 @@ static struct usb_device_id ar9170_usb_ids[] = {
 	{ USB_DEVICE(0x0cf3, 0x1001) },
 	/* TP-Link TL-WN821N v2 */
 	{ USB_DEVICE(0x0cf3, 0x1002) },
+	/* 3Com Dual Band 802.11n USB Adapter */
+	{ USB_DEVICE(0x0cf3, 0x1010) },
+	/* H3C Dual Band 802.11n USB Adapter */
+	{ USB_DEVICE(0x0cf3, 0x1011) },
 	/* Cace Airpcap NX */
 	{ USB_DEVICE(0xcace, 0x0300) },
 	/* D-Link DWA 160 A1 */
 	{ USB_DEVICE(0x07d1, 0x3c10) },
 	/* D-Link DWA 160 A2 */
 	{ USB_DEVICE(0x07d1, 0x3a09) },
+	/* Netgear WNA1000 */
+	{ USB_DEVICE(0x0846, 0x9040) },
 	/* Netgear WNDA3100 */
 	{ USB_DEVICE(0x0846, 0x9010) },
 	/* Netgear WN111 v2 */
 	{ USB_DEVICE(0x0846, 0x9001) },
 	/* Zydas ZD1221 */
 	{ USB_DEVICE(0x0ace, 0x1221) },
+	/* Proxim ORiNOCO 802.11n USB */
+	{ USB_DEVICE(0x1435, 0x0804) },
+	/* WNC Generic 11n USB Dongle */
+	{ USB_DEVICE(0x1435, 0x0326) },
 	/* ZyXEL NWD271N */
 	{ USB_DEVICE(0x0586, 0x3417) },
 	/* Z-Com UB81 BG */
