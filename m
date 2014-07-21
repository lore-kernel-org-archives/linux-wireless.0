Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:65009 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbaGUVla (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 17:41:30 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so7118032wgg.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2014 14:41:28 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/6] staging: vt6656: Remove ununsed macro URB_ASYNC_UNLINK
Date: Mon, 21 Jul 2014 22:40:45 +0100
Message-Id: <1405978847-2750-4-git-send-email-tvboxspy@gmail.com> (sfid-20140721_234143_711793_3C82FD57)
In-Reply-To: <1405978847-2750-1-git-send-email-tvboxspy@gmail.com>
References: <1405978847-2750-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index acb0608..addaa65 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -53,10 +53,6 @@
 
 #define USB_CTL_WAIT   500 //ms
 
-#ifndef URB_ASYNC_UNLINK
-#define URB_ASYNC_UNLINK    0
-#endif
-
 int vnt_control_out(struct vnt_private *priv, u8 request, u16 value,
 		u16 index, u16 length, u8 *buffer)
 {
-- 
2.0.1

