Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:58086 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab0FJW2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 18:28:41 -0400
Subject: [PATCH] p54usb: Remove duplicate Medion MD40900 device id
From: Leann Ogasawara <leann.ogasawara@canonical.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	flamingice@sourmilk.net
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jun 2010 15:28:33 -0700
Message-ID: <1276208913.1221.3646.camel@emiko>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Medion MD40900 device id [0x0cde, 0x0006] is defined twice.  Remove
the duplicate.

Originally-by: Ben Collins <ben.collins@ubuntu.com>
Signed-off-by: Leann Ogasawara <leann.ogasawara@canonical.com>
---
 drivers/net/wireless/p54/p54usb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 7307325..d6d8713 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -69,7 +69,6 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 	{USB_DEVICE(0x0915, 0x2002)},	/* Cohiba Proto board */
 	{USB_DEVICE(0x0baf, 0x0118)},   /* U.S. Robotics U5 802.11g Adapter*/
 	{USB_DEVICE(0x0bf8, 0x1009)},   /* FUJITSU E-5400 USB D1700*/
-	{USB_DEVICE(0x0cde, 0x0006)},   /* Medion MD40900 */
 	{USB_DEVICE(0x0cde, 0x0008)},	/* Sagem XG703A */
 	{USB_DEVICE(0x0cde, 0x0015)},	/* Zcomax XG-705A */
 	{USB_DEVICE(0x0d8e, 0x3762)},	/* DLink DWL-G120 Cohiba */
-- 
1.7.0.4



