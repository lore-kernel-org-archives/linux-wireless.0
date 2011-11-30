Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44621 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232Ab1K3Uqg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 15:46:36 -0500
Received: by mail-lpp01m010-f46.google.com with SMTP id w12so290792lag.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 Nov 2011 12:46:35 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH v3 1/4] ath9k: trivial: cosmetic fix in calibration debug log
Date: Wed, 30 Nov 2011 15:46:17 -0500
Message-Id: <1322685980-8757-2-git-send-email-mar.kolya@gmail.com> (sfid-20111130_214640_007634_912F5C9A)
In-Reply-To: <1322685980-8757-1-git-send-email-mar.kolya@gmail.com>
References: <20111130201051.GC2477@tuxdriver.com>
 <1322685980-8757-1-git-send-email-mar.kolya@gmail.com>
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
index 12a730d..755c98e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -225,7 +225,7 @@ static void ar9003_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 			i);
 
 		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Orignal: Chn %diq_corr_meas = 0x%08x\n",
+			"Original: Chn %d iq_corr_meas = 0x%08x\n",
 			i, ah->totalIqCorrMeas[i]);
 
 		iqCorrNeg = 0;
-- 
1.7.4.1

