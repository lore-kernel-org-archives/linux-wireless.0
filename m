Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:47096 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaGXWex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 18:34:53 -0400
Received: by mail-wg0-f47.google.com with SMTP id b13so3427283wgh.30
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 15:34:52 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/5] staging: vt6656: power.h remove dead macros
Date: Thu, 24 Jul 2014 23:34:16 +0100
Message-Id: <1406241258-10025-3-git-send-email-tvboxspy@gmail.com> (sfid-20140725_003457_382357_99EF9C8D)
In-Reply-To: <1406241258-10025-1-git-send-email-tvboxspy@gmail.com>
References: <1406241258-10025-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/power.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/vt6656/power.h b/drivers/staging/vt6656/power.h
index bd9de77..256726f 100644
--- a/drivers/staging/vt6656/power.h
+++ b/drivers/staging/vt6656/power.h
@@ -30,8 +30,6 @@
 #define __POWER_H__
 
 #define     C_PWBT                   1000      // micro sec. power up before TBTT
-#define     PS_FAST_INTERVAL         1         // Fast power saving listen interval
-#define     PS_MAX_INTERVAL          4         // MAX power saving listen interval
 
 void vnt_disable_power_saving(struct vnt_private *);
 void vnt_enable_power_saving(struct vnt_private *, u16);
-- 
2.0.1

