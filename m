Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:39853 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaBGFAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 00:00:36 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 0/7] ath9k patches
Date: Fri,  7 Feb 2014 10:29:48 +0530
Message-Id: <1391749195-24381-1-git-send-email-sujith@msujith.org> (sfid-20140207_060051_421083_7ABE2A4D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This series updates the IQ calibration code, fixing various
issues. There are still some more issues to be addressed.

Sujith Manoharan (7):
  ath9k: Fix IQ cal post processing for SoC
  ath9k: Check explicitly for IQ calibration
  ath9k: Rename ar9003_hw_tx_iqcal_load_avg_2_passes
  ath9k: Fix magnitude/phase calculation
  ath9k: Modify IQ calibration for AR955x
  ath9k: Expand the IQ coefficient array
  ath9k: Calculate IQ-CAL median

 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 232 +++++++++++++++++++-------
 1 file changed, 173 insertions(+), 59 deletions(-)

-- 
1.8.5.3

