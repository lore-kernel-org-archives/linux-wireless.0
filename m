Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43230 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab0FLEeF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 00:34:05 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 05/24] ath9k_hw: add register definitions for the new ANI
Date: Sat, 12 Jun 2010 00:33:43 -0400
Message-Id: <1276317242-15540-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1276317242-15540-1-git-send-email-lrodriguez@atheros.com>
References: <1276317242-15540-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.h |    7 +++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |    8 ++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.h b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
index 81bf6e5..ce8bb00 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
@@ -114,6 +114,10 @@
 #define AR_PHY_FIND_SIG_FIRPWR    0x03FC0000
 #define AR_PHY_FIND_SIG_FIRPWR_S  18
 
+#define AR_PHY_FIND_SIG_LOW           0x9840
+#define AR_PHY_FIND_SIG_FIRSTEP_LOW   0x00000FC0L
+#define AR_PHY_FIND_SIG_FIRSTEP_LOW_S 6
+
 #define AR_PHY_AGC_CTL1                  0x985C
 #define AR_PHY_AGC_CTL1_COARSE_LOW       0x00007F80
 #define AR_PHY_AGC_CTL1_COARSE_LOW_S     7
@@ -325,6 +329,9 @@
 #define AR_PHY_EXT_CCA_CYCPWR_THR1_S    9
 #define AR_PHY_EXT_CCA_THRESH62         0x007F0000
 #define AR_PHY_EXT_CCA_THRESH62_S       16
+#define AR_PHY_EXT_TIMING5_CYCPWR_THR1   0x0000FE00L
+#define AR_PHY_EXT_TIMING5_CYCPWR_THR1_S 9
+
 #define AR_PHY_EXT_MINCCA_PWR           0xFF800000
 #define AR_PHY_EXT_MINCCA_PWR_S         23
 #define AR9280_PHY_EXT_MINCCA_PWR       0x01FF0000
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 676d3f1..265f59f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -149,6 +149,8 @@
 #define AR_PHY_EXT_CCA_THRESH62_S       16
 #define AR_PHY_EXT_MINCCA_PWR   0x01FF0000
 #define AR_PHY_EXT_MINCCA_PWR_S 16
+#define AR_PHY_EXT_CYCPWR_THR1 0x0000FE00L
+#define AR_PHY_EXT_CYCPWR_THR1_S 9
 #define AR_PHY_TIMING5_CYCPWR_THR1  0x000000FE
 #define AR_PHY_TIMING5_CYCPWR_THR1_S    1
 #define AR_PHY_TIMING5_CYCPWR_THR1_ENABLE  0x00000001
@@ -283,6 +285,12 @@
 #define AR_PHY_CCK_SPUR_MIT_CCK_SPUR_FREQ                           0x1ffffe00
 #define AR_PHY_CCK_SPUR_MIT_CCK_SPUR_FREQ_S                                  9
 
+#define AR_PHY_MRC_CCK_CTRL         (AR_AGC_BASE + 0x1d0)
+#define AR_PHY_MRC_CCK_ENABLE       0x00000001
+#define AR_PHY_MRC_CCK_ENABLE_S              0
+#define AR_PHY_MRC_CCK_MUX_REG      0x00000002
+#define AR_PHY_MRC_CCK_MUX_REG_S             1
+
 #define AR_PHY_RX_OCGAIN        (AR_AGC_BASE + 0x200)
 
 #define AR_PHY_CCA_NOM_VAL_9300_2GHZ          -110
-- 
1.6.3.3

