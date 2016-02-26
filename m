Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60515 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbcBZIKK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 03:10:10 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 00/13] disable hw peak cal for all ar9300 chips
Date: Fri, 26 Feb 2016 16:08:30 +0800
Message-Id: <1456474123-10520-1-git-send-email-miaoqing@codeaurora.org> (sfid-20160226_091015_672931_927FA66A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

HW peak detect calibration would fail for AR9300 chips and
we went for implementing the SW way of doing it instead of
HW doing the peak detect calibration.

Miaoqing Pan (13):
  ath9k: Update QCA953x initvals
  ath9k: Update AR9003 2.2 initvals
  ath9k: Update AR933x initvals
  ath9k: Update AR9340 initvals
  ath9k: Update AR9462 initvals
  ath9k: Update AR9485 initvals
  ath9k: Update AR955x initvals
  ath9k: Update AR9565 initvals
  ath9k: Update QCA956x initvals
  ath9k: Update AR9580 initvals
  ath9k: enable manual peak cal for all ar9300 chips
  ath9k: use AR_SREV_9003_PCOEM to identify PCOEM chips
  ath9k: set correct peak detect threshold

 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |  4 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      | 44 +++++++++-------------
 .../net/wireless/ath/ath9k/ar9330_1p1_initvals.h   |  4 +-
 .../net/wireless/ath/ath9k/ar9330_1p2_initvals.h   |  4 +-
 drivers/net/wireless/ath/ath9k/ar9340_initvals.h   |  4 +-
 .../net/wireless/ath/ath9k/ar9462_2p0_initvals.h   |  4 +-
 .../net/wireless/ath/ath9k/ar9462_2p1_initvals.h   |  4 +-
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h   |  4 +-
 drivers/net/wireless/ath/ath9k/ar953x_initvals.h   |  4 +-
 .../net/wireless/ath/ath9k/ar955x_1p0_initvals.h   |  2 +-
 .../net/wireless/ath/ath9k/ar9565_1p0_initvals.h   |  2 +-
 drivers/net/wireless/ath/ath9k/ar956x_initvals.h   |  2 +-
 .../net/wireless/ath/ath9k/ar9580_1p0_initvals.h   |  4 +-
 13 files changed, 39 insertions(+), 47 deletions(-)

-- 
1.9.1

