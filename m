Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61413 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507AbaCRPGf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 11:06:35 -0400
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com
Subject: [PATCH v10 0/4] mac802111: channel context reservation
Date: Tue, 18 Mar 2014 17:03:02 +0200
Message-Id: <1395154986-13810-1-git-send-email-luciano.coelho@intel.com> (sfid-20140318_160638_288822_5C81F28F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One more small fix to a WARN_ON detected by Michal.  One change in
patch 3/4 (which also goes into 4/4).

--
Luca.

Luciano Coelho (4):
  mac80211: split ieee80211_vif_change_channel in two
  mac80211: refactor ieee80211_assign/unassign_vif_chanctx into one
  mac80211: implement chanctx reservation
  mac80211: allow reservation of a running chanctx

 include/net/mac80211.h     |   7 +
 net/mac80211/chan.c        | 367 +++++++++++++++++++++++++++++++++------------
 net/mac80211/ieee80211_i.h |  13 ++
 3 files changed, 294 insertions(+), 93 deletions(-)

-- 
1.9.0

