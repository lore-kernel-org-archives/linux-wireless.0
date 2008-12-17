Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26637 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbYLQI7l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 03:59:41 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 0/8] iwlwifi driver 12/17 updates
Date: Wed, 17 Dec 2008 16:52:26 +0800
Message-Id: <1229503954-30347-1-git-send-email-yi.zhu@intel.com> (sfid-20081217_095946_183812_362384D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

These are mostly cleanup except for patch 7 is targeted to address
a memory allocation problem in heavy rx.

[PATCH 1/8] iwlwifi: cleanup iwl-dev.h
[PATCH 2/8] iwlwifi: add line feed to printk
[PATCH 3/8] iwlwifi: update comments on the debug interface
[PATCH 4/8] iwlwifi: use type uint for module param debug
[PATCH 5/8] iwlwifi: remove useless goto
[PATCH 6/8] iwlwifi: use meaningful vars in _iwl_poll_bit()
[PATCH 7/8] iwlwifi: use GFP_KERNEL to allocate Rx SKB memory
[PATCH 8/8] iwlwifi: indicate txpower is off in sysfs

Thanks,
-yi
