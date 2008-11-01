Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:49793 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373AbYKARQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 13:16:17 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] zd1211rw: Add 2 device IDs
Message-Id: <20081101170348.3E56D72C001@zog.reactivated.net> (sfid-20081101_181619_708673_C817E0F6)
Date: Sat,  1 Nov 2008 17:03:48 +0000 (GMT)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

07fa/1196
Bewan BWIFI-USB54AR: Tested by night1308, this device is a ZD1211B with
an AL2230S radio.

0ace/b215
HP 802.11abg: Tested by Robert Philippe
---
 drivers/net/wireless/zd1211rw/zd_usb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index a60ae86..a3ccd8c 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -61,6 +61,7 @@ static struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x0105, 0x145f), .driver_info = DEVICE_ZD1211 },
 	/* ZD1211B */
 	{ USB_DEVICE(0x0ace, 0x1215), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0ace, 0xb215), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x157e, 0x300d), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x079b, 0x0062), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x1582, 0x6003), .driver_info = DEVICE_ZD1211B },
@@ -82,6 +83,7 @@ static struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x0cde, 0x001a), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0586, 0x340a), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0471, 0x1237), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x07fa, 0x1196), .driver_info = DEVICE_ZD1211B },
 	/* "Driverless" devices that need ejecting */
 	{ USB_DEVICE(0x0ace, 0x2011), .driver_info = DEVICE_INSTALLER },
 	{ USB_DEVICE(0x0ace, 0x20ff), .driver_info = DEVICE_INSTALLER },
-- 
1.6.0.3

