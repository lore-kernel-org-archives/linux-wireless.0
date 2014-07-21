Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:61705 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbaGUVld (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 17:41:33 -0400
Received: by mail-wg0-f47.google.com with SMTP id b13so6920933wgh.18
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2014 14:41:31 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/6] staging: vt6656: usbpipe.c clean up USB_CTL_WAIT
Date: Mon, 21 Jul 2014 22:40:47 +0100
Message-Id: <1405978847-2750-6-git-send-email-tvboxspy@gmail.com> (sfid-20140721_234144_296703_214C79AF)
In-Reply-To: <1405978847-2750-1-git-send-email-tvboxspy@gmail.com>
References: <1405978847-2750-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index aeef7ae..7b050ba 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -45,7 +45,7 @@
 #include "device.h"
 #include "usbpipe.h"
 
-#define USB_CTL_WAIT   500 //ms
+#define USB_CTL_WAIT	500 /* ms */
 
 int vnt_control_out(struct vnt_private *priv, u8 request, u16 value,
 		u16 index, u16 length, u8 *buffer)
-- 
2.0.1

