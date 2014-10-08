Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:53903 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaJHDMe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 23:12:34 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v3 0/4] ath9k patches
Date: Wed,  8 Oct 2014 08:43:18 +0530
Message-Id: <1412738002-7636-1-git-send-email-sujith@msujith.org> (sfid-20141008_051238_278412_9476F4E5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

v3: Fix compilation error when TX99 is enabled.

Sujith Manoharan (4):
  ath9k: Fix sequence number assignment
  ath9k: Use sta_state() callback
  ath9k: Enable multi-channel properly
  ath9k: Process beacons properly

 drivers/net/wireless/ath/ath9k/ath9k.h   |  6 +++--
 drivers/net/wireless/ath/ath9k/beacon.c  | 12 ++--------
 drivers/net/wireless/ath/ath9k/channel.c | 11 ++++++---
 drivers/net/wireless/ath/ath9k/main.c    | 41 +++++++++++++++++++++++++-------
 drivers/net/wireless/ath/ath9k/tx99.c    |  8 ++++++-
 drivers/net/wireless/ath/ath9k/xmit.c    | 34 +++++++++++++++++---------
 6 files changed, 77 insertions(+), 35 deletions(-)

-- 
2.1.2

