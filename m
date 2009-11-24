Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44238 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757664AbZKXDaN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 22:30:13 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 0/8] iwmc3200wifi driver updates for 2.6.33
Date: Tue, 24 Nov 2009 11:33:25 +0800
Message-Id: <1259033613-25600-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here are some iwmc3200wifi driver updates for 2.6.33. We add the HT
support in this series.

[PATCH 1/8] MAINTAINERS: Add iwmc3200wifi entry
[PATCH 2/8] iwmc3200wifi: Parse HT channels EEPROM entries
[PATCH 3/8] iwmc3200wifi: Dont set the UMAC power limit when interface is down
[PATCH 4/8] iwmc3200wifi: Update wireless_mode with eeprom values
[PATCH 5/8] iwmc3200wifi: Set wireless mode correctly
[PATCH 6/8] iwmc3200wifi: 802.11n Tx aggregation support
[PATCH 7/8] iwmc3200wifi: Add stopped queue to debugfs
[PATCH 8/8] iwmc3200wifi: Remove tx concatenation option

Thanks,
-yi
