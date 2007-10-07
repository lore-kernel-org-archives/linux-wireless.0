Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:61900 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752735AbXJGOZ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Oct 2007 10:25:26 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw: Add ID for TalkTalk SNU5630NS/05
Message-Id: <20071007152426.330649D51CF@zog.reactivated.net> (sfid-20071007_152528_879568_1A0E6875)
Date: Sun,  7 Oct 2007 16:24:26 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested by Su-Jong You
zd1211b chip 0471:1237 v4810 high 00-12-bf AL2230_RF pa0 g--N

Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 zd_usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Index: linux-2.6/drivers/net/wireless/zd1211rw/zd_usb.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/zd1211rw/zd_usb.c
+++ linux-2.6/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -77,6 +77,7 @@ static struct usb_device_id usb_ids[] = 
 	{ USB_DEVICE(0x129b, 0x1667), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0cde, 0x001a), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0586, 0x340a), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0471, 0x1237), .driver_info = DEVICE_ZD1211B },
 	/* "Driverless" devices that need ejecting */
 	{ USB_DEVICE(0x0ace, 0x2011), .driver_info = DEVICE_INSTALLER },
 	{ USB_DEVICE(0x0ace, 0x20ff), .driver_info = DEVICE_INSTALLER },
