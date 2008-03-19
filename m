Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:54315 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161146AbYCSXtw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 19:49:52 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/7] iwlwifi and mac80211 updates (TKIP)
Date: Wed, 19 Mar 2008 16:41:39 -0700
Message-Id: <1205970106-22196-1-git-send-email-reinette.chatre@intel.com> (sfid-20080319_235024_728555_AF2B2651)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series reverts the previous TKIP related patches to mac80211
and iwlwifi and addresses the issues discussed on the mailing list.

[PATCH 1/7] tkip: revert TKIP patches
[PATCH 2/7] iwlwifi-2.6: Cleans up set_key flow
[PATCH 3/7] iwlwifi-2.6: RX status translation to old scheme
[PATCH 4/7] mac80211: get a TKIP phase key from skb
[PATCH 5/7] mac80211: allows driver to request a Phase 1 RX key
[PATCH 6/7] iwlwifi-2.6: enables HW TKIP encryption
[PATCH 7/7] iwlwifi-2.6: enables RX TKIP decryption in HW


Thanks

Reinette
