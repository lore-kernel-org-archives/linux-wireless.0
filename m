Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:33028 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759231AbZC2Uuc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 16:50:32 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] p54usb: add Telsey 802.11g USB2.0 Adapter
Date: Sun, 29 Mar 2009 22:50:28 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903292250.28819.chunkeey@web.de> (sfid-20090329_225046_973452_91557CAA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index da6640a..6cc6cbc 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -71,6 +71,7 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 	{USB_DEVICE(0x1260, 0xee22)},	/* SMC 2862W-G version 2 */
 	{USB_DEVICE(0x13b1, 0x000a)},	/* Linksys WUSB54G ver 2 */
 	{USB_DEVICE(0x13B1, 0x000C)},	/* Linksys WUSB54AG */
+	{USB_DEVICE(0x1413, 0x5400)},   /* Telsey 802.11g USB2.0 Adapter */
 	{USB_DEVICE(0x1435, 0x0427)},	/* Inventel UR054G */
 	{USB_DEVICE(0x2001, 0x3704)},	/* DLink DWL-G122 rev A2 */
 	{USB_DEVICE(0x413c, 0x8102)},	/* Spinnaker DUT */
