Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48282 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752124AbdLALvB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 06:51:01 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  1 Dec 2017 13:50:50 +0200
Message-Id: <20171201115053.29608-1-luca@coelho.fi> (sfid-20171201_125110_369424_598BC407)
Subject: [PATCH 0/3] cfg80211/mac80211 patches from our internal tree 2017-12-01
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here are a few patches from our internal tree, including the fix in
hwsim to prevent the test failure with Emmanuel's patch from my
previous series.

Please review.

Cheers,
Luca.


Adiel Aloni (1):
  mac80211_hwsim: enforce PS_MANUAL_POLL to be set after PS_ENABLED

David Spinadel (1):
  mac80211: Add MIC space only for TX key option

Johannes Berg (1):
  mac80211: don't warn on AID field without top two MSBs set

 drivers/net/wireless/mac80211_hwsim.c | 17 +++++++++++------
 include/net/mac80211.h                |  6 +++++-
 net/mac80211/key.c                    | 12 +++++++++---
 net/mac80211/mlme.c                   |  9 +++++----
 net/mac80211/tx.c                     |  4 +++-
 net/mac80211/wpa.c                    | 16 ++++++++++++----
 6 files changed, 45 insertions(+), 19 deletions(-)

-- 
2.15.0
