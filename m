Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:53732 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbaICHzR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 03:55:17 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 0/5] ath9k patches
Date: Wed,  3 Sep 2014 13:25:24 +0530
Message-Id: <1409730929-30208-1-git-send-email-sujith@msujith.org> (sfid-20140903_095522_252916_380291C2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Various fixes for MCC.

Sujith Manoharan (5):
  ath9k: Fix RX filter calculation
  ath9k: Fix ath_startrecv()
  ath9k: Fix COMP_BAR filter
  ath9k: Fix RX filters in channel contexts
  ath9k: Fix interface accounting

 drivers/net/wireless/ath/ath9k/ath9k.h  |  7 ++++---
 drivers/net/wireless/ath/ath9k/beacon.c |  2 +-
 drivers/net/wireless/ath/ath9k/debug.c  |  2 +-
 drivers/net/wireless/ath/ath9k/main.c   | 20 +++++++++-----------
 drivers/net/wireless/ath/ath9k/recv.c   | 31 +++++++++++++++++++------------
 drivers/net/wireless/ath/ath9k/tx99.c   |  2 +-
 drivers/net/wireless/ath/ath9k/wow.c    |  2 +-
 7 files changed, 36 insertions(+), 30 deletions(-)

-- 
2.1.0

