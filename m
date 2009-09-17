Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:39470 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbZIQLrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 07:47:06 -0400
Received: by ewy2 with SMTP id 2so303098ewy.17
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2009 04:46:59 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] ar9170usb: add usbid for TP-Link TL-WN821N v2
Date: Thu, 17 Sep 2009 13:46:53 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Stephen Chen" <Stephen.Chen@atheros.com>,
	"Fabian Lenz" <lenz_fabian@yahoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200909171346.53856.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the usbid for TP-Link TL-WN821N v2.

Cc: stable@kernel.org
Reported-by: Fabian Lenz <lenz_fabian@yahoo.de>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index e0138ac..68b0bda 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -64,6 +64,8 @@ static struct usb_device_id ar9170_usb_ids[] = {
 	{ USB_DEVICE(0x0cf3, 0x9170) },
 	/* Atheros TG121N */
 	{ USB_DEVICE(0x0cf3, 0x1001) },
+	/* TP-Link TL-WN821N v2 */
+	{ USB_DEVICE(0x0cf3, 0x1002) },
 	/* Cace Airpcap NX */
 	{ USB_DEVICE(0xcace, 0x0300) },
 	/* D-Link DWA 160A */
