Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:52809 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757970Ab0FQKrc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 06:47:32 -0400
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Subject: [PATCH] p54usb: Drop duplicate USBID 0xcde:0x0006
Date: Thu, 17 Jun 2010 13:37:29 +0300
Message-Id: <1276771049-2187-1-git-send-email-ozan@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop the duplicate USB ID 0xcde:0x0006 which is written at two
different places in p54usb.c

Signed-off-by: Ozan Çağlayan <ozan@pardus.org.tr>
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
1.7.1

