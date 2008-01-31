Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:6441 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbYAaGKa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2008 01:10:30 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/5] iwlwifi driver updates
Date: Wed, 30 Jan 2008 22:05:11 -0800
Message-Id: <1201759516-28963-1-git-send-email-reinette.chatre@intel.com> (sfid-20080131_061033_377503_73F283A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please find a few iwlwifi updates. Patch 2/5 also touches
include/linux/ieee80211.h

[PATCH 1/5] iwlwifi: fix sparse warning in iwl 3945
[PATCH 2/5] iwlwifi: Fix MIMO PS mode
[PATCH 3/5] iwlwifi: remove ieee80211 types from iwl-helpers.h
[PATCH 4/5] iwlwifi: fix merge sequence: exit on error before state change
[PATCH 5/5] iwlwifi: fix merge error

Thank you

Reinette
