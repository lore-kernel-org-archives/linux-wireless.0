Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7533 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab1G1RaA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 13:30:00 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 6/9] ath9k_hw: update PMU to improve ripple issue for AR9485
Date: Thu, 28 Jul 2011 22:59:33 +0530
Message-ID: <1311874176-27569-6-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110728_193002_442165_BF0DCB90)
In-Reply-To: <1311874176-27569-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1311874176-27569-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 6cfc9eb..c34bef1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3734,7 +3734,7 @@ static void ar9003_hw_internal_regulator_apply(struct ath_hw *ah)
 				}
 			} else {
 				reg_pmu_set = (5 << 1) | (7 << 4) |
-					      (1 << 8) | (2 << 14) |
+					      (2 << 8) | (2 << 14) |
 					      (6 << 17) | (1 << 20) |
 					      (3 << 24) | (1 << 28);
 			}
-- 
1.7.6

