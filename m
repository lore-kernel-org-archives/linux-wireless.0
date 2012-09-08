Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52077 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab2IHHbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2012 03:31:55 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20554.62320.883202.31640@gargle.gargle.HOWL> (sfid-20120908_093158_179618_53EB9BD3)
Date: Sat, 8 Sep 2012 12:57:44 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [RFC 0/7] ath9k patches
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds support for AR9565, which is a 1x1, 2G-only
chip with BT coexistence.

Sujith

Sujith Manoharan (7):
  ath9k_hw: Add version/revision macros for AR9565
  ath9k_hw: Add AR9565 initvals
  ath9k_hw: Add AR9565 HW support
  ath9k: Set correct max streams for AR9565
  ath9k_hw: Fix spur mitigation for AR9565
  ath9k_hw: Program correct PLL value for AR9565
  ath9k: Add PCI ID for AR9565

 drivers/net/wireless/ath/ath9k/ani.c               |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   10 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |   57 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |   86 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |   29 +-
 .../net/wireless/ath/ath9k/ar9565_1p0_initvals.h   | 1233 ++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/eeprom.h            |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c                |   42 +-
 drivers/net/wireless/ath/ath9k/hw.h                |    1 +
 drivers/net/wireless/ath/ath9k/init.c              |    2 +-
 drivers/net/wireless/ath/ath9k/pci.c               |    1 +
 drivers/net/wireless/ath/ath9k/reg.h               |    9 +
 13 files changed, 1422 insertions(+), 54 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h

-- 
1.7.12

