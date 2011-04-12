Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38772 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab1DLM5l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 08:57:41 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 05:57:16 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 12/22] ath9k_hw: Fix register offset AR_PHY_65NM_CH0_THERM for AR9340
Date: Tue, 12 Apr 2011 18:27:12 +0530
Message-ID: <1302613042-1754-13-git-send-email-vasanth@atheros.com>
In-Reply-To: <1302613042-1754-1-git-send-email-vasanth@atheros.com>
References: <1302613042-1754-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 8bdda2c..d133ee8 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -588,7 +588,7 @@
 #define AR_PHY_65NM_CH0_BIAS2       0x160c4
 #define AR_PHY_65NM_CH0_BIAS4       0x160cc
 #define AR_PHY_65NM_CH0_RXTX4       0x1610c
-#define AR_PHY_65NM_CH0_THERM       (AR_SREV_9485(ah) ? 0x1628c : 0x16290)
+#define AR_PHY_65NM_CH0_THERM       (AR_SREV_9300(ah) ? 0x16290 : 0x1628c)
 
 #define AR_PHY_65NM_CH0_THERM_LOCAL   0x80000000
 #define AR_PHY_65NM_CH0_THERM_LOCAL_S 31
-- 
1.7.0.4

