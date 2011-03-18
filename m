Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.cs.drexel.edu ([129.25.8.238]:53033 "EHLO
	mail.cs.drexel.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309Ab1CRIuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 04:50:04 -0400
Message-ID: <4D831ACF.5030506@cs.drexel.edu>
Date: Fri, 18 Mar 2011 04:41:51 -0400
From: Lee Trager <lt73@cs.drexel.edu>
MIME-Version: 1.0
To: Lee Trager <lt73@cs.drexel.edu>
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: [PATCH] ath3k: Add ASUS BT Support
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ASUS USB Bluetooth module that comes with my motherboard(ASUS P8P67
Pro) is simply a re-branded Atheros AR3011. This patch add support for
it in the driver

Signed-off-by: Lee Trager <lt73@cs.drexel.edu>

--- drivers/bluetooth/ath3k.c.old	2011-03-18 04:27:26.160161039 -0400
+++ drivers/bluetooth/ath3k.c	2011-03-18 04:29:05.853945455 -0400
@@ -36,9 +36,12 @@
 	/* Atheros AR3011 */
 	{ USB_DEVICE(0x0CF3, 0x3000) },

-	/* Atheros AR3011 with sflash firmware*/
+	/* Atheros AR3011 with sflash firmware */
 	{ USB_DEVICE(0x0CF3, 0x3002) },

+	/* ASUS branded Atheros AR3011 */
+	{ USB_DEVICE(0x0B05, 0x179C) },
+
 	/* Atheros AR9285 Malbec with sflash firmware */
 	{ USB_DEVICE(0x03F0, 0x311D) },
