Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:48946 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab1F3T0g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 15:26:36 -0400
Received: by fxd18 with SMTP id 18so2559970fxd.11
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2011 12:26:35 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Thu, 30 Jun 2011 21:06:17 +0200
Subject: [PATCH -stable] carl9170: add NEC WL300NU-AG usbid
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Message-Id: <E1QcMuC-0001AU-GJ@debian64.daheim> (sfid-20110630_212641_965514_42AF8E60)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: stable@kernel.org
Reported-by: Mark Davis
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/usb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index 2fb53d0..333b69e 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -112,6 +112,8 @@ static struct usb_device_id carl9170_usb_ids[] = {
 	{ USB_DEVICE(0x04bb, 0x093f) },
 	/* NEC WL300NU-G */
 	{ USB_DEVICE(0x0409, 0x0249) },
+	/* NEC WL300NU-AG */
+	{ USB_DEVICE(0x0409, 0x02b4) },
 	/* AVM FRITZ!WLAN USB Stick N */
 	{ USB_DEVICE(0x057c, 0x8401) },
 	/* AVM FRITZ!WLAN USB Stick N 2.4 */
-- 
1.7.5.4

