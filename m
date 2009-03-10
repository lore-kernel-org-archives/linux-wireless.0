Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34429 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238AbZCJVaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 17:30:12 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/6] iwlwifi HT driver updates
Date: Tue, 10 Mar 2009 14:35:06 -0700
Message-Id: <1236720912-6502-1-git-send-email-reinette.chatre@intel.com> (sfid-20090310_223016_237577_61FB268F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series includes HT performance improvement changes as well as
debugging infrastructure to support HT.

[PATCH 1/6] iwlwifi: add valid tx antenna information in rate_scale_table debugfs
[PATCH 2/6] iwlwifi: add rf information in rate_scale debugfs command
[PATCH 3/6] iwlwifi: remove un-necessary rs_tl_turn_on_agg() after agg enabled
[PATCH 4/6] iwlwifi: HT performance improvement changes
[PATCH 5/6] iwlwifi: check IEEE80211_TX_STAT_AMPDU for agg pkt
[PATCH 6/6] iwlwifi: verify the antenna selection when receive fixed rate debugfs


Thank you

Reinette

