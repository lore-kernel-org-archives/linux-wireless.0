Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54052 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab1GFVBE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 17:01:04 -0400
Received: by mail-ew0-f46.google.com with SMTP id 4so108843ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2011 14:01:03 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 5/6] rt2x00: Properly identify rt2800usb devices.
Date: Wed, 6 Jul 2011 22:59:19 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <201107062256.25555.IvDoorn@gmail.com> <201107062257.38435.IvDoorn@gmail.com> <201107062258.56747.IvDoorn@gmail.com>
In-Reply-To: <201107062258.56747.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201107062259.20822.IvDoorn@gmail.com> (sfid-20110706_230109_064394_D718668D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Sitecom WLA4000 (USB ID 0x0df6:0x0060) is an RT3072 chipset.
Sitecom WLA5000 (USB ID 0x0df6:0x0062) is an RT3572 chipset.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 6e92298..af23058 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1020,6 +1020,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0df6, 0x0048) },
 	{ USB_DEVICE(0x0df6, 0x0051) },
 	{ USB_DEVICE(0x0df6, 0x005f) },
+	{ USB_DEVICE(0x0df6, 0x0060) },
 	/* SMC */
 	{ USB_DEVICE(0x083a, 0x6618) },
 	{ USB_DEVICE(0x083a, 0x7511) },
@@ -1076,6 +1077,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x148f, 0x3572) },
 	/* Sitecom */
 	{ USB_DEVICE(0x0df6, 0x0041) },
+	{ USB_DEVICE(0x0df6, 0x0062) },
 	/* Toshiba */
 	{ USB_DEVICE(0x0930, 0x0a07) },
 	/* Zinwell */
@@ -1174,8 +1176,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0df6, 0x004a) },
 	{ USB_DEVICE(0x0df6, 0x004d) },
 	{ USB_DEVICE(0x0df6, 0x0053) },
-	{ USB_DEVICE(0x0df6, 0x0060) },
-	{ USB_DEVICE(0x0df6, 0x0062) },
 	/* SMC */
 	{ USB_DEVICE(0x083a, 0xa512) },
 	{ USB_DEVICE(0x083a, 0xc522) },
-- 
1.7.2.3

