Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:64705 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751127AbeA2IOo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Jan 2018 03:14:44 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH] ath9k_htc: add Altai WA1011N-GU
Date: Mon, 29 Jan 2018 09:14:30 +0100
Message-Id: <20180129081430.16413-1-linux@rempel-privat.de> (sfid-20180129_091448_449566_9D0C2ACC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

as reported in:
https://github.com/qca/open-ath9k-htc-firmware/pull/71#issuecomment-361100070

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 56676eaff24c..cb0eef13af1c 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -24,6 +24,7 @@ static const struct usb_device_id ath9k_hif_usb_ids[] = {
 	{ USB_DEVICE(0x0cf3, 0x9271) }, /* Atheros */
 	{ USB_DEVICE(0x0cf3, 0x1006) }, /* Atheros */
 	{ USB_DEVICE(0x0846, 0x9030) }, /* Netgear N150 */
+	{ USB_DEVICE(0x07b8, 0x9271) }, /* Altai WA1011N-GU */
 	{ USB_DEVICE(0x07D1, 0x3A10) }, /* Dlink Wireless 150 */
 	{ USB_DEVICE(0x13D3, 0x3327) }, /* Azurewave */
 	{ USB_DEVICE(0x13D3, 0x3328) }, /* Azurewave */
-- 
2.14.1
