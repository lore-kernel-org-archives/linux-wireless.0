Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rosetta.club.kyutech.ac.jp ([131.206.108.15]:46283 "EHLO
	rosetta.club.kyutech.ac.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668AbaBFFQn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 00:16:43 -0500
From: Masaki TAGAWA <masaki@club.kyutech.ac.jp>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Masaki TAGAWA <masaki@club.kyutech.ac.jp>
Subject: [PATCH] ath9k_htc: Add device ID for Buffalo WLI-UV-AG300P
Date: Thu,  6 Feb 2014 14:06:24 +0900
Message-Id: <1391663184-14810-1-git-send-email-masaki@club.kyutech.ac.jp> (sfid-20140206_061839_252586_519620C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Buffalo WLI-UV-AG300P is almost the same as Sony UWA-BR100.

Signed-off-by: Masaki TAGAWA <masaki@club.kyutech.ac.jp>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 6d5d716..8e7153b 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -54,6 +54,8 @@ static struct usb_device_id ath9k_hif_usb_ids[] = {
 	  .driver_info = AR9280_USB },  /* SMC Networks */
 	{ USB_DEVICE(0x0411, 0x017f),
 	  .driver_info = AR9280_USB },  /* Sony UWA-BR100 */
+	{ USB_DEVICE(0x0411, 0x0197),
+	  .driver_info = AR9280_USB },  /* Buffalo WLI-UV-AG300P */
 	{ USB_DEVICE(0x04da, 0x3904),
 	  .driver_info = AR9280_USB },
 
-- 
1.7.11.2

