Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:60774 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3LPKWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 05:22:41 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] ath9k patches
Date: Mon, 16 Dec 2013 15:47:39 +0530
Message-Id: <1387189061-505-1-git-send-email-sujith@msujith.org> (sfid-20131216_112244_515680_B521588D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Nothing major - the spectral code that was scattered around
has been collected in spectral.c and some minor cleanup in ath9k.h.
These apply on top of Felix's pending patches.

Sujith Manoharan (2):
  ath9k: Cleanup spectral scan code
  ath9k: Cleanup ath9k.h

 drivers/net/wireless/ath/ath9k/Makefile   |   4 +-
 drivers/net/wireless/ath/ath9k/ath9k.h    | 358 +++++---------------
 drivers/net/wireless/ath/ath9k/debug.c    | 311 +----------------
 drivers/net/wireless/ath/ath9k/init.c     |   2 +-
 drivers/net/wireless/ath/ath9k/recv.c     | 181 ----------
 drivers/net/wireless/ath/ath9k/spectral.c | 543 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/spectral.h | 212 ++++++++++++
 7 files changed, 840 insertions(+), 771 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/spectral.c
 create mode 100644 drivers/net/wireless/ath/ath9k/spectral.h

-- 
1.8.5.1

