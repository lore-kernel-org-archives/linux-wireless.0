Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:51882 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbaICDJP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 23:09:15 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 0/6] ath9k patches
Date: Wed,  3 Sep 2014 08:39:19 +0530
Message-Id: <1409713765-9358-1-git-send-email-sujith@msujith.org> (sfid-20140903_050939_490005_2D4453ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Pending patches for ath9k, rebased over 3.17-rc3.

Sujith Manoharan (6):
  ath9k: Fix beacon configuration for channel contexts
  ath9k: Fix beacons for managed mode
  ath9k: Fix panic when adding an AP interface
  ath9k: Fix NoA start time calculation
  ath9k: Fix offchannel duration calculation
  ath9k: Add CTWindow support

 drivers/net/wireless/ath/ath9k/ath9k.h   |  2 ++
 drivers/net/wireless/ath/ath9k/beacon.c  | 12 ++++++++++
 drivers/net/wireless/ath/ath9k/channel.c | 39 +++++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath9k/init.c    |  5 ++--
 drivers/net/wireless/ath/ath9k/main.c    | 10 ++++----
 5 files changed, 56 insertions(+), 12 deletions(-)

-- 
2.1.0

