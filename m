Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:44725 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbbBPFRP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 00:17:15 -0500
Received: from [117.222.159.239] (port=14037 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YNE3W-000EUz-AG
	for linux-wireless@vger.kernel.org; Mon, 16 Feb 2015 00:17:15 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/9] ath9k patches
Date: Mon, 16 Feb 2015 10:49:52 +0530
Message-Id: <1424064001-7009-1-git-send-email-sujith@msujith.org> (sfid-20150216_061719_114778_424532A0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

ath9k patches for -next.

Sujith Manoharan (9):
  ath9k: Move MCI registers to reg_mci.h
  ath9k: Remove useless check in MCI reset
  ath9k: Add new MCI configuration parameters
  ath9k: Handle 2-ANT AR9565 in MCI reset
  ath9k: Fix MCI TX control
  ath9k: Setup MCI statistics properly
  ath9k: Prepare MCI interface correctly
  ath9k: Fix GPM initialization
  ath9k: Mute BT properly

 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 158 ++++++++++----
 drivers/net/wireless/ath/ath9k/ar9003_mci.h |  24 ++-
 drivers/net/wireless/ath/ath9k/hw.h         |   1 +
 drivers/net/wireless/ath/ath9k/mci.c        |   5 +-
 drivers/net/wireless/ath/ath9k/reg.h        | 275 ------------------------
 drivers/net/wireless/ath/ath9k/reg_mci.h    | 310 ++++++++++++++++++++++++++++
 6 files changed, 449 insertions(+), 324 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/reg_mci.h

-- 
2.3.0

