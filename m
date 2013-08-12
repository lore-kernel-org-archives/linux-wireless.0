Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:38956 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab3HLJpV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 05:45:21 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 00/15] ath9k patches
Date: Mon, 12 Aug 2013 15:11:27 +0530
Message-Id: <1376300502-2741-1-git-send-email-sujith@msujith.org> (sfid-20130812_114524_924847_AE0B2ED0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Various fixes/cleanups for the RX path. Please review !

Sujith Manoharan (15):
  ath9k: Add MAX_AMSDU to supported HT capabilities
  ath9k: Use a subroutine to check for "mybeacon"
  ath9k: Fix phy error handling for DFS
  ath9k: Discard invalid frames early
  ath9k: Fix RX crypto processing
  ath9k: Fix TSF processing
  ath9k: Reorder some functions
  ath9k: Fix PHY error processing
  ath9k: Fix RX debug statistics
  ath9k: Fix RX packet counter
  ath9k: Fix RX beacon processing
  ath9k: Move the RX poll check to preprocess()
  ath9k: Handle corrupt descriptors properly
  ath9k: Fix error condition for corrupt descriptors
  ath9k: Remove unused function argument

 drivers/net/wireless/ath/ath9k/init.c |   3 +-
 drivers/net/wireless/ath/ath9k/recv.c | 364 ++++++++++++++++++----------------
 2 files changed, 200 insertions(+), 167 deletions(-)

-- 
1.8.3.4

