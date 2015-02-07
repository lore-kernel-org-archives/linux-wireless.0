Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:39808 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbbBGKqV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2015 05:46:21 -0500
Received: by mail-qg0-f41.google.com with SMTP id i50so14340146qgf.0
        for <linux-wireless@vger.kernel.org>; Sat, 07 Feb 2015 02:46:20 -0800 (PST)
From: Leon Nardella <leon.nardella@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, ath9k-devel@qca.qualcomm.com,
	kvalo@codeaurora.org, Leon Nardella <leon.nardella@gmail.com>
Subject: [PATCH] * Add support for Philips (or NXP) PTA01 Wireless Adapter
Date: Sat,  7 Feb 2015 08:46:11 -0200
Message-Id: <1423305971-8360-1-git-send-email-leon.nardella@gmail.com> (sfid-20150207_114625_042071_A4445DCD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Leon Nardella <leon.nardella@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 8e7153b..10c02f5 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -40,6 +40,7 @@ static struct usb_device_id ath9k_hif_usb_ids[] = {
 	{ USB_DEVICE(0x0cf3, 0xb003) }, /* Ubiquiti WifiStation Ext */
 	{ USB_DEVICE(0x0cf3, 0xb002) }, /* Ubiquiti WifiStation */
 	{ USB_DEVICE(0x057c, 0x8403) }, /* AVM FRITZ!WLAN 11N v2 USB */
+	{ USB_DEVICE(0x0471, 0x209e) }, /* Philips (or NXP) PTA01 */
 
 	{ USB_DEVICE(0x0cf3, 0x7015),
 	  .driver_info = AR9287_USB },  /* Atheros */
-- 
2.1.0

