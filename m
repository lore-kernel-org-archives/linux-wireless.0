Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54273 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802AbYHGFgB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 01:36:01 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 22:36:01 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18586.34577.713555.705987@localhost.localdomain> (sfid-20080807_073605_682125_AE09D04E)
Date: Thu, 7 Aug 2008 10:54:33 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 5/6] ath9k: More unused macros
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 9976406..82e71f9 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -634,11 +634,6 @@ enum ath9k_power_mode {
 	ATH9K_PM_UNDEFINED
 };
 
-#define HAL_ANTENNA_MIN_MODE  0
-#define HAL_ANTENNA_FIXED_A   1
-#define HAL_ANTENNA_FIXED_B   2
-#define HAL_ANTENNA_MAX_MODE  3
-
 struct ath9k_mib_stats {
 	u32 ackrcv_bad;
 	u32 rts_bad;
@@ -696,7 +691,6 @@ enum phytype {
 	PHY_FH,
 	PHY_OFDM,
 	PHY_HT,
-	PHY_MAX
 };
 #define PHY_CCK PHY_DS
 
-- 
1.5.6.5

