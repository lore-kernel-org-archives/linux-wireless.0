Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38734 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbYCJSlY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2008 14:41:24 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/7] iwlwifi driver updates
Date: Mon, 10 Mar 2008 11:35:05 -0700
Message-Id: <1205174112-18962-1-git-send-email-reinette.chatre@intel.com> (sfid-20080310_184128_935634_1A6BE3A8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Series contains LED support as a new feature, some fixes, as well as
changes to move to a shared library design.

[PATCH 1/7] iwlwifi: Add led support
[PATCH 2/7] iwlwifi: fix bug to show hidden APs during scan
[PATCH 3/7] iwlwifi: Use sta_bcast_id variable instead of BROADCAST_ID constant
[PATCH 4/7] iwlwifi: update copyright year
[PATCH 5/7] iwlwifi: Use eeprom form iwlcore
[PATCH 6/7] iwlwifi: Fix endianity in debug print
[PATCH 7/7] iwlwifi: change rate number to a constant


Reinette
