Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:52980 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760744AbaGRWBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 18:01:51 -0400
Received: by mail-we0-f172.google.com with SMTP id x48so5070303wes.17
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2014 15:01:50 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/5] staging: vt6656: remove unused macros
Date: Fri, 18 Jul 2014 23:00:56 +0100
Message-Id: <1405720856-2737-5-git-send-email-tvboxspy@gmail.com> (sfid-20140719_000156_047493_F5395B72)
In-Reply-To: <1405720856-2737-1-git-send-email-tvboxspy@gmail.com>
References: <1405720856-2737-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove macros start are unlikely to be reused

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index 92bf428..d53fcef 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -354,12 +354,6 @@
 #define MISCFIFO_KEYETRY0	32
 #define MISCFIFO_KEYENTRYSIZE	22
 
-// max time out delay time
-#define W_MAX_TIMEOUT       0xFFF0U     //
-
-// wait time within loop
-#define CB_DELAY_LOOP_WAIT  10          // 10ms
-
 #define MAC_REVISION_A0		0x00
 #define MAC_REVISION_A1		0x01
 
-- 
2.0.1

