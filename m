Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28171 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbYICUmZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 16:42:25 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] IBSS rate scaling fixes
Date: Wed,  3 Sep 2008 23:42:17 +0300
Message-Id: <1220474540-16737-1-git-send-email-tomas.winkler@intel.com> (sfid-20080903_224229_289765_C570B993)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series should fix fixed low rate (1Mbps) in IBSS. This is regression
from 2.6.26

I suggest merging patches 1 and 2 in 2.6.27, they are simple one-liners and provide 
the necessary fix for the regression.
Patch 3 provides more general fix and can go to 2.6.28

[PATCH 1/3] iwlwifi: rs - take a fresh set of supported rates at each cycle
[PATCH 2/3] mac80211: Fix low bit rate in IBSS
[PATCH 3/3] mac80211: Fix rate scale initialization in IBSS



---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

