Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:63538 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab3IXT44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 15:56:56 -0400
Received: by mail-bk0-f54.google.com with SMTP id mz12so1919029bkb.41
        for <linux-wireless@vger.kernel.org>; Tue, 24 Sep 2013 12:56:55 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, the_force@gmx.de
Subject: [PATCH -stable] p54usb: add USB ID for Corega WLUSB2GTST USB adapter
Date: Tue, 24 Sep 2013 21:56:46 +0200
Message-ID: <1908256.18UySgn1pZ@blech> (sfid-20130924_215701_079294_6BA0A482)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added USB ID for Corega WLUSB2GTST USB adapter.

Cc: <stable@vger.kernel.org>
Reported-by: Joerg Kalisch <the_force@gmx.de>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/p54/p54usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index b9deef6..f42dc3c 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -83,6 +83,7 @@ static struct usb_device_id p54u_table[] = {
 	{USB_DEVICE(0x06a9, 0x000e)},	/* Westell 802.11g USB (A90-211WG-01) */
 	{USB_DEVICE(0x06b9, 0x0121)},	/* Thomson SpeedTouch 121g */
 	{USB_DEVICE(0x0707, 0xee13)},   /* SMC 2862W-G version 2 */
+	{USB_DEVICE(0x07aa, 0x0020)},	/* Corega WLUSB2GTST USB */
 	{USB_DEVICE(0x0803, 0x4310)},	/* Zoom 4410a */
 	{USB_DEVICE(0x083a, 0x4521)},   /* Siemens Gigaset USB Adapter 54 version 2 */
 	{USB_DEVICE(0x083a, 0x4531)},	/* T-Com Sinus 154 data II */
-- 
1.8.4.rc3

