Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22867 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326Ab0BYGMQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 01:12:16 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 0/7] iwmc3200wifi driver 02/25 updates
Date: Thu, 25 Feb 2010 14:15:24 +0800
Message-Id: <1267078531-9817-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here are some iwmc3200wifi driver updates for .34 kernel. Please apply.

[PATCH 1/7] iwmc3200wifi: refuse to associate on unallowed channels
[PATCH 2/7] iwmc3200wifi: remove "_safe" for some list_for_each_entry usage
[PATCH 3/7] iwmc3200wifi: add ftrace event tracing support
[PATCH 4/7] iwmc3200wifi: protect rx_tickets and rx_packets[] lists
[PATCH 5/7] iwmc3200wifi: increase concatenated buffer
[PATCH 6/7] iwmc3200wifi: mark some pmksa functions static
[PATCH 7/7] iwmc3200wifi: typo fix and code cleanup

Thanks,
-yi
