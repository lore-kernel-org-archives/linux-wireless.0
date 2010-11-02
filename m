Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vostochny.stro.at ([78.47.22.85]:48411 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172Ab0KBWjW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 18:39:22 -0400
From: maximilian attems <max@stro.at>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, maximilian attems <max@stro.at>
Subject: [PATCH] zd1201: Add missing id
Date: Tue,  2 Nov 2010 23:39:12 +0100
Message-Id: <1288737552-3524-1-git-send-email-max@stro.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Mandriva patch seems to stem from 2.6.14, so much for their
upstreaming effort.

Didn't find another Linux reference of it, just an omnious
"USB\VID_1044&PID_8004" from GigabyteZD1201U.INF for
Gigabyte GN-WLBZ101 802.11b USB Adapter, which matches the
Mandriva patch comment.

Aboves file also lists an "USB\VID_1044&PID_8006", which I have
kept appart as this "Gigabyte GN-WBZB-M 802.11b USB Adapter"
didn't show up in googling.

Signed-off-by: maximilian attems <max@stro.at>
---
 drivers/net/wireless/zd1201.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/zd1201.c b/drivers/net/wireless/zd1201.c
index 390d77f..b97aa9c 100644
--- a/drivers/net/wireless/zd1201.c
+++ b/drivers/net/wireless/zd1201.c
@@ -30,6 +30,7 @@ static struct usb_device_id zd1201_table[] = {
 	{USB_DEVICE(0x0ace, 0x1201)}, /* ZyDAS ZD1201 Wireless USB Adapter */
 	{USB_DEVICE(0x050d, 0x6051)}, /* Belkin F5D6051 usb  adapter */
 	{USB_DEVICE(0x0db0, 0x6823)}, /* MSI UB11B usb  adapter */
+	{USB_DEVICE(0x1044, 0x8004)}, /* Gigabyte GN-WLBZ101 */
 	{USB_DEVICE(0x1044, 0x8005)}, /* GIGABYTE GN-WLBZ201 usb adapter */
 	{}
 };
-- 
1.7.1

