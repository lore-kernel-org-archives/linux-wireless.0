Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:56766 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762806AbZEHM1B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 08:27:01 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 08 May 2009 05:27:02 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 1/2] ath9k: Remove bogus break after return
Date: Fri, 8 May 2009 17:54:50 -0700
Message-ID: <1241830491-10912-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 5879c73..9e1db85 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1617,11 +1617,9 @@ static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
 	switch (type) {
 	case ATH9K_RESET_POWER_ON:
 		return ath9k_hw_set_reset_power_on(ah);
-		break;
 	case ATH9K_RESET_WARM:
 	case ATH9K_RESET_COLD:
 		return ath9k_hw_set_reset(ah, type);
-		break;
 	default:
 		return false;
 	}
-- 
1.6.2.4

