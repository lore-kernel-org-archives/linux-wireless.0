Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay02.solcon.nl ([212.45.32.108]:33185 "EHLO
	mailrelay02.solcon.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab2ENQut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 12:50:49 -0400
Message-ID: <4FB12E00.4050104@solcon.nl> (sfid-20120514_185053_064864_CA1F2BD0)
Date: Mon, 14 May 2012 18:08:32 +0200
From: Albert Pool <albertpool@solcon.nl>
MIME-Version: 1.0
To: IvDoorn@gmail.com, gwingerde@gmail.com, helmut.schaa@googlemail.com
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] rt2800usb: 2001:3c17 is an RT3370 device
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

D-Link DWA-123 rev A1

Signed-off-by: Albert Pool<albertpool@solcon.nl>
---
  drivers/net/wireless/rt2x00/rt2800usb.c |    3 ++-
  1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 262ee9e..6ee4051 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1070,6 +1070,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
  #ifdef CONFIG_RT2800USB_RT33XX
  	/* Belkin */
  	{ USB_DEVICE(0x050d, 0x945b) },
+	/* D-Link */
+	{ USB_DEVICE(0x2001, 0x3c17) },
  	/* Ralink */
  	{ USB_DEVICE(0x148f, 0x3370) },
  	{ USB_DEVICE(0x148f, 0x8070) },
@@ -1145,7 +1147,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
  	/* D-Link */
  	{ USB_DEVICE(0x07d1, 0x3c0b) },
  	{ USB_DEVICE(0x07d1, 0x3c17) },
-	{ USB_DEVICE(0x2001, 0x3c17) },
  	/* Edimax */
  	{ USB_DEVICE(0x7392, 0x4085) },
  	/* Encore */
-- 
1.7.9


