Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51117 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab1K1AWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 19:22:35 -0500
Received: by mail-vw0-f46.google.com with SMTP id fc26so3356107vbb.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Nov 2011 16:22:35 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH v2 1/4] ath9k: trivial: cosmetic fix in calibration debug log
Date: Sun, 27 Nov 2011 19:22:11 -0500
Message-Id: <1322439734-14520-2-git-send-email-mar.kolya@gmail.com> (sfid-20111128_012238_121831_3A8294EC)
In-Reply-To: <1322439734-14520-1-git-send-email-mar.kolya@gmail.com>
References: <1322439734-14520-1-git-send-email-mar.kolya@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Add missed space and change typo in calibration debugging log.

Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index 88279e3..157337f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -203,7 +203,7 @@ static void ar9002_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 			i);
 
 		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Orignal: Chn %diq_corr_meas = 0x%08x\n",
+			"Original: Chn %d iq_corr_meas = 0x%08x\n",
 			i, ah->totalIqCorrMeas[i]);
 
 		iqCorrNeg = 0;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 12a730d..4b3c70a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -225,7 +225,7 @@ static void ar9003_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 			i);
 
 		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Orignal: Chn %diq_corr_meas = 0x%08x\n",
+			"Original: Chn %diq_corr_meas = 0x%08x\n",
 			i, ah->totalIqCorrMeas[i]);
 
 		iqCorrNeg = 0;
-- 
1.7.4.1

