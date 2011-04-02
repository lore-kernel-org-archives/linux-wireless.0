Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50016 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1DBJbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Apr 2011 05:31:34 -0400
Received: by fxm17 with SMTP id 17so3069894fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Apr 2011 02:31:33 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH -stable] p54usb: IDs for two new devices
Date: Sat, 2 Apr 2011 11:31:29 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201104021131.29616.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: <stable@kernel.org>
Reported-by: Mark Davis [via p54/devices wiki]
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 9b344a9..e183587 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -56,6 +56,7 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 	{USB_DEVICE(0x0846, 0x4210)},	/* Netgear WG121 the second ? */
 	{USB_DEVICE(0x0846, 0x4220)},	/* Netgear WG111 */
 	{USB_DEVICE(0x09aa, 0x1000)},	/* Spinnaker Proto board */
+	{USB_DEVICE(0x0bf8, 0x1007)},	/* Fujitsu E-5400 USB */
 	{USB_DEVICE(0x0cde, 0x0006)},	/* Medion 40900, Roper Europe */
 	{USB_DEVICE(0x0db0, 0x6826)},	/* MSI UB54G (MS-6826) */
 	{USB_DEVICE(0x107b, 0x55f2)},	/* Gateway WGU-210 (Gemtek) */
@@ -68,6 +69,7 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 	{USB_DEVICE(0x1915, 0x2235)},	/* Linksys WUSB54G Portable OEM */
 	{USB_DEVICE(0x2001, 0x3701)},	/* DLink DWL-G120 Spinnaker */
 	{USB_DEVICE(0x2001, 0x3703)},	/* DLink DWL-G122 */
+	{USB_DEVICE(0x2001, 0x3762)},	/* Conceptronic C54U */
 	{USB_DEVICE(0x5041, 0x2234)},	/* Linksys WUSB54G */
 	{USB_DEVICE(0x5041, 0x2235)},	/* Linksys WUSB54G Portable */
 
