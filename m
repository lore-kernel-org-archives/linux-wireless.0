Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:10814 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753524AbXCYXUU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Mar 2007 19:20:20 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw-mac80211: Add another ID for Linksys WUSBF54G
Message-Id: <20070325232025.7AFF97B409F@zog.reactivated.net>
Date: Mon, 26 Mar 2007 00:20:25 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested by TiCPU on irc

zd1211 chip 13b1:001e v4802 high 00-14-bf AL2230_RF pa0 g---

Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 drivers/net/wireless/mac80211/zd1211rw/zd_usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_usb.c b/drivers/net/wireless/mac80211/zd1211rw/zd_usb.c
index 24d22dc..1d84830 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_usb.c
@@ -50,6 +50,7 @@ static struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x0b3b, 0x1630), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x0586, 0x3401), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x14ea, 0xab13), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x13b1, 0x001e), .driver_info = DEVICE_ZD1211 },
 	/* ZD1211B */
 	{ USB_DEVICE(0x0ace, 0x1215), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x157e, 0x300d), .driver_info = DEVICE_ZD1211B },
-- 
1.5.0.5

