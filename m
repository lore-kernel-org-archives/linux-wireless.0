Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:10586 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab0CARXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 12:23:37 -0500
Received: by qw-out-2122.google.com with SMTP id 8so538666qwh.37
        for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 09:23:36 -0800 (PST)
Date: Mon, 1 Mar 2010 12:23:28 -0500 (EST)
From: Bryan Polk <sainth@eidolons.org>
To: "John W. Linville" <linville@tuxdriver.com>
cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH] rt2x00: Add USB ID for CEIVA adapter to rt73usb
In-Reply-To: <4B8B3A1A.80403@gmail.com>
Message-ID: <alpine.LNX.2.00.1003011205211.28884@eidolons.org>
References: <51a465a61002281248jc7701abq642b67f0b68ed80a@mail.gmail.com> <4B8B3A1A.80403@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for CEIVA USB wireless adapters to the rt73usb driver.

Signed-off-by: Bryan Polk <sainth@eidolons.org>
---
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index f39a8ed..47f3e4a 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2352,6 +2352,8 @@ static struct usb_device_id rt73usb_device_table[] = {
 	{ USB_DEVICE(0x0411, 0x00f4), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x0411, 0x0116), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x0411, 0x0119), USB_DEVICE_DATA(&rt73usb_ops) },
+	/* CEIVA */
+	{ USB_DEVICE(0x178d, 0x02be), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* CNet */
 	{ USB_DEVICE(0x1371, 0x9022), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x1371, 0x9032), USB_DEVICE_DATA(&rt73usb_ops) },
