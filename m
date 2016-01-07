Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from puleglot.ru ([78.47.112.147]:48896 "EHLO puleglot.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718AbcAHBdf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 20:33:35 -0500
From: Alexander Tsoy <alexander@tsoy.me>
Date: Fri, 8 Jan 2016 01:26:03 +0300
Subject: [PATCH] ath9k_htc: add device ID for Toshiba WLM-20U2/GN-1080
To: <linux-wireless@vger.kernel.org>
Cc: <ath9k-devel@lists.ath9k.org>
Message-Id: <E1aHLfh-0001d1-FT@puleglot.ru> (sfid-20160108_023351_482246_C5E98F12)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This device is available under different marketing names:
WLM-20U2 - Wireless USB Dongle for Toshiba TVs
GN-1080 - Wireless LAN Module for Toshiba MFPs.

Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 165dd20..8cbf490 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -55,6 +55,8 @@ static struct usb_device_id ath9k_hif_usb_ids[] = {
 	  .driver_info = AR9280_USB },  /* Buffalo WLI-UV-AG300P */
 	{ USB_DEVICE(0x04da, 0x3904),
 	  .driver_info = AR9280_USB },
+	{ USB_DEVICE(0x0930, 0x0a08),
+	  .driver_info = AR9280_USB },  /* Toshiba WLM-20U2 and GN-1080 */
 
 	{ USB_DEVICE(0x0cf3, 0x20ff),
 	  .driver_info = STORAGE_DEVICE },
-- 
2.4.10

