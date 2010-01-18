Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45697 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab0ARBYX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 20:24:23 -0500
Received: by ewy19 with SMTP id 19so49296ewy.21
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jan 2010 17:24:21 -0800 (PST)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Hin-Tak Leung <HinTak.Leung@gmail.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Yasuhiro ABE <yadiary@gmail.com>
Subject: [PATCH] zd1211rw: adding 0409:0248 to supported device list
Date: Mon, 18 Jan 2010 01:24:11 +0000
Message-Id: <1263777851-6130-1-git-send-email-HinTak.Leung@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yasuhiro ABE <yadiary@gmail.com> reported success in sourceforge zd1211-dev list.
The device is a NEC Aterm WL54GU usb wireless stick.

The brand and retail product name
    NEC, Aterm PA-WL54GU
The USB ID's (duh)
    ID 0409:0248
The chip ID string
    zd1211rw 1-1:1.0: zd1211b chip 0409:0248 v4810 high 00-1b-8b AL2230S_RF pa0 g--N-
The FCC ID
    unknown

Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Yasuhiro ABE <yadiary@gmail.com>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 4daf1c9..442fc11 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -62,6 +62,7 @@ static struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x6891, 0xa727), .driver_info = DEVICE_ZD1211 },
 	/* ZD1211B */
 	{ USB_DEVICE(0x0053, 0x5301), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0409, 0x0248), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0411, 0x00da), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0471, 0x1236), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0471, 0x1237), .driver_info = DEVICE_ZD1211B },
-- 
1.6.5.2

