Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-1920.google.com ([74.125.78.150]:47500 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZGMWUl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 18:20:41 -0400
Received: by ey-out-1920.google.com with SMTP id 3so503365eyh.36
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2009 15:20:40 -0700 (PDT)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Hin-Tak Leung <HinTak.Leung@gmail.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: [PATCH] zd1211rw: adding Accton Technology Corp (083a:e501) as a ZD1211B device
Date: Mon, 13 Jul 2009 23:20:37 +0100
Message-Id: <1247523637-13397-1-git-send-email-HinTak.Leung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New device supported by the zd1211rw driver reported to linux-wireless.
Device string from lsusb:
"ID 083a:e501 Accton Technology Corp. ZD1211B"

RF type from dmesg:
zd1211b chip 083a:e501 v4810 high 00-1a-2a AL2230_RF pa0 g--NS

Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Tested-by: Adrián Cereto<ssorgatem@esdebian.org>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index dc34791..c1912f8 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -75,6 +75,7 @@ static struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x07b8, 0x6001), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x07fa, 0x1196), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x083a, 0x4505), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x083a, 0xe501), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x083a, 0xe503), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x083a, 0xe506), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0ace, 0x1215), .driver_info = DEVICE_ZD1211B },
-- 
1.6.2.5

