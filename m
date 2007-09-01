Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:48544 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756173AbXIAViz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 17:38:55 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw-mac80211: add USB id for Telegent TG54USB WLAN adapter
Message-Id: <20070901213858.31C6C7B409F@zog.reactivated.net>
Date: Sat,  1 Sep 2007 22:38:57 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ulrich Kunitz <kune@deine-taler.de>

Reinhard Speyerer reported at 2007-08-10 a new device.

Here are the information strings.

Product: Telegent TG54USB WLAN Adapter
USB ID: 129b:1666
Chip ID: zd1211 chip 129b:1666 v4330 high 00-01-36 RF2959_RF pa0 -----
FCC ID: N89-UW620Z

Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 drivers/net/wireless/zd1211rw-mac80211/zd_usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw-mac80211/zd_usb.c b/drivers/net/wireless/zd1211rw-mac80211/zd_usb.c
index 0d942a4..9de9f7e 100644
--- a/drivers/net/wireless/zd1211rw-mac80211/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw-mac80211/zd_usb.c
@@ -53,6 +53,7 @@ static struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x14ea, 0xab13), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x13b1, 0x001e), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x0586, 0x3407), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x129b, 0x1666), .driver_info = DEVICE_ZD1211 },
 	/* ZD1211B */
 	{ USB_DEVICE(0x0ace, 0x1215), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x157e, 0x300d), .driver_info = DEVICE_ZD1211B },
-- 
1.5.3.rc7

