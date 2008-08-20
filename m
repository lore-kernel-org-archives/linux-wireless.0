Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3175 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbYHTCFE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 22:05:04 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 0/7] iwlwifi driver critical fix for 2.6.27
Date: Wed, 20 Aug 2008 10:01:26 +0800
Message-Id: <1219197693-21407-1-git-send-email-yi.zhu@intel.com> (sfid-20080820_040509_825434_C5A17D1A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Below patches are critical fix for iwlwifi driver on 2.6.27 (Linus GIT tip).
Please apply.

Thanks,
-yi

[PATCH 1/7] iwlwifi: W/A for the TSF correction in IBSS
[PATCH 2/7] iwlwifi: clean up hw scan handler
[PATCH 3/7] iwlwifi: allow consecutive scans in unassociated state
[PATCH 4/7] iwlwifi: align set channel with mac80211
[PATCH 5/7] iwlwifi: fix hidden ssid discovery in passive channels
[PATCH 6/7] iwlwifi: void full rxon on rx chain changes
[PATCH 7/7] iwlwifi: cleanup PCI register handling
