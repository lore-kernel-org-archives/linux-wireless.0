Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:40985 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3KGAQc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 19:16:32 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/13] ath9k pending patches
Date: Thu,  7 Nov 2013 05:41:47 +0530
Message-Id: <1383783120-22435-1-git-send-email-sujith@msujith.org> (sfid-20131107_011635_620142_034BC31B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pending patches for ath9k, rebased over master.
The MAINTAINERS file has also been updated with patch 13.

Sujith

Sujith Manoharan (13):
  ath9k: Add WB335 PCI IDs
  ath9k: Identify Killer Wireless cards
  ath9k: Fix TX99 config option usage
  ath9k: Fix wow.c compilation
  ath9k: Add a config option for WoW
  ath9k: Use CONFIG_ATH9K_WOW
  ath9k: Add an initialization routine for WoW
  ath9k: Add SERDES initvals for AR9462 2.1
  ath9k: Remove unused AR9462 2.0 initvals
  ath9k: Remove pcieSerDesWrite
  ath9k: Use correct PCIE initvals for AR9485
  ath9k: Apply CUS227 specific TX gain values
  ath9k: Update MAINTAINERS

 MAINTAINERS                                        |  19 +-
 drivers/net/wireless/ath/ath9k/Kconfig             |  10 +-
 drivers/net/wireless/ath/ath9k/Makefile            |   8 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |  43 +-
 drivers/net/wireless/ath/ath9k/ar9003_wow.c        | 422 +++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9340_initvals.h   | 102 ++++
 .../net/wireless/ath/ath9k/ar9462_2p0_initvals.h   |  14 -
 .../net/wireless/ath/ath9k/ar9462_2p1_initvals.h   |   7 +
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h   |  35 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |  53 +-
 drivers/net/wireless/ath/ath9k/debug.c             | 115 +---
 drivers/net/wireless/ath/ath9k/hw.c                |   1 -
 drivers/net/wireless/ath/ath9k/hw.h                |   5 +-
 drivers/net/wireless/ath/ath9k/init.c              |  23 +-
 drivers/net/wireless/ath/ath9k/main.c              | 468 +---------------
 drivers/net/wireless/ath/ath9k/pci.c               |  45 ++
 drivers/net/wireless/ath/ath9k/tx99.c              | 263 +++++++++
 drivers/net/wireless/ath/ath9k/wow.c               | 589 +++++++++------------
 drivers/net/wireless/ath/ath9k/xmit.c              |   4 +
 19 files changed, 1224 insertions(+), 1002 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_wow.c
 create mode 100644 drivers/net/wireless/ath/ath9k/tx99.c

-- 
1.8.4.2

