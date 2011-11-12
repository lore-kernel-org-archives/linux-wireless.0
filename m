Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:2939 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583Ab1KLSRK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Nov 2011 13:17:10 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH] rt2x00: Add USB device ID of Buffalo WLI-UC-GNHP.
Date: Sat, 12 Nov 2011 19:10:43 +0100
Message-Id: <1321121444-31528-1-git-send-email-gwingerde@gmail.com> (sfid-20111112_191725_113063_B4F439FE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is reported to be an RT3070 based device.

Reported-by: Teika Kazura <teika@lavabit.com>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index f156579..3778763 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -919,6 +919,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x050d, 0x935b) },
 	/* Buffalo */
 	{ USB_DEVICE(0x0411, 0x00e8) },
+	{ USB_DEVICE(0x0411, 0x0158) },
 	{ USB_DEVICE(0x0411, 0x016f) },
 	{ USB_DEVICE(0x0411, 0x01a2) },
 	/* Corega */
-- 
1.7.7

