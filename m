Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57589 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600Ab1KVOqh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 09:46:37 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k_hw: cosmetic change in calibration debug log
Date: Tue, 22 Nov 2011 20:15:56 +0530
Message-ID: <1321973156-17427-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111122_154646_105703_680C3817)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 12a730d..e5407df 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -824,7 +824,7 @@ static void ar9003_hw_tx_iq_cal_post_proc(struct ath_hw *ah, bool is_reusable)
 						chan_info_tab[i] + offset);
 
 				ath_dbg(common, ATH_DBG_CALIBRATE,
-					"IQ RES[%d]=0x%x"
+					"IQ_RES[%d]=0x%x "
 					"IQ_RES[%d]=0x%x\n",
 					idx, iq_res[idx], idx + 1,
 					iq_res[idx + 1]);
-- 
1.7.0.4

