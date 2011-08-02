Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from AShevkov.infinet.ru ([91.191.225.92]:49318 "EHLO
	AShevkov.infinet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab1HBPkA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 11:40:00 -0400
From: Alex Hacker <hacker@epn.ru>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Alex Hacker <hacker@epn.ru>
Subject: [PATCH] ath9k: Misprint in ar9003_phy.h. Fix a misprint wich can cause incorrect calibration process.
Date: Tue,  2 Aug 2011 21:00:34 +0600
Message-Id: <1312297234-24166-1-git-send-email-hacker@epn.ru> (sfid-20110802_174003_783602_86850B10)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 6de3f0b..5c59042 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -850,7 +850,7 @@
 #define AR_PHY_TPC_11_B1         (AR_SM1_BASE + 0x220)
 #define AR_PHY_PDADC_TAB_1       (AR_SM1_BASE + 0x240)
 #define AR_PHY_TX_IQCAL_STATUS_B1   (AR_SM1_BASE + 0x48c)
-#define AR_PHY_TX_IQCAL_CORR_COEFF_B1(_i)    (AR_SM_BASE + 0x450 + ((_i) << 2))
+#define AR_PHY_TX_IQCAL_CORR_COEFF_B1(_i)    (AR_SM1_BASE + 0x450 + ((_i) << 2))
 
 /*
  * Channel 2 Register Map
-- 
1.7.4

