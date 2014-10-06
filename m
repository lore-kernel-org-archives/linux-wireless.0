Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:60230 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaJFFsq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 01:48:46 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 0/6] ath9k patches
Date: Mon,  6 Oct 2014 11:19:33 +0530
Message-Id: <1412574579-22532-1-git-send-email-sujith@msujith.org> (sfid-20141006_074858_631502_321BD0FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Various fixes for -next.

Sujith Manoharan (6):
  ath: Fix smatch warning
  ath9k: Fix crash in MCC mode
  ath9k: Fix sequence number assignment
  ath9k: Use sta_state() callback
  ath9k: Enable multi-channel properly
  ath9k: Process beacons properly

 drivers/net/wireless/ath/ath9k/ath9k.h   |  6 +++--
 drivers/net/wireless/ath/ath9k/beacon.c  | 12 ++-------
 drivers/net/wireless/ath/ath9k/channel.c |  7 +++---
 drivers/net/wireless/ath/ath9k/main.c    | 43 +++++++++++++++++++++++++-------
 drivers/net/wireless/ath/ath9k/xmit.c    | 34 +++++++++++++++++--------
 drivers/net/wireless/ath/main.c          |  8 +++---
 6 files changed, 71 insertions(+), 39 deletions(-)

-- 
2.1.2

