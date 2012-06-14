Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52429 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab2FNR2K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 13:28:10 -0400
Received: by pbbrp8 with SMTP id rp8so4097916pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2012 10:28:10 -0700 (PDT)
From: Jeongdo Son <sohn9086@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Jeongdo Son <sohn9086@gmail.com>
Subject: [PATCH] rt2x00: Add support for BUFFALO WLI-UC-GNM2 to rt2800usb.
Date: Fri, 15 Jun 2012 02:28:01 +0900
Message-Id: <1339694881-2158-1-git-send-email-sohn9086@gmail.com> (sfid-20120614_192814_694623_3D30294C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a RT3070 based device.

Signed-off-by: Jeongdo Son <sohn9086@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index cb71e88..9c08399 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -922,6 +922,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0411, 0x0158) },
 	{ USB_DEVICE(0x0411, 0x016f) },
 	{ USB_DEVICE(0x0411, 0x01a2) },
+	{ USB_DEVICE(0x0411, 0x01ee) },
 	/* Corega */
 	{ USB_DEVICE(0x07aa, 0x002f) },
 	{ USB_DEVICE(0x07aa, 0x003c) },
-- 
1.7.9.5

