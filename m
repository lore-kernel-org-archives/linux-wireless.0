Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43739 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab0C1O5l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Mar 2010 10:57:41 -0400
Received: by bwz1 with SMTP id 1so2956974bwz.21
        for <linux-wireless@vger.kernel.org>; Sun, 28 Mar 2010 07:57:39 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, linville@tuxdriver.com,
	IvDoorn@gmail.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/2] wireless: rt2x00: rt2800usb: delete id
Date: Sun, 28 Mar 2010 16:57:32 +0200
Message-Id: <1269788252-7473-1-git-send-email-xose.vazquez@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was removed in the windows inf file by ralink.
And it isn't on ralink linux drivers.

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index a1691b8..c1cc15d 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1010,8 +1010,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Amigo */
 	{ USB_DEVICE(0x0e0b, 0x9031), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0e0b, 0x9041), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Askey */
-	{ USB_DEVICE(0x0930, 0x0a07), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* ASUS */
 	{ USB_DEVICE(0x0b05, 0x1760), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0b05, 0x1761), USB_DEVICE_DATA(&rt2800usb_ops) },
-- 
1.6.6.1

