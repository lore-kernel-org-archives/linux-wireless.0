Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52532 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbcARBeK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2016 20:34:10 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, nbd@openwrt.org,
	Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH v3 0/5] ath9k bug fixes
Date: Mon, 18 Jan 2016 09:33:45 +0800
Message-Id: <1453080830-7616-1-git-send-email-miaoqing@codeaurora.org> (sfid-20160118_023413_866391_DDE4D26A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

ath9k bug fixes

Miaoqing Pan (5):
  ath9k: avoid ANI restart if no trigger
  ath9k: clean up ANI per-channel pointer checking
  ath9k: do not reset while BB panic(0x4000409) on ar9561
  ath9k: fix inconsistent use of tab and space in indentation
  ath9k: fix data bus error on ar9300 and ar9580

 drivers/net/wireless/ath/ath9k/ani.c           | 36 +++++++-------------------
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |  6 ++---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c    |  5 ++--
 drivers/net/wireless/ath/ath9k/hw.c            | 10 +++++++
 drivers/net/wireless/ath/ath9k/reg.h           |  4 ++-
 5 files changed, 28 insertions(+), 33 deletions(-)

-- 
1.9.1

