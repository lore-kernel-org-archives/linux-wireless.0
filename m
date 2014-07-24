Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:54166 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaGXWet (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 18:34:49 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so65405wib.2
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 15:34:48 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/5] staging: vt6656: dpc.h remove dead function prototypes
Date: Thu, 24 Jul 2014 23:34:14 +0100
Message-Id: <1406241258-10025-1-git-send-email-tvboxspy@gmail.com> (sfid-20140725_003453_874025_38A5B914)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing
RXvWorkItem
RXvFreeRCB

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/dpc.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/vt6656/dpc.h b/drivers/staging/vt6656/dpc.h
index 1df2ae8..d538aa3 100644
--- a/drivers/staging/vt6656/dpc.h
+++ b/drivers/staging/vt6656/dpc.h
@@ -32,10 +32,6 @@
 #include "device.h"
 #include "wcmd.h"
 
-void RXvWorkItem(struct work_struct *work);
-
-void RXvFreeRCB(struct vnt_rcb *pRCB, int bReAllocSkb);
-
 int vnt_rx_data(struct vnt_private *, struct vnt_rcb *,
 	unsigned long bytes_recieved);
 
-- 
2.0.1

