Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ipout1-voc1esa.cbr1.mail-filtering.com.au ([117.55.234.241]:3437
        "EHLO o-voc1esa.cbr1.mail-filtering.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751782AbdERJ2X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 05:28:23 -0400
From: Tom Gaudasinski <tomg@records.headdesk.com.au>
To: linux-wireless@vger.kernel.org
Cc: sgruszka@redhat.com, helmut.schaa@googlemail.com,
        kvalo@codeaurora.org,
        Tom Gaudasinski <tomg@records.headdesk.com.au>
Subject: [PATCH v2] rt2x00: Add device ID for Epson WN7512BEP
Date: Thu, 18 May 2017 19:27:50 +1000
Message-Id: <1495099670-2813-1-git-send-email-tomg@records.headdesk.com.au> (sfid-20170518_112827_933226_0CF94E71)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make Epson WN7512BEP work by adding its device-id to rt2800usb. Device
contains a Ralink RT3071L, registers as vendor Accton/Arcadyan. Corrections
made to submission for posterity.

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
