Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:58784 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbaHXPqL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Aug 2014 11:46:11 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 0/4] ath9k patches
Date: Sun, 24 Aug 2014 21:16:09 +0530
Message-Id: <1408895173-3732-1-git-send-email-sujith@msujith.org> (sfid-20140824_174614_615496_79A30C59)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

More channel context fixes.

All pending patches: http://msujith.org/dir/patches/wl/Aug-24-2014/

Sujith

Sujith Manoharan (4):
  ath9k: Add new chanctx events
  ath9k: Print the event/state in ath_chanctx_event
  ath9k: Fix interface limits
  ath9k: Fix channel context creation

 drivers/net/wireless/ath/ath9k/ath9k.h   |  5 +++
 drivers/net/wireless/ath/ath9k/channel.c | 63 ++++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/init.c    |  6 ++-
 drivers/net/wireless/ath/ath9k/main.c    |  2 +
 4 files changed, 71 insertions(+), 5 deletions(-)

-- 
2.0.4

