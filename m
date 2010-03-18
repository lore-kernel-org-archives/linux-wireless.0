Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:51248 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab0CRXHC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 19:07:02 -0400
Received: by mail-bw0-f209.google.com with SMTP id 1so2546834bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 18 Mar 2010 16:07:02 -0700 (PDT)
Date: Thu, 18 Mar 2010 19:06:57 -0400
From: Ben Konrath <ben@bagu.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/1] ar9170: add support for NEC WL300NU-G USB dongle
Message-ID: <20100318230657.GB4280@plug.phub.net.cable.rogers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This patch adds support for the NEC WL300NU-G USB wifi dongle.

Signed-off-by: Ben Konrath <ben@bagu.org>
---
 drivers/net/wireless/ath/ar9170/usb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index 0f36118..49f06b5 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -94,6 +94,8 @@ static struct usb_device_id ar9170_usb_ids[] = {
 	{ USB_DEVICE(0x04bb, 0x093f) },
 	/* AVM FRITZ!WLAN USB Stick N */
 	{ USB_DEVICE(0x057C, 0x8401) },
+	/* NEC WL300NU-G */
+	{ USB_DEVICE(0x0409, 0x0249) },
 	/* AVM FRITZ!WLAN USB Stick N 2.4 */
 	{ USB_DEVICE(0x057C, 0x8402), .driver_info = AR9170_REQ_FW1_ONLY },
 
-- 
1.6.6.1

