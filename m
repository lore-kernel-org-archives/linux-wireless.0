Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:40497 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755547AbXGaLyy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 07:54:54 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id EEF201804B256
	for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 12:54:48 +0100 (BST)
Received: from meerkat.home.warmcat.com (unknown [192.168.0.242])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id B8A97103A7
	for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:54:53 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by meerkat.home.warmcat.com (Postfix) with ESMTP id D172618D1DA2
	for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 12:54:46 +0100 (BST)
From: warmcat <andy@warmcat.com>
Subject: [PATCH] rt73usb-add-bluenext-148f-2573
To: linux-wireless@vger.kernel.org
Date: Tue, 31 Jul 2007 12:54:46 +0100
Message-ID: <20070731115446.5717.37617.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add device ID for cheapo BlueNext rt2571-based stick BN-WD54G

Signed-off-by: Andy Green <andy@warmcat.com>
---

 drivers/net/wireless/rt73usb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 3d838d1..82bb23c 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -1814,6 +1814,8 @@ static struct usb_device_id rt73usb_device_table[] = {
 	{ USB_DEVICE(0x050d, 0x905b), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Billionton */
 	{ USB_DEVICE(0x1631, 0xc019), USB_DEVICE_DATA(&rt73usb_ops) },
+	/* BlueNEXT */
+	{ USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* CNet */
 	{ USB_DEVICE(0x1371, 0x9022), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x1371, 0x9032), USB_DEVICE_DATA(&rt73usb_ops) },

