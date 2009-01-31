Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:34518 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbZAaJHp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2009 04:07:45 -0500
Received: by ewy14 with SMTP id 14so1122119ewy.13
        for <linux-wireless@vger.kernel.org>; Sat, 31 Jan 2009 01:07:42 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] Add new rt73usb USB ID
Date: Sat, 31 Jan 2009 10:07:39 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901311007.40028.IvDoorn@gmail.com> (sfid-20090131_100751_801102_C7F1BB60)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index be791a4..6521dac 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2368,6 +2368,7 @@ static struct usb_device_id rt73usb_device_table[] = {
 	/* Billionton */
 	{ USB_DEVICE(0x1631, 0xc019), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Buffalo */
+	{ USB_DEVICE(0x0411, 0x00d8), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x0411, 0x00f4), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* CNet */
 	{ USB_DEVICE(0x1371, 0x9022), USB_DEVICE_DATA(&rt73usb_ops) },
