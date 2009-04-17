Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:51602 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbZDQMvq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 08:51:46 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] ar9170usb: add ZyXEL NWD271N
Date: Fri, 17 Apr 2009 14:52:23 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200904171452.24136.chunkeey@web.de> (sfid-20090417_145150_021845_5A02423E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
this patch is for wireless-testing and 2.6.30.
---
diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index 43e8d8d..c9e422e 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -69,6 +69,8 @@ static struct usb_device_id ar9170_usb_ids[] = {
 	{ USB_DEVICE(0x0846, 0x9001) },
 	/* Zydas ZD1221 */
 	{ USB_DEVICE(0x0ace, 0x1221) },
+	/* ZyXEL NWD271N */
+	{ USB_DEVICE(0x0586, 0x3417) },
 	/* Z-Com UB81 BG */
 	{ USB_DEVICE(0x0cde, 0x0023) },
 	/* Z-Com UB82 ABG */
