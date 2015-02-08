Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:52752 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbbBHNw6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2015 08:52:58 -0500
From: Dedy Lansky <dlansky@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dedy Lansky <dlansky@codeaurora.org>,
	linux-wireless@vger.kernel.org,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Subject: [PATCH v2 0/2] cfg80211: PBSS Basic Support
Date: Sun,  8 Feb 2015 15:52:02 +0200
Message-Id: <1423403524-22540-1-git-send-email-dlansky@codeaurora.org> (sfid-20150208_145305_061525_3930F03A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211: PBSS Basic Support

Dedy Lansky (2):
  cfg80211: add bss_type and privacy arguments in cfg80211_get_bss()
  cfg80211: add support for connecting to PBSS network type

 drivers/net/wireless/ath/ath10k/mac.c       |  3 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c  |  9 +--
 drivers/net/wireless/ath/wil6210/cfg80211.c |  2 +-
 drivers/net/wireless/cw1200/sta.c           |  4 +-
 drivers/net/wireless/libertas/cfg.c         |  6 +-
 drivers/net/wireless/mwifiex/cfg80211.c     |  8 +--
 include/net/cfg80211.h                      | 42 +++++++++++++-
 net/mac80211/ibss.c                         | 43 ++++-----------
 net/wireless/ibss.c                         |  2 +-
 net/wireless/mlme.c                         |  6 +-
 net/wireless/scan.c                         | 86 ++++++++++++++++++++++++++---
 net/wireless/sme.c                          | 22 ++++----
 net/wireless/trace.h                        | 24 ++++----
 13 files changed, 177 insertions(+), 80 deletions(-)

-- 
1.9.1

