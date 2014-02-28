Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:45646 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaCAAAF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 19:00:05 -0500
Received: by mail-wg0-f49.google.com with SMTP id x12so1123418wgg.8
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 16:00:03 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 7/9] staging: vt6656: clean up device_free_int_bufs.
Date: Fri, 28 Feb 2014 23:58:37 +0000
Message-Id: <1393631919-16182-7-git-send-email-tvboxspy@gmail.com> (sfid-20140301_010024_206165_A96EFC2F)
In-Reply-To: <1393631919-16182-1-git-send-email-tvboxspy@gmail.com>
References: <1393631919-16182-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clean up white and camel case.

Camel case change
pDevice -> priv

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 669e4f3..0475a20 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -801,9 +801,10 @@ static void usb_device_reset(struct vnt_private *pDevice)
 	return ;
 }
 
-static void device_free_int_bufs(struct vnt_private *pDevice)
+static void device_free_int_bufs(struct vnt_private *priv)
 {
-	kfree(pDevice->int_buf.data_buf);
+	kfree(priv->int_buf.data_buf);
+
 	return;
 }
 
-- 
1.9.0

