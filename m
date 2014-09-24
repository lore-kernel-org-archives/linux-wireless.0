Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:50750 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaIXGRn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 02:17:43 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 0/5] ath9k patches
Date: Wed, 24 Sep 2014 11:48:11 +0530
Message-Id: <1411539496-30595-1-git-send-email-sujith@msujith.org> (sfid-20140924_081753_963435_E4A717D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

MCC fixes for 3.18. This includes the two patches that were posted earlier.

Sujith Manoharan (5):
  ath9k: Cache BSS information
  ath9k: Fix p2p address management
  ath9k: Fix queue management
  ath9k: Use normal queues for offchannel frames
  ath9k: Fix offchannel queuing

 drivers/net/wireless/ath/ath9k/ath9k.h   |  6 ++++
 drivers/net/wireless/ath/ath9k/channel.c |  6 ++--
 drivers/net/wireless/ath/ath9k/main.c    | 49 +++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath9k/xmit.c    | 17 ++++-------
 4 files changed, 60 insertions(+), 18 deletions(-)

-- 
2.1.0

