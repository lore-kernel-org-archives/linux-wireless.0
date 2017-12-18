Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50916 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758126AbdLRKOM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Dec 2017 05:14:12 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 18 Dec 2017 12:14:03 +0200
Message-Id: <20171218101405.9330-1-luca@coelho.fi> (sfid-20171218_111422_287161_6008A308)
Subject: [PATCH 0/2] cfg80211/mac80211 patches from our internal tree 2017-12-18
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here are a couple of patches from our internal tree.

Cheers,
Luca.


Adiel Aloni (1):
  mac80211_hwsim: enable TODS BIT in null data frame

David Spinadel (1):
  nl80211: send deauth reason if locally generated

 drivers/net/wireless/mac80211_hwsim.c | 1 +
 net/wireless/nl80211.c                | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

-- 
2.15.1
