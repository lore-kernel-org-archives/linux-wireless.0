Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:35177 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706AbXJGOX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Oct 2007 10:23:57 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw-mac80211: Add ID for TalkTalk SNU5630NS/05
Message-Id: <20071007152333.51E0D9D51CF@zog.reactivated.net> (sfid-20071007_152403_386779_B319A45D)
Date: Sun,  7 Oct 2007 16:23:33 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested by Su-Jong You
zd1211b chip 0471:1237 v4810 high 00-12-bf AL2230_RF pa0 g--N

Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 drivers/net/wireless/zd1211rw-mac80211/zd_usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw-mac80211/zd_usb.c b/drivers/net/wireless/zd1211rw-mac80211/zd_usb.c
index c81ba0f..15ea70e 100644
--- a/drivers/net/wireless/zd1211rw-mac80211/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw-mac80211/zd_usb.c
@@ -74,6 +74,7 @@ static struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x129b, 0x1667), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0cde, 0x001a), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0586, 0x340a), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0471, 0x1237), .driver_info = DEVICE_ZD1211B },
 	/* "Driverless" devices that need ejecting */
 	{ USB_DEVICE(0x0ace, 0x2011), .driver_info = DEVICE_INSTALLER },
 	{ USB_DEVICE(0x0ace, 0x20ff), .driver_info = DEVICE_INSTALLER },
-- 
1.5.3.3

