Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:49825 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757805AbaEKIFT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2014 04:05:19 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@venema.h4ckr.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 05/10] ath9k: reorder or remove some includes
Date: Sun, 11 May 2014 10:04:35 +0200
Message-Id: <1399795480-7459-6-git-send-email-linux@rempel-privat.de> (sfid-20140511_100532_901253_755C5F05)
In-Reply-To: <1399795480-7459-1-git-send-email-linux@rempel-privat.de>
References: <1399795480-7459-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

to fix compile errors

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 2 +-
 drivers/net/wireless/ath/ath9k/hw.c    | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 33a2ae7..20dd344 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -23,8 +23,8 @@
 #include <linux/leds.h>
 #include <linux/completion.h>
 
-#include "debug.h"
 #include "common.h"
+#include "debug.h"
 #include "mci.h"
 #include "dfs.h"
 #include "spectral.h"
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index dffefee..2a8ed83 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -26,7 +26,6 @@
 #include "ar9003_mac.h"
 #include "ar9003_mci.h"
 #include "ar9003_phy.h"
-#include "debug.h"
 #include "ath9k.h"
 
 static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type);
-- 
1.9.1

