Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34681 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932343AbdBPQN4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Feb 2017 11:13:56 -0500
From: Dmitry Tunin <hanipouspilot@gmail.com>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Tunin <hanipouspilot@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] ath9k_htc: Add support of AirTies 1eda:2315 AR9271 device
Date: Thu, 16 Feb 2017 19:13:42 +0300
Message-Id: <1487261622-21338-1-git-send-email-hanipouspilot@gmail.com> (sfid-20170216_171559_164699_9F271D89)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T:  Bus=01 Lev=02 Prnt=02 Port=02 Cnt=01 Dev#=  7 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=ff(vend.) Sub=ff Prot=ff MxPS=64 #Cfgs=  1
P:  Vendor=1eda ProdID=2315 Rev=01.08
S:  Manufacturer=ATHEROS
S:  Product=USB2.0 WLAN
S:  SerialNumber=12345
C:  #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 6 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)

Signed-off-by: Dmitry Tunin <hanipouspilot@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index de2d212..05dd056 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -37,6 +37,7 @@ static struct usb_device_id ath9k_hif_usb_ids[] = {
 	{ USB_DEVICE(0x0cf3, 0xb002) }, /* Ubiquiti WifiStation */
 	{ USB_DEVICE(0x057c, 0x8403) }, /* AVM FRITZ!WLAN 11N v2 USB */
 	{ USB_DEVICE(0x0471, 0x209e) }, /* Philips (or NXP) PTA01 */
+	{ USB_DEVICE(0x1eda, 0x2315) }, /* AirTies */
 
 	{ USB_DEVICE(0x0cf3, 0x7015),
 	  .driver_info = AR9287_USB },  /* Atheros */
-- 
2.7.4
