Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37123 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbaCMNdu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2014 09:33:50 -0400
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com
Subject: [PATCH v9 0/4] mac802111: channel context reservation
Date: Thu, 13 Mar 2014 15:33:37 +0200
Message-Id: <1394717621-5608-1-git-send-email-luciano.coelho@intel.com> (sfid-20140313_143353_461056_3E5304EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Another version with more rebase fixes.  Thanks Michal for all the reviews!

--
Cheers,
Luca.

Luciano Coelho (4):
  mac80211: split ieee80211_vif_change_channel in two
  mac80211: refactor ieee80211_assign/unassign_vif_chanctx into one
  mac80211: implement chanctx reservation
  mac80211: allow reservation of a running chanctx

 include/net/mac80211.h     |   7 +
 net/mac80211/chan.c        | 366 +++++++++++++++++++++++++++++++++------------
 net/mac80211/ieee80211_i.h |  13 ++
 3 files changed, 293 insertions(+), 93 deletions(-)

-- 
1.9.0

