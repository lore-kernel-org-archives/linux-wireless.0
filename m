Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:47226 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaGXWev (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 18:34:51 -0400
Received: by mail-wg0-f50.google.com with SMTP id n12so3483720wgh.9
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 15:34:50 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/5] staging: vt6656: dpc remove unneeded headers
Date: Thu, 24 Jul 2014 23:34:15 +0100
Message-Id: <1406241258-10025-2-git-send-email-tvboxspy@gmail.com> (sfid-20140725_003455_179879_112BD86E)
In-Reply-To: <1406241258-10025-1-git-send-email-tvboxspy@gmail.com>
References: <1406241258-10025-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/dpc.c | 3 ---
 drivers/staging/vt6656/dpc.h | 1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index f5fbb5f..07de768 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -37,12 +37,9 @@
 
 #include "dpc.h"
 #include "device.h"
-#include "rxtx.h"
-#include "card.h"
 #include "mac.h"
 #include "baseband.h"
 #include "rf.h"
-#include "usbpipe.h"
 
 int vnt_rx_data(struct vnt_private *priv, struct vnt_rcb *ptr_rcb,
 	unsigned long bytes_received)
diff --git a/drivers/staging/vt6656/dpc.h b/drivers/staging/vt6656/dpc.h
index d538aa3..fab195f 100644
--- a/drivers/staging/vt6656/dpc.h
+++ b/drivers/staging/vt6656/dpc.h
@@ -30,7 +30,6 @@
 #define __DPC_H__
 
 #include "device.h"
-#include "wcmd.h"
 
 int vnt_rx_data(struct vnt_private *, struct vnt_rcb *,
 	unsigned long bytes_recieved);
-- 
2.0.1

