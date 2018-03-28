Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36858 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750735AbeC1KYS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 06:24:18 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Mar 2018 13:24:08 +0300
Message-Id: <20180328102411.25677-1-luca@coelho.fi> (sfid-20180328_122422_807588_FF6A840C)
Subject: [PATCH v3 0/3] cfg80211/mac80211: ETSI requirements patches
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here are Haim's 3 patches for the new ETSI requirements that have been
pending due to fixes we had in our internl tree.  All the fixes have
been squased.

Please review and let me know if there are any issues.

Cheers,
Luca.

Haim Dreyfuss (3):
  cfg80211: read wmm rules from regulatory database
  mac80211: limit wmm params to comply with ETSI requirements
  cfg80211: Add API to allow querying regdb for wmm_rule

 include/net/cfg80211.h     |  28 +++++++
 include/net/regulatory.h   |  28 +++++++
 net/mac80211/cfg.c         |   3 +
 net/mac80211/ieee80211_i.h |   4 +
 net/mac80211/mlme.c        |   1 +
 net/mac80211/util.c        |  44 ++++++++++
 net/wireless/reg.c         | 204 +++++++++++++++++++++++++++++++++++++++++++--
 7 files changed, 303 insertions(+), 9 deletions(-)

-- 
2.16.2
