Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44388 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750846AbdHRMeD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 08:34:03 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 18 Aug 2017 15:33:55 +0300
Message-Id: <20170818123357.19646-1-luca@coelho.fi> (sfid-20170818_143406_152709_9D4516D3)
Subject: [PATCH 0/2] mac80211 patches from our internal tree 2017-08-18
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Here are two pending mac80211 patches from our internal tree.

Please review.

Cheers,
Luca.


Avraham Stern (1):
  mac80211: flush hw_roc_start work before cancelling the ROC

Luca Coelho (1):
  mac80211: add documentation to ieee80211_rx_ba_offl()

 include/net/mac80211.h    | 8 +++++++-
 net/mac80211/agg-rx.c     | 4 ++--
 net/mac80211/offchannel.c | 2 ++
 3 files changed, 11 insertions(+), 3 deletions(-)

-- 
2.14.1
