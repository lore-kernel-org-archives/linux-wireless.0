Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:41641 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaIOFz0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:55:26 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 0/5] ath9k patches
Date: Mon, 15 Sep 2014 11:25:49 +0530
Message-Id: <1410760554-11844-1-git-send-email-sujith@msujith.org> (sfid-20140915_075530_391231_C7EDE145)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

MCC fixes for 3.18

Sujith Manoharan (5):
  ath9k: Remove unnecessary tbtt assignment
  ath9k: Check beaconing mode properly
  ath9k: Set offchannel state properly
  ath9k: Remove useless opmode check
  ath9k: Fix primary station configuration

 drivers/net/wireless/ath/ath9k/ath9k.h   |  4 +-
 drivers/net/wireless/ath/ath9k/channel.c |  8 ++--
 drivers/net/wireless/ath/ath9k/main.c    | 70 ++++++++++++++++++++------------
 drivers/net/wireless/ath/ath9k/recv.c    |  2 +-
 4 files changed, 51 insertions(+), 33 deletions(-)

-- 
2.1.0

