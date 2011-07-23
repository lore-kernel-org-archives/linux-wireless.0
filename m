Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46215 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab1GWIVd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 04:21:33 -0400
Received: by mail-pz0-f42.google.com with SMTP id 37so4899732pzk.1
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jul 2011 01:21:33 -0700 (PDT)
From: Huang Weiyi <weiyi.huang@gmail.com>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH] ath5k: remove duplicated #include
Date: Sat, 23 Jul 2011 16:21:16 +0800
Message-Id: <1311409276-3316-1-git-send-email-weiyi.huang@gmail.com> (sfid-20110723_102137_719442_59119E85)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove duplicated #include('s) in
  drivers/net/wireless/ath/ath5k/ahb.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ahb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
index ba682a0..705e0f0 100644
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -24,7 +24,6 @@
 #include "debug.h"
 #include "base.h"
 #include "reg.h"
-#include "debug.h"
 
 /* return bus cachesize in 4B word units */
 static void ath5k_ahb_read_cachesize(struct ath_common *common, int *csz)
-- 
1.5.6.4

