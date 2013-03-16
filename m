Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:41952 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961Ab3CPSUS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:20:18 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 25/25] rt2800: 5592: add more USB devices IDs
Date: Sat, 16 Mar 2013 19:19:53 +0100
Message-Id: <1363457993-15541-26-git-send-email-stf_xl@wp.pl> (sfid-20130316_192025_942541_DB37D605)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Reported-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 9b1ca67..f322820 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1247,6 +1247,15 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x148f, 0x5372) },
 #endif
 #ifdef CONFIG_RT2800USB_RT55XX
+	/* Arcadyan */
+	{ USB_DEVICE(0x043e, 0x7a32), .driver_info = 5592 },
+	/* AVM GmbH */
+	{ USB_DEVICE(0x057c, 0x8501), .driver_info = 5592 },
+	/* D-Link DWA-160-B2 */
+	{ USB_DEVICE(0x2001, 0x3c1a), .driver_info = 5592 },
+	/* Proware */
+	{ USB_DEVICE(0x043e, 0x7a13), .driver_info = 5592 },
+	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x5572), .driver_info = 5592 },
 #endif
 #ifdef CONFIG_RT2800USB_UNKNOWN
-- 
1.7.4.4

