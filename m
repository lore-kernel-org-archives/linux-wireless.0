Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27273 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098AbYC1Xdt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 19:33:49 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/4] mac80211 and iwlwifi driver updates
Date: Fri, 28 Mar 2008 16:33:31 -0700
Message-Id: <1206747215-10640-1-git-send-email-reinette.chatre@intel.com> (sfid-20080328_233351_188018_8690E42A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series eliminates conf_ht, adds more information to bss_conf, and
eliminates association from a beacon.

[PATCH 1/4] mac80211: eliminate conf_ht
[PATCH 2/4] iwlwifi: eliminate conf_ht
[PATCH 3/4] mac80211: add association capabilty and timing info into bss_conf
[PATCH 4/4] iwlwifi: Eliminate association from beacon

Thank you

Reinette
