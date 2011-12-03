Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33602 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab1LCDjl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 22:39:41 -0500
Received: by qcqz2 with SMTP id z2so593586qcq.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Dec 2011 19:39:40 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH v4 1/4] ath9k: trivial: cosmetic fix in calibration debug log
Date: Fri,  2 Dec 2011 22:39:14 -0500
Message-Id: <1322883557-14120-2-git-send-email-mar.kolya@gmail.com> (sfid-20111203_043953_278209_F49EDE7E)
In-Reply-To: <1322883557-14120-1-git-send-email-mar.kolya@gmail.com>
References: <1322883557-14120-1-git-send-email-mar.kolya@gmail.com>
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
index ddeba86..23b3a6c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -226,7 +226,7 @@ static void ar9003_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 			i);
 
 		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Orignal: Chn %diq_corr_meas = 0x%08x\n",
+			"Original: Chn %d iq_corr_meas = 0x%08x\n",
 			i, ah->totalIqCorrMeas[i]);
 
 		iqCorrNeg = 0;
-- 
1.7.4.1

