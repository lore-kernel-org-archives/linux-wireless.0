Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25958 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760503AbYCUU6b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2008 16:58:31 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/5] iwlwifi driver updates
Date: Fri, 21 Mar 2008 13:53:39 -0700
Message-Id: <1206132824-20558-1-git-send-email-reinette.chatre@intel.com> (sfid-20080321_205958_671412_5D572313)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains a few iwlwifi driver updates and one bugfix.

The fix "iwlwifi: fix __devexit_p points to __devexit functions" was
created based on a report for 2.6.25-rc6. Is it enough of a bugfix to
make it into 2.6.25?

Most changes in this series are cleanup and movement of code to
a central library.

[PATCH 1/5] MAINTAINERS: update iwlwifi git url
[PATCH 2/5] iwlwifi: fix __devexit_p points to __devexit functions
[PATCH 3/5] iwlwifi: iwl3945 remove 4965 commands
[PATCH 4/5] iwlwifi: rename iwl4965_get_channel_info to iwl_get_channel_info
[PATCH 5/5] iwlwifi: move host command sending functions to core module


Thanks

Reinette

