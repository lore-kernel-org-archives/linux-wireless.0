Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:53106 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740AbaIECdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 22:33:00 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v3 00/11] ath9k patches
Date: Fri,  5 Sep 2014 08:03:08 +0530
Message-Id: <1409884399-32289-1-git-send-email-sujith@msujith.org> (sfid-20140905_043308_195828_F7161071)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Pending patches, meant for 3.18.

Sujith Manoharan (11):
  ath9k: Fix beacon configuration for channel contexts
  ath9k: Fix beacons for managed mode
  ath9k: Fix panic when adding an AP interface
  ath9k: Fix NoA start time calculation
  ath9k: Fix offchannel duration calculation
  ath9k: Add CTWindow support
  ath9k: Fix RX filter calculation
  ath9k: Fix ath_startrecv()
  ath9k: Fix COMP_BAR filter
  ath9k: Fix RX filters in channel contexts
  ath9k: Fix interface accounting

 drivers/net/wireless/ath/ath9k/ath9k.h   |  9 +++++---
 drivers/net/wireless/ath/ath9k/beacon.c  | 14 +++++++++++-
 drivers/net/wireless/ath/ath9k/channel.c | 39 +++++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath9k/debug.c   |  2 +-
 drivers/net/wireless/ath/ath9k/init.c    |  5 ++--
 drivers/net/wireless/ath/ath9k/main.c    | 30 ++++++++++++------------
 drivers/net/wireless/ath/ath9k/recv.c    | 31 +++++++++++++++----------
 drivers/net/wireless/ath/ath9k/tx99.c    |  2 +-
 drivers/net/wireless/ath/ath9k/wow.c     |  2 +-
 9 files changed, 92 insertions(+), 42 deletions(-)

-- 
2.1.0

