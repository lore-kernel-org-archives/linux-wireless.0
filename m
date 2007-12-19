Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:53216 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754708AbXLSAqf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 19:46:35 -0500
Date: Wed, 19 Dec 2007 01:43:33 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: [PATCH] rt2x00: remove unused variable
Message-ID: <20071219014333.17c66bd1@morte> (sfid-20071219_004639_629712_6D4B418B)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove an unused variable. Note that the pipe obtained there isn't used as
well.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
Index: wireless-2.6/drivers/net/wireless/rt2x00/rt2x00usb.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ wireless-2.6/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -176,7 +176,6 @@ int rt2x00usb_write_tx_data(struct rt2x0
 	struct usb_device *usb_dev =
 	    interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
 	struct data_entry *entry = rt2x00_get_data_entry(ring);
-	int pipe = usb_sndbulkpipe(usb_dev, 1);
 	struct skb_desc *desc;
 	u32 length;
 
 
--
Ciao
Stefano
