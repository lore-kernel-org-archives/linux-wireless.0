Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:35158 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaIJNpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:45:40 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 0/5] ath9k patches
Date: Wed, 10 Sep 2014 19:15:55 +0530
Message-Id: <1410356760-10901-1-git-send-email-sujith@msujith.org> (sfid-20140910_154543_120002_55AC5E0A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

MCC fixes for 3.18.

Sujith Manoharan (5):
  ath9k: Assign offchannel duration properly
  ath9k: Fix Notice of Absence issues
  ath9k: Clear offchannel duration properly
  ath9k: Fix channel switch time duration
  ath9k: Fix beacon miss handling

 drivers/net/wireless/ath/ath9k/ath9k.h   |   8 +-
 drivers/net/wireless/ath/ath9k/channel.c | 143 ++++++++++++++++++++++---------
 2 files changed, 109 insertions(+), 42 deletions(-)

-- 
2.1.0

