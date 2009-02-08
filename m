Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:44697 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbZBHCOE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2009 21:14:04 -0500
Received: by ewy14 with SMTP id 14so1994056ewy.13
        for <linux-wireless@vger.kernel.org>; Sat, 07 Feb 2009 18:14:02 -0800 (PST)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: sourceforge.bnwi@manchmal.in-ulm.de,
	Hin-Tak Leung <HinTak.Leung@gmail.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: [PATCH] zd1211rw: adding 0ace:0xa211 as a ZD1211 device
Date: Sun,  8 Feb 2009 02:13:56 +0000
Message-Id: <1234059236-4335-1-git-send-email-HinTak.Leung@gmail.com> (sfid-20090208_031410_653114_0E9256ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christoph Biedl <sourceforge.bnwi@manchmal.in-ulm.de> reported success
in the sourceforge zd1211 mailing list on this addition. This product ID
was supported by the vendor driver ZD1211LnxDrv 2.22.0.0 (and possibly
earlier) and it probably should have been added earlier.

Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Tested-by: Christoph Biedl <sourceforge.bnwi@manchmal.in-ulm.de>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 17527f7..f0e5e94 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -37,6 +37,7 @@
 static struct usb_device_id usb_ids[] = {
 	/* ZD1211 */
 	{ USB_DEVICE(0x0ace, 0x1211), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x0ace, 0xa211), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x07b8, 0x6001), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x126f, 0xa006), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x6891, 0xa727), .driver_info = DEVICE_ZD1211 },
-- 
1.6.0.6

