Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:43699 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbbBEEtk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2015 23:49:40 -0500
Received: from [117.199.130.171] (port=13666 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YJENn-002ASp-8x
	for linux-wireless@vger.kernel.org; Wed, 04 Feb 2015 23:49:39 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/7] ath9k patches
Date: Thu,  5 Feb 2015 10:22:37 +0530
Message-Id: <1423111964-19626-1-git-send-email-sujith@msujith.org> (sfid-20150205_054944_208970_8F4BC374)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

ath9k patches for -next.

Sujith Manoharan (7):
  ath9k: Fix descriptors for keep-alive frame
  ath9k: Set keep awake timer
  ath9k: Add new MCI states
  ath9k: Check MCI PowerSave state
  ath9k: Handle additional patterns on wakeup
  ath9k: Clear additional WoW events
  ath9k: Restart TSF2 timers on wakeup

 drivers/net/wireless/ath/ath9k/ar9003_mci.h | 37 ++++++++++++++++-
 drivers/net/wireless/ath/ath9k/ar9003_wow.c | 61 +++++++++++++++++++++++------
 drivers/net/wireless/ath/ath9k/reg_wow.h    | 10 ++++-
 3 files changed, 94 insertions(+), 14 deletions(-)

-- 
2.2.2

