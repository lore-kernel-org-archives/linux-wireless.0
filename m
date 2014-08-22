Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:58082 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbaHVPJg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 11:09:36 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 0/8] ath9k patches
Date: Fri, 22 Aug 2014 20:39:23 +0530
Message-Id: <1408720171-9765-1-git-send-email-sujith@msujith.org> (sfid-20140822_170939_453552_F6BF8A63)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Pending patches for ath9k, rebased over 3.17-rc1.

Sujith

Sujith Manoharan (8):
  ath9k: Add a debug level for channel context
  ath9k: Handle failure to allocate HW timer
  ath9k: Move channel operations to channel.c
  ath9k: Add debug information
  ath9k: Add a config option for channel context
  ath9k: Move P2P functions to channel.c
  ath9k: Isolate P2P powersave routines
  ath9k: Isolate ath9k_use_chanctx module parameter

 drivers/net/wireless/ath/ath.h           |   1 +
 drivers/net/wireless/ath/ath9k/Kconfig   |   9 +
 drivers/net/wireless/ath/ath9k/ath9k.h   |  50 +++-
 drivers/net/wireless/ath/ath9k/channel.c | 412 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/init.c    |  70 +++---
 drivers/net/wireless/ath/ath9k/main.c    | 392 ++++++-----------------------
 drivers/net/wireless/ath/ath9k/recv.c    |   6 +-
 7 files changed, 586 insertions(+), 354 deletions(-)

-- 
2.0.4

