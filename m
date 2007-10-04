Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:10149 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751128AbXJDEIe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2007 00:08:34 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] p54usb: Add device ID for Linksys WUSB54AG
Date: Thu, 04 Oct 2007 00:06:00 -0400
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Martti Huttunen <martti.huttunen@mail.suomi.net>
Message-Id: <20071004040600.23974.82373.stgit@magic.sourmilk.net> (sfid-20071004_050842_664875_ACD7E674)
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Martti Huttunen <martti.huttunen@mail.suomi.net>

Add the device ID for Linksys WUSB54AG.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/p54usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/p54usb.c b/drivers/net/wireless/p54usb.c
index 7446c39..755482a 100644
--- a/drivers/net/wireless/p54usb.c
+++ b/drivers/net/wireless/p54usb.c
@@ -62,6 +62,7 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 	{USB_DEVICE(0x0cde, 0x0008)},	/* Sagem XG703A */
 	{USB_DEVICE(0x0d8e, 0x3762)},	/* DLink DWL-G120 Cohiba */
 	{USB_DEVICE(0x09aa, 0x1000)},	/* Spinnaker Proto board */
+	{USB_DEVICE(0x13B1, 0x000C)},	/* Linksys WUSB54AG */
 	{USB_DEVICE(0x1435, 0x0427)},	/* Inventel UR054G */
 	{USB_DEVICE(0x2001, 0x3704)},	/* DLink DWL-G122 rev A2 */
 	{USB_DEVICE(0x413c, 0x8102)},	/* Spinnaker DUT */

