Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:54334 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab2DPT1Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 15:27:25 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 5/5] ath9k: remove unused PWRINC_*_TO_*_CHAIN defines
Date: Mon, 16 Apr 2012 22:22:50 +0200
Message-Id: <1334607770-26090-5-git-send-email-juhosg@openwrt.org> (sfid-20120416_212728_589273_A7A4BC7F)
In-Reply-To: <1334607770-26090-1-git-send-email-juhosg@openwrt.org>
References: <1334607770-26090-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index d254571..8bfd0ef 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -30,9 +30,6 @@
 #define CTL_11A_EXT (CTL_11A | EXT_ADDITIVE)
 #define CTL_11G_EXT (CTL_11G | EXT_ADDITIVE)
 #define CTL_11B_EXT (CTL_11B | EXT_ADDITIVE)
-#define PWRINCR_3_TO_1_CHAIN      9             /* 10*log(3)*2 */
-#define PWRINCR_3_TO_2_CHAIN      3             /* floor(10*log(3/2)*2) */
-#define PWRINCR_2_TO_1_CHAIN      6             /* 10*log(2)*2 */
 
 #define SUB_NUM_CTL_MODES_AT_5G_40 2    /* excluding HT40, EXT-OFDM */
 #define SUB_NUM_CTL_MODES_AT_2G_40 3    /* excluding HT40, EXT-OFDM, EXT-CCK */
-- 
1.7.2.1

