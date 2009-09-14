Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:39172 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbZINVIq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 17:08:46 -0400
Received: by ewy2 with SMTP id 2so1067582ewy.17
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 14:08:48 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Jari Jaakola <jari.jaakola@gmail.com>
Subject: [PATCH] p54usb: add Zcomax XG-705A usbid
Date: Mon, 14 Sep 2009 23:08:43 +0200
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>, stable@kernel.org
References: <6c9000d40909141238w2331a975tdaf0952487a3c76@mail.gmail.com>
In-Reply-To: <6c9000d40909141238w2331a975tdaf0952487a3c76@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200909142308.43652.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a new usbid for Zcomax XG-705A to the device table.

Cc: stable@kernel.org
Reported-by: Jari Jaakola <jari.jaakola@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index e44460f..17e1995 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -67,6 +67,7 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 	{USB_DEVICE(0x0bf8, 0x1009)},   /* FUJITSU E-5400 USB D1700*/
 	{USB_DEVICE(0x0cde, 0x0006)},   /* Medion MD40900 */
 	{USB_DEVICE(0x0cde, 0x0008)},	/* Sagem XG703A */
+	{USB_DEVICE(0x0cde, 0x0015)},	/* Zcomax XG-705A */
 	{USB_DEVICE(0x0d8e, 0x3762)},	/* DLink DWL-G120 Cohiba */
 	{USB_DEVICE(0x124a, 0x4025)},	/* IOGear GWU513 (GW3887IK chip) */
 	{USB_DEVICE(0x1260, 0xee22)},	/* SMC 2862W-G version 2 */
