Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:37233 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbaJNEAD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2014 00:00:03 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 0/9] ath9k patches
Date: Tue, 14 Oct 2014 09:30:47 +0530
Message-Id: <1413259256-4808-1-git-send-email-sujith@msujith.org> (sfid-20141014_060028_959333_0F22963E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

MCC fixes for -next.

Sujith Manoharan (9):
  ath9k: Add a function to check for an active GO
  ath9k: Check for active GO in mgd_prepare_tx()
  ath9k: Use a helper function for offchannel NoA
  ath9k: Use a helper function to set NoA
  ath9k: Use a helper function for bmiss
  ath9k: Fix RoC expiration
  ath9k: Send oneshot NoA
  ath9k: Fix HW scan abort
  ath9k: Improve flush() in mcc mode

 drivers/net/wireless/ath/ath9k/ath9k.h   |   6 +-
 drivers/net/wireless/ath/ath9k/channel.c | 253 +++++++++++++++++++++----------
 drivers/net/wireless/ath/ath9k/main.c    |  87 +++++++++--
 3 files changed, 256 insertions(+), 90 deletions(-)

-- 
2.1.2

