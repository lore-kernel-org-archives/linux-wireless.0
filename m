Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ipout2-voc1esa.syd1.mail-filtering.com.au ([175.107.169.225]:57961
        "EHLO o-voc1esa.syd1.mail-filtering.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754884AbdERJQs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 05:16:48 -0400
From: Tom Gaudasinski <tomg@records.headdesk.com.au>
To: linux-wireless@vger.kernel.org
Cc: sgruszka@redhat.com, helmut.schaa@googlemail.com,
        kvalo@codeaurora.org,
        Tom Gaudasinski <tomg@records.headdesk.com.au>
Subject: [PATCH] rt2x00: Add device ID for Epson WN7512BEP
Date: Thu, 18 May 2017 19:16:27 +1000
Message-Id: <1495098987-2691-1-git-send-email-tomg@records.headdesk.com.au> (sfid-20170518_111653_839896_084AEF50)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make Epson WN7512BEP work by adding its device-id to rt2800usb. Device
contains a Ralink RT3071L, registers as vendor Accton/Arcadyan.

Signed-off-by: Tom Gaudasinski <tomg@records.headdesk.com.au>

---
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
index f11e3f5..771bb76 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
@@ -1156,6 +1156,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x2001, 0x3c17) },
 	/* Panasonic */
 	{ USB_DEVICE(0x083a, 0xb511) },
+	/* Accton/Arcadyan/Epson */
+	{ USB_DEVICE(0x083a, 0xb512) },
 	/* Philips */
 	{ USB_DEVICE(0x0471, 0x20dd) },
 	/* Ralink */
-- 
2.7.4
