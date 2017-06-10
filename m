Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60200 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751890AbdFJKwz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Jun 2017 06:52:55 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 10 Jun 2017 13:52:42 +0300
Message-Id: <20170610105246.26455-1-luca@coelho.fi> (sfid-20170610_125400_536067_F56E7FEC)
Subject: [PATCH 0/4] mac80211 patches from our internal tree 2017-06-10
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi Johannes,

Here are the pending mac80211 patches from our internal tree.  There
is a couple of bugfixes, a cleanup and a small improvement in tracing.
 
Please review.

Cheers,
Luca.


Emmanuel Grumbach (2):
  mac80211: don't send SMPS action frame in AP mode when not needed
  mac80211: add the action to the drv_ampdu_action tracepoint

Johannes Berg (2):
  mac80211: set bss_info data before configuring the channel
  mac80211: remove 5/10 MHz rate code from station MLME

 net/mac80211/cfg.c   |  2 ++
 net/mac80211/mlme.c  | 62 ++++++++++++++++++++++++++--------------------------
 net/mac80211/trace.h | 11 ++++++----
 3 files changed, 40 insertions(+), 35 deletions(-)

-- 
2.11.0
