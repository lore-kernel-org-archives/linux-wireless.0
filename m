Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42770 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726516AbeHUJlM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 05:41:12 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 09:22:18 +0300
Message-Id: <20180821062220.29813-1-luca@coelho.fi> (sfid-20180821_082315_935373_1202BA23)
Subject: [PATCH 0/2] nl80211: a couple of fixes for WMM reporting
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here are a couple of fixes to small issues in the WMM reporting
implementation that were pending in our internal tree.

Please review.


Cheers,
Luca.

Haim Dreyfuss (2):
  nl80211: Fix nla_put_u8 to u16 for NL80211_WMMR_TXOP
  nl80211: Pass center frequency in KHZ instead of MHZ

 net/wireless/nl80211.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.18.0
