Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:48279 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711AbbCMDja (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 23:39:30 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Subject: [PATCH 0/4] ath9k patches
Date: Fri, 13 Mar 2015 09:13:06 +0530
Message-Id: <1426218190-19888-1-git-send-email-sujith@msujith.org> (sfid-20150313_043934_693429_1BC9CC5A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

More support for AIC, for -next.

Sujith Manoharan (4):
  ath9k: Handle MCI_STATE_AIC_CAL_RESET
  ath9k: Handle MCI_STATE_AIC_START
  ath9k: Handle MCI_STATE_AIC_CAL
  ath9k: Start AIC calibration during MCI reset

 drivers/net/wireless/ath/ath9k/ar9003_aic.c | 69 ++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/ar9003_aic.h |  3 ++
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 15 +++++++
 3 files changed, 85 insertions(+), 2 deletions(-)

-- 
2.3.1

