Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:59949 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaAUH42 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 02:56:28 -0500
Received: by mail-la0-f45.google.com with SMTP id b8so6290900lan.18
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 23:56:27 -0800 (PST)
From: dubtsov@gmail.com
To: linux-wireless@vger.kernel.org
Cc: Roman Dubtsov <dubtsov@gmail.com>
Subject: [PATCH] rt2x00: rt2800usb: mark D-Link DWA-137 as supported
Date: Tue, 21 Jan 2014 14:49:18 +0700
Message-Id: <1390290558-6265-1-git-send-email-dubtsov@gmail.com> (sfid-20140121_085632_995329_128DC504)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roman Dubtsov <dubtsov@gmail.com>

Signed-off-by: Roman Dubtsov <dubtsov@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index a81ceb6..ea619c2 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -992,6 +992,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x07d1, 0x3c15) },
 	{ USB_DEVICE(0x07d1, 0x3c16) },
 	{ USB_DEVICE(0x07d1, 0x3c17) },
+	{ USB_DEVICE(0x2001, 0x3317) },
 	{ USB_DEVICE(0x2001, 0x3c1b) },
 	/* Draytek */
 	{ USB_DEVICE(0x07fa, 0x7712) },
-- 
1.8.5.3

