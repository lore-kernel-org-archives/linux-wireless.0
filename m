Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:52771 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbYCMAIr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 20:08:47 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/5] iwlwifi driver updates
Date: Wed, 12 Mar 2008 17:05:57 -0700
Message-Id: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com> (sfid-20080313_000851_040638_9032CF47)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series provides support for HW encryption for 4965.
TKIP in iwlwifi requires that for TX rekeying is computed in
software and also phase1 rekeying for RX is computed by 
software. mac80211 encryption infrastracture is utilized for
this.

[PATCH 1/5] mac80211: allows driver to request a Phase 2 key
[PATCH 2/5] mac80211: allows driver to request a Phase 1 RX key
[PATCH 3/5] iwlwifi-2.6: Cleans up set_key flow
[PATCH 4/5] iwlwifi-2.6: enables HW TKIP security
[PATCH 5/5] iwlwifi-2.6: RX status translation to old scheme

Thanks

Reinette
