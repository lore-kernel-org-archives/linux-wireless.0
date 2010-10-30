Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53274 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab0J3Rqq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Oct 2010 13:46:46 -0400
Received: by bwz11 with SMTP id 11so3443377bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Oct 2010 10:46:44 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH for-2.6.37] carl9170: usbid table updates
Date: Sat, 30 Oct 2010 19:46:37 +0200
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010301946.38280.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch includes the following updates:
 * add D-Link DWA-130 Rev D
 * Netgear has three WNDA3100 versions.
   the original WNDA3100 is now called WNDA3100v1.
    
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index ddf5373..82c5f1c 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -82,9 +82,11 @@ static struct usb_device_id carl9170_usb_ids[] = {
 	{ USB_DEVICE(0x07d1, 0x3c10) },
 	/* D-Link DWA 160 A2 */
 	{ USB_DEVICE(0x07d1, 0x3a09) },
+	/* D-Link DWA 130 D */
+	{ USB_DEVICE(0x07d1, 0x3a0f) },
 	/* Netgear WNA1000 */
 	{ USB_DEVICE(0x0846, 0x9040) },
-	/* Netgear WNDA3100 */
+	/* Netgear WNDA3100 (v1) */
 	{ USB_DEVICE(0x0846, 0x9010) },
 	/* Netgear WN111 v2 */
 	{ USB_DEVICE(0x0846, 0x9001), .driver_info = CARL9170_ONE_LED },
