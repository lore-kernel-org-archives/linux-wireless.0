Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:55362 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbYJMVhp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 17:37:45 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54usb: Device ID updates
Date: Mon, 13 Oct 2008 23:41:53 +0200
Cc: John W Linville <linville@tuxdriver.com>, jafg666@gmail.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810132341.53306.chunkeey@web.de> (sfid-20081013_233749_395433_A09EE6F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch updates p54usb's device list.
It adds the ID for SMC 2862W-G v2 and marks the
"Spinnaker Proto board" as a first generation device.

Reported-by: <jafg666@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 1912f5e..75d749b 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -39,6 +39,7 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 	{USB_DEVICE(0x0846, 0x4200)},	/* Netgear WG121 */
 	{USB_DEVICE(0x0846, 0x4210)},	/* Netgear WG121 the second ? */
 	{USB_DEVICE(0x0846, 0x4220)},	/* Netgear WG111 */
+	{USB_DEVICE(0x09aa, 0x1000)},	/* Spinnaker Proto board */
 	{USB_DEVICE(0x0cde, 0x0006)},	/* Medion 40900, Roper Europe */
 	{USB_DEVICE(0x124a, 0x4023)},	/* Shuttle PN15, Airvast WM168g, IOGear GWU513 */
 	{USB_DEVICE(0x1915, 0x2234)},	/* Linksys WUSB54G OEM */
@@ -63,8 +64,8 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 	{USB_DEVICE(0x0cde, 0x0006)},   /* Medion MD40900 */
 	{USB_DEVICE(0x0cde, 0x0008)},	/* Sagem XG703A */
 	{USB_DEVICE(0x0d8e, 0x3762)},	/* DLink DWL-G120 Cohiba */
-	{USB_DEVICE(0x09aa, 0x1000)},	/* Spinnaker Proto board */
 	{USB_DEVICE(0x124a, 0x4025)},	/* IOGear GWU513 (GW3887IK chip) */
+	{USB_DEVICE(0x1260, 0xee22)},	/* SMC 2862W-G version 2 */
 	{USB_DEVICE(0x13b1, 0x000a)},	/* Linksys WUSB54G ver 2 */
 	{USB_DEVICE(0x13B1, 0x000C)},	/* Linksys WUSB54AG */
 	{USB_DEVICE(0x1435, 0x0427)},	/* Inventel UR054G */
