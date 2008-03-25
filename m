Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42941 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712AbYCYXdm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 19:33:42 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/6] iwlwifi driver updates and mac80211 change
Date: Tue, 25 Mar 2008 16:33:35 -0700
Message-Id: <1206488021-4193-1-git-send-email-reinette.chatre@intel.com> (sfid-20080325_233350_743478_EF107C67)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains LED support as well as more organization
and cleanup for iwlwifi.

There is one patch specific to mac80211.

[PATCH 1/6] iwlwifi: Add led support
[PATCH 2/6] iwlwifi: rename iwl-4965-io.h to iwl-io.h
[PATCH 3/6] iwlwifi: improve NIC i/o debug prints information
[PATCH 4/6] mac80211: fix wrong Rx A-MPDU control via debugfs
[PATCH 5/6] iwlwifi: allow a default callback for ASYNC host commands
[PATCH 6/6] iwlwifi: iwl_priv - clean up in types of members

Thank you

Reinette
