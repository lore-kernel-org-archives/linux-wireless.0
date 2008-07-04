Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from queueout01-winn.ispmail.ntl.com ([81.103.221.31]:44332 "EHLO
	queueout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753656AbYGDDet (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 23:34:49 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: firat@airties.com
Subject: [PATCH] zd1211rw: add ID for AirTies WUS-201
Message-Id: <20080704033151.0494872C001@zog.reactivated.net> (sfid-20080704_053453_530848_02A3D763)
Date: Fri,  4 Jul 2008 04:31:50 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Firat Birlik <firat@airties.com>

I would like to inform you of our zd1211 based usb wifi adapter (AirTies
WUS-201), which works with the zd1211rw driver with the following device
id definition.

Signed-off-by: Daniel Drake <dsd@gentoo.org>

Index: linux-2.6.26-rc8/drivers/net/wireless/zd1211rw/zd_usb.c
===================================================================
--- linux-2.6.26-rc8.orig/drivers/net/wireless/zd1211rw/zd_usb.c
+++ linux-2.6.26-rc8/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -64,6 +64,7 @@ static struct usb_device_id usb_ids[] = 
 	{ USB_DEVICE(0x079b, 0x0062), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x1582, 0x6003), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x050d, 0x705c), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x083a, 0xe506), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x083a, 0x4505), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0471, 0x1236), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x13b1, 0x0024), .driver_info = DEVICE_ZD1211B },
