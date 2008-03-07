Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:43419 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758071AbYCGBkT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 20:40:19 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/4] iwlwifi driver updates
Date: Thu,  6 Mar 2008 17:36:52 -0800
Message-Id: <1204853816-8964-1-git-send-email-reinette.chatre@intel.com> (sfid-20080307_014027_883878_BF2A63A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches are mostly cleanup. One patch fixes rate scaling in 3945.

[PATCH 1/4] iwlwifi: queue functions cleanup
[PATCH 2/4] iwlwifi: Fix 3945 rate scaling
[PATCH 3/4] iwlwifi: 3945 split tx_complete to command and packet function
[PATCH 4/4] iwlwifi: grab NIC access when disabling aggregations

Thanks

Reinette
