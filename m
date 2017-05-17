Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ipout2-voc2esa.syd1.mail-filtering.com.au ([175.107.169.228]:17760
        "EHLO o-voc2esa.syd1.mail-filtering.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753034AbdEQKrS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 May 2017 06:47:18 -0400
From: =?UTF-8?Q?Tom_Gaudasi=c5=84ski?= <tomg@records.headdesk.com.au>
Subject: [PATCH] rt2800usb: Add Epson wireless adapter device-id
Cc: sgruszka@redhat.com, helmut.schaa@googlemail.com
To: linux-wireless@vger.kernel.org
Message-ID: <8e00714b-ab62-15e9-e86a-e0de5009797d@records.headdesk.com.au> (sfid-20170517_124732_436098_053CFA3D)
Date: Wed, 17 May 2017 20:15:30 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make Epson WN7512BEP work by adding its device-id to rt2800usb. Device
contains a Ralink RT3071L, registers as vendor Accton/Arcadyan.

Signed-off-by: Tom Gaudasinski <tomg@records.headdesk.com.au>

--- linux/drivers/net/wireless/ralink/rt2x00/rt2800usb.c.orig   
2017-05-17 19:49:44.893895819 +1000
+++ linux/drivers/net/wireless/ralink/rt2x00/rt2800usb.c    2017-05-17
19:49:32.906111192 +1000
@@ -1156,6 +1156,8 @@ static struct usb_device_id rt2800usb_de
     { USB_DEVICE(0x2001, 0x3c17) },
     /* Panasonic */
     { USB_DEVICE(0x083a, 0xb511) },
+    /* Accton/Arcadyan/Epson */
+    { USB_DEVICE(0x083a, 0xb512) },
     /* Philips */
     { USB_DEVICE(0x0471, 0x20dd) },
     /* Ralink */
