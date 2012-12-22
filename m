Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tur.go2.pl ([193.17.41.50]:38325 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab2LVQUL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 11:20:11 -0500
Received: from moh1-ve3.go2.pl (moh1-ve3.go2.pl [193.17.41.134])
	by tur.go2.pl (Postfix) with ESMTP id 979C115A073C
	for <linux-wireless@vger.kernel.org>; Sat, 22 Dec 2012 17:20:10 +0100 (CET)
Received: from moh1-ve3.go2.pl (unknown [10.0.0.134])
	by moh1-ve3.go2.pl (Postfix) with ESMTP id CD9E4665742
	for <linux-wireless@vger.kernel.org>; Sat, 22 Dec 2012 17:19:01 +0100 (CET)
Received: from unknown (unknown [10.0.0.74])
	by moh1-ve3.go2.pl (Postfix) with SMTP
	for <linux-wireless@vger.kernel.org>; Sat, 22 Dec 2012 17:19:01 +0100 (CET)
Date: Sat, 22 Dec 2012 17:18:54 +0100
From: Tomasz Guszkowski <tsg@o2.pl>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@googlemail.com>
Subject: [PATCH] p54usb: add USB ID for T-Com Sinus 154 data II
Message-Id: <20121222171854.3ee183a36a12491da52553a9@o2.pl> (sfid-20121222_172021_856145_E1354547)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomasz Guszkowski <tsg@o2.pl>

Added USB ID for T-Com Sinus 154 data II. 

Signed-off-by: Tomasz Guszkowski <tsg@o2.pl>
---
I have tested the device in managed mode with no security, WEP 128 bit and WPA-PSK (TKIP) with firmware 2.13.1.0.lm87.arm (md5sum: 7d676323ac60d6e1a3b6d61e8c528248). No problems have been encountered.

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index e71c702..03a8bd3 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -52,6 +52,7 @@ static struct usb_device_id p54u_table[] = {
 	{USB_DEVICE(0x07aa, 0x001c)},	/* Corega CG-WLUSB2GT */
 	{USB_DEVICE(0x083a, 0x4501)},	/* Accton 802.11g WN4501 USB */
 	{USB_DEVICE(0x083a, 0x4502)},	/* Siemens Gigaset USB Adapter */
+	{USB_DEVICE(0x083a, 0x4503)},	/* T-Com Sinus 154 data II */
 	{USB_DEVICE(0x083a, 0x5501)},	/* Phillips CPWUA054 */
 	{USB_DEVICE(0x0846, 0x4200)},	/* Netgear WG121 */
 	{USB_DEVICE(0x0846, 0x4210)},	/* Netgear WG121 the second ? */
