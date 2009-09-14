Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from LL-220-228-151-25.LL.sparqnet.net ([220.228.151.25]:38117 "EHLO
	mail.atheros.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757537AbZINXpK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 19:45:10 -0400
From: Stephen Chen <Stephen.Chen@Atheros.com>
To: Christian Lamparter <chunkeey@googlemail.com>,
	Fabian Lenz <lenz_fabian@yahoo.de>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Date: Tue, 15 Sep 2009 07:39:40 +0800
Subject: RE: [RFC] ar9170usb: add ar9170 usbid
Message-ID: <618D4DE9D5223A45A46C48063FD64045109947ACC0@TAEXMB-01.global.atheros.com>
References: <200909142046.07525.lenz_fabian@yahoo.de>
 <200909142308.19569.chunkeey@googlemail.com>
In-Reply-To: <200909142308.19569.chunkeey@googlemail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

I could not find this VID/PID in INF file in Windows release.
This ID combination could be obsolete.
Thank you!

Stephen
-----Original Message-----
From: Christian Lamparter [mailto:chunkeey@googlemail.com]
Sent: Tuesday, September 15, 2009 5:08 AM
To: Fabian Lenz
Cc: linux-wireless@vger.kernel.org; Luis Rodriguez; Stephen Chen
Subject: [RFC] ar9170usb: add ar9170 usbid

Reported-by: Fabian Lenz <lenz_fabian@yahoo.de>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
Stephen,

- since 0x0cf3 is Atheros' vendor id - can you please lookup the real product
code name for 0x0cf3:0x1002.

I will take care of the re-spin and update the wiki.

Thanks,
        Chr
---
diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index e0138ac..68b0bda 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -64,6 +64,8 @@ static struct usb_device_id ar9170_usb_ids[] = {
        { USB_DEVICE(0x0cf3, 0x9170) },
        /* Atheros TG121N */
        { USB_DEVICE(0x0cf3, 0x1001) },
+       /* Atheros - Unknown Product Name - */
+       { USB_DEVICE(0x0cf3, 0x1002) },
        /* Cace Airpcap NX */
        { USB_DEVICE(0xcace, 0x0300) },
        /* D-Link DWA 160A */
