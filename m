Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4724 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764744AbYBTUcI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 15:32:08 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo Couckuyt <iv0co@yahoo.co.uk>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] p54usb: add USB ID for Phillips CPWUA054
Date: Wed, 20 Feb 2008 15:01:55 -0500
Message-Id: <1203537715-10263-1-git-send-email-linville@tuxdriver.com> (sfid-20080220_203226_280869_06880CA1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo Couckuyt <iv0co@yahoo.co.uk>

Retarget of an old patch against prism54usb in linux-wireless archive:

	http://marc.info/?l=linux-wireless&m=117449935810254&w=2

Cc: Ivo Couckuyt <iv0co@yahoo.co.uk>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/p54usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/p54usb.c b/drivers/net/wireless/p54usb.c
index 60d286e..f869566 100644
--- a/drivers/net/wireless/p54usb.c
+++ b/drivers/net/wireless/p54usb.c
@@ -35,6 +35,7 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 	{USB_DEVICE(0x0707, 0xee06)},	/* SMC 2862W-G */
 	{USB_DEVICE(0x083a, 0x4501)},	/* Accton 802.11g WN4501 USB */
 	{USB_DEVICE(0x083a, 0x4502)},	/* Siemens Gigaset USB Adapter */
+	{USB_DEVICE(0x083a, 0x5501)},	/* Phillips CPWUA054 */
 	{USB_DEVICE(0x0846, 0x4200)},	/* Netgear WG121 */
 	{USB_DEVICE(0x0846, 0x4210)},	/* Netgear WG121 the second ? */
 	{USB_DEVICE(0x0846, 0x4220)},	/* Netgear WG111 */
-- 
1.5.3.3

