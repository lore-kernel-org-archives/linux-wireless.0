Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:49796 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaLSBBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 20:01:51 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@qca.qualcomm.com
Subject: [PATCH 0/5] ath9k patches
Date: Fri, 19 Dec 2014 06:33:54 +0530
Message-Id: <1418951039-12309-1-git-send-email-sujith@msujith.org> (sfid-20141219_020212_980257_15B180CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Pending patches for ath9k, rebased over wireless-drivers-next.
All of these are for -next.

The patch "ath9k: Fix no-ack frame status" depends on two commits
that have been merged in mac80211-next, so it needs to be pulled
into wireless-drivers-next.

Sujith

Miaoqing Pan (4):
  ath9k: Add HW IDs for QCA956x
  ath9k: Add initvals for QCA956x
  ath9k: Fix register definitions for QCA956x
  ath9k: Add QCA956x HW support

Sujith Manoharan (1):
  ath9k: Fix no-ack frame status

 drivers/net/wireless/ath/ath9k/ahb.c             |    4 +
 drivers/net/wireless/ath/ath9k/ani.c             |    3 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c   |   15 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c       |   61 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c      |   47 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h      |   19 +-
 drivers/net/wireless/ath/ath9k/ar956x_initvals.h | 1046 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c              |   41 +-
 drivers/net/wireless/ath/ath9k/hw.h              |    1 +
 drivers/net/wireless/ath/ath9k/mac.c             |    3 +-
 drivers/net/wireless/ath/ath9k/recv.c            |    3 +-
 drivers/net/wireless/ath/ath9k/reg.h             |    4 +
 drivers/net/wireless/ath/ath9k/xmit.c            |    9 +-
 13 files changed, 1212 insertions(+), 44 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar956x_initvals.h

-- 
2.1.3

