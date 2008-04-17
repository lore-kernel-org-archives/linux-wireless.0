Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6294 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686AbYDQXDl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 19:03:41 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/5] iwlwifi driver updates
Date: Thu, 17 Apr 2008 16:03:35 -0700
Message-Id: <1208473420-16550-1-git-send-email-reinette.chatre@intel.com> (sfid-20080418_000345_853044_0CDEF1A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series continues to stabilize the HW crypto work. There are
a few patches related to the architecture changes.
The final patch fixes debugging output.

[PATCH 1/5] iwlwifi: HW crypto acceleration fixes
[PATCH 2/5] iwlwifi: arranging aggregation actions
[PATCH 3/5] iwlwifi: define ANA_PLL values in iwl-csr.h
[PATCH 4/5] iwlwifi: export int iwl4965_set_pwr_src
[PATCH 5/5] iwlwifi: fix debug messages during scanning

Thank you

Reinette

