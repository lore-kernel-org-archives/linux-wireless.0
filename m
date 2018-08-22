Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lorien.comfychair.org ([173.8.144.98]:56103 "EHLO
        lorien.comfychair.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbeHWCdB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Aug 2018 22:33:01 -0400
From: Danek Duvall <duvall@comfychair.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Danek Duvall <duvall@comfychair.org>
Subject: [PATCH 0/2] correct use of IEEE80211_VHT_CAP_RXSTBC_X
Date: Wed, 22 Aug 2018 16:01:03 -0700
Message-Id: <cover.1534978104.git.duvall@comfychair.org> (sfid-20180823_010615_700733_A79B434C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix two slightly different problematic usages of IEEE80211_VHT_CAP_RXSTBC_[1234]
as discussed on the list.

Danek Duvall (2):
  mac80211: correct use of IEEE80211_VHT_CAP_RXSTBC_X
  mac80211_hwsim: correct use of IEEE80211_VHT_CAP_RXSTBC_X

 drivers/net/wireless/mac80211_hwsim.c | 3 ---
 net/mac80211/main.c                   | 5 +----
 2 files changed, 1 insertion(+), 7 deletions(-)

-- 
2.11.0
