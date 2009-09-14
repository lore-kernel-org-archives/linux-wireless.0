Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:31763 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172AbZINVIW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 17:08:22 -0400
Received: by ey-out-2122.google.com with SMTP id 25so671865eya.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 14:08:25 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Fabian Lenz <lenz_fabian@yahoo.de>
Subject: [RFC] ar9170usb: add ar9170 usbid
Date: Mon, 14 Sep 2009 23:08:19 +0200
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Stephen.Chen@atheros.com
References: <200909142046.07525.lenz_fabian@yahoo.de>
In-Reply-To: <200909142046.07525.lenz_fabian@yahoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200909142308.19569.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Fabian Lenz <lenz_fabian@yahoo.de>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
Stephen,

- since 0x0cf3 is Atheros' vendor id - can you please lookup the real product
code name for 0x0cf3:0x1002.

I will take care of the re-spin and update the wiki.

Thanks,
	Chr
---
diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index e0138ac..68b0bda 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -64,6 +64,8 @@ static struct usb_device_id ar9170_usb_ids[] = {
 	{ USB_DEVICE(0x0cf3, 0x9170) },
 	/* Atheros TG121N */
 	{ USB_DEVICE(0x0cf3, 0x1001) },
+	/* Atheros - Unknown Product Name - */
+	{ USB_DEVICE(0x0cf3, 0x1002) },
 	/* Cace Airpcap NX */
 	{ USB_DEVICE(0xcace, 0x0300) },
 	/* D-Link DWA 160A */
