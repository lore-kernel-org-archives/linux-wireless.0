Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4722 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933740AbYBTUcH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 15:32:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Cavan Carroll <cavancarroll@hotmail.com>
Subject: [PATCH] p54usb: add USB ID for Linksys WUSB54G ver 2
Date: Wed, 20 Feb 2008 15:06:30 -0500
Message-Id: <1203537990-10448-1-git-send-email-linville@tuxdriver.com> (sfid-20080220_203225_580796_4411AF41)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on report from Cavan Carroll <cavancarroll@hotmail.com>:

	http://bugzilla.kernel.org/show_bug.cgi?id=9863

Cc: Cavan Carroll <cavancarroll@hotmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/p54usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/p54usb.c b/drivers/net/wireless/p54usb.c
index f869566..e7d4aee 100644
--- a/drivers/net/wireless/p54usb.c
+++ b/drivers/net/wireless/p54usb.c
@@ -63,6 +63,7 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 	{USB_DEVICE(0x0cde, 0x0008)},	/* Sagem XG703A */
 	{USB_DEVICE(0x0d8e, 0x3762)},	/* DLink DWL-G120 Cohiba */
 	{USB_DEVICE(0x09aa, 0x1000)},	/* Spinnaker Proto board */
+	{USB_DEVICE(0x13b1, 0x000a)},	/* Linksys WUSB54G ver 2 */
 	{USB_DEVICE(0x13B1, 0x000C)},	/* Linksys WUSB54AG */
 	{USB_DEVICE(0x1435, 0x0427)},	/* Inventel UR054G */
 	{USB_DEVICE(0x2001, 0x3704)},	/* DLink DWL-G122 rev A2 */
-- 
1.5.3.3

