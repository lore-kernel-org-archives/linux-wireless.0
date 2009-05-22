Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:64164 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbZEVTdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 15:33:22 -0400
Received: by ewy24 with SMTP id 24so2041428ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 22 May 2009 12:33:23 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Add new rt2800usb USB ID's
Date: Fri, 22 May 2009 21:33:21 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200905222133.21315.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

new patch to add more usb_dev to rt2800usb.c .
IDs 'stolen' from the latest Ralink linux
driver(2009_0520_RT3070_Linux_STA_v2.1.1.0.tar.gz)

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 142ad34..3756166 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -2927,12 +2927,17 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x07d1, 0x3c09), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c0a), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c0b), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x07d1, 0x3c0d), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x07d1, 0x3c0e), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x07d1, 0x3c0f), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c11), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c13), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Edimax */
 	{ USB_DEVICE(0x7392, 0x7711), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x7392, 0x7717), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x7392, 0x7718), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* Encore */
+	{ USB_DEVICE(0x203d, 0x1480), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* EnGenius */
 	{ USB_DEVICE(0X1740, 0x9701), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1740, 0x9702), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -2951,6 +2956,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0e66, 0x0003), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0e66, 0x0009), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0e66, 0x000b), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* I-O DATA */
+	{ USB_DEVICE(0x04bb, 0x0945), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* LevelOne */
 	{ USB_DEVICE(0x1740, 0x0605), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1740, 0x0615), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -2970,6 +2977,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Pegatron */
 	{ USB_DEVICE(0x1d4d, 0x0002), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1d4d, 0x000c), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x1d4d, 0x000e), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Philips */
 	{ USB_DEVICE(0x0471, 0x200f), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Planex */
@@ -2981,6 +2989,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Quanta */
 	{ USB_DEVICE(0x1a32, 0x0304), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Ralink */
+	{ USB_DEVICE(0x0db0, 0x3820), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0db0, 0x6899), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2070), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2770), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -3005,6 +3014,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0df6, 0x003e), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x003f), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x0040), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x0042), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* SMC */
 	{ USB_DEVICE(0x083a, 0x6618), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x083a, 0x7511), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -3029,6 +3039,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Zinwell */
 	{ USB_DEVICE(0x5a57, 0x0280), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x5a57, 0x0282), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x5a57, 0x0283), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x5a57, 0x5257), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Zyxel */
 	{ USB_DEVICE(0x0586, 0x3416), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0586, 0x341a), USB_DEVICE_DATA(&rt2800usb_ops) },
-- 
1.6.3

