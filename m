Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:49963 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaKKHGA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 02:06:00 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 0/6] ath9k patches
Date: Tue, 11 Nov 2014 12:37:18 +0530
Message-Id: <1415689644-29693-1-git-send-email-sujith@msujith.org> (sfid-20141111_080609_934344_FE2C0CE5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Various fixes for -next.

Miaoqing Pan (3):
  ath9k: disable overriding AR9340 SLP32 registers
  ath9k: Use new QCA953x initvals
  ath9k: Fix high tx power in multi-chain mode

Sujith Manoharan (3):
  ath9k: Update QCA953x initvals
  ath9k: Fix LED configuration
  ath9k: Enable TSF2 for generic HW timers

 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c   |  22 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c       |  51 ++-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c      |  12 +-
 drivers/net/wireless/ath/ath9k/ar953x_initvals.h | 498 +++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/ath9k.h           |   1 +
 drivers/net/wireless/ath/ath9k/gpio.c            |   9 +-
 drivers/net/wireless/ath/ath9k/hw.c              |  23 +-
 drivers/net/wireless/ath/ath9k/hw.h              |   3 +
 drivers/net/wireless/ath/ath9k/init.c            |   3 +
 drivers/net/wireless/ath/ath9k/main.c            |   6 +-
 drivers/net/wireless/ath/ath9k/pci.c             |   4 +-
 drivers/net/wireless/ath/ath9k/reg.h             |   3 +
 12 files changed, 575 insertions(+), 60 deletions(-)

-- 
2.1.3

