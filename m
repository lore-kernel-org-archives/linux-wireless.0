Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:40233 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbZBOQn2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 11:43:28 -0500
Received: by ewy14 with SMTP id 14so1607517ewy.13
        for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 08:43:26 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 3/3] rt2x00: Add various new USB IDs for rt73usb
Date: Sun, 15 Feb 2009 17:43:05 +0100
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200902151742.01372.IvDoorn@gmail.com> <200902151742.30220.IvDoorn@gmail.com> <200902151742.48677.IvDoorn@gmail.com>
In-Reply-To: <200902151742.48677.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200902151743.05405.IvDoorn@gmail.com> (sfid-20090215_174332_552854_A231430C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt73usb.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 846996c..90ace51 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2342,6 +2342,9 @@ static const struct rt2x00_ops rt73usb_ops = {
 static struct usb_device_id rt73usb_device_table[] = {
 	/* AboCom */
 	{ USB_DEVICE(0x07b8, 0xb21d), USB_DEVICE_DATA(&rt73usb_ops) },
+	/* Amigo */
+	{ USB_DEVICE(0x148f, 0x9021), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x0eb0, 0x9021), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Askey */
 	{ USB_DEVICE(0x1690, 0x0722), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* ASUS */
@@ -2389,6 +2392,7 @@ static struct usb_device_id rt73usb_device_table[] = {
 	{ USB_DEVICE(0x0db0, 0xa861), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x0db0, 0xa874), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Ralink */
+	{ USB_DEVICE(0x04bb, 0x093d), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2671), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Qcom */
@@ -2405,6 +2409,8 @@ static struct usb_device_id rt73usb_device_table[] = {
 	/* Planex */
 	{ USB_DEVICE(0x2019, 0xab01), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x2019, 0xab50), USB_DEVICE_DATA(&rt73usb_ops) },
+	/* ZyXEL */
+	{ USB_DEVICE(0x0586, 0x3415), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ 0, }
 };
 
-- 
1.5.6.1

