Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:28540 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755494AbXEVAAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2007 20:00:10 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw-mac80211: Add ID for ZyXEL G-200v2
Message-Id: <20070522000009.E54A87B409F@zog.reactivated.net>
Date: Tue, 22 May 2007 01:00:09 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested by Guy Gallagher
zd1211 chip 0586:3407 v4721 high 00-13-49 AL2230_RF pa0 g---
FCC ID SI5WUB200Z

Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 drivers/net/wireless/mac80211/zd1211rw/zd_usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_usb.c b/drivers/net/wireless/mac80211/zd1211rw/zd_usb.c
index e623043..47db3e3 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_usb.c
@@ -52,6 +52,7 @@ static struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x0586, 0x3401), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x14ea, 0xab13), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x13b1, 0x001e), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x0586, 0x3407), .driver_info = DEVICE_ZD1211 },
 	/* ZD1211B */
 	{ USB_DEVICE(0x0ace, 0x1215), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x157e, 0x300d), .driver_info = DEVICE_ZD1211B },
-- 
1.5.2

