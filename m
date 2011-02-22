Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33694 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab1BVNuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Feb 2011 08:50:46 -0500
Received: by fxm17 with SMTP id 17so2765026fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Feb 2011 05:50:45 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] carl9170: add Airlive X.USB a/b/g/n USBID
Date: Tue, 22 Feb 2011 14:49:43 +0100
Cc: linville@tuxdriver.com, Jan Puk <janpuk@volny.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201102221449.43419.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jan Puk <janpuk@volny.cz>

"AirLive X.USB now works perfectly under a Linux
environment!"

Cc: <stable@kernel.org>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index 537732e..f82c400 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -118,6 +118,8 @@ static struct usb_device_id carl9170_usb_ids[] = {
 	{ USB_DEVICE(0x057c, 0x8402) },
 	/* Qwest/Actiontec 802AIN Wireless N USB Network Adapter */
 	{ USB_DEVICE(0x1668, 0x1200) },
+	/* Airlive X.USB a/b/g/n */
+	{ USB_DEVICE(0x1b75, 0x9170) },
 
 	/* terminate */
 	{}
