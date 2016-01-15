Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36867 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534AbcAOKSl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2016 05:18:41 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH v2 4/5] ath9k: fix inconsistent use of tab and space in indentation
Date: Fri, 15 Jan 2016 18:17:20 +0800
Message-Id: <1452853041-3674-5-git-send-email-miaoqing@codeaurora.org> (sfid-20160115_111845_185949_E50277A3)
In-Reply-To: <1452853041-3674-1-git-send-email-miaoqing@codeaurora.org>
References: <1452853041-3674-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

Minor changes for indenting.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 8b4561e..54ed2f7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -5485,11 +5485,11 @@ unsigned int ar9003_get_paprd_scale_factor(struct ath_hw *ah,
 			  AR9300_PAPRD_SCALE_1);
 	else {
 		if (chan->channel >= 5700)
-		return MS(le32_to_cpu(eep->modalHeader5G.papdRateMaskHt20),
-			  AR9300_PAPRD_SCALE_1);
+			return MS(le32_to_cpu(eep->modalHeader5G.papdRateMaskHt20),
+				  AR9300_PAPRD_SCALE_1);
 		else if (chan->channel >= 5400)
 			return MS(le32_to_cpu(eep->modalHeader5G.papdRateMaskHt40),
-				   AR9300_PAPRD_SCALE_2);
+				  AR9300_PAPRD_SCALE_2);
 		else
 			return MS(le32_to_cpu(eep->modalHeader5G.papdRateMaskHt40),
 				  AR9300_PAPRD_SCALE_1);
-- 
1.9.1

