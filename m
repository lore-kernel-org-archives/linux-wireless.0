Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:47535 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbZCTXBC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 19:01:02 -0400
Received: by ewy9 with SMTP id 9so894240ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2009 16:00:59 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: New USB ID for rt73usb
Date: Sat, 21 Mar 2009 00:00:57 +0100
Cc: users@rt2x00.serialmonkey.com,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903210000.57321.IvDoorn@gmail.com> (sfid-20090321_000108_671561_261C0A02)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 24fdfdf..420fff4 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2425,6 +2425,8 @@ static struct usb_device_id rt73usb_device_table[] = {
 	{ USB_DEVICE(0x0df6, 0x9712), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Surecom */
 	{ USB_DEVICE(0x0769, 0x31f3), USB_DEVICE_DATA(&rt73usb_ops) },
+	/* Tilgin */
+	{ USB_DEVICE(0x6933, 0x5001), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Philips */
 	{ USB_DEVICE(0x0471, 0x200a), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Planex */
