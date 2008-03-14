Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms6.Sony.CO.JP ([211.125.136.204]:46625 "EHLO ms6.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbYCNLPD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2008 07:15:03 -0400
Date: Fri, 14 Mar 2008 20:16:40 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: [PATCH] rt2x00: Add id for Corega CG-WLUSB2GPX
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Message-Id: <20080314190922.2594.40F06B3A@sm.sony.co.jp> (sfid-20080314_112329_578359_4214098C)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the id for Corega CG-WLUSB2GPX.

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
---
 Tested with wpa_supplicant (wext wrapper) on PS3 with the F8 userland.

 drivers/net/wireless/rt2x00/rt73usb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2095,6 +2095,8 @@ static struct usb_device_id rt73usb_devi
 	{ USB_DEVICE(0x1371, 0x9032), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Conceptronic */
 	{ USB_DEVICE(0x14b2, 0x3c22), USB_DEVICE_DATA(&rt73usb_ops) },
+	/* Corega */
+	{ USB_DEVICE(0x07aa, 0x002e), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* D-Link */
 	{ USB_DEVICE(0x07d1, 0x3c03), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c04), USB_DEVICE_DATA(&rt73usb_ops) },

-- 
Masakazu Mokuno

