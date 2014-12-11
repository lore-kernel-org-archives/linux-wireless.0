Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:54914 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932937AbaLKBvi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 20:51:38 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 0/4] ath9k patches
Date: Thu, 11 Dec 2014 07:23:36 +0530
Message-Id: <1418262820-24856-1-git-send-email-sujith@msujith.org> (sfid-20141211_025143_089155_B218E17C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This series adds initial support for QCA956x.

Miaoqing Pan (4):
  ath9k: Add HW IDs for QCA956x
  ath9k: Add initvals for QCA956x
  ath9k: Fix register definitions for QCA956x
  ath9k: Add QCA956x HW support

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
 12 files changed, 1206 insertions(+), 41 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar956x_initvals.h

-- 
2.1.3

