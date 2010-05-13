Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35259 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab0EMBPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 21:15:08 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/2] ath9k_hw: rename the ar9003_initvals.h to ar9003_2p0_initvals.h
Date: Wed, 12 May 2010 21:15:06 -0400
Message-Id: <1273713306-13789-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1273713306-13789-1-git-send-email-lrodriguez@atheros.com>
References: <1273713306-13789-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 .../{ar9003_initvals.h => ar9003_2p0_initvals.h}   |    6 +++---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)
 rename drivers/net/wireless/ath/ath9k/{ar9003_initvals.h => ar9003_2p0_initvals.h} (99%)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p0_initvals.h
similarity index 99%
rename from drivers/net/wireless/ath/ath9k/ar9003_initvals.h
rename to drivers/net/wireless/ath/ath9k/ar9003_2p0_initvals.h
index db019dd..f82a00d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p0_initvals.h
@@ -14,8 +14,8 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef INITVALS_9003_H
-#define INITVALS_9003_H
+#ifndef INITVALS_9003_2P0_H
+#define INITVALS_9003_2P0_H
 
 /* AR9003 2.0 */
 
@@ -1781,4 +1781,4 @@ static const u32 ar9300PciePhy_clkreq_disable_L1_2p0[][2] = {
 	{0x00004044, 0x00000000},
 };
 
-#endif /* INITVALS_9003_H */
+#endif /* INITVALS_9003_2P0_H */
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 3c4a446..863f61e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -16,7 +16,7 @@
 
 #include "hw.h"
 #include "ar9003_mac.h"
-#include "ar9003_initvals.h"
+#include "ar9003_2p0_initvals.h"
 #include "ar9003_2p2_initvals.h"
 
 /* General hardware code for the AR9003 hadware family */
-- 
1.6.3.3

