Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:59315 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbaGUVlb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 17:41:31 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so7059223wgh.2
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2014 14:41:30 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/6] staging: vt6656: usbpipe remove unneeded comments
Date: Mon, 21 Jul 2014 22:40:46 +0100
Message-Id: <1405978847-2750-5-git-send-email-tvboxspy@gmail.com> (sfid-20140721_234144_893593_37613DA5)
In-Reply-To: <1405978847-2750-1-git-send-email-tvboxspy@gmail.com>
References: <1405978847-2750-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We know what the endpoints are

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index addaa65..aeef7ae 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -45,12 +45,6 @@
 #include "device.h"
 #include "usbpipe.h"
 
-//endpoint def
-//endpoint 0: control
-//endpoint 1: interrupt
-//endpoint 2: read bulk
-//endpoint 3: write bulk
-
 #define USB_CTL_WAIT   500 //ms
 
 int vnt_control_out(struct vnt_private *priv, u8 request, u16 value,
-- 
2.0.1

