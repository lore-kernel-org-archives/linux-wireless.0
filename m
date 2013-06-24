Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:36952 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3FXGLi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 02:11:38 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] ath9k patches
Date: Mon, 24 Jun 2013 11:38:34 +0530
Message-Id: <1372054117-4626-1-git-send-email-sujith@msujith.org> (sfid-20130624_081141_399626_98A39017)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This series adds initial support for AR9462 2.1

Sujith Manoharan (3):
  ath9k: Add version macros for AR9462 2.1
  ath9k: Add initvals for AR9462 2.1
  ath9k: Program initvals for AR9462 2.1

 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |   59 +-
 .../net/wireless/ath/ath9k/ar9462_2p1_initvals.h   | 1774 ++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/reg.h               |   13 +-
 3 files changed, 1842 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9462_2p1_initvals.h

-- 
1.8.3.1

