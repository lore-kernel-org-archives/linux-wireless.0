Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:58148 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527AbaH0GhO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 02:37:14 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 0/4] ath9k patches
Date: Wed, 27 Aug 2014 12:07:21 +0530
Message-Id: <1409121445-11484-1-git-send-email-sujith@msujith.org> (sfid-20140827_083719_505925_F6BB8B98)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

More channel context fixes.
Pending patches: http://msujith.org/dir/patches/wl/Aug-27-2014/

Sujith

Sujith Manoharan (4):
  ath9k: Fix channel context transition
  ath9k: Disable fastcc for channel context mode
  ath9k: Add more debug statements for channel context
  ath9k: Fix channel context timer

 drivers/net/wireless/ath/ath9k/ath9k.h   |  10 +-
 drivers/net/wireless/ath/ath9k/channel.c | 158 ++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath9k/main.c    |   6 ++
 drivers/net/wireless/ath/ath9k/recv.c    |  12 +--
 4 files changed, 163 insertions(+), 23 deletions(-)

-- 
2.1.0

