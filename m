Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49640 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759666AbaGXWez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 18:34:55 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so66095wiv.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 15:34:54 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/5] staging: vt6656: rf.h cleanup C_PWBT comments
Date: Thu, 24 Jul 2014 23:34:17 +0100
Message-Id: <1406241258-10025-4-git-send-email-tvboxspy@gmail.com> (sfid-20140725_003459_413531_AD3DA08F)
In-Reply-To: <1406241258-10025-1-git-send-email-tvboxspy@gmail.com>
References: <1406241258-10025-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/power.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/power.h b/drivers/staging/vt6656/power.h
index 256726f..7696b71 100644
--- a/drivers/staging/vt6656/power.h
+++ b/drivers/staging/vt6656/power.h
@@ -29,7 +29,7 @@
 #ifndef __POWER_H__
 #define __POWER_H__
 
-#define     C_PWBT                   1000      // micro sec. power up before TBTT
+#define C_PWBT	1000 /* micro sec. power up before TBTT */
 
 void vnt_disable_power_saving(struct vnt_private *);
 void vnt_enable_power_saving(struct vnt_private *, u16);
-- 
2.0.1

