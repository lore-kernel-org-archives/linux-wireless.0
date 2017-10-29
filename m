Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42200 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750915AbdJ2JvT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 05:51:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 29 Oct 2017 11:51:06 +0200
Message-Id: <20171029095111.17078-1-luca@coelho.fi> (sfid-20171029_105209_073254_93EC69C7)
Subject: [PATCH 0/5] cfg80211/mac80211 patches from our internal tree 2017-10-29
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here are some cfg80211/mac80211 patches from our internal tree.

Please review.

Cheers,
Luca.


Emmanuel Grumbach (1):
  mac80211: always update the PM state of a peer on MGMT / DATA frames

Luca Coelho (1):
  mac80211: remove BUG() when interface type is invalid

Sara Sharon (2):
  mac80211: call synchronize_net once in the restart flow
  mac80211: tear down RX aggregations first

Tova Mussai (1):
  cfg80211: IBSS: Add support for static WEP in driver for IBSS

 include/net/cfg80211.h |  5 +++++
 net/mac80211/agg-tx.c  |  3 ++-
 net/mac80211/ht.c      |  4 +++-
 net/mac80211/iface.c   |  2 +-
 net/mac80211/main.c    |  3 +++
 net/mac80211/rx.c      | 17 +++++------------
 net/mac80211/util.c    | 19 ++++++++++---------
 net/wireless/ibss.c    |  5 +++++
 8 files changed, 34 insertions(+), 24 deletions(-)

-- 
2.14.2
