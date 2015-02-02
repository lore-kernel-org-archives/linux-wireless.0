Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:59838 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbbBBMsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 07:48:14 -0500
Received: from [117.216.55.194] (port=15247 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YIGQG-002djK-EC
	for linux-wireless@vger.kernel.org; Mon, 02 Feb 2015 07:48:13 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/6] ath9k patches
Date: Mon,  2 Feb 2015 18:21:07 +0530
Message-Id: <1422881473-24580-1-git-send-email-sujith@msujith.org> (sfid-20150202_134830_600514_C4F84CD2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

ath9k patches for -next.

Sujith Manoharan (6):
  ath9k: Add support for more WOW patterns
  ath9k: Register correct WOW details with mac80211
  ath9k: Fix issues with WoW enable
  ath9k: Program AR_WA correctly
  ath9k: Clear TSF2 properly
  ath9k: Choose correct rate for 2GHz channel

 drivers/net/wireless/ath/ath9k/ar9003_wow.c | 281 ++++++++++++++--------------
 drivers/net/wireless/ath/ath9k/hw.h         |   3 +-
 drivers/net/wireless/ath/ath9k/reg.h        |   2 +
 drivers/net/wireless/ath/ath9k/reg_wow.h    |  39 +++-
 drivers/net/wireless/ath/ath9k/wow.c        |  16 +-
 5 files changed, 200 insertions(+), 141 deletions(-)

-- 
2.2.2

