Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:3369 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696Ab2BKU6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Feb 2012 15:58:14 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] rt2x00: Add support for D-Link DWA-127 to rt2800usb.
Date: Sat, 11 Feb 2012 21:58:09 +0100
Message-Id: <1328993889-28763-1-git-send-email-gwingerde@gmail.com> (sfid-20120211_215834_286082_4587A2F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an RT3070 based device.

Cc: <stable@vger.kernel.org>
Reported-by: Mikhail Kryshen <mikhail@kryshen.net>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index d009b6b..0074c4e 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -921,6 +921,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x07d1, 0x3c13) },
 	{ USB_DEVICE(0x07d1, 0x3c15) },
 	{ USB_DEVICE(0x07d1, 0x3c16) },
+	{ USB_DEVICE(0x2001, 0x3c1b) },
 	/* Draytek */
 	{ USB_DEVICE(0x07fa, 0x7712) },
 	/* DVICO */
-- 
1.7.9

