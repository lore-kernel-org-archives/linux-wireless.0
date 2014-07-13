Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37264 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaGMJnt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 05:43:49 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so1183896wib.14
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2014 02:43:47 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/13] staging: vt6656: wcmd remove unneeded headers
Date: Sun, 13 Jul 2014 10:42:52 +0100
Message-Id: <1405244573-10978-12-git-send-email-tvboxspy@gmail.com> (sfid-20140713_114407_864335_C71952BC)
In-Reply-To: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com>
References: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index bb9500f..3c65228 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -40,14 +40,11 @@
 
 #include "device.h"
 #include "mac.h"
-#include "card.h"
 #include "wcmd.h"
 #include "power.h"
-#include "baseband.h"
 #include "usbpipe.h"
 #include "rxtx.h"
 #include "rf.h"
-#include "channel.h"
 
 static void vnt_cmd_timer_wait(struct vnt_private *priv, unsigned long msecs)
 {
-- 
1.9.1

