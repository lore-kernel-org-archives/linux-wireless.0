Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:25944 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab3BDLxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 06:53:24 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 0/2] 64-bit counters in the struct station_info
Date: Mon, 4 Feb 2013 13:53:10 +0200
Message-ID: <1359978792-7121-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130204_125328_262559_46D53650)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

patch 1 expands counters and patch 2 uses this 64-bit counters for
the ath6kl - only easy to find driver with 64-bit counters.

Vladimir Kondratiev (2):
  wireless: expand per-station byte counters to 64bit
  ath6kl: provide 64-bit per-station byte counters

 drivers/net/wireless/ath/ath6kl/cfg80211.c |    6 ++++--
 include/net/cfg80211.h                     |   12 ++++++++----
 include/uapi/linux/nl80211.h               |    4 ++++
 net/wireless/nl80211.c                     |   10 +++++++++-
 4 files changed, 25 insertions(+), 7 deletions(-)

-- 
1.7.10.4

