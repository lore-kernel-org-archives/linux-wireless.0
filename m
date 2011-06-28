Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:44815 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758286Ab1F1Ons (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 10:43:48 -0400
Received: from mail.atheros.com ([10.234.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jun 2011 07:43:11 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <rodrigue@qca.qualcomm.com>,
	<senthilb@qca.qualcomm.com>, <thomas@xyz.pp.se>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k_htc: Add device ID for Sony UWA-BR100
Date: Tue, 28 Jun 2011 20:13:41 +0530
Message-ID: <1309272221-25787-1-git-send-email-mshajakhan@atheros.com> (sfid-20110628_165534_181499_0295361F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

for more details please take a look at:
http://comments.gmane.org/gmane.linux.drivers.ath9k.devel/6541
http://www.wikidevi.com/wiki/Sony_UWA-BR100

Reported-by: Thomas Novin <thomas@xyz.pp.se>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 260f1f3..8028fe9 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -49,6 +49,8 @@ static struct usb_device_id ath9k_hif_usb_ids[] = {
 	  .driver_info = AR9280_USB },  /* Netgear WNDA3200 */
 	{ USB_DEVICE(0x083A, 0xA704),
 	  .driver_info = AR9280_USB },  /* SMC Networks */
+	{ USB_DEVICE(0x0411, 0x017f),
+	  .driver_info = AR9280_USB },  /* Sony UWA-BR100 */
 
 	{ USB_DEVICE(0x0cf3, 0x20ff),
 	  .driver_info = STORAGE_DEVICE },
-- 
1.7.0.4

