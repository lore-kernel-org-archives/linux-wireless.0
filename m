Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17399 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbYDCXFq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 19:05:46 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/5] iwlwifi driver updates
Date: Thu,  3 Apr 2008 16:05:19 -0700
Message-Id: <1207263924-25385-1-git-send-email-reinette.chatre@intel.com> (sfid-20080404_000559_039526_DE581FC9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series continues the driver cleanup and reorganization.
It also includes a fix that ensures LED is initialized before upper
layers are notified that it can be used.
A second fix (fix rfkill memory error) fixes a slab corruption error.

[PATCH 1/5] iwlwifi: hw names cleanup
[PATCH 2/5] iwlwifi: move driver status inliners into iwl-core.h
[PATCH 3/5] iwlwifi: use ieee80211_frequency_to_channel
[PATCH 4/5] iwlwifi: ensure led registration complete as part of initialization
[PATCH 5/5] iwlwifi: fix rfkill memory error

Thanks

Reinette

