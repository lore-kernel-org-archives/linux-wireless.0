Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39338 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab0DZTEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 15:04:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 10/13] ath9k_hw: Fix typos in tx rate power level parsing for AR9003
Date: Mon, 26 Apr 2010 15:04:38 -0400
Message-Id: <1272308681-32396-11-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1272308681-32396-1-git-send-email-lrodriguez@atheros.com>
References: <1272308681-32396-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 79b0e28..25dd44d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -1200,7 +1200,7 @@ static u8 ar9003_hw_eeprom_get_tgt_pwr(struct ath_hw *ah,
 	u8 *pFreqBin;
 
 	if (is2GHz) {
-		numPiers = AR9300_NUM_5G_20_TARGET_POWERS;
+		numPiers = AR9300_NUM_2G_20_TARGET_POWERS;
 		pEepromTargetPwr = eep->calTargetPower2G;
 		pFreqBin = eep->calTarget_freqbin_2G;
 	} else {
@@ -1236,7 +1236,7 @@ static u8 ar9003_hw_eeprom_get_ht20_tgt_pwr(struct ath_hw *ah,
 	u8 *pFreqBin;
 
 	if (is2GHz) {
-		numPiers = AR9300_NUM_5G_20_TARGET_POWERS;
+		numPiers = AR9300_NUM_2G_20_TARGET_POWERS;
 		pEepromTargetPwr = eep->calTargetPower2GHT20;
 		pFreqBin = eep->calTarget_freqbin_2GHT20;
 	} else {
-- 
1.6.3.3

