Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:65214 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575AbZAULvV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 06:51:21 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 21 Jan 2009 03:51:21 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Fix typo in chip version check
Date: Wed, 21 Jan 2009 17:18:48 +0530
Message-ID: <1232538528-14289-1-git-send-email-vasanth@atheros.com> (sfid-20090121_125128_262337_C2BFD4FC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index ab15e55..baa7a7e 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -2255,7 +2255,7 @@ int ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 		return -EINVAL;
 	}
 
-	if (AR_SREV_9280(ah)) {
+	if (AR_SREV_9280_10_OR_LATER(ah)) {
 		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
 			    AR_GPIO_JTAG_DISABLE);
 
-- 
1.5.5.1

