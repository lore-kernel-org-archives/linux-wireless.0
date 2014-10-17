Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:44413 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaJQCJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2014 22:09:38 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 00/23] ath9k patches
Date: Fri, 17 Oct 2014 07:40:07 +0530
Message-Id: <1413511830-5536-1-git-send-email-sujith@msujith.org> (sfid-20141017_040951_519927_23735E7A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This is a rebase of all the pending ath9k patches over -wl,
meant for -next.

Sujith Manoharan (23):
  ath9k: Use sta_state() callback
  ath9k: Enable multi-channel properly
  ath9k: Process beacons properly
  ath9k: Unify reset API
  ath9k: Set ATH_OP_HW_RESET before HW reset
  ath9k: Disable beacon tasklet during reset
  ath9k: Clear NoA schedule properly
  ath9k: Use configurable timeout for flush
  ath9k: Fix MCC flush timeout
  ath9k: Fix offchannel flush timeout
  ath9k: Check for pending frames properly
  ath9k: Send AUTHORIZED event only for station mode
  ath9k: Fix address management
  ath9k: Add a function to check for an active GO
  ath9k: Check for active GO in mgd_prepare_tx()
  ath9k: Use a helper function for offchannel NoA
  ath9k: Use a helper function to set NoA
  ath9k: Use a helper function for bmiss
  ath9k: Fix RoC expiration
  ath9k: Send oneshot NoA
  ath9k: Fix HW scan abort
  ath9k: Improve flush() in mcc mode
  ath9k: Do not start BA when scanning

 drivers/net/wireless/ath/ath.h           |   2 +-
 drivers/net/wireless/ath/ath9k/ath9k.h   |  15 +-
 drivers/net/wireless/ath/ath9k/channel.c | 319 +++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/main.c    | 193 +++++++++++++++----
 drivers/net/wireless/ath/ath9k/tx99.c    |   4 +-
 5 files changed, 410 insertions(+), 123 deletions(-)

-- 
2.1.2

