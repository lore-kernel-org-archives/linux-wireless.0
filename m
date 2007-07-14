Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:44898 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756701AbXGNAk6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2007 20:40:58 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw: Add ID for Siemens Gigaset USB Stick 54
Message-Id: <20070714004054.7107A7B409F@zog.reactivated.net>
Date: Sat, 14 Jul 2007 01:40:54 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested by David Santinoli
zd1211b chip 129b:1667 v4810 high 00-01-e3 AL2230S_RF pa0 ---N-

Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 zd_usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Index: linux/drivers/net/wireless/zd1211rw/zd_usb.c
===================================================================
--- linux.orig/drivers/net/wireless/zd1211rw/zd_usb.c
+++ linux/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -73,6 +73,7 @@ static struct usb_device_id usb_ids[] = 
 	{ USB_DEVICE(0x0053, 0x5301), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0411, 0x00da), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x2019, 0x5303), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x129b, 0x1667), .driver_info = DEVICE_ZD1211B },
 	/* "Driverless" devices that need ejecting */
 	{ USB_DEVICE(0x0ace, 0x2011), .driver_info = DEVICE_INSTALLER },
 	{ USB_DEVICE(0x0ace, 0x20ff), .driver_info = DEVICE_INSTALLER },
