Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:47451 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab3HPWq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 18:46:58 -0400
Received: by mail-we0-f174.google.com with SMTP id q54so2125331wes.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Aug 2013 15:46:57 -0700 (PDT)
Message-ID: <1376693209.18777.4.camel@canaries32-MCP7A> (sfid-20130817_004704_731811_EE989959)
Subject: [PATCH 4/8] staging: vt6656: desc.h remove dead code typedef struct
 tagSRrvTime_atim.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 16 Aug 2013 23:46:49 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove dead structure tagSRrvTime_atim.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/staging/vt6656/desc.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/staging/vt6656/desc.h b/drivers/staging/vt6656/desc.h
index c2dec3b..dc089ac 100644
--- a/drivers/staging/vt6656/desc.h
+++ b/drivers/staging/vt6656/desc.h
@@ -144,17 +144,6 @@
 #define TD_FLAGS_PS_RETRY  0x04 /* check if PS STA frame re-transmit */
 
 /*
- * RsvTime buffer header
- */
-typedef struct tagSRrvTime_atim {
-    u16        wCTSTxRrvTime_ba;
-    u16        wTxRrvTime_a;
-} __attribute__ ((__packed__))
-SRrvTime_atim, *PSRrvTime_atim;
-
-typedef const SRrvTime_atim *PCSRrvTime_atim;
-
-/*
  * TX FIFO header
  */
 typedef struct tagSTxBufHead {
-- 
1.8.1.2



