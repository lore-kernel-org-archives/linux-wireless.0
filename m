Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12731 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab2DKI2y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 04:28:54 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20357.16543.250833.850316@gargle.gargle.HOWL> (sfid-20120411_102901_078440_B1EF2A68)
Date: Wed, 11 Apr 2012 13:58:15 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k_htc: Add Panasonic N5HBZ0000055 device id
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Ryan Roper <ryan.roper@gmail.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 424aabb..f67cd95 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -53,6 +53,8 @@ static struct usb_device_id ath9k_hif_usb_ids[] = {
 	  .driver_info = AR9280_USB },  /* SMC Networks */
 	{ USB_DEVICE(0x0411, 0x017f),
 	  .driver_info = AR9280_USB },  /* Sony UWA-BR100 */
+	{ USB_DEVICE(0x04da, 0x3904),
+	  .driver_info = AR9280_USB },
 
 	{ USB_DEVICE(0x0cf3, 0x20ff),
 	  .driver_info = STORAGE_DEVICE },
-- 
1.7.10

