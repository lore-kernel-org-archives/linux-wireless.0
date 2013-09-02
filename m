Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:57240 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab3IBIas (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Sep 2013 04:30:48 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21028.19411.335796.192256@gargle.gargle.HOWL> (sfid-20130902_103051_716048_F6AC821C)
Date: Mon, 2 Sep 2013 13:56:59 +0530
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/8] ath9k patches
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This series adds various updates for AR9565.

v2 - Identify cards that don't support antenna diversity.

Sujith

Sujith Manoharan (8):
  ath9k: Update initvals for AR9565 1.0
  ath9k: Bypass EEPROM for diversity cap for AR9565
  ath9k: Fix antenna diversity init for AR9565
  ath9k: Use correct RX gain table for AR9565
  ath9k: Add support for AR9565 v1.0.1 LNA diversity
  ath9k: Enable antenna diversity for WB335
  ath9k: Identify CUS252 cards
  ath9k: Identify WB335 Antenna configuration

 drivers/net/wireless/ath/ath9k/antenna.c           |  36 +---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c        |   1 +
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |  22 ++-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |   2 +
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |   3 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |  23 ++-
 .../net/wireless/ath/ath9k/ar9565_1p0_initvals.h   |  17 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |  16 +-
 drivers/net/wireless/ath/ath9k/hw.h                |   1 +
 drivers/net/wireless/ath/ath9k/init.c              |  20 +++
 drivers/net/wireless/ath/ath9k/pci.c               | 190 ++++++++++++++++++++-
 11 files changed, 279 insertions(+), 52 deletions(-)

-- 
1.8.4

