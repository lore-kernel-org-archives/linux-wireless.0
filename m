Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:34960 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab3L3EVm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Dec 2013 23:21:42 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] ath9k patches
Date: Mon, 30 Dec 2013 09:46:32 +0530
Message-Id: <1388376996-614-1-git-send-email-sujith@msujith.org> (sfid-20131230_052147_490231_EA23E896)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

QCA9531 is a 2x2 2.4 GHz SoC platform. This series starts adding support
for it.

Sujith Manoharan (4):
  ath9k: Add version/revision macros for QCA9531
  ath9k: Assign macVersion for QCA9531
  ath9k: Add QCA953x initvals
  ath9k: Initialize QCA953x INI arrays

 drivers/net/wireless/ath/ath9k/ar9003_hw.c       |  48 +-
 drivers/net/wireless/ath/ath9k/ar953x_initvals.h | 718 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c              |   5 +
 drivers/net/wireless/ath/ath9k/hw.h              |   1 +
 drivers/net/wireless/ath/ath9k/reg.h             |  13 +-
 5 files changed, 783 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar953x_initvals.h

-- 
1.8.5.2

