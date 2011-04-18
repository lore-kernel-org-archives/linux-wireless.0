Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40169 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab1DRNgH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:36:07 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so2833906fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 06:36:06 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 14/23] rt2x00: Linksys WUSB600N rev2 is a RT3572 device.
Date: Mon, 18 Apr 2011 15:31:50 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201104181526.01722.IvDoorn@gmail.com> <201104181531.03375.IvDoorn@gmail.com> <201104181531.32313.IvDoorn@gmail.com>
In-Reply-To: <201104181531.32313.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104181531.51867.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Move the USB ID entry from the unknown devices to the list of RT35xx based
devices.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 2005972..1bb9a7d 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -983,6 +983,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x04bb, 0x0944), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Linksys */
 	{ USB_DEVICE(0x13b1, 0x002f), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x1737, 0x0079), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x3572), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Sitecom */
@@ -1041,7 +1042,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Linksys */
 	{ USB_DEVICE(0x1737, 0x0077), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1737, 0x0078), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x1737, 0x0079), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Motorola */
 	{ USB_DEVICE(0x100d, 0x9032), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Ovislink */
-- 
1.7.2.3

