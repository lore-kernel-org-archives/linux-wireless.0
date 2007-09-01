Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:61850 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbXIAEgu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:36:50 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 6BA90618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:36:49 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 27/35] Remove unneeded braces, found by checkpatch.pl
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:36:49 -0400
Message-ID: <20070901043648.2498.86369.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index e469d66..fb4a45c 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -3407,11 +3407,10 @@ static int at76_submit_rx_urb(struct at76_priv *priv)
 	}
 
 exit:
-	if (ret < 0 && ret != -ENODEV) {
+	if (ret < 0 && ret != -ENODEV)
 		printk(KERN_ERR "%s: cannot submit rx urb - please unload the "
 		       "driver and/or power cycle the device\n",
 		       priv->netdev->name);
-	}
 
 	return ret;
 }
