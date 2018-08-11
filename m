Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:37462 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727399AbeHLCJx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 Aug 2018 22:09:53 -0400
Received: by mail-pl0-f68.google.com with SMTP id d5-v6so5464221pll.4
        for <linux-wireless@vger.kernel.org>; Sat, 11 Aug 2018 16:34:04 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: lorenzo.bianconi@redhat.com
Cc: linux-wireless@vger.kernel.org, Rosen Penev <rosenp@gmail.com>
Subject: [PATCH] mt76x2u: Add support for Alfa AWUS036ACM
Date: Sat, 11 Aug 2018 16:33:52 -0700
Message-Id: <1534030432-229-1-git-send-email-rosenp@gmail.com> (sfid-20180812_013640_356065_90FAEC7D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A 2x2 unit with a USB dock for optimal placement.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2_usb.c
index 1428cfd..f5338c3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_usb.c
@@ -20,6 +20,7 @@
 #include "mt76x2u.h"
 
 static const struct usb_device_id mt76x2u_device_table[] = {
+	{ USB_DEVICE(0x0e8d, 0x7612) }, /* Alfa AWUS036ACM */
 	{ USB_DEVICE(0x0b05, 0x1833) },	/* Asus USB-AC54 */
 	{ USB_DEVICE(0x0b05, 0x17eb) },	/* Asus USB-AC55 */
 	{ USB_DEVICE(0x0b05, 0x180b) },	/* Asus USB-N53 B1 */
-- 
2.7.4
