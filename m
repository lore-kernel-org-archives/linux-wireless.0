Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36712 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbcAOKRj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2016 05:17:39 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH v2 0/5] ath9k bug fixes
Date: Fri, 15 Jan 2016 18:17:16 +0800
Message-Id: <1452853041-3674-1-git-send-email-miaoqing@codeaurora.org> (sfid-20160115_111749_789373_94F6A47C)
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

