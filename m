Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:52150 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbZFZE2T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2009 00:28:19 -0400
Received: by ewy6 with SMTP id 6so2972149ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2009 21:28:21 -0700 (PDT)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Hin-Tak Leung <HinTak.Leung@gmail.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: [PATCH] zd1211rw: adding SONY IFU-WLM2 (054c:0257) as a zd1211b device
Date: Fri, 26 Jun 2009 05:28:15 +0100
Message-Id: <1245990495-5681-1-git-send-email-HinTak.Leung@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yevgen Kotikov reported success on the sourceforge zd1211-devs list
with the following details:

Brand/retail: SONY IFU-WLM2
USB-IDs: Vendor: 0x054C Device: 0x0257
chip ID: zd1211b chip 054c:0257 v4802 high 00-0b-6b AL2230_RF pa0 -----
FCC ID: unknown

Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Tested-by: Yevgen Kotikov <yevgen.kotikov@gmail.com>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 2c24dd9..722b20c 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -66,6 +66,7 @@ static struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x0471, 0x1236), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0471, 0x1237), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x050d, 0x705c), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x054c, 0x0257), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0586, 0x340a), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0586, 0x340f), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0586, 0x3410), .driver_info = DEVICE_ZD1211B },
-- 
1.6.2.5

