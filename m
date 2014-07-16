Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:43681 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbaGPVXm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 17:23:42 -0400
Received: by mail-wg0-f45.google.com with SMTP id x12so1553673wgg.16
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 14:23:41 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 20/21] staging: vt6656: main_usb remove static function declarations.
Date: Wed, 16 Jul 2014 22:22:10 +0100
Message-Id: <1405545731-6082-20-git-send-email-tvboxspy@gmail.com> (sfid-20140716_232353_631259_769D88AE)
In-Reply-To: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
References: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All these functions are in visibility order.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 4bcdf8e..932382f 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -115,24 +115,6 @@ static const long frequency_list[] = {
 };
 */
 
-static int vt6656_probe(struct usb_interface *intf,
-			const struct usb_device_id *id);
-static void vt6656_disconnect(struct usb_interface *intf);
-
-#ifdef CONFIG_PM	/* Minimal support for suspend and resume */
-static int vt6656_suspend(struct usb_interface *intf, pm_message_t message);
-static int vt6656_resume(struct usb_interface *intf);
-#endif /* CONFIG_PM */
-
-static int device_init_registers(struct vnt_private *pDevice);
-
-static void device_free_tx_bufs(struct vnt_private *pDevice);
-static void device_free_rx_bufs(struct vnt_private *pDevice);
-static void device_free_int_bufs(struct vnt_private *pDevice);
-static bool device_alloc_bufs(struct vnt_private *pDevice);
-
-static void usb_device_reset(struct vnt_private *pDevice);
-
 static void device_set_options(struct vnt_private *priv)
 {
 	/* Set number of TX buffers */
-- 
2.0.1

